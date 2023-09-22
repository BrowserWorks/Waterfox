# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Une partie de cette page a planté.</strong> Pour informer { -brand-product-name } de ce problème et le résoudre plus rapidement, veuillez envoyer un rapport.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Une partie de cette page a planté. Pour informer { -brand-product-name } de ce problème et le résoudre plus rapidement, veuillez envoyer un rapport.
crashed-subframe-learnmore-link =
    .value = En savoir plus
crashed-subframe-submit =
    .label = Envoyer un rapport
    .accesskey = r

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Un rapport de plantage n’a pas été envoyé
       *[other] { $reportCount } rapports de plantage n’ont pas été envoyés
    }
pending-crash-reports-view-all =
    .label = Afficher
pending-crash-reports-send =
    .label = Envoyer
pending-crash-reports-always-send =
    .label = Toujours envoyer
