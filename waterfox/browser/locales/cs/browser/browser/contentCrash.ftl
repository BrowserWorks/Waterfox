# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message =
    { -brand-shorter-name.case-status ->
        [with-cases] <strong>Část této stránky spadla.</strong> Pokud chcete autorům { -brand-product-name(case: "gen") } tento problém nahlásit pro zrychlení opravy, odešlete prosím hlášení.
       *[no-cases] <strong>Část této stránky spadla.</strong> Pokud chcete autorům aplikace { -brand-product-name } tento problém nahlásit pro zrychlení opravy, odešlete prosím hlášení.
    }

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title =
        { -brand-product-name.case-status ->
            [with-cases] Část této stránky spadla. Pokud chcete autorům { -brand-product-name(case: "gen") } tento problém nahlásit pro zrychlení opravy, odešlete prosím hlášení.
           *[no-cases] Část této stránky spadla. Pokud chcete autorům aplikace { -brand-product-name } tento problém nahlásit pro zrychlení opravy, odešlete prosím hlášení.
        }
crashed-subframe-learnmore-link =
    .value = Zjistit více
crashed-subframe-submit =
    .label = Odeslat hlášení
    .accesskey = d

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Máte neodeslané hlášení o pádu
        [few] Máte { $reportCount } neodeslaná hlášení o pádu
       *[other] Máte { $reportCount } neodeslaných hlášení o pádu
    }
pending-crash-reports-view-all =
    .label = Zobrazit
pending-crash-reports-send =
    .label = Odeslat
pending-crash-reports-always-send =
    .label = Vždy odeslat
