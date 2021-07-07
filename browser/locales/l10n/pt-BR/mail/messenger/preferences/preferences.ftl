# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Fechar
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opções
           *[other] Preferências
        }
preferences-tab-title =
    .title = Preferências
preferences-doc-title = Preferências
category-list =
    .aria-label = Categorias
pane-general-title = Geral
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Redação
category-compose =
    .tooltiptext = Redação
pane-privacy-title = Privacidade e Segurança
category-privacy =
    .tooltiptext = Privacidade e Segurança
pane-chat-title = Conversa
category-chat =
    .tooltiptext = Conversa
pane-calendar-title = Agenda
category-calendar =
    .tooltiptext = Agenda
general-language-and-appearance-header = Idioma e aparência
general-incoming-mail-header = Recebimento de emails
general-files-and-attachment-header = Arquivos e anexos
general-tags-header = Etiquetas
general-reading-and-display-header = Leitura e exibição
general-updates-header = Atualização
general-network-and-diskspace-header = Rede e espaço em disco
general-indexing-label = Indexação
composition-category-header = Redação
composition-attachments-header = Anexos
composition-spelling-title = Ortografia
compose-html-style-title = Estilo HTML
composition-addressing-header = Endereçamento
privacy-main-header = Privacidade
privacy-passwords-header = Senhas
privacy-junk-header = Spam
collection-header = Coleta e uso de dados pelo { -brand-short-name }
collection-description = Nos esforçamos para proporcionar escolhas e coletar somente o necessário para melhorar e fornecer o { -brand-short-name } para todos. Sempre pedimos permissão antes de receber informações pessoais.
collection-privacy-notice = Aviso de privacidade
collection-health-report-telemetry-disabled = Você não está mais permitindo que a { -vendor-short-name } capture dados técnicos e de interação. Todos os dados coletados anteriormente serão apagados em até 30 dias.
collection-health-report-telemetry-disabled-link = Saiba mais
collection-health-report =
    .label = Permitir que o { -brand-short-name } envie dados técnicos e de interação para a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Saiba mais
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = O relatório de dados está desativado nesta configuração
collection-backlogged-crash-reports =
    .label = Permitir que o { -brand-short-name } envie relatos de travamento em seu nome
    .accesskey = v
collection-backlogged-crash-reports-link = Saiba mais
privacy-security-header = Segurança
privacy-scam-detection-title = Detecção de fraudes
privacy-anti-virus-title = Antivírus
privacy-certificates-title = Certificados
chat-pane-header = Conversa
chat-status-title = Status
chat-notifications-title = Notificações
chat-pane-styling-header = Estilos
choose-messenger-language-description = Escolha os idiomas utilizados para mostrar menus, mensagens e notificações do { -brand-short-name }.
manage-messenger-languages-button =
    .label = Definir alternativas…
    .accesskey = l
confirm-messenger-language-change-description = Reiniciar o { -brand-short-name } para aplicar estas alterações
confirm-messenger-language-change-button = Aplicar e reiniciar
update-setting-write-failure-title = Erro ao salvar preferências de atualização
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    O { -brand-short-name } encontrou um erro e não salvou esta alteração. Note que definir esta preferência de atualização requer permissão para escrever no arquivo abaixo. Você ou um administrador do sistema deve conseguir resolver o erro dando ao grupo 'Users' total controle sobre este arquivo.
    
    Não foi possível escrever no arquivo: { $path }
update-in-progress-title = Atualização em andamento
update-in-progress-message = Quer que o { -brand-short-name } continue esta atualização?
update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar
addons-button = Extensões e Temas
account-button = Configurações da conta
open-addons-sidebar-button = Extensões e temas

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para criar uma senha mestra, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = criar uma senha mestra
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para criar uma senha principal, insira suas credenciais de acesso ao Windows. Isso ajuda a proteger a segurança de suas contas.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = criar uma senha principal
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = F
focus-search-shortcut-alt =
    .key = K
general-legend = Página inicial do { -brand-short-name }
start-page-label =
    .label = Ao iniciar o { -brand-short-name }, abrir esta página no painel de mensagens:
    .accesskey = A
