# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informacje do rozwiązywania problemów
page-subtitle =
    Ta strona zawiera informacje techniczne, które mogą być przydatne podczas
    rozwiązywania problemów. Jeśli szukasz odpowiedzi na często zadawane pytania
    dotyczące programu { -brand-short-name }, sprawdź naszą <a data-l10n-name="support-link">stronę wsparcia
    technicznego</a>.

crashes-title = Zgłoszenia awarii
crashes-id = ID zgłoszenia
crashes-send-date = Data przesłania
crashes-all-reports = Wszystkie zgłoszenia awarii
crashes-no-config = Ten program nie został skonfigurowany do wyświetlania zgłoszeń awarii.
support-addons-title = Dodatki
support-addons-name = Nazwa
support-addons-type = Typ
support-addons-enabled = Włączone
support-addons-version = Wersja
support-addons-id = ID
security-software-title = Oprogramowanie zabezpieczające
security-software-type = Typ
security-software-name = Nazwa
security-software-antivirus = Program antywirusowy
security-software-antispyware = Program antyszpiegowski
security-software-firewall = Zapora sieciowa
features-title = Wbudowane rozszerzenia programu { -brand-short-name }
features-name = Nazwa
features-version = Wersja
features-id = ID
processes-title = Zdalne procesy
processes-type = Typ
processes-count = Liczba
app-basics-title = Informacje o programie
app-basics-name = Nazwa
app-basics-version = Wersja
app-basics-build-id = ID kompilacji
app-basics-distribution-id = ID dystrybucji
app-basics-update-channel = Kanał aktualizacji
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Katalog aktualizacji
       *[other] Folder aktualizacji
    }
app-basics-update-history = Historia aktualizacji
app-basics-show-update-history = Wyświetl historię aktualizacji
# Represents the path to the binary used to start the application.
app-basics-binary = Plik binarny programu
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Katalog profilu
       *[other] Folder profilu
    }
app-basics-enabled-plugins = Włączone wtyczki
app-basics-build-config = Konfiguracja kompilacji
app-basics-user-agent = Identyfikator programu
app-basics-os = System operacyjny
app-basics-os-theme = Motyw systemu operacyjnego
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Używa systemu Rosetta
app-basics-memory-use = Zużycie pamięci
app-basics-performance = Wydajność
app-basics-service-workers = Zarejestrowane wątki usługowe
app-basics-third-party = Moduły zewnętrzne
app-basics-profiles = Profile
app-basics-launcher-process-status = Proces uruchamiający
app-basics-multi-process-support = Okna wieloprocesowe
app-basics-fission-support = Okna Fission
app-basics-remote-processes-count = Zdalne procesy
app-basics-enterprise-policies = Zasady organizacji
app-basics-location-service-key-google = Klucz usługi lokalizacji Google
app-basics-safebrowsing-key-google = Klucz usługi „Bezpieczne przeglądanie” Google
app-basics-key-mozilla = Klucz usługi lokalizacji Mozilli
app-basics-safe-mode = Tryb awaryjny
show-dir-label =
    { PLATFORM() ->
        [macos] Pokaż w Finderze
        [windows] Otwórz folder
       *[other] Otwórz katalog
    }
environment-variables-title = Zmienne środowiskowe
environment-variables-name = Nazwa
environment-variables-value = Wartość
experimental-features-title = Funkcje eksperymentalne
experimental-features-name = Nazwa
experimental-features-value = Wartość
modified-key-prefs-title = Ważne zmienione ustawienia
modified-prefs-name = Nazwa
modified-prefs-value = Wartość
user-js-title = Preferencje user.js
user-js-description = Folder profilu użytkownika zawiera <a data-l10n-name="user-js-link">plik user.js</a> z preferencjami, które nie zostały utworzone przez program { -brand-short-name }.
locked-key-prefs-title = Ważne zablokowane ustawienia
locked-prefs-name = Nazwa
locked-prefs-value = Wartość
graphics-title = Grafika
graphics-features-title = Funkcje
graphics-diagnostics-title = Diagnostyka
graphics-failure-log-title = Dziennik niepowodzeń
graphics-gpu1-title = GPU 1
graphics-gpu2-title = GPU 2
graphics-decision-log-title = Decyzje
graphics-crash-guards-title = Funkcje wyłączone dla ochrony przed awariami
graphics-workarounds-title = Obejścia problemów
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protokół okien
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Środowisko pulpitu
place-database-title = Baza danych „Places”
place-database-integrity = Integralność
place-database-verify-integrity = Sprawdź integralność
a11y-title = Ułatwienia dostępu
a11y-activated = Aktywne
a11y-force-disabled = Zablokuj ułatwienia dostępu
a11y-handler-used = Aktywna obsługa dostępności
a11y-instantiator = Aktywator
library-version-title = Wersje bibliotek
copy-text-to-clipboard-label = Skopiuj tekst do schowka
copy-raw-data-to-clipboard-label = Skopiuj nieprzetworzone dane do schowka
sandbox-title = Piaskownica
sandbox-sys-call-log-title = Odrzucone wywołania systemowe
sandbox-sys-call-index = #
sandbox-sys-call-age = Sekund temu
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Typ procesu
sandbox-sys-call-number = Wywołanie systemowe
sandbox-sys-call-args = Parametry
troubleshoot-mode-title = Diagnozuj problemy
restart-in-troubleshoot-mode-label = Tryb rozwiązywania problemów…
clear-startup-cache-title = Spróbuj wyczyścić pamięć podręczną uruchamiania
clear-startup-cache-label = Wyczyść pamięć podręczną uruchamiania…
startup-cache-dialog-title2 = Uruchomić ponownie, aby wyczyścić pamięć podręczną uruchamiania?
startup-cache-dialog-body2 = Nie spowoduje to zmiany ustawień ani usunięcia rozszerzeń.
restart-button-label = Uruchom ponownie

