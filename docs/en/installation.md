[Home](../../README.md) · [Polski](../pl/installation.md) · [User guide](user-guide.md)

# Installation and updates

## Requirements and first connection

Install the APK from the [latest GitHub release](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest) on an Android device and follow the system installation prompts. You need a reachable [FileBrowser Quantum](https://github.com/gtsteffaniak/filebrowser) server and an account permitted to use it. The app is an independent client with its own application ID; credentials from other clients are not migrated.

Enter the server address, username and password. Addresses without a scheme use HTTPS. Explicit HTTP requires confirmation: credentials, tokens and file data travel unencrypted, so use it only on a trusted network. API redirects are rejected; configure the final server address directly. Image and background-transfer requests also do not follow redirects, and Android video rejects cross-protocol redirects. HTTP media and background transfers require device testing.

Login is directly with username and password. Interactive TOTP, OIDC, passkeys and proxy-based login are not supported. Saved credentials use Android-backed secure storage. On a supported device, unlocking can use the system biometric prompt or device credential; availability depends on the device.

## Updating

While the app is in use, automatic checks query GitHub for stable releases at most once per 24 hours. Use **Status → App updates** to disable automatic checks or check manually. GitHub receives your IP address when checking or downloading. You choose when to download and install, and Android may request permission to install packages from this app. The first version containing the updater must itself be installed manually.

Android can update an existing installation only if the APK retains the application ID and signing key and has a higher `versionCode`. An APK signed with a different key cannot update it in place. See the [privacy policy](../../PRIVACY.md) for data handling.

## Building from source

The committed Android project requires Flutter and the Android SDK; CI uses Flutter 3.44.4. For development setup, signing and tests, see [Contributing](../../CONTRIBUTING.md). A local release build without configured release signing falls back to a debug key and must not be distributed.
