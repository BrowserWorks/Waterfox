# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Establece políticas a las que WebExtensions pueda acceder a través de chrome.storage.managed.

policy-AllowedDomainsForApps = Define los dominios autorizados para acceder a Google Workspace.

policy-AppAutoUpdate = Activar o desactivar la actualización automática de la aplicación.

policy-AppUpdateURL = Establecer la URL de actualización de la aplicación personalizada.

policy-Authentication = Configurar la autenticación integrada para sitios web que lo admitan.

policy-AutoLaunchProtocolsFromOrigins = Define una lista de protocolos externos que pueden ser usados desde los orígenes que aparecen en la lista sin que se le pregunte al usuario.

policy-BackgroundAppUpdate2 = Habilitar o deshabilitar la actualización en segundo plano.

policy-BlockAboutAddons = Bloquear el acceso al administrador de complementos (about:addons).

policy-BlockAboutConfig = Bloquear acceso a la página about:config

policy-BlockAboutProfiles = Bloquear acceso a la página about:profiles.

policy-BlockAboutSupport = Bloquear acceso a la página about:support.

policy-Bookmarks = Crear marcadores en la barra de herramientas Marcadores, menú Marcadores o una carpeta específica dentro de ellos.

policy-CaptivePortal = Habilitar o deshabilitar soporte de portal cautivo.

policy-CertificatesDescription = Agregar certificados o usar certificados incorporados.

policy-Cookies = Permitir o denegar sitios web para establecer cookies.

policy-DisabledCiphers = Desactivar cifrados.

policy-DefaultDownloadDirectory = Establece el directorio de descarga predeterminado

policy-DisableAppUpdate = Evitar que el navegador se actualice.

policy-DisableBuiltinPDFViewer = Deshabilitar PDF.js, el lector de PDF integrado en { -brand-short-name }.

policy-DisableDefaultBrowserAgent = Previene que el agente de navegación predeterminado tome acciones. Solo aplicable a Windows; otras plataformas no tienen el agente.

policy-DisableDeveloperTools = Bloquear acceso a las herramientas de desarrollador.

policy-DisableFeedbackCommands = Deshabilitar comandos para enviar comentarios desde el menú Ayuda (Enviar comentario y reportar sitios engañosos).

policy-DisableWaterfoxAccounts = Deshabilitar los servicios basados en { -fxaccount-brand-name }, incluido Sync.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = Deshabilitar la función de Waterfox Screenshots.

policy-DisableWaterfoxStudies = Evitar que { -brand-short-name } ejecute estudios.

policy-DisableForgetButton = Evitar el acceso al botón Olvidar.

policy-DisableFormHistory = No recordar la búsqueda y el historial de formularios.

policy-DisablePrimaryPasswordCreation = Si es cierto, no se puede crear una contraseña maestra

policy-DisablePasswordReveal = No permitir que las contraseñas sean reveladas en inicios de sesión guardados.

policy-DisablePocket = Deshabilitar la característica para guardar páginas web a Pocket.

policy-DisablePrivateBrowsing = Deshabilitar Navegación Privada.

policy-DisableProfileImport = Deshabilitar el comando de menú para importar datos desde otro navegador.

policy-DisableProfileRefresh = Deshabilitar el botón "Recargar { -brand-short-name }" en la página about:support.

policy-DisableSafeMode = Deshabilitar la función para reiniciar en modo seguro. Nota: la tecla Mayús para ingresar al modo seguro solo se puede deshabilitar en Windows usando la política de grupo.

policy-DisableSecurityBypass = Evitar que el usuario ignore ciertas advertencias de seguridad.

policy-DisableSetAsDesktopBackground = Deshabilitar el comando de menú configurado como fondo de escritorio para las imágenes.

policy-DisableSystemAddonUpdate = Evitar que el navegador instale y actualice los complementos del sistema.

policy-DisableTelemetry = Desactivar la telemetría.

policy-DisplayBookmarksToolbar = Mostrar la barra de herramientas de marcadores de forma predeterminada.

policy-DisplayMenuBar = Mostrar la barra de menú de manera predeterminada.

policy-DNSOverHTTPS = Configurar DNS over HTTPS.

policy-DontCheckDefaultBrowser = Deshabilitar la comprobación del navegador predeterminado al inicio.

policy-DownloadDirectory = Establece y asegura el directorio de descarga

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Habilitar o deshabilitar el bloqueo de contenido y bloquearlo opcionalmente.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Habilitar o deshabilitar extensiones de medios cifrados y opcionalmente, bloquearlos.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar o bloquear extensiones. La opción Instalar toma direcciones URL o rutas como parámetros. Las opciones desinstalar y bloquear toman ID de extensión.

