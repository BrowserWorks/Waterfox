# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = À propos des plugins

installed-plugins-label = Plugins installés
no-plugins-are-installed-label = Aucun plugin installé n’a été trouvé

deprecation-description = Quelque chose semble manquer ? Certains plugins ne sont plus pris en charge. <a data-l10n-name="deprecation-link">En savoir plus.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fichier :</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Chemin :</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version :</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">État :</span> Activé
state-dd-enabled-block-list-state = <span data-l10n-name="state">État :</span> Activé ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">État :</span> Désactivé
state-dd-Disabled-block-list-state = <span data-l10n-name="state">État :</span> Désactivé ({ $blockListState })

mime-type-label = Type MIME
description-label = Description
suffixes-label = Suffixes

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Informations de licence
plugins-gmp-privacy-info = Informations liées à la vie privée

plugins-openh264-name = Codec vidéo OpenH264 fourni par Cisco Systems, Inc.
plugins-openh264-description = Ce plugin est automatiquement installé par Waterfox pour respecter la spécification WebRTC et permettre les appels WebRTC avec les appareils qui nécessitent le codec vidéo H.264. Rendez-vous sur http://www.openh264.org/ pour consulter le code source du codec et en apprendre davantage sur son implémentation.

plugins-widevine-name = Module de déchiffrement de contenu Widevine fourni par Google Inc.
plugins-widevine-description = Ce plugin permet la lecture de contenus chiffrés selon la spécification Encrypted Media Extensions. Le chiffrement de contenus est typiquement utilisé par les sites comme protection contre la copie de médias payants. Visitez https://www.w3.org/TR/encrypted-media/ pour davantage d’informations sur la spécification Encrypted Media Extensions.
