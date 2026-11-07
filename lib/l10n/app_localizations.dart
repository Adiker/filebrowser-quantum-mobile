import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title (task switcher / window title)
  ///
  /// In en, this message translates to:
  /// **'File Browser'**
  String get appTitle;

  /// Generic dialog dismiss / abort button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Generic delete action (buttons, menus, tooltips)
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Generic copy-to-clipboard action
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// Generic retry action after a failure
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Generic rename action (sheet item, dialog title, confirm button)
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// Generic download action
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get actionDownload;

  /// Generic create action (FAB tooltip, new-folder confirm)
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// Generic share action (system share-sheet)
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Move action in the selection bar
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get actionMove;

  /// Generic dialog close button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// Opens the file details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get actionDetails;

  /// Hand a file off to a native app
  ///
  /// In en, this message translates to:
  /// **'Open with…'**
  String get actionOpenWith;

  /// Pause a transfer
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get actionPause;

  /// Resume a paused transfer
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get actionResume;

  /// Lock the app (sign out, keep credentials)
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get actionLock;

  /// Sign out and erase stored credentials
  ///
  /// In en, this message translates to:
  /// **'Sign out & forget'**
  String get actionSignOutForget;

  /// Skip this item in a conflict prompt
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// Keep both files in a conflict prompt (auto-renames)
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get actionKeepBoth;

  /// Overwrite the existing item in a conflict prompt
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get actionOverwrite;

  /// Generic confirm button to proceed after a warning
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// Login screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Connect to File Browser'**
  String get loginTitle;

  /// Label of the server URL field
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get loginServerUrlLabel;

  /// Hint (example value) for the server URL field
  ///
  /// In en, this message translates to:
  /// **'https://files.example.com'**
  String get loginServerUrlHint;

  /// Label of the username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// Label of the password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// Validator message for an empty required field
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get loginValidationRequired;

  /// Validator message for an invalid server URL
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTP or HTTPS server URL'**
  String get loginValidationUrl;

  /// No description provided for @loginHttpsFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'HTTPS connection failed'**
  String get loginHttpsFailedTitle;

  /// No description provided for @loginHttpsFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Could not connect securely. You can try {url}, but your password, session token, and files will be sent without encryption. Anyone able to observe this connection may read them. Continue only if you trust the network.'**
  String loginHttpsFailedBody(String url);

  /// No description provided for @loginHttpWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Unencrypted connection'**
  String get loginHttpWarningTitle;

  /// No description provided for @loginHttpWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Your password, session token, and files will be sent without encryption. Anyone able to observe this connection may read them. Continue only if you trust the network.'**
  String get loginHttpWarningBody;

  /// No description provided for @loginHttpCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loginHttpCancel;

  /// No description provided for @loginHttpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Connect over HTTP'**
  String get loginHttpConfirm;

  /// Login submit button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get loginContinue;

  /// Tooltip to reveal the password
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// Tooltip to obscure the password
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// Lock screen headline
  ///
  /// In en, this message translates to:
  /// **'File Browser is locked'**
  String get lockTitle;

  /// Biometric unlock button
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// Lock screen action to forget and set up another server
  ///
  /// In en, this message translates to:
  /// **'Use a different server'**
  String get lockUseDifferentServer;

  /// Source selection screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Choose a source'**
  String get sourceSelectTitle;

  /// No description provided for @sourceChange.
  ///
  /// In en, this message translates to:
  /// **'Change source'**
  String get sourceChange;

  /// No description provided for @sourceCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current source: {name}'**
  String sourceCurrent(String name);

  /// No description provided for @sourceLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load sources. Please try again.'**
  String get sourceLoadError;

  /// No description provided for @sourceChangeError.
  ///
  /// In en, this message translates to:
  /// **'Could not change source. Please try again.'**
  String get sourceChangeError;

  /// No description provided for @sourceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sources are available.'**
  String get sourceEmpty;

  /// Lock action labelled with the signed-in username
  ///
  /// In en, this message translates to:
  /// **'Lock ({username})'**
  String lockWithUser(String username);

  /// Label of the root breadcrumb (the source root)
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get breadcrumbsRoot;

  /// Tooltip: navigate to the parent directory
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get browserUpTooltip;

  /// Tooltip: open search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get browserSearchTooltip;

  /// Tooltip: open the sort menu
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get browserSortTooltip;

  /// Tooltip: reload the directory listing
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get browserRefreshTooltip;

  /// Tooltip: overflow menu
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get browserMoreOptionsTooltip;

  /// No description provided for @browserViewTooltip.
  ///
  /// In en, this message translates to:
  /// **'View options'**
  String get browserViewTooltip;

  /// No description provided for @browserViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get browserViewGrid;

  /// No description provided for @browserViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get browserViewList;

  /// No description provided for @browserViewSize.
  ///
  /// In en, this message translates to:
  /// **'Item size'**
  String get browserViewSize;

  /// Sort menu: by name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// Sort menu: by size
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sortSize;

  /// Sort menu: by modification date
  ///
  /// In en, this message translates to:
  /// **'Date modified'**
  String get sortDateModified;

  /// Overflow menu: choose the default download folder
  ///
  /// In en, this message translates to:
  /// **'Download folder'**
  String get browserMenuDownloadFolder;

  /// Empty state of the directory grid
  ///
  /// In en, this message translates to:
  /// **'This folder is empty'**
  String get browserEmptyFolder;

  /// Selection app bar title: number of selected items
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String browserSelectedCount(int count);

  /// Tooltip: leave multiselect mode
  ///
  /// In en, this message translates to:
  /// **'Exit selection'**
  String get browserExitSelectionTooltip;

  /// Tooltip: select every visible item
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get browserSelectAll;

  /// Tooltip: clear the selection
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get browserDeselectAll;

  /// Action sheet: download a folder as a zip archive
  ///
  /// In en, this message translates to:
  /// **'Download as zip'**
  String get browserDownloadAsZip;

  /// Create/show a public share link (sheet item and dialog title)
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get browserShareLink;

  /// Title of the save-location dialog
  ///
  /// In en, this message translates to:
  /// **'Save download to'**
  String get browserSaveDownloadTo;

  /// Shown when no custom download folder is set
  ///
  /// In en, this message translates to:
  /// **'App storage (default)'**
  String get browserAppStorageDefault;

  /// Button that opens the directory picker
  ///
  /// In en, this message translates to:
  /// **'Change folder…'**
  String get browserChangeFolder;

  /// Snackbar after picking a default download folder
  ///
  /// In en, this message translates to:
  /// **'Downloads will save to {path}'**
  String browserDownloadsSaveTo(String path);

  /// Snackbar when a download is enqueued
  ///
  /// In en, this message translates to:
  /// **'Downloading {name}…'**
  String browserDownloadingItem(String name);

  /// Snackbar while fetching a file for open-with
  ///
  /// In en, this message translates to:
  /// **'Opening {name}…'**
  String browserOpeningItem(String name);

  /// Error: no native app handles the file type
  ///
  /// In en, this message translates to:
  /// **'No app installed can open {name}.'**
  String browserNoAppToOpen(String name);

  /// Error opening a file
  ///
  /// In en, this message translates to:
  /// **'Could not open {name}: {error}'**
  String browserCouldNotOpen(String name, String error);

  /// Label of the rename text field
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get browserNewNameLabel;

  /// Error snackbar when a rename fails
  ///
  /// In en, this message translates to:
  /// **'Rename failed: {error}'**
  String browserRenameFailed(String error);

  /// Delete confirmation dialog title for one item
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String browserDeleteItemTitle(String name);

  /// Delete confirmation body for a folder
  ///
  /// In en, this message translates to:
  /// **'This deletes the folder and everything in it.'**
  String get browserDeleteFolderWarning;

  /// Delete confirmation body for a file
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get browserDeleteFileWarning;

  /// Error snackbar when a delete fails
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String browserDeleteFailed(String error);

  /// Delete confirmation dialog title for a selection
  ///
  /// In en, this message translates to:
  /// **'Delete {count} item(s)?'**
  String browserDeleteCountTitle(int count);

  /// Delete confirmation body for a selection
  ///
  /// In en, this message translates to:
  /// **'Selected files and folders (with their contents) will be permanently deleted. This cannot be undone.'**
  String get browserDeleteSelectedWarning;

  /// Error snackbar listing per-item delete failures
  ///
  /// In en, this message translates to:
  /// **'Delete failed for {count} item(s):\n{failures}'**
  String browserDeleteFailedFor(int count, String failures);

  /// Snackbar when a multi-item zip download is enqueued
  ///
  /// In en, this message translates to:
  /// **'Downloading {count} item(s) as zip…'**
  String browserDownloadingCountZip(int count);

  /// Destination picker title for a move
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get browserMoveTo;

  /// Destination picker title for a copy
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get browserCopyTo;

  /// Destination picker confirm for a move
  ///
  /// In en, this message translates to:
  /// **'Move here'**
  String get browserMoveHere;

  /// Destination picker confirm for a copy
  ///
  /// In en, this message translates to:
  /// **'Copy here'**
  String get browserCopyHere;

  /// Past-tense verb used in move batch summaries
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get browserVerbMoved;

  /// Past-tense verb used in copy batch summaries
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get browserVerbCopied;

  /// Batch move/copy summary when some items failed
  ///
  /// In en, this message translates to:
  /// **'{verb} {succeeded}, skipped {skipped}; {failedCount} failed:\n{failures}'**
  String browserBatchFailedSummary(String verb, int succeeded, int skipped,
      int failedCount, String failures);

  /// Batch move/copy summary when the user aborted mid-batch
  ///
  /// In en, this message translates to:
  /// **'Cancelled; {verb} {succeeded}, skipped {skipped}'**
  String browserBatchCancelledSummary(String verb, int succeeded, int skipped);

  /// Batch move/copy success summary; skippedSuffix is empty or browserSkippedSuffix
  ///
  /// In en, this message translates to:
  /// **'{verb} {succeeded} item(s){skippedSuffix}'**
  String browserBatchDoneSummary(
      String verb, int succeeded, String skippedSuffix);

  /// Suffix appended to the batch success summary when items were skipped
  ///
  /// In en, this message translates to:
  /// **', skipped {count}'**
  String browserSkippedSuffix(int count);

  /// Name-conflict dialog title
  ///
  /// In en, this message translates to:
  /// **'Already exists'**
  String get conflictTitle;

  /// Name-conflict dialog body
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" already exists in the destination.'**
  String conflictBody(String name);

  /// Checkbox to reuse the conflict choice for the rest of the batch
  ///
  /// In en, this message translates to:
  /// **'Apply to all remaining'**
  String get conflictApplyToAll;

  /// Error when a download cannot start because the session is gone
  ///
  /// In en, this message translates to:
  /// **'Cannot download: session expired. Sign in again.'**
  String get errorSessionExpiredDownload;

  /// Error when open-with cannot start because the session is gone
  ///
  /// In en, this message translates to:
  /// **'Cannot open: session expired. Sign in again.'**
  String get errorSessionExpiredOpen;

  /// Error when an upload cannot start because the session is gone
  ///
  /// In en, this message translates to:
  /// **'Cannot upload: session expired. Sign in again.'**
  String get errorSessionExpiredUpload;

  /// Error when a transfer retry cannot start because the session is gone
  ///
  /// In en, this message translates to:
  /// **'Cannot retry: session expired. Sign in again.'**
  String get errorSessionExpiredRetry;

  /// Error when sending file copies cannot start because the session is gone
  ///
  /// In en, this message translates to:
  /// **'Cannot share: session expired. Sign in again.'**
  String get errorSessionExpiredShare;

  /// Error snackbar when a folder upload fails
  ///
  /// In en, this message translates to:
  /// **'Folder upload failed: {error}'**
  String browserFolderUploadFailed(String error);

  /// Snackbar when a picked folder contains no files
  ///
  /// In en, this message translates to:
  /// **'No files found in \"{name}\"'**
  String browserNoFilesFoundIn(String name);

  /// Snackbar when a folder upload is enqueued
  ///
  /// In en, this message translates to:
  /// **'Uploading {count} file(s) from \"{name}\"…'**
  String browserUploadingCountFrom(int count, String name);

  /// Snackbar when file uploads are enqueued
  ///
  /// In en, this message translates to:
  /// **'Uploading {count} file(s)…'**
  String browserUploadingCount(int count);

  /// Snackbar fragment: number of uploads skipped due to conflicts
  ///
  /// In en, this message translates to:
  /// **'skipped {count}'**
  String browserSkippedCount(int count);

  /// Snackbar when every upload was skipped/cancelled
  ///
  /// In en, this message translates to:
  /// **'Nothing to upload'**
  String get browserNothingToUpload;

  /// Snackbar when an inbound share contains no file-backed items
  ///
  /// In en, this message translates to:
  /// **'Only files can be uploaded'**
  String get browserOnlyFilesUpload;

  /// Destination picker title for an inbound share upload
  ///
  /// In en, this message translates to:
  /// **'Upload {count} file(s) to'**
  String browserUploadCountTo(int count);

  /// Destination picker confirm for an inbound share upload
  ///
  /// In en, this message translates to:
  /// **'Upload here'**
  String get browserUploadHere;

  /// Create-folder action (menu item, dialog title, picker button)
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get browserNewFolder;

  /// Label of the new-folder name field
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get browserFolderNameLabel;

  /// Error snackbar when creating a folder fails
  ///
  /// In en, this message translates to:
  /// **'Could not create folder: {error}'**
  String browserCouldNotCreateFolder(String error);

  /// Create menu: upload files
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get browserUploadFiles;

  /// Create menu: upload files subtitle
  ///
  /// In en, this message translates to:
  /// **'Select one or more files'**
  String get browserUploadFilesSubtitle;

  /// Create menu: upload a folder
  ///
  /// In en, this message translates to:
  /// **'Upload folder'**
  String get browserUploadFolder;

  /// Create menu: upload folder subtitle
  ///
  /// In en, this message translates to:
  /// **'Uploads the folder and its contents'**
  String get browserUploadFolderSubtitle;

  /// Per-item batch error: illegal move destination
  ///
  /// In en, this message translates to:
  /// **'Can\'t move a folder into itself or a subfolder'**
  String get batchMoveIntoSelfError;

  /// Default destination picker title
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get destinationChooseFolder;

  /// Destination picker empty state (no files either)
  ///
  /// In en, this message translates to:
  /// **'No subfolders here'**
  String get destinationNoSubfolders;

  /// Destination picker empty state when only files exist
  ///
  /// In en, this message translates to:
  /// **'No subfolders ({count} file(s) hidden)'**
  String destinationNoSubfoldersHidden(int count);

  /// Confirmation snackbar after copying an error message
  ///
  /// In en, this message translates to:
  /// **'Error copied'**
  String get errorCopied;

  /// Snackbar action that copies the error text (uppercase)
  ///
  /// In en, this message translates to:
  /// **'COPY'**
  String get errorCopyAction;

  /// Shown when the modified timestamp is absent
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get fileDetailsUnknown;

  /// Confirmation snackbar after copying a detail value
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get fileDetailsCopied;

  /// Detail row label: server path
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get fileDetailsPath;

  /// Detail row label: file size
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileDetailsSize;

  /// Detail row label: modification time
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get fileDetailsModified;

  /// Detail row label: file type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fileDetailsType;

  /// Detail row label: sha256 checksum
  ///
  /// In en, this message translates to:
  /// **'sha256'**
  String get fileDetailsSha256;

  /// Shown when the server returns an empty checksum
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get fileDetailsChecksumEmpty;

  /// Checksum button label while computing
  ///
  /// In en, this message translates to:
  /// **'Computing…'**
  String get fileDetailsComputing;

  /// Button that requests the sha256 checksum
  ///
  /// In en, this message translates to:
  /// **'Compute checksum (sha256)'**
  String get fileDetailsComputeChecksum;

  /// Error shown when the checksum request fails
  ///
  /// In en, this message translates to:
  /// **'Checksum failed: {error}'**
  String fileDetailsChecksumFailed(String error);

  /// Image viewer title: 1-based position, total count, file name
  ///
  /// In en, this message translates to:
  /// **'{position} / {total}  ·  {name}'**
  String galleryTitle(int position, int total, String name);

  /// Search field hint scoped to the current folder
  ///
  /// In en, this message translates to:
  /// **'Search in {name}…'**
  String searchHint(String name);

  /// Tooltip: clear the search query
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearTooltip;

  /// Search empty-query hint
  ///
  /// In en, this message translates to:
  /// **'Type to search this folder'**
  String get searchTypeToSearch;

  /// Hint when the query is below the server minimum length
  ///
  /// In en, this message translates to:
  /// **'Keep typing (at least {min} characters)'**
  String searchKeepTyping(int min);

  /// Search no-results state
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String searchNoResults(String query);

  /// Error snackbar when creating a share link fails
  ///
  /// In en, this message translates to:
  /// **'Could not create share: {error}'**
  String shareCouldNotCreate(String error);

  /// Share result: link requires a password
  ///
  /// In en, this message translates to:
  /// **'Password protected'**
  String get sharePasswordProtected;

  /// Share result: link has no password
  ///
  /// In en, this message translates to:
  /// **'No password'**
  String get shareNoPassword;

  /// Confirmation snackbar after copying a share URL
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get shareLinkCopied;

  /// Label of the optional share password field
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get shareDialogPasswordLabel;

  /// Label of the expiry amount field
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get shareDialogExpiresLabel;

  /// Label of the expiry unit dropdown
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get shareDialogExpiryLabel;

  /// Validation error for the expiry amount
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number'**
  String get shareDialogPositiveNumber;

  /// Confirm button of the create-share dialog
  ///
  /// In en, this message translates to:
  /// **'Create link'**
  String get shareDialogCreateLink;

  /// Share chooser option: send local copies via the system share sheet
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send file} other{Send {count} files}}'**
  String shareSendCopy(num count);

  /// Subtitle of the send-copy share option when available
  ///
  /// In en, this message translates to:
  /// **'Share a copy through another app'**
  String get shareSendCopySubtitle;

  /// Subtitle of the send-copy share option when the selection contains a folder
  ///
  /// In en, this message translates to:
  /// **'Folders can\'t be sent as files'**
  String get shareSendFoldersUnsupported;

  /// Subtitle of the share-link option when available
  ///
  /// In en, this message translates to:
  /// **'Create a public link on the server'**
  String get shareLinkSubtitle;

  /// Subtitle of the share-link option when more than one item is selected
  ///
  /// In en, this message translates to:
  /// **'Select a single item to share a link'**
  String get shareLinkSelectOne;

  /// Snackbar while items download to the device before the system share sheet opens
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Preparing file…} other{Preparing {count} files…}}'**
  String sharePreparingCount(num count);

  /// Error snackbar when preparing/sending file copies fails
  ///
  /// In en, this message translates to:
  /// **'Could not send: {error}'**
  String shareCouldNotSend(String error);

  /// Confirmation title before downloading a large selection for sending
  ///
  /// In en, this message translates to:
  /// **'Send large files?'**
  String get shareLargeTitle;

  /// Confirmation body before downloading a large selection for sending
  ///
  /// In en, this message translates to:
  /// **'{size} will be downloaded to your device before sharing.'**
  String shareLargeBody(String size);

  /// Shares screen title and overflow menu item
  ///
  /// In en, this message translates to:
  /// **'Shared links'**
  String get sharesTitle;

  /// Delete-share confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete share link?'**
  String get sharesDeleteTitle;

  /// Delete-share confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'The public link for \"{path}\" will stop working. This cannot be undone.'**
  String sharesDeleteBody(String path);

  /// Error snackbar when deleting a share fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete share: {error}'**
  String sharesCouldNotDelete(String error);

  /// Shares screen empty state
  ///
  /// In en, this message translates to:
  /// **'No shared links yet'**
  String get sharesEmpty;

  /// Shares screen empty-state hint
  ///
  /// In en, this message translates to:
  /// **'Use “Share link” on a file or folder to create one.'**
  String get sharesEmptyHint;

  /// Tooltip of the per-share actions menu
  ///
  /// In en, this message translates to:
  /// **'Share actions'**
  String get sharesActionsTooltip;

  /// Share actions menu: copy the public URL
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get sharesCopyLink;

  /// Status screen title and overflow menu item
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusTitle;

  /// Status section header: disk usage
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get statusSectionStorage;

  /// Status section header: signed-in user
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get statusSectionAccount;

  /// Status section header: server info
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get statusSectionServer;

  /// Shown when the source reports no capacity
  ///
  /// In en, this message translates to:
  /// **'Disk usage unavailable'**
  String get statusDiskUsageUnavailable;

  /// Subtitle explaining missing disk usage
  ///
  /// In en, this message translates to:
  /// **'The server did not report capacity for this source.'**
  String get statusDiskUsageUnavailableHint;

  /// Disk usage line; used/total are humanized sizes, percent has one decimal
  ///
  /// In en, this message translates to:
  /// **'{used} of {total} used ({percent}%)'**
  String statusUsedOfTotal(String used, String total, String percent);

  /// Free space line; free is a humanized size
  ///
  /// In en, this message translates to:
  /// **'{free} free'**
  String statusFree(String free);

  /// Shown when the username is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get statusUnknownUser;

  /// Shown when the user has no write permissions
  ///
  /// In en, this message translates to:
  /// **'Read-only'**
  String get statusReadOnly;

  /// Comma-joined list of granted permissions
  ///
  /// In en, this message translates to:
  /// **'Permissions: {permissions}'**
  String statusPermissions(String permissions);

  /// Permission name: create
  ///
  /// In en, this message translates to:
  /// **'create'**
  String get statusPermCreate;

  /// Permission name: modify
  ///
  /// In en, this message translates to:
  /// **'modify'**
  String get statusPermModify;

  /// Server card while settings load
  ///
  /// In en, this message translates to:
  /// **'Loading server info…'**
  String get statusLoadingServerInfo;

  /// Server card when settings are inaccessible
  ///
  /// In en, this message translates to:
  /// **'Server info unavailable'**
  String get statusServerInfoUnavailable;

  /// Subtitle explaining missing server info
  ///
  /// In en, this message translates to:
  /// **'Requires an administrator account.'**
  String get statusRequiresAdmin;

  /// Server card subtitle when signup is on
  ///
  /// In en, this message translates to:
  /// **'Signup enabled'**
  String get statusSignupEnabled;

  /// Server card subtitle when signup is off
  ///
  /// In en, this message translates to:
  /// **'Signup disabled'**
  String get statusSignupDisabled;

  /// Button that opens the shares screen
  ///
  /// In en, this message translates to:
  /// **'Manage shared links'**
  String get statusManageSharedLinks;

  /// Error when fetching a text file fails
  ///
  /// In en, this message translates to:
  /// **'Could not load {name}: {error}'**
  String textViewerCouldNotLoad(String name, String error);

  /// Shown for a zero-byte text file
  ///
  /// In en, this message translates to:
  /// **'(empty file)'**
  String get textViewerEmptyFile;

  /// Shown when a text file exceeds the preview cap; size is humanized
  ///
  /// In en, this message translates to:
  /// **'Too large to preview ({size}).'**
  String textViewerTooLarge(String size);

  /// Transfers screen title and app bar tooltip
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfersTitle;

  /// Tooltip: remove completed/failed transfers from the list
  ///
  /// In en, this message translates to:
  /// **'Clear finished'**
  String get transfersClearFinished;

  /// Transfers screen empty state
  ///
  /// In en, this message translates to:
  /// **'No transfers yet'**
  String get transfersEmpty;

  /// Semantics label of the per-transfer progress bar
  ///
  /// In en, this message translates to:
  /// **'Transfer progress'**
  String get transfersProgressSemantics;

  /// Transfer status: waiting to start
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get transfersStatusQueued;

  /// Transfer status: running, with percent complete
  ///
  /// In en, this message translates to:
  /// **'Transferring {percent}%'**
  String transfersStatusTransferring(int percent);

  /// Transfer status: paused, with percent complete
  ///
  /// In en, this message translates to:
  /// **'Paused {percent}%'**
  String transfersStatusPaused(int percent);

  /// Transfer status: backing off before a retry
  ///
  /// In en, this message translates to:
  /// **'Waiting to retry…'**
  String get transfersStatusRetrying;

  /// Transfer status: finished successfully
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get transfersStatusComplete;

  /// Transfer status: failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get transfersStatusFailed;

  /// Transfer status: canceled by the user
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get transfersStatusCanceled;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appearanceMode;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceAmoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED black'**
  String get appearanceAmoled;

  /// No description provided for @appearanceAmoledHint.
  ///
  /// In en, this message translates to:
  /// **'Use a black background in dark mode'**
  String get appearanceAmoledHint;

  /// No description provided for @appearanceColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get appearanceColor;

  /// No description provided for @appearanceDynamic.
  ///
  /// In en, this message translates to:
  /// **'Material You (system colors)'**
  String get appearanceDynamic;

  /// No description provided for @appearanceDynamicHint.
  ///
  /// In en, this message translates to:
  /// **'Uses indigo when system colors are unavailable'**
  String get appearanceDynamicHint;

  /// No description provided for @appearanceIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get appearanceIndigo;

  /// No description provided for @appearanceBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get appearanceBlue;

  /// No description provided for @appearanceTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get appearanceTeal;

  /// No description provided for @appearanceGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get appearanceGreen;

  /// No description provided for @appearanceOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get appearanceOrange;

  /// No description provided for @appearancePink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get appearancePink;

  /// Error shown (and copied) when video playback fails
  ///
  /// In en, this message translates to:
  /// **'Could not play video:\n{error}'**
  String videoCouldNotPlay(String error);

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'App updates'**
  String get updateTitle;

  /// No description provided for @updateAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Check for updates automatically'**
  String get updateAutomatic;

  /// No description provided for @updateAutomaticHint.
  ///
  /// In en, this message translates to:
  /// **'Check GitHub while the app is in use'**
  String get updateAutomaticHint;

  /// No description provided for @updateCheck.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get updateCheck;

  /// No description provided for @updateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates…'**
  String get updateChecking;

  /// No description provided for @updateCurrent.
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get updateCurrent;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateLatest.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version.'**
  String get updateLatest;

  /// No description provided for @updateDownload.
  ///
  /// In en, this message translates to:
  /// **'Download update'**
  String get updateDownload;

  /// No description provided for @updateCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel download'**
  String get updateCancel;

  /// No description provided for @updateInstall.
  ///
  /// In en, this message translates to:
  /// **'Install update'**
  String get updateInstall;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateOpen.
  ///
  /// In en, this message translates to:
  /// **'View update'**
  String get updateOpen;

  /// No description provided for @updatePermission.
  ///
  /// In en, this message translates to:
  /// **'Allow this app to install updates in Android settings, then return and tap Install update again.'**
  String get updatePermission;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateError;

  /// No description provided for @updateNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get updateNotes;

  /// No description provided for @updateSize.
  ///
  /// In en, this message translates to:
  /// **'Download size'**
  String get updateSize;

  /// No description provided for @updateProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get updateProgress;

  /// No description provided for @updateTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get updateTryAgain;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
