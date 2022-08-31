# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Om plugins

installed-plugins-label = Installerede plugins
no-plugins-are-installed-label = Ingen installerede plugins fundet

deprecation-description = Mangler du noget? Nogle plugins er ikke længere understøttet. <a data-l10n-name="deprecation-link">Læs mere.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fil:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Sti:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tilstand:</span> Aktiveret
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Aktiveret ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tilstand:</span> Deaktiveret
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Deaktiveret ({ $blockListState })

mime-type-label = MIME Type
description-label = Beskrivelse
suffixes-label = Endelser

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Licensinformation
plugins-gmp-privacy-info = Privatlivsinformation

plugins-openh264-name = OpenH264 Video Codec provided by Cisco Systems, Inc.
plugins-openh264-description = Dette plugin installeres automatisk af Waterfox for at overholde WebRTC-specifikationerne og muliggøre WebRTC-samtaler, som benytter video codec'et H.264. Du kan læse mere om implementeringen, og du kan finde kildekoden, på http://www.openh264.org/.

plugins-widevine-name = Widevine Content Decryption Module provided by Google Inc.
plugins-widevine-description = Dette plugin gør det muligt at afspille krypterede mediefiler i overensstemmelse med Encrypted Media Extensions specification. Websteder anvender typisk krypterede mediefiler for at undgå kopiering af betalt medie-indhold. Læs mere om Encrypted Media Extensions på https://www.w3.org/TR/encrypted-media/