location-label =
    .value = Endereço:
    .accesskey = E
restore-default-label =
    .label = Restaurar padrão
    .accesskey = R
default-search-engine = Mecanismo de pesquisa padrão
add-search-engine =
    .label = Adicionar a partir de arquivo
    .accesskey = A
remove-search-engine =
    .label = Remover
    .accesskey = v
minimize-to-tray-label =
    .label = Quando o { -brand-short-name } for minimizado, mover para a bandeja
    .accesskey = m
new-message-arrival = Ao chegarem novas mensagens
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Tocar o arquivo de som:
           *[other] Tocar um som
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] c
        }
mail-play-button =
    .label = Testar
    .accesskey = T
change-dock-icon = Mudar preferências do ícone
app-icon-options =
    .label = Opções do ícone…
    .accesskey = n
notification-settings = Alertas e a notificação sonoras padrão podem ser desativados no Painel de Notificações nas Preferências do Sistema.
animated-alert-label =
    .label = Mostrar um alerta
    .accesskey = M
customize-alert-label =
    .label = Personalizar…
    .accesskey = z
tray-icon-label =
    .label = Exibir ícone na bandeja
    .accesskey = n
biff-use-system-alert =
    .label = Usar a notificação do sistema
tray-icon-unread-label =
    .label = Mostra na bandeja um ícone de mensagens não lidas
    .accesskey = b
tray-icon-unread-description = Recomendado ao usar botões pequenos na barra de tarefas
mail-system-sound-label =
    .label = Som padrão do sistema para novas mensagens
    .accesskey = m
mail-custom-sound-label =
    .label = Usar este arquivo de som:
    .accesskey = U
mail-browse-sound-button =
    .label = Procurar…
    .accesskey = P
enable-gloda-search-label =
    .label = Ativar pesquisa global e indexação
    .accesskey = A
datetime-formatting-legend = Formatação de data e hora
language-selector-legend = Idioma
allow-hw-accel =
    .label = Usar aceleração de hardware quando disponível
    .accesskey = h
store-type-label =
    .value = Tipo de armazenamento de mensagens de contas novas:
    .accesskey = T
mbox-store-label =
    .label = Um arquivo por pasta (mbox)
maildir-store-label =
    .label = Um arquivo por mensagem (maildir)
scrolling-legend = Navegação
autoscroll-label =
    .label = Rolagem automática
    .accesskey = t
smooth-scrolling-label =
    .label = Rolagem suave
    .accesskey = R
system-integration-legend = Integração com o sistema
always-check-default =
    .label = Sempre verificar se o { -brand-short-name } é o aplicativo padrão de email ao iniciar
    .accesskey = S
check-default-button =
    .label = Verificar agora…
    .accesskey = V
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
search-integration-label =
    .label = Permitir que o { search-engine-name } pesquise em mensagens
    .accesskey = P
config-editor-button =
    .label = Editor de configurações…
    .accesskey = E
return-receipts-description = Determinar como o { -brand-short-name } trata confirmações de leitura.
return-receipts-button =
    .label = Confirmações de leitura…
    .accesskey = C
