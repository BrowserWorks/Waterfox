# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Sobre o { -brand-full-name }

releaseNotes-link = Novidades

update-checkForUpdatesButton =
    .label = Verificar se há atualizações
    .accesskey = V

update-updateButton =
    .label = Reiniciar o { -brand-shorter-name } para atualizar
    .accesskey = R

update-checkingForUpdates = Verificando se há atualizações…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Baixando atualização — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Baixando atualização — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Aplicando atualização…

update-failed = Falha na atualização. <label data-l10n-name="failed-link">Baixar a versão mais recente</label>
update-failed-main = Falha na atualização. <a data-l10n-name="failed-link-main">Baixar a versão mais recente</a>

update-adminDisabled = Atualizações desativadas pelo administrador do sistema
update-noUpdatesFound = O { -brand-short-name } está atualizado
aboutdialog-update-checking-failed = Falha ao verificar se há atualizações.
update-otherInstanceHandlingUpdates = O { -brand-short-name } está sendo atualizado por outra instância

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Atualizações disponíveis em <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Atualizações disponíveis em <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Não é mais possível realizar atualizações neste sistema. <label data-l10n-name="unsupported-link">Saiba mais</label>

update-restarting = Reiniciando…

update-internal-error2 = Não foi possível verificar se há atualizações devido a um erro interno. Atualizações disponíveis em <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Usando o canal de atualização <label data-l10n-name="current-channel">{ $channel }</label>. 

warningDesc-version = O { -brand-short-name } é experimental e pode ser instável.

aboutdialog-help-user = Ajuda do { -brand-product-name }
aboutdialog-submit-feedback = Enviar opinião

community-exp = A <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> é uma <label data-l10n-name="community-exp-creditsLink">comunidade global</label> que trabalha unida para manter a web aberta, pública e acessível a todos.

community-2 = O { -brand-short-name } é desenvolvido pela <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, uma <label data-l10n-name="community-creditsLink">comunidade global</label> que trabalha unida para manter a web aberta, pública e acessível a todos.

helpus = Quer ajudar? <label data-l10n-name="helpus-donateLink">Faça uma doação</label> ou <label data-l10n-name="helpus-getInvolvedLink">participe!</label>

bottomLinks-license = Informações de licenciamento
bottomLinks-rights = Direitos do usuário final
bottomLinks-privacy = Política de privacidade

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bits)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bits)
