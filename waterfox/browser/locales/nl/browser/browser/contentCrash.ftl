# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Een deel van deze pagina is gecrasht.</strong> Dien een rapport in om { -brand-product-name } te informeren over dit probleem en het sneller opgelost te krijgen.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Een deel van deze pagina is gecrasht. Dien een rapport in om { -brand-product-name } te informeren over dit probleem en het sneller opgelost te krijgen.
crashed-subframe-learnmore-link =
    .value = Meer info
crashed-subframe-submit =
    .label = Rapport verzenden
    .accesskey = z

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] U hebt een niet-verzonden crashrapport
       *[other] U hebt { $reportCount } niet-verzonden crashrapporten
    }
pending-crash-reports-view-all =
    .label = Weergeven
pending-crash-reports-send =
    .label = Verzenden
pending-crash-reports-always-send =
    .label = Altijd verzenden
