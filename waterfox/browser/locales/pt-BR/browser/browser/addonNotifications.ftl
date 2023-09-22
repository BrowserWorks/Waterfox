# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = O { -brand-short-name } impediu que este site instale um programa neste computador.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Permitir que { $host } instale uma extensão?
xpinstall-prompt-message = Você está tentando instalar uma extensão de { $host }. Tenha certeza se confia neste site antes de continuar.

##

xpinstall-prompt-header-unknown = Permitir que um site desconhecido instale uma extensão?
xpinstall-prompt-message-unknown = Você está tentando instalar uma extensão a partir de um site desconhecido. Tenha certeza de que confia neste site antes de continuar.

xpinstall-prompt-dont-allow =
    .label = Não permitir
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Nunca permitir
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Denunciar site suspeito
    .accesskey = D
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Avançar para a instalação
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Este site está solicitando acesso a seus dispositivos MIDI (Musical Instrument Digital Interface). O acesso a dispositivos pode ser ativado instalando uma extensão.
site-permission-install-first-prompt-midi-message = Não há garantia deste acesso ser seguro. Só continue se confiar neste site.

##

xpinstall-disabled-locked = A instalação de software foi desativada pelo administrador do sistema.
xpinstall-disabled = A instalação de software está desativada. Clique em Ativar e tente novamente.
xpinstall-disabled-button =
    .label = Ativar
    .accesskey = A

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) foi bloqueado pelo administrador do seu sistema.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = O administrador do seu sistema impediu que este site pedisse autorização para instalar programas neste computador.
addon-install-full-screen-blocked = A instalação de extensões não é permitida no modo de tela inteira ou logo antes de mudar para tela inteira.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } adicionado ao { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } requer novas permissões

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Finalize a instalação das extensões importadas para o { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Remover { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Remover { $name } do { -brand-shorter-name }?
addon-removal-button = Remover
addon-removal-abuse-report-checkbox = Denunciar esta extensão para a { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Baixando e verificando a extensão…
       *[other] Baixando e verificando { $addonCount } extensões…
    }
addon-download-verifying = Verificando

addon-install-cancel-button =
    .label = Cancelar
    .accesskey = C
addon-install-accept-button =
    .label = Adicionar
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Este site quer instalar uma extensão no { -brand-short-name }:
       *[other] Este site quer instalar { $addonCount } extensões no { -brand-short-name }:
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Cuidado: Este site quer instalar uma extensão não-verificada em { -brand-short-name }. Proceda por sua conta e risco.
       *[other] Cuidado: Este site quer instalar { $addonCount } extensões não-verificadas em { -brand-short-name }. Proceda por sua conta e risco.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Cuidado: Este site quer instalar { $addonCount } extensões em { -brand-short-name }, algumas das quais não foram verificadas. Proceda por sua conta e risco.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = A extensão não pôde ser baixada por causa de uma falha na conexão.
addon-install-error-incorrect-hash = A extensão não pôde ser instalada porque não corresponde à extensão { -brand-short-name } esperada.
addon-install-error-corrupt-file = A extensão baixada deste site não pôde ser instalada porque parece estar corrompida.
addon-install-error-file-access = { $addonName } não pôde ser instalado porque { -brand-short-name } não pode modificar o arquivo necessário.
addon-install-error-not-signed = O { -brand-short-name } impediu que este site instale uma extensão não verificada.
addon-install-error-invalid-domain = A extensão { $addonName } não pode ser instalada a partir deste local.
addon-local-install-error-network-failure = Esta extensão não pôde ser instalada devido a um erro do sistema de arquivos.
addon-local-install-error-incorrect-hash = Esta extensão não pôde ser instalada porque não corresponde à extensão { -brand-short-name } esperada.
addon-local-install-error-corrupt-file = Esta extensão não pôde ser instalada porque parece estar danificada.
addon-local-install-error-file-access = { $addonName } não pôde ser instalado porque { -brand-short-name } não pode modificar o arquivo necessário.
addon-local-install-error-not-signed = Esta extensão não pôde ser instalada porque não foi verificada.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } não pôde ser instalado porque não é compatível com o { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } não pôde ser instalado porque tem um elevado risco de causar problemas de estabilidade ou segurança.
