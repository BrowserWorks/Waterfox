# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Limpar dados
    .style = width: 35em
clear-site-data-description = Limpar todos os cookies e dados de sites armazenados pelo { -brand-short-name } pode terminar sessões nos sites e remover conteúdo web offline. Limpar dados em cache não irá afetar as suas credenciais.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies e dados de sites ({ $amount } { $unit })
    .accesskey = s
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies e dados de sites
    .accesskey = s
clear-site-data-cookies-info = Se for limpo, pode terminar sessões em sites
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Conteúdo Web em cache ({ $amount } { $unit })
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Conteúdo Web em cache
    .accesskey = W
clear-site-data-cache-info = Irá obrigar que os sites recarreguem imagens e dados
clear-site-data-cancel =
    .label = Cancelar
    .accesskey = C
clear-site-data-clear =
    .label = Limpar
    .accesskey = L
clear-site-data-dialog =
    .buttonlabelaccept = Limpar
    .buttonaccesskeyaccept = L
