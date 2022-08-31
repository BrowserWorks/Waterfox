# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


title-label = Informazioni sui plugin

installed-plugins-label = Plugin installati
no-plugins-are-installed-label = Nessun plugin installato

deprecation-description = Manca qualcosa? Alcuni plugin non sono più supportati. <a data-l10n-name="deprecation-link">Ulteriori informazioni.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">File:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Percorso:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versione:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Stato:</span> attivo
state-dd-enabled-block-list-state = <span data-l10n-name="state">Stato:</span> attivo ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Stato:</span> disattivato
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Stato:</span> disattivato ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descrizione
suffixes-label = Estensione

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Informazioni sulla licenza
plugins-gmp-privacy-info = Informativa sulla privacy

plugins-openh264-name = Codec video OpenH264 realizzato da Cisco Systems, Inc.
plugins-openh264-description = Questo plugin viene installato automaticamente da Waterfox, in conformità con le specifiche WebRTC, per consentire chiamate con dispositivi che richiedono un codec video H.264. Visitare https://www.openh264.org/ per visualizzare il codice sorgente e scoprire ulteriori informazioni sull’implementazione.

plugins-widevine-name = Modulo Widevine Content Decryption fornito da Google Inc.
plugins-widevine-description = Questo plugin consente la riproduzione di file multimediali crittati, nel rispetto delle specifiche Encrypted Media Extensions. Questo tipo di file è normalmente utilizzato dai siti per proteggere contenuti di alta qualità contro la copia. Consultare https://www.w3.org/TR/encrypted-media/ per ulteriori informazioni relative a Encrypted Media Extensions.
