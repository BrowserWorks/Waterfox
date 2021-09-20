# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profilerings-indstillinger
perftools-intro-description =
    Optagelser starter profiler.firefox.com i et nyt faneblad. Alle data gemmes
    lokalt, men du kan vælge at uploade og dele dem.

## All of the headings for the various sections.

perftools-heading-settings = Alle indstillinger
perftools-heading-buffer = Buffer-indstillinger
perftools-heading-features = Funktioner
perftools-heading-features-default = Funktioner (anbefales som standard)
perftools-heading-features-disabled = Deaktiverede funktioner
perftools-heading-features-experimental = Eksperimentel
perftools-heading-threads = Tråde
perftools-heading-local-build = Lokalt build

##

perftools-description-intro =
    Optagelser starter <a>profiler.firefox.com</a> i et nyt faneblad. Alle data gemmes
    lokalt, men du kan vælge at uploade og dele dem.
perftools-description-local-build =
    Hvis du profilerer et build, du selv har kompileret på denne maskine
    så tilføj dit builds objdir på listen nedenfor, så det kan bruges til at
    slå symbol-information op.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Sampling-interval:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Buffer-størrelse:
perftools-custom-threads-label = Tilføj tilpassede tråde ved deres navne:
perftools-devtools-interval-label = Interval:
perftools-devtools-threads-label = Tråde:
perftools-devtools-settings-label = Indstillinger

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Profilering er deaktiveret, når privat browsing er aktiveret.
    Luk alle private vinduer for at aktivere profilering igen.
perftools-status-recording-stopped-by-another-tool = Optagelsen blev stoppet af et andet værktøj.
perftools-status-restart-required = Browseren skal genstartes for at aktivere denne funktion.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Stopper optagelser
perftools-request-to-get-profile-and-stop-profiler = Indfanger profil

##

perftools-button-start-recording = Start optagelse
perftools-button-capture-recording = Indfang optagelse
perftools-button-cancel-recording = Afbryd optagelse
perftools-button-save-settings = Gem indstillinger og gå tilbage
perftools-button-restart = Genstart
perftools-button-add-directory = Tilføj en mappe
perftools-button-remove-directory = Fjern valgte
perftools-button-edit-settings = Rediger indstillinger…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Hovedprocesserne for både forældre-processen og indholds-processerne.
perftools-thread-compositor =
    .title = Sammensætter forskellige painted elementer på siden
perftools-thread-dom-worker =
    .title = Dette håndterer både web-workers og service-workers
perftools-thread-renderer =
    .title = Når WebRender er aktiveret, kalder tråden, der udfører OpenGL
perftools-thread-render-backend =
    .title = WebRender RenderBackend-tråden
perftools-thread-paint-worker =
    .title = Når off-main-thread painting er aktiveret, tråden på hvilken painting sker
perftools-thread-style-thread =
    .title = Style-beregning opdeles på flere tråde
pref-thread-stream-trans =
    .title = Netværks-stream-transport
perftools-thread-socket-thread =
    .title = Tråden hvor netværks-kode udfører blokerende socket-kald
perftools-thread-img-decoder =
    .title = Billedafkodnings-tråde
perftools-thread-dns-resolver =
    .title = DNS-opslag foregår på denne tråd
perftools-thread-js-helper =
    .title = Baggrundsarbejde for JS-motoren, fx off-main-thread-kompileringer

##

perftools-record-all-registered-threads = Ignorer valg ovenfor og optag alle registrerede tråde
perftools-tools-threads-input-label =
    .title = Disse tråd-navne er en kommasepareret liste, der bruges til at aktivere profilering af trådene i profileringsværktøjet. Navnet behøver bare at stemme delvist overens med trådnavnet for at blive inkluderet. Mellemrum indgår i sammenligningen.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Waterfox Profiler
perftools-onboarding-message = <b>Nyhed</b>: { -profiler-brand-name } er nu en del af Udviklerværktøj. <a>Læs mere</a> om dette praktiske nye værktøj.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (I en begrænset periode kan du se det originale Ydelses-panel i <a>{ options-context-advanced-settings }</a>)
perftools-onboarding-close-button =
    .aria-label = Luk introduktions-beskeden
