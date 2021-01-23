# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Definir politicas que WebExtensions pote acceder via chrome.storage.managed.

policy-AppAutoUpdate = Activar o disactivar actualisationes automatic del applicationes.

policy-AppUpdateURL = Definir un URL de actualisation personalisate pro le application.

policy-Authentication = Configurar authentication integrate pro sitos web que lo supporta.

policy-BlockAboutAddons = Blocar accesso al Gestor de additivos (circa:additivos).

policy-BlockAboutConfig = Blocar accesso al pagina about:config.

policy-BlockAboutProfiles = Blocar accesso al pagina about:profiles.

policy-BlockAboutSupport = Blocar accesso al pagina about:support.

policy-CaptivePortal = Activar o disactivar supporto pro portal captive.

policy-CertificatesDescription = Adde certificatos o usa certificatos integrate.

policy-Cookies = Permitter o refusar al sitos web de deponer cookies.

policy-DisabledCiphers = Disactivar cryptographias.

policy-DefaultDownloadDirectory = Selige le directorio predefinite pro discargamentos.

policy-DisableAppUpdate = Impedir a { -brand-short-name } de actualisar.

policy-DisableDefaultClientAgent = Impedir al application agente predefinite de interprender ulle actiones. Applicabile solo a Windows; altere systemas operative non ha le agente.

policy-DisableDeveloperTools = Blocar le accesso al instrumentos del disveloppamento.

policy-DisableFeedbackCommands = Disactivar le commandos pro inviar opinion ab le menu Adjuta ("Inviar opinion" e "Denunciar un sito fraudulente").

policy-DisableForgetButton = Impedir accesso al button Oblidar.

policy-DisableFormHistory = Non rememorar le chronologia de recercas e formularios.

policy-DisableMasterPasswordCreation = Si ver, non pote esser create un contrasigno maestro.

policy-DisablePasswordReveal = Non permitter de monstrar le contrasignos in le credentiales salvate.

policy-DisableProfileImport = Disactivar le commando del menu pro importar datos ab un altere application.

policy-DisableSafeMode = Disactivar le functionalitate pro reinitiar in Modo secur. Nota: le clave Shift pro inserer le Modo secur pote solmente esser disactivate sur Windows per le politicas de gruppo.

policy-DisableSecurityBypass = Impedir al usator de ignorar certe avisos de securitate.

policy-DisableSystemAddonUpdate = Impedir a { -brand-short-name } de installar e actualisar additivos de systema.

policy-DisableTelemetry = Disactivar le telemetria.

policy-DisplayMenuBar = Monstrar le barra de menu per predefinition.

policy-DNSOverHTTPS = Configurar DNS sur HTTPS.

policy-DontCheckDefaultClient = Disactivar le verification de cliente predefinite al initio.

policy-DownloadDirectory = Configurar e blocar le plica del discargas.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activar o disactivar le blocage de contento e optionalmente serrar lo.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activar o disactivar le extensiones cifrate de medios e optionalmente blocar los.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installar, disinstallar o blocar le extensiones. Le option Installar require URLs o percursos como parametros. Le optiones Disinstallar e Blocate require le extension IDs.

policy-ExtensionSettings = Gerer tote le aspectos del installation de extensiones.

policy-ExtensionUpdate = Activar o disactivar le actualisation automatic de extensiones.

policy-HardwareAcceleration = Si false, disactivar le acceleration hardware.

policy-InstallAddonsPermission = Permitter a certe sitos web de installar additivos.

policy-LegacyProfiles = Disactivar le function que fortia le creation de un profilo separate pro cata installation.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar parametro pro usar como predefinite le comportamento ancian del attributo SameSite pro le cookies.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Reverter a comportamento ancian de SameSite pro cookies sur sitos specific.

##

policy-LocalFileLinks = Permitter a sitos web specific de ligar a files local.

policy-NetworkPrediction = Activar o disactivar prediction del rete (prelectura del DNS).

policy-OfferToSaveLogins = Fortiar que le parametro permitte a { -brand-short-name } de offerer de memorisar credentiales. Le valores "true" e "false" es acceptate.

policy-OfferToSaveLoginsDefault = Indica le valor predefinite pro permitter a { -brand-short-name } de offerer de memorisar credentiales. Le valores "true" e "false" es acceptate. Le valores "ver" e "false" es acceptate.

policy-OverrideFirstRunPage = Supplantar le pagina del lanceamento initial.

policy-OverridePostUpdatePage = Supplantar le pagina de “Novas” post-actualisation. Defini iste criterio a blanc si tu desira disactivar le pagina de post-actualisation.

policy-PasswordManagerEnabled = Activar salvamento de contrasignos al gestor de contrasignos.

# PDF.js and PDF should not be translated
policy-PDFjs = Disactivar o configurar PDF.js, le visor de PDF integrate in { -brand-short-name }.

policy-Permissions2 = Configurar permissos pro camera, microphono, position, avisos e autoreproduction.

policy-Preferences = Definir e blocar le valor de un sub-ensemble de preferentias.

policy-PromptForDownloadLocation = Demandar ubi salvar le files quando on discarga.

policy-Proxy = Configurar le parametros del servitor proxy.

policy-RequestedLocales = Definir le lista de linguas desirate pro le application in ordine de preferentia.

policy-SanitizeOnShutdown2 = Clarar datos de navigation al clausura.

policy-SearchEngines = Configurar le parametros del motores de recerca. Iste criterio es solmente disponibile sur le version con supporto extendite (Extended Support Release - ESR).

policy-SearchSuggestEnabled = Activar o disactivar suggestiones de recerca.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Installar modulos PKCS #11.

policy-SSLVersionMax = Stabilir le version SSL maxime.

policy-SSLVersionMin = Stabilir le version SSL minime.

policy-SupportMenu = Adder un selection de supporto personalisate al menu de adjuta.

policy-UserMessaging = Non monstrar certe messages al usator.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blocar le accesso a sitos web. Vider documentation pro plus detalios sur le formato.
