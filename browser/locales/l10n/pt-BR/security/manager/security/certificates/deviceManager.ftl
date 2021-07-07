# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Gerenciador de dispositivos
    .style = width: 67em; height: 32em;
devmgr-devlist =
    .label = Dispositivos e módulos de segurança
devmgr-header-details =
    .label = Detalhes
devmgr-header-value =
    .label = Valor
devmgr-button-login =
    .label = Entrar
    .accesskey = L
devmgr-button-logout =
    .label = Sair
    .accesskey = D
devmgr-button-changepw =
    .label = Alterar senha
    .accesskey = M
devmgr-button-load =
    .label = Carregar
    .accesskey = C
devmgr-button-unload =
    .label = Descarregar
    .accesskey = e
devmgr-button-enable-fips =
    .label = Ativar FIPS
    .accesskey = F
devmgr-button-disable-fips =
    .label = Desativar FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Carregar driver de dispositivo PKCS#11
load-device-info = Forneça a informação para o módulo que você quer adicionar.
load-device-modname =
    .value = Nome do módulo
    .accesskey = M
load-device-modname-default =
    .value = Novo módulo PKCS#11
load-device-filename =
    .value = Nome do arquivo do módulo
    .accesskey = q
load-device-browse =
    .label = Procurar…
    .accesskey = P

## Token Manager

devinfo-status =
    .label = Status
devinfo-status-disabled =
    .label = Desativado
devinfo-status-not-present =
    .label = Ausente
devinfo-status-uninitialized =
    .label = Não inicializado
devinfo-status-not-logged-in =
    .label = Não logado
devinfo-status-logged-in =
    .label = Logado
devinfo-status-ready =
    .label = Pronto
devinfo-desc =
    .label = Descrição
devinfo-man-id =
    .label = Fabricante
devinfo-hwversion =
    .label = Versão do HW
devinfo-fwversion =
    .label = Versão do FW
devinfo-modname =
    .label = Módulo
devinfo-modpath =
    .label = Caminho
login-failed = Falha ao logar.
devinfo-label =
    .label = Label
devinfo-serialnum =
    .label = Número de série
fips-nonempty-password-required = O modo FIPS exige que você tenha uma senha mestra em cada dispositivo de segurança. Defina uma senha antes de tentar ativar o modo FIPS.
fips-nonempty-primary-password-required = O modo FIPS exige que você tenha uma senha principal em cada dispositivo de segurança. Defina uma senha antes de tentar ativar o modo FIPS.
unable-to-toggle-fips = Não foi possível alterar o modo FIPS para o dispositivo de segurança. É recomendado que você reinicie o aplicativo.
load-pk11-module-file-picker-title = Escolha um driver PKCS#11 para carregar
# Load Module Dialog
load-module-help-empty-module-name =
    .value = O nome do módulo não pode ficar em branco.
# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ é uma palavra reservada e não pode ser usada como nome do módulo.
add-module-failure = Não foi possível adicionar o módulo
del-module-warning = Tem certeza que quer excluir este módulo de segurança?
del-module-error = Não foi possível excluir módulo
