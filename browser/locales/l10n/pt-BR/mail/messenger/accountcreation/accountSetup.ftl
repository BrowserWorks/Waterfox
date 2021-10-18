# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Configuração de conta

## Header

account-setup-title = Configure com seu endereço de email existente
account-setup-description = Para usar seu endereço de email atual, preencha suas credenciais.
account-setup-secondary-description = O { -brand-product-name } procura automaticamente uma configuração de servidor recomendada que esteja funcionando.
account-setup-success-title = Conta criada com sucesso
account-setup-success-description = Agora você pode usar esta conta no { -brand-short-name }.
account-setup-success-secondary-description = Você pode melhorar a experiência de uso conectando serviços relacionados e configurando preferências avançadas de contas.

## Form fields

account-setup-name-label = Seu nome completo
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Fulano
account-setup-name-info-icon =
    .title = Seu nome, como será mostrado aos outros
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = Endereço de email
    .accesskey = E
account-setup-email-input =
    .placeholder = fulano@example.com
account-setup-email-info-icon =
    .title = Seu endereço de email existente
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Senha
    .accesskey = S
    .title = Opcional, será usada apenas para validar o nome de usuário
account-provisioner-button = Obter um novo endereço de email
    .accesskey = O
account-setup-password-toggle =
    .title = Exibir/ocultar senha
account-setup-password-toggle-show =
    .title = Exibir senha
account-setup-password-toggle-hide =
    .title = Ocultar senha
account-setup-remember-password = Memorizar senha
    .accesskey = M
account-setup-exchange-label = Sua conta
    .accesskey = c
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = SEUDOMÍNIO\seunomedeusuário
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Conta no domínio

## Action buttons

account-setup-button-cancel = Cancelar
    .accesskey = a
account-setup-button-manual-config = Configurar manualmente
    .accesskey = m
account-setup-button-stop = Interromper
    .accesskey = I
account-setup-button-retest = Testar novamente
    .accesskey = T
account-setup-button-continue = Continuar
    .accesskey = C
account-setup-button-done = Pronto
    .accesskey = P

## Notifications

account-setup-looking-up-settings = Procurando configuração…
account-setup-looking-up-settings-guess = Procurando configuração: Experimentando nomes de servidor comuns…
account-setup-looking-up-settings-half-manual = Procurando configuração: Examinando servidor…
account-setup-looking-up-disk = Procurando configuração: Instalação do { -brand-short-name }…
account-setup-looking-up-isp = Procurando configuração: Provedor de email…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Procurando configuração: Base de dados da Waterfox de provedores de internet…
account-setup-looking-up-mx = Procurando configuração: Domínio de recebimento de email…
account-setup-looking-up-exchange = Procurando configuração: Servidor Exchange…
account-setup-checking-password = Verificando a senha…
account-setup-installing-addon = Baixando e instalando extensão…
account-setup-success-half-manual = As seguintes configurações foram encontradas ao examinar o servidor indicado:
account-setup-success-guess = Configuração encontrada ao experimentar nomes de servidor comuns.
account-setup-success-guess-offline = Você está desconectado. Estimamos algumas configurações, mas você precisa inserir as configurações corretas.
account-setup-success-password = A senha está correta
account-setup-success-addon = A extensão foi instalada com sucesso
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Configuração encontrada na base de dados da Waterfox de provedores de internet.
account-setup-success-settings-disk = Configuração encontrada na instalação do { -brand-short-name }.
account-setup-success-settings-isp = Configuração encontrada no provedor de email.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Encontrada configuração de um servidor Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Configuração inicial
account-setup-step2-image =
    .title = Carregando…
account-setup-step3-image =
    .title = Configuração encontrada
account-setup-step4-image =
    .title = Erro de conexão
account-setup-step5-image =
    .title = Conta criada
