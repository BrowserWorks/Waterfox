# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Over plug-ins

installed-plugins-label = Geïnstalleerde plug-ins
no-plugins-are-installed-label = Er zijn geen geïnstalleerde plug-ins gevonden

deprecation-description = Mist u iets? Sommige plug-ins worden niet meer ondersteund. <a data-l10n-name="deprecation-link">Meer info.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Bestand:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Pad:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versie:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Status:</span> Ingeschakeld
state-dd-enabled-block-list-state = <span data-l10n-name="state">Status:</span> Ingeschakeld ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Status:</span> Uitgeschakeld
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Status:</span> Uitgeschakeld ({ $blockListState })

mime-type-label = MIME-type
description-label = Beschrijving
suffixes-label = Achtervoegsels

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Licentie-informatie
plugins-gmp-privacy-info = Privacyverklaring

plugins-openh264-name = OpenH264-videocodec, aangeboden door Cisco Systems, Inc.
plugins-openh264-description = Deze plug-in wordt automatisch door Waterfox geïnstalleerd om aan de WebRTC-specificatie te voldoen en WebRTC-gesprekken met apparaten die de H.264-videocodec vereisen mogelijk te maken. Bezoek https://www.openh264.org/ voor de broncode van de codec en meer info over de implementatie.

plugins-widevine-name = Widevine Content Decryption Module, aangeboden door Google Inc.
plugins-widevine-description = Deze plug-in zorgt voor het afspelen van versleutelde media met inachtneming van de Encrypted Media Extensions-specificatie. Versleutelde media worden doorgaans door websites gebruikt ter bescherming tegen het kopiëren van premium-media-inhoud. Bezoek https://www.w3.org/TR/encrypted-media/ voor meer informatie over Encrypted Media Extensions.
