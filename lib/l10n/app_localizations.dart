import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Doping'**
  String get appTitle;

  /// Todo tab label
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get todoTab;

  /// Pomodoro tab label
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoroTab;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// Todo list screen title
  ///
  /// In en, this message translates to:
  /// **'Todo List'**
  String get todoList;

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Total tasks label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Incomplete tasks label
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get incomplete;

  /// Completed tasks label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Tasks unit
  ///
  /// In en, this message translates to:
  /// **'tasks'**
  String get tasks;

  /// Empty todo list message
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTodos;

  /// Add first task prompt
  ///
  /// In en, this message translates to:
  /// **'Add your first task'**
  String get addFirstTask;

  /// Hide completed tasks button
  ///
  /// In en, this message translates to:
  /// **'Hide completed'**
  String get hideCompleted;

  /// Show completed tasks button
  ///
  /// In en, this message translates to:
  /// **'Show completed'**
  String get showCompleted;

  /// Add task screen title
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// Edit task screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// Title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Title field hint
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Description field hint
  ///
  /// In en, this message translates to:
  /// **'Enter description (optional)'**
  String get enterDescription;

  /// Deadline field label
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// Select date time button
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateTime;

  /// Repeat interval field label
  ///
  /// In en, this message translates to:
  /// **'Repeat Interval'**
  String get repeatInterval;

  /// No repeat option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// 1 minute repeat option
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get oneMinute;

  /// 5 minutes repeat option
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get fiveMinutes;

  /// 10 minutes repeat option
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get tenMinutes;

  /// 30 minutes repeat option
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get thirtyMinutes;

  /// 1 hour repeat option
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// 1 day repeat option
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get oneDay;

  /// 1 week repeat option
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get oneWeek;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title required error
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titleRequired;

  /// Deadline required error
  ///
  /// In en, this message translates to:
  /// **'Please select a deadline'**
  String get selectDeadline;

  /// Error saving task message
  ///
  /// In en, this message translates to:
  /// **'Error saving task'**
  String get errorSavingTask;

  /// Pomodoro timer screen title
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Timer'**
  String get pomodoroTimer;

  /// Work phase label
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// Break phase label
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get breakPhase;

  /// Rest phase label
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// Sessions label
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Settings button/screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Work time setting label
  ///
  /// In en, this message translates to:
  /// **'Work Time'**
  String get workTime;

  /// Break time setting label
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// Rest time setting label
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get restTime;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Work phase complete notification
  ///
  /// In en, this message translates to:
  /// **'Work phase complete!'**
  String get workPhaseComplete;

  /// Break time notification
  ///
  /// In en, this message translates to:
  /// **'Time for a break'**
  String get timeForBreak;

  /// Break phase complete notification
  ///
  /// In en, this message translates to:
  /// **'Break complete!'**
  String get breakPhaseComplete;

  /// Work time notification
  ///
  /// In en, this message translates to:
  /// **'Time to work'**
  String get timeToWork;

  /// Rest phase complete notification
  ///
  /// In en, this message translates to:
  /// **'Rest complete!'**
  String get restPhaseComplete;

  /// Mark complete notification action
  ///
  /// In en, this message translates to:
  /// **'✓ Complete'**
  String get markComplete;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Vietnamese language option
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// App settings section title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// General settings section
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
