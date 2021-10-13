# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Zamknij

preferences-doc-title = Preferencje

category-list =
    .aria-label = Kategorie

pane-general-title = Ogólne
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Tworzenie
category-compose =
    .tooltiptext = Tworzenie

pane-privacy-title = Prywatność i bezpieczeństwo
category-privacy =
    .tooltiptext = Prywatność i bezpieczeństwo

pane-chat-title = Komunikator
category-chat =
    .tooltiptext = Komunikator

pane-calendar-title = Kalendarz
category-calendar =
    .tooltiptext = Kalendarz

general-language-and-appearance-header = Język i wygląd

general-incoming-mail-header = Poczta przychodząca

general-files-and-attachment-header = Pliki i załączniki

general-tags-header = Etykiety

general-reading-and-display-header = Czytanie i wyświetlanie

general-updates-header = Aktualizacje

general-network-and-diskspace-header = Sieć i miejsce na dysku

general-indexing-label = Indeksowanie

composition-category-header = Tworzenie

composition-attachments-header = Załączniki

composition-spelling-title = Pisownia

compose-html-style-title = Styl HTML

composition-addressing-header = Adresowanie

privacy-main-header = Prywatność

privacy-passwords-header = Hasła

privacy-junk-header = Niechciana poczta

collection-header = Dane zbierane przez program { -brand-short-name }

collection-description = Dążymy do zapewnienia odpowiedniego wyboru i zbierania wyłącznie niezbędnych danych, aby dostarczać i doskonalić program { -brand-short-name } dla nas wszystkich. Zawsze prosimy o pozwolenie przed przesłaniem danych osobistych.
collection-privacy-notice = Prywatność

collection-health-report-telemetry-disabled = { -vendor-short-name } nie ma już zezwolenia na zbieranie danych technicznych i o interakcjach z programem. Wszystkie wcześniej zebrane dane zostaną usunięte w ciągu 30 dni.
collection-health-report-telemetry-disabled-link = Więcej informacji

collection-health-report =
    .label = Przesyłanie do organizacji { -vendor-short-name } danych technicznych i o interakcjach z programem { -brand-short-name }.
    .accesskey = z
collection-health-report-link = Więcej informacji

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Przesyłanie danych jest wyłączone przy tej konfiguracji programu

collection-backlogged-crash-reports =
    .label = Przesyłanie zgromadzonych zgłoszeń awarii programu { -brand-short-name }.
    .accesskey = o
collection-backlogged-crash-reports-link = Więcej informacji

privacy-security-header = Bezpieczeństwo

privacy-scam-detection-title = Wykrywanie oszustw

privacy-anti-virus-title = Ochrona antywirusowa

privacy-certificates-title = Certyfikaty

chat-pane-header = Komunikator

chat-status-title = Stan

chat-notifications-title = Powiadomienia

chat-pane-styling-header = Style

choose-messenger-language-description = Wybierz język używany do wyświetlania menu, komunikatów i powiadomień programu { -brand-short-name }.
manage-messenger-languages-button =
    .label = Ustaw języki zastępcze…
    .accesskey = U
confirm-messenger-language-change-description = Uruchom program { -brand-short-name } ponownie, aby zastosować te zmiany
confirm-messenger-language-change-button = Zastosuj i uruchom ponownie

update-setting-write-failure-title = Błąd podczas zachowywania preferencji aktualizacji

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    W programie { -brand-short-name } wystąpił błąd i nie zachowano tej zmiany. Zauważ, że ustawienie tej preferencji aktualizacji wymaga uprawnienia do zapisu do poniższego pliku. Ty lub administrator komputera może móc rozwiązać błąd przez udzielenie grupie „Użytkownicy” pełnej kontroli nad tym plikiem.
    
    Nie można zapisać do pliku: { $path }

update-in-progress-title = Trwa aktualizacja

update-in-progress-message = Czy { -brand-short-name } ma kontynuować tę aktualizację?

update-in-progress-ok-button = &Odrzuć
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Kontynuuj

account-button = Ustawienia kont
open-addons-sidebar-button = Dodatki i motywy

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Aby utworzyć hasło główne, wprowadź swoje dane logowania do systemu Windows. Pomaga to chronić bezpieczeństwo Twoich kont.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = utworzenie hasła głównego

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Strona startowa programu { -brand-short-name }

