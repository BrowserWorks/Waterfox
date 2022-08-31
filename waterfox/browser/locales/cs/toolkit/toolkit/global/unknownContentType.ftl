# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label =
        Otevřít { -brand-short-name.gender ->
            [masculine] ve { -brand-short-name(case: "loc") }
            [feminine] v { -brand-short-name(case: "loc") }
            [neuter] v { -brand-short-name(case: "loc") }
           *[other] v aplikaci { -brand-short-name }
        }
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        Nastavení lze změnit v { PLATFORM() ->
            [windows] Možnostech
           *[other] Předvolbách
        } { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }.

unknowncontenttype-intro = Stažení souboru:
unknowncontenttype-which-is = typ:
unknowncontenttype-from = zdroj:
unknowncontenttype-prompt = Chcete tento soubor uložit?
unknowncontenttype-action-question = Co má { -brand-short-name } s tímto souborem udělat?
unknowncontenttype-open-with =
    .label = Otevřít pomocí
    .accesskey = O
unknowncontenttype-other =
    .label = Jiná…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] Vybrat…
           *[other] Procházet…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] P
        }
unknowncontenttype-save-file =
    .label = Uložit soubor
    .accesskey = s
unknowncontenttype-remember-choice =
    .label = Provádět od teď s podobnými soubory automaticky.
    .accesskey = P
