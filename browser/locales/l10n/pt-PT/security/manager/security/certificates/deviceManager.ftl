# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Gestor de dispositivos
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Módulos e dispositivos de segurança

devmgr-header-details =
    .label = Detalhes

devmgr-header-value =
    .label = Valor

devmgr-button-login =
    .label = Iniciar sessão
    .accesskey = n

devmgr-button-logout =
    .label = Terminar sessão
    .accesskey = o

devmgr-button-changepw =
    .label = Alterar palavra-passe
    .accesskey = p

devmgr-button-load =
    .label = Carregar
    .accesskey = C

devmgr-button-unload =
    .label = Descarregar
    .accesskey = D

devmgr-button-enable-fips =
    .label = Ativar FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Desativar FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Carregar controlador do dispositivo PKCS#11

load-device-info = Introduza a informação para o módulo que pretende adicionar.

load-device-modname =
    .value = Nome do módulo
    .accesskey = m

load-device-modname-default =
    .value = Novo módulo PKCS#11

load-device-filename =
    .value = Nome do ficheiro do módulo
    .accesskey = f

load-device-browse =
    .label = Procurar…
    .accesskey = P

## Token Manager

devinfo-status =
    .label = Estado

devinfo-status-disabled =
    .label = Desativado

devinfo-status-not-present =
    .label = Não presente

devinfo-status-uninitialized =
    .label = Não inicializado

devinfo-status-not-logged-in =
    .label = Não autenticado

devinfo-status-logged-in =
    .label = Autenticado

devinfo-status-ready =
    .label = Pronto

devinfo-desc =
    .label = Descrição

devinfo-man-id =
    .label = Fabricante

devinfo-hwversion =
    .label = Versão de HW
devinfo-fwversion =
    .label = Versão de FW

devinfo-modname =
    .label = Módulo

devinfo-modpath =
    .label = Caminho

login-failed = Falha de autenticação

devinfo-label =
    .label = Etiqueta

devinfo-serialnum =
    .label = Número de série

fips-nonempty-primary-password-required = O modo FIPS requer uma palavra-passe principal definida para cada dispositivo de segurança. Por favor defina a palavra-passe antes de tentar ativar o modo FIPS.
unable-to-toggle-fips = Não foi possível alterar o modo FIPS para o dispositivo de segurança. É recomendado que saia e reinicie esta aplicação.
load-pk11-module-file-picker-title = Escolha um controlador do dispositivo PKCS#11 para carregar

# Load Module Dialog
load-module-help-empty-module-name =
    .value = O nome do módulo não pode estar vazio.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ está reservado e não pode ser utilizado como nome de módulo.

add-module-failure = Não é possível adicionar módulo
del-module-warning = Tem a certeza que pretende eliminar este módulo de segurança?
del-module-error = Não foi possível apagar o módulo
