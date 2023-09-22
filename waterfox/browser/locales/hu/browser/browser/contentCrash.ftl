# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Az oldal egy része összeomlott.</strong> Küldjön egy jelentést a { -brand-product-name } fejlesztőinek, hogy gyorsabban elháríthassák a problémát.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Az oldal egy része összeomlott. Küldjön egy jelentést a { -brand-product-name } fejlesztőinek, hogy gyorsabban elháríthassák a problémát.
crashed-subframe-learnmore-link =
    .value = További tudnivalók
crashed-subframe-submit =
    .label = Jelentés beküldése
    .accesskey = b

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Van egy beküldetlen hibajelentés
       *[other] Van { $reportCount } beküldetlen hibajelentés
    }
pending-crash-reports-view-all =
    .label = Megjelenítés
pending-crash-reports-send =
    .label = Küldés
pending-crash-reports-always-send =
    .label = Küldés mindig
