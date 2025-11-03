# Flutter Demos Project

This project contains multiple Flutter demo pages showcasing different UI patterns and Bloc state management.

## Project Structure

```
lib/
├── account/                    # Account Management Feature
│   ├── bloc/
│   │   ├── account_bloc.dart   # Business logic for account
│   │   ├── account_event.dart  # Events for account
│   │   └── account_state.dart  # States for account
│   ├── models/
│   │   ├── account_info.dart   # Account data model
│   │   └── card_info.dart      # Card data model
│   ├── pages/
│   │   └── manage_page.dart    # Main account management page
│   └── repositories/
│       └── account_repository.dart  # Mock data repository
│
├── country/                    # Country Selection Feature
│   ├── bloc/
│   │   ├── country_bloc.dart   # Business logic for country
│   │   ├── country_event.dart  # Events for country
│   │   └── country_state.dart  # States for country
│   ├── models/
│   │   └── country.dart        # Country data model
│   ├── repositories/
│   │   └── country_repository.dart  # Mock data repository
│   └── widgets/
│       └── country_selection_bottom_sheet.dart  # Country selection UI
│
└── main.dart                   # App entry point
```

## Features

### 1. Account Management Page
- **Location**: `lib/account/pages/manage_page.dart`
- **Features**:
  - Display total balance
  - Show account information
  - Display credit card with visual design
  - Card management functionality
  - Uses Bloc pattern for state management
  - Mock API integration

**Design Highlights**:
- Gradient card design mimicking real credit cards
- VISA branding
- Masked card number with visibility toggle
- Card holder name and expiry date
- Circular avatar decoration

### 2. Country Selection BottomSheet
- **Location**: `lib/country/widgets/country_selection_bottom_sheet.dart`
- **Features**:
  - Search functionality
  - Popular countries section
  - Full country list
  - Country selection with state persistence
  - Clear search functionality
  - Uses Bloc pattern for state management
  - Mock API integration

## Technologies Used

- **Flutter**: UI Framework
- **Bloc Pattern**: State management (flutter_bloc ^8.1.6)
- **Equatable**: Value equality (equatable ^2.0.5)
- **Mock Repositories**: Simulated API calls with delays

## Running the Project

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>
```

## Code Organization

Each feature follows a clean architecture pattern:

1. **Models**: Data structures
2. **Repositories**: Data layer (mock API calls)
3. **Bloc**: Business logic layer
   - Events: User actions
   - States: UI states
   - Bloc: Event handlers and state emission
4. **Pages/Widgets**: Presentation layer

## Mock Data

All data is simulated using static data in repositories with artificial delays to mimic network calls:

- **Account**: AED 1,563,716.25
- **Account Number**: 3000 0910 1000 0001
- **Card**: VISA ending in 5631
- **Card Holder**: Steve Jobs
- **Expiry**: 10/26

## Future Enhancements

- Add more demo pages
- Implement real API integration
- Add unit and widget tests
- Add internationalization support
- Implement dark mode support

