![CI](https://github.com/codevalley/bioscope/workflows/CI/badge.svg)
# Personal Coach App

A Flutter-based personal coach app that helps users track their nutrition and wellness goals.

## Current Status

We are currently implementing the food capture interface, which allows users to take photos of their meals and receive nutrition information. The basic functionality is in place, but we are working on improving error handling, user experience, and secure storage of API keys.

## Getting Started

1. Ensure you have Flutter installed on your machine.
2. Clone this repository.
3. Run `flutter pub get` to fetch dependencies.
4. Update the `lib/config/api_config.dart` file with your API key.
5. Run `flutter run` to start the app on your connected device or emulator.

## Project Structure

This project follows clean architecture principles:

- `lib/domain`: Contains business logic and entities.
- `lib/data`: Handles data management and API interactions.
- `lib/presentation`: Manages UI components and state.
- `lib/application`: Handles app-wide configurations and dependency injection.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.