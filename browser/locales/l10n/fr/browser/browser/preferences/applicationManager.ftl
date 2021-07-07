# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

app-manager-window =
    .title = Détails de l’application
    .style = width: 30em; min-height: 20em;

app-manager-remove =
    .label = Supprimer
    .accesskey = S

# Variables:
#   $type (String) - the URI scheme of the link (e.g. mailto:)
app-manager-handle-protocol = Les applications suivantes peuvent être utilisées pour Liens { $type }.

# Variables:
#   $type (String) - the MIME type (e.g. application/binary)
app-manager-handle-file = Les applications suivantes peuvent être utilisées pour Contenu { $type }.

## These strings are followed, on a new line,
## by the URL or path of the application.

app-manager-web-app-info = Cette application web est hébergée par :
app-manager-local-app-info = L’emplacement de cette application est :
