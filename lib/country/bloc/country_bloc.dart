import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/country.dart';
import '../repositories/country_repository.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository _repository;
  Country? _selectedCountry;

  CountryBloc(this._repository) : super(CountryInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<SearchCountries>(_onSearchCountries);
    on<ClearSearch>(_onClearSearch);
    on<SelectCountry>(_onSelectCountry);
  }

  void _onLoadCountries(LoadCountries event, Emitter<CountryState> emit) async {
    emit(CountryLoading());
    try {
      final countries = await _repository.getAllCountries();
      final popularCountries = _repository.getPopularCountries();

      emit(
        CountryLoaded(
          allCountries: countries,
          filteredCountries: countries,
          popularCountries: popularCountries,
          selectedCountry: _selectedCountry,
        ),
      );
    } catch (e) {
      emit(CountryError('Failed to load countries: ${e.toString()}'));
    }
  }

  void _onSearchCountries(SearchCountries event, Emitter<CountryState> emit) {
    if (state is CountryLoaded) {
      final currentState = state as CountryLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredCountries: currentState.allCountries,
            searchQuery: '',
          ),
        );
      } else {
        final filteredCountries = currentState.allCountries
            .where(
              (country) =>
                  country.name.toLowerCase().contains(query) ||
                  country.code.toLowerCase().contains(query),
            )
            .toList();

        emit(
          currentState.copyWith(
            filteredCountries: filteredCountries,
            searchQuery: query,
          ),
        );
      }
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<CountryState> emit) {
    if (state is CountryLoaded) {
      final currentState = state as CountryLoaded;
      emit(
        currentState.copyWith(
          filteredCountries: currentState.allCountries,
          searchQuery: '',
        ),
      );
    }
  }

  void _onSelectCountry(SelectCountry event, Emitter<CountryState> emit) {
    _selectedCountry = event.country;
    if (state is CountryLoaded) {
      final currentState = state as CountryLoaded;
      emit(currentState.copyWith(selectedCountry: event.country));
    }
  }

  Country? get selectedCountry => _selectedCountry;
}
