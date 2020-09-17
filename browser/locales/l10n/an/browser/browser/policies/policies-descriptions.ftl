# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Definir las politicas a que WebExtensions puede acceder via chrome.storage.managed.
policy-AppAutoUpdate = Activar u desactivar las actualizacions automaticas de l'aplicación.
policy-AppUpdateURL = Cambia la URL personalizada d'actualización de l'aplicación
policy-Authentication = Configura l'autenticación integrada pa pachinas web que la proposen.
policy-BlockAboutAddons = Blocar l'acceso a lo chestor d'extensions (about:addons).
policy-BlockAboutConfig = Blocar l'acceso a la pachina about:config.
policy-BlockAboutProfiles = Blocar l'acceso a la pachina about:profiles.
policy-BlockAboutSupport = Blocar l'acceso a la pachina about:support .
policy-Bookmarks = Crear marcapachinas en a barra de ferramientas de Marcapachinas, lo menú de marcapachinas u en una carpeta especifica adintro d'ella.
policy-CaptivePortal = Activar u desactivar lo soporte a portals cautivos.
policy-CertificatesDescription = Anyadir certificaus u usar los certificaus predefinius.
policy-Cookies = Permitir u vedar a las pachinas web de definir cookies.
policy-DisabledCiphers = Desactivar cifraus.
policy-DefaultDownloadDirectory = Definir la carpeta de descargas por defecto
policy-DisableAppUpdate = Privar que lo navegador s'esvielle.
policy-DisableBuiltinPDFViewer = Desactiva PDF.js, lo lector incorporau de PDF en { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Priva que l'achent d'o navegador per defecto prenga garra acción. Nomás aplicable en Windows, atros sistemas no tienen l'achent.
policy-DisableDeveloperTools = Blocar l'acceso a las ferramientas de desenvolvedor.
policy-DisableFeedbackCommands = Desactiva los comandos de ninviar feedback desde lo menú d'Aduya (Ninviar feedback y reportar puestos enganyosos).
policy-DisableFirefoxAccounts = Desactivar servicios basaus en { -fxaccount-brand-name }, mesmo Sync.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Desactivar la función Foto de pantalla de Firefox.
policy-DisableFirefoxStudies = Priva que { -brand-short-name } execute estudios.
policy-DisableForgetButton = Priva l'acceso a lo botón Oblidar.
policy-DisableFormHistory = No remerar lo historial de buquedas y formularios.
policy-DisableMasterPasswordCreation = Si ye activau, no se podrá crear una clau mayestra.
policy-DisablePrimaryPasswordCreation = Si ye activau, no se podrá crear una clau primaria.
policy-DisablePasswordReveal = No permitir de revelar claus en inicios de sesión alzaus.
policy-DisablePocket = Desactivar la función d'alzar pachinas web en Pocket.
policy-DisablePrivateBrowsing = Desactivar la navegación privada.
policy-DisableProfileImport = Desactivar la orden de menú que permite importar datos d'unatro navegador.
policy-DisableProfileRefresh = Desactivar lo botón de refresco de { -brand-short-name } en a pachina about:support
policy-DisableSafeMode = Desactivar la función de reiniciar en Modo seguro. Nota: la tecla Shift pa dentrar en Modo seguro nomás puede desactivar-se en Windows fendo servir politicas de grupo.
policy-DisableSecurityBypass = Priva que l'usuario se pase ciertos avisos de seguranza.
policy-DisableSetAsDesktopBackground = Desactivar lo comando de menú Triar como Fondo de escritorio para imachens.
policy-DisableSystemAddonUpdate = Priva que lo navegador instale u esvielle extensions d'o sistema.
policy-DisableTelemetry = Desactivar Telemetría.
policy-DisplayBookmarksToolbar = Amuestra la barra de ferramientas de marcapachinas per defecto.
policy-DisplayMenuBar = Amostrar la barra de menú per defecto.
policy-DNSOverHTTPS = Configurar lo DNS con HTTPS.
policy-DontCheckDefaultBrowser = Desactivar la comprebación d'o navegador per defecto a l'inicio.
policy-DownloadDirectory = Definir y trancar lo directorio de descargas.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activar u desactivar lo bloqueyo de conteniu y opcionalment blocar-lo.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activar u desactivar las extensions de medios cifraus y opcionalment blocar-los.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar u blocar extensions. La opción d'instalar prene URLs u rutas como parametros. Las opcions de desinstalar y blocar prenen las IDs d'extension.
policy-ExtensionSettings = Chestionar totz los aspectos de la instalación d'extensions.
policy-ExtensionUpdate = Activar u desactivar las actualizacións automaticas
policy-FirefoxHome = Configurar la pachina d'inicio de Firefox.
policy-FlashPlugin = Permitir u no l'uso d'a extensión de Flash.
policy-Handlers = Configurar los chestors d'as aplicacions per defecto.
policy-HardwareAcceleration = Si ye falso, amorta l'acceleración per hardware.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Configura y opcionalment bloca la pachina d'inicio.
policy-InstallAddonsPermission = Permitir a ciertas pachinas web d'instalar extensions.
policy-LegacyProfiles = Desactivar la función de forzar un perfil deseparau pa cada instalación.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar la configuración de conducta de cookies SameSite heredada per defecto.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Restaurar la conducta desactualizada SameSite pa cookies en pachinas especificas.

##

policy-LocalFileLinks = Permitir a pachinas web usar vinclos a fichers locals.
policy-MasterPassword = Requerir u privar l'uso d'una clau mayestra.
policy-PrimaryPassword = Requerir u privar l'uso d'una clau principal.
policy-NetworkPrediction = Activar u desactivar la predicción de ret (DNS prefetching).
policy-NewTabPage = Activar u desactivar la pachina de nueva pestanya.
policy-NoDefaultBookmarks = Desactivar la creación d'os marcapachinas per defecto adintro de { -brand-short-name }, y los marcapachinas intelichents (mas visitaus, etiquetas recients). Nota: esta politica nomás ye efectiva si se fa servir antes d'o primer uso d'o perfil.
policy-OfferToSaveLogins = Aforzar la configuración que permite que { -brand-short-name } s'obreixca a recordar d'os inicios de sesión y claus alzaus. S'acceptan las valors verdadero y falso.
policy-OfferToSaveLoginsDefault = Configura la valor por defecto pa permitir que { -brand-short-name } s'ofreixca a recordar los inicios de sesión y claus alzaus. S'acceptan las valors verdadero y falso.
policy-OverrideFirstRunPage = Sobrescribe la pachina d'a primer execución. Configura esta política en blanco si quiers desactivar la pachina d'a primer execución.
policy-OverridePostUpdatePage = Sobrescribe la pachina "Novedatz" de dimpués d'a instalación. Configura esta politica en blanco si quiers desactivar la pachina de dimpués de la instalación.
policy-PasswordManagerEnabled = Permitir alzar claus en o chestor de claus.
# PDF.js and PDF should not be translated
policy-PDFjs = Desactivar u configurar PDF.js, lo visor de PDF de { -brand-short-name }.
policy-Permissions2 = Configurar permisos pa la camara, microfono, localización, notificacions y reproducción automatica.
policy-PictureInPicture = Activar u desactivar Picture-in-Picture.
policy-PopupBlocking = Permitir a ciertas pachinas web de mostrar popups per defecto.
policy-Preferences = Configurar y blocar la valor d'un subconchunto de preferencias.
policy-PromptForDownloadLocation = Preguntar án alzar los fichers quan se descargan.
policy-Proxy = Configurar lo proxy
policy-RequestedLocales = Configura la lista d'idiomas (locales) demandaus pa aplicar-los en orden de preferencia.
policy-SanitizeOnShutdown2 = Limpia los datos de navegación en amortar.
policy-SearchBar = Configura la localización por defecto en a barra de busqueda. L'usuario la puede personalizar.
policy-SearchEngines = Configurar las opcions de motors de busqueda. Esta politica nomás ye accesible en a versión de soporte extendido (ESR).
policy-SearchSuggestEnabled = Activar u desactivar las sucherencias de busqueda.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar los módulos PKCS #11.
policy-SSLVersionMax = Configurar la versión maxima de SSL.
policy-SSLVersionMin = Configurar la versión minima de SSL.
policy-SupportMenu = Anyadir un elemento d'o menú de soporte personalizau a lo menú d'aduya.
policy-UserMessaging = No amostrar ciertos mensaches a l'usuario.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blocar l'acceso a pachinas web. Mira la documentación pa mas detalles sobre lo formato.
