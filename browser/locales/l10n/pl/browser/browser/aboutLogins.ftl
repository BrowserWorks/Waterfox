# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Dane logowania i hasła

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Szukaj danych logowania

create-login-button = Utwórz nowe dane logowania

fxaccounts-sign-in-text = Korzystaj ze swoich haseł na innych urządzeniach
fxaccounts-sign-in-sync-button = Zaloguj się do synchronizacji
fxaccounts-avatar-button =
    .title = Zarządzaj kontem

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Otwórz menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importuj z innej przeglądarki…
about-logins-menu-menuitem-import-from-a-file = Importuj z pliku…
about-logins-menu-menuitem-export-logins = Eksportuj dane logowania…
about-logins-menu-menuitem-remove-all-logins = Usuń wszystkie dane logowania…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opcje
       *[other] Preferencje
    }
about-logins-menu-menuitem-help = Pomoc

## Login List

login-list =
    .aria-label = Dane logowania pasujące do zapytania
login-list-count =
    { $count ->
        [one] { $count } dane logowania
        [few] { $count } dane logowania
       *[many] { $count } danych logowania
    }
login-list-sort-label-text = Sortuj wg:
login-list-name-option = Nazwa (A-Z)
login-list-name-reverse-option = Nazwa (Z-A)
login-list-username-option = Nazwa użytkownika (A-Z)
login-list-username-reverse-option = Nazwa użytkownika (Z-A)
about-logins-login-list-alerts-option = Powiadomienia
login-list-last-changed-option = Ostatnia modyfikacja
login-list-last-used-option = Ostatnie użycie
login-list-intro-title = Brak danych logowania
login-list-intro-description = Tutaj będą wyświetlane hasła zachowane w przeglądarce { -brand-product-name }.
about-logins-login-list-empty-search-title = Nie odnaleziono danych logowania
about-logins-login-list-empty-search-description = Brak wyników pasujących do wyszukiwania.
login-list-item-title-new-login = Nowe dane logowania
login-list-item-subtitle-new-login = Wprowadź dane logowania
login-list-item-subtitle-missing-username = (bez nazwy użytkownika)
about-logins-list-item-breach-icon =
    .title = Witryna z wyciekiem haseł
about-logins-list-item-vulnerable-password-icon =
    .title = Potencjalnie niebezpieczne hasło

