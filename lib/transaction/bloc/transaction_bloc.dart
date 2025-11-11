import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<LoadMoreTransactions>(_onLoadMoreTransactions);
    on<FilterTransactions>(_onFilterTransactions);
    on<SearchTransactions>(_onSearchTransactions);
    on<SelectAccount>(_onSelectAccount);
    on<LoadAccountOptions>(_onLoadAccountOptions);
  }

  void _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final accountOptions = await _repository.getAccountOptions();
      final transactions = await _repository.getTransactions();
      final hasMore = await _repository.hasMoreTransactions();

      emit(
        TransactionLoaded(
          transactions: transactions,
          accountOptions: accountOptions,
          selectedAccountId: accountOptions.isNotEmpty ? accountOptions.first.id : null,
          hasMore: hasMore,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to load transactions: ${e.toString()}'));
    }
  }

  void _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    final currentState = state as TransactionLoaded;
    try {
      final transactions = await _repository.getTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );
      final hasMore = await _repository.hasMoreTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );

      emit(
        currentState.copyWith(
          transactions: transactions,
          hasMore: hasMore,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to refresh transactions: ${e.toString()}'));
    }
  }

  void _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    final currentState = state as TransactionLoaded;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final moreTransactions = await _repository.getTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: nextPage,
      );

      final hasMore = await _repository.hasMoreTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: nextPage,
      );

      emit(
        currentState.copyWith(
          transactions: [...currentState.transactions, ...moreTransactions],
          hasMore: hasMore,
          isLoadingMore: false,
          currentPage: nextPage,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isLoadingMore: false,
        ),
      );
    }
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    final currentState = state as TransactionLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final transactions = await _repository.getTransactions(
        type: event.type,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );
      final hasMore = await _repository.hasMoreTransactions(
        type: event.type,
        accountId: currentState.selectedAccountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );

      emit(
        currentState.copyWith(
          transactions: transactions,
          currentFilter: event.type,
          hasMore: hasMore,
          isLoadingMore: false,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to filter transactions: ${e.toString()}'));
    }
  }

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    final currentState = state as TransactionLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final transactions = await _repository.getTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: event.query,
        page: 1,
      );
      final hasMore = await _repository.hasMoreTransactions(
        type: currentState.currentFilter,
        accountId: currentState.selectedAccountId,
        searchQuery: event.query,
        page: 1,
      );

      emit(
        currentState.copyWith(
          transactions: transactions,
          searchQuery: event.query,
          hasMore: hasMore,
          isLoadingMore: false,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to search transactions: ${e.toString()}'));
    }
  }

  void _onSelectAccount(
    SelectAccount event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    final currentState = state as TransactionLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final transactions = await _repository.getTransactions(
        type: currentState.currentFilter,
        accountId: event.accountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );
      final hasMore = await _repository.hasMoreTransactions(
        type: currentState.currentFilter,
        accountId: event.accountId,
        searchQuery: currentState.searchQuery,
        page: 1,
      );

      emit(
        currentState.copyWith(
          transactions: transactions,
          selectedAccountId: event.accountId,
          hasMore: hasMore,
          isLoadingMore: false,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to load account transactions: ${e.toString()}'));
    }
  }

  void _onLoadAccountOptions(
    LoadAccountOptions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is! TransactionLoaded) return;

    try {
      final accountOptions = await _repository.getAccountOptions();
      final currentState = state as TransactionLoaded;
      emit(currentState.copyWith(accountOptions: accountOptions));
    } catch (e) {
      emit(TransactionError('Failed to load account options: ${e.toString()}'));
    }
  }
}
