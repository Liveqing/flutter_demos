import 'package:equatable/equatable.dart';

enum TransactionType { all, credited, debited }

enum TransactionStatus { completed, failed, pending }

class Transaction extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final String currency;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? avatarText;
  final String? avatarEmoji;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.currency = 'AED',
    required this.date,
    required this.type,
    this.status = TransactionStatus.completed,
    this.avatarText,
    this.avatarEmoji,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        amount,
        currency,
        date,
        type,
        status,
        avatarText,
        avatarEmoji,
      ];

  String get formattedAmount {
    final prefix = type == TransactionType.credited ? '+' : '-';
    return '$prefix$currency ${amount.toStringAsFixed(2)}';
  }

  String get formattedTime {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${date.hour >= 12 ? 'pm' : 'am'}';
  }

  String get formattedDate {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get displayAvatar {
    if (avatarEmoji != null) return avatarEmoji!;
    if (avatarText != null) return avatarText!;
    return title.isNotEmpty ? title[0].toUpperCase() : 'T';
  }
}
