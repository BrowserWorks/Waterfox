# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Source des données de ping :
about-telemetry-show-current-data = Données actuelles
about-telemetry-show-archived-ping-data = Données de ping archivées
about-telemetry-show-subsession-data = Afficher les données de sous-session
about-telemetry-choose-ping = Sélectionner le ping :
about-telemetry-archive-ping-type = Type de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Aujourd’hui
about-telemetry-option-group-yesterday = Hier
about-telemetry-option-group-older = Plus ancien
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Données télémétriques
about-telemetry-current-store = Magasin actuel :
about-telemetry-more-information = Besoin de plus d’informations ?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">documentation des données de Waterfox</a> propose des guides pour comprendre comment utiliser nos outils de données.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">documentation du client de télémétrie Waterfox</a> contient la définition des différents concepts, la documentation de l’API et un référentiel de données.
about-telemetry-telemetry-dashboard = Les <a data-l10n-name="dashboard-link">tableaux de bord de télémétrie</a> vous permettent de visualiser les données reçues par Waterfox grâce à la télémétrie.
about-telemetry-telemetry-probe-dictionary = Le <a data-l10n-name="probe-dictionary-link">dictionnaire des échantillons</a> fournit des informations et des descriptions sur les échantillons collectés par télémétrie.
about-telemetry-show-in-Waterfox-json-viewer = Ouvrir dans la visionneuse JSON
about-telemetry-home-section = Accueil
about-telemetry-general-data-section = Données générales
about-telemetry-environment-data-section = Données de l’environnement
about-telemetry-session-info-section = Informations sur la session
about-telemetry-scalar-section = Scalaires
about-telemetry-keyed-scalar-section = Scalaires avec mots-clés
about-telemetry-histograms-section = Histogrammes
about-telemetry-keyed-histogram-section = Histogrammes avec mots-clés
about-telemetry-events-section = Évènements
about-telemetry-simple-measurements-section = Mesures simples
about-telemetry-slow-sql-section = Requêtes SQL lentes
about-telemetry-addon-details-section = Détails sur les modules complémentaires
about-telemetry-captured-stacks-section = Piles d’allocations capturées
about-telemetry-late-writes-section = Écritures tardives
about-telemetry-raw-payload-section = Charge brute
about-telemetry-raw = JSON brut
about-telemetry-full-sql-warning = NOTE : Le débogage des requêtes SQL lentes est activé. Des requêtes SQL complètes peuvent être affichées ci-dessous, mais elles ne seront pas envoyées par télémétrie.
about-telemetry-fetch-stack-symbols = Récupérer les noms de fonctions pour les piles
about-telemetry-hide-stack-symbols = Afficher les données brutes des piles
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] données de la version stable
       *[prerelease] données de préversion
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activée
       *[disabled] désactivée
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } élément, moyenne = { $prettyAverage }, somme = { $sum }
       *[other] { $sampleCount } éléments, moyenne = { $prettyAverage }, somme = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Cette page affiche les informations collectées par télémétrie concernant les performances, les caractéristiques matérielles, l’utilisation des fonctionnalités et la personnalisation du navigateur. Ces informations sont envoyées à { $telemetryServerOwner } pour aider à l’amélioration de { -brand-full-name }.
about-telemetry-settings-explanation = La télémétrie collecte les { about-telemetry-data-type } et la transmission est <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Chaque information est envoyée empaquetée dans des « <a data-l10n-name="ping-link">pings</a> ». Vous visionnez le ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Les informations sont envoyées dans des paquets appelés « <a data-l10n-name="ping-link">pings</a> ». Vous visualisez les données actuelles.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Rechercher dans { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Rechercher dans toutes les sections
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Résultats pour « { $searchTerms } »
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Désolé, il n’y a aucun résultat dans { $sectionName } pour « { $currentSearchText } ».
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Désolé, il n’y a aucun résultat pour « { $searchTerms } » dans les différentes sections
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Désolé, aucune donnée n’est disponible dans « { $sectionName } »
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = données actuelles
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = tout
# button label to copy the histogram
about-telemetry-histogram-copy = Copier
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Requêtes SQL lentes dans le fil d’exécution principal (main thread)
about-telemetry-slow-sql-other = Requêtes SQL lentes dans les fils d’exécution assistants (helper threads)
about-telemetry-slow-sql-hits = Compteur
about-telemetry-slow-sql-average = Temps moyen (ms)
about-telemetry-slow-sql-statement = Requête
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Identifiant du module
about-telemetry-addon-table-details = Détails
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Éditeur { $addonProvider }
about-telemetry-keys-header = Propriété
about-telemetry-names-header = Nom
about-telemetry-values-header = Valeur
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (Nombre de captures : { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Écriture tardive n°{ $lateWriteCount }
about-telemetry-stack-title = Pile :
about-telemetry-memory-map-title = Cartographie mémoire :
about-telemetry-error-fetching-symbols = Une erreur s’est produite lors de la récupération des symboles. Vérifiez votre connexion à Internet et réessayez.
about-telemetry-time-stamp-header = horodatage
about-telemetry-category-header = catégorie
about-telemetry-method-header = méthode
about-telemetry-object-header = objet
about-telemetry-extra-header = en supplément
about-telemetry-origin-section = Télémétrie d’origine
about-telemetry-origin-origin = origine
about-telemetry-origin-count = comptage
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Waterfox Origin Telemetry</a> encode les données avant de les envoyer de façon à ce que { $telemetryServerOwner } puisse compter différentes choses, mais ne puisse pas savoir si tel { -brand-product-name } a contribué ou non à ce comptage. <a data-l10n-name="prio-blog-link">En savoir plus</a>
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Processus « { $process } »
