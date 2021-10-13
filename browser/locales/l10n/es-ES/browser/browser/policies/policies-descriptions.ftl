# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Establezca las políticas a las que puede acceder WebExtensions mediante chrome.storage.managed.

policy-AllowedDomainsForApps = Definir dominios autorizados para acceder a Google Workspace.

policy-AppAutoUpdate = Activar o desactivar la actualización automática de la aplicación.

policy-AppUpdateURL = Establecer una URL personalizada de actualización de la aplicación.

policy-Authentication = Configurar la autenticación integrada para sitios web que la admitan.

policy-AutoLaunchProtocolsFromOrigins = Define una lista de protocolos externos que pueden ser usados desde los orígenes que aparecen en la lista sin que se pida confirmación al usuario.

policy-BackgroundAppUpdate2 = Activar o desactivar la actualización en segundo plano.

policy-BlockAboutAddons = Bloquear el acceso al administrador de complementos (about:addons).

policy-BlockAboutConfig = Bloquear el acceso a la página about:config.

policy-BlockAboutProfiles = Bloquear el acceso a la página about:profiles.

policy-BlockAboutSupport = Bloquear el acceso a la página about:support.

policy-Bookmarks = Crear marcadores en la barra de herramientas de marcadores, en el menú de marcadores o en una carpeta específica dentro de los mismos.

policy-CaptivePortal = Activar o desactivar el soporte de portal cautivo.

policy-CertificatesDescription = Añada certificados o use los certificados incluidos de serie.

policy-Cookies = Permitir o denegar a los sitios web establecer cookies.

policy-DisabledCiphers = Desactivar cifrados.

policy-DefaultDownloadDirectory = Establecer el directorio de descargas predeterminado.

policy-DisableAppUpdate = Evitar que el navegador se actualice.

policy-DisableBuiltinPDFViewer = Desactivar PDF.js, el visor de PDF integrado en { -brand-short-name }.

policy-DisableDefaultBrowserAgent = Previene que el agente de navegador predeterminado realice cualquier acción. Solo aplicable a Windows; otras plataformas no tienen el agente.

policy-DisableDeveloperTools = Bloquear el acceso a las herramientas de desarrollador.

policy-DisableFeedbackCommands = Desactivar comandos para enviar opiniones desde el menú de ayuda (Enviar opinión e informar de sitio engañoso).

policy-DisableWaterfoxAccounts = Desactivar servicios basados en { -fxaccount-brand-name }, incluyendo Sync.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = Desactivar la función Waterfox Screenshots.

policy-DisableWaterfoxStudies = Evitar que { -brand-short-name } ejecute estudios.

policy-DisableForgetButton = Impedir el acceso al botón Olvidar.

policy-DisableFormHistory = No recordar el historial de búsqueda y formularios.

policy-DisablePrimaryPasswordCreation = Si es cierto, no se puede crear una contraseña maestra

policy-DisablePasswordReveal = No permitir que se vean las contraseñas en las credenciales guardadas.

policy-DisablePocket = Desactivar la función para guardar páginas web en Pocket.

policy-DisablePrivateBrowsing = Desactivar la navegación privada.

policy-DisableProfileImport = Desactivar el comando de menú para importar datos desde otro navegador.

policy-DisableProfileRefresh = Desactivar el botón de Restablecer { -brand-short-name } en la página about:support.

policy-DisableSafeMode = Desactivar la función para reiniciar en modo seguro. Nota: la tecla Mayús para acceder al modo seguro solo se puede desactivar en Windows usando las políticas de grupo del sistema.

policy-DisableSecurityBypass = Evitar que el usuario se salte ciertas advertencias de seguridad.

policy-DisableSetAsDesktopBackground = Desactivar el comando de menú Establecer como fondo de escritorio para las imágenes.

policy-DisableSystemAddonUpdate = Impedir que el navegador instale y actualice complementos del sistema.

policy-DisableTelemetry = Desactivar Telemetry.

policy-DisplayBookmarksToolbar = Mostrar de forma predeterminada la barra de herramientas de marcadores.

policy-DisplayMenuBar = Mostrar de forma predeterminada la barra de menú.

policy-DNSOverHTTPS = Configurar DNS sobre HTTPS.

policy-DontCheckDefaultBrowser = Desactivar la comprobación de navegador predeterminado al iniciar.

policy-DownloadDirectory = Establecer y bloquear el directorio de descargas predeterminado.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activar o desactivar el bloqueo de contenido y bloquearlo opcionalmente.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activar o desactivar extensiones de medios cifrados y, opcionalmente, bloquearlos.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar o bloquear extensiones. La opción de instalar usa URLs o rutas como parámetros. Las opciones para desinstalar y bloquear usan los ID de las extensiones.

