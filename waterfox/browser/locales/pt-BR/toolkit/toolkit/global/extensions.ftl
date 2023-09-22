# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Adicionar { $extension }?
webext-perms-header-with-perms = Adicionar { $extension }? Esta extensão terá permissão para:
webext-perms-header-unsigned = Adicionar { $extension }? Esta extensão não foi verificada. Extensões maliciosas podem roubar suas informações privativas ou comprometer seu computador. Só instale se confiar na origem.
webext-perms-header-unsigned-with-perms = Adicionar { $extension }? Esta extensão não foi verificada. Extensões maliciosas podem roubar suas informações privativas ou comprometer seu computador. Só instale se confiar na origem. Esta extensão terá permissão para:
webext-perms-sideload-header = { $extension } adicionado
webext-perms-optional-perms-header = { $extension } requer permissões adicionais.

##

webext-perms-add =
    .label = Adicionar
    .accesskey = A
webext-perms-cancel =
    .label = Cancelar
    .accesskey = C

webext-perms-sideload-text = Outro programa neste computador instalou uma extensão que pode afetar seu navegador. Reveja as solicitações de permissão desta extensão e escolha Ativar ou Cancelar (para deixar a extensão desativada).
webext-perms-sideload-text-no-perms = Outro programa neste computador instalou uma extensão que pode afetar o navegador. Escolha Ativar ou Cancelar (para deixar a extensão desativada).
webext-perms-sideload-enable =
    .label = Ativar
    .accesskey = A
webext-perms-sideload-cancel =
    .label = Cancelar
    .accesskey = C

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = A extensão { $extension } foi atualizada. Você precisa aprovar novas permissões para que a versão atualizada seja instalada. Se escolher “Cancelar”, será mantida a versão atual. Esta extensão terá permissão para:
webext-perms-update-accept =
    .label = Atualizar
    .accesskey = u

webext-perms-optional-perms-list-intro = Ele quer:
webext-perms-optional-perms-allow =
    .label = Permitir
    .accesskey = P
webext-perms-optional-perms-deny =
    .label = Negar
    .accesskey = N

webext-perms-host-description-all-urls = Acessar seus dados em todos os sites visitados

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Acessar seus dados em páginas do domínio { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Acessar seus dados em { $domainCount } outro domínio
       *[other] Acessar seus dados em { $domainCount } outros domínios
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Acessar seus dados em { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Acessar seus dados em { $domainCount } outro site
       *[other] Acessar seus dados em { $domainCount } outros sites
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Esta extensão concede a { $hostname } acesso a seus dispositivos MIDI.
webext-site-perms-header-with-gated-perms-midi-sysex = Esta extensão concede a { $hostname } acesso a seus dispositivos MIDI (com suporte a SysEx).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Geralmente são dispositivos conectados, como sintetizadores de áudio, mas também podem estar integrados ao seu computador.
    
    Os sites normalmente não têm permissão para acessar dispositivos MIDI. O uso inadequado pode causar danos ou comprometer a segurança.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Adicionar { $extension }? Esta extensão concede as seguintes capacidades a { $hostname }:
webext-site-perms-header-unsigned-with-perms = Adicionar { $extension }? Esta extensão não foi verificada. Extensões maliciosas podem roubar suas informações privativas ou comprometer seu computador. Só instale se confiar na origem. Esta extensão concede as seguintes capacidades a { $hostname }:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Acessar dispositivos MIDI
webext-site-perms-midi-sysex = Acessar dispositivos MIDI com suporte a SysEx