start-page-label =
    .label = Po uruchomieniu programu { -brand-short-name } wyświetlaj poniższą stronę startową w oknie wiadomości:
    .accesskey = P

location-label =
    .value = Adres:
    .accesskey = A
restore-default-label =
    .label = Przywróć domyślną
    .accesskey = d

default-search-engine = Domyślna wyszukiwarka
add-search-engine =
    .label = Dodaj z pliku
    .accesskey = D
remove-search-engine =
    .label = Usuń
    .accesskey = U

minimize-to-tray-label =
    .label = Minimalizuj program { -brand-short-name } do ikony w obszarze powiadomień
    .accesskey = M

new-message-arrival = Po odebraniu nowej wiadomości:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] odtwarzaj plik:
           *[other] odtwarzaj dźwięk
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] o
        }
mail-play-button =
    .label = Odtwórz
    .accesskey = r

change-dock-icon = Zmień preferencje ikony aplikacji
app-icon-options =
    .label = Opcje ikony aplikacji…
    .accesskey = i

notification-settings = Powiadomienia i domyślny dźwięk można wyłączyć w panelu Powiadomienia Preferencji systemowych.

animated-alert-label =
    .label = wyświetlaj powiadomienie
    .accesskey = w
customize-alert-label =
    .label = Dostosuj…
    .accesskey = s

biff-use-system-alert =
    .label = wyświetlaj powiadomienie systemowe

tray-icon-unread-label =
    .label = wyświetlaj ikonę w obszarze powiadomień, kiedy są nieprzeczytane wiadomości
    .accesskey = n

tray-icon-unread-description = Zalecane w przypadku korzystania z małych przycisków na pasku zadań

mail-system-sound-label =
    .label = domyślny systemowy dźwięk powiadomienia o nowej poczcie
    .accesskey = s
mail-custom-sound-label =
    .label = użyj pliku
    .accesskey = u
mail-browse-sound-button =
    .label = Przeglądaj…
    .accesskey = e

enable-gloda-search-label =
    .label = Indeksowanie wiadomości i wyszukiwanie
    .accesskey = n

datetime-formatting-legend = Format daty i czasu
language-selector-legend = Język

allow-hw-accel =
    .label = Korzystaj ze sprzętowego przyspieszania, jeśli jest dostępne
    .accesskey = K

store-type-label =
    .value = Sposób przechowywania wiadomości:
    .accesskey = S

mbox-store-label =
    .label = plik na folder (mbox)
maildir-store-label =
    .label = plik na wiadomość (maildir)

scrolling-legend = Przewijanie
autoscroll-label =
    .label = Używaj automatycznego przewijania
    .accesskey = U
smooth-scrolling-label =
    .label = Używaj płynnego przewijania
    .accesskey = a

system-integration-legend = Integracja z systemem operacyjnym
always-check-default =
    .label = Przy uruchamianiu sprawdzaj, czy { -brand-short-name } jest domyślnym programem pocztowym
    .accesskey = P
check-default-button =
    .label = Sprawdź teraz…
    .accesskey = S

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Usługa wyszukiwania systemu Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Zezwalaj programowi { search-engine-name } na wyszukiwanie wiadomości
    .accesskey = Z

config-editor-button =
    .label = Edytor ustawień…
    .accesskey = E

return-receipts-description = Określ, w jaki sposób { -brand-short-name } ma traktować potwierdzenia doręczenia wiadomości
return-receipts-button =
    .label = Opcje potwierdzeń…
    .accesskey = O

