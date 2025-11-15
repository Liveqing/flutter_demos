import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_status_progress.dart';

class TransactionDetailsPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsPage({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Basic Info
            _buildTransactionHeader(),
            const SizedBox(height: 32),
            
            // Status Progress
            _buildStatusSection(),
            const SizedBox(height: 32),
            
            // Transaction Details
            _buildDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: transaction.type == TransactionType.credited 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                transaction.displayAvatar,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == TransactionType.credited 
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Title and Subtitle
          Text(
            transaction.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            transaction.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Amount
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: transaction.type == TransactionType.credited 
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${transaction.formattedDate} • ${transaction.formattedTime}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        TransactionStatusProgress(
          currentStatus: TransactionProgressStatus.processed,
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailItem('Transaction ID', transaction.id),
              _buildDetailItem('Date', '${transaction.formattedDate} ${DateTime.now().year}'),
              _buildDetailItem('Time', transaction.formattedTime),
              _buildDetailItem('Amount', transaction.formattedAmount),
              _buildDetailItem('Currency', transaction.currency),
              _buildDetailItem('Type', _getTransactionTypeText()),
              _buildDetailItem('Status', _getStatusText(), isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionTypeText() {
    switch (transaction.type) {
      case TransactionType.credited:
        return 'Credit';
      case TransactionType.debited:
        return 'Debit';
      case TransactionType.all:
        return 'All';
    }
  }

  String _getStatusText() {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.pending:
        return 'Pending';
    }
  }
}
