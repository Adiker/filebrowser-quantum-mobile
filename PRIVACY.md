# Privacy Policy

**App:** File Browser Mobile (`com.filebrowser_quantum_mobile`)
**Last updated:** 2026-07-28

File Browser Mobile is a client app for self-hosted [FileBrowser Quantum](https://filebrowserquantum.com/) servers. It connects to the server address you enter and, when update checks are enabled or requested, to GitHub.

## Data we collect

None. The app has no analytics, no crash reporting, no advertising, and no tracking of any kind. The developer never receives any data from your device.

## Data stored on your device

- **Server address and login credentials** — stored locally in Android's encrypted storage (Android Keystore via `flutter_secure_storage`) so you can sign in again without retyping them. They are sent to the server you configured over the connection you configured. HTTP sends credentials and files without encryption after your confirmation.
- **Biometric unlock** — if you enable it, authentication is handled entirely by Android's system biometric prompt. The app never sees, stores, or transmits your fingerprint or face data.
- **Preferences** (sort order, view settings) — stored locally.
- **Downloaded files and cached thumbnails** — stored locally in the app's storage.

All of this is deleted when you uninstall the app or clear its data.

## Network traffic

The app communicates with the File Browser server you configure. Update checks contact the GitHub API, and update downloads use GitHub and its asset hosting. GitHub receives your IP address and standard request information. Automatic checks can be disabled in App updates; manual checks still contact GitHub. No server credentials are sent to GitHub. There are no telemetry endpoints. The privacy of data on your server is governed by whoever operates that server — typically you.

## Permissions

- **Internet** — to reach your server and GitHub for updates.
- **Install packages** — to request installation of an update after your confirmation. Android may ask you to allow this source.
- **Biometrics** — optional app unlock.
- **Notifications / foreground service** — progress for background uploads and downloads.

## Children

The app does not collect data from anyone, including children.

## Changes

Changes to this policy will be published at this URL with an updated date.

## Contact

Questions: open an issue on this repository or email jet@eluve.com.
