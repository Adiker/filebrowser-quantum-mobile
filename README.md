[Polski](README.pl.md)

# FileBrowser Quantum Mobile

[![CI](https://github.com/Adiker/filebrowser-quantum-mobile/actions/workflows/ci.yml/badge.svg)](https://github.com/Adiker/filebrowser-quantum-mobile/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/Adiker/filebrowser-quantum-mobile)](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

An Android client for a self-hosted [FileBrowser Quantum](https://github.com/gtsteffaniak/filebrowser) server or NAS. Browse and manage files, transfer them, create share links, and view media from your device.

## Features

- Browse multiple sources, search, sort, select files and perform batch operations.
- Upload and download files, share into the app, send copies to other apps, or create server share links.
- View images, video and text; inspect file details and checksums.
- Unlock saved credentials with the device authentication prompt when supported and check server status.
- Check for stable app updates and choose when to install them.

## Install and start

1. Install the APK from the [latest release](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest), following Android's prompts.
2. Enter the address and credentials of your running FileBrowser Quantum server. An address without a scheme defaults to HTTPS.
3. Select a source if the server offers more than one, then browse your files.

HTTP requires explicit confirmation and sends credentials and files without encryption. Direct username/password login is supported; interactive TOTP, OIDC, passkeys and proxy-based login are not. See the [installation guide](docs/en/installation.md) for updates, compatibility and connection details.

## Screenshots

<p align="center">
  <img src="docs/screenshots/browser.png" width="24%" alt="File browser"/>
  <img src="docs/screenshots/gallery.png" width="24%" alt="Image gallery"/>
  <img src="docs/screenshots/viewer.png" width="24%" alt="Image viewer"/>
  <img src="docs/screenshots/details.png" width="24%" alt="File details"/>
</p>

## Documentation

| Topic | English | Polski |
|---|---|---|
| Installation, server connection and updates | [Installation](docs/en/installation.md) | [Instalacja](docs/pl/installation.md) |
| File management, transfers and troubleshooting | [User guide](docs/en/user-guide.md) | [Przewodnik użytkownika](docs/pl/user-guide.md) |
| Development, tests and releases | [Contributing](CONTRIBUTING.md) | — |
| Technical design | [Architecture](ARCHITECTURE.md) | — |
| Data and network access | [Privacy policy](PRIVACY.md) | — |

See the [changelog](CHANGELOG.md) for release history. The documentation is available in English and Polish; this does not imply that the app itself supports both languages.

## Origins and license

This independent client is based on [jjshoots/filebrowser_mobile](https://github.com/jjshoots/filebrowser_mobile) and [rpmlourenco/filebrowser_mobile](https://github.com/rpmlourenco/filebrowser_mobile). It has its own Android application ID, so existing installations of those apps require a fresh sign-in.

[Apache License 2.0](LICENSE)
