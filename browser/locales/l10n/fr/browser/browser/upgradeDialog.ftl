# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Découvrez votre nouveau { -brand-short-name }
upgrade-dialog-new-subtitle = Conçu pour vous amener où vous voulez, encore plus vite
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Commencez par rendre <span data-l10n-name="zap">{ -brand-short-name }</span> accessible d’un clic
upgrade-dialog-new-item-menu-title = Barres d’outils et menus simplifiés
upgrade-dialog-new-item-menu-description = Donnent la priorité aux choses importantes pour trouver ce dont vous avez besoin.
upgrade-dialog-new-item-tabs-title = Onglets modernes
upgrade-dialog-new-item-tabs-description = Présentent les informations avec soin en renforçant la concentration et la fluidité des mouvements.
upgrade-dialog-new-item-icons-title = Nouvelles icônes et messages plus précis
upgrade-dialog-new-item-icons-description = Vous aident à vous y retrouver, en toute simplicité.
upgrade-dialog-new-primary-primary-button = Faire de { -brand-short-name } mon navigateur principal
    .title = Définit { -brand-short-name } comme navigateur par défaut et l’épingle à la barre des tâches
upgrade-dialog-new-primary-default-button = Faire de { -brand-short-name } mon navigateur par défaut
upgrade-dialog-new-primary-pin-button = Épingler { -brand-short-name } à la barre des tâches
upgrade-dialog-new-primary-pin-alt-button = Épingler à la barre des tâches
upgrade-dialog-new-primary-theme-button = Choisir un thème
upgrade-dialog-new-secondary-button = Plus tard
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = D’accord, j’ai compris !

## Pin Firefox screen
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
upgrade-dialog-default-title = Faire de { -brand-short-name } votre navigateur par défaut ?
upgrade-dialog-default-subtitle = Toute votre navigation rapide, sûre et confidentielle.
upgrade-dialog-default-primary-button = Définir comme navigateur par défaut
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Faire de { -brand-short-name } votre navigateur par défaut
upgrade-dialog-default-subtitle-2 = Laissez vitesse, sécurité et vie privée se configurer automatiquement.
upgrade-dialog-default-primary-button-2 = Définir comme navigateur par défaut
upgrade-dialog-default-secondary-button = Plus tard

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Prenez un nouveau départ
    avec un thème mis à jour
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Prenez un nouveau départ avec un thème rafraichi
upgrade-dialog-theme-system = Thème du système
    .title = Suivre le thème du système pour les boutons, menus et fenêtres
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
