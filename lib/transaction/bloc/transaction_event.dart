import 'package:equatable/equatable.dart';
import '../models/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class RefreshTransactions extends TransactionEvent {}

class LoadMoreTransactions extends TransactionEvent {}

class FilterTransactions extends TransactionEvent {
  final TransactionType type;

  const FilterTransactions(this.type);

  @override
  List<Object> get props => [type];
}

class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);

  @override
  List<Object> get props => [query];
}

class SelectAccount extends TransactionEvent {
  final String accountId;

  const SelectAccount(this.accountId);

  @override
  List<Object> get props => [accountId];
}

class LoadAccountOptions extends TransactionEvent {}
