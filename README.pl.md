[English](README.md)

# FileBrowser Quantum Mobile

[![CI](https://github.com/Adiker/filebrowser-quantum-mobile/actions/workflows/ci.yml/badge.svg)](https://github.com/Adiker/filebrowser-quantum-mobile/actions/workflows/ci.yml)
[![Najnowsze wydanie](https://img.shields.io/github/v/release/Adiker/filebrowser-quantum-mobile)](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest)
[![Licencja: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

Klient Androida dla własnego serwera lub NAS-a z [FileBrowser Quantum](https://github.com/gtsteffaniak/filebrowser). Pozwala przeglądać pliki, zarządzać nimi, przesyłać je, tworzyć linki udostępniania i wyświetlać multimedia na urządzeniu.

## Funkcje

- Przeglądanie wielu źródeł, wyszukiwanie, sortowanie, zaznaczanie plików i operacje grupowe.
- Wysyłanie i pobieranie plików, przyjmowanie plików z innych aplikacji, przekazywanie kopii oraz tworzenie linków serwera.
- Podgląd obrazów, filmów i tekstu, szczegóły plików oraz sumy kontrolne.
- Odblokowywanie zapisanych danych systemowym ekranem uwierzytelniania, jeśli urządzenie go obsługuje, oraz podgląd stanu serwera.
- Sprawdzanie stabilnych aktualizacji aplikacji i wybór momentu ich instalacji.

## Instalacja i pierwsze uruchomienie

1. Zainstaluj APK z [najnowszego wydania](https://github.com/Adiker/filebrowser-quantum-mobile/releases/latest), postępując zgodnie z komunikatami Androida.
2. Podaj adres i dane logowania działającego serwera FileBrowser Quantum. Adres bez schematu domyślnie używa HTTPS.
3. Jeśli serwer udostępnia kilka źródeł, wybierz jedno z nich i rozpocznij przeglądanie.

HTTP wymaga osobnego potwierdzenia i przesyła hasła oraz pliki bez szyfrowania. Obsługiwane jest bezpośrednie logowanie nazwą użytkownika i hasłem; interaktywne TOTP, OIDC, passkeys i logowanie przez proxy nie są obsługiwane. Szczegóły połączenia, zgodności i aktualizacji zawiera [instrukcja instalacji](docs/pl/installation.md).

## Zrzuty ekranu

<p align="center">
  <img src="docs/screenshots/browser.png" width="24%" alt="Przeglądarka plików"/>
  <img src="docs/screenshots/gallery.png" width="24%" alt="Galeria obrazów"/>
  <img src="docs/screenshots/viewer.png" width="24%" alt="Podgląd obrazu"/>
  <img src="docs/screenshots/details.png" width="24%" alt="Szczegóły pliku"/>
</p>

## Dokumentacja

| Temat | English | Polski |
|---|---|---|
| Instalacja, połączenie z serwerem i aktualizacje | [Installation](docs/en/installation.md) | [Instalacja](docs/pl/installation.md) |
| Zarządzanie plikami, transfery i rozwiązywanie problemów | [User guide](docs/en/user-guide.md) | [Przewodnik użytkownika](docs/pl/user-guide.md) |
| Tworzenie aplikacji, testy i wydania | [Contributing](CONTRIBUTING.md) | — |
| Projekt techniczny | [Architecture](ARCHITECTURE.md) | — |
| Dane i połączenia sieciowe | [Privacy policy](PRIVACY.md) | — |

Historię wydań zawiera [changelog](CHANGELOG.md). Dokumentacja jest dostępna po angielsku i polsku; nie oznacza to obsługi obu języków przez samą aplikację.

## Pochodzenie i licencja

Ten niezależny klient bazuje na [jjshoots/filebrowser_mobile](https://github.com/jjshoots/filebrowser_mobile) i [rpmlourenco/filebrowser_mobile](https://github.com/rpmlourenco/filebrowser_mobile). Ma własny identyfikator aplikacji Androida, dlatego użytkownicy tamtych aplikacji muszą zalogować się ponownie.

[Apache License 2.0](LICENSE)