update-app-legend = Aktualizacje programu { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Wersja { $version }

allow-description = Zezwalaj programowi { -brand-short-name } na:
automatic-updates-label =
    .label = Automatyczne instalowanie aktualizacji (zalecane: większe bezpieczeństwo)
    .accesskey = i
check-updates-label =
    .label = Sprawdzanie dostępności aktualizacji i pytania o ich instalację
    .accesskey = S

update-history-button =
    .label = Wyświetl historię aktualizacji
    .accesskey = W

use-service =
    .label = Używaj usługi instalowania aktualizacji działającej w tle
    .accesskey = U

cross-user-udpate-warning = To ustawienie będzie obowiązywać dla wszystkich kont systemu Windows i profilów programu { -brand-short-name } używających tej instalacji.

networking-legend = Połączenie
proxy-config-description = Określ, w jaki sposób { -brand-short-name } ma się łączyć z Internetem

network-settings-button =
    .label = Ustawienia…
    .accesskey = U

offline-legend = Tryb offline
offline-settings = Ustawienia trybu offline

offline-settings-button =
    .label = Tryb offline…
    .accesskey = T

diskspace-legend = Miejsce na dysku
offline-compact-folder =
    .label = Automatycznie porządkuj wszystkie foldery, gdy zaoszczędzi to w sumie ponad
    .accesskey = A

offline-compact-folder-automatically =
    .label = Zawsze pytaj przed porządkowaniem
    .accesskey = Z

compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Używaj maksymalnie
    .accesskey = m

use-cache-after = MB miejsca dla pamięci podręcznej

##

smart-cache-label =
    .label = Używaj ręcznego zarządzania pamięcią podręczną
    .accesskey = r

clear-cache-button =
    .label = Wyczyść teraz
    .accesskey = W

fonts-legend = Czcionki i kolory

default-font-label =
    .value = Domyślna czcionka:
    .accesskey = D

default-size-label =
    .value = Rozmiar:
    .accesskey = R

font-options-button =
    .label = Zaawansowane…
    .accesskey = Z

color-options-button =
    .label = Kolory…
    .accesskey = K

display-width-legend = Wiadomości tekstowe

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Wyświetlaj emotikony jako grafikę
    .accesskey = W

display-text-label = Ustawienia wyświetlania cytatów w wiadomościach tekstowych:

style-label =
    .value = Styl:
    .accesskey = S

regular-style-item =
    .label = Normalny
bold-style-item =
    .label = Pogrubiony
italic-style-item =
    .label = Kursywa
bold-italic-style-item =
    .label = Pogrubiona kursywa

size-label =
    .value = Rozmiar:
    .accesskey = o

regular-size-item =
    .label = Normalny
bigger-size-item =
    .label = Większy
smaller-size-item =
    .label = Mniejszy

quoted-text-color =
    .label = Kolor:
    .accesskey = o

search-handler-table =
    .placeholder = Filtruj typy zawartości i czynności

type-column-label = Typ zawartości

action-column-label = Czynność

save-to-label =
    .label = Zapisuj pliki do
    .accesskey = Z

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Wybierz…
           *[other] Przeglądaj…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] W
           *[other] P
        }

always-ask-label =
    .label = Zawsze pytaj gdzie zapisać plik
    .accesskey = e


display-tags-text = Etykiety mogą być używane do klasyfikowania wiadomości oraz nadawania im priorytetów.

new-tag-button =
    .label = Nowa…
    .accesskey = N

edit-tag-button =
    .label = Edytuj…
    .accesskey = E

delete-tag-button =
    .label = Usuń
    .accesskey = U

auto-mark-as-read =
    .label = Automatyczne oznaczanie wiadomości jako przeczytanych:
    .accesskey = A

mark-read-no-delay =
    .label = natychmiast po wyświetleniu
    .accesskey = n

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = po wyświetlaniu przez
    .accesskey = w

seconds-label = sekund

##

open-msg-label =
    .value = Otwieranie wiadomości w:

open-msg-tab =
    .label = nowych kartach
    .accesskey = k

open-msg-window =
    .label = nowych oknach wiadomości
    .accesskey = h

open-msg-ex-window =
    .label = istniejącym oknie wiadomości
    .accesskey = m

close-move-delete =
    .label = Zamykanie okna/karty wiadomości przy przenoszeniu lub usuwaniu
    .accesskey = Z

display-name-label =
    .value = Wyświetlana nazwa:

condensed-addresses-label =
    .label = Pokazywanie tylko nazw kontaktów dla nadawców z książki adresowej
    .accesskey = P

## Compose Tab

forward-label =
    .value = Przekazuj wiadomości:
    .accesskey = P

inline-label =
    .label = bezpośrednio

as-attachment-label =
    .label = jako załącznik

extension-label =
    .label = dodawaj rozszerzenia do nazw plików załączników
    .accesskey = d

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Zapisuj stan wiadomości co
    .accesskey = Z

auto-save-end = min

##

warn-on-send-accel-key =
    .label = Wymagaj potwierdzenia, gdy do wysłania wiadomości użyty został skrót klawiaturowy
    .accesskey = W

spellcheck-label =
    .label = Sprawdzaj pisownię przed wysłaniem wiadomości
    .accesskey = a

spellcheck-inline-label =
    .label = Sprawdzaj pisownię w trakcie tworzenia wiadomości
    .accesskey = w

