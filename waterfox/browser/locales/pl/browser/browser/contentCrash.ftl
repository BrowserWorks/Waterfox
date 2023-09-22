# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Część tej strony uległa awarii.</strong> Prosimy to zgłosić, aby powiadomić twórców przeglądarki { -brand-product-name } o problemie i przyspieszyć jego naprawienie.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Część tej strony uległa awarii. Prosimy to zgłosić, aby powiadomić twórców przeglądarki { -brand-product-name } o problemie i przyspieszyć jego naprawienie.
crashed-subframe-learnmore-link =
    .value = Więcej informacji
crashed-subframe-submit =
    .label = Zgłoś awarię
    .accesskey = Z

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Nieprzesłane zgłoszenie awarii
        [few] { $reportCount } nieprzesłane zgłoszenia awarii
       *[many] { $reportCount } nieprzesłanych zgłoszeń awarii
    }
pending-crash-reports-view-all =
    .label = Wyświetl
pending-crash-reports-send =
    .label = Prześlij
pending-crash-reports-always-send =
    .label = Zawsze przesyłaj
