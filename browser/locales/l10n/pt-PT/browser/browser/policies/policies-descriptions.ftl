# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Definir políticas que WebExtensions podem aceder via chrome.storage.managed.

policy-AllowedDomainsForApps = Definir os domínios com permissão para aceder ao Google Workspace.

policy-AppAutoUpdate = Ativar ou desativar atualizações automáticas de aplicações.

policy-AppUpdateURL = Definir um URL personalizado de atualização da aplicação.

policy-Authentication = Configurar autenticação integrada para os sites que a suportem.

policy-AutoLaunchProtocolsFromOrigins = Define uma lista de protocolos externos que podem ser utilizados a partir de origens listadas, sem avisar o utilizador.

policy-BackgroundAppUpdate2 = Ativar ou desativar o serviço de atualização em segundo plano.

policy-BlockAboutAddons = Bloquear acesso ao Gestor de extras (about:addons).

policy-BlockAboutConfig = Bloquear acesso  à página about:config.

policy-BlockAboutProfiles = Bloquear acesso  à página about:profiles.

policy-BlockAboutSupport = Bloquear acesso  à página about:support.

policy-Bookmarks = Criar marcadores na barra de ferramentas de marcadores, menus de marcadores ou uma pasta especificada dentro dos mesmos.

policy-CaptivePortal = Ativar ou desativar o suporte ao portal cativo.

policy-CertificatesDescription = Adicionar certificados ou utilizar certificados integrados.

policy-Cookies = Permitir ou negar que os sites definam cookies.

policy-DisabledCiphers = Desativar cifras.

policy-DefaultDownloadDirectory = Definir o diretório de transferências predefinido.

policy-DisableAppUpdate = Impedir o navegador de ser atualizado.

policy-DisableBuiltinPDFViewer = Desativar o PDF.js, o leitor de PDF incorporado no { -brand-short-name }.

policy-DisableDefaultBrowserAgent = Impedir que o agente do navegador predefinido execute qualquer ação. Aplicável apenas ao Windows; as outras plataformas não dispõem deste agente.

policy-DisableDeveloperTools = Bloquear acesso às ferramentas de programador.

policy-DisableFeedbackCommands = Desativar comandos para enviar comentários a partir do menu de Ajuda (enviar feedback e reportar sites fraudulentos)

policy-DisableWaterfoxAccounts = Desativar os serviços baseados na { -fxaccount-brand-name }, incluindo o Sync.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = Desativar a funcionalidade Waterfox Screenshots.

policy-DisableWaterfoxStudies = Impedir o { -brand-short-name } de executar estudos.

policy-DisableForgetButton = Impedir o acesso ao botão Esquecer.

policy-DisableFormHistory = Não guardar histórico de pesquisas ou de formulários.

policy-DisablePrimaryPasswordCreation = Se verdadeiro, não poderá ser criada uma palavra-passe principal.

policy-DisablePasswordReveal = Impedir que as palavras-passe sejam reveladas nas credenciais guardadas.

policy-DisablePocket = Desativar a funcionalidade de guardar páginas web no Pocket.

policy-DisablePrivateBrowsing = Desativar a Navegação privada.

policy-DisableProfileImport = Desativar o menu de comando para importar dados de outro navegador.

policy-DisableProfileRefresh = Desativar o botão Restaurar { -brand-short-name } na página about:support.

policy-DisableSafeMode = Desativar a funcionalidade de reiniciar no Modo de segurança. Nota: o botão Shift para entrar no Modo de segurança apenas pode ser desativado no Windows utilizando Política de grupo.

policy-DisableSecurityBypass = Impedir o utilizador de contornar certos avisos de segurança.

policy-DisableSetAsDesktopBackground = Desativar o comando de menu Definir como fundo do ambiente de trabalho para imagens.

policy-DisableSystemAddonUpdate = Impedir o navegador de instalar e atualizar extras de sistema.

policy-DisableTelemetry = Desligar a Telemetria.

policy-DisplayBookmarksToolbar = Mostrar a Barra ferramentas de marcadores por predefinição.

policy-DisplayMenuBar = Mostrar a Barra de menu por predefinição.

policy-DNSOverHTTPS = Configurar DNS por HTTPS.

policy-DontCheckDefaultBrowser = Desativar verificação por navegador predefinido no arranque.

policy-DownloadDirectory = Definir e bloquear o diretório de transferências predefinido.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Ativar ou desativar o Bloqueio de conteúdo e bloqueá-lo opcionalmente.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Ativar ou desativar as Extensões de multimédia encriptada e, opcionalmente, bloquear esta definição.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar ou bloquear extensões. A opção Instalar usa URLs ou caminhos como parâmetros. As opções Desinstalar e Bloquear usam IDs de extensões.

