# Architecture — FileBrowser Quantum Mobile

This is a Flutter Android client for a self-hosted FileBrowser Quantum server. For contributor commands and release procedure see [CONTRIBUTING.md](CONTRIBUTING.md); for user-facing behavior see the [English](docs/en/user-guide.md) and [Polish](docs/pl/user-guide.md) guides.

## Structure and data flow

- `lib/main.dart` initializes the app; `lib/src/app.dart` wires providers, lifecycle and the authentication gate.
- `lib/src/auth/` manages credentials, the device-authentication gate, JWT lifetime and source selection. `lib/src/data/` stores non-secret preferences.
- `lib/src/api/` implements the HTTP client, models, authenticated image caching and share-link construction. `lib/src/ui/` contains screens, shared actions and selection logic.
- `lib/src/transfers/` unifies background-downloader tasks and in-process chunked uploads for the transfers UI. `lib/src/update/` checks GitHub releases, downloads APKs and coordinates installation.
- `android/` holds the committed native host, Android configuration and update installation bridge. `lib/l10n/` holds the localization template and generated Dart files. `test/` includes unit, widget and API integration tests; `tool/` contains supporting scripts.

## Authentication and network safety

`AuthController` stores the server URL and credentials through `SecureStore`, then signs in directly and selects a source. On subsequent unlock, a supported device uses Android's biometric/device credential prompt; an unsupported device proceeds without that prompt. A valid cached JWT is reused, otherwise the stored credentials allow direct login. Tokens are refreshed when needed; the API client makes at most one renewal and replay attempt after a 401. A consumed request stream cannot be replayed automatically.

A missing URL scheme defaults to HTTPS. Explicit HTTP requires consent for the normalized server address; credentials, tokens and files are unencrypted over HTTP. API redirects are rejected to avoid forwarding sensitive headers; image and background-transfer requests do not follow redirects. Android video playback rejects cross-protocol redirects. The manifest disables backup and device-to-device transfer of app data. Changes in these paths require targeted security and device validation.

## Server API


All endpoints are under `/api`. `<S>` is the current source name; paths are
passed as query parameters (not URL segments), and every path-scoped call carries
`source=<S>`.

| Action       | Request                                                                  |
| ------------ | ------------------------------------------------------------------------ |
| Login        | `POST /api/auth/login?username=<u>` , headers `X-Password`, `X-Secret` → JWT text |
| Renew        | `POST /api/auth/renew` → JWT text                                         |
| Sources      | `GET /api/settings/sources` → `{ "<S>": { used, usedAlt, total, … } }`    |
| List dir     | `GET /api/resources?path=<p>&source=<S>` → `{folders[], files[]}`         |
| Checksum     | `GET /api/resources?path=<p>&source=<S>&checksum=<algo>`                  |
| Download     | `GET /api/resources/download?source=<S>&file=<p>` (repeat `file=` + `algo=zip` to bundle) |
| Preview      | `GET /api/resources/preview?source=<S>&path=<p>&size=<small\|large\|original>` |
| Upload       | `POST /api/resources?path=<p>&source=<S>&override=…`, raw bytes as the body |
| Chunked upload | same POST with `X-File-Chunk-Offset` / `X-File-Total-Size` / `X-File-Upload-Session` headers per chunk; server finalizes on the last chunk |
| Pause upload | `POST /api/resources/pause?path=<p>&source=<S>` (preserves the server-side partial for resume) |
| New folder   | `POST /api/resources?path=<p>&source=<S>&isDir=true`                      |
| Delete       | `DELETE /api/resources?path=<p>&source=<S>`                               |
| Move / copy  | `PATCH /api/resources`, JSON `{action, items:[{fromSource,fromPath,toSource,toPath}], overwrite, rename}` |
| Search       | `GET /api/tools/search?query=<q>&sources=<S>&scope=<base/>` → JSON array  |
| Disk usage   | `GET /api/settings/sources` → per-source `usedAlt` / `total`             |
| Shares       | `GET /api/share/list`, `GET/POST /api/share`, `DELETE /api/share?hash=…`  |
| Settings     | `GET /api/settings` (admin-only capabilities/branding; degrades on 403)   |

All authenticated requests send the JWT in the `Authorization: Bearer <jwt>`
header. Token renewal is handled by an interceptor that performs at most one
renew + replay per request. Public share pages are served at
`/public/share/<hash>`.

## Transfers and Android integration

Downloads and small uploads use `background_downloader` and Android foreground-service notifications. Uploads larger than the 10 MiB chunk size use `ChunkedUploadTask` in the app process, with sequential offsets. A graceful pause signals the server to preserve the partial file; a transport error mid-chunk restarts from zero. Process termination can interrupt the chunked path. The transfer record unifies progress for both engines. Android SAF handles destination selection, while intent filters receive shared files and Android's share/open handlers hand files to other apps.

The application ID is `com.adiker.filebrowser_quantum_mobile`; the Android namespace is separate. `MainActivity` uses `FlutterFragmentActivity` for `local_auth`. The manifest declares network, biometric, notification, foreground-service and package-install permissions, share intent filters and an update `FileProvider`. Android SDK versions and Java configuration are defined in `android/app/build.gradle.kts`.

## Updates and releases

`UpdateController` checks stable GitHub releases during app use, no more than once per 24 hours for automatic checks. `UpdateService` validates release metadata and restricts APK downloads and redirects to HTTPS; Android handles the installation prompt via the native bridge. The user controls download and installation. The manual release workflow builds and validates a signed APK and optionally publishes it. See [CONTRIBUTING.md](CONTRIBUTING.md) and [release.yml](.github/workflows/release.yml) for the exact workflow and compatibility checks.

## Localization, tests and dependencies

`lib/l10n/app_en.arb` is the source template configured in `l10n.yaml`; `flutter gen-l10n` produces the tracked `app_localizations*.dart` files. Widget tests can use `test/support/l10n.dart` to install delegates.

`make ci` runs dependency resolution, analysis and unit/widget tests. `make e2e` runs tagged API tests against the server started by `tool/serve.sh`; CI additionally builds a debug Android APK and publishes coverage. These API tests do not replace physical-device tests for Android storage, media, notifications, sharing or installation. See [CONTRIBUTING.md](CONTRIBUTING.md) for commands and test server configuration.

Flutter dependencies are declared in `pubspec.yaml`. The local `video_player_android` override under `third_party/` is based on version 2.12.2 and disables cross-protocol media redirects; see its [local modification note](third_party/video_player_android/README.local.md) and license before updating it.