account-setup-privacy-footnote2 = Suas credenciais só são armazenadas localmente em seu computador.
account-setup-selection-help = Não tem certeza do que selecionar?
account-setup-selection-error = Precisa de ajuda?
account-setup-success-help = Não tem certeza do que fazer a seguir?
account-setup-documentation-help = Documentação de configuração
account-setup-forum-help = Fórum de suporte
account-setup-privacy-help = Política de privacidade
account-setup-getting-started = Introdução

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Configuração disponível
       *[other] Configurações disponíveis
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Mantém suas pastas e emails sincronizados em seu servidor
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Mantém suas pastas e emails em seu computador
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Usar servidor Microsoft Exchange ou serviços na nuvem do Office365
account-setup-incoming-title = Recebimento
account-setup-outgoing-title = Envio
account-setup-username-title = Nome de usuário
account-setup-exchange-title = Servidor
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Sem criptografia
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Usar um servidor de envio SMTP já existente
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Recebimento: { $incoming }, Envio: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Falha na autenticação. As credenciais informadas estão incorretas ou outro nome de usuário é necessário para acessar a conta. Este nome de usuário geralmente é a conta no domínio do Windows, com ou sem o prefixo do domínio (por exemplo, alice ou AD\\alice)
account-setup-credentials-wrong = Falha na autenticação. Verifique o nome de usuário e a senha
account-setup-find-settings-failed = O { -brand-short-name } não conseguiu encontrar as configurações de sua conta de email
account-setup-exchange-config-unverifiable = A configuração não pôde ser verificada. Se o nome de usuário e a senha estão corretos, é provável que o administrador do servidor tenha desativado a configuração selecionada em sua conta. Experimente selecionando outro protocolo.
account-setup-provisioner-error = Ocorreu um erro ao configurar sua nova conta no { -brand-short-name }. Tente configurar a conta manualmente usando suas credenciais.

## Manual configuration area

account-setup-manual-config-title = Configurações do servidor
account-setup-incoming-server-legend = Servidor de recebimento
account-setup-protocol-label = Protocolo:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Servidor:
account-setup-port-label = Porta:
    .title = Defina o número da porta como 0 para detecção automática
account-setup-auto-description = O { -brand-short-name } tentará detectar automaticamente os campos deixados vazios.
account-setup-ssl-label = Segurança da conexão:
account-setup-outgoing-server-legend = Servidores de envio

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Detectar automaticamente
ssl-no-authentication-option = Sem autenticação
ssl-cleartext-password-option = Senha normal
ssl-encrypted-password-option = Senha criptografada

## Incoming/Outgoing SSL options

ssl-noencryption-option = Nenhum
account-setup-auth-label = Método de autenticação:
account-setup-username-label = Nome de usuário:
account-setup-advanced-setup-button = Configuração avançada
    .accesskey = v

## Warning insecure server dialog

account-setup-insecure-title = Aviso!
account-setup-insecure-incoming-title = Configuração de recebimento:
account-setup-insecure-outgoing-title = Configuração de envio:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> não usa criptografia.
account-setup-warning-cleartext-details = Servidores não seguros de email não usam conexões criptografadas para proteger suas senhas e informações privativas. Ao se conectar a este servidor, você pode expor essas informações.
account-setup-insecure-server-checkbox = Eu entendo os riscos
    .accesskey = E
account-setup-insecure-description = O { -brand-short-name } pode permitir configurar seu email usando as definições fornecidas. Entretanto, você deve entrar em contato com seu administrador ou provedor de email para falar a respeito dessas conexões impróprias. Veja mais informações nas <a data-l10n-name="thunderbird-faq-link">perguntas frequentes do Thunderbird</a>.
insecure-dialog-cancel-button = Alterar configurações
    .accesskey = A
insecure-dialog-confirm-button = Confirmar
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = O { -brand-short-name } encontrou informações de configuração da sua conta em { $domain }. Quer continuar e enviar suas credenciais?
exchange-dialog-confirm-button = Entrar
exchange-dialog-cancel-button = Cancelar

