# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Defina as políticas que as WebExtensions podem aceder via chrome.storage.managed.

policy-AppAutoUpdate = Ativar ou desativar as atualizações automáticas da aplicação.

policy-AppUpdateURL = Definir um endereço personalizado para a atualização da aplicação.

policy-Authentication = Configurar autenticação integrada para sites que a suportem.

policy-BlockAboutAddons = Bloquear o acesso ao Gestor de extras (about:addons).

policy-BlockAboutConfig = Bloquear o acesso à página about:config.

policy-BlockAboutProfiles = Bloquear o acesso à página about:profiles.

policy-BlockAboutSupport = Bloquear o acesso à página about:support.

policy-CaptivePortal = Ativar ou desativar o suporte ao portal cativo.

policy-CertificatesDescription = Adicionar certificados ou usar certificados internos.

policy-Cookies = Permitir ou impedir que sites definam cookies.

policy-DisabledCiphers = Desativar cifras.

policy-DefaultDownloadDirectory = Definir a pasta de transferências predefinida.

policy-DisableAppUpdate = Impedir que o { -brand-short-name } seja atualizado.

policy-DisableDefaultClientAgent = Impedir que o agente do cliente predefinido execute qualquer ação. Aplicável apenas ao Windows; as outras plataformas não dispõem deste agente.

policy-DisableDeveloperTools = Bloquear o acesso às ferramentas do programador.

policy-DisableFeedbackCommands = Desativar comandos para enviar comentários a partir do menu de Ajuda (enviar feedback e reportar sites fraudulentos)

policy-DisableForgetButton = Impedir o acesso ao botão Esquecer.

policy-DisableFormHistory = Não guardar histórico de pesquisas ou de formulários.

policy-DisableMasterPasswordCreation = Se verdadeiro, a palavra-passe mestra não pode ser criada.

policy-DisablePasswordReveal = Impedir que as palavras-passe sejam reveladas nas credenciais guardadas.

policy-DisableProfileImport = Desativar o comando do menu para importar dados de outra aplicação.

policy-DisableSafeMode = Desativar a funcionalidade de reiniciar no Modo de segurança. Nota: o botão Shift para entrar no Modo de segurança apenas pode ser desativado no Windows utilizando Política de grupo.

policy-DisableSecurityBypass = Impedir o utilizador de contornar certos avisos de segurança.

policy-DisableSystemAddonUpdate = Impedir o { -brand-short-name } de instalar e atualizar extras de sistema.

policy-DisableTelemetry = Desativar a Telemetria.

policy-DisplayMenuBar = Mostrar a Barra de menu por predefinição.

policy-DNSOverHTTPS = Configurar DNS por HTTPS.

policy-DontCheckDefaultClient = Desativar a verificação do cliente predefinido na inicialização.

policy-DownloadDirectory = Definir e bloquear o diretório de transferências predefinido.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Ativar ou desativar o bloqueio de conteúdo e bloqueá-lo de forma opcional.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Ativar ou desativar as Extensões de multimédia encriptada e, opcionalmente, bloquear esta definição.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar ou bloquear extensões. A opção Instalar utiliza endereços ou caminhos como parâmetros. As opções Desinstalar e Bloquear utilizam identificadores de extensões.

policy-ExtensionSettings = Gerir todos os aspetos da instalação de extensões.

policy-ExtensionUpdate = Ativar ou desativar atualizações automáticas de extensões.

policy-HardwareAcceleration = Se falso, desligar aceleração por hardware.

policy-InstallAddonsPermission = Permitir a instalação de extras a determinados sites.

policy-LegacyProfiles = Desativar a funcionalidade de forçar um perfil separado para cada instalação.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Ativar a definição legada de comportamento predefinido para a cookie SameSite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Reverter para o comportamento legado de SameSite para as cookies nos sites especificados.

##

policy-LocalFileLinks = Permitir que determinados sites estabeleçam ligações a ficheiros locais.

policy-NetworkPrediction = Ativar ou desativar a previsão de rede (pré-obtenção de DNS).

policy-OfferToSaveLogins = Forçar a definição para permitir que { -brand-short-name } se ofereça para memorizar as credenciais e as palavras-passe guardadas. São aceites ambos os valores, "true" e "false".

policy-OfferToSaveLoginsDefault = Definir o valor predefinido para permitir que o { -brand-short-name } sugira credenciais e palavras-passe guardadas. São aceites ambos os valores, true e false.

policy-OverrideFirstRunPage = Substituir a página de primeira execução. Defina esta política para blank se pretende desativar a página de primeira execução.

policy-OverridePostUpdatePage = Sobrepor a página "Novidades" após uma atualização. Defina esta política para blank se pretende desativar a página pós-atualização.

policy-PasswordManagerEnabled = Ativar a opção de guardar as palavras-passe no gestor de palavras-passe.

# PDF.js and PDF should not be translated
policy-PDFjs = Desativar ou configurar o PDF.js, o visualizador integrado de PDF do { -brand-short-name }.

policy-Permissions2 = Configurar as permissões para a câmara, microfone, localização, notificações e reprodução automática.

policy-Preferences = Definir e bloquear o valor para um subconjunto de preferências.

policy-PromptForDownloadLocation = Perguntar onde guardar os ficheiros ao transferir.

policy-Proxy = Configurar as definições de proxy.

policy-RequestedLocales = Definir a lista de idiomas solicitados para a aplicação por ordem de preferência.

policy-SanitizeOnShutdown2 = Limpar dados de navegação ao desligar.

policy-SearchEngines = Configurar as definições do motor de pesquisa. Esta política apenas está disponível na versão de suporte estendido (Extended Support Release - ESR).

policy-SearchSuggestEnabled = Ativar ou desativar sugestões de pesquisa.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar os módulos PKCS #11.

policy-SSLVersionMax = Definir a versão máxima de SSL.

policy-SSLVersionMin = Definir a versão mínima de SSL.

policy-SupportMenu = Adicionar um item de menu de apoio personalizado ao menu de ajuda.

policy-UserMessaging = Não mostrar determinadas mensagens ao utilizador.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Impedir que sites sejam visitados. Consulte a documentação para mais detalhes sobre o formato.
