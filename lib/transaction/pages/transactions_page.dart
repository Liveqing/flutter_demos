import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../repositories/transaction_repository.dart';
import '../models/transaction.dart';
import '../models/filter_options.dart';
import '../widgets/transaction_item.dart';
import '../widgets/account_selector.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'transaction_details_page.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionBloc(TransactionRepository())..add(LoadTransactions()),
      child: const TransactionsView(),
    );
  }
}

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final TextEditingController _searchController = TextEditingController();
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TransactionBloc>().add(LoadTransactions());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TransactionLoaded) {
            return Column(
              children: [
                // Search Bar
                _buildSearchBar(state),
                const SizedBox(height: 16),

                // Filter Tabs and Account Selector
                _buildFiltersAndAccount(state),
                const SizedBox(height: 16),

                // Transaction List
                Expanded(child: _buildTransactionList(state)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchBar(TransactionLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<TransactionBloc>().add(
                    SearchTransactions(value),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndAccount(TransactionLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Filter Tabs
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildFilterTab(
                    'All',
                    TransactionType.all,
                    state.currentFilter,
                  ),
                  _buildFilterTab(
                    'Credited',
                    TransactionType.credited,
                    state.currentFilter,
                  ),
                  _buildFilterTab(
                    'Debited',
                    TransactionType.debited,
                    state.currentFilter,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Account Selector
          AccountSelector(
            selectedAccount: state.selectedAccount,
            accounts: state.accountOptions,
            onAccountSelected: (accountId) {
              context.read<TransactionBloc>().add(SelectAccount(accountId));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    String title,
    TransactionType type,
    TransactionType currentFilter,
  ) {
    final isSelected = type == currentFilter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<TransactionBloc>().add(FilterTransactions(type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(TransactionLoaded state) {
    if (state.transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return EasyRefresh(
      controller: _refreshController,
      onRefresh: () async {
        context.read<TransactionBloc>().add(RefreshTransactions());
      },
      onLoad: state.hasMore
          ? () async {
              context.read<TransactionBloc>().add(LoadMoreTransactions());
            }
          : null,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _getItemCount(state),
        itemBuilder: (context, index) {
          return _buildListItem(context, state, index);
        },
      ),
    );
  }

  int _getItemCount(TransactionLoaded state) {
    final groupedTransactions = _groupTransactionsByDate(state.transactions);
    int count = 0;
    for (final group in groupedTransactions.entries) {
      count += 1; // Header
      count += group.value.length; // Transactions
    }
    if (state.isLoadingMore) {
      count += 1; // Loading indicator
    }
    return count;
  }

  Widget _buildListItem(
    BuildContext context,
    TransactionLoaded state,
    int index,
  ) {
    final groupedTransactions = _groupTransactionsByDate(state.transactions);
    int currentIndex = 0;

    for (final group in groupedTransactions.entries) {
      // Check if this is the header
      if (currentIndex == index) {
        return _buildDateHeader(group.key, group.value.first);
      }
      currentIndex++;

      // Check if this is one of the transactions in this group
      for (int i = 0; i < group.value.length; i++) {
        if (currentIndex == index) {
          return TransactionItem(
            transaction: group.value[i],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsPage(
                    transaction: group.value[i],
                  ),
                ),
              );
            },
          );
        }
        currentIndex++;
      }
    }

    // Loading indicator
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDateHeader(String dateKey, Transaction firstTransaction) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Text(
        dateKey,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      String dateKey;
      if (transaction.isToday) {
        dateKey = 'TODAY';
      } else {
        final parts = transaction.formattedDate.split(' ');
        if (parts.length >= 2) {
          dateKey = 'SUNDAY, ${parts[0]} ${parts[1]}';
        } else {
          dateKey = transaction.formattedDate;
        }
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        initialFilters: const FilterOptions(),
        onApplyFilters: (filters) {
          // Handle filter application
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Filters applied: ${filters.hasFilters ? 'Yes' : 'None'}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
