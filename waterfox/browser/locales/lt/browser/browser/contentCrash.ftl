# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Dalis šio tinklalapio užstrigo.</strong> Norėdami pranešti apie šią problemą „{ -brand-product-name }“ ir greičiau ją išspręsti, nusiųskite pranešimą.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Dalis šio tinklalapio užstrigo. Norėdami pranešti apie šią problemą „{ -brand-product-name }“ ir greičiau ją išspręsti, nusiųskite pranešimą.
crashed-subframe-learnmore-link =
    .value = Sužinoti daugiau
crashed-subframe-submit =
    .label = Siųsti pranešimą
    .accesskey = S

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Esate nenusiuntę { $reportCount } strigties pranešimo
        [few] Esate nenusiuntę { $reportCount } strigčių pranešimų
       *[other] Esate nenusiuntę { $reportCount } strigčių pranešimų
    }
pending-crash-reports-view-all =
    .label = Peržiūrėti
pending-crash-reports-send =
    .label = Siųsti
pending-crash-reports-always-send =
    .label = Siųsti visada
