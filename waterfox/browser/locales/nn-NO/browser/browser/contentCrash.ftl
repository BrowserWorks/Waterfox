# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Ein del av denne sida krasja.</strong> For å informere { -brand-product-name } om dette problemet og få det løyst raskare, må du sende inn ein rapport.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Ein del av denne sida krasja. For å informere { -brand-product-name } om dette problemet og få det løyst raskare, må du sende inn ein rapport.
crashed-subframe-learnmore-link =
    .value = Les meir
crashed-subframe-submit =
    .label = Send inn rapport
    .accesskey = S

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Du har ein usendt krasjrapport
       *[other] Du har { $reportCount } usende krasjrapportar
    }
pending-crash-reports-view-all =
    .label = Vis
pending-crash-reports-send =
    .label = Send
pending-crash-reports-always-send =
    .label = Send alltid
