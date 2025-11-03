import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/account_repository.dart';
import 'account_details_event.dart';
import 'account_details_state.dart';

class AccountDetailsBloc
    extends Bloc<AccountDetailsEvent, AccountDetailsState> {
  final AccountRepository _repository;

  AccountDetailsBloc(this._repository) : super(AccountDetailsInitial()) {
    on<LoadAccountDetails>(_onLoadAccountDetails);
    on<RefreshAccountDetails>(_onRefreshAccountDetails);
  }

  void _onLoadAccountDetails(
    LoadAccountDetails event,
    Emitter<AccountDetailsState> emit,
  ) async {
    emit(AccountDetailsLoading());
    try {
      final accountDetails = await _repository.getAccountDetails();
      emit(AccountDetailsLoaded(accountDetails: accountDetails));
    } catch (e) {
      emit(AccountDetailsError(
          'Failed to load account details: ${e.toString()}'));
    }
  }

  void _onRefreshAccountDetails(
    RefreshAccountDetails event,
    Emitter<AccountDetailsState> emit,
  ) async {
    try {
      final accountDetails = await _repository.getAccountDetails();
      emit(AccountDetailsLoaded(accountDetails: accountDetails));
    } catch (e) {
      emit(AccountDetailsError(
          'Failed to refresh account details: ${e.toString()}'));
    }
  }
}