## Dismiss account creation dialog

exit-dialog-title = Nenhuma conta de email configurada
exit-dialog-description = Tem certeza que quer cancelar o processo de configuração? O { -brand-short-name } ainda pode ser usado sem nenhuma conta de email, mas muitos recursos não estarão disponíveis.
account-setup-no-account-checkbox = Usar o { -brand-short-name } sem contas de email
    .accesskey = U
exit-dialog-cancel-button = Continuar a configuração
    .accesskey = C
exit-dialog-confirm-button = Sair da configuração
    .accesskey = S

## Alert dialogs

account-setup-creation-error-title = Erro ao criar conta
account-setup-error-server-exists = O servidor de recebimento já existe.
account-setup-confirm-advanced-title = Confirmar configuração avançada
account-setup-confirm-advanced-description = Este diálogo será fechado e será criada uma conta com a configuração atual, mesmo se a configuração estiver incorreta. Quer continuar?

## Addon installation section

account-setup-addon-install-title = Instalar
account-setup-addon-install-intro = Uma extensão de terceiros pode permitir que você acesse sua conta de email neste servidor:
account-setup-addon-no-protocol = Este servidor de email infelizmente não oferece suporte a protocolos abertos. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Configurações da conta
account-setup-encryption-button = Criptografia de ponta a ponta
account-setup-signature-button = Adicionar uma assinatura
account-setup-dictionaries-button = Baixar dicionários
account-setup-address-book-carddav-button = Conectar a um catálogo de endereços CardDAV
account-setup-address-book-ldap-button = Conectar a um catálogo de endereços LDAP
account-setup-calendar-button = Conectar a uma agenda remota
account-setup-linked-services-title = Conectar seus serviços vinculados
account-setup-linked-services-description = O { -brand-short-name } detectou outros serviços vinculados à sua conta de email.
account-setup-no-linked-description = Configure outros serviços para aproveitar ao máximo sua experiência de uso no { -brand-short-name }.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] O { -brand-short-name } encontrou um catálogo de endereços vinculado à sua conta de email.
       *[other] O { -brand-short-name } encontrou { $count } catálogos de endereços vinculados à sua conta de email.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] O { -brand-short-name } encontrou uma agenda vinculada à sua conta de email.
       *[other] O { -brand-short-name } encontrou { $count } agendas vinculadas à sua conta de email.
    }
account-setup-button-finish = Concluir
    .accesskey = C
account-setup-looking-up-address-books = Procurando catálogos de endereços…
account-setup-looking-up-calendars = Procurando agendas…
account-setup-address-books-button = Catálogos de endereços
account-setup-calendars-button = Agendas
account-setup-connect-link = Conectar
account-setup-existing-address-book = Conectado
    .title = Catálogo de endereços já conectado
account-setup-existing-calendar = Conectado
    .title = Agenda já conectada
account-setup-connect-all-calendars = Conectar todas as agendas
account-setup-connect-all-address-books = Conectar todos os catálogos de endereços

## Calendar synchronization dialog

calendar-dialog-title = Conectar agenda
calendar-dialog-cancel-button = Cancelar
    .accesskey = C
calendar-dialog-confirm-button = Conectar
    .accesskey = n
account-setup-calendar-name-label = Nome
account-setup-calendar-name-input =
    .placeholder = Minha agenda
account-setup-calendar-color-label = Cor
account-setup-calendar-refresh-label = Atualizar
account-setup-calendar-refresh-manual = Manualmente
account-setup-calendar-refresh-interval =
    { $count ->
        [one] A cada minuto
       *[other] A cada { $count } minutos
    }
account-setup-calendar-read-only = Somente leitura
    .accesskey = l
account-setup-calendar-show-reminders = Exibir lembretes
    .accesskey = E
account-setup-calendar-offline-support = Suporte offline
    .accesskey = o
