# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Uma parte desta página falhou.</strong> Para tornar o problema conhecido e ajudar a que o mesmo seja resolvido mais rapidamente no { -brand-product-name }, por favor submeta um relatório.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Uma parte desta página falhou. Para tornar o problema conhecido e ajudar a que o mesmo seja resolvido mais rapidamente no { -brand-product-name }, por favor submeta um relatório.
crashed-subframe-learnmore-link =
    .value = Saber mais
crashed-subframe-submit =
    .label = Submeter relatório
    .accesskey = S

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Tem um relatório de falha não enviado
       *[other] Tem { $reportCount } relatórios de falha não enviados
    }
pending-crash-reports-view-all =
    .label = Ver
pending-crash-reports-send =
    .label = Enviar
pending-crash-reports-always-send =
    .label = Enviar sempre
