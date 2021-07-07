# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Effacer les données
    .style = width: 35em
clear-site-data-description = Effacer l’ensemble des cookies et des données de sites stockés par { -brand-short-name } peut vous déconnecter de certains sites web et supprimer du contenu web hors connexion. Effacer les données mises en cache n’affectera pas vos identifiants.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies et données de sites ({ $amount } { $unit })
    .accesskey = C
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies et données de sites
    .accesskey = C
clear-site-data-cookies-info = Vous pouvez être déconnecté des sites web si vous effacez ces données
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contenu web en cache ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contenu web en cache
    .accesskey = w
clear-site-data-cache-info = Les sites web devront recharger les images et les données
clear-site-data-cancel =
    .label = Annuler
    .accesskey = A
clear-site-data-clear =
    .label = Effacer
    .accesskey = E
clear-site-data-dialog =
    .buttonlabelaccept = Effacer
    .buttonaccesskeyaccept = E
