# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-20

### Added

#### Todo Features
- ✅ Create, read, update, delete (CRUD) operations for todo tasks
- ⏰ Deadline management with DatePicker and TimePicker
- 🔔 Smart repeating notifications (1 minute to 1 week intervals)
- ⚡ Quick action: Complete task directly from notification
- 📊 Live statistics cards (Total, Incomplete, Completed)
- 🎨 Swipe-to-delete gesture
- 📱 1x1 Android widget for quick task creation
- 💾 Local SQLite database storage

#### Pomodoro Features
- ⏱️ Customizable timer (Work/Break/Rest durations)
- 🔄 Automatic phase cycling (Work → Break → Work → Rest)
- 📊 Session tracking and statistics
- 🔔 Phase completion notifications
- 🎨 Circular progress indicator with color-coded phases
- 📱 1x1 Android widget for quick Pomodoro start
- 💾 Settings persistence with SharedPreferences

#### UI/UX
- 🎨 Material Design 3 with yellow (#FFD700) theme
- 📐 Rounded corners on all components (15-20dp)
- 💫 Smooth animations and transitions
- 🧭 Bottom navigation (Todo / Pomodoro / Settings)
- 📊 Gradient headers and visual effects
- 🌓 Light theme optimized

#### Localization
- 🌍 Multi-language support (English, Tiếng Việt)
- ⚙️ Runtime language switching
- 🔄 Persistent language preference
- 📝 Comprehensive translation coverage

#### Platform Support
- 🤖 Android (API 21+)
- 🍎 iOS (iOS 12+)
- 🖥️ macOS (development/testing)

#### App Branding
- 🎨 Custom app icon with clock + checkmark + tomato design
- 📱 Adaptive icon for Android 8.0+
- 🏷️ App name: "Doping"

### Technical Implementation
- **Architecture**: Clean separation (Models, Services, Screens, Providers)
- **State Management**: Provider pattern
- **Database**: SQLite with sqflite
- **Notifications**: flutter_local_notifications with timezone support
- **Widgets**: home_widget for Android home screen widgets
- **Platform Channels**: MethodChannel for native communication

### Dependencies
- `flutter: sdk`
- `flutter_localizations: sdk`
- `sqflite: ^2.3.0`
- `path_provider: ^2.1.1`
- `flutter_local_notifications: ^17.0.0`
- `intl: any`
- `timezone: ^0.9.2`
- `shared_preferences: ^2.2.2`
- `home_widget: ^0.6.0`
- `provider: ^6.1.0`

### Android Specific
- Core library desugaring enabled for Java 8+ API support
- Permissions: POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, USE_EXACT_ALARM
- Widget receivers: TodoWidgetProvider, PomodoroWidgetProvider
- Custom layouts: todo_widget.xml, pomodoro_widget.xml

### Known Issues
- macOS notifications require additional entitlements configuration
- Widgets don't auto-update when app is closed (Android platform limitation)

### Documentation
- ✅ Comprehensive README.md
- ✅ Contributing guidelines (CONTRIBUTING.md)
- ✅ MIT License
- ✅ Screenshots guide
- ✅ Architecture documentation

---

## [Unreleased]

### Planned for v1.1
- [ ] Cloud sync with Firebase
- [ ] Dark mode support
- [ ] Additional widget sizes (2x2, 4x2)
- [ ] iOS widgets support

### Planned for v1.2
- [ ] Task categories and tags
- [ ] Recurring tasks (daily, weekly, monthly)
- [ ] Priority levels
- [ ] Task sorting and filtering

### Planned for v1.3
- [ ] Charts and analytics
- [ ] Data export/import
- [ ] Custom notification sounds
- [ ] Task collaboration features

---

## Version History

- **v1.0.0** (2026-01-20) - Initial release with full todo and Pomodoro features

---

[1.0.0]: https://github.com/yourusername/doping/releases/tag/v1.0.0
[Unreleased]: https://github.com/yourusername/doping/compare/v1.0.0...HEAD
