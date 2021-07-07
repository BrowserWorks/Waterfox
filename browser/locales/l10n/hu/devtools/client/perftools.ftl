# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profilozó beállításai
perftools-intro-description =
    A rögzítések megnyitják a profiler.firefox.com oldalt egy új lapon. Minden adat
    helyben lesz tárolva, de lehetősége lesz feltölteni, hogy megossza azt.

## All of the headings for the various sections.

perftools-heading-settings = Teljes beállítások
perftools-heading-buffer = Pufferbeállítások
perftools-heading-features = Funkciók
perftools-heading-features-default = Funkciók (alapértelmezés szerint ajánlott)
perftools-heading-features-disabled = Letiltott funkciók
perftools-heading-features-experimental = Kísérleti
perftools-heading-threads = Szálak
perftools-heading-local-build = Helyi összeállítás

##

perftools-description-intro =
    A rögzítések megnyitják a <a>profiler.firefox.com</a> oldalt egy új lapon. Minden adat
    helyben lesz tárolva, de lehetősége lesz feltölteni, hogy megossza azt.
perftools-description-local-build =
    Ha egy olyan összeállítást profiloz, amelyet saját maga fordított le,
    ezen a gépen, akkor adja az összeállítás tárgykönyvtárát a lenti listához,
    hogy használható legyen a szimbóluminformációk megkereséséhez.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Mintavételi intervallum:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Puffer mérete:
perftools-custom-threads-label = Egyéni szálak hozzáadása név szerint:
perftools-devtools-interval-label = Intervallum:
perftools-devtools-threads-label = Szálak:
perftools-devtools-settings-label = Beállítások

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    A profilozó le van tiltva, ha a privát böngészés engedélyezett.
    A profilozó újbóli engedélyezéséhez zárjon be minden privát ablakot.
perftools-status-recording-stopped-by-another-tool = A felvételt egy másik eszköz leállította.
perftools-status-restart-required = A funkció bekapcsolásához újra kell indítani a böngészőt.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Felvétel leállítása
perftools-request-to-get-profile-and-stop-profiler = Profil rögzítése

##

perftools-button-start-recording = Felvétel indítása
perftools-button-capture-recording = Felvétel rögzítése
perftools-button-cancel-recording = Rögzítés megszakítása
perftools-button-save-settings = Beállítások mentése és visszatérés
perftools-button-restart = Újraindítás
perftools-button-add-directory = Könyvtár hozzáadása
perftools-button-remove-directory = Kijelölt eltávolítása
perftools-button-edit-settings = Beállítások szerkesztése…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = A szülőfolyamat és a tartalomfolyamatok fő folyamatai
perftools-thread-compositor =
    .title = Az oldal különböző festett elemeit kompozitálja össze
perftools-thread-dom-worker =
    .title = Ez kezeli a web workereket és a service workereket
perftools-thread-renderer =
    .title = Ha a WebRender engedélyezett, akkor az OpenGL-hívásokat végrehajtó szál
perftools-thread-render-backend =
    .title = A WebRender RenderBackend szála
perftools-thread-paint-worker =
    .title = Ha a főszálon kívüli festés engedélyezett, akkor az a szál, amelyen a festés történik
perftools-thread-style-thread =
    .title = A stílusok számítása több szálra oszlik
pref-thread-stream-trans =
    .title = Hálózati adatátvitel
perftools-thread-socket-thread =
    .title = Az a szál, ahol a hálózati kód a blokkoló foglalathívásokat futtatja
perftools-thread-img-decoder =
    .title = Képdekódoló szálak
perftools-thread-dns-resolver =
    .title = A DNS-feloldás ezen a szálon történik
perftools-thread-js-helper =
    .title = A JS motor háttérben futó feladatai, mint a főszálon kívüli fordítások

##

perftools-record-all-registered-threads = A fenti kiválasztások megkerülése, és az összes regisztrált szál rögzítése
perftools-tools-threads-input-label =
    .title = Az itt felsorolt szálnevek vesszővel elválasztott listája a profilozóban a szálak profilozásának engedélyezésére szolgál. A szál már nevének részleges egyezése esetén is hozzáadásra kerül. A mező szóközökre érzékeny.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Firefox profilozó
perftools-onboarding-message = <b>Új</b>: A { -profiler-brand-name } mostantól a Fejlesztői eszközökbe integrált. <a>Tudjon meg többet</a> erről a hatékony új eszközről.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Korlátozott ideig elérheti az eredeti Teljesítmény panelt is a <a>{ options-context-advanced-settings }</a> segítségévél)
perftools-onboarding-close-button =
    .aria-label = A bemutató üzenet bezárása
