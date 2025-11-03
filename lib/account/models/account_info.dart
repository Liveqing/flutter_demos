import 'package:equatable/equatable.dart';

class AccountInfo extends Equatable {
  final String accountNumber;
  final double totalBalance;
  final String currency;

  const AccountInfo({
    required this.accountNumber,
    required this.totalBalance,
    this.currency = 'AED',
  });

  @override
  List<Object> get props => [accountNumber, totalBalance, currency];

  String get formattedBalance {
    return totalBalance.toStringAsFixed(2);
  }

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return accountNumber.replaceRange(
      0,
      accountNumber.length - 4,
      '*' * (accountNumber.length - 4),
    );
  }
}

