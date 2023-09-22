# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings for a dialog that may open on macOS before the app's main window
## opens. The dialog prompts the user to allow the app to install itself in an
## appropriate location before relaunching itself from that location if the
## user accepts.

prompt-to-install-title =
    { -brand-short-name.case-status ->
        [with-cases] Dokončit instalaci { -brand-short-name(case: "gen") }?
       *[no-cases] Dokončit instalaci aplikace { -brand-short-name }?
    }
prompt-to-install-message =
    { -brand-short-name.gender ->
        [masculine] Dokončením tohoto instalačního kroku { -brand-short-name(case: "gen") } zajistíte jeho aktuálnost a zabráníte ztrátě dat. { -brand-short-name } se objeví ve složce s aplikacemi a v Docku.
        [feminine] Dokončením tohoto instalačního kroku { -brand-short-name(case: "gen") } zajistíte její aktuálnost a zabráníte ztrátě dat. { -brand-short-name } se objeví ve složce s aplikacemi a v Docku.
        [neuter] Dokončením tohoto instalačního kroku { -brand-short-name(case: "gen") } zajistíte jeho aktuálnost a zabráníte ztrátě dat. { -brand-short-name } se objeví ve složce s aplikacemi a v Docku.
       *[other] Dokončením tohoto instalačního kroku aplikace { -brand-short-name } zajistíte její aktuálnost a zabráníte ztrátě dat. { -brand-short-name } se objeví ve složce s aplikacemi a v Docku.
    }
prompt-to-install-yes-button = Instalovat
prompt-to-install-no-button = Neinstalovat

## Strings for a dialog that opens if the installation failed.

install-failed-title =
    { -brand-short-name.case-status ->
        [with-cases] { -brand-short-name(case: "acc") } se nepodařilo nainstalovat.
       *[no-cases] Aplikaci { -brand-short-name } se nepodařilo nainstalovat.
    }
install-failed-message =
    { -brand-short-name.case-status ->
        [with-cases] { -brand-short-name(case: "acc") } se nepodařilo nainstalovat, ale bude nadále fungovat.
       *[no-cases] Aplikaci { -brand-short-name } se nepodařilo nainstalovat, ale bude nadále fungovat.
    }

## Strings for a dialog that recommends to the user to start an existing
## installation of the app in the Applications directory if one is detected,
## rather than the app that was double-clicked in a .dmg.

prompt-to-launch-existing-app-title =
    { -brand-short-name.case-status ->
        [with-cases] Chcete otevřít nainstalovanou verzi { -brand-short-name(case: "gen") }?
       *[no-cases] Chcete otevřít nainstalovanou verzi aplikace { -brand-short-name }?
    }
prompt-to-launch-existing-app-message =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") } už máte nainstalovaný
        [feminine] { -brand-short-name(case: "acc") } už máte nainstalovanou
        [neuter] { -brand-short-name(case: "acc") } už máte nainstalované
       *[other] Aplikaci { -brand-short-name } už máte nainstalovanou
    }. Aby nedošlo ke ztrátě dat, doporučujeme používat nainstalovanou verzi { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.
prompt-to-launch-existing-app-yes-button = Otevřít nainstalovanou verzi
prompt-to-launch-existing-app-no-button = Ne, děkuji
