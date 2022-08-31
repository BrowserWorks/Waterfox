# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Om insticksprogram

installed-plugins-label = Installerade insticksprogram
no-plugins-are-installed-label = Inga installerade insticksprogram hittades

deprecation-description = Saknar du något? Vissa insticksmoduler stöds inte längre. <a data-l10n-name="deprecation-link">Läs mer.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fil:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Sökväg:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Version:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Status:</span> Aktiverad
state-dd-enabled-block-list-state = <span data-l10n-name="state">Status:</span> Aktiverad ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Status:</span> Inaktiverad
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Status:</span> Inaktiverad ({ $blockListState })

mime-type-label = MIME-typ
description-label = Beskrivning
suffixes-label = Filändelse

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Licensinformation
plugins-gmp-privacy-info = Sekretessinformation

plugins-openh264-name = OpenH264 Video Codec tillhandahållen av Cisco Systems, Inc.
plugins-openh264-description = Denna insticksmodul installeras automatiskt av Waterfox för att följa WebRTC-specifikationen och möjliggöra WebRTC-samtal med enheter som kräver H.264 video codec. Besök http://www.openh264.org/ för att visa källkoden för codec och lära dig mer om implementationen.

plugins-widevine-name = Widevine Content dekrypteringsmodul tillhandahålls av Google Inc.
plugins-widevine-description = Denna insticksmodul möjliggör uppspelning av krypterade media i enlighet med specifikationen för krypterad mediautökning. Krypterade medier används vanligtvis av webbplatser för att skydda mot kopiering av premiummedieinnehåll. Besök https://www.w3.org/TR/encrypted-media/ för mer information om Krypterade Media Extensions.
