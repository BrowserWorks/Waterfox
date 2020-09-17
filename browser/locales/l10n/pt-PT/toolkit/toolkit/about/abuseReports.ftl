# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Reportar para { $addon-name }

abuse-report-title-extension = Reportar esta extensão à { -vendor-short-name }
abuse-report-title-theme = Reportar este tema à { -vendor-short-name }
abuse-report-subtitle = Qual é o problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = por <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Não sabe qual problema selecionar?
    <a data-l10n-name="learnmore-link">Saber mais acerca de reportar extensões e temas</a>

abuse-report-submit-description = Descreva o problema (opcional)
abuse-report-textarea =
    .placeholder = É mais fácil resolver um problema se tivermos detalhes específicos. Por favor descreva o que está a experienciar. Obrigado por nos ajudar a manter a web saudável.
abuse-report-submit-note =
    Nota: não inclua informações pessoais (como nome, endereço de email, número de telefone e endereço físico).
    A { -vendor-short-name } mantém um registo permanente destes relatórios.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Seguinte
abuse-report-goback-button = Retroceder
abuse-report-submit-button = Submeter

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Relatório para <span data-l10n-name="addon-name">{ $addon-name }</span> cancelado.
abuse-report-messagebar-submitting = A enviar relatório para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Obrigado por enviar um relatório. Pretende remover <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Obrigado por submeter um relatório.
abuse-report-messagebar-removed-extension = Obrigado por enviar um relatório. Removeu a extensão <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Obrigado por enviar um relatório. Removeu o tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Ocorreu um erro ao enviar o relatório para <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = O relatório para <span data-l10n-name="addon-name">{ $addon-name }</span> não foi enviado porque outro relatório foi submetido recentemente.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sim, removê-la
abuse-report-messagebar-action-keep-extension = Não, vou mantê-la
abuse-report-messagebar-action-remove-theme = Sim, removê-lo
abuse-report-messagebar-action-keep-theme = Não, vou mantê-lo
abuse-report-messagebar-action-retry = Voltar a tentar
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Danificou o meu computador ou comprometeu os meus dados
abuse-report-damage-example = Exemplo: malware injetado ou dados furtados

abuse-report-spam-reason-v2 = Contém spam ou insere publicidade não-solicitada
abuse-report-spam-example = Exemplo: inserir anúncios em páginas da web

abuse-report-settings-reason-v2 = Alterou o meu motor de pesquisa, página inicial ou o novo separador sem informar ou questionar
abuse-report-settings-suggestions = Antes de reportar a extensão, pode tentar alterar as suas definições:
abuse-report-settings-suggestions-search = Alterar o seu motor de pesquisa predefinido
abuse-report-settings-suggestions-homepage = Alterar a sua página inicial e novo separador

abuse-report-deceptive-reason-v2 = Alega ser algo que não é
abuse-report-deceptive-example = Exemplo: descrição ou imagem enganosa

abuse-report-broken-reason-extension-v2 = Não funciona, quebra sites ou torna o { -brand-product-name } mais lento
abuse-report-broken-reason-theme-v2 = Não funciona ou quebra a visualização do navegador
abuse-report-broken-example = Exemplo: funcionalidades lentas, difíceis de utilizar ou que não funcionam; partes de sites que não são carregadas ou parecem estranhas
abuse-report-broken-suggestions-extension =
    Parece que identificou um bug. Além de submeter um relatório aqui, a melhor maneira
    de resolver um problema de funcionalidade é entrar em contacto com o programador da extensão.
    <a data-l10n-name="support-link">Visite o site da extensão</a> para obter informações sobre o programador.
abuse-report-broken-suggestions-theme =
    Parece que identificou um bug. Além de submeter um relatório aqui, a melhor maneira
    de resolver um problema de funcionalidade é entrar em contacto com o programador do tema.
    <a data-l10n-name="support-link">Visite o site do tema</a> para obter informações sobre o programador.

abuse-report-policy-reason-v2 = Contém conteúdo odioso, violento, ou ilegal
abuse-report-policy-suggestions =
    Nota: os problemas de direitos de autor e marcas registadas devem ser reportados num processo em separado.
    <a data-l10n-name="report-infringement-link">Utilize estas instruções</a> para
    reportar o problema.

abuse-report-unwanted-reason-v2 = Eu nunca quis isto e não sei como livrar-me do mesmo
abuse-report-unwanted-example = Exemplo: uma aplicação instalou-o sem a minha permissão

abuse-report-other-reason = Outra coisa

