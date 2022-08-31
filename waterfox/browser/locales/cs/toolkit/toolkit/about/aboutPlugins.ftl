# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = O zásuvných modulech

installed-plugins-label = Nainstalované zásuvné moduly
no-plugins-are-installed-label = Nenalezeny žádné zásuvné moduly

deprecation-description = Něco chybí? Některé zásuvné moduly už nejsou podporovány. <a data-l10n-name="deprecation-link">Zjistit více.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Soubor</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Cesta:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Verze:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stav:</span> Povolen
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stav:</span> Povolen ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stav:</span> Zakázán
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stav:</span> Zakázán ({ $blockListState })

mime-type-label = Typ MIME
description-label = Popis
suffixes-label = Přípony

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Informace o licenci
plugins-gmp-privacy-info = Informace o ochraně soukromí

plugins-openh264-name = Video kodek OpenH264 od společnosti Cisco Systems
plugins-openh264-description = Tento zásuvný modul je automaticky instalován, aby tato aplikace vyhověla specifikaci WebRTC a umožnila WebRTC hovory se zařízeními, která vyžadují použití video kodeku H.264. Pro zobrazení zdrojového kódu a více informací o implementaci navštivte https://www.openh264.org/.

plugins-widevine-name = Modul Widevine od společnosti Google pro dešifrování obsahu
plugins-widevine-description = Tento zásuvný modul umožňuje přehrávání šifrovaných médií podle specifikace Encrypted Media Extensions. Šifrovaná média jsou typicky používána pro ochranu prémiového nebo placeného obsahu před kopírováním. Více informací o Encrypted Media Extensions najdete na adrese https://www.w3.org/TR/encrypted-media/.
