# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Assistant d’importation

import-from =
    { PLATFORM() ->
        [windows] Importer les options, marque-pages, historique, mots de passe et autres données depuis :
       *[other] Importer les préférences, marque-pages, historique, mots de passe et autres données depuis :
    }

import-from-bookmarks = Importer les marque-pages depuis :
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (anciennes versions)
    .accesskey = a
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Ne rien importer
    .accesskey = r
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Aucun logiciel contenant des marque-pages, un historique ou des mots de passe enregistrés n’a été trouvé.

import-source-page-title = Importation des paramètres et des données
import-items-page-title = Éléments à importer

import-items-description = Sélectionnez les éléments à importer :

import-permissions-page-title = Veuillez accorder les autorisations à { -brand-short-name }

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS vous demande d’autoriser explicitement { -brand-short-name } à accéder aux marque-pages de Safari. Cliquez sur « Continuer » et sélectionnez le fichier « Bookmarks.plist » dans le panneau d’ouverture de fichier qui apparaît.

import-migrating-page-title = Importation…

import-migrating-description = Les éléments suivants sont en cours d’importation…

import-select-profile-page-title = Sélectionner un profil

import-select-profile-description = Les profils suivants sont disponibles à l’importation :

import-done-page-title = Importation terminée

import-done-description = Les éléments suivants ont été importés avec succès :

import-close-source-browser = Veuillez vous assurer que le navigateur sélectionné soit fermé avant de continuer.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Importé depuis { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox Waterfox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Liste de lecture (depuis Safari)
imported-edge-reading-list = Liste de lecture (depuis Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookies
browser-data-cookies-label =
    .value = Cookies

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historique de navigation et marque-pages
           *[other] Historique de navigation
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historique de navigation et marque-pages
           *[other] Historique de navigation
        }

browser-data-formdata-checkbox =
    .label = Données de formulaires enregistrées
browser-data-formdata-label =
    .value = Données de formulaires enregistrées

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Identifiants et mots de passe enregistrés
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Identifiants et mots de passe enregistrés

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favoris
            [edge] Favoris
            [chrome] Favoris
            [safari] Signets
           *[other] Marque-pages
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favoris
            [edge] Favoris
            [chrome] Favoris
            [safari] Signets
           *[other] Marque-pages
        }

browser-data-otherdata-checkbox =
    .label = Autres données
browser-data-otherdata-label =
    .label = Autres données

browser-data-session-checkbox =
    .label = Fenêtres et onglets
browser-data-session-label =
    .value = Fenêtres et onglets