language-popup-label =
    .value = Słownik:
    .accesskey = S

download-dictionaries-link = Pobierz więcej słowników

font-label =
    .value = Czcionka:
    .accesskey = C

font-size-label =
    .value = Rozmiar:
    .accesskey = R

default-colors-label =
    .label = Używaj domyślnych kolorów czytelnika
    .accesskey = d

font-color-label =
    .value = Kolor tekstu:
    .accesskey = K

bg-color-label =
    .value = Kolor tła:
    .accesskey = t

restore-html-label =
    .label = Przywróć domyślne
    .accesskey = e

default-format-label =
    .label = Domyślnie używaj formatu akapitu zamiast tekstu treści
    .accesskey = p

format-description = Ustawienia automatycznego formatowania wysyłanych wiadomości

send-options-label =
    .label = Opcje wysyłania…
    .accesskey = O

autocomplete-description = Podczas adresowania wiadomości wyszukuj pasujące pozycje:

ab-label =
    .label = w lokalnych książkach adresowych
    .accesskey = w

directories-label =
    .label = na serwerze usług katalogowych:
    .accesskey = n

directories-none-label =
    .none = brak

edit-directories-label =
    .label = Edytuj katalogi…
    .accesskey = E

email-picker-label =
    .label = Zapisuj adresy e-mail z poczty wychodzącej w książce:
    .accesskey = Z

default-directory-label =
    .value = Domyślnie uruchamiany katalog w oknie książki adresowej:
    .accesskey = u

default-last-label =
    .none = Ostatnio używany katalog

attachment-label =
    .label = Sprawdzaj pod kątem brakujących załączników
    .accesskey = S

attachment-options-label =
    .label = Słowa kluczowe…
    .accesskey = a

enable-cloud-share =
    .label = Proponuj udostępnianie plików większych niż
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Dodaj…
    .accesskey = D
    .defaultlabel = Dodaj…

remove-cloud-account =
    .label = Usuń
    .accesskey = U

find-cloud-providers =
    .value = Znajdź więcej dostawców…

cloud-account-description = Dodaj nowy serwis przechowywania plików


## Privacy Tab

mail-content = Wiadomości

remote-content-label =
    .label = Zdalne treści w wiadomościach
    .accesskey = Z

exceptions-button =
    .label = Wyjątki…
    .accesskey = W

remote-content-info =
    .value = Informacje o wpływie zdalnych treści na prywatność

web-content = Strony

history-label =
    .label = Zachowywanie historii odwiedzonych stron
    .accesskey = e

cookies-label =
    .label = Akceptowanie ciasteczek
    .accesskey = A

third-party-label =
    .value = Akceptowanie ciasteczek zewnętrznych witryn:
    .accesskey = k

third-party-always =
    .label = zawsze
third-party-never =
    .label = nigdy
third-party-visited =
    .label = z odwiedzonych

keep-label =
    .value = Przechowywanie ciasteczek:
    .accesskey = h

keep-expire =
    .label = do ich wygaśnięcia
keep-close =
    .label = do zamknięcia programu { -brand-short-name }
keep-ask =
    .label = pytaj za każdym razem

cookies-button =
    .label = Wyświetl ciasteczka…
    .accesskey = c

do-not-track-label =
    .label = Informowanie witryn o preferencjach względem śledzenia (wysyłanie nagłówka „Do Not Track”)
    .accesskey = n

learn-button =
    .label = Więcej informacji

passwords-description = { -brand-short-name } może zachować hasła dla wszystkich kont użytkownika.

passwords-button =
    .label = Zachowane hasła…
    .accesskey = Z


primary-password-description = Hasło główne chroni wszystkie hasła użytkownika, ale musi być ono wprowadzane jednorazowo dla każdej sesji.

primary-password-label =
    .label = Używaj hasła głównego
    .accesskey = U

primary-password-button =
    .label = Zmień hasło główne…
    .accesskey = h

forms-primary-pw-fips-title = Program pracuje obecnie w trybie FIPS. Tryb FIPS wymaga niepustego hasła głównego.
forms-master-pw-fips-desc = Zmiana hasła się nie powiodła.


junk-description = W tym miejscu można zmienić domyślne ustawienia filtru niechcianej poczty. Aby zmienić ustawienia niechcianej poczty dotyczące konkretnego konta, należy przejść do Konfiguracji kont.

