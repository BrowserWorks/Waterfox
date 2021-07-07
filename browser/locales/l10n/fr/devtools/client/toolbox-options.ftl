# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Outils de développement par défaut
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Non géré pour la cible actuelle de la boîte à outils
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Outils installés via modules complémentaires
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Boutons de la boîte à outils
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Thèmes

## Inspector section

# The heading
options-context-inspector = Inspecteur
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Afficher les styles du navigateur
options-show-user-agent-styles-tooltip =
    .title = Activer cette option affichera les styles par défaut chargés par le navigateur
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Tronquer les attributs DOM
options-collapse-attrs-tooltip =
    .title = Tronquer les longs attributs dans l’inspecteur

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unité par défaut pour les couleurs
options-default-color-unit-authored = unité d’origine
options-default-color-unit-hex = hexadécimal
options-default-color-unit-hsl = TSL(A)
options-default-color-unit-rgb = RVB(A)
options-default-color-unit-name = noms de couleurs

## Style Editor section

# The heading
options-styleeditor-label = Éditeur de style
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Compléter automatiquement le CSS
options-stylesheet-autocompletion-tooltip =
    .title = Compléter automatiquement les propriétés, valeurs et sélecteurs CSS dans l’éditeur de style lors de la saisie

## Screenshot section

# The heading
options-screenshot-label = Comportement pour les captures d’écran
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Enregistrer dans le presse-papiers
options-screenshot-clipboard-tooltip =
    .title = Enregistrer directement la capture d’écran dans le presse-papiers
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Capturer vers le presse-papiers uniquement
options-screenshot-clipboard-tooltip2 =
    .title = Enregistre directement la capture d’écran dans le presse-papiers
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Jouer un son d’obturateur d’appareil photo
options-screenshot-audio-tooltip =
    .title = Activer le son d’un obturateur d’appareil photo lors de la capture d’écran

## Editor section

# The heading
options-sourceeditor-label = Préférences de l’éditeur
options-sourceeditor-detectindentation-tooltip =
    .title = Déduire l’indentation d’après le contenu source
options-sourceeditor-detectindentation-label = Détecter l’indentation
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Insérer automatiquement les parenthèses et les accolades fermantes
options-sourceeditor-autoclosebrackets-label = Fermer automatiquement les parenthèses et les accolades
options-sourceeditor-expandtab-tooltip =
    .title = Utiliser des espaces à la place du caractère tabulation
options-sourceeditor-expandtab-label = Indenter à l’aide d’espaces
options-sourceeditor-tabsize-label = Taille des tabulations
options-sourceeditor-keybinding-label = Raccourcis clavier
options-sourceeditor-keybinding-default-label = Par défaut

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Paramètres avancés
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Désactiver le cache HTTP (lorsque la boîte à outils est ouverte)
options-disable-http-cache-tooltip =
    .title = Activer cette option désactivera le cache HTTP pour l’ensemble des onglets dans lesquels la boîte à outils est ouverte. Cette option n’a aucun effet sur les service workers.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Désactiver JavaScript *
options-disable-javascript-tooltip =
    .title = Activer cette option désactivera JavaScript pour l’onglet courant. Ce paramètre sera oublié à la fermeture de l’onglet ou de la boîte à outils.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activer le débogage du chrome du navigateur et des modules
options-enable-chrome-tooltip =
    .title = Activer cette option vous permettra d’utiliser divers outils de développement dans le contexte du navigateur (via Outils > Développement web > Boîte à outils du navigateur) et de déboguer des modules depuis le gestionnaire de modules complémentaires
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activer le débogage distant
options-enable-remote-tooltip2 =
    .title = L’activation de cette option permettra de déboguer cette instance de navigateur à distance
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activer les Service Workers via HTTP (lorsque la boîte à outils est ouverte)
options-enable-service-workers-http-tooltip =
    .title = Activer cette option activera les Service Workers via HTTP pour tous les onglets où la boîte à outils est ouverte.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Activer les liens vers les sources
options-source-maps-tooltip =
    .title = En activant cette option, les sources seront liées dans les outils.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Pour cette session, recharge la page
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Afficher les données de la plate-forme Gecko
options-show-platform-data-tooltip =
    .title = Si vous activez cette option, les rapports du profileur JavaScript incluront les symboles de la plate-forme Gecko
