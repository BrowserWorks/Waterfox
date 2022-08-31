# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Acerca dos plugins

installed-plugins-label = Plugins instalados
no-plugins-are-installed-label = Não existem plugins instalados

deprecation-description = Falta alguma coisa? Alguns plugins deixaram de ser suportados. <a data-l10n-name="deprecation-link">Saber mais.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Ficheiro:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Caminho:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versão:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Estado:</span> Ativado
state-dd-enabled-block-list-state = <span data-l10n-name="state">Estado:</span> Ativado ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Estado:</span> Desativado
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Estado:</span> Desativado ({ $blockListState })

mime-type-label = Tipo MIME
description-label = Descrição
suffixes-label = Sufixos

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Informação da licença
plugins-gmp-privacy-info = Informação de privacidade

plugins-openh264-name = Codec de vídeo OpenH264 disponibilizado por Cisco Systems, Inc.
plugins-openh264-description = Este plugin é instalado automaticamente pela Waterfox para cumprir com a especificação WebRTC e para ativar chamadas WebRTC com dispositivos que requeiram a codificação de vídeo H.264. Visite http://www.openh264.org/ para ver o código fonte do codec e saber mais acerca da implementação.

plugins-widevine-name = Módulo Widevine Content Decryption disponibilizado por Google Inc.
plugins-widevine-description = Este plugin ativa a reprodução de multimédia encriptada em conformidade com a especificação Encrypted Media Extensions. A multimédia encriptada é tipicamente utilizada por sites para proteger contra a cópia de conteúdo multimédia premium. Visite https://www.w3.org/TR/encrypted-media/ para mais informação sobre Encrypted Media Extensions.
