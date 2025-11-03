import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';
import '../bloc/country_event.dart';
import '../bloc/country_state.dart';
import '../models/country.dart';
import '../repositories/country_repository.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  final Country? selectedCountry;
  final Function(Country) onCountrySelected;

  const CountrySelectionBottomSheet({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<CountrySelectionBottomSheet> createState() =>
      _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState
    extends State<CountrySelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CountryBloc(CountryRepository());
        bloc.add(LoadCountries());
        if (widget.selectedCountry != null) {
          bloc.add(SelectCountry(widget.selectedCountry!));
        }
        return bloc;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildCountryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "What's your legal information ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Login',
              style: TextStyle(color: Color(0xFFFF6B35), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nationality',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<CountryBloc>().add(SearchCountries(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search nationality',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon:
                        state is CountryLoaded && state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              context.read<CountryBloc>().add(ClearSearch());
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryList() {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        if (state is CountryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CountryError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is CountryLoaded) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                if (state.searchQuery.isEmpty) ...[
                  _buildPopularSection(state),
                  const SizedBox(height: 20),
                  _buildAllSection(state),
                ] else ...[
                  _buildSearchResults(state),
                ],
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPopularSection(CountryLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...state.popularCountries.map(
          (country) => _buildCountryItem(country, state.selectedCountry),
        ),
      ],
    );
  }

  Widget _buildAllSection(CountryLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'All',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...state.allCountries.map(
          (country) => _buildCountryItem(country, state.selectedCountry),
        ),
      ],
    );
  }

  Widget _buildSearchResults(CountryLoaded state) {
    if (state.filteredCountries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No countries found',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: state.filteredCountries
          .map((country) => _buildCountryItem(country, state.selectedCountry))
          .toList(),
    );
  }

  Widget _buildCountryItem(Country country, Country? selectedCountry) {
    final isSelected = selectedCountry?.code == country.code;

    return GestureDetector(
      onTap: () {
        widget.onCountrySelected(country);
        Navigator.of(context).pop(country);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent, // 确保整个区域可点击
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF6B35)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 12, color: Color(0xFFFF6B35))
                  : null,
            ),
            const SizedBox(width: 12),
            Text(country.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                country.name,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
