# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Eliminazione dei dati
    .style = width: 40em
clear-site-data-description = L’eliminazione di cookie e dati dei siti web salvati da { -brand-short-name } potrebbe disconnettere l’utente da siti web o rimuovere contenuti per l’utilizzo non in linea. La rimozione della cache non ha alcun effetto sugli accessi effettuati.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie e dati dei siti web ({ $amount } { $unit })
    .accesskey = C
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie e dati dei siti web
    .accesskey = C
clear-site-data-cookies-info = Potrebbe comportare la disconnessione da siti web
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contenuti web in cache ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contenuti web in cache
    .accesskey = w
clear-site-data-cache-info = Immagini e dati dei siti web dovranno essere riscaricati
clear-site-data-cancel =
    .label = Annulla
    .accesskey = A
clear-site-data-clear =
    .label = Elimina
    .accesskey = E
clear-site-data-dialog =
    .buttonlabelaccept = Elimina
    .buttonaccesskeyaccept = E
