# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Om programtillegg

installed-plugins-label = Installerte programtillegg
no-plugins-are-installed-label = Fann ingen installerte programtillegg

deprecation-description = Saknar du noko? Nokre program er ikkje lenger støtta. <a data-l10n-name="deprecation-link">Les meir.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fil:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Sti:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versjon:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tilstand:</span> Påslått
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Påslått ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tilstand:</span> Avslått
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tilstand:</span> Avslått ({ $blockListState })

mime-type-label = MIME-type
description-label = Skildring
suffixes-label = Filtypar

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Lisensinformasjon
plugins-gmp-privacy-info = Personverninformasjon

plugins-openh264-name = OpenH264 video-kodek er levert av Cisco Systems, Inc.
plugins-openh264-description = Dette programtillegget er automatisk installert av Waterfox for å følgja WebRTC-spesifikasjonar og for å tillate WebRTC-kall med einingar som brukar videokodeken H.264. Gå til http://www.openh264.org/ for å skjå kjeldekoden og lesa meir om implementeringa.

plugins-widevine-name = Widevine Content Decryption Module levert av Google Inc.
plugins-widevine-description = Dette programtillegget gjer det mogleg å spele av krypterte media i samsvar med spesifikasjonane for Encrypted Media Extensions. Krypterte medium vert vanlegvis brukte av nettsider for å verne mot kopiering av betalt medieinnhald. Gå til https://www.w3.org/TR/encrypted-media/ for meir informasjon om Encrypted Media Extensions.
