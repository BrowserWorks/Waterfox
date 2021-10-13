# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings for a dialog that may open on macOS before the app's main window
## opens. The dialog prompts the user to allow the app to install itself in an
## appropriate location before relaunching itself from that location if the
## user accepts.

prompt-to-install-title =
    Dokončit instalaci { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }?
prompt-to-install-message =
    Dokončením tohoto instalačního kroku { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } zajistíte její aktuálnost a zabráníte ztrátě dat. { -brand-short-name } se objeví ve složce s aplikacemi a v Docku.
prompt-to-install-yes-button = Instalovat
prompt-to-install-no-button = Neinstalovat

## Strings for a dialog that opens if the installation failed.

install-failed-title =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] Aplikaci { -brand-short-name }
    } se nepodařilo nainstalovat.
install-failed-message =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] Aplikaci { -brand-short-name }
    } se nepodařilo nainstalovat, ale bude nadále fungovat.