update-app-legend = Atualizações do { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versão { $version }
allow-description = Permitir ao { -brand-short-name }
automatic-updates-label =
    .label = Instalar atualizações automaticamente (recomendado: maior segurança)
    .accesskey = a
check-updates-label =
    .label = Verificar atualizações, mas permitir que eu escolha quando instalá-las
    .accesskey = c
update-history-button =
    .label = Exibir histórico de atualizações
    .accesskey = l
use-service =
    .label = Usar um serviço em segundo plano para instalar atualizações
    .accesskey = s
cross-user-udpate-warning = Esta configuração se aplicará a todas as contas do Windows e perfis do { -brand-short-name } que usam esta instalação do { -brand-short-name }.
networking-legend = Conexão
proxy-config-description = Determine como o { -brand-short-name } conecta-se à internet.
network-settings-button =
    .label = Configurar conexão…
    .accesskey = C
offline-legend = Desconectado
offline-settings = Configurar o modo desconectado
offline-settings-button =
    .label = Desconectado…
    .accesskey = o
diskspace-legend = Espaço em disco
offline-compact-folder =
    .label = Condensar todas as pastas se puder liberar pelo menos
    .accesskey = n
compact-folder-size =
    .value = MB no total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Usar no máximo
    .accesskey = s
use-cache-after = MB de espaço para o cache

##

smart-cache-label =
    .label = Substituir o gerenciamento automático do cache
    .accesskey = u
clear-cache-button =
    .label = Limpar cache agora
    .accesskey = L
fonts-legend = Fontes
default-font-label =
    .value = Fonte padrão:
    .accesskey = F
default-size-label =
    .value = Tam.:
    .accesskey = T
font-options-button =
    .label = Avançado…
    .accesskey = A
color-options-button =
    .label = Cores…
    .accesskey = C
display-width-legend = Mensagens sem formatação
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Representar smileys como imagens
    .accesskey = R
display-text-label = Ao exibir texto citado:
style-label =
    .value = Estilo:
    .accesskey = E
regular-style-item =
    .label = Regular
bold-style-item =
    .label = Negrito
italic-style-item =
    .label = Itálico
bold-italic-style-item =
    .label = Negrito itálico
size-label =
    .value = Tam.:
    .accesskey = T
regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Maior
smaller-size-item =
    .label = Menor
quoted-text-color =
    .label = Cor:
    .accesskey = o
search-input =
    .placeholder = Procurar
search-handler-table =
    .placeholder = Filtrar tipos de conteúdo e ações
type-column-label =
    .label = Tipo de conteúdo
    .accesskey = T
action-column-label =
    .label = Ação
    .accesskey = A
save-to-label =
    .label = Salvar arquivos em:
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Procurar…
           *[other] Procurar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] P
           *[other] P
        }
always-ask-label =
    .label = Sempre perguntar onde salvar arquivos
    .accesskey = e
display-tags-text = Etiquetas podem ser usadas para organizar e priorizar suas mensagens.
new-tag-button =
    .label = Nova…
    .accesskey = N
edit-tag-button =
    .label = Editar…
    .accesskey = E
delete-tag-button =
    .label = Excluir
    .accesskey = x
auto-mark-as-read =
    .label = Marcar automaticamente mensagens como lidas
    .accesskey = M
mark-read-no-delay =
    .label = Ao exibir
    .accesskey = A

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Ao exibir por
    .accesskey = e
seconds-label = segundos

##

open-msg-label =
    .value = Abrir mensagens em:
open-msg-tab =
    .label = Nova aba
    .accesskey = N
open-msg-window =
    .label = Nova janela
    .accesskey = o
open-msg-ex-window =
    .label = Janela existente
    .accesskey = J
close-move-delete =
    .label = Ao mover ou excluir, fechar aba/janela da mensagem
    .accesskey = v
display-name-label =
    .value = Nome de exibição:
condensed-addresses-label =
    .label = Exibir somente o nome de pessoas em meu catálogo de endereços
    .accesskey = s

## Compose Tab

forward-label =
    .value = Encaminhar como:
    .accesskey = h
inline-label =
    .label = Texto na mensagem
as-attachment-label =
    .label = Anexo
extension-label =
    .label = Adic. extensão ao nome do arquivo
    .accesskey = A

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Salvar automaticamente a cada
    .accesskey = S
auto-save-end = minutos

##

warn-on-send-accel-key =
    .label = Confirmar ao usar um atalho do teclado para enviar mensagens
    .accesskey = o
spellcheck-label =
    .label = Verificar ortografia antes de enviar
    .accesskey = e
spellcheck-inline-label =
    .label = Verificar ortografia ao digitar
    .accesskey = V
language-popup-label =
    .value = Idioma:
    .accesskey = I
download-dictionaries-link = Mais dicionários
font-label =
    .value = Fonte:
    .accesskey = F
font-size-label =
    .value = Tamanho:
    .accesskey = m
