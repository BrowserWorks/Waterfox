# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profilerinstellingen
perftools-intro-description =
    Opnames starten profiler.firefox.com in een nieuw tabblad. Alle gegevens worden lokaal
    opgeslagen, maar u kunt ervoor kiezen ze te uploaden om ze te delen.

## All of the headings for the various sections.

perftools-heading-settings = Volledige instellingen
perftools-heading-buffer = Bufferinstellingen
perftools-heading-features = Functies
perftools-heading-features-default = Functies (standaard aan aanbevolen)
perftools-heading-features-disabled = Uitgeschakelde functies
perftools-heading-features-experimental = Experimenteel
perftools-heading-threads = Threads
perftools-heading-threads-jvm = JVM-threads
perftools-heading-local-build = Lokale build

##

perftools-description-intro =
    Opnames starten <a>profiler.firefox.com</a> in een nieuw tabblad. Alle gegevens worden lokaal
    opgeslagen, maar u kunt ervoor kiezen ze te uploaden om ze te delen.
perftools-description-local-build =
    Als u een build profileert die u zelf, op deze machine, gecompileerd heeft,
    voeg dan de objdir van uw build aan de onderstaande lijst toe, zodat
    deze kan worden gebruikt om symboolinformatie op te zoeken.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Steekproefinterval:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Buffergrootte:
perftools-custom-threads-label = Aangepaste threads op naam toevoegen:
perftools-devtools-interval-label = Interval:
perftools-devtools-threads-label = Threads:
perftools-devtools-settings-label = Instellingen

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = De opname is door een ander hulpmiddel gestopt.
perftools-status-restart-required = De browser moet opnieuw worden gestart om deze functie in te schakelen.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Opname wordt gestopt
perftools-request-to-get-profile-and-stop-profiler = Profiel wordt vastgelegd

##

perftools-button-start-recording = Opname starten
perftools-button-capture-recording = Opname vastleggen
perftools-button-cancel-recording = Opname annuleren
perftools-button-save-settings = Instellen opslaan en teruggaan
perftools-button-restart = Herstarten
perftools-button-add-directory = Een directory toevoegen
perftools-button-remove-directory = Geselecteerde verwijderen
perftools-button-edit-settings = Instellingen bewerken…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = De hoofdprocessen voor zowel het bovenliggende proces als de inhoudsprocessen
perftools-thread-compositor =
    .title = Stelt verschillende painted elementen op de pagina samen
perftools-thread-dom-worker =
    .title = Dit verwerkt zowel webworkers als serviceworkers
perftools-thread-renderer =
    .title = Als WebRender is ingeschakeld, de thread die OpenGL-aanroepen uitvoert
perftools-thread-render-backend =
    .title = De WebRender RenderBackend-thread
perftools-thread-paint-worker =
    .title = Als off-main-threadpainting is ingeschakeld, de thread waarop painting wordt uitgevoerd
perftools-thread-timer =
    .title = De timers voor het afhandelen van threads (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = Stijlberekening is opgesplitst in meerdere threads
pref-thread-stream-trans =
    .title = Netwerkstroomtransport
perftools-thread-socket-thread =
    .title = De thread waarin netwerkcode alle blokkerende socket-aanroepen uitvoert
perftools-thread-img-decoder =
    .title = Afbeeldingsontsleutelingsthreads
perftools-thread-dns-resolver =
    .title = Op deze thread vindt DNS-omzetting plaats
perftools-thread-task-controller =
    .title = TaskController-threadpoolthreads
perftools-thread-jvm-gecko =
    .title = De belangrijkste Gecko JVM-thread
perftools-thread-jvm-nimbus =
    .title = De belangrijkste threads voor de Nimbus-experimenten-SDK
perftools-thread-jvm-default-dispatcher =
    .title = De standaard dispatcher voor de Kotlin-coroutines-bibliotheek
perftools-thread-jvm-glean =
    .title = De belangrijkste threads voor de Glean-telemetrie-SDK
perftools-thread-jvm-arch-disk-io =
    .title = De IO-dispatcher voor de Kotlin-coroutines-bibliotheek
perftools-thread-jvm-pool =
    .title = Threads gemaakt in een naamloze thread-pool

##

perftools-record-all-registered-threads = Bovenstaande selectie omzeilen en alle geregistreerde threads opnemen
perftools-tools-threads-input-label =
    .title = Deze threadnamen zijn een kommagescheiden lijst, die wordt gebruikt om het profileren van de threads in de profiler mogelijk te maken. De naam hoeft maar deels overeen te komen met de threadnaam om opgenomen te worden. Gevoelig voor witruimte.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Nieuw</b>: { -profiler-brand-name } is nu geïntegreerd in de Ontwikkelaarshulpmiddelen. <a>Meer info</a> over dit krachtige nieuwe hulpmiddel.
perftools-onboarding-close-button =
    .aria-label = Het welkomstbericht sluiten

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Webontwikkelaar
perftools-presets-web-developer-description = Aanbevolen voorinstelling voor de meeste foutopsporing in web-apps, met lage overhead.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = Aanbevolen voorinstelling voor profileren van { -brand-shorter-name }.
perftools-presets-graphics-label = Grafisch
perftools-presets-graphics-description = Voorinstelling voor het onderzoeken van grafische bugs in { -brand-shorter-name }.
perftools-presets-media-label = Media
perftools-presets-media-description2 = Voorinstelling voor het onderzoeken van audio- en videobugs in { -brand-shorter-name }.
perftools-presets-networking-label = Netwerk
perftools-presets-networking-description = Voorinstelling voor het onderzoeken van netwerkbugs in { -brand-shorter-name }.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Vermogen
perftools-presets-power-description = Voorinstelling voor het onderzoeken van stroomverbruikbugs in { -brand-shorter-name }, met lage overhead.
perftools-presets-custom-label = Aangepast

##

