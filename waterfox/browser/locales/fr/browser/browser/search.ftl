# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Erreur à l’installation
opensearch-error-duplicate-desc = { -brand-short-name } ne peut pas installer le plugin de recherche à partir de « { $location-url } » car un moteur portant le même nom existe déjà.

opensearch-error-format-title = Format invalide
opensearch-error-format-desc = { -brand-short-name } n’a pas pu installer le moteur de recherche depuis : { $location-url }

opensearch-error-download-title = Erreur de téléchargement
opensearch-error-download-desc = { -brand-short-name } n’a pas pu télécharger le plugin de recherche à partir de : { $location-url }

##

searchbar-submit =
    .tooltiptext = Lancer la recherche

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Rechercher

searchbar-icon =
    .tooltiptext = Rechercher

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Votre moteur de recherche par défaut a été changé.</strong> { $oldEngine } n’est plus disponible comme moteur de recherche par défaut dans { -brand-short-name }. Désormais, { $newEngine } le remplace. Pour changer le moteur de recherche par défaut, accédez aux paramètres. <label data-l10n-name="remove-search-engine-article">En savoir plus</label>
remove-search-engine-button = OK
