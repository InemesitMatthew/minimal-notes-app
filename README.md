# Minimal Notes App with Isar Database

A simple notes-taking app built with **Flutter**, utilizing the **Isar database** for fast, local data storage. The app also includes light and dark mode themes, managed via **Provider** for state management. The project is structured in a modular way, making it easy to extend and maintain.

## Features

- **Create, Read, Update, and Delete Notes (CRUD)**: 
  You can add, view, edit, and delete notes. The app saves your notes using the Isar database, providing fast and efficient storage.

- **Dark/Light Mode Toggle**:
  The app supports both light and dark themes, which are managed by the `ThemeProvider`. Users can toggle between modes in the settings page. The theme choice is persisted using `SharedPreferences`, ensuring the user's preference remains after the app is closed and reopened.

- **Simple and Clean UI**:
  The UI is clean, using `Material` widgets, custom fonts (via Google Fonts), and a well-organized drawer for navigation.

- **Confirmation for Deleting Notes**: 
  A confirmation dialog is shown when attempting to delete a note, ensuring no accidental deletions.

- **Theme-Consistent Buttons**:
  Buttons like "Cancel" and "Delete" in dialogs are styled to follow the app’s current theme (light or dark), ensuring proper contrast and a unified look.

## Project Structure

```bash
lib/
│
├── components/         # UI Components like Drawer and Note Tiles
│   ├── drawer.dart
│   ├── drawer_tile.dart
│   ├── note_tile.dart
│   └── note_settings.dart
│
├── models/             # Data models and database handlers
│   ├── note.dart       # Note model (for Isar)
│   ├── note_db.dart    # NoteDb class handling Isar database operations
│   └── note.g.dart     # Auto-generated file for Isar schema (not manually edited)
│
├── pages/              # Pages (screens) of the app
│   ├── notes_page.dart # Main page displaying the list of notes
│   └── settings_page.dart # Settings page for toggling theme
│
├── theme/              # Theme-related files
│   ├── theme.dart      # Light and Dark mode definitions
│   └── theme_provider.dart # ThemeProvider class to handle theme toggling
│
└── main.dart           # Main entry point of the app
```

## Getting Started

### Prerequisites

- **Flutter SDK**: Ensure Flutter is installed. If not, follow the instructions on [Flutter's website](https://flutter.dev/docs/get-started/install).
- **Isar Database**: This project uses the Isar database for local storage. No special setup is required as it's integrated through Flutter packages.
- **Provider**: The state management solution used in this app is `Provider`.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/InemesitMatthew/minimal-notes-app
   cd minimal-notes-app
   ```

2. **Install Dependencies**:
   Ensure that all required packages are installed by running:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Run the app in a connected device or emulator:
   ```bash
   flutter run
   ```

### Running the Isar Database Generator

Before running the app, make sure to generate the Isar schema by running the following command:
```bash
flutter pub run build_runner build
```

This will generate the `note.g.dart` file for the `Note` model used by the Isar database.

## Usage

### Notes Page
- The app starts on the **Notes Page** where you can view a list of notes.
- Tap the **+ button** (floating action button) to add a new note.
- Tap the **3 dots** next to a note to update or delete it.
- Deleting a note will show a confirmation dialog with **themed buttons** to ensure clarity in both light and dark modes.

### Settings Page
- Open the **drawer** by tapping the top-left menu icon.
- In the drawer, select **Settings** to toggle between light and dark themes.
- **Theme Persistence**: The selected theme will now persist between app restarts using `SharedPreferences`.

## State Management

The app uses the **Provider** package for state management, with two main providers:
- **NoteDb Provider**: Manages CRUD operations for notes stored in the Isar database.
- **ThemeProvider**: Manages the app's light and dark mode states. The theme state is persisted using `SharedPreferences`.

### Key Classes

- **NoteDb**: Handles all database interactions using the Isar database.
- **Note**: Model class representing a single note. Automatically generates an ID and stores the note text.
- **ThemeProvider**: Manages the theme data and handles the toggle between light and dark mode.

## Dependencies

Here is a list of main dependencies:

- **Flutter**: UI framework for building natively compiled applications.
- **Isar**: High-performance, local database.
- **Provider**: For managing app state.
- **Google Fonts**: For custom fonts in the app.
- **SharedPreferences**: To persist theme settings across app restarts.

Make sure these dependencies are listed in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  isar: ^3.1.0+1
  path_provider: ^2.0.11
  google_fonts: ^3.0.1
  shared_preferences: ^2.0.15 # For theme persistence
  build_runner: ^2.3.3 # Required for generating Isar schema
  isar_generator: ^3.1.0
```

## Screenshots

> _Screenshots coming soon!_

## Future Enhancements

The following features could be implemented in future updates:

- **Note Sorting**: Add functionality to sort notes by creation date or alphabetically.
- **Note Search**: Allow users to search notes via a search bar.
- **Enhanced UI Animations**: Add animations for creating, updating, and deleting notes to improve the user experience.

## Contributing

Contributions are welcome! If you'd like to contribute, feel free to fork the repository and submit a pull request. Make sure to add descriptive commit messages and comments in your code.

---

## License

This project is open-source and available under the MIT License. You can see the [LICENSE](LICENSE) file for more details.

