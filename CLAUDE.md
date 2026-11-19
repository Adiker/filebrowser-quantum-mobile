# CLAUDE.md — FileBrowser Quantum Mobile

Read [AGENTS.md](AGENTS.md) first for project-specific working rules. [ARCHITECTURE.md](ARCHITECTURE.md) describes the Flutter/Android design and security-sensitive paths; [CONTRIBUTING.md](CONTRIBUTING.md) covers setup, tests and releases. User guides live in `docs/en/` and `docs/pl/`.

## Quick start

```bash
make ci       # dependencies, analysis, unit/widget tests
make e2e      # local Quantum server and API integration tests
flutter run   # connected Android device or emulator
```

CI pins Flutter 3.44.4. Keep this file short: put durable technical detail in the architecture reference and agent-specific pitfalls in AGENTS.md.
