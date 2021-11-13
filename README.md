# fight_club

A simple RPG character creator and idle game made with Flutter.

This application run on Android, Ios and Macos.

---

## Requirements

- Dart >= 2.14.0
- Flutter >= 2.0.0

---

## Dependencies

### [Riverpod](https://github.com/rrousselGit/river_pod)

Well tested and maintained state management and dependency injection library by Remi Rousselet, creator of provider package.

### [Hive](https://github.com/hivedb/hive)

Popular storage library for Dart application.

---

## Installation

```sh
flutter pub get && flutter run
```

---
## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

---

## Continuous Integration

This project run github actions in order to:

- Validate code against lint rules
- Run the tests
- Enforce 100% code coverage threshold
  
A second workflow use [Dart Code Metrics](https://github.com/dart-code-checker/dart-code-metrics) to analyse the code quality and build reports on pull request.