# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Ustawienia profilera
perftools-intro-description =
    Nagrania otwierają witrynę profiler.firefox.com w nowej karcie. Wszystkie dane
    są przechowywane lokalnie, ale można przesłać je w celu udostępnienia.

## All of the headings for the various sections.

perftools-heading-settings = Pełne ustawienia
perftools-heading-buffer = Ustawienia bufora
perftools-heading-features = Funkcje
perftools-heading-features-default = Funkcje (zalecane domyślnie)
perftools-heading-features-disabled = Wyłączone funkcje
perftools-heading-features-experimental = Eksperymentalne
perftools-heading-threads = Wątki
perftools-heading-local-build = Lokalna kompilacja

##

perftools-description-intro =
    Nagrania otwierają witrynę <a>profiler.firefox.com</a> w nowej karcie. Wszystkie dane
    są przechowywane lokalnie, ale można przesłać je w celu udostępnienia.
perftools-description-local-build =
    Jeśli profilowana jest samodzielnie skompilowana wersja na tym komputerze,
    dodaj objdir swojej kompilacji do poniższej listy, aby można było wyszukać
    informacje o symbolach.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Przedział próbkowania:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Rozmiar bufora:

perftools-custom-threads-label = Dodaj własne wątki według nazw:

perftools-devtools-interval-label = Przedział:
perftools-devtools-threads-label = Wątki:
perftools-devtools-settings-label = Ustawienia

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Po włączeniu trybu prywatnego profiler jest wyłączony.
    Zamknij wszystkie okna w trybie prywatnym, aby ponownie włączyć profiler
perftools-status-recording-stopped-by-another-tool = Nagrywanie zostało zatrzymane przez inne narzędzie.
perftools-status-restart-required = Konieczne jest ponowne uruchomienie przeglądarki, aby włączyć tę funkcję.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Zatrzymywanie nagrywania
perftools-request-to-get-profile-and-stop-profiler = Przechwytywanie profilu

##

perftools-button-start-recording = Rozpocznij nagrywanie
perftools-button-capture-recording = Przechwyć nagranie
perftools-button-cancel-recording = Anuluj nagrywanie
perftools-button-save-settings = Zapisz ustawienia i wróć
perftools-button-restart = Uruchom ponownie
perftools-button-add-directory = Dodaj katalog
perftools-button-remove-directory = Usuń zaznaczone
perftools-button-edit-settings = Zmień ustawienia…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Główne procesy dla procesu nadrzędnego i procesów treści
perftools-thread-compositor =
    .title = Składa razem różne narysowane elementy na stronie
perftools-thread-dom-worker =
    .title = Obsługuje wątki sieciowe i wątki usługowe
perftools-thread-renderer =
    .title = Wątek wykonujący wywołania OpenGL, kiedy WebRender jest włączony
perftools-thread-render-backend =
    .title = Wątek RenderBackend silnika WebRender
perftools-thread-paint-worker =
    .title = Wątek, w którym odbywa się rysowanie, kiedy rysowanie poza wątkiem głównym jest włączone
perftools-thread-style-thread =
    .title = Obliczanie stylów jest rozdzielone na wiele wątków
pref-thread-stream-trans =
    .title = Przesyłanie strumienia sieciowego
perftools-thread-socket-thread =
    .title = Wątek, w którym kod sieciowy wykonuje blokujące wywołania gniazd
perftools-thread-img-decoder =
    .title = Wątki dekodowania obrazów
perftools-thread-dns-resolver =
    .title = Rozwiązywanie DNS odbywa się w tym wątku

perftools-thread-task-controller =
    .title = Wątki puli wątków TaskController

##

perftools-record-all-registered-threads = Pomiń powyższy wybór i nagraj wszystkie zarejestrowane wątki

perftools-tools-threads-input-label =
    .title = Te nazwy wątków to lista oddzielona przecinkami, która jest używana do włączenia profilowania wątków w profilerze. Nazwa może tylko częściowo pasować do nazwy wątku, aby została uwzględniona. Spacje są rozróżniane.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>Nowość</b>: { -profiler-brand-name } jest teraz zintegrowany z narzędziami dla programistów. <a>Więcej informacji</a> o tym nowym potężnym narzędziu.

# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Przez ograniczony czas można korzystać z poprzedniego panelu wydajności w sekcji <a>{ options-context-advanced-settings }</a>)

perftools-onboarding-close-button =
    .aria-label = Zamknij ten komunikat
