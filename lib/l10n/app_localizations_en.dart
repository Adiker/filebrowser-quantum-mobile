// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'File Browser';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionDownload => 'Download';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionShare => 'Share';

  @override
  String get actionMove => 'Move';

  @override
  String get actionDone => 'Done';

  @override
  String get actionDetails => 'Details';

  @override
  String get actionOpenWith => 'Open with…';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionResume => 'Resume';

  @override
  String get actionLock => 'Lock';

  @override
  String get actionSignOutForget => 'Sign out & forget';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionKeepBoth => 'Keep both';

  @override
  String get actionOverwrite => 'Overwrite';

  @override
  String get actionContinue => 'Continue';

  @override
  String get loginTitle => 'Connect to File Browser';

  @override
  String get loginServerUrlLabel => 'Server URL';

  @override
  String get loginServerUrlHint => 'https://files.example.com';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginValidationRequired => 'Required';

  @override
  String get loginValidationUrl => 'Enter a valid HTTP or HTTPS server URL';

  @override
  String get loginHttpsFailedTitle => 'HTTPS connection failed';

  @override
  String loginHttpsFailedBody(String url) {
    return 'Could not connect securely. You can try $url, but your password, session token, and files will be sent without encryption. Anyone able to observe this connection may read them. Continue only if you trust the network.';
  }

  @override
  String get loginHttpWarningTitle => 'Unencrypted connection';

  @override
  String get loginHttpWarningBody =>
      'Your password, session token, and files will be sent without encryption. Anyone able to observe this connection may read them. Continue only if you trust the network.';

  @override
  String get loginHttpCancel => 'Cancel';

  @override
  String get loginHttpConfirm => 'Connect over HTTP';

  @override
  String get loginContinue => 'Continue';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get lockTitle => 'File Browser is locked';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockUseDifferentServer => 'Use a different server';

  @override
  String get sourceSelectTitle => 'Choose a source';

  @override
  String get sourceChange => 'Change source';

  @override
  String sourceCurrent(String name) {
    return 'Current source: $name';
  }

  @override
  String get sourceLoadError => 'Could not load sources. Please try again.';

  @override
  String get sourceChangeError => 'Could not change source. Please try again.';

  @override
  String get sourceEmpty => 'No sources are available.';

  @override
  String lockWithUser(String username) {
    return 'Lock ($username)';
  }

  @override
  String get breadcrumbsRoot => 'Files';

  @override
  String get browserUpTooltip => 'Up';

  @override
  String get browserSearchTooltip => 'Search';

  @override
  String get browserSortTooltip => 'Sort';

  @override
  String get browserRefreshTooltip => 'Refresh';

  @override
  String get browserMoreOptionsTooltip => 'More options';

  @override
  String get browserViewTooltip => 'View options';

  @override
  String get browserViewGrid => 'Grid';

  @override
  String get browserViewList => 'List';

  @override
  String get browserViewSize => 'Item size';

  @override
  String get sortName => 'Name';

  @override
  String get sortSize => 'Size';

  @override
  String get sortDateModified => 'Date modified';

  @override
  String get browserMenuDownloadFolder => 'Download folder';

  @override
  String get browserEmptyFolder => 'This folder is empty';

  @override
  String browserSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get browserExitSelectionTooltip => 'Exit selection';

  @override
  String get browserSelectAll => 'Select all';

  @override
  String get browserDeselectAll => 'Deselect all';

  @override
  String get browserDownloadAsZip => 'Download as zip';

  @override
  String get browserShareLink => 'Share link';

  @override
  String get browserSaveDownloadTo => 'Save download to';

  @override
  String get browserAppStorageDefault => 'App storage (default)';

  @override
  String get browserChangeFolder => 'Change folder…';

  @override
  String browserDownloadsSaveTo(String path) {
    return 'Downloads will save to $path';
  }

  @override
  String browserDownloadingItem(String name) {
    return 'Downloading $name…';
  }

  @override
  String browserOpeningItem(String name) {
    return 'Opening $name…';
  }

  @override
  String browserNoAppToOpen(String name) {
    return 'No app installed can open $name.';
  }

  @override
  String browserCouldNotOpen(String name, String error) {
    return 'Could not open $name: $error';
  }

  @override
  String get browserNewNameLabel => 'New name';

  @override
  String browserRenameFailed(String error) {
    return 'Rename failed: $error';
  }

  @override
  String browserDeleteItemTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get browserDeleteFolderWarning =>
      'This deletes the folder and everything in it.';

  @override
  String get browserDeleteFileWarning => 'This cannot be undone.';

  @override
  String browserDeleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String browserDeleteCountTitle(int count) {
    return 'Delete $count item(s)?';
  }

  @override
  String get browserDeleteSelectedWarning =>
      'Selected files and folders (with their contents) will be permanently deleted. This cannot be undone.';

  @override
  String browserDeleteFailedFor(int count, String failures) {
    return 'Delete failed for $count item(s):\n$failures';
  }

  @override
  String browserDownloadingCountZip(int count) {
    return 'Downloading $count item(s) as zip…';
  }

  @override
  String get browserMoveTo => 'Move to';

  @override
  String get browserCopyTo => 'Copy to';

  @override
  String get browserMoveHere => 'Move here';

  @override
  String get browserCopyHere => 'Copy here';

  @override
  String get browserVerbMoved => 'Moved';

  @override
  String get browserVerbCopied => 'Copied';

  @override
  String browserBatchFailedSummary(
    String verb,
    int succeeded,
    int skipped,
    int failedCount,
    String failures,
  ) {
    return '$verb $succeeded, skipped $skipped; $failedCount failed:\n$failures';
  }

  @override
  String browserBatchCancelledSummary(String verb, int succeeded, int skipped) {
    return 'Cancelled; $verb $succeeded, skipped $skipped';
  }

  @override
  String browserBatchDoneSummary(
    String verb,
    int succeeded,
    String skippedSuffix,
  ) {
    return '$verb $succeeded item(s)$skippedSuffix';
  }

  @override
  String browserSkippedSuffix(int count) {
    return ', skipped $count';
  }

  @override
  String get conflictTitle => 'Already exists';

  @override
  String conflictBody(String name) {
    return '\"$name\" already exists in the destination.';
  }

  @override
  String get conflictApplyToAll => 'Apply to all remaining';

  @override
  String get errorSessionExpiredDownload =>
      'Cannot download: session expired. Sign in again.';

  @override
  String get errorSessionExpiredOpen =>
      'Cannot open: session expired. Sign in again.';

  @override
  String get errorSessionExpiredUpload =>
      'Cannot upload: session expired. Sign in again.';

  @override
  String get errorSessionExpiredRetry =>
      'Cannot retry: session expired. Sign in again.';

  @override
  String get errorSessionExpiredShare =>
      'Cannot share: session expired. Sign in again.';

  @override
  String browserFolderUploadFailed(String error) {
    return 'Folder upload failed: $error';
  }

  @override
  String browserNoFilesFoundIn(String name) {
    return 'No files found in \"$name\"';
  }

  @override
  String browserUploadingCountFrom(int count, String name) {
    return 'Uploading $count file(s) from \"$name\"…';
  }

  @override
  String browserUploadingCount(int count) {
    return 'Uploading $count file(s)…';
  }

  @override
  String browserSkippedCount(int count) {
    return 'skipped $count';
  }

  @override
  String get browserNothingToUpload => 'Nothing to upload';

  @override
  String get browserOnlyFilesUpload => 'Only files can be uploaded';

  @override
  String browserUploadCountTo(int count) {
    return 'Upload $count file(s) to';
  }

  @override
  String get browserUploadHere => 'Upload here';

  @override
  String get browserNewFolder => 'New folder';

  @override
  String get browserFolderNameLabel => 'Folder name';

  @override
  String browserCouldNotCreateFolder(String error) {
    return 'Could not create folder: $error';
  }

  @override
  String get browserUploadFiles => 'Upload files';

  @override
  String get browserUploadFilesSubtitle => 'Select one or more files';

  @override
  String get browserUploadFolder => 'Upload folder';

  @override
  String get browserUploadFolderSubtitle =>
      'Uploads the folder and its contents';

  @override
  String get batchMoveIntoSelfError =>
      'Can\'t move a folder into itself or a subfolder';

  @override
  String get destinationChooseFolder => 'Choose folder';

  @override
  String get destinationNoSubfolders => 'No subfolders here';

  @override
  String destinationNoSubfoldersHidden(int count) {
    return 'No subfolders ($count file(s) hidden)';
  }

  @override
  String get errorCopied => 'Error copied';

  @override
  String get errorCopyAction => 'COPY';

  @override
  String get fileDetailsUnknown => 'Unknown';

  @override
  String get fileDetailsCopied => 'Copied';

  @override
  String get fileDetailsPath => 'Path';

  @override
  String get fileDetailsSize => 'Size';

  @override
  String get fileDetailsModified => 'Modified';

  @override
  String get fileDetailsType => 'Type';

  @override
  String get fileDetailsSha256 => 'sha256';

  @override
  String get fileDetailsChecksumEmpty => '(empty)';

  @override
  String get fileDetailsComputing => 'Computing…';

  @override
  String get fileDetailsComputeChecksum => 'Compute checksum (sha256)';

  @override
  String fileDetailsChecksumFailed(String error) {
    return 'Checksum failed: $error';
  }

  @override
  String galleryTitle(int position, int total, String name) {
    return '$position / $total  ·  $name';
  }

  @override
  String searchHint(String name) {
    return 'Search in $name…';
  }

  @override
  String get searchClearTooltip => 'Clear';

  @override
  String get searchTypeToSearch => 'Type to search this folder';

  @override
  String searchKeepTyping(int min) {
    return 'Keep typing (at least $min characters)';
  }

  @override
  String searchNoResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String shareCouldNotCreate(String error) {
    return 'Could not create share: $error';
  }

  @override
  String get sharePasswordProtected => 'Password protected';

  @override
  String get shareNoPassword => 'No password';

  @override
  String get shareLinkCopied => 'Link copied';

  @override
  String get shareDialogPasswordLabel => 'Password (optional)';

  @override
  String get shareDialogExpiresLabel => 'Expires';

  @override
  String get shareDialogExpiryLabel => 'Expiry';

  @override
  String get shareDialogPositiveNumber => 'Enter a positive number';

  @override
  String get shareDialogCreateLink => 'Create link';

  @override
  String shareSendCopy(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send $count files',
      one: 'Send file',
    );
    return '$_temp0';
  }

  @override
  String get shareSendCopySubtitle => 'Share a copy through another app';

  @override
  String get shareSendFoldersUnsupported => 'Folders can\'t be sent as files';

  @override
  String get shareLinkSubtitle => 'Create a public link on the server';

  @override
  String get shareLinkSelectOne => 'Select a single item to share a link';

  @override
  String sharePreparingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preparing $count files…',
      one: 'Preparing file…',
    );
    return '$_temp0';
  }

  @override
  String shareCouldNotSend(String error) {
    return 'Could not send: $error';
  }

  @override
  String get shareLargeTitle => 'Send large files?';

  @override
  String shareLargeBody(String size) {
    return '$size will be downloaded to your device before sharing.';
  }

  @override
  String get sharesTitle => 'Shared links';

  @override
  String get sharesDeleteTitle => 'Delete share link?';

  @override
  String sharesDeleteBody(String path) {
    return 'The public link for \"$path\" will stop working. This cannot be undone.';
  }

  @override
  String sharesCouldNotDelete(String error) {
    return 'Could not delete share: $error';
  }

  @override
  String get sharesEmpty => 'No shared links yet';

  @override
  String get sharesEmptyHint =>
      'Use “Share link” on a file or folder to create one.';

  @override
  String get sharesActionsTooltip => 'Share actions';

  @override
  String get sharesCopyLink => 'Copy link';

  @override
  String get statusTitle => 'Status';

  @override
  String get statusSectionStorage => 'Storage';

  @override
  String get statusSectionAccount => 'Account';

  @override
  String get statusSectionServer => 'Server';

  @override
  String get statusDiskUsageUnavailable => 'Disk usage unavailable';

  @override
  String get statusDiskUsageUnavailableHint =>
      'The server did not report capacity for this source.';

  @override
  String statusUsedOfTotal(String used, String total, String percent) {
    return '$used of $total used ($percent%)';
  }

  @override
  String statusFree(String free) {
    return '$free free';
  }

  @override
  String get statusUnknownUser => 'Unknown user';

  @override
  String get statusReadOnly => 'Read-only';

  @override
  String statusPermissions(String permissions) {
    return 'Permissions: $permissions';
  }

  @override
  String get statusPermCreate => 'create';

  @override
  String get statusPermModify => 'modify';

  @override
  String get statusLoadingServerInfo => 'Loading server info…';

  @override
  String get statusServerInfoUnavailable => 'Server info unavailable';

  @override
  String get statusRequiresAdmin => 'Requires an administrator account.';

  @override
  String get statusSignupEnabled => 'Signup enabled';

  @override
  String get statusSignupDisabled => 'Signup disabled';

  @override
  String get statusManageSharedLinks => 'Manage shared links';

  @override
  String textViewerCouldNotLoad(String name, String error) {
    return 'Could not load $name: $error';
  }

  @override
  String get textViewerEmptyFile => '(empty file)';

  @override
  String textViewerTooLarge(String size) {
    return 'Too large to preview ($size).';
  }

  @override
  String get transfersTitle => 'Transfers';

  @override
  String get transfersClearFinished => 'Clear finished';

  @override
  String get transfersEmpty => 'No transfers yet';

  @override
  String get transfersProgressSemantics => 'Transfer progress';

  @override
  String get transfersStatusQueued => 'Queued';

  @override
  String transfersStatusTransferring(int percent) {
    return 'Transferring $percent%';
  }

  @override
  String transfersStatusPaused(int percent) {
    return 'Paused $percent%';
  }

  @override
  String get transfersStatusRetrying => 'Waiting to retry…';

  @override
  String get transfersStatusComplete => 'Complete';

  @override
  String get transfersStatusFailed => 'Failed';

  @override
  String get transfersStatusCanceled => 'Canceled';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceMode => 'Theme';

  @override
  String get appearanceSystem => 'System default';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceAmoled => 'AMOLED black';

  @override
  String get appearanceAmoledHint => 'Use a black background in dark mode';

  @override
  String get appearanceColor => 'Accent color';

  @override
  String get appearanceDynamic => 'Material You (system colors)';

  @override
  String get appearanceDynamicHint =>
      'Uses indigo when system colors are unavailable';

  @override
  String get appearanceIndigo => 'Indigo';

  @override
  String get appearanceBlue => 'Blue';

  @override
  String get appearanceTeal => 'Teal';

  @override
  String get appearanceGreen => 'Green';

  @override
  String get appearanceOrange => 'Orange';

  @override
  String get appearancePink => 'Pink';

  @override
  String videoCouldNotPlay(String error) {
    return 'Could not play video:\n$error';
  }
}
