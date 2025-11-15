import '../models/transaction.dart';
import '../models/account_option.dart';

class TransactionRepository {
  static const Duration _delay = Duration(milliseconds: 800);

  // 模拟账户选项数据
  static const List<AccountOption> _accountOptions = [
    AccountOption(
      id: '1',
      name: 'Account123456789',
      accountNumber: '123456789',
      isSelected: true,
    ),
    AccountOption(
      id: '2',
      name: 'Cryptal8237',
      accountNumber: '8237',
    ),
    AccountOption(
      id: '3',
      name: 'Nickname',
      accountNumber: '9876',
    ),
  ];

  // 模拟交易数据
  static final List<Transaction> _allTransactions = [
    // Today
    Transaction(
      id: '1',
      title: 'Ella King',
      subtitle: 'Credited',
      amount: 172342.00,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: TransactionType.credited,
      progressStatus: TransactionProgressStatus.credited,
      avatarEmoji: '👩',
    ),
    Transaction(
      id: '2',
      title: 'Uber',
      subtitle: 'Payment',
      amount: 83.00,
      date: DateTime.now().subtract(const Duration(hours: 4)),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.inTransit,
      avatarEmoji: '🚗',
    ),
    Transaction(
      id: '3',
      title: 'Mark S.',
      subtitle: 'Failed',
      amount: 83.00,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      type: TransactionType.debited,
      status: TransactionStatus.failed,
      progressStatus: TransactionProgressStatus.initiated,
      avatarEmoji: '👨',
    ),

    // Sunday, 21 Sep
    Transaction(
      id: '4',
      title: 'Uber',
      subtitle: 'Payment',
      amount: 83.00,
      date: DateTime(2024, 9, 21, 20, 24),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.processed,
      avatarEmoji: '🚗',
    ),
    Transaction(
      id: '5',
      title: 'Uber',
      subtitle: 'Payment',
      amount: 83.00,
      date: DateTime(2024, 9, 21, 20, 24),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.credited,
      avatarEmoji: '🚗',
    ),
    Transaction(
      id: '6',
      title: 'Oliver',
      subtitle: 'Telecommunication Services',
      amount: 83.00,
      date: DateTime(2024, 9, 21, 20, 24),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.inTransit,
      avatarEmoji: '👨',
    ),
    Transaction(
      id: '7',
      title: 'Uber',
      subtitle: 'Payment',
      amount: 83.00,
      date: DateTime(2024, 9, 21, 20, 24),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.processed,
      avatarEmoji: '🚗',
    ),
    Transaction(
      id: '8',
      title: 'Uber',
      subtitle: 'Payment',
      amount: 83.00,
      date: DateTime(2024, 9, 21, 20, 24),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.initiated,
      avatarEmoji: '🚗',
    ),

    // More transactions for pagination
    Transaction(
      id: '9',
      title: 'Netflix',
      subtitle: 'Subscription',
      amount: 49.99,
      date: DateTime(2024, 9, 20, 15, 30),
      type: TransactionType.debited,
      progressStatus: TransactionProgressStatus.credited,
      avatarEmoji: '📺',
    ),
    Transaction(
      id: '10',
      title: 'Salary',
      subtitle: 'Monthly Salary',
      amount: 15000.00,
      date: DateTime(2024, 9, 20, 9, 0),
      type: TransactionType.credited,
      progressStatus: TransactionProgressStatus.credited,
      avatarEmoji: '💰',
    ),
  ];

  Future<List<AccountOption>> getAccountOptions() async {
    await Future.delayed(_delay);
    return List.from(_accountOptions);
  }

  Future<List<Transaction>> getTransactions({
    TransactionType type = TransactionType.all,
    String? accountId,
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(_delay);

    var filteredTransactions = List<Transaction>.from(_allTransactions);

    // Filter by type
    if (type != TransactionType.all) {
      filteredTransactions = filteredTransactions
          .where((transaction) => transaction.type == type)
          .toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredTransactions = filteredTransactions
          .where((transaction) =>
              transaction.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              transaction.subtitle.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= filteredTransactions.length) {
      return [];
    }

    return filteredTransactions.sublist(
      startIndex,
      endIndex > filteredTransactions.length
          ? filteredTransactions.length
          : endIndex,
    );
  }

  Future<bool> hasMoreTransactions({
    TransactionType type = TransactionType.all,
    String? accountId,
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
  }) async {
    final transactions = await getTransactions(
      type: type,
      accountId: accountId,
      searchQuery: searchQuery,
      page: page + 1,
      pageSize: pageSize,
    );
    return transactions.isNotEmpty;
  }
}
