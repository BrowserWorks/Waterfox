# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Credenciais e palavras-passe

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Leve as suas palavras-passe para todo o lado
login-app-promo-subtitle = Obtenha a aplicação gratuita do { -lockwise-brand-name }
login-app-promo-android =
    .alt = Obter no Google Play
login-app-promo-apple =
    .alt = Transferir da App Store
login-filter =
    .placeholder = Pesquisar credenciais
create-login-button = Criar nova credencial
fxaccounts-sign-in-text = Obtenha as suas palavras-passe nos seus outros dispositivos
fxaccounts-sign-in-button = Iniciar sessão no { -sync-brand-short-name }
fxaccounts-sign-in-sync-button = Iniciar sessão para sincronizar
fxaccounts-avatar-button =
    .title = Gerir conta

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Abrir menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar de outro navegador…
about-logins-menu-menuitem-import-from-a-file = Importar de um ficheiro:
about-logins-menu-menuitem-export-logins = Exportar credenciais…
about-logins-menu-menuitem-remove-all-logins = Remover todas as credenciais…
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
    .aria-label = Credenciais que correspondem aos termos da pesquisa
login-list-count =
    { $count ->
        [one] { $count } credencial
       *[other] { $count } credenciais
    }
login-list-sort-label-text = Ordenar por:
login-list-name-option = Nome (A-Z)
login-list-name-reverse-option = Nome (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Última modificação
login-list-last-used-option = Última utilização
login-list-intro-title = Não foram encontradas credenciais
login-list-intro-description = Quando guarda uma palavra-passe no { -brand-product-name }, esta será apresentada aqui.
about-logins-login-list-empty-search-title = Não foram encontradas credenciais
about-logins-login-list-empty-search-description = Não foram encontrados resultados que correspondam à sua pesquisa.
login-list-item-title-new-login = Nova credencial
login-list-item-subtitle-new-login = Introduza as suas credenciais
login-list-item-subtitle-missing-username = (sem nome de utilizador)
about-logins-list-item-breach-icon =
    .title = Site invadido
about-logins-list-item-vulnerable-password-icon =
    .title = Palavra-passe vulnerável

## Introduction screen

login-intro-heading = Está à procura das suas credenciais guardadas? Configure o { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Está à procura das suas credenciais guardadas? Configure o { -sync-brand-short-name } ou importe as credenciais.
about-logins-login-intro-heading-logged-out2 = À procura das suas credenciais guardadas? Ative a sincronização ou importe as credenciais.
about-logins-login-intro-heading-logged-in = Não foram encontradas credenciais sincronizadas.
login-intro-description = Se guardou as suas credenciais para o { -brand-product-name } num dispositivo diferente, eis como as obter aqui:
login-intro-instruction-fxa = Crie ou inicie a sessão na sua { -fxaccount-brand-name } no dispositivo onde as suas credenciais estão guardadas
login-intro-instruction-fxa-settings = Certifique-se que ativou a opção Credenciais nas definições do { -sync-brand-short-name }
about-logins-intro-instruction-help = Visite o <a data-l10n-name="help-link">Apoio do { -lockwise-brand-short-name }</a> para mais ajuda
login-intro-instructions-fxa = Crie ou inicie a sessão na sua { -fxaccount-brand-name } no dispositivo onde as suas credenciais estão guardadas
login-intro-instructions-fxa-settings = Aceda a Definições > Sincronizar > Ativar sincronização... Marque a caixa de seleção Credenciais e palavras-passe.
login-intro-instructions-fxa-help = Visite o <a data-l10n-name="help-link">Apoio do { -lockwise-brand-short-name }</a> para mais ajuda.
about-logins-intro-import = Se as suas credenciais estão guardadas noutro navegador, pode <a data-l10n-name="import-link">importar as mesmas para o { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Se as suas credenciais são guardadas fora do { -brand-product-name }, poderá <a data-l10n-name="import-browser-link">importar as mesmas de outro navegador</a> ou <a data-l10n-name="import-file-link">de um ficheiro</a>

## Login

login-item-new-login-title = Criar nova credencial
login-item-edit-button = Editar
about-logins-login-item-remove-button = Remover
login-item-origin-label = Endereço do site
login-item-tooltip-message = Certifique-se que isto corresponde ao endereço exato do site onde se autenticou.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nome de utilizador
about-logins-login-item-username =
    .placeholder = (sem nome de utilizador)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = Copiado!
login-item-password-label = Palavra-passe
login-item-password-reveal-checkbox =
    .aria-label = Mostrar palavra-passe
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = Copiada!
login-item-save-changes-button = Guardar alterações
login-item-save-new-button = Guardar
login-item-cancel-button = Cancelar
login-item-time-changed = Última modificação: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Criada: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Última utilização: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Para editar a sua credencial, introduza as suas credenciais de autenticação do Windows. Isto ajuda a proteger a segurança das suas contas.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar a credencial guardada
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Para ver a sua palavra-passe, introduza as suas credenciais de autenticação do Windows. Isto ajuda a proteger a segurança das suas contas.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = revelar a palavra-passe guardada
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Para copiar a sua palavra-passe, introduza as suas credenciais de autenticação do Windows. Isto ajuda a proteger a segurança das suas contas.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar a palavra-passe guardada

## Master Password notification

master-password-notification-message = Por favor introduza a sua palavra-passe mestra para ver credenciais e palavras-passe guardadas
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Para exportas as suas credenciais, introduza as suas credenciais de autenticação do Windows. Isto ajuda a proteger a segurança das suas contas.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar credenciais e palavras-passe guardadas

## Primary Password notification

about-logins-primary-password-notification-message = Por favor introduza a sua palavra-passe principal para ver credenciais e palavras-passe guardadas
master-password-reload-button =
    .label = Iniciar sessão
    .accesskey = I

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Quer as suas credenciais em todo o lado em que utiliza o { -brand-product-name }? Aceda às Opções do { -sync-brand-short-name } e selecione a opção Credenciais.
       *[other] Quer as suas credenciais em todo o lado em que utiliza o { -brand-product-name }? Aceda às Preferências do { -sync-brand-short-name } e selecione a opção Credenciais.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Visitar as opções do { -sync-brand-short-name }
           *[other] Visitar as preferências do { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Não voltar a perguntar
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancelar
confirmation-dialog-dismiss-button =
    .title = Cancelar
about-logins-confirm-remove-dialog-title = Remover esta credencial?
confirm-delete-dialog-message = Esta ação não pode ser anulada.
about-logins-confirm-remove-dialog-confirm-button = Remover
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Remover
        [one] Remover
       *[other] Remover tudo
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Sim, remover esta credencial
       *[other] Sim, remover estas credenciais
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Remover { $count } credencial?
       *[other] Remove todas as { $count } credenciais?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Isto irá remover a credencial que guardou no { -brand-short-name } e quaisquer alertas de violação de dados que sejam apresentados aqui. Não poderá anular esta ação.
       *[other] Isto irá remover as credenciais que guardou no { -brand-short-name } e quaisquer alertas de violação de dados que sejam apresentados aqui. Não poderá anular esta ação.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Remover { $count } credencial de todos os dispositivos?
       *[other] Remover todas as { $count } credenciais de todos os dispositivos?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Isto irá remover a credencial que guardou no { -brand-short-name } em todos os seus dispositivos onde sincronizou a sua { -fxaccount-brand-name }. Isto irá também remover quaisquer alertas de violação de dados que sejam apresentados aqui. Não poderá anular esta ação.
       *[other] Isto irá remover todas as credenciais que guardou no { -brand-short-name } em todos os seus dispositivos onde sincronizou a sua { -fxaccount-brand-name }. Isto irá também remover quaisquer alertas de violação de dados que sejam apresentados aqui. Não poderá anular esta ação.
    }
about-logins-confirm-export-dialog-title = Exportar credenciais e palavras-passe
about-logins-confirm-export-dialog-message = As suas palavras-passe serão guardadas como texto legível (por exemplo, BadP@ssw0rd) para que qualquer pessoa que possa abrir o ficheiro exportado as possa visualizar.
about-logins-confirm-export-dialog-confirm-button = Exportar…
about-logins-alert-import-title = Importação concluída
about-logins-alert-import-message = Ver resumo detalhado da importação
confirm-discard-changes-dialog-title = Descartar alterações não guardadas?
confirm-discard-changes-dialog-message = Todas as alterações não guardadas irão ser perdidas.
confirm-discard-changes-dialog-confirm-button = Descartar

## Breach Alert notification

about-logins-breach-alert-title = Violação de dados em site
breach-alert-text = As palavras-passe deste site foram divulgadas ou roubadas desde a última vez que atualizou as suas credenciais. Altere a sua palavra-passe para proteger a sua conta.
about-logins-breach-alert-date = Esta violação de dados ocorreu a { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ir para { $hostname }
about-logins-breach-alert-learn-more-link = Saber mais

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Palavra-passe vulnerável
about-logins-vulnerable-alert-text2 = Esta palavra-passe foi utilizada noutra conta que provavelmente esteve envolvida numa violação de dados. Reutilizar credenciais coloca todas as suas contas em risco. Altere esta palavra-passe.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir para { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saber mais

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Já existe uma entrada com esse nome de utilizador para { $loginTitle }. <a data-l10n-name="duplicate-link">Ir para a entrada existente?</a>
# This is a generic error message.
about-logins-error-message-default = Ocorreu um erro enquanto tentava guardar esta palavra-passe.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar ficheiro de credenciais
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = credenciais.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Ficheiro CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar ficheiro de credenciais
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Ficheiro CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] Ficheiro TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importação concluída
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Nova credencial adicionada:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Novas credenciais adicionadas:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Credencial existente atualizada:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Credenciais existentes atualizadas:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Foi encontrada uma credencial duplicada:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importada)</span>
       *[other] <span>Foram encontradas credenciais duplicadas:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importadas)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Erro:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importada)</span>
       *[other] <span>Erros:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(não importadas)</span>
    }
