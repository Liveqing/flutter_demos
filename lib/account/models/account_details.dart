import 'package:equatable/equatable.dart';

class AccountDetails extends Equatable {
  final String name;
  final String iban;
  final String accountNumber;
  final String currency;
  final String accountOpeningDate;
  final double totalBalance;

  const AccountDetails({
    required this.name,
    required this.iban,
    required this.accountNumber,
    required this.currency,
    required this.accountOpeningDate,
    required this.totalBalance,
  });

  @override
  List<Object> get props => [
        name,
        iban,
        accountNumber,
        currency,
        accountOpeningDate,
        totalBalance,
      ];

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  String get formattedBalance {
    return totalBalance.toStringAsFixed(2);
  }

  String get formattedIban {
    // Format IBAN with spaces every 4 characters
    return iban.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    ).trim();
  }

  String get formattedAccountNumber {
    // Format account number with spaces every 4 characters
    return accountNumber.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    ).trim();
  }
}

