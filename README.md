# Sandwich Shop (Flutter)

A small Flutter demo app that simulates a sandwich order counter. This project demonstrates a compact UI with stateful controls, a simple style refactor, and a basic widget test.

---

## 1. Project Title and Description

### Title
Sandwich Shop (Flutter)

### Short description
A lightweight Flutter app to create simple sandwich orders: choose sandwich size, adjust quantity, and add notes. The app displays an order summary including emoji visualisation.

### Key features
- Select sandwich size/type (Footlong, Six-inch).
- Increase and decrease sandwich quantity with a configurable maximum.
- Add an order note (e.g., "no onions", "extra pickles").
- Reusable styled buttons and a centralized styles file.
- Basic widget test to confirm core UI boots.

---

## 2. Installation and Setup Instructions

### Prerequisites
- Supported OS: Windows, macOS, Linux
- Flutter SDK (stable channel recommended). Install from https://flutter.dev/docs/get-started/install
- Git
- An IDE such as Visual Studio Code or Android Studio (optional but recommended)
- Device/emulator to run the app

Recommended Flutter versions
- Flutter 3.x or later is recommended for Material 3 widgets (SegmentedButton). If you have an older SDK, some widgets may not exist.

### Clone the repository
```bash
git clone <repository-url>
cd sandwich_shop-main
```

### Install dependencies
```bash
flutter pub get
```

### Run the app
- List devices:
  flutter devices
- Run on a device/emulator:
  flutter run

To run on a specific device:
```bash
flutter run -d <device-id>
```

---

## 3. Usage Instructions

### Main flows
1. Launch app — you will see the AppBar titled "Sandwich Counter".
2. Choose sandwich size using the segmented control.
3. Use Add / Remove buttons to adjust quantity (respecting the maxQuantity limit).
4. Enter an order note in the text field.
5. The order summary displays the quantity, sandwich type, and a row of sandwich emojis.

### Notes and configuration
- `OrderScreen` accepts `maxQuantity` (default 10). To change it, instantiate `OrderScreen(maxQuantity: 20)` where used.
- Styles are centralized in `lib/views/app_styles.dart` (if present). Ensure package imports match the `name:` in pubspec.yaml or use relative imports.

### Running tests
```bash
flutter test
```
The included widget test pumps the App and verifies core UI elements (app bar title and Add button).

### Screenshots / GIFs
Add screenshots in the repo under `assets/screenshots/` and reference them here. Example markdown:
```markdown
![Main screen](assets/screenshots/main_screen.png)
```
To capture GIFs for usage, use a screen recorder and save under `assets/gifs/`, then reference similarly.

---

## 4. Project Structure and Technologies Used

Typical structure (relevant files):
- lib/
  - main.dart — app entry point and UI/state logic
  - views/
    - app_styles.dart — shared visual styles (TextStyle, colors, helpers)
  - (recommended) view_models/ — place to add view models
  - (recommended) repositories/ — data access abstractions
- test/
  - widget_test.dart — basic widget test
- pubspec.yaml — dependencies and metadata

Key technologies and packages:
- Flutter (Material)
- No external packages are required by default; add packages in pubspec.yaml if needed.

Development tools:
- Visual Studio Code or Android Studio
- Flutter CLI

---

## 5. Known Issues or Limitations

- SegmentedButton / ButtonSegment require a recent Flutter SDK (Material 3). If you see errors, either upgrade Flutter (`flutter upgrade`) or replace those widgets with ToggleButtons/DropdownButton.
- Dart does not support string multiplication like `'🥪' * quantity`. Use:
  ```dart
  List.filled(quantity, '🥪').join()
  ```
  to build repeated emoji strings.
- Package import mismatch: if you add `import 'package:sandwich_shop/views/app_styles.dart';` ensure the `name:` in pubspec.yaml is `sandwich_shop`. Otherwise use a relative import `import 'views/app_styles.dart';`.
- The UI and logic are intentionally simple; for larger apps move business logic into view models and add persistent storage if required.

Planned improvements
- Add persistent orders storage (local DB or cloud).
- Add more sandwich customization options (toppings, bread types).
- Improve accessibility and UI polish.

---

## 6. Contribution Guidelines

- Fork the repository, create a feature branch, and open a pull request.
- Add tests for new behavior.
- Keep changes small and document them in the PR description.
- Update README if you add setup steps or new dependencies.

---

## 7. Contact Information

Maintainer: <Your Name>  
Email: <your-email@example.com>  
Replace the placeholders above with your real contact info or GitHub profile link.

---

## Quick commands reference

- Install deps: flutter pub get
- Run app: flutter run
- Run tests: flutter test
- Analyze code: flutter analyze

---

Thank you for using the Sandwich Shop demo. If you want, I can also add example screenshots, move app_styles.dart into `lib/views/`, or update imports to use your actual pubspec package name.
