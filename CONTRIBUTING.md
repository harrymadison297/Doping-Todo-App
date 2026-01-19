# Contributing to Doping

First off, thank you for considering contributing to Doping! It's people like you that make Doping such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps which reproduce the problem**
* **Provide specific examples to demonstrate the steps**
* **Describe the behavior you observed after following the steps**
* **Explain which behavior you expected to see instead and why**
* **Include screenshots and animated GIFs** if possible
* **Include your Flutter/Dart version**: `flutter --version`

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a step-by-step description of the suggested enhancement**
* **Provide specific examples to demonstrate the steps**
* **Describe the current behavior** and **explain which behavior you expected to see instead**
* **Explain why this enhancement would be useful**

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Follow the Dart/Flutter style guide
* Include screenshots and animated GIFs in your pull request whenever possible
* End all files with a newline
* Avoid platform-dependent code

## Development Setup

1. **Fork and clone the repository**

```bash
git clone https://github.com/your-username/doping.git
cd doping
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Create a branch**

```bash
git checkout -b feature/your-feature-name
```

4. **Make your changes**

Follow the project structure and coding standards.

5. **Test your changes**

```bash
flutter test
flutter analyze
```

6. **Commit your changes**

```bash
git add .
git commit -m "feat: add amazing feature"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc)
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

7. **Push to your fork**

```bash
git push origin feature/your-feature-name
```

8. **Create a Pull Request**

Go to the original repository and create a pull request.

## Styleguides

### Dart Style Guide

* Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
* Use `dart format` to format your code
* Run `flutter analyze` to check for issues

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

### Flutter Best Practices

* Use `const` constructors whenever possible
* Follow the principle of separation of concerns
* Keep widgets small and focused
* Use proper state management (Provider)
* Write meaningful comments for complex logic

### File Naming

* Use lowercase with underscores for file names: `todo_model.dart`
* Use CamelCase for class names: `TodoModel`
* Use camelCase for variable and function names: `getTodoList()`

## Project Structure

```
lib/
├── l10n/              # Localization files
├── models/            # Data models
├── providers/         # State management
├── screens/           # UI screens
├── services/          # Business logic
└── main.dart         # Entry point
```

### Adding New Features

1. **Models**: Add data models to `lib/models/`
2. **Services**: Add business logic to `lib/services/`
3. **Screens**: Add UI screens to `lib/screens/`
4. **Providers**: Add state management to `lib/providers/` if needed
5. **Localization**: Add strings to `lib/l10n/app_en.arb` and `app_vi.arb`

## Testing

* Write unit tests for services and models
* Write widget tests for UI components
* Ensure all tests pass before submitting PR

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Documentation

* Update README.md if you change functionality
* Add dartdoc comments to public APIs
* Update CHANGELOG.md for notable changes

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

---

Thank you for contributing! 🎉
