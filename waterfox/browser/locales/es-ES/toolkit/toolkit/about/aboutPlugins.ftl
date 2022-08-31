# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Acerca de los plugins

installed-plugins-label = Plugins instalados
no-plugins-are-installed-label = No se han encontrado plugins instalados

deprecation-description = ¿Echa algo en falta? Algunos plugins ya no están admitidos. <a data-l10n-name="deprecation-link">Saber más.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Archivo:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Ruta:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versión:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Estado:</span> Habilitado
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estado:</span> Habilitado ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estado:</span> Deshabilitado
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estado:</span> Deshabilitado ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descripción
suffixes-label = Sufijos

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Información de licencia
plugins-gmp-privacy-info = Información de privacidad

plugins-openh264-name = OpenH264 Video Codec proporcionado por Cisco Systems, Inc.
plugins-openh264-description = Este plugin se ha instalado automáticamente por Waterfox para cumplir con la especificación WebRTC y para permitir llamadas WebRTC con dispositivos que requieren el códec de vídeo H.264. Visite http://www.openh264.org/ para ver el código fuente del códec y saber más sobre la implementación.

plugins-widevine-name = Módulo de descifrado de contenido Widevine proporcionado por Google Inc.
plugins-widevine-description = Este complemento permite la reproducción de medios cifrados de acuerdo con la especificación Encrypted Media Extensions. Los sitios suelen utilizar medios cifrados para protegerse contra la copia de contenido multimedia premium. Visite https://www.w3.org/TR/encrypted-media/ para obtener más información sobre Encrypted Media Extensions.
