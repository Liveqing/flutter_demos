import 'package:equatable/equatable.dart';
import '../models/country.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class LoadCountries extends CountryEvent {}

class SearchCountries extends CountryEvent {
  final String query;

  const SearchCountries(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends CountryEvent {}

class SelectCountry extends CountryEvent {
  final Country country;

  const SelectCountry(this.country);

  @override
  List<Object> get props => [country];
}
