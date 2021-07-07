# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Contas e senhas

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Tenha suas senhas em qualquer lugar
login-app-promo-subtitle = Instale o aplicativo gratuito { -lockwise-brand-name }
login-app-promo-android =
    .alt = Instale a partir do Google Play
login-app-promo-apple =
    .alt = Baixe no App Store
login-filter =
    .placeholder = Pesquisar contas
create-login-button = Criar nova conta
fxaccounts-sign-in-text = Tenha suas senhas em outros dispositivos
fxaccounts-sign-in-button = Entrar no { -sync-brand-short-name }
fxaccounts-sign-in-sync-button = Entrar no Sync
fxaccounts-avatar-button =
    .title = Gerenciar conta

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Abrir menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar de outro navegador…
about-logins-menu-menuitem-import-from-a-file = Importar de um arquivo…
about-logins-menu-menuitem-export-logins = Exportar contas…
about-logins-menu-menuitem-remove-all-logins = Remover todas as contas…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opções
       *[other] Preferências
    }
about-logins-menu-menuitem-help = Ajuda
menu-menuitem-android-app = { -lockwise-brand-short-name } para Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } para iPhone e iPad

## Login List

login-list =
    .aria-label = Contas que combinar com a consulta
login-list-count =
    { $count ->
        [one] { $count } conta
       *[other] { $count } contas
    }
login-list-sort-label-text = Ordenar por:
login-list-name-option = Nome (A-Z)
login-list-name-reverse-option = Nome (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Última modificação
login-list-last-used-option = Último uso
login-list-intro-title = Nenhuma conta encontrada
login-list-intro-description = Quando você salva uma senha no { -brand-product-name }, ela aparece aqui.
about-logins-login-list-empty-search-title = Nenhuma conta encontrada
about-logins-login-list-empty-search-description = Nenhum resultado corresponde à sua busca.
login-list-item-title-new-login = Nova conta
login-list-item-subtitle-new-login = Informe as credenciais da sua conta
login-list-item-subtitle-missing-username = (sem nome de usuário)
about-logins-list-item-breach-icon =
    .title = Site vazado
about-logins-list-item-vulnerable-password-icon =
    .title = Senha vulnerável

## Introduction screen

login-intro-heading = Procurando suas contas salvas? Configure o { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Procurando suas contas salvas? Configure o { -sync-brand-short-name } ou importe.
about-logins-login-intro-heading-logged-out2 = Procurando suas contas salvas? Ative a sincronização ou importe.
about-logins-login-intro-heading-logged-in = Nenhuma conta sincronizada foi encontrada.
login-intro-description = Se você salvou suas contas no { -brand-product-name } em outro dispositivo, veja como tê-las aqui:
login-intro-instruction-fxa = Crie ou entre na sua { -fxaccount-brand-name } no dispositivo onde suas contas estão salvas
login-intro-instruction-fxa-settings = Selecione a opção 'Contas de acesso' nas configurações do { -sync-brand-short-name }
about-logins-intro-instruction-help = Caso precise de mais ajuda, visite o <a data-l10n-name="help-link">suporte do { -lockwise-brand-short-name }</a>
login-intro-instructions-fxa = Crie ou entre na sua { -fxaccount-brand-name } no dispositivo onde suas contas estão salvas.
login-intro-instructions-fxa-settings = Vá em Configurações > Sync > Ativar sincronização… Selecione a opção de contas e senhas.
login-intro-instructions-fxa-help = Visite o <a data-l10n-name="help-link">suporte do { -lockwise-brand-short-name }</a> para obter mais ajuda.
about-logins-intro-import = Se suas contas estão salvas em outro navegador, você pode <a data-l10n-name="import-link">importar para o { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Se suas contas foram salvas fora do { -brand-product-name }, você pode <a data-l10n-name="import-browser-link">importar de outro navegador</a> ou <a data-l10n-name="import-file-link">de um arquivo</a>

## Login

login-item-new-login-title = Criar nova conta
login-item-edit-button = Editar
about-logins-login-item-remove-button = Remover
login-item-origin-label = Endereço do site
login-item-tooltip-message = Certifique-se de que corresponde ao endereço exato do site onde você acessou a conta.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nome de usuário
about-logins-login-item-username =
    .placeholder = (sem nome de usuário)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = Copiado!
login-item-password-label = Senha
login-item-password-reveal-checkbox =
    .aria-label = Mostrar senha
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = Copiado!
login-item-save-changes-button = Salvar alterações
login-item-save-new-button = Salvar
login-item-cancel-button = Cancelar
login-item-time-changed = Última modificação: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Criado em: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Último uso: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Para editar a conta, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar a conta salva
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Para ver a senha, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = revelar a senha salva
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Para copiar a senha, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar a senha salva

## Master Password notification

master-password-notification-message = Digite sua senha principal para ver contas e senhas salvas
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Para exportar suas contas, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar contas e senhas salvas

## Primary Password notification

about-logins-primary-password-notification-message = Digite sua senha principal para ver contas e senhas salvas
master-password-reload-button =
    .label = Entrar
    .accesskey = E

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Quer ter suas contas em todo lugar onde usa o { -brand-product-name }? Vá nas opções do { -sync-brand-short-name } e selecione a opção Contas de acesso.
       *[other] Quer ter suas contas em todo lugar onde usa o { -brand-product-name }? Vá nas preferências do { -sync-brand-short-name } e selecione a opção Contas de acesso.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Visite a opções do { -sync-brand-short-name }
           *[other] Visite as preferências do { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Não perguntar novamente
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancelar
confirmation-dialog-dismiss-button =
    .title = Cancelar
about-logins-confirm-remove-dialog-title = Remover esta conta?
confirm-delete-dialog-message = Esta ação não pode ser desfeita.
about-logins-confirm-remove-dialog-confirm-button = Remover
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Remover
        [one] Remover
       *[other] Remover tudo
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Sim, remover esta conta
        [one] Sim, remover esta conta
       *[other] Sim, remover estas contas
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Remover { $count } conta?
       *[other] Remover todas as { $count } contas?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Será removida a conta que você salvou no { -brand-short-name } e quaisquer alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
        [one] Será removida a conta que você salvou no { -brand-short-name } e quaisquer alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
       *[other] Serão removidas as contas que você salvou no { -brand-short-name } e quaisquer alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Remover { $count } conta de todos os dispositivos?
       *[other] Remover todas as { $count } contas de todos os dispositivos?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Será removida a conta que você salvou no { -brand-short-name } em todos os dispositivos sincronizados com sua { -fxaccount-brand-name }. Também serão removidos alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
        [one] Será removida a conta que você salvou no { -brand-short-name } em todos os dispositivos sincronizados com sua { -fxaccount-brand-name }. Também serão removidos alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
       *[other] Serão removidas todos as contas que você salvou no { -brand-short-name } em todos os dispositivos sincronizados com sua { -fxaccount-brand-name }. Também serão removidos alertas de vazamento que aparecem aqui. Você não pode desfazer esta ação.
    }
about-logins-confirm-export-dialog-title = Exportar contas e senhas
about-logins-confirm-export-dialog-message = Suas senhas serão salvas em texto legível (exemplo, Senh@Ruim123), qualquer pessoa que consiga abrir o arquivo exportado poderá ver.
about-logins-confirm-export-dialog-confirm-button = Exportar…
about-logins-alert-import-title = Importação concluída
about-logins-alert-import-message = Ver resumo detalhado da importação
confirm-discard-changes-dialog-title = Descartar alterações não salvas?
confirm-discard-changes-dialog-message = Todas as alterações não salvas serão perdidas.
confirm-discard-changes-dialog-confirm-button = Descartar

## Breach Alert notification

about-logins-breach-alert-title = Vazamento de site
breach-alert-text = Senhas foram vazadas ou roubadas deste site desde a última vez que você atualizou suas credenciais de acesso. Mude a senha para proteger sua conta.
about-logins-breach-alert-date = Este vazamento ocorreu em { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ir para { $hostname }
about-logins-breach-alert-learn-more-link = Saiba mais

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Senha vulnerável
about-logins-vulnerable-alert-text2 = Esta senha foi usada em outra conta de um site onde houve vazamento de dados. Reaproveitar credenciais coloca todas as suas contas em risco. Mude esta senha.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir para { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saiba mais

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Já existe um item de { $loginTitle } com este nome de usuário. <a data-l10n-name="duplicate-link">Ir para o item existente?</a>
# This is a generic error message.
about-logins-error-message-default = Ocorreu um erro ao tentar salvar esta senha.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar arquivo de contas
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = contas.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Arquivo CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar arquivo de contas
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Arquivo CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] Arquivo TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importação concluída
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Nova conta adicionada:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Novas contas adicionadas:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Conta existente atualizada:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Contas existentes atualizadas:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Conta duplicada encontrada:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importada)</span>
       *[other] <span>Contas duplicadas encontradas:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importadas)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Erro:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importado)</span>
       *[other] <span>Erros:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importados)</span>
    }
