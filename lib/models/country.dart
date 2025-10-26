import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String code;
  final String name;
  final String flag;

  const Country({required this.code, required this.name, required this.flag});

  @override
  List<Object> get props => [code, name, flag];

  @override
  String toString() => 'Country(code: $code, name: $name, flag: $flag)';
}
