# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Parte desta página travou.</strong> Para deixar o { -brand-product-name } ter conhecimento deste problema e corrigir mais rápido, envie um relatório.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Parte desta página travou. Envie um relatório para o { -brand-product-name } tomar conhecimento deste problema e corrigir mais rápido.
crashed-subframe-learnmore-link =
    .value = Saiba mais
crashed-subframe-submit =
    .label = Enviar relatório
    .accesskey = E

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Você tem um relatório de travamento não enviado
       *[other] Você tem { $reportCount } relatórios de travamento não enviados
    }
pending-crash-reports-view-all =
    .label = Ver
pending-crash-reports-send =
    .label = Enviar
pending-crash-reports-always-send =
    .label = Sempre enviar
