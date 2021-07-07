# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Relatório de { $addon-name }
abuse-report-title-extension = Denunciar esta extensão para a { -vendor-short-name }
abuse-report-title-theme = Denunciar este tema para a { -vendor-short-name }
abuse-report-subtitle = Qual é o problema?
# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = por <a data-l10n-name="author-name">{ $author-name }</a>
abuse-report-learnmore =
    Não tem certeza de qual problema selecionar?
    <a data-l10n-name="learnmore-link">Saiba mais sobre como denunciar extensões e temas</a>
abuse-report-submit-description = Descreva o problema (opcional)
abuse-report-textarea =
    .placeholder = É mais fácil para nós abordar um problema se tivermos detalhes. Descreva o que está acontecendo. Obrigado por nos ajudar a manter a web saudável.
abuse-report-submit-note = Nota: Não inclua informações pessoais (como nome, endereço de email, número de telefone, endereço físico). A { -vendor-short-name } guarda um registro permanente desses relatos.

## Panel buttons.

abuse-report-cancel-button = Cancelar
abuse-report-next-button = Avançar
abuse-report-goback-button = Voltar
abuse-report-submit-button = Enviar

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Denúncia de <span data-l10n-name="addon-name">{ $addon-name }</span> cancelada.
abuse-report-messagebar-submitting = Enviando denúncia de <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Obrigado por enviar uma denúncia. Quer remover <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Obrigado por enviar uma denúncia.
abuse-report-messagebar-removed-extension = Obrigado por enviar uma denúncia. Você removeu a extensão <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Obrigado por enviar uma denúncia. Você removeu o tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Houve um erro ao enviar a denúncia de <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = A denúncia de <span data-l10n-name="addon-name">{ $addon-name }</span> não foi enviada porque outra denúncia foi enviado recentemente.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Sim, remover
abuse-report-messagebar-action-keep-extension = Não, manter
abuse-report-messagebar-action-remove-theme = Sim, remover
abuse-report-messagebar-action-keep-theme = Não, manter
abuse-report-messagebar-action-retry = Tentar novamente
abuse-report-messagebar-action-cancel = Cancelar

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Danificou meu computador ou comprometeu meus dados
abuse-report-damage-example = Exemplo: injetou código malicioso ou roubou dados
abuse-report-spam-reason-v2 = Contém spam ou insere publicidade indesejada
abuse-report-spam-example = Exemplo: insere anúncios em páginas web
abuse-report-settings-reason-v2 = Mudou meu mecanismo de pesquisa, página inicial ou página de nova aba, sem me informar ou me perguntar
abuse-report-settings-suggestions = Antes de denunciar a extensão, você pode tentar alterar suas configurações:
abuse-report-settings-suggestions-search = Muda sua configuração de pesquisa padrão
abuse-report-settings-suggestions-homepage = Muda a página inicial e a página de nova aba
abuse-report-deceptive-reason-v2 = Alega ser algo que não é
abuse-report-deceptive-example = Exemplo: descrição ou imagens enganosas
abuse-report-broken-reason-extension-v2 = Não funciona, atrapalha sites, ou faz o { -brand-product-name } ficar mais lento
abuse-report-broken-reason-theme-v2 = Não funciona ou atrapalha a exibição do navegador
abuse-report-broken-example = Exemplo: recursos são lentos, difíceis de usar, ou não funcionam; partes de sites não são carregadas ou aparecem erradas
abuse-report-broken-suggestions-extension =
    Parece que você identificou um bug. Além de enviar um relato aqui, a melhor maneira de
    ter um problema de funcionalidade resolvido é entrar em contato com o desenvolvedor da extensão.
    <a data-l10n-name="support-link">Visite o site da extensão</a> para obter informações do desenvolvedor.
abuse-report-broken-suggestions-theme =
    Parece que você identificou um bug. Além de enviar um relato aqui, a melhor maneira de
    ter um problema de funcionalidade resolvido é entrar em contato com o desenvolvedor do tema.
    <a data-l10n-name="support-link">Visite o site do tema</a> para obter informações do desenvolvedor.
abuse-report-policy-reason-v2 = Contém conteúdo de ódio, violento ou ilegal
abuse-report-policy-suggestions =
    Nota: Problemas de direitos autorais (copyright) e marcas registradas (trademark) devem ser relatados em um processo diferente.
    <a data-l10n-name="report-infringement-link">Siga essas instruções</a> para relatar um problema.
abuse-report-unwanted-reason-v2 = Eu nunca quis e não sei como me livrar disso
abuse-report-unwanted-example = Exemplo: uma aplicação instalou sem minha permissão
abuse-report-other-reason = Outra coisa
