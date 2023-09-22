# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Abrir menú

# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }

# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }

# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Abrir { $targetURI } en una pestaña nueva

# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Descartar { $tabTitle }

# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Ahora mismo

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Eliminar
    .accesskey = D
fxviewtabrow-forget-about-this-site = Olvidarse de este sitio…
    .accesskey = F
fxviewtabrow-open-in-window = Abrir en una nueva ventana
    .accesskey = N
fxviewtabrow-open-in-private-window = Abrir en una nueva ventana privada
    .accesskey = P
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Guardar en marcadores…
    .accesskey = B
fxviewtabrow-save-to-pocket = Guardar en { -pocket-brand-name }
    .accesskey = o
fxviewtabrow-copy-link = Copiar enlace
    .accesskey = L