## Media titles

audio-backend = Mechanizm dźwięku
max-audio-channels = Maksymalna liczba kanałów
sample-rate = Preferowana częstotliwość próbkowania
roundtrip-latency = Opóźnienie w obie strony (odchylenie standardowe)
media-title = Media
media-output-devices-title = Urządzenia wyjściowe
media-input-devices-title = Urządzenia wejściowe
media-device-name = Nazwa
media-device-group = Grupa
media-device-vendor = Dostawca
media-device-state = Stan
media-device-preferred = Preferowane
media-device-format = Format
media-device-channels = Kanały
media-device-rate = Częstotliwość próbkowania
media-device-latency = Opóźnienie
media-capabilities-title = Możliwości medialne
# List all the entries of the database.
media-capabilities-enumerate = Wyświetl zawartość bazy danych

##

intl-title = Umiędzynaradawianie i lokalizacja
intl-app-title = Ustawienia programu
intl-locales-requested = Żądane ustawienia regionalne
intl-locales-available = Dostępne ustawienia regionalne
intl-locales-supported = Ustawienia regionalne programu
intl-locales-default = Domyślne ustawienia regionalne
intl-os-title = System operacyjny
intl-os-prefs-system-locales = Ustawienia regionalne systemu
intl-regional-prefs = Preferencje regionalne

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Zdalne debugowanie (protokół Chromium)
remote-debugging-accepting-connections = Przyjmuje połączenia
remote-debugging-url = Adres URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Zgłoszenia awarii z ostatniego dnia
        [few] Zgłoszenia awarii z ostatnich { $days } dni
       *[many] Zgłoszenia awarii z ostatnich { $days } dni
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] przed minutą
        [few] { $minutes } minuty temu
       *[many] { $minutes } minut temu
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] przed godziną
        [few] { $hours } godziny temu
       *[many] { $hours } godzin temu
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] wczoraj
        [few] { $days } dni temu
       *[many] { $days } dni temu
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Wszystkie zgłoszenia awarii (łącznie z jednym oczekującym we wskazanym okresie)
        [few] Wszystkie zgłoszenia awarii (łącznie z { $reports } oczekującymi we wskazanym okresie)
       *[many] Wszystkie zgłoszenia awarii (łącznie z { $reports } oczekującymi we wskazanym okresie)
    }

raw-data-copied = Nieprzetworzone dane skopiowane do schowka
text-copied = Tekst skopiowany do schowka.

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Zablokowane dla zainstalowanej wersji sterownika grafiki.
blocked-gfx-card = Zablokowane dla zainstalowanej karty graficznej z powodu nierozwiązanych problemów ze sterownikiem.
blocked-os-version = Zablokowane dla używanej wersji systemu operacyjnego.
blocked-mismatched-version = Zablokowane z powodu różnicy wersji pomiędzy rejestrem a biblioteką DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Zablokowane dla zainstalowanej wersji sterownika grafiki. Zalecana jest aktualizacja sterownika do wersji { $driverVersion } lub nowszej.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametry ClearType

compositing = Komponowanie
hardware-h264 = Sprzętowe dekodowanie H.264
main-thread-no-omtc = główny wątek, brak OMTC
yes = Tak
no = Nie
unknown = Nieznane
virtual-monitor-disp = Wirtualny monitor

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Obecny
missing = Brak

