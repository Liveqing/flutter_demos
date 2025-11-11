import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/filter_options.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterOptions initialFilters;
  final Function(FilterOptions) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterOptions _currentFilters;
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _minAmountController.text = _currentFilters.minAmount?.toString() ?? '';
    _maxAmountController.text = _currentFilters.maxAmount?.toString() ?? '';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransactionCategories(),
                  const SizedBox(height: 24),
                  _buildTimeSection(),
                  const SizedBox(height: 24),
                  _buildAmountSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Transactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTransactionCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TransactionCategory?>(
              value: _currentFilters.category,
              isExpanded: true,
              hint: const Row(
                children: [
                  Icon(Icons.business_center_outlined, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    'Service',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ],
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: [
                const DropdownMenuItem<TransactionCategory?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.all_inclusive, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('All Categories'),
                    ],
                  ),
                ),
                ...TransactionCategory.values.map((category) {
                  return DropdownMenuItem<TransactionCategory?>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(category), color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(_currentFilters.getCategoryDisplayName(category)),
                      ],
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _currentFilters = _currentFilters.copyWith(category: value);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        // Time Filter Buttons
        Row(
          children: [
            _buildTimeFilterButton('1 week', TimeFilter.oneWeek),
            const SizedBox(width: 12),
            _buildTimeFilterButton('1 month', TimeFilter.oneMonth),
            const SizedBox(width: 12),
            _buildTimeFilterButton('3 months', TimeFilter.threeMonths),
            const SizedBox(width: 12),
            _buildTimeFilterButton('6 months', TimeFilter.sixMonths),
          ],
        ),
        const SizedBox(height: 16),
        
        // Date Range Pickers
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                'From',
                _currentFilters.startDate ?? DateTime(2025, 9, 29),
                (date) {
                  setState(() {
                    _currentFilters = _currentFilters.copyWith(startDate: date);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text('—', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                'To',
                _currentFilters.endDate ?? DateTime(2025, 10, 29),
                (date) {
                  setState(() {
                    _currentFilters = _currentFilters.copyWith(endDate: date);
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Date Selection Table
        _buildDateSelectionTable(),
      ],
    );
  }

  Widget _buildTimeFilterButton(String label, TimeFilter filter) {
    final isSelected = _currentFilters.timeFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(timeFilter: filter);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime selectedDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              '${selectedDate.day} ${_getMonthAbbr(selectedDate.month)} ${selectedDate.year}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4A90E2), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDateRow('23', 'September', '2022'),
          _buildDateRow('23', 'October', '2023', isSelected: true),
          _buildDateRow('23', 'November', '2024'),
        ],
      ),
    );
  }

  Widget _buildDateRow(String day, String month, String year, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4A90E2).withOpacity(0.1) : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF4A90E2) : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              month,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF4A90E2) : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            year,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount (AED)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Min',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _minAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '12,000',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF6B35)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      setState(() {
                        _currentFilters = _currentFilters.copyWith(minAmount: amount);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Max',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _maxAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '12,000,000',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF6B35)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      setState(() {
                        _currentFilters = _currentFilters.copyWith(maxAmount: amount);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentFilters = const FilterOptions();
                  _minAmountController.clear();
                  _maxAmountController.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(_currentFilters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.service:
        return Icons.business_center_outlined;
      case TransactionCategory.food:
        return Icons.restaurant_outlined;
      case TransactionCategory.transport:
        return Icons.directions_car_outlined;
      case TransactionCategory.entertainment:
        return Icons.movie_outlined;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
