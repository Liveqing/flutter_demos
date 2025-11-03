import 'package:equatable/equatable.dart';

abstract class AccountDetailsEvent extends Equatable {
  const AccountDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountDetails extends AccountDetailsEvent {}

class RefreshAccountDetails extends AccountDetailsEvent {}

