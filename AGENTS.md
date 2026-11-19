# AGENTS.md — FileBrowser Quantum Mobile

Read [ARCHITECTURE.md](ARCHITECTURE.md) for the technical overview and [CONTRIBUTING.md](CONTRIBUTING.md) for development, test and release commands. Follow the user's instructions and preserve unrelated work in the working tree.

## Project-specific guardrails

- This is an independent Flutter/Android client for FileBrowser Quantum. Preserve the Android application ID and release-signing compatibility unless an explicit migration is intended.
- Credentials, tokens and authenticated media must not leak through redirects or logs. HTTP requires explicit user consent; keep that behavior across login and transfer paths.
- Background downloader tasks and in-process chunked uploads have different lifecycle and resume behavior. Test changes against the correct path; widget tests cannot establish real device behavior.
- `lib/l10n/app_en.arb` is the localization template. Regenerate the tracked `app_localizations*.dart` files after changing strings; do not edit generated files by hand.
- `third_party/video_player_android` is a local dependency override with a security modification. Read its `README.local.md` before updating it.
- Keep user-facing English and Polish guides aligned when behavior changes; update the technical reference and changelog when relevant. Do not claim untested device behavior.
- Run checks appropriate to the change; documentation-only changes need link and reference checks rather than a full Android build. Never commit credentials, signing keys or test-server state.