policy-ExtensionSettings = Administrar todos los aspectos de la instalación de extensiones.

policy-ExtensionUpdate = Habilitar o deshabilitar actualizaciones automáticas de extensiones.

policy-WaterfoxHome = Configurar la página de inicio de Waterfox.

policy-FlashPlugin = Permitir o denegar el uso del plugin Flash.

policy-Handlers = Configurar gestores de aplicación predeterminados.

policy-HardwareAcceleration = Si es falso, desactiva la aceleración por hardware.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Establecer y opcionalmente bloquear la página de inicio.

policy-InstallAddonsPermission = Permitir que ciertos sitios web instalen complementos.

policy-LegacyProfiles = Desactivar la función que obliga a tener un perfil separado para cada instalación

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar la configuración de comportamiento tradicional de SameSite para las cookies de forma predeterminada.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Volver al comportamiento tradicional de SameSite para las cookies en sitios específicos.

##

policy-LocalFileLinks = Permitir a sitios web concretos enlazar a archivos locales.

policy-ManagedBookmarks = Configura una lista de marcadores administrada por un administrador que el usuario no puede cambiar.

policy-ManualAppUpdateOnly = Permitir solo actualizaciones manuales y no notificar al usuario acerca de actualizaciones.

policy-PrimaryPassword = Requerir o evitar el uso de una contraseña maestra.

policy-NetworkPrediction = Habilitar o deshabilitar la predicción de red (búsqueda previa de DNS).

policy-NewTabPage = Habilitar o deshabilitar la página Nueva pestaña.

policy-NoDefaultBookmarks = Desactivar la creación de los marcadores predeterminados incluidos con { -brand-short-name } y los marcadores inteligentes (Más visitados, Etiquetas recientes). Nota: esta política solo es válida si se utiliza antes de la primera ejecución del perfil.

policy-OfferToSaveLogins = Aplicar la configuración para permitir que { -brand-short-name } ofrezca recordar inicios de sesión y contraseñas guardadas. Se aceptan los valores verdadero y falso.

policy-OfferToSaveLoginsDefault = Establecer el valor predeterminado para permitir que { -brand-short-name } le ofrezca recordar inicios de sesión y contraseñas guardados. Se aceptan los valores true y false.

policy-OverrideFirstRunPage = Anular la página de primera ejecución. Deje esta política en blanco si desea desactivar la página de primera ejecución.

policy-OverridePostUpdatePage = Anular la página "Qué hay de nuevo" posterior a la actualización. Deje esta política en blanco si quiere desactivar la página posterior a la actualización.

policy-PasswordManagerEnabled = Activar el guardado de contraseñas en el administrador de contraseñas.

# PDF.js and PDF should not be translated
policy-PDFjs = Desactivar o configurar PDF.js, el visor de PDF integrado en { -brand-short-name }.

policy-Permissions2 = Configurar permisos para cámara, micrófono, ubicación, notificaciones y reproducción automática.

policy-PictureInPicture = Activar o desactivar Picture-in-Picture.

policy-PopupBlocking = Permitir que ciertos sitios web muestren ventanas emergentes de forma predeterminada.

policy-Preferences = Establezca y bloquee el valor para un subconjunto de preferencias.

policy-PromptForDownloadLocation = Preguntar dónde guardar los archivos que se descargan.

policy-Proxy = Configurar los ajustes del proxy.

policy-RequestedLocales = Establecer la lista de localizaciones solicitadas para la aplicación, ordenadas por preferencia.

policy-SanitizeOnShutdown2 = Borrar datos de navegación al salir.

policy-SearchBar = Establecer la ubicación predeterminada de la barra de búsqueda. El usuario todavía puede personalizarla.

policy-SearchEngines = Configurar los ajustes del motor de búsqueda. Esta política solo está disponible en la versión Extended Support Release (ESR).

policy-SearchSuggestEnabled = Habilitar o deshabilitar sugerencias de búsqueda.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar módulos PKCS #11.

policy-ShowHomeButton = Mostrar el botón de inicio en la barra de herramientas.

policy-SSLVersionMax = Establecer la versión máxima de SSL.

policy-SSLVersionMin = Establecer la versión mínima de SSL.

policy-SupportMenu = Agrega un elemento de menú de soporte personalizado al menú de ayuda.

policy-UserMessaging = No mostrar ciertos mensajes al usuario.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloquear sitios web para que no sean visitados. Consulte la documentación para obtener más detalles sobre el formato.

policy-Windows10SSO = Permitir inicio de sesión único de Windows para cuentas Microsoft, profesionales y educativas.
