import 'package:equatable/equatable.dart';

class AccountOption extends Equatable {
  final String id;
  final String name;
  final String accountNumber;
  final bool isSelected;

  const AccountOption({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.isSelected = false,
  });

  @override
  List<Object> get props => [id, name, accountNumber, isSelected];

  AccountOption copyWith({
    String? id,
    String? name,
    String? accountNumber,
    bool? isSelected,
  }) {
    return AccountOption(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