about-logins-import-dialog-done = Concluído
about-logins-import-dialog-error-title = Erro de importação
about-logins-import-dialog-error-conflicting-values-title = Vários valores conflitantes para uma mesma conta
about-logins-import-dialog-error-conflicting-values-description = Por exemplo, vários nomes de usuário, senhas, endereços, etc. para uma mesma conta.
about-logins-import-dialog-error-file-format-title = Problema no formato do arquivo
about-logins-import-dialog-error-file-format-description = Cabeçalhos de coluna incorretos ou ausentes. Certifique-se de que o arquivo inclui colunas de nome de usuário, senha e URL.
about-logins-import-dialog-error-file-permission-title = Não foi possível ler o arquivo
about-logins-import-dialog-error-file-permission-description = O { -brand-short-name } não tem permissão para ler o arquivo. Experimente alterar as permissões do arquivo.
about-logins-import-dialog-error-unable-to-read-title = Não foi possível analisar o arquivo
about-logins-import-dialog-error-unable-to-read-description = Certifique-se de selecionar um arquivo CSV ou TSV.
about-logins-import-dialog-error-no-logins-imported = Nenhuma conta foi importada
about-logins-import-dialog-error-learn-more = Saiba mais
about-logins-import-dialog-error-try-again = Tentar novamente…
about-logins-import-dialog-error-try-import-again = Tentar importar novamente…
about-logins-import-dialog-error-cancel = Cancelar
about-logins-import-report-title = Resumo da importação
about-logins-import-report-description = Contas e senhas importadas para o { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Linha { $number }
about-logins-import-report-row-description-no-change = Duplicado: Corresponde exatamente a uma conta já existente
about-logins-import-report-row-description-modified = Conta existente atualizada
about-logins-import-report-row-description-added = Nova conta adicionada
about-logins-import-report-row-description-error = Erro: Falta um campo

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Erro: Múltiplos valores de { $field }
about-logins-import-report-row-description-error-missing-field = Erro: Falta { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Nova conta adicionada</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Novas contas adicionadas</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Conta existente atualizada</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Contas existentes atualizadas</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Conta duplicada</div> <div data-l10n-name="not-imported">(não importada)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Contas duplicadas</div> <div data-l10n-name="not-imported">(não importadas)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Erro</div> <div data-l10n-name="not-imported">(não importado)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Erros</div> <div data-l10n-name="not-imported">(não importados)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Relatório de resumo da importação
