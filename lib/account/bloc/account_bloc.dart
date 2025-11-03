import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/account_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _repository;

  AccountBloc(this._repository) : super(AccountInitial()) {
    on<LoadAccountData>(_onLoadAccountData);
    on<RefreshAccountData>(_onRefreshAccountData);
  }

  void _onLoadAccountData(
    LoadAccountData event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final data = await _repository.getAccountData();
      emit(
        AccountLoaded(
          accountInfo: data['account'],
          cardInfo: data['card'],
        ),
      );
    } catch (e) {
      emit(AccountError('Failed to load account data: ${e.toString()}'));
    }
  }

  void _onRefreshAccountData(
    RefreshAccountData event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final data = await _repository.getAccountData();
      emit(
        AccountLoaded(
          accountInfo: data['account'],
          cardInfo: data['card'],
        ),
      );
    } catch (e) {
      emit(AccountError('Failed to refresh account data: ${e.toString()}'));
    }
  }
}

