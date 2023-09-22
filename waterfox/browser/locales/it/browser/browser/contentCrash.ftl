# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Una parte di questa pagina si è bloccata.</strong> Invia una segnalazione a { -brand-product-name } per comunicare questo problema e fare in modo che venga risolto più rapidamente.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Una parte di questa pagina si è bloccata. Invia una segnalazione a { -brand-product-name } per comunicare questo problema e fare in modo che venga risolto più rapidamente.
crashed-subframe-learnmore-link =
    .value = Ulteriori informazioni
crashed-subframe-submit =
    .label = Invia segnalazione
    .accesskey = s

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] È presente una segnalazione di arresto anomalo non ancora inviata
       *[other] Sono presenti { $reportCount } segnalazioni di arresto anomalo non ancora inviate
    }
pending-crash-reports-view-all =
    .label = Visualizza
pending-crash-reports-send =
    .label = Invia
pending-crash-reports-always-send =
    .label = Invia sempre
