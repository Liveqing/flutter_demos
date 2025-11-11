import 'package:equatable/equatable.dart';
import '../models/transaction.dart';
import '../models/account_option.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final List<AccountOption> accountOptions;
  final TransactionType currentFilter;
  final String? searchQuery;
  final String? selectedAccountId;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;

  const TransactionLoaded({
    required this.transactions,
    required this.accountOptions,
    this.currentFilter = TransactionType.all,
    this.searchQuery,
    this.selectedAccountId,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    List<AccountOption>? accountOptions,
    TransactionType? currentFilter,
    String? searchQuery,
    String? selectedAccountId,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      accountOptions: accountOptions ?? this.accountOptions,
      currentFilter: currentFilter ?? this.currentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  AccountOption? get selectedAccount {
    if (selectedAccountId == null) return null;
    try {
      return accountOptions.firstWhere((account) => account.id == selectedAccountId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        transactions,
        accountOptions,
        currentFilter,
        searchQuery,
        selectedAccountId,
        hasMore,
        isLoadingMore,
        currentPage,
      ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
