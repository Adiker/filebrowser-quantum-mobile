[Strona główna](../../README.pl.md) · [English](../en/installation.md) · [Przewodnik użytkownika](user-guide.md)

# Instalacja i aktualizacje

## Wymagania i pierwsze połączenie

Zainstaluj APK z [najnowszego wydania na GitHubie](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest) na urządzeniu z Androidem i postępuj zgodnie z komunikatami systemu. Potrzebny jest dostępny [serwer FileBrowser Quantum](https://github.com/gtsteffaniak/filebrowser) oraz konto z odpowiednimi uprawnieniami. Aplikacja jest niezależnym klientem z własnym identyfikatorem; dane logowania z innych klientów nie są przenoszone.

Podaj adres serwera, nazwę użytkownika i hasło. Adres bez schematu używa HTTPS. Jawne HTTP wymaga potwierdzenia: dane logowania, tokeny i pliki są przesyłane bez szyfrowania, więc korzystaj z niego wyłącznie w zaufanej sieci. Przekierowania API są odrzucane; skonfiguruj bezpośredni adres serwera. Żądania obrazów i transferów w tle również nie podążają za przekierowaniami, a odtwarzacz wideo Androida odrzuca przekierowania między protokołami. Multimedia i transfery przez HTTP wymagają testów na urządzeniu.

Logowanie odbywa się bezpośrednio nazwą użytkownika i hasłem. Interaktywne TOTP, OIDC, passkeys i logowanie przez proxy nie są obsługiwane. Dane logowania są zapisywane w bezpiecznej pamięci Androida. Na obsługiwanym urządzeniu odblokowanie może używać systemowego okna biometrycznego lub blokady urządzenia; dostępność zależy od urządzenia.

## Aktualizacje

Podczas korzystania z aplikacji automatyczne sprawdzanie stabilnych wydań na GitHubie odbywa się najwyżej raz na 24 godziny. W **Status → App updates** można je wyłączyć lub sprawdzić aktualizację ręcznie. GitHub otrzymuje adres IP podczas sprawdzania i pobierania. Użytkownik decyduje o pobraniu i instalacji, a Android może poprosić o zgodę na instalowanie pakietów z tej aplikacji. Pierwszą wersję zawierającą mechanizm aktualizacji trzeba zainstalować ręcznie.

Aktualizacja istniejącej instalacji wymaga tego samego identyfikatora aplikacji i klucza podpisu oraz wyższego `versionCode`. APK podpisane innym kluczem nie zaktualizuje jej w miejscu. Informacje o danych zawiera [polityka prywatności](../../PRIVACY.md).

## Budowanie ze źródeł

Zawarty w repozytorium projekt Androida wymaga Fluttera i Android SDK; CI używa Fluttera 3.44.4. Konfigurację środowiska, podpisywanie i testy opisuje [Contributing](../../CONTRIBUTING.md). Lokalny build release bez skonfigurowanego podpisu wydania używa klucza debug i nie może być rozpowszechniany.
