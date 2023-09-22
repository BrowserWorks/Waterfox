# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Nastavení nástroje na měření výkonu
perftools-intro-description =
    Nahrávání spustí v novém panelu profiler.firefox.com. Všechna data jsou
    ukládána lokálně na vašem počítači, ale můžete se rozhodnout je sdílet.

## All of the headings for the various sections.

perftools-heading-settings = Plné nastavení
perftools-heading-buffer = Nastavení vyrovnávací paměti
perftools-heading-features = Funkce
perftools-heading-features-default = Funkce (ve výchozím nastavení doporučeno)
perftools-heading-features-disabled = Zakázané funkce
perftools-heading-features-experimental = Experimentální
perftools-heading-threads = Vlákna
perftools-heading-threads-jvm = Vlákna JVM
perftools-heading-local-build = Místní sestavení

##

perftools-description-intro =
    Nahrávání spustí v novém panelu <a>profiler.firefox.com</a>. Všechna data jsou
    ukládána lokálně na vašem počítači, ale můžete se rozhodnout je sdílet.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Interval vzorkování:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Velikost vyrovnávací paměti:
perftools-custom-threads-label = Přidat vlastní vlákna podle názvu:
perftools-devtools-interval-label = Interval:
perftools-devtools-threads-label = Vlákna:
perftools-devtools-settings-label = Nastavení

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = Nahrávání bylo zastaveno jiným nástrojem.
perftools-status-restart-required = Pro povolení této funkce je potřeba prohlížeč restartovat.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Ukončuje se nahrávání

##

perftools-button-start-recording = Spustit nahrávání
perftools-button-cancel-recording = Zrušit nahrávání
perftools-button-save-settings = Uložit nastavení a přejít zpět
perftools-button-restart = Restartovat
perftools-button-add-directory = Přidat adresář
perftools-button-remove-directory = Odebrat vybrané
perftools-button-edit-settings = Upravit nastavení…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Hlavní procesy pro nadřazený proces a procesy obsahu
perftools-thread-compositor =
    .title = Skládá dohromady různé vykreslené prvky na stránce
perftools-thread-renderer =
    .title = Pokud je WebRender povolen, jde o vlákno, které vykonává volání OpenGL
perftools-thread-render-backend =
    .title = Vlákno WebRender RenderBackend
perftools-thread-timer =
    .title = Časovače zpracování vláken (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = Výpočty pro styly jsou rozdělené do více vláken
pref-thread-stream-trans =
    .title = Přenos síťového toku
perftools-thread-img-decoder =
    .title = Vlákna pro dekódování obrázků
perftools-thread-dns-resolver =
    .title = V tomto vklákně probíhá překlad DNS
perftools-thread-task-controller =
    .title = Vlákno souboru vláken TaskController
perftools-thread-jvm-gecko =
    .title = Hlavní vlákno Gecko JVM
perftools-thread-jvm-nimbus =
    .title = Hlavní vlákna pro experimentální sadu SDK Nimbus
perftools-thread-jvm-glean =
    .title = Hlavní vlákna pro Glean telemetry SDK

##

perftools-record-all-registered-threads = Neuvažovat výše uvedené výběry a zaznamenávat všechna registrovaná vlákna

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Novinka</b>: { -profiler-brand-name } je teď integrovaný do nástrojů pro webové vývojáře. <a>Zjistěte více</a> o tomto novém výkonném nástroji.
perftools-onboarding-close-button =
    .aria-label = Zavřít informační zprávu

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/shared/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Vývoj webu
perftools-presets-web-developer-description = Doporučené nastavení s minimální režií pro ladění většiny webových aplikací.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description =
    { -brand-shorter-name.case-status ->
        [with-cases] Doporučené nastavení pro profilování { -brand-shorter-name(case: "gen") }.
       *[no-cases] Doporučené nastavení pro profilování aplikace { -brand-shorter-name }.
    }
perftools-presets-graphics-label = Grafika
perftools-presets-graphics-description =
    { -brand-shorter-name.case-status ->
        [with-cases] Doporučené nastavení pro ladění grafických chyb ve { -brand-shorter-name(case: "loc") }.
       *[no-cases] Doporučené nastavení pro ladění grafických chyb v aplikaci { -brand-shorter-name }.
    }
perftools-presets-media-label = Média
perftools-presets-media-description2 =
    { -brand-shorter-name.case-status ->
        [with-cases] Doporučené nastavení pro ladění chyb při přehrávání zvuku nebo videa ve { -brand-shorter-name(case: "loc") }.
       *[no-cases] Doporučené nastavení pro ladění chyb při přehrávání zvuku nebo videa v aplikaci { -brand-shorter-name }.
    }
perftools-presets-networking-label = Síť
perftools-presets-networking-description =
    { -brand-shorter-name.case-status ->
        [with-cases] Doporučené nastavení pro ladění síťových problémů ve { -brand-shorter-name(case: "loc") }.
       *[no-cases] Doporučené nastavení pro ladění síťových problémů v aplikaci { -brand-shorter-name }.
    }
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Napájení
perftools-presets-power-description =
    { -brand-shorter-name.case-status ->
        [with-cases] Doporučené nastavení pro ladění chyb ve spotřebě { -brand-shorter-name(case: "gen") }.
       *[no-cases] Doporučené nastavení pro ladění chyb ve spotřebě aplikace { -brand-shorter-name }.
    }
perftools-presets-custom-label = Vlastní

##