policy-ExtensionSettings = Gerir todos os aspetos de instalação de extensões.

policy-ExtensionUpdate = Ativar ou desativar atualizações automáticas de extensões.

policy-WaterfoxHome = Configurar o Waterfox Home.

policy-FlashPlugin = Permitir ou negar a utilização do plugin Flash.

policy-Handlers = Configurar as aplicações operadoras predefinidas.

policy-HardwareAcceleration = Se falso, desligar aceleração de hardware.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Definir e bloquear opcionalmente a página inicial.

policy-InstallAddonsPermission = Permitir a instalação de extras a determinados sites.

policy-LegacyProfiles = Desativar a funcionalidade de forçar um perfil separado para cada instalação

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Ative a definição legada de comportamento predefinido para a cookie SameSite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Reverta para o comportamento legado de SameSite para as cookies nos sites especificados.

##

policy-LocalFileLinks = Permitir que determinados sites estabeleçam ligações a ficheiros locais.

policy-ManagedBookmarks = Configura uma lista de marcadores geridos por um administrador que não podem ser alterados pelo utilizador.

policy-ManualAppUpdateOnly = Permitir apenas atualizações manuais e não notificar o utilizador sobre atualizações.

policy-PrimaryPassword = Exigir ou impedir a utilização de uma palavra-passe principal.

policy-NetworkPrediction = Ativar ou desativar a previsão de rede (pré-obtenção de DNS).

policy-NewTabPage = Ativar ou desativar a página de novo separador.

policy-NoDefaultBookmarks = Desativar a criação de marcadores predefinidos empacotados com o { -brand-short-name }, e os Marcadores inteligentes (Mais visitados, Etiquetas recentes). Nota: esta política é apenas eficaz se utilizada antes da primeira execução do perfil.

policy-OfferToSaveLogins = Forçar a definição para permitir que { -brand-short-name } se ofereça para memorizar as credenciais e as palavras-passe guardadas. São aceites ambos os valores, "true" e "false".

policy-OfferToSaveLoginsDefault = Defina o valor predefinido para permitir que o { -brand-short-name } sugira credenciais e palavras-passe guardadas. São aceites ambos os valores, true e false.

policy-OverrideFirstRunPage = Sobrepor a página de primeira execução. Defina esta política para blank se pretende desativar a página de primeira execução.

policy-OverridePostUpdatePage = Sobrepor a página "Novidades" pós-atualização. Defina esta política para blank se pretende desativar a página pós-atualização.

policy-PasswordManagerEnabled = Ativar a opção de guardar as palavras-passe no gestor de palavras-passe.

# PDF.js and PDF should not be translated
policy-PDFjs = Desativar ou configurar o PDF.js, o visualizador integrado de PDF do { -brand-short-name }.

policy-Permissions2 = Configurar as permissões para a câmara, microfone, localização, notificações e reprodução automática.

policy-PictureInPicture = Ativar ou desativar o vídeo em janela flutuante.

policy-PopupBlocking = Permitir que determinados sites mostrem pop-ups por predefinição.

policy-Preferences = Definir e bloquear o valor para um subconjunto de preferências.

policy-PromptForDownloadLocation = Perguntar onde guardar os ficheiros durante a transferência.

policy-Proxy = Configurar definições proxy.

policy-RequestedLocales = Definir a lista de idiomas solicitados para a aplicação por ordem de preferência.

policy-SanitizeOnShutdown2 = Limpar dados de navegação ao desligar.

policy-SearchBar = Definir a localização predefinida da barra de pesquisa. O utilizador ainda tem permissão para a personalizar.

policy-SearchEngines = Configurar as definições de motor de pesquisa. Esta política é apenas disponível na versão Extended Support Release (ESR).

policy-SearchSuggestEnabled = Ativar ou desativar sugestões de pesquisa.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar módulos PKCS #11.

policy-ShowHomeButton = Mostrar o botão início na barra de ferramentas.

policy-SSLVersionMax = Definir a versão máxima de SSL.

policy-SSLVersionMin = Definir a versão mínima de SSL.

policy-SupportMenu = Adicionar um item de menu de suporte personalizado ao menu de ajuda.

policy-UserMessaging = Não mostrar determinadas mensagens ao utilizador.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Impedir que sites sejam visitados. Consulte a documentação para mais detalhes sobre o formato.

policy-Windows10SSO = Permitir a autenticação única para contas da Microsoft, trabalho e escola.
