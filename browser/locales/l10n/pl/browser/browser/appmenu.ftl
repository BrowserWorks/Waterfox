# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Pobieranie aktualizacji programu { -brand-shorter-name }
    .label-update-available = Aktualizacja jest dostępna — pobierz teraz
    .label-update-manual = Aktualizacja jest dostępna — pobierz teraz
    .label-update-unsupported = Nie można uaktualnić — system jest niezgodny
    .label-update-restart = Aktualizacja jest dostępna — uruchom ponownie
appmenuitem-protection-dashboard-title = Panel ochrony
appmenuitem-customize-mode =
    .label = Dostosuj…

## Zoom Controls

appmenuitem-new-tab =
    .label = Nowa karta
appmenuitem-new-window =
    .label = Nowe okno
appmenuitem-new-private-window =
    .label = Nowe okno prywatne
appmenuitem-passwords =
    .label = Hasła
appmenuitem-addons-and-themes =
    .label = Dodatki i motywy
appmenuitem-find-in-page =
    .label = Znajdź na stronie…
appmenuitem-more-tools =
    .label = Więcej narzędzi
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Zakończ
           *[other] Zakończ
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Otwórz menu aplikacji
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Zamknij menu aplikacji
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Ustawienia

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Powiększ
appmenuitem-zoom-reduce =
    .label = Pomniejsz
appmenuitem-fullscreen =
    .label = Tryb pełnoekranowy

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Synchronizuj teraz
appmenu-remote-tabs-sign-into-sync =
    .label = Zaloguj się do synchronizacji…
appmenu-remote-tabs-turn-on-sync =
    .label = Włącz synchronizację…
appmenuitem-fxa-toolbar-sync-now2 = Synchronizuj teraz
appmenuitem-fxa-manage-account = Zarządzaj kontem
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Ostatnia synchronizacja: { $time }
    .label = Ostatnia synchronizacja: { $time }
appmenu-fxa-sync-and-save-data2 = Synchronizuj i zachowuj dane
appmenu-fxa-signed-in-label = Zaloguj się
appmenu-fxa-setup-sync =
    .label = Włącz synchronizację…
appmenu-fxa-show-more-tabs = Wyświetl więcej kart
appmenuitem-save-page =
    .label = Zapisz stronę jako…

## What's New panel in App menu.

whatsnew-panel-header = Co nowego
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Powiadamiaj o nowych funkcjach
    .accesskey = P

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Odkryj więcej informacji
profiler-popup-description-title =
    .value = Nagrywaj, analizuj, udostępniaj
profiler-popup-description = Współpracuj nad problemami z wydajnością, publikując profile do udostępnienia zespołowi.
profiler-popup-learn-more = Więcej informacji
profiler-popup-settings =
    .value = Ustawienia
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Zmień ustawienia…
profiler-popup-disabled =
    Profiler jest obecnie wyłączony, najprawdopodobniej z powodu otwarcia okna
    w trybie prywatnym.
profiler-popup-recording-screen = Nagrywanie…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Własne
profiler-popup-start-recording-button =
    .label = Rozpocznij nagrywanie
profiler-popup-discard-button =
    .label = Odrzuć
profiler-popup-capture-button =
    .label = Przechwyć
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = Zarządzaj historią
appmenu-reopen-all-tabs = Przywróć wszystkie karty
appmenu-reopen-all-windows = Przywróć wszystkie okna
appmenu-restore-session =
    .label = Przywróć poprzednią sesję
appmenu-clear-history =
    .label = Wyczyść historię przeglądania…
appmenu-recent-history-subheader = Ostatnio odwiedzone
appmenu-recently-closed-tabs =
    .label = Ostatnio zamknięte karty
appmenu-recently-closed-windows =
    .label = Ostatnio zamknięte okna

## Help panel

appmenu-help-header =
    .title = Pomoc programu { -brand-shorter-name }
appmenu-about =
    .label = O programie { -brand-shorter-name }
    .accesskey = O
appmenu-get-help =
    .label = Pomoc
    .accesskey = P
appmenu-help-more-troubleshooting-info =
    .label = Więcej informacji do rozwiązywania problemów
    .accesskey = n
appmenu-help-report-site-issue =
    .label = Zgłoś problem ze stroną…
appmenu-help-feedback-page =
    .label = Prześlij swoją opinię…
    .accesskey = e

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Tryb rozwiązywania problemów…
    .accesskey = T
appmenu-help-exit-troubleshoot-mode =
    .label = Wyłącz tryb rozwiązywania problemów
    .accesskey = t

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Zgłoś oszustwo internetowe…
    .accesskey = Z
appmenu-help-not-deceptive =
    .label = To nie jest oszustwo…
    .accesskey = n

## More Tools

appmenu-customizetoolbar =
    .label = Dostosuj pasek narzędzi…
appmenu-taskmanager =
    .label = Menedżer zadań
appmenu-developer-tools-subheader = Narzędzia przeglądarki
appmenu-developer-tools-extensions =
    .label = Rozszerzenia dla twórców witryn