about-logins-list-section-breach = Witryny z wyciekami haseł
about-logins-list-section-vulnerable = Potencjalnie niebezpieczne hasła
about-logins-list-section-nothing = Brak powiadomienia
about-logins-list-section-today = Dzisiaj
about-logins-list-section-yesterday = Wczoraj
about-logins-list-section-week = Ostatnie 7 dni

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Szukasz swoich zachowanych haseł? Włącz synchronizację lub je zaimportuj.
about-logins-login-intro-heading-logged-in = Brak synchronizowanych danych logowania.
login-intro-description = Aby przenieść tutaj dane logowania zachowane w przeglądarce { -brand-product-name } na innym urządzeniu:
login-intro-instructions-fxa = Zarejestruj się lub zaloguj na { -fxaccount-brand-name(case: "loc", capitalization: "lower") } na urządzeniu, w którym zachowano dane logowania.
login-intro-instructions-fxa-settings = Otwórz Ustawienia → Synchronizacja → Włącz synchronizację… i zaznacz pole „dane logowania i hasła”.
login-intro-instructions-fxa-help = <a data-l10n-name="help-link">Pomoc usługi { -lockwise-brand-short-name }</a> zawiera więcej informacji.
about-logins-intro-import = Jeśli dane logowania są zachowane w innej przeglądarce, możesz <a data-l10n-name="import-link">zaimportować je do usługi { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Jeśli dane logowania są zachowane poza przeglądarką { -brand-product-name }, możesz <a data-l10n-name="import-browser-link">zaimportować je z innej przeglądarki</a> lub <a data-l10n-name="import-file-link">z pliku</a>

## Login

login-item-new-login-title = Nowe dane logowania
login-item-edit-button = Edytuj
about-logins-login-item-remove-button = Usuń
login-item-origin-label = Adres witryny
login-item-tooltip-message = Upewnij się, że jest to dokładny adres witryny, na której się logujesz.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nazwa użytkownika
about-logins-login-item-username =
    .placeholder = (bez nazwy użytkownika)
login-item-copy-username-button-text = Kopiuj
login-item-copied-username-button-text = Skopiowano
login-item-password-label = Hasło
login-item-password-reveal-checkbox =
    .aria-label = Widoczne hasło
login-item-copy-password-button-text = Kopiuj
login-item-copied-password-button-text = Skopiowano
login-item-save-changes-button = Zapisz zmiany
login-item-save-new-button = Zapisz
login-item-cancel-button = Anuluj
login-item-time-changed = Ostatnia modyfikacja: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Utworzono: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ostatnie użycie: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Aby zmienić dane logowania witryny, wprowadź swoje dane logowania do systemu Windows. Pomaga to chronić bezpieczeństwo Twoich kont.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = zmiana zachowanych danych logowania

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Aby wyświetlić hasło, wprowadź swoje dane logowania do systemu Windows. Pomaga to chronić bezpieczeństwo Twoich kont.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = wyświetlenie zachowanego hasła

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Aby skopiować hasło, wprowadź swoje dane logowania do systemu Windows. Pomaga to chronić bezpieczeństwo Twoich kont.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = skopiowanie zachowanego hasła

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Aby wyeksportować dane logowania witryn, wprowadź swoje dane logowania do systemu Windows. Pomaga to chronić bezpieczeństwo Twoich kont.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = wyeksportowanie zachowanych danych logowania i haseł

## Primary Password notification

about-logins-primary-password-notification-message = Proszę podać hasło główne, aby wyświetlić zachowane dane logowania i hasła
master-password-reload-button =
    .label = Zaloguj się
    .accesskey = Z

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Anuluj
confirmation-dialog-dismiss-button =
    .title = Anuluj

about-logins-confirm-remove-dialog-title = Czy usunąć te dane logowania?
confirm-delete-dialog-message = Tej czynności nie można cofnąć.
about-logins-confirm-remove-dialog-confirm-button = Usuń

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Usuń
       *[other] Usuń wszystkie
    }

about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Tak, usuń te dane logowania
        [one] Tak, usuń te dane logowania
        [few] Tak, usuń te dane logowania
       *[many] Tak, usuń te dane logowania
    }

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Czy usunąć { $count } dane logowania?
        [few] Czy usunąć { $count } dane logowania?
       *[many] Czy usunąć { $count } danych logowania?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } i widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
        [one] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } i widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
        [few] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } i widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
       *[many] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } i widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Czy usunąć { $count } dane logowania ze wszystkich urządzeń?
        [few] Czy usunąć { $count } dane logowania ze wszystkich urządzeń?
       *[many] Czy usunąć { $count } danych logowania ze wszystkich urządzeń?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } na wszystkich urządzeniach synchronizowanych z { -fxaccount-brand-name(case: "ins", capitalization: "lower") } oraz widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
        [one] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } na wszystkich urządzeniach synchronizowanych z { -fxaccount-brand-name(case: "ins", capitalization: "lower") } oraz widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
        [few] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } na wszystkich urządzeniach synchronizowanych z { -fxaccount-brand-name(case: "ins", capitalization: "lower") } oraz widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
       *[many] Spowoduje to usunięcie danych logowania zachowanych w przeglądarce { -brand-short-name } na wszystkich urządzeniach synchronizowanych z { -fxaccount-brand-name(case: "ins", capitalization: "lower") } oraz widocznych tutaj powiadomień o wyciekach danych. Tego działania nie można cofnąć.
    }

about-logins-confirm-export-dialog-title = Eksport danych logowania i haseł
about-logins-confirm-export-dialog-message = Twoje hasła zostaną zapisane jako zwykły tekst (np. SłabeH@s1o), więc każdy, kto może otworzyć wyeksportowany plik, będzie mógł je zobaczyć.
about-logins-confirm-export-dialog-confirm-button = Eksportuj…

about-logins-alert-import-title = Ukończono importowanie
about-logins-alert-import-message = Wyświetl szczegółowe podsumowanie importowania

confirm-discard-changes-dialog-title = Czy odrzucić niezachowane zmiany?
confirm-discard-changes-dialog-message = Wszystkie niezachowane zmiany zostaną utracone.
confirm-discard-changes-dialog-confirm-button = Odrzuć

