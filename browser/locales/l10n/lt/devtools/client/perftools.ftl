# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profiliuoklės nuostatos
perftools-intro-description =
    Įrašinėjimai paleidžia profiler.firefox.com naujoje kortelėje. Visi duomenys
    laikomi jūsų įrenginyje, tačiau galite juos įkelti dalinimuisi.

## All of the headings for the various sections.

perftools-heading-settings = Visos nuostatos
perftools-heading-buffer = Buferio nuostatos
perftools-heading-features = Savybės
perftools-heading-features-default = Savybės (rekomenduojamos pagal numatymą)
perftools-heading-features-disabled = Išjungtos savybės
perftools-heading-features-experimental = Eksperimentinės
perftools-heading-threads = Gijos
perftools-heading-local-build = Vietinis darinys

##

perftools-description-intro =
    Įrašinėjimai paleidžia <a>profiler.firefox.com</a> naujoje kortelėje. Visi duomenys
    laikomi jūsų įrenginyje, tačiau galite juos įkelti dalinimuisi.
perftools-description-local-build =
    Jei profiliuojate savo sukompiliuotą darinį šiame kompiuteryje, pridėkite
    šio darinio „objdir“ į žemiau esantį sąrašą, kad būtų galima iš jo gauti
    simbolių informaciją.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Ėminių darymo intervalas:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Buferio dydis:
perftools-custom-threads-label = Pridėti kitas gijas pagal pavadinimą:
perftools-devtools-interval-label = Intervalas:
perftools-devtools-threads-label = Gijos:
perftools-devtools-settings-label = Nuostatos

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Profiliuokė išjungiama privačiojo naršymo veiksenoje.
    Užverkite visus privačius langus, norėdami įjungti profiliuoklę
perftools-status-recording-stopped-by-another-tool = Įrašinėjimą sustabdė kita priemonė.
perftools-status-restart-required = Norint įjungti šį funkcionalumą, reikia perleisti naršyklę.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Stabdomas įrašinėjimas
perftools-request-to-get-profile-and-stop-profiler = Užfiksuojamas profilis

##

perftools-button-start-recording = Pradėti įrašinėjimą
perftools-button-capture-recording = Užfiksuoti įrašinėjimą
perftools-button-cancel-recording = Nutraukti įrašinėjimą
perftools-button-save-settings = Įrašyti nuostatas ir grįžti
perftools-button-restart = Perleisti
perftools-button-add-directory = Pridėti aplanką
perftools-button-remove-directory = Pašalinti pažymėtus
perftools-button-edit-settings = Keisti nuostatas…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Pagrindiniai procesai tiek tėviniam procesui, tiek turinio procesams
perftools-thread-compositor =
    .title = Kartu sujungia skirtingus tinklalapyje nupieštus elementus
perftools-thread-dom-worker =
    .title = Taikoma tiek saityno scenarijams, tiek aptarnavimo scenarijams
perftools-thread-renderer =
    .title = Kai „WebRender“ yra įjungtas, tai gija, vykdanti „OpenGL“ kreipinius
perftools-thread-render-backend =
    .title = „WebRender“ priklausanti „RenderBackend“ gija
perftools-thread-paint-worker =
    .title = Kai yra įjungtas piešimas už pagrindinės gijos ribų, tai gija, kurioje vyksta piešimas
perftools-thread-style-thread =
    .title = Stilių apskaičiavimas yra padalintas į keletą gijų
pref-thread-stream-trans =
    .title = Tinklo srauto transportas
perftools-thread-socket-thread =
    .title = Gija, kurioje tinklo kodas vykdo bet kokius blokuojančius jungčių kreipinius
perftools-thread-img-decoder =
    .title = Vaizdų iškodavimo gijos
perftools-thread-dns-resolver =
    .title = Šioje gijoje vykdomos DNS užklausos
perftools-thread-js-helper =
    .title = JS variklio foninis darbas, toks kaip kompiliavimas už pagrindinės gijos ribų

##

perftools-record-all-registered-threads = Apeiti pasirinkimus iš aukščiau, ir įrašinėti visas registruotas gijas
perftools-tools-threads-input-label =
    .title = Šie gijų pavadinimai yra kableliais atskirtas sąrašas, naudojamas įjungti gijų profiliavimą. Užtenka, kad pavadinimas tik dalinai atitiktų gijos pavadinimą. Svarbu tuščios vietos simboliai.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Firefox Profiler
perftools-onboarding-message = <b>Nauja</b>: „{ -profiler-brand-name }“ dabar integruota į programuotojų priemones. <a>Sužinokite daugiau</a> apie šį naują galingą įrankį.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (kurį laiką dar galėsite pasiekti ankstesnį našumo polangį per <a>{ options-context-advanced-settings }</a>)
perftools-onboarding-close-button =
    .aria-label = Užverti supažindinimo pranešimą