default-colors-label =
    .label = Usar cores padrão do leitor
    .accesskey = d
font-color-label =
    .value = Cor do texto:
    .accesskey = C
bg-color-label =
    .value = Cor de fundo:
    .accesskey = u
restore-html-label =
    .label = Restaurar padrão
    .accesskey = R
default-format-label =
    .label = Usar formato de parágrafo em vez do corpo do texto por padrão
    .accesskey = P
format-description = Configurar comportamento de formatação de texto
send-options-label =
    .label = Opções de envio…
    .accesskey = m
autocomplete-description = Ao endereçar mensagens, procurar por contatos em:
ab-label =
    .label = Catálogos de endereços locais
    .accesskey = C
directories-label =
    .label = Servidor de diretório:
    .accesskey = S
directories-none-label =
    .none = Nenhum
edit-directories-label =
    .label = Editar diretórios…
    .accesskey = E
email-picker-label =
    .label = Adicionar automaticamente endereços de email de destinatários ao meu:
    .accesskey = A
default-directory-label =
    .value = Lista padrão ao abrir a janela do catálogo de endereços:
    .accesskey = P
default-last-label =
    .none = Último diretório usado
attachment-label =
    .label = Detectar ausência de anexos
    .accesskey = D
attachment-options-label =
    .label = Palavras-chave…
    .accesskey = P
enable-cloud-share =
    .label = Oferecer compartilhamento para arquivos maiores que
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Adicionar…
    .accesskey = A
    .defaultlabel = Adicionar…
remove-cloud-account =
    .label = Remover
    .accesskey = R
find-cloud-providers =
    .value = Procurar mais provedores…
cloud-account-description = Adicionar um serviço de armazenamento de anexos online

## Privacy Tab

mail-content = Conteúdo do email
remote-content-label =
    .label = Permitir conteúdo remoto nas mensagens
    .accesskey = m
exceptions-button =
    .label = Exceções…
    .accesskey = E
remote-content-info =
    .value = Saiba mais sobre os problemas de privacidade de conteúdo remoto
web-content = Conteúdo da web
history-label =
    .label = Lembrar sites e links que eu visitei
    .accesskey = r
cookies-label =
    .label = Aceitar cookies de sites
    .accesskey = A
third-party-label =
    .value = Aceitar cookies de terceiros:
    .accesskey = c
third-party-always =
    .label = Sempre
third-party-never =
    .label = Nunca
third-party-visited =
    .label = De sites visitados
keep-label =
    .value = Manter até:
    .accesskey = a
keep-expire =
    .label = eles expiram
keep-close =
    .label = eu feche o { -brand-short-name }
keep-ask =
    .label = perguntar todas as vezes
cookies-button =
    .label = Mostrar cookies…
    .accesskey = M
do-not-track-label =
    .label = Enviar aos sites um sinal “Não rastrear” indicando que você não quer ser rastreado
    .accesskey = n
learn-button =
    .label = Saiba mais
passwords-description = O { -brand-short-name } pode memorizar nomes de usuário e senhas de todas as suas contas.
passwords-button =
    .label = Senhas memorizadas…
    .accesskey = S
master-password-description = A senha mestra protege todas as suas senhas — mas você deve fornecê-la uma vez por sessão.
master-password-label =
    .label = Usar uma senha mestra
    .accesskey = U
master-password-button =
    .label = Alterar senha mestra…
    .accesskey = A
primary-password-description = Uma senha principal protege todas as suas senhas, mas você deve digitá-la uma vez por sessão.
primary-password-label =
    .label = Usar uma senha principal
    .accesskey = U
primary-password-button =
    .label = Alterar senha principal…
    .accesskey = A
forms-primary-pw-fips-title = Você está no momento no modo FIPS. O modo FIPS exige uma senha principal não vazia.
forms-master-pw-fips-desc = Falha na alteração da senha
junk-description = Defina suas configurações padrão para spam. Opções específicas para cada conta podem ser definidas em “Configurar contas”.
junk-label =
    .label = Ao marcar mensagens como spam:
    .accesskey = A
