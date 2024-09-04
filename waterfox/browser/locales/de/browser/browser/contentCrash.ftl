# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Ein Teil der Seite ist abgestürzt.</strong> Übermitteln Sie bitte einen Bericht, um { -brand-product-name } über dieses Problem zu informieren und beim Beheben des Fehlers zu helfen.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Ein Teil der Seite ist abgestürzt. Übermitteln Sie bitte einen Bericht, um { -brand-product-name } über dieses Problem zu informieren und beim Beheben des Fehlers zu helfen.
crashed-subframe-learnmore-link =
    .value = Weitere Informationen
crashed-subframe-submit =
    .label = Bericht senden
    .accesskey = B

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Es gibt einen nicht gesendeten Absturzbericht.
       *[other] Es gibt { $reportCount } nicht gesendete Absturzberichte.
    }
pending-crash-reports-view-all =
    .label = Ansehen
pending-crash-reports-send =
    .label = Senden
pending-crash-reports-always-send =
    .label = Immer senden
