import 'package:equatable/equatable.dart';
import '../models/account_details.dart';

abstract class AccountDetailsState extends Equatable {
  const AccountDetailsState();

  @override
  List<Object?> get props => [];
}

class AccountDetailsInitial extends AccountDetailsState {}

class AccountDetailsLoading extends AccountDetailsState {}

class AccountDetailsLoaded extends AccountDetailsState {
  final AccountDetails accountDetails;

  const AccountDetailsLoaded({required this.accountDetails});

  @override
  List<Object> get props => [accountDetails];
}

class AccountDetailsError extends AccountDetailsState {
  final String message;

  const AccountDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