gpu-process-pid = PID procesu GPU
gpu-process = Proces GPU
gpu-description = Opis
gpu-vendor-id = ID dostawcy
gpu-device-id = ID urządzenia
gpu-subsys-id = ID podsystemu
gpu-drivers = Sterowniki
gpu-ram = RAM
gpu-driver-vendor = Dostawca sterownika
gpu-driver-version = Wersja sterownika
gpu-driver-date = Data sterownika
gpu-active = Aktywna
webgl1-wsiinfo = Informacje sterownika WebGL 1 WSI
webgl1-renderer = Renderer sterownika WebGL 1
webgl1-version = Wersja sterownika WebGL 1
webgl1-driver-extensions = Rozszerzenia sterownika WebGL 1
webgl1-extensions = Rozszerzenia WebGL 1
webgl2-wsiinfo = Informacje sterownika WebGL 2 WSI
webgl2-renderer = Renderer sterownika WebGL 2
webgl2-version = Wersja sterownika WebGL 2
webgl2-driver-extensions = Rozszerzenia sterownika WebGL 2
webgl2-extensions = Rozszerzenia WebGL 2

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Zablokowano z powodu znanych problemów: <a data-l10n-name="bug-link">zgłoszenie { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Zablokowano. Kod błędu: { $failureCode }

d3d11layers-crash-guard = Kompozytor D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Dekoder wideo WMF VPX

reset-on-next-restart = Spróbuj włączyć przy następnym uruchomieniu
gpu-process-kill-button = Zakończ proces GPU
gpu-device-reset = Reset urządzenia
gpu-device-reset-button = Resetuj urządzenie
uses-tiling = Używa kafelkowania
content-uses-tiling = Używa kafelkowania (treść)
off-main-thread-paint-enabled = Rysowanie poza głównym wątkiem
off-main-thread-paint-worker-count = Wątki rysujące poza głównym
target-frame-rate = Docelowa liczba klatek na sekundę

min-lib-versions = Oczekiwana wersja minimalna
loaded-lib-versions = Wersja w użyciu

has-seccomp-bpf = Seccomp-BPF (filtrowanie wywołań systemowych)
has-seccomp-tsync = Synchronizacja wątków Seccomp
has-user-namespaces = Przestrzenie nazw użytkownika
has-privileged-user-namespaces = Przestrzenie nazw użytkownika dla uprzywilejowanych procesów
can-sandbox-content = Separacja procesów
can-sandbox-media = Separacja wtyczek
content-sandbox-level = Poziom separacji treści
effective-content-sandbox-level = Efektywny poziom separacji treści
content-win32k-lockdown-state = Stan blokady Win32k dla procesu treści
sandbox-proc-type-content = zawartość
sandbox-proc-type-file = zawartość pliku
sandbox-proc-type-media-plugin = wtyczka
sandbox-proc-type-data-decoder = dekoder danych

startup-cache-title = Pamięć podręczna uruchamiania
startup-cache-disk-cache-path = Ścieżka do pamięci podręcznej na dysku
startup-cache-ignore-disk-cache = Ignorowanie pamięci podręcznej na dysku
startup-cache-found-disk-cache-on-init = Odnaleziono pamięć podręczną na dysku podczas inicjacji
startup-cache-wrote-to-disk-cache = Zapisano do pamięci podręcznej na dysku

launcher-process-status-0 = włączony
launcher-process-status-1 = wyłączony z powodu awarii
launcher-process-status-2 = wymuszone wyłączenie
launcher-process-status-unknown = nieznany stan

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = wyłączone przez eksperyment
fission-status-experiment-treatment = włączone przez eksperyment
fission-status-disabled-by-e10s-env = wyłączone przez środowisko
fission-status-enabled-by-env = włączone przez środowisko
fission-status-disabled-by-safe-mode = wyłączone przez tryb awaryjny
fission-status-enabled-by-default = włączone domyślnie
fission-status-disabled-by-default = wyłączone domyślnie
fission-status-enabled-by-user-pref = włączone przez użytkownika
fission-status-disabled-by-user-pref = wyłączone przez użytkownika
fission-status-disabled-by-e10s-other = e10s jest wyłączone
fission-status-enabled-by-rollout = włączone przez stopniowe wdrażanie

async-pan-zoom = Asynchroniczne przewijanie/powiększanie
apz-none = brak
wheel-enabled = kółko
touch-enabled = dotyk
drag-enabled = pasek przewijania
keyboard-enabled = klawiatura
autoscroll-enabled = automatyczne przewijanie
zooming-enabled = płynne powiększanie gestem

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = Asynchroniczne przewijanie/powiększanie za pomocą kółka wyłączone z powodu nieobsługiwanego ustawienia ({ $preferenceKey })
touch-warning = Asynchroniczne przewijanie/powiększanie za pomocą dotyku wyłączone z powodu nieobsługiwanego ustawienia ({ $preferenceKey })

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Nieaktywne
policies-active = Aktywne
policies-error = Błąd

## Printing section

support-printing-title = Drukowanie
support-printing-troubleshoot = Rozwiązywanie problemów
support-printing-clear-settings-button = Wyczyść zachowane ustawienia drukowania
support-printing-modified-settings = Zmienione ustawienia drukowania
support-printing-prefs-name = Nazwa
support-printing-prefs-value = Wartość

## Normandy sections

support-remote-experiments-title = Zdalne eksperymenty
support-remote-experiments-name = Nazwa
support-remote-experiments-branch = Gałąź eksperymentu
support-remote-experiments-see-about-studies = <a data-l10n-name="support-about-studies-link">about:studies</a> zawiera więcej informacji, w tym jak wyłączyć poszczególne eksperymenty lub uniemożliwić programowi { -brand-short-name } przeprowadzanie tego typu eksperymentów w przyszłości.

support-remote-features-title = Zdalne funkcje
support-remote-features-name = Nazwa
support-remote-features-status = Stan
