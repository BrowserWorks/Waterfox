# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Découvrez votre nouveau { -brand-short-name }
upgrade-dialog-new-subtitle = Conçu pour vous amener où vous voulez, encore plus vite
upgrade-dialog-new-item-menu-title = Barres d’outils et menus simplifiés
upgrade-dialog-new-item-menu-description = Donnent la priorité aux choses importantes pour trouver ce dont vous avez besoin.
upgrade-dialog-new-item-tabs-title = Onglets modernes
upgrade-dialog-new-item-tabs-description = Présentent les informations avec soin en renforçant la concentration et la fluidité des mouvements.
upgrade-dialog-new-item-icons-title = Nouvelles icônes et messages plus précis
upgrade-dialog-new-item-icons-description = Vous aident à vous y retrouver, en toute simplicité.
upgrade-dialog-new-primary-default-button = Faire de { -brand-short-name } mon navigateur par défaut
upgrade-dialog-new-primary-theme-button = Choisir un thème
upgrade-dialog-new-secondary-button = Plus tard
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = D’accord, j’ai compris !

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Ajoutez { -brand-short-name } à votre Dock
       *[other] Épinglez { -brand-short-name } à votre barre des tâches
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Accédez facilement au tout dernier { -brand-short-name }.
       *[other] Gardez le tout dernier { -brand-short-name } à portée de main.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Ajouter au Dock
       *[other] Épingler à la barre des tâches
    }
upgrade-dialog-pin-secondary-button = Pas maintenant

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Faire de { -brand-short-name } votre navigateur par défaut
upgrade-dialog-default-subtitle-2 = Laissez vitesse, sécurité et vie privée se configurer automatiquement.
upgrade-dialog-default-primary-button-2 = Définir comme navigateur par défaut
upgrade-dialog-default-secondary-button = Plus tard

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Prenez un nouveau départ avec un thème rafraichi
upgrade-dialog-theme-system = Thème du système
    .title = Suivre le thème du système pour les boutons, menus et fenêtres

## Start screen

upgrade-dialog-start-subtitle = De nouveaux coloris somptueux. Disponibles pendant une durée limitée.
upgrade-dialog-start-primary-button = Découvrir ces coloris
upgrade-dialog-start-secondary-button = Plus tard

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Choisissez vos couleurs
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
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Utiliser un thème dynamique et coloré pour les boutons, menus et fenêtres
upgrade-dialog-theme-keep = Conserver le thème actuel
    .title = Utiliser le thème que vous aviez installé avant la mise à jour de { -brand-short-name }
upgrade-dialog-theme-primary-button = Enregistrer le thème
upgrade-dialog-theme-secondary-button = Plus tard
upgrade-dialog-colorway-variation-soft = Doux
    .title = Utiliser ce coloris
upgrade-dialog-colorway-variation-balanced = Équilibré
    .title = Utiliser ce coloris

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Merci de nous avoir choisis
upgrade-dialog-thankyou-subtitle = { -brand-short-name } est un navigateur indépendant soutenu par une organisation à but non lucratif. Ensemble, nous rendons le Web plus sûr, plus sain et plus privé.
upgrade-dialog-thankyou-primary-button = Commencer la navigation
