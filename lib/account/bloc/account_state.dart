import 'package:equatable/equatable.dart';
import '../models/account_info.dart';
import '../models/card_info.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final AccountInfo accountInfo;
  final CardInfo cardInfo;

  const AccountLoaded({
    required this.accountInfo,
    required this.cardInfo,
  });

  @override
  List<Object> get props => [accountInfo, cardInfo];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}

