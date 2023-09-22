# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Parte de esta página falló.</strong> Para que { -brand-product-name } sepa sobre este problema y se arregle más rápido, por favor envía un informe.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Parte de esta página falló. Para que { -brand-product-name } sepa sobre este problema y se arregle más rápido, por favor envía un informe.
crashed-subframe-learnmore-link =
    .value = Saber más
crashed-subframe-submit =
    .label = Enviar informe
    .accesskey = E

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Tienes un informe de fallos sin enviar
       *[other] Tienes { $reportCount } informes de fallos sin enviar
    }
pending-crash-reports-view-all =
    .label = Ver
pending-crash-reports-send =
    .label = Enviar
pending-crash-reports-always-send =
    .label = Siempre enviar
