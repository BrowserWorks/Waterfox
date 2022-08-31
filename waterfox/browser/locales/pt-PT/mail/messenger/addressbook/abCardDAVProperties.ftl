# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

carddav-url-label =
    .value = Endereço CardDAV:
    .accesskey = V

carddav-refreshinterval-label =
    .label = Sincronizar:
    .accesskey = S

# Variables:
#   $minutes (integer) - Number of minutes between address book synchronizations
carddav-refreshinterval-minutes-value =
    .label =
        { $minutes ->
            [one] a cada minuto
           *[other] a { $minutes } minutos
        }

# Variables:
#   $hours (integer) - Number of hours between address book synchronizations
carddav-refreshinterval-hours-value =
    .label =
        { $hours ->
            [one] a cada hora
           *[other] a cada { $hours } horas
        }

carddav-readonly-label =
    .label = Só de leitura
    .accesskey = l
