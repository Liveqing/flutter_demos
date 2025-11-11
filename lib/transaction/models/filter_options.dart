import 'package:equatable/equatable.dart';

enum TransactionCategory { service, food, transport, entertainment, shopping, other }

enum TimeFilter { oneWeek, oneMonth, threeMonths, sixMonths, custom }

class FilterOptions extends Equatable {
  final TransactionCategory? category;
  final TimeFilter timeFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;

  const FilterOptions({
    this.category,
    this.timeFilter = TimeFilter.oneWeek,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });

  @override
  List<Object?> get props => [
        category,
        timeFilter,
        startDate,
        endDate,
        minAmount,
        maxAmount,
      ];

  FilterOptions copyWith({
    TransactionCategory? category,
    TimeFilter? timeFilter,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) {
    return FilterOptions(
      category: category ?? this.category,
      timeFilter: timeFilter ?? this.timeFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool get hasFilters {
    return category != null ||
        timeFilter != TimeFilter.oneWeek ||
        startDate != null ||
        endDate != null ||
        minAmount != null ||
        maxAmount != null;
  }

  String getCategoryDisplayName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.service:
        return 'Service';
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  String getTimeFilterDisplayName(TimeFilter filter) {
    switch (filter) {
      case TimeFilter.oneWeek:
        return '1 week';
      case TimeFilter.oneMonth:
        return '1 month';
      case TimeFilter.threeMonths:
        return '3 months';
      case TimeFilter.sixMonths:
        return '6 months';
      case TimeFilter.custom:
        return 'Custom';
    }
  }
}
