# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profilerarinställningar
perftools-intro-description =
    Inspelningar startar profiler.firefox.com i en ny flik. All data lagras
    lokalt, men du kan välja att ladda upp den för delning.

## All of the headings for the various sections.

perftools-heading-settings = Fullständiga inställningar
perftools-heading-buffer = Buffertinställningar
perftools-heading-features = Funktioner
perftools-heading-features-default = Funktioner (rekommenderas som standard)
perftools-heading-features-disabled = Inaktiverade Funktioner
perftools-heading-features-experimental = Experimentell
perftools-heading-threads = Trådar
perftools-heading-local-build = Lokalt bygge

##

perftools-description-intro =
    Inspelningar startar <a>profiler.firefox.com</a> i en ny flik. All data lagras
    lokalt, men du kan välja att ladda upp den för delning.
perftools-description-local-build =
    Om du profilerar ett bygge som du själv har sammanställt, på denna
    maskin, lägg till din bygg-objdir i listan nedan så att
    den kan användas för att slå upp symbolinformation.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Samplingsintervall:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Buffertstorlek:
perftools-custom-threads-label = Lägg till anpassade trådar efter namn:
perftools-devtools-interval-label = Intervall:
perftools-devtools-threads-label = Trådar:
perftools-devtools-settings-label = Inställningar

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Profilerar är inaktiverad när privat surfning är aktiverat.
    Stäng alla privata fönster för att återaktivera profileraren
perftools-status-recording-stopped-by-another-tool = Inspelningen stoppades av ett annat verktyg.
perftools-status-restart-required = Webbläsaren måste startas om för att aktivera den här funktionen.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Avbryter inspelning
perftools-request-to-get-profile-and-stop-profiler = Fångar profil

##

perftools-button-start-recording = Starta inspelning
perftools-button-capture-recording = Fånga inspelning
perftools-button-cancel-recording = Avbryt inspelning
perftools-button-save-settings = Spara inställningar och gå tillbaka
perftools-button-restart = Starta om
perftools-button-add-directory = Lägg till en katalog
perftools-button-remove-directory = Ta bort markerad
perftools-button-edit-settings = Redigera inställningar…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Huvudprocesserna för både överordnade och innehållsprocesser
perftools-thread-compositor =
    .title = Sätter samman olika målade element på sidan
perftools-thread-dom-worker =
    .title = Detta hanterar både web workers och service workers
perftools-thread-renderer =
    .title = När WebRender är aktiverat, anropar tråden som kör OpenGL
perftools-thread-render-backend =
    .title = WebRender RenderBackend-tråden
perftools-thread-paint-worker =
    .title = När målning utanför huvudtråden är aktiverad, den tråd som målningen sker på
perftools-thread-style-thread =
    .title = Stilberäkning är uppdelad i flera trådar
pref-thread-stream-trans =
    .title = Nätvärksströmstransport
perftools-thread-socket-thread =
    .title = Tråden där nätverkskoden kör alla blockerande socketanrop
perftools-thread-img-decoder =
    .title = Bildavkodningstrådar
perftools-thread-dns-resolver =
    .title = DNS-upplösning sker på den här tråden
perftools-thread-js-helper =
    .title = JS-motorns bakgrundsarbete som kompileringar utanför huvudtråden

##

perftools-record-all-registered-threads = Gå förbi val ovan och spela in alla registrerade trådar
perftools-tools-threads-input-label =
    .title = Dessa trådnamn är en kommaseparerad lista som används för att möjliggöra profilering av trådarna i profileraren. Namnet behöver bara vara en partiell matchning av trådnamnet som ska inkluderas. Den är känslig för mellanslag.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Waterfox profilerare
perftools-onboarding-message = <b>Nytt</b>: { -profiler-brand-name } är nu integrerad i utvecklarverktyg. <a>Läs mer</a> om det här kraftfulla nya verktyget.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Under en begränsad tid kan du komma åt den ursprungliga Prestanda-panelen via <a>{ options-context-advanced-settings }</a>)
perftools-onboarding-close-button =
    .aria-label = Stäng meddelandet