junk-move-label =
    .label = Movê-las para a pasta “Spam” da conta
    .accesskey = o
junk-delete-label =
    .label = Excluí-las
    .accesskey = x
junk-read-label =
    .label = Marcar como lidas as mensagens definidas como spam
    .accesskey = M
junk-log-label =
    .label = Registrar as atividades do filtro antispam adaptativo
    .accesskey = R
junk-log-button =
    .label = Exibir log
    .accesskey = E
reset-junk-button =
    .label = Excluir o treinamento
    .accesskey = c
phishing-description = O { -brand-short-name } pode verificar se mensagens são possíveis fraudes (também conhecidas como phishing scams), detectando as técnicas de falsificação mais comuns.
phishing-label =
    .label = Alertar se a mensagem exibida for um possível golpe
    .accesskey = A
antivirus-description = O { -brand-short-name } pode facilitar a análise de novas mensagens por antivírus antes que elas sejam armazenadas localmente.
antivirus-label =
    .label = Aplicativos antivírus podem colocar uma mensagem recebida em quarentena
    .accesskey = A
certificate-description = Quando um servidor solicitar meu certificado pessoal:
certificate-auto =
    .label = Selecionar um automaticamente
    .accesskey = S
certificate-ask =
    .label = Perguntar quando necessário
    .accesskey = A
ocsp-label =
    .label = Consultar servidores OCSP para confirmar a validade atual dos certificados
    .accesskey = C
certificate-button =
    .label = Gerenciar certificados…
    .accesskey = G
security-devices-button =
    .label = Dispositivos de segurança…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Ao iniciar o { -brand-short-name }:
    .accesskey = o
offline-label =
    .label = Manter minhas contas de conversa desconectadas
auto-connect-label =
    .label = Conectar minhas contas de conversa automaticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Notificar aos meus contatos que estou Inativo após
    .accesskey = N
idle-time-label = minutos de inatividade

##

away-message-label =
    .label = e definir meu status como Ausente com esta mensagem de status:
    .accesskey = A
send-typing-label =
    .label = Enviar notificações de digitação durante conversas
    .accesskey = E
notification-label = Quando as mensagens dirigidas a você chegarem:
show-notification-label =
    .label = Mostrar notificações
    .accesskey = c
notification-all =
    .label = com nome do destinatário e prévia da mensagem
notification-name =
    .label = com o nome do remetente apenas
notification-empty =
    .label = sem qualquer informação
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animar o ícone da dock
           *[other] Piscar o item da barra de tarefas
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] f
        }
chat-play-sound-label =
    .label = Reproduzir um som
    .accesskey = d
chat-play-button =
    .label = Reproduzir
    .accesskey = p
chat-system-sound-label =
    .label = Som padrão do sistema para novas mensagens
    .accesskey = S
chat-custom-sound-label =
    .label = Usar este arquivo de som:
    .accesskey = U
chat-browse-sound-button =
    .label = Procurar…
    .accesskey = P
theme-label =
    .value = Tema:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bolhas
style-dark =
    .label = Escuro
style-paper =
    .label = Folhas de papel
style-simple =
    .label = Simples
preview-label = Visualizar:
no-preview-label = Nenhuma visualização disponível
no-preview-description = Este tema não é válido ou está atualmente indisponível (extensão desativada, modo de segurança, …).
chat-variant-label =
    .value = Variante:
    .accesskey = V
chat-header-label =
    .label = Exibir cabeçalho
    .accesskey = C
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 16.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Procurar em opções
           *[other] Procurar em preferências
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 16.4em
    .placeholder = Procurar em preferências

## Preferences UI Search Results

search-results-header = Resultados da pesquisa
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Desculpe, “<span data-l10n-name="query"></span>” não foi encontrado nas opções.
       *[other] Desculpe, “<span data-l10n-name="query"></span>” não foi encontrado nas preferências.
    }
search-results-help-link = Precisa de ajuda? Visite o <a data-l10n-name="url">suporte do { -brand-short-name }</a>