about-logins-import-dialog-done = Concluído
about-logins-import-dialog-error-title = Erro de importação
about-logins-import-dialog-error-conflicting-values-title = Múltiplos valores conflituantes para Credencial Única
about-logins-import-dialog-error-conflicting-values-description = Por exemplo: vários nomes de utilizador, palavras-passe, endereços, etc. para uma credencial.
about-logins-import-dialog-error-file-format-title = Problema com o formato do ficheiro
about-logins-import-dialog-error-file-format-description = Cabeçalhos de colunas incorretos ou em falta. Confirme que o ficheiro inclui colunas para o nome de utilizador, palavra-passe e endereço.
about-logins-import-dialog-error-file-permission-title = Não foi possível ler o ficheiro
about-logins-import-dialog-error-file-permission-description = O { -brand-short-name } não tem permissão para ler o ficheiro. Tente alterar as permissões do ficheiro.
about-logins-import-dialog-error-unable-to-read-title = Não foi possível interpretar o ficheiro
about-logins-import-dialog-error-unable-to-read-description = Certifique-se que selecionou um ficheiro CSV ou TSV.
about-logins-import-dialog-error-no-logins-imported = Não foram importadas credenciais
about-logins-import-dialog-error-learn-more = Saber mais
about-logins-import-dialog-error-try-again = Tentar novamente…
about-logins-import-dialog-error-try-import-again = Tente importar novamente...
about-logins-import-dialog-error-cancel = Cancelar
about-logins-import-report-title = Resumo de importação
about-logins-import-report-description = Credenciais e palavras-passe importadas para o { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Linha { $number }
about-logins-import-report-row-description-no-change = Duplicado: correspondência exata a credencial existente
about-logins-import-report-row-description-modified = Credencial existente atualizada
about-logins-import-report-row-description-added = Nova credencial adicionada
about-logins-import-report-row-description-error = Erro: campo em falta

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Erro: Múltiplos valores para { $field }
about-logins-import-report-row-description-error-missing-field = Erro: { $field } em falta

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nova credencial adicionada</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">novas credenciais adicionadas</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credencial existente atualizada</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenciais existentes atualizadas</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credencial duplicada</div> <div data-l10n-name="not-imported">(não importada)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenciais duplicadas</div> <div data-l10n-name="not-imported">(não importadas)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">erro</div> <div data-l10n-name="not-imported">(não importada)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">erros</div> <div data-l10n-name="not-imported">(não importadas)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Relatório com o resumo da importação
