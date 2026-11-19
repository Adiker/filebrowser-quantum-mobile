# Contributing

Thanks for improving the FileBrowser Quantum Android client. Please describe the problem and include relevant tests and documentation with behavior changes.

## Setup and checks

CI uses Flutter 3.44.4 (Dart 3.12) and an Android SDK. The Android project is committed; no `flutter create` is needed. `Makefile` finds Flutter on `PATH`, or falls back to `~/flutter/bin/flutter`.

```bash
make get       # flutter pub get
make analyze   # flutter analyze
make test      # unit and widget tests; no server needed
make ci        # get, analyze and test
flutter run    # connected device or emulator
flutter build apk --debug
```

Format changed Dart files with `dart format` and keep `flutter analyze` clean. Add or update tests for changed behavior. CI runs analysis and unit/widget tests with coverage, an Android debug APK build, and API integration tests. Device-dependent flows also need testing on an Android device when affected.

## Integration tests

`test/integration/quantum_api_test.dart` tests the API client against a real Quantum server without an emulator. Integration tests are skipped by default.

```bash
make serve     # run the test server in the foreground
make e2e       # start the server, run integration tests, stop it
```

`tool/serve.sh` downloads Quantum `v2.0.2-stable` by default and stores generated data in `.quantum-test/`. Set `FB_TEST_RELEASE` to choose another release, `FB_TEST_WORK_DIR` to isolate its data, and `FB_TEST_URL` / `FB_TEST_PORT` when configuring the endpoint and server port. The harness seeds test credentials and data; use it only as a test server. For an already-running server, use `FB_TEST_URL=... flutter test --tags integration --run-skipped`.

## Localization and documentation

Edit `lib/l10n/app_en.arb`, preserving placeholders, then run `flutter gen-l10n` and include the generated localization files. New locales need an appropriate ARB file and translations. Update the English and Polish user guides together for user-facing changes; update [ARCHITECTURE.md](ARCHITECTURE.md) for technical changes and [CHANGELOG.md](CHANGELOG.md) for user-visible changes. See [AGENTS.md](AGENTS.md) for project-specific guardrails.

## Releases (maintainers)

Update `version: X.Y.Z+build` in `pubspec.yaml` and add a matching `## X.Y.Z` section to `CHANGELOG.md`. Increasing the build number alone does not create a new release version. Run the GitHub Actions **Release** workflow manually on the intended commit: it validates, builds and uploads a signed APK artifact. Select **publish** to create the `vX.Y.Z` tag and GitHub Release; changing the version or running without this option does not publish a release. If the tag already exists, a publish run skips the build and release steps.

The workflow requires the four Android signing secrets listed in [release.yml](.github/workflows/release.yml). It checks the application ID, release signature and compatibility with the previous stable release. Preserve the signing key and increase `versionCode` for in-place updates. Local release builds without configured signing fall back to the debug key; never distribute a debug-signed APK. Do not commit keystores, passwords or `android/key.properties`.
