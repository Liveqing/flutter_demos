import 'package:equatable/equatable.dart';
import '../models/country.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<Country> allCountries;
  final List<Country> filteredCountries;
  final List<Country> popularCountries;
  final String searchQuery;
  final Country? selectedCountry;

  const CountryLoaded({
    required this.allCountries,
    required this.filteredCountries,
    required this.popularCountries,
    this.searchQuery = '',
    this.selectedCountry,
  });

  CountryLoaded copyWith({
    List<Country>? allCountries,
    List<Country>? filteredCountries,
    List<Country>? popularCountries,
    String? searchQuery,
    Country? selectedCountry,
  }) {
    return CountryLoaded(
      allCountries: allCountries ?? this.allCountries,
      filteredCountries: filteredCountries ?? this.filteredCountries,
      popularCountries: popularCountries ?? this.popularCountries,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCountry: selectedCountry ?? this.selectedCountry,
    );
  }

  @override
  List<Object?> get props => [
    allCountries,
    filteredCountries,
    popularCountries,
    searchQuery,
    selectedCountry,
  ];
}

class CountryError extends CountryState {
  final String message;

  const CountryError(this.message);

  @override
  List<Object> get props => [message];
}