## Breach Alert notification

about-logins-breach-alert-title = Wyciek haseł z witryny
breach-alert-text = Od czasu ostatniej zmiany danych logowania hasła z tej witryny wyciekły lub zostały wykradzione. Zmień hasło, aby ochronić swoje konto.
about-logins-breach-alert-date = Wyciek z { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Otwórz witrynę { $hostname }
about-logins-breach-alert-learn-more-link = Więcej informacji

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Potencjalnie niebezpieczne hasło
about-logins-vulnerable-alert-text2 = To hasło jest używane na innym koncie, które prawdopodobnie znalazło się w bazie wykradzionych haseł. Używanie tych samych danych logowania na różnych witrynach naraża wszystkie konta użytkownika na ryzyko. Zmień to hasło.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Otwórz witrynę { $hostname }
about-logins-vulnerable-alert-learn-more-link = Więcej informacji

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Dane logowania dla witryny „{ $loginTitle }” z tą nazwą użytkownika już istnieją. <a data-l10n-name="duplicate-link">Przejść do istniejących danych?</a>

# This is a generic error message.
about-logins-error-message-default = Wystąpił błąd podczas zapisywania tego hasła.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Eksportuj plik z danymi logowania
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = dane-logowania.csv
about-logins-export-file-picker-export-button = Eksportuj
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Plik CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importuj plik z danymi logowania
about-logins-import-file-picker-import-button = Importuj
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Plik CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Dokument TSV
       *[other] Plik TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Ukończono importowanie
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Dodano nowe dane logowania:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Zaktualizowano istniejące dane logowania:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>Odnaleziono podwójne dane logowania:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nie zaimportowano)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>Błędy:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nie zaimportowano)</span>
    }
about-logins-import-dialog-done = Gotowe

about-logins-import-dialog-error-title = Błąd importu
about-logins-import-dialog-error-conflicting-values-title = Wiele sprzecznych wartości dla jednych danych logowania
about-logins-import-dialog-error-conflicting-values-description = Na przykład: kilka nazw użytkownika, haseł, adresów itp. dla jednych danych logowania.
about-logins-import-dialog-error-file-format-title = Problem z formatem pliku
about-logins-import-dialog-error-file-format-description = Niepoprawne lub brakujące nagłówki kolumn. Upewnij się, że plik zawiera kolumny z nazwami użytkownika, hasłami i adresami.
about-logins-import-dialog-error-file-permission-title = Nie można odczytać pliku
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } nie ma uprawnienia do odczytu tego pliku. Spróbuj zmienić uprawnienia pliku.
about-logins-import-dialog-error-unable-to-read-title = Nie można przetworzyć pliku
about-logins-import-dialog-error-unable-to-read-description = Upewnij się, że wybrano plik CSV lub TSV.
about-logins-import-dialog-error-no-logins-imported = Żadne dane logowania nie zostały zaimportowane
about-logins-import-dialog-error-learn-more = Więcej informacji
about-logins-import-dialog-error-try-import-again = Spróbuj zaimportować ponownie…
about-logins-import-dialog-error-cancel = Anuluj

about-logins-import-report-title = Podsumowanie importowania
about-logins-import-report-description = Dane logowania i hasła zaimportowane do przeglądarki { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = { $number }. wiersz
about-logins-import-report-row-description-no-change = Duplikat: dokładnie pasuje do istniejących danych logowania
about-logins-import-report-row-description-modified = Zaktualizowano istniejące dane logowania
about-logins-import-report-row-description-added = Dodano nowe dane logowania
about-logins-import-report-row-description-error = Błąd: brak pola

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Błąd: wiele wartości dla pola { $field }
about-logins-import-report-row-description-error-missing-field = Błąd: brak pola { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Dodane nowe dane logowania</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Dodane nowe dane logowania</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Dodane nowe dane logowania</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Zaktualizowane istniejące dane logowania</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Zaktualizowane istniejące dane logowania</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Zaktualizowane istniejące dane logowania</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Podwójne dane logowania</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Podwójne dane logowania</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Podwójne dane logowania</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Błędy</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Błędy</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Błędy</div> <div data-l10n-name="not-imported">(nie zaimportowano)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Podsumowanie importowania
