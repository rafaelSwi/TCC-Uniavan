import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @contactAdministratorToCreateAnAccount.
  ///
  /// In en, this message translates to:
  /// **'To create an account you must contact an administrator.'**
  String get contactAdministratorToCreateAnAccount;

  /// No description provided for @connectivityWithTheServer.
  ///
  /// In en, this message translates to:
  /// **'Server connectivity:    '**
  String get connectivityWithTheServer;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @connectivityError.
  ///
  /// In en, this message translates to:
  /// **'Connectivity Error'**
  String get connectivityError;

  /// No description provided for @couldNotEstablishServerConnection.
  ///
  /// In en, this message translates to:
  /// **'Could not establish a connection to the server.'**
  String get couldNotEstablishServerConnection;

  /// No description provided for @permissionError.
  ///
  /// In en, this message translates to:
  /// **'Permission Error'**
  String get permissionError;

  /// No description provided for @permissionErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Your user does not have sufficient permissions to perform this action.'**
  String get permissionErrorDesc;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @someLoginError.
  ///
  /// In en, this message translates to:
  /// **'There was a problem with the login process'**
  String get someLoginError;

  /// No description provided for @connectionEstablishedButLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'The connection to the server was established, but the login failed.'**
  String get connectionEstablishedButLoginFailed;

  /// No description provided for @interfaceScale.
  ///
  /// In en, this message translates to:
  /// **'Interface Scale'**
  String get interfaceScale;

  /// No description provided for @interfaceScaleDesc.
  ///
  /// In en, this message translates to:
  /// **'Experimental, may present problems'**
  String get interfaceScaleDesc;

  /// No description provided for @def.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get def;

  /// No description provided for @closeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'\"X\" Button'**
  String get closeButtonLabel;

  /// No description provided for @closeButtonLabelDesc.
  ///
  /// In en, this message translates to:
  /// **'\"X\" Button Label'**
  String get closeButtonLabelDesc;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get goBack;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid Request'**
  String get invalidRequest;

  /// No description provided for @thisLocationIsAlreadyMarkedAsDiscarded.
  ///
  /// In en, this message translates to:
  /// **'This location is already marked as discarded.'**
  String get thisLocationIsAlreadyMarkedAsDiscarded;

  /// No description provided for @thisScheduleIsAlreadyMarkedAsDiscarded.
  ///
  /// In en, this message translates to:
  /// **'This schedule is already marked as discarded.'**
  String get thisScheduleIsAlreadyMarkedAsDiscarded;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Change it on the login screen'**
  String get appearanceDesc;

  /// No description provided for @currentHost.
  ///
  /// In en, this message translates to:
  /// **'Current Host'**
  String get currentHost;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @chunk.
  ///
  /// In en, this message translates to:
  /// **'Chunk'**
  String get chunk;

  /// No description provided for @chunks.
  ///
  /// In en, this message translates to:
  /// **'Chunks'**
  String get chunks;

  /// No description provided for @httpSecure.
  ///
  /// In en, this message translates to:
  /// **'HTTP Secure'**
  String get httpSecure;

  /// No description provided for @applyPort.
  ///
  /// In en, this message translates to:
  /// **'Apply Port'**
  String get applyPort;

  /// No description provided for @applyNewHost.
  ///
  /// In en, this message translates to:
  /// **'Apply new host'**
  String get applyNewHost;

  /// No description provided for @emptyFields.
  ///
  /// In en, this message translates to:
  /// **'Empty fields'**
  String get emptyFields;

  /// No description provided for @readInPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Read in Portuguese (Português)'**
  String get readInPortuguese;

  /// No description provided for @readInEnglish.
  ///
  /// In en, this message translates to:
  /// **'Read in English (Inglês)'**
  String get readInEnglish;

  /// No description provided for @fillAllToCreateActivity.
  ///
  /// In en, this message translates to:
  /// **'Fill in all the fields to create an activity.'**
  String get fillAllToCreateActivity;

  /// No description provided for @fillAllToCloneActivity.
  ///
  /// In en, this message translates to:
  /// **'Fill in all the fields to clone this activity.'**
  String get fillAllToCloneActivity;

  /// No description provided for @fillAllToCreateUser.
  ///
  /// In en, this message translates to:
  /// **'Fill in all the fields to create this user.'**
  String get fillAllToCreateUser;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @requestToCreateActivitySent.
  ///
  /// In en, this message translates to:
  /// **'The Request to create this activity has been created.'**
  String get requestToCreateActivitySent;

  /// No description provided for @requestToDeprecateLocationSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to deprecate this location has been sent.'**
  String get requestToDeprecateLocationSent;

  /// No description provided for @requestToDeprecateScheduleSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to deprecate this schedule has been sent.'**
  String get requestToDeprecateScheduleSent;

  /// No description provided for @requestToCloneActivitySent.
  ///
  /// In en, this message translates to:
  /// **'The Request to clone this activity has been created.'**
  String get requestToCloneActivitySent;

  /// No description provided for @requestToCreateUserSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to create this user has been created.'**
  String get requestToCreateUserSent;

  /// No description provided for @errorWhileCreatingActivity.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to create the activity.'**
  String get errorWhileCreatingActivity;

  /// No description provided for @errorWhileDeprecateLocation.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to deprecate this location.'**
  String get errorWhileDeprecateLocation;

  /// No description provided for @errorWhileDeprecateSchedule.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to deprecate this schedule.'**
  String get errorWhileDeprecateSchedule;

  /// No description provided for @errorWhileCreatingChunk.
  ///
  /// In en, this message translates to:
  /// **'There was a problem creating a location chunk.'**
  String get errorWhileCreatingChunk;

  /// No description provided for @errorWhileDeletingChunk.
  ///
  /// In en, this message translates to:
  /// **'There was a problem deleting this chunk.'**
  String get errorWhileDeletingChunk;

  /// No description provided for @errorWhileUpdatingChunk.
  ///
  /// In en, this message translates to:
  /// **'There was a problem updating this chunk.'**
  String get errorWhileUpdatingChunk;

  /// No description provided for @errorWhileCloningActivity.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to clone this activity.'**
  String get errorWhileCloningActivity;

  /// No description provided for @createActivity.
  ///
  /// In en, this message translates to:
  /// **'Create Activity'**
  String get createActivity;

  /// No description provided for @cloneActivity.
  ///
  /// In en, this message translates to:
  /// **'Clone Activity'**
  String get cloneActivity;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteThisChunk.
  ///
  /// In en, this message translates to:
  /// **'Delete this chunk?'**
  String get deleteThisChunk;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @restriction.
  ///
  /// In en, this message translates to:
  /// **'Restriction'**
  String get restriction;

  /// No description provided for @restrictions.
  ///
  /// In en, this message translates to:
  /// **'Restrictions'**
  String get restrictions;

  /// No description provided for @unresolved.
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get unresolved;

  /// No description provided for @someInformationNeedsToBeFilled.
  ///
  /// In en, this message translates to:
  /// **'Some information needs to be filled in to continue.'**
  String get someInformationNeedsToBeFilled;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @selectedPlural.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedPlural;

  /// No description provided for @selectEmployees.
  ///
  /// In en, this message translates to:
  /// **'Select Employees'**
  String get selectEmployees;

  /// No description provided for @selectModerators.
  ///
  /// In en, this message translates to:
  /// **'Select Moderators'**
  String get selectModerators;

  /// No description provided for @selectActivities.
  ///
  /// In en, this message translates to:
  /// **'Select activities'**
  String get selectActivities;

  /// No description provided for @selectInCaseOfRain.
  ///
  /// In en, this message translates to:
  /// **'Select activities for rainy days'**
  String get selectInCaseOfRain;

  /// No description provided for @selectRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Select Restrictions'**
  String get selectRestrictions;

  /// No description provided for @restrictionsMustBeManuallySelected.
  ///
  /// In en, this message translates to:
  /// **'Restrictions must be manually selected, even in case of cloning.'**
  String get restrictionsMustBeManuallySelected;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @professionalAmount.
  ///
  /// In en, this message translates to:
  /// **'Professionals Amount'**
  String get professionalAmount;

  /// No description provided for @labourerAmount.
  ///
  /// In en, this message translates to:
  /// **'Labourer Amount'**
  String get labourerAmount;

  /// No description provided for @minutesForEachProfessional.
  ///
  /// In en, this message translates to:
  /// **'Minutes for each professional'**
  String get minutesForEachProfessional;

  /// No description provided for @minutesForEachLabourer.
  ///
  /// In en, this message translates to:
  /// **'Minutes for each labourer'**
  String get minutesForEachLabourer;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @deadlineDate.
  ///
  /// In en, this message translates to:
  /// **'Deadline Date'**
  String get deadlineDate;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @selectActivityLocation.
  ///
  /// In en, this message translates to:
  /// **'Select the location of this activity'**
  String get selectActivityLocation;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selectedLocation;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @deprecated.
  ///
  /// In en, this message translates to:
  /// **'Deprecated'**
  String get deprecated;

  /// No description provided for @deprecateLocation.
  ///
  /// In en, this message translates to:
  /// **'Deprecate Location'**
  String get deprecateLocation;

  /// No description provided for @deprecateThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Deprecate this location? This action cannot be reversed.'**
  String get deprecateThisLocation;

  /// No description provided for @deprecateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Deprecate Schedule'**
  String get deprecateSchedule;

  /// No description provided for @deprecateThisSchedule.
  ///
  /// In en, this message translates to:
  /// **'Deprecate this schedule? This action cannot be reversed.'**
  String get deprecateThisSchedule;

  /// No description provided for @associateWithSameProjects.
  ///
  /// In en, this message translates to:
  /// **'Associate with the same projects?'**
  String get associateWithSameProjects;

  /// No description provided for @youCannotCreateNewUser.
  ///
  /// In en, this message translates to:
  /// **'You cannot create a new user.'**
  String get youCannotCreateNewUser;

  /// No description provided for @nameColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Name column label (Default: \'Nome\')'**
  String get nameColumnLabel;

  /// No description provided for @durationColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration column label (Default: \'Duração\')'**
  String get durationColumnLabel;

  /// No description provided for @selectSheetFile.
  ///
  /// In en, this message translates to:
  /// **'Select Sheet File'**
  String get selectSheetFile;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @onlyXlsxFilesWillWork.
  ///
  /// In en, this message translates to:
  /// **'Only \"xlsx\" files will work.'**
  String get onlyXlsxFilesWillWork;

  /// No description provided for @inMinutes.
  ///
  /// In en, this message translates to:
  /// **'In Minutes'**
  String get inMinutes;

  /// No description provided for @inHours.
  ///
  /// In en, this message translates to:
  /// **'In Hours'**
  String get inHours;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @selectChunks.
  ///
  /// In en, this message translates to:
  /// **'Select Chunks'**
  String get selectChunks;

  /// No description provided for @previouslySelected.
  ///
  /// In en, this message translates to:
  /// **'Previously selected'**
  String get previouslySelected;

  /// No description provided for @noneSelected.
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get noneSelected;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @noReference.
  ///
  /// In en, this message translates to:
  /// **'No reference'**
  String get noReference;

  /// No description provided for @selectLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'You need to choose a location first.'**
  String get selectLocationFirst;

  /// No description provided for @fillEverythingFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete the entire procedure.'**
  String get fillEverythingFirst;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @requestToCreateLocationSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to create this location has been created.'**
  String get requestToCreateLocationSent;

  /// No description provided for @errorWhileCreatingLocation.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to create the location.'**
  String get errorWhileCreatingLocation;

  /// No description provided for @errorWhileOpeningUserSchedule.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while opening more information about this user\'s schedules.'**
  String get errorWhileOpeningUserSchedule;

  /// No description provided for @createLocation.
  ///
  /// In en, this message translates to:
  /// **'Create Location'**
  String get createLocation;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No Projets'**
  String get noProjects;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get projectTitle;

  /// No description provided for @fullTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Title'**
  String get fullTitle;

  /// No description provided for @dateWhenItWasMarkedAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Date when it was marked as completed'**
  String get dateWhenItWasMarkedAsCompleted;

  /// No description provided for @markedAsCompletedby.
  ///
  /// In en, this message translates to:
  /// **'Marked as completed by the following user'**
  String get markedAsCompletedby;

  /// No description provided for @userHasAlreadyMarkedThisChunkAsComplete.
  ///
  /// In en, this message translates to:
  /// **'A user has already marked/unmarked this chunk as completed at some point.'**
  String get userHasAlreadyMarkedThisChunkAsComplete;

  /// No description provided for @noInfo.
  ///
  /// In en, this message translates to:
  /// **'No Information'**
  String get noInfo;

  /// No description provided for @confirmWithCurrentDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm with today\'s date'**
  String get confirmWithCurrentDate;

  /// No description provided for @confirmWithselectedDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm with selected date'**
  String get confirmWithselectedDate;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected date'**
  String get selectedDate;

  /// No description provided for @yesUndo.
  ///
  /// In en, this message translates to:
  /// **'Yes, continue'**
  String get yesUndo;

  /// No description provided for @doYouWantToMarkThisChunkAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark this chunk as complete?'**
  String get doYouWantToMarkThisChunkAsComplete;

  /// No description provided for @doYouWantToUnmarkThisChunk.
  ///
  /// In en, this message translates to:
  /// **'Undo chunk progress?'**
  String get doYouWantToUnmarkThisChunk;

  /// No description provided for @doYouWantToUnmarkThisChunkDescription.
  ///
  /// In en, this message translates to:
  /// **'Undoing the progress of this chunk will return it to the \"In Progress\" status. It is worth mentioning that this action will be recorded in your name.'**
  String get doYouWantToUnmarkThisChunkDescription;

  /// No description provided for @clickHereToChooseCustomCompletionDate.
  ///
  /// In en, this message translates to:
  /// **'Click HERE to choose a custom completion date. If the date is today, just click to confirm.'**
  String get clickHereToChooseCustomCompletionDate;

  /// No description provided for @conclusionDate.
  ///
  /// In en, this message translates to:
  /// **'Completion Date'**
  String get conclusionDate;

  /// No description provided for @chunkHasNoNote.
  ///
  /// In en, this message translates to:
  /// **'This chunk has no notes.'**
  String get chunkHasNoNote;

  /// No description provided for @projectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Project Completed'**
  String get projectCompleted;

  /// No description provided for @completionDate.
  ///
  /// In en, this message translates to:
  /// **'Finish Date'**
  String get completionDate;

  /// No description provided for @actionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Action confirmed'**
  String get actionConfirmed;

  /// No description provided for @swipeToContinueRememberThisActionIsIrreversible.
  ///
  /// In en, this message translates to:
  /// **'Swipe to continue, remember this action is irreversible'**
  String get swipeToContinueRememberThisActionIsIrreversible;

  /// No description provided for @pressEscToExitOrClickOutsideThePopup.
  ///
  /// In en, this message translates to:
  /// **'Press ESC to exit or click outside the pop-up'**
  String get pressEscToExitOrClickOutsideThePopup;

  /// No description provided for @doYouWantToFinishThisProject.
  ///
  /// In en, this message translates to:
  /// **'Do you want to finish the project?'**
  String get doYouWantToFinishThisProject;

  /// No description provided for @notCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get notCompleted;

  /// No description provided for @itIsNotPossibleToModifyAttributesOfProjectThatHasAlreadyBeenCompleted.
  ///
  /// In en, this message translates to:
  /// **'It is not possible to modify attributes of a project that has already been completed.'**
  String
      get itIsNotPossibleToModifyAttributesOfProjectThatHasAlreadyBeenCompleted;

  /// No description provided for @requestToCreateProjectSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to create this project has been created.'**
  String get requestToCreateProjectSent;

  /// No description provided for @errorWhileCreatingProject.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to create the project.'**
  String get errorWhileCreatingProject;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userDetails;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Title'**
  String get scheduleTitle;

  /// No description provided for @changeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Change Schedule'**
  String get changeSchedule;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get undefined;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @changePermissions.
  ///
  /// In en, this message translates to:
  /// **'Change Permissions'**
  String get changePermissions;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change Personal Name'**
  String get changeName;

  /// No description provided for @changeCpf.
  ///
  /// In en, this message translates to:
  /// **'Change CPF'**
  String get changeCpf;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @associatedActivities.
  ///
  /// In en, this message translates to:
  /// **'Associated Activities'**
  String get associatedActivities;

  /// No description provided for @quickGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick Guide'**
  String get quickGuide;

  /// No description provided for @spreadsheetAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet Analysis'**
  String get spreadsheetAnalysis;

  /// No description provided for @scheduleDetails.
  ///
  /// In en, this message translates to:
  /// **'Schedule details'**
  String get scheduleDetails;

  /// No description provided for @requestToCreateScheduleSent.
  ///
  /// In en, this message translates to:
  /// **'The Request to create this schedule has been created.'**
  String get requestToCreateScheduleSent;

  /// No description provided for @errorWhileCreatingSchedule.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to create the schedule.'**
  String get errorWhileCreatingSchedule;

  /// No description provided for @errorWhileCreatingUser.
  ///
  /// In en, this message translates to:
  /// **'There was a problem trying to create this user.'**
  String get errorWhileCreatingUser;

  /// No description provided for @errorWhileCollectingUser.
  ///
  /// In en, this message translates to:
  /// **'There was a problem that prevented this user\'s information from being collected from the server.'**
  String get errorWhileCollectingUser;

  /// No description provided for @errorWhileOpeningUser.
  ///
  /// In en, this message translates to:
  /// **'There was a problem opening more information for this user.'**
  String get errorWhileOpeningUser;

  /// No description provided for @onlyUsersWithHigherPermissionCanModifyProjectAttributes.
  ///
  /// In en, this message translates to:
  /// **'Only users with higher permission can modify project attributes.'**
  String get onlyUsersWithHigherPermissionCanModifyProjectAttributes;

  /// No description provided for @createSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get createSchedule;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @moderators.
  ///
  /// In en, this message translates to:
  /// **'Moderators'**
  String get moderators;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @noActivitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No activities were found'**
  String get noActivitiesFound;

  /// No description provided for @noLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations were found'**
  String get noLocationsFound;

  /// No description provided for @noSchedulesFound.
  ///
  /// In en, this message translates to:
  /// **'No schedules were found'**
  String get noSchedulesFound;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users were found'**
  String get noUsersFound;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @inCaseOfRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy Day Activities'**
  String get inCaseOfRain;

  /// No description provided for @searchEmployees.
  ///
  /// In en, this message translates to:
  /// **'Search employees'**
  String get searchEmployees;

  /// No description provided for @searchForUsersToAddtoTheProject.
  ///
  /// In en, this message translates to:
  /// **'Search for users to add to the project'**
  String get searchForUsersToAddtoTheProject;

  /// No description provided for @searchForActivitiesToAddtoTheProject.
  ///
  /// In en, this message translates to:
  /// **'Search for activities to add to the project'**
  String get searchForActivitiesToAddtoTheProject;

  /// No description provided for @mainResponsible.
  ///
  /// In en, this message translates to:
  /// **'Main responsible'**
  String get mainResponsible;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @timeSelection.
  ///
  /// In en, this message translates to:
  /// **'Time Selection'**
  String get timeSelection;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @clockIn.
  ///
  /// In en, this message translates to:
  /// **'Clock In'**
  String get clockIn;

  /// No description provided for @clockOut.
  ///
  /// In en, this message translates to:
  /// **'Clock Out'**
  String get clockOut;

  /// No description provided for @startOfBreak.
  ///
  /// In en, this message translates to:
  /// **'Start of Break'**
  String get startOfBreak;

  /// No description provided for @endOfBreak.
  ///
  /// In en, this message translates to:
  /// **'End of Break'**
  String get endOfBreak;

  /// No description provided for @workBreak.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get workBreak;

  /// No description provided for @ifAny.
  ///
  /// In en, this message translates to:
  /// **'If Any'**
  String get ifAny;

  /// No description provided for @unableToCollectRequiredInfoFromServer.
  ///
  /// In en, this message translates to:
  /// **'Unable to collect required information from server.'**
  String get unableToCollectRequiredInfoFromServer;

  /// No description provided for @workBreaks.
  ///
  /// In en, this message translates to:
  /// **'Breaks'**
  String get workBreaks;

  /// No description provided for @usersUsing.
  ///
  /// In en, this message translates to:
  /// **'Users using'**
  String get usersUsing;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createThisSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create this Schedule?'**
  String get createThisSchedule;

  /// No description provided for @updateThisSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update this Schedule?'**
  String get updateThisSchedule;

  /// No description provided for @hideRestrictedUsers.
  ///
  /// In en, this message translates to:
  /// **'Hide restricted users'**
  String get hideRestrictedUsers;

  /// No description provided for @noBreak.
  ///
  /// In en, this message translates to:
  /// **'No Break'**
  String get noBreak;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @professionals.
  ///
  /// In en, this message translates to:
  /// **'Professionals'**
  String get professionals;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @labourer.
  ///
  /// In en, this message translates to:
  /// **'Labourer'**
  String get labourer;

  /// No description provided for @labourers.
  ///
  /// In en, this message translates to:
  /// **'Labourers'**
  String get labourers;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @worker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get worker;

  /// No description provided for @restricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get restricted;

  /// No description provided for @nameWillHaveItsInitialsInCapitalLetters.
  ///
  /// In en, this message translates to:
  /// **'The name will have its initials in capital letters.'**
  String get nameWillHaveItsInitialsInCapitalLetters;

  /// No description provided for @theNameWillBeRecognizedAs.
  ///
  /// In en, this message translates to:
  /// **'The name will be recognized as:'**
  String get theNameWillBeRecognizedAs;

  /// No description provided for @errorOpeningActivity.
  ///
  /// In en, this message translates to:
  /// **'It was not possible to open more details about this activity due to a server problem.'**
  String get errorOpeningActivity;

  /// No description provided for @errorOpeningLocation.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when opening more details for this location'**
  String get errorOpeningLocation;

  /// No description provided for @errorOpeningSchedule.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when opening more details for this schedule'**
  String get errorOpeningSchedule;

  /// No description provided for @errorOpeningProject.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when opening more details for this project'**
  String get errorOpeningProject;

  /// No description provided for @errorOpeningUser.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when opening more details for this user'**
  String get errorOpeningUser;

  /// No description provided for @errorLoadingUsers.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading users'**
  String get errorLoadingUsers;

  /// No description provided for @errorLoadingLocations.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading locations'**
  String get errorLoadingLocations;

  /// No description provided for @errorLoadingSchedules.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading schedules'**
  String get errorLoadingSchedules;

  /// No description provided for @errorOpeningUserMaybeCpfIsWrong.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when opening more details for this user, maybe the CPF entered is wrong.'**
  String get errorOpeningUserMaybeCpfIsWrong;

  /// No description provided for @notPossibleToCreateAdminUser.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, it is not possible to create a user with administrative permissions.'**
  String get notPossibleToCreateAdminUser;

  /// No description provided for @notPossibleToCreateActivity.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create a new activity.'**
  String get notPossibleToCreateActivity;

  /// No description provided for @notPossibleToCreateLocation.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create a new location.'**
  String get notPossibleToCreateLocation;

  /// No description provided for @notPossibleToCreateProject.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create a new project.'**
  String get notPossibleToCreateProject;

  /// No description provided for @notPossibleToCreateSchedule.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create a new schedule.'**
  String get notPossibleToCreateSchedule;

  /// No description provided for @searchByDescription.
  ///
  /// In en, this message translates to:
  /// **'Search by description'**
  String get searchByDescription;

  /// No description provided for @showCompletedActivities.
  ///
  /// In en, this message translates to:
  /// **'Show completed activities'**
  String get showCompletedActivities;

  /// No description provided for @showDeprecatedLocations.
  ///
  /// In en, this message translates to:
  /// **'Show deprecated locations'**
  String get showDeprecatedLocations;

  /// No description provided for @showOnlyOverdueProjects.
  ///
  /// In en, this message translates to:
  /// **'Show only overdue projects'**
  String get showOnlyOverdueProjects;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @noScheduleAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Schedule Available'**
  String get noScheduleAvailable;

  /// No description provided for @searchByCpf.
  ///
  /// In en, this message translates to:
  /// **'CPF Search'**
  String get searchByCpf;

  /// No description provided for @selectPermission.
  ///
  /// In en, this message translates to:
  /// **'Select a Permission'**
  String get selectPermission;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select a Theme'**
  String get selectTheme;

  /// No description provided for @selectSchedule.
  ///
  /// In en, this message translates to:
  /// **'Select a Schedule'**
  String get selectSchedule;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select a Role'**
  String get selectRole;

  /// No description provided for @selection.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get selection;

  /// No description provided for @unfinishedProjects.
  ///
  /// In en, this message translates to:
  /// **'Unfinished Projects'**
  String get unfinishedProjects;

  /// No description provided for @noUnfinishedProjects.
  ///
  /// In en, this message translates to:
  /// **'No Unfinished Projects'**
  String get noUnfinishedProjects;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addChunk.
  ///
  /// In en, this message translates to:
  /// **'Add Chunk'**
  String get addChunk;

  /// No description provided for @mainInformation.
  ///
  /// In en, this message translates to:
  /// **'Main Information'**
  String get mainInformation;

  /// No description provided for @insertMainInformation.
  ///
  /// In en, this message translates to:
  /// **'INSERT MAIN INFO.'**
  String get insertMainInformation;

  /// No description provided for @secondaryInformation.
  ///
  /// In en, this message translates to:
  /// **'Secondary Information'**
  String get secondaryInformation;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @inProgressAbbreviated.
  ///
  /// In en, this message translates to:
  /// **'In Pr.'**
  String get inProgressAbbreviated;

  /// No description provided for @cancelAbbreviated.
  ///
  /// In en, this message translates to:
  /// **'Canc.'**
  String get cancelAbbreviated;

  /// No description provided for @activeAbbreviated.
  ///
  /// In en, this message translates to:
  /// **'Act.'**
  String get activeAbbreviated;

  /// No description provided for @activitiesReallyAbbreviatedAndUpperCased.
  ///
  /// In en, this message translates to:
  /// **'ACT.'**
  String get activitiesReallyAbbreviatedAndUpperCased;

  /// No description provided for @rainReallyAbbreviatedAndUpperCased.
  ///
  /// In en, this message translates to:
  /// **'RAI.'**
  String get rainReallyAbbreviatedAndUpperCased;

  /// No description provided for @moderatorsReallyAbbreviatedAndUpperCased.
  ///
  /// In en, this message translates to:
  /// **'MOD.'**
  String get moderatorsReallyAbbreviatedAndUpperCased;

  /// No description provided for @resetSearch.
  ///
  /// In en, this message translates to:
  /// **'Reset Search'**
  String get resetSearch;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @marked.
  ///
  /// In en, this message translates to:
  /// **'Marked'**
  String get marked;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @responsible.
  ///
  /// In en, this message translates to:
  /// **'Responsible'**
  String get responsible;

  /// No description provided for @cpf.
  ///
  /// In en, this message translates to:
  /// **'CPF'**
  String get cpf;

  /// No description provided for @cep.
  ///
  /// In en, this message translates to:
  /// **'CEP'**
  String get cep;

  /// No description provided for @cpfRegistrationUpdate.
  ///
  /// In en, this message translates to:
  /// **'CPF registration update'**
  String get cpfRegistrationUpdate;

  /// No description provided for @requestToUpdateCpf.
  ///
  /// In en, this message translates to:
  /// **'The request to update this user\'s CPF was sent to the server.'**
  String get requestToUpdateCpf;

  /// No description provided for @requestToUpdateProject.
  ///
  /// In en, this message translates to:
  /// **'The request to update the project was sent to the server.'**
  String get requestToUpdateProject;

  /// No description provided for @requestToUpdateSchedule.
  ///
  /// In en, this message translates to:
  /// **'The request to update this user\'s schedule was sent to the server.'**
  String get requestToUpdateSchedule;

  /// No description provided for @requestToCompleteActivity.
  ///
  /// In en, this message translates to:
  /// **'The request to mark this activity as completed has been sent to the server.'**
  String get requestToCompleteActivity;

  /// No description provided for @errorWhileCompletingActivity.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete this activity.'**
  String get errorWhileCompletingActivity;

  /// No description provided for @errorWhileCompletingActivityCheckForMore.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete this activity, check for ongoing restrictions and/or all chunks have been completed.'**
  String get errorWhileCompletingActivityCheckForMore;

  /// No description provided for @errorWhileUpdatingCpf.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s CPF.'**
  String get errorWhileUpdatingCpf;

  /// No description provided for @errorWhileUpdatingProject.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this project.'**
  String get errorWhileUpdatingProject;

  /// No description provided for @errorWhileUpdatingSchedule.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s schedule.'**
  String get errorWhileUpdatingSchedule;

  /// No description provided for @currentCpf.
  ///
  /// In en, this message translates to:
  /// **'Current CPF'**
  String get currentCpf;

  /// No description provided for @insertCpf.
  ///
  /// In en, this message translates to:
  /// **'Insert CPF'**
  String get insertCpf;

  /// No description provided for @thisActivityHasRestrictions.
  ///
  /// In en, this message translates to:
  /// **'The current activity/chunk has restrictions, and these restrictions must be completed first.'**
  String get thisActivityHasRestrictions;

  /// No description provided for @cpfChangesTakesTime.
  ///
  /// In en, this message translates to:
  /// **'CPF changes may take some time to be completely processed by the server.'**
  String get cpfChangesTakesTime;

  /// No description provided for @nameChangesTakesTime.
  ///
  /// In en, this message translates to:
  /// **'Name changes are not instantaneous and may take time to be fully processed'**
  String get nameChangesTakesTime;

  /// No description provided for @roleChangesTakesTime.
  ///
  /// In en, this message translates to:
  /// **'Role changes are not instantaneous and may take time to be fully processed'**
  String get roleChangesTakesTime;

  /// No description provided for @scheduleChangesTakesTime.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes are not instantaneous and may take some time to be completely processed by the server.'**
  String get scheduleChangesTakesTime;

  /// No description provided for @activitiesAndModeratorsWillBeAddedToTheExistingProject.
  ///
  /// In en, this message translates to:
  /// **'Selected activities and moderators will be added to the existing project.'**
  String get activitiesAndModeratorsWillBeAddedToTheExistingProject;

  /// No description provided for @notPossibleToRemoveActivitiesOrModeratorsFromCreatedProjects.
  ///
  /// In en, this message translates to:
  /// **'You CANNOT REMOVE activities or moderators from created projects.'**
  String get notPossibleToRemoveActivitiesOrModeratorsFromCreatedProjects;

  /// No description provided for @updateCpf.
  ///
  /// In en, this message translates to:
  /// **'Update CPF'**
  String get updateCpf;

  /// No description provided for @updateProject.
  ///
  /// In en, this message translates to:
  /// **'Update Project'**
  String get updateProject;

  /// No description provided for @updateActivity.
  ///
  /// In en, this message translates to:
  /// **'Update Activity'**
  String get updateActivity;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameUpdate.
  ///
  /// In en, this message translates to:
  /// **'Name Update'**
  String get nameUpdate;

  /// No description provided for @requestToUpdateName.
  ///
  /// In en, this message translates to:
  /// **'The request to update this user\'s name was sent to the server.'**
  String get requestToUpdateName;

  /// No description provided for @errorWhileUpdatingName.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s name.'**
  String get errorWhileUpdatingName;

  /// No description provided for @currentName.
  ///
  /// In en, this message translates to:
  /// **'Current Name'**
  String get currentName;

  /// No description provided for @updateName.
  ///
  /// In en, this message translates to:
  /// **'Update Name'**
  String get updateName;

  /// No description provided for @rememberCpf.
  ///
  /// In en, this message translates to:
  /// **'Remember CPF'**
  String get rememberCpf;

  /// No description provided for @permAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'If there is a button to be pressed, the administrator can press it, and things will happen.'**
  String get permAdminDesc;

  /// No description provided for @permManagerDesc.
  ///
  /// In en, this message translates to:
  /// **'A manager can create and manage Projects, Locations, Activities, etc. However, he cannot change users\' personal data, such as permissions.'**
  String get permManagerDesc;

  /// No description provided for @permWorkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Worker has adequate permissions to use the system, but without detailed management of activities, projects and users.'**
  String get permWorkerDesc;

  /// No description provided for @permRestrictedDesc.
  ///
  /// In en, this message translates to:
  /// **'A restricted user cannot perform absolutely any action within the system, whether viewing or managing.'**
  String get permRestrictedDesc;

  /// No description provided for @selectPermissionToReadItsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a permission to read its description.'**
  String get selectPermissionToReadItsDescription;

  /// No description provided for @permUpdate.
  ///
  /// In en, this message translates to:
  /// **'User permission update'**
  String get permUpdate;

  /// No description provided for @permError.
  ///
  /// In en, this message translates to:
  /// **'Permission Error'**
  String get permError;

  /// No description provided for @youDontHavePerm.
  ///
  /// In en, this message translates to:
  /// **'You do not have sufficient permissions to perform this action.'**
  String get youDontHavePerm;

  /// No description provided for @requestToUpdatePerm.
  ///
  /// In en, this message translates to:
  /// **'The request to update permissions was sent to the server.'**
  String get requestToUpdatePerm;

  /// No description provided for @errorWhileUpdatingPerm.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s permissions.'**
  String get errorWhileUpdatingPerm;

  /// No description provided for @errorWhileUpdatingActivity.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this activity.'**
  String get errorWhileUpdatingActivity;

  /// No description provided for @updateUserPermission.
  ///
  /// In en, this message translates to:
  /// **'Update user permission'**
  String get updateUserPermission;

  /// No description provided for @minCharactersAcceptedInPassword.
  ///
  /// In en, this message translates to:
  /// **'Minimum number of characters in a password:'**
  String get minCharactersAcceptedInPassword;

  /// No description provided for @passwordUpdate.
  ///
  /// In en, this message translates to:
  /// **'User password update'**
  String get passwordUpdate;

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permission;

  /// No description provided for @requestToUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'The request to update this user\'s password was sent to the server.'**
  String get requestToUpdatePassword;

  /// No description provided for @requestToUpdateActivity.
  ///
  /// In en, this message translates to:
  /// **'The request to update this activity was sent to the server.'**
  String get requestToUpdateActivity;

  /// No description provided for @errorWhileUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s password.'**
  String get errorWhileUpdatingPassword;

  /// No description provided for @updateUserPassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updateUserPassword;

  /// No description provided for @passwordUpdatesDoNotRevokeActiveTokens.
  ///
  /// In en, this message translates to:
  /// **'Password updates do not revoke active Tokens.'**
  String get passwordUpdatesDoNotRevokeActiveTokens;

  /// No description provided for @roleUpdate.
  ///
  /// In en, this message translates to:
  /// **'User role update'**
  String get roleUpdate;

  /// No description provided for @requestToUpdateRole.
  ///
  /// In en, this message translates to:
  /// **'The request to update this user\'s role was sent to the server.'**
  String get requestToUpdateRole;

  /// No description provided for @errorWhileUpdatingRole.
  ///
  /// In en, this message translates to:
  /// **'An unexpected problem occurred when trying to update this user\'s role.'**
  String get errorWhileUpdatingRole;

  /// No description provided for @updateUserRole.
  ///
  /// In en, this message translates to:
  /// **'Update role'**
  String get updateUserRole;

  /// No description provided for @updateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update Schedule'**
  String get updateSchedule;

  /// No description provided for @scheduleUpdate.
  ///
  /// In en, this message translates to:
  /// **'User schedule update'**
  String get scheduleUpdate;

  /// No description provided for @updateUserSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update Schedule'**
  String get updateUserSchedule;

  /// No description provided for @usersAffectedByChange.
  ///
  /// In en, this message translates to:
  /// **'Users affected by the change'**
  String get usersAffectedByChange;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View Progress'**
  String get viewProgress;

  /// No description provided for @cantCloneActivity.
  ///
  /// In en, this message translates to:
  /// **'Unable to clone activity'**
  String get cantCloneActivity;

  /// No description provided for @creatorInformation.
  ///
  /// In en, this message translates to:
  /// **'Creator Information'**
  String get creatorInformation;

  /// No description provided for @responsibleInformation.
  ///
  /// In en, this message translates to:
  /// **'Responsible Information'**
  String get responsibleInformation;

  /// No description provided for @modifyActivityAttributes.
  ///
  /// In en, this message translates to:
  /// **'Modify activity attributes'**
  String get modifyActivityAttributes;

  /// No description provided for @modifyProjectAttributes.
  ///
  /// In en, this message translates to:
  /// **'Modify project attributes'**
  String get modifyProjectAttributes;

  /// No description provided for @activityAlreadyDone.
  ///
  /// In en, this message translates to:
  /// **'Activity already completed'**
  String get activityAlreadyDone;

  /// No description provided for @cannotModifyActivitiesThatHaveAlreadyBeenCompleted.
  ///
  /// In en, this message translates to:
  /// **'You cannot modify activities that have already been completed'**
  String get cannotModifyActivitiesThatHaveAlreadyBeenCompleted;

  /// No description provided for @locationInformation.
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark Done'**
  String get markDone;

  /// No description provided for @navigateHorizontallyControlsTip.
  ///
  /// In en, this message translates to:
  /// **'Navigate horizontally (A, D, ←, →) and adjust zoom with ﹣ and ﹢.'**
  String get navigateHorizontallyControlsTip;

  /// No description provided for @navigateHorizontallyTouchTip.
  ///
  /// In en, this message translates to:
  /// **'Navigate horizontally smoothly using your laptop\'s touchpad.'**
  String get navigateHorizontallyTouchTip;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @customWidget.
  ///
  /// In en, this message translates to:
  /// **'Custom Widget'**
  String get customWidget;

  /// No description provided for @defaultWidgetWithCustomColors.
  ///
  /// In en, this message translates to:
  /// **'Default Widget with custom colors'**
  String get defaultWidgetWithCustomColors;

  /// No description provided for @contrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get contrast;

  /// No description provided for @showWeeekDays.
  ///
  /// In en, this message translates to:
  /// **'Show Week Days'**
  String get showWeeekDays;

  /// No description provided for @showActivities.
  ///
  /// In en, this message translates to:
  /// **'Show Activities'**
  String get showActivities;

  /// No description provided for @showProjects.
  ///
  /// In en, this message translates to:
  /// **'Show Projects'**
  String get showProjects;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @deprecate.
  ///
  /// In en, this message translates to:
  /// **'Deprecate'**
  String get deprecate;

  /// No description provided for @discardLocationThisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'Discard location? This action cannot be undone.'**
  String get discardLocationThisActionCannotBeUndone;

  /// No description provided for @averageLaborCost.
  ///
  /// In en, this message translates to:
  /// **'Average labor cost'**
  String get averageLaborCost;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDesc.
  ///
  /// In en, this message translates to:
  /// **'Restart required'**
  String get languageDesc;

  /// No description provided for @orangeTheme.
  ///
  /// In en, this message translates to:
  /// **'Builder'**
  String get orangeTheme;

  /// No description provided for @greenTheme.
  ///
  /// In en, this message translates to:
  /// **'Florest'**
  String get greenTheme;

  /// No description provided for @grayTheme.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get grayTheme;

  /// No description provided for @blueTheme.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get blueTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon Dark'**
  String get darkTheme;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese (Português)'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English (English)'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish (Español)'**
  String get spanish;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @selectMaterials.
  ///
  /// In en, this message translates to:
  /// **'Select Materials'**
  String get selectMaterials;

  /// No description provided for @averageLaborCostInReais.
  ///
  /// In en, this message translates to:
  /// **'Average labor cost (R\$)'**
  String get averageLaborCostInReais;

  /// No description provided for @requestToCreateMaterialSent.
  ///
  /// In en, this message translates to:
  /// **'The request to create this material has been sent to the system.'**
  String get requestToCreateMaterialSent;

  /// No description provided for @errorWhileCreatingMaterial.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating this material.'**
  String get errorWhileCreatingMaterial;

  /// No description provided for @createMaterial.
  ///
  /// In en, this message translates to:
  /// **'Create Material'**
  String get createMaterial;

  /// No description provided for @materialName.
  ///
  /// In en, this message translates to:
  /// **'Material Name'**
  String get materialName;

  /// No description provided for @averagePriceInReais.
  ///
  /// In en, this message translates to:
  /// **'Average price (R\$)'**
  String get averagePriceInReais;

  /// No description provided for @averagePrice.
  ///
  /// In en, this message translates to:
  /// **'Average Price'**
  String get averagePrice;

  /// No description provided for @averagePriceReference.
  ///
  /// In en, this message translates to:
  /// **'Average Price Reference'**
  String get averagePriceReference;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @noMaterialsFound.
  ///
  /// In en, this message translates to:
  /// **'No materials found'**
  String get noMaterialsFound;

  /// No description provided for @youCannotCreateNewMaterial.
  ///
  /// In en, this message translates to:
  /// **'You cannot create a new material.'**
  String get youCannotCreateNewMaterial;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