policy-ExtensionSettings = Administra todos los aspectos de la instalación de extensiones

policy-ExtensionUpdate = Habilitar o deshabilitar actualizaciones automáticas de extensiones.

policy-WaterfoxHome = Configura Waterfox Home.

policy-FlashPlugin = Permitir o denegar el uso del complemento Flash.

policy-Handlers = Configurar gestores de aplicación predeterminados.

policy-HardwareAcceleration = Si es "false", desactivar aceleración de hardware.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Establecer y opcionalmente bloquear la página de inicio.

policy-InstallAddonsPermission = Permitir que algunos sitios web instalen complementos.

policy-LegacyProfiles = Deshabilitar la función que obliga a tener un perfil separado para cada instalación

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar la configuración de comportamiento tradicional de SameSite para las cookies de forma predeterminada.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Volver al comportamiento tradicional de SameSite para las cookies en sitios específicos.

##

policy-LocalFileLinks = Permitir a sitios web específicos para enlazar a archivos locales.

policy-ManagedBookmarks = Configura una lista de marcadores administrada por un administrador que el usuario no puede cambiar.

policy-ManualAppUpdateOnly = Permitir solo actualizaciones manuales y no notificar al usuario sobre las actualizaciones.

policy-PrimaryPassword = Requerir o evitar el uso de una contraseña maestra.

policy-NetworkPrediction = Habilitar o deshabilitar predicción de red (búsqueda previa de DNS).

policy-NewTabPage = Habilitar o deshabilitar la página Nueva pestaña.

policy-NoDefaultBookmarks = Deshabilitar la creación de los marcadores predeterminados incluidos con { -brand-short-name }, y los marcadores inteligentes (etiquetas más visitadas y recientes). Nota: esta política solo es efectiva si se usa antes de la primera ejecución del perfil.

policy-OfferToSaveLogins = Haz cumplir la configuración para permitir que { -brand-short-name } ofrezca recordar inicios de sesión y contraseñas guardadas. Se aceptan valores verdaderos y falsos.

policy-OfferToSaveLoginsDefault = Establecer el valor predeterminado para permitir que { -brand-short-name } te ofrezca recordar inicios de sesión y contraseñas guardados. Se aceptan valores verdaderos y falsos.

policy-OverrideFirstRunPage = Anular la primera página de ejecución. Establecer esta política en blanco si desea deshabilitar la primera página de ejecución.

policy-OverridePostUpdatePage = Anular la página "Novedades" posterior a la actualización. Establecer esta política en blanco si deseas deshabilitar la página posterior a la actualización.

policy-PasswordManagerEnabled = Habilitar el guardado de contraseñas en el administrador de contraseñas.

# PDF.js and PDF should not be translated
policy-PDFjs = Deshabilitar o configurar PDF.js, el visor de PDF integrado en { -brand-short-name }.

policy-Permissions2 = Configura permisos para cámara, micrófono, ubicación, notificaciones y reproducción automática.

policy-PictureInPicture = Habilitar o deshabilitar Picture-in-Picture.

policy-PopupBlocking = Permitir que ciertos sitios web muestren ventanas emergentes de manera predeterminada.

policy-Preferences = Establece y bloquea el valor para un subconjunto de preferencias.

policy-PromptForDownloadLocation = Pregunte dónde guardar archivos al descargar.

policy-Proxy = Configura los ajustes del proxy.

policy-RequestedLocales = Establecer la lista de localizaciones solicitadas para la aplicación, ordenadas por preferencia.

policy-SanitizeOnShutdown2 = Borrar datos de navegación al apagar.

policy-SearchBar = Establecer la ubicación predeterminada de la barra de búsqueda. El usuario aún puede personalizarlo.

policy-SearchEngines = Configurar los ajustes del motor de búsqueda. Esta política solo está disponible en la versión Extended Support Release (ESR).

policy-SearchSuggestEnabled = Habilitar o deshabilitar sugerencias de búsqueda.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar módulos PKCS #11.

policy-ShowHomeButton = Muestra el botón de inicio en la barra de herramientas.

policy-SSLVersionMax = Establecer la versión máxima de SSL.

policy-SSLVersionMin = Establecer la versión mínima de SSL.

policy-SupportMenu = Agregar un elemento personalizado de asistencia al menú de ayuda.

policy-UserMessaging = No mostrar ciertos mensajes al usuario.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloquear sitios web de ser visitado. Consulta la documentación para obtener más detalles sobre el formato.

policy-Windows10SSO = Permitir inicio de sesión único de Windows para cuentas de Microsoft, el trabajo y la escuela.
