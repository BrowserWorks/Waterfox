# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Default browser screen

## Theme selection screen

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = La vie en couleur
upgrade-dialog-start-subtitle = De nouveaux coloris somptueux. Disponibles pendant une durée limitée.
upgrade-dialog-start-primary-button = Découvrir ces coloris
upgrade-dialog-start-secondary-button = Plus tard

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Choisissez vos couleurs
# This is shown to users with a custom home page, so they can switch to default.
upgrade-dialog-colorway-home-checkbox = Passer à l’accueil de Waterfox avec les couleurs de votre thème
upgrade-dialog-colorway-primary-button = Enregistrer le coloris
upgrade-dialog-colorway-secondary-button = Conserver le thème précédent
upgrade-dialog-colorway-theme-tooltip =
    .title = Découvrir les thèmes par défaut
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Voir le coloris { $colorwayName }
upgrade-dialog-colorway-default-theme = Par défaut
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automatique
    .title = Suivre le thème du système d’exploitation pour les boutons, menus et fenêtres
upgrade-dialog-theme-light = Clair
    .title = Utiliser un thème clair pour les boutons, menus et fenêtres
upgrade-dialog-theme-dark = Sombre
    .title = Utiliser un thème sombre pour les boutons, menus et fenêtres
upgrade-dialog-colorway-variation-soft = Doux
    .title = Utiliser ce coloris
upgrade-dialog-colorway-variation-balanced = Équilibré
    .title = Utiliser ce coloris
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Soutenu
    .title = Utiliser ce coloris

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Merci de nous avoir choisis
upgrade-dialog-thankyou-subtitle = { -brand-short-name } est un navigateur indépendant soutenu par une organisation à but non lucratif. Ensemble, nous rendons le Web plus sûr, plus sain et plus privé.
upgrade-dialog-thankyou-primary-button = Commencer la navigation