junk-label =
    .label = W przypadku ręcznego oznaczenia wiadomości jako niechcianej:
    .accesskey = W

junk-move-label =
    .label = przenoś wiadomości do folderu „Niechciane”
    .accesskey = p

junk-delete-label =
    .label = usuwaj wiadomości
    .accesskey = u

junk-read-label =
    .label = Oznaczaj wiadomości uznane za niechciane jako przeczytane
    .accesskey = z

junk-log-label =
    .label = Włącz dziennik filtru niechcianej poczty
    .accesskey = d

junk-log-button =
    .label = Wyświetl dziennik
    .accesskey = k

reset-junk-button =
    .label = Zresetuj dane treningowe
    .accesskey = r

phishing-description = { -brand-short-name } może analizować treści wiadomości w poszukiwaniu typowych technik stosowanych przez oszustów.

phishing-label =
    .label = Informuj, jeżeli wyświetlana wiadomość może być próbą oszustwa
    .accesskey = n

antivirus-description = { -brand-short-name } może ułatwiać pracę programom antywirusowym poprzez umożliwienie im analizowania przychodzących wiadomości pocztowych, zanim zostaną one zapisane przez program.

antivirus-label =
    .label = Zezwalaj programom antywirusowym na przenoszenie poszczególnych wiadomości do kwarantanny
    .accesskey = Z

certificate-description = Kiedy serwer żąda osobistego certyfikatu użytkownika:

certificate-auto =
    .label = wybierz certyfikat automatycznie
    .accesskey = c

certificate-ask =
    .label = pytaj za każdym razem
    .accesskey = t

ocsp-label =
    .label = Wyślij zapytanie do serwerów OCSP, aby potwierdzić aktualność certyfikatów
    .accesskey = e

certificate-button =
    .label = Zarządzaj certyfikatami…
    .accesskey = Z

security-devices-button =
    .label = Urządzenia zabezpieczające…
    .accesskey = U

## Chat Tab

startup-label =
    .value = Po uruchomieniu programu { -brand-short-name }:
    .accesskey = P

offline-label =
    .label = nie łącz z kontami komunikatora

auto-connect-label =
    .label = łącz z kontami komunikatora automatycznie

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Wyświetlaj informacje o mojej nieaktywności po
    .accesskey = W

idle-time-label = minutach

##

away-message-label =
    .label = i ustawiaj stan na „Zaraz wracam” z opisem:
    .accesskey = u

send-typing-label =
    .label = Wysyłaj powiadomienia o pisaniu w trakcie rozmów
    .accesskey = t

notification-label = Przy odebraniu wiadomości bezpośrednio skierowanych do użytkownika:

show-notification-label =
    .label = Wyświetlaj powiadomienia:
    .accesskey = e

notification-all =
    .label = z nazwą nadawcy i podglądem wiadomości
notification-name =
    .label = tylko z nazwą nadawcy
notification-empty =
    .label = bez żadnych informacji

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animuj ikonę dokowania
           *[other] Migaj elementem paska zadań
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] M
        }

chat-play-sound-label =
    .label = odtwarzaj dźwięk
    .accesskey = d

chat-play-button =
    .label = Odtwórz
    .accesskey = O

chat-system-sound-label =
    .label = domyślny systemowy dźwięk powiadomienia o nowej poczcie
    .accesskey = s

chat-custom-sound-label =
    .label = użyj pliku
    .accesskey = u

chat-browse-sound-button =
    .label = Przeglądaj…
    .accesskey = r

theme-label =
    .value = Motyw:
    .accesskey = M

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bąbelki
style-dark =
    .label = Ciemny
style-paper =
    .label = Arkusze papieru
style-simple =
    .label = Prosty

preview-label = Podgląd:
no-preview-label = Podgląd jest niedostępny
no-preview-description = Ten motyw jest nieprawidłowy lub obecnie niedostępny (wyłączony dodatek, tryb awaryjny itp.).

chat-variant-label =
    .value = Wariant:
    .accesskey = W

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Szukaj w preferencjach

## Preferences UI Search Results

search-results-header = Wyniki wyszukiwania

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Niestety! W opcjach niczego nie odnaleziono dla wyszukiwania „<span data-l10n-name="query"></span>”.
       *[other] Niestety! W preferencjach niczego nie odnaleziono dla wyszukiwania „<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Potrzebujesz pomocy? Odwiedź <a data-l10n-name="url">pomoc programu { -brand-short-name }</a>.
