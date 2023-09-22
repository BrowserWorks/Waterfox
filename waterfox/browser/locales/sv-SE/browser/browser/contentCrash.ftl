# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>En del av den här sidan kraschade.</strong> För att informera { -brand-product-name } om det här problemet och få det åtgärdat snabbare, skicka en rapport.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = En del av den här sidan kraschade. För att informera { -brand-product-name } om det här problemet och få det åtgärdat snabbare, skicka en rapport.
crashed-subframe-learnmore-link =
    .value = Läs mer
crashed-subframe-submit =
    .label = Skicka in rapport
    .accesskey = S

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Du har en ej inskickad kraschrapport
       *[other] Du har { $reportCount } ej inskickade kraschrapporter
    }
pending-crash-reports-view-all =
    .label = Visa
pending-crash-reports-send =
    .label = Skicka
pending-crash-reports-always-send =
    .label = Skicka alltid
