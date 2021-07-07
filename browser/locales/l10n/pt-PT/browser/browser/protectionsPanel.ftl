# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Ocorreu um erro ao enviar o relatório. Por favor, tente novamente mais tarde.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Site corrigido? Enviar relatório

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Rigorosa
    .label = Rigorosa
protections-popup-footer-protection-label-custom = Personalizada
    .label = Personalizada
protections-popup-footer-protection-label-standard = Padrão
    .label = Padrão

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Mais informação sobre a Proteção melhorada contra a monitorização

protections-panel-etp-on-header = A proteção melhorada contra a monitorização está ATIVADA para este site
protections-panel-etp-off-header = A proteção melhorada contra a monitorização está DESATIVADA para este site

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = O site não está a funcionar?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = O site não está a funcionar?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Porquê?
protections-panel-not-blocking-why-etp-on-tooltip = O bloqueio destes pode quebrar elementos em alguns sites. Sem rastreadores, alguns botões, formulários e campos de autenticação podem não funcionar.
protections-panel-not-blocking-why-etp-off-tooltip = Todos os rastreadores deste site foram carregados porque as proteções estão desativadas.

##

protections-panel-no-trackers-found = Não foi detetado nenhum rastreador conhecido pelo { -brand-short-name } nesta página.

protections-panel-content-blocking-tracking-protection = Conteúdo de monitorização

protections-panel-content-blocking-socialblock = Rastreadores de redes sociais
protections-panel-content-blocking-cryptominers-label = Cripto-mineradores
protections-panel-content-blocking-fingerprinters-label = Identificadores

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqueado
protections-panel-not-blocking-label = Permitido
protections-panel-not-found-label = Nenhuma detetada

##

protections-panel-settings-label = Definições de proteção
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Painel das proteções

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Desligue as proteções se estiver a ter problemas com:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campos de credenciais
protections-panel-site-not-working-view-issue-list-forms = Formulários
protections-panel-site-not-working-view-issue-list-payments = Pagamentos
protections-panel-site-not-working-view-issue-list-comments = Comentários
protections-panel-site-not-working-view-issue-list-videos = Vídeos

protections-panel-site-not-working-view-send-report = Enviar um relatório

##

protections-panel-cross-site-tracking-cookies = Estes cookies seguem-no entre os vários sites para recolher dados sobre o que faz na Internet. São definidos por terceiros, como anunciantes e empresas de análise.
protections-panel-cryptominers = Os cripto-mineradores utilizam o poder de computação do seu sistema para minerar dinheiro digital. Os scripts de cripto-mineração podem descarregar a sua bateria, tornar o seu computador mais lento e aumentar os custos com a sua fatura elétrica.
protections-panel-fingerprinters = Os identificadores recolhem definições do seu navegador e computador para criar um perfil sobre si. Ao utilizar este identificador digital, estes podem monitorizá-lo em vários sites diferentes.
protections-panel-tracking-content = Os sites podem carregar anúncios, vídeos e outros conteúdos externos com códigos de rastreamento. O bloqueio de conteúdos de rastreamento pode ajudar os sites a carregar mais rapidamente, mas alguns botões, formulários e campos de autenticação podem não funcionar.
protections-panel-social-media-trackers = As redes sociais colocam rastreadores em outros sites para monitorizar o que faz, vê e assiste na Internet. Isto permite que estas empresas de redes sociais saibam mais sobre si, para além do que partilha no seu perfil nas redes sociais.

protections-panel-description-shim-allowed = Alguns rastreadores marcados abaixo foram parcialmente desbloqueados nesta página porque interagiu com os mesmos.
protections-panel-description-shim-allowed-learn-more = Saber mais
protections-panel-shim-allowed-indicator =
    .tooltiptext = Rastreador parcialmente desbloqueado

protections-panel-content-blocking-manage-settings =
    .label = Gerir definições de proteção
    .accesskey = G

protections-panel-content-blocking-breakage-report-view =
    .title = Reportar um site quebrado
protections-panel-content-blocking-breakage-report-view-description = O bloqueio de determinados rastreadores pode causar problemas com alguns sites. Reportar estes problemas ajuda o { -brand-short-name } a melhorar para todos. O envio deste relatório irá enviar um endereço e informação sobre as suas definições do navegador à Waterfox. <label data-l10n-name="learn-more">Saber mais</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opcional: descreva o problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opcional: descreva o problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Cancelar
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Enviar relatório
