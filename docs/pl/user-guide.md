[Strona główna](../../README.pl.md) · [English](../en/user-guide.md) · [Instalacja](installation.md)

# Przewodnik użytkownika

## Przeglądanie i zarządzanie plikami

Po zalogowaniu pojedyncze źródło jest wybierane automatycznie; przy kilku źródłach wybierz jedno z nich. Poruszaj się za pomocą ścieżki nawigacyjnej, przełączaj widok listy i siatki, zmieniaj rozmiar elementów oraz sortuj według nazwy, rozmiaru lub daty. Wyszukiwanie obejmuje bieżące źródło i wymaga co najmniej trzech znaków.

Użyj akcji elementu lub zaznacz kilka pozycji, aby je skopiować, przenieść, usunąć lub pobrać. Przy kopiowaniu i przenoszeniu dostępny jest wybór folderu docelowego. Możesz tworzyć foldery, zmieniać nazwy i sprawdzać szczegóły pliku; sumy kontrolne są obliczane na żądanie. Ekran stanu pokazuje konto, zajętość dysku i dostępne możliwości serwera.

## Podgląd i udostępnianie

Otwieraj obrazy w galerii, odtwarzaj filmy i wyświetlaj tekst. Menu podglądu zawiera również akcje pliku. Możesz utworzyć link serwera z opcjonalnym hasłem i terminem wygaśnięcia, zarządzać istniejącymi linkami lub przekazać lokalne kopie przez menu udostępniania Androida. Przed przekazaniem kopie są pobierane do pamięci podręcznej; transfer przekraczający 100 MiB wymaga potwierdzenia. Folderów nie można przekazać jako kopii.

Możesz udostępnić pliki z innej aplikacji Androida do tego klienta i wybrać folder docelowy wysyłania. Opcja **Open with** przekazuje pobrany plik do innej zainstalowanej aplikacji. Działanie tych funkcji zależy od obsługi intencji Androida i zainstalowanych aplikacji.

## Transfery

Ekran transferów pokazuje postęp. Pobieranie oraz wysyłanie małych plików obsługuje usługa transferu Androida działająca w tle, która wyświetla powiadomienia. Pliki większe niż 10 MiB są wysyłane kolejno w częściach przez proces aplikacji, z możliwością wstrzymania, wznowienia i ponowienia; Android może przerwać wysyłanie po zabiciu aplikacji w tle. Poprawne wstrzymanie w aplikacji zachowuje częściowy plik na serwerze, ale błąd sieci w trakcie części powoduje ponowienie od początku.

W przypadku konfliktu z istniejącą ścieżką wybierz nadpisanie, pominięcie albo zachowanie obu plików. Miejsce pobierania wybiera się systemowym selektorem pamięci; dostępne lokalizacje i zachowanie zależą od wersji Androida.

## Rozwiązywanie problemów

- **Nie można się połączyć lub zalogować:** sprawdź końcowy adres serwera, dostęp do sieci, konto i uprawnienia. Bez schematu używany jest HTTPS. HTTP wymaga potwierdzenia. Przekierowania i interaktywne logowanie przez dostawcę tożsamości nie są obsługiwane; zobacz [Instalację](installation.md).
- **Transfer się zatrzymuje:** sprawdź ekran transferów i powiadomienia Androida. Podczas wysyłania w częściach utrzymuj aplikację aktywną i sprawdź dostęp do wybranej lokalizacji.
- **Nie można zainstalować aktualizacji:** postępuj zgodnie z prośbą Androida o uprawnienie i sprawdź identyfikator, klucz podpisu oraz wyższy kod wersji APK. Zobacz [Aktualizacje](installation.md#aktualizacje).
- **Nie można otworzyć lub udostępnić pliku:** sprawdź, czy jest zainstalowana odpowiednia aplikacja Androida oraz czy plik lub lokalizacja są dostępne.

Zgłaszając problem, podaj wersję aplikacji, Androida i urządzenie, wersję serwera, kroki odtworzenia oraz treść błędu. Przed udostępnieniem logów usuń hasła, tokeny i prywatne ścieżki. Skorzystaj z [formularza zgłoszenia błędu](https://github.com/Adiker/filebrowser-quantum-mobile/issues/new/choose).
