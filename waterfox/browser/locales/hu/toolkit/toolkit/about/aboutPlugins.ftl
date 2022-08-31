# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = A bővítményekről

installed-plugins-label = Telepített bővítmények
no-plugins-are-installed-label = Nincsenek telepített bővítmények

deprecation-description = Hiányzik valami? Néhány bővítményt már nem támogatott. <a data-l10n-name="deprecation-link">További tudnivalók</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fájl:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Útvonal:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Verzió:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Állapot:</span> Engedélyezve
state-dd-enabled-block-list-state = <span data-l10n-name="state">Állapot:</span> Engedélyezve ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Állapot:</span> Tiltva
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Állapot:</span> Tiltva ({ $blockListState })

mime-type-label = MIME-típus
description-label = Leírás
suffixes-label = Kiterjesztés

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Licencinformációk
plugins-gmp-privacy-info = Adatvédelmi információk

plugins-openh264-name = OpenH264 videokodek a Cisco Systems, Inc.-től
plugins-openh264-description = Ezt a bővítményt a Waterfox automatikusan telepítette a WebRTC specifikációnak való megfelelés érdekében, és a WebRTC hívások lehetővé tételéhez olyan eszközökkel, amelyek a H.264 videokodeket igénylik. Keresse fel a http://www.openh264.org/ oldalt a megvalósítással kapcsolatos további tudnivalókért.

plugins-widevine-name = Widevine tartalom-visszafejtő modul a Google Inc.-től
plugins-widevine-description = Ez a bővítmény lehetővé teszi a titkosított médiák lejátszását, az Encrypted Media Extensions specifikációnak megfelelően. Titkosított médiát jellemzően azok az oldalak használnak, amelyek a prémium médiatartalmak másolása ellen védekeznek. A titkosított médiakiterjesztésekről szóló további információkért keresse fel az https://www.w3.org/TR/encrypted-media/ oldalt.
