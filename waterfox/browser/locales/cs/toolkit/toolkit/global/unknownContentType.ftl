# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label =
        { -brand-short-name.case-status ->
            [with-cases] Otevřít ve { -brand-short-name(case: "loc") }
           *[no-cases] Otevřít v aplikaci { -brand-short-name }
        }
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows]
                { -brand-short-name.case-status ->
                    [with-cases] Nastavení lze změnit v Možnostech { -brand-short-name(case: "gen") }.
                   *[no-cases] Nastavení lze změnit v Možnostech aplikace { -brand-short-name }.
                }
           *[other]
                { -brand-short-name.case-status ->
                    [with-cases] Nastavení lze změnit v Předvolbách { -brand-short-name(case: "gen") }.
                   *[no-cases] Nastavení lze změnit v Předvolbách aplikace { -brand-short-name }.
                }
        }

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
