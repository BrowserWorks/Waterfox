# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Establecer las políticas que WebExtensions pueden acceder a través de chrome.storage.managed.
policy-AppAutoUpdate = Habilitar o deshabilitar la actualización automática de la aplicación.
policy-AppUpdatePin = Evita que { -brand-short-name } se actualice más allá de la versión especificada.
policy-AppUpdateURL = Establecer la URL personalizada para actualización de la aplicación.
policy-Authentication = Configurar la autenticación integrada para los sitios web que la admitan.
policy-BackgroundAppUpdate2 = Habilitar o deshabilitar la actualización en segundo plano.
policy-BlockAboutAddons = Bloquear el acceso al administrador de complementos (about:addons).
policy-BlockAboutConfig = Bloquear acceso ala página about:config.
policy-BlockAboutProfiles = Bloquear acceso a la página about:profiles.
policy-BlockAboutSupport = Bloquear acceso a la página about:support.
policy-CaptivePortal = Habilitar o deshabilitar soporte de portal cautivo.
policy-CertificatesDescription = Agregar certificados o usar certificados integrados.
policy-Cookies = Permitir o no permitir que los sitios web guarden cookies.
policy-DisableBuiltinPDFViewer = Deshabilitar PDF.js, el lector de PDF integrado en { -brand-short-name }.
policy-DisabledCiphers = Deshabilitar cifrado.
policy-DefaultDownloadDirectory = Establece el directorio de descargas predeterminado.
policy-DisableAppUpdate = Impedir que { -brand-short-name } se actualice.
policy-DisableDefaultClientAgent = Impedir que el agente cliente predeterminado realice cualquier acción. Sólo aplicable en Windows; otras plataformas no tienen el agente.
policy-DisableDeveloperTools = Bloquear acceso a las herramientas de desarrollador.
policy-DisableFeedbackCommands = Deshabilitar comandos para enviar comentarios desde el menú de Ayuda (Submit Feedback and Report Deceptive Site).
policy-DisableForgetButton = Impedir acceso al botón Olvidar.
policy-DisableFormHistory = No recordar historial de búsqueda y formularios.
policy-DisableMasterPasswordCreation = Si el valor es true, no se puede crear una contraseña maestra.
policy-DisablePasswordReveal = No permitir que se muestren contraseñas en inicios de sesión guardados.
policy-DisableProfileImport = Deshabilitar la opción de menú para importar datos de otra aplicación.
policy-DisableSafeMode = Deshabilitar la característica de reiniciar en modo seguro. Nota: la tecla Shift para entrar en modo seguro sólo puede ser deshabilitada en Windows usando políticas de grupo.
policy-DisableSecurityBypass = Impedir que el usuario ignore ciertas alertas de seguridad.
policy-DisableSystemAddonUpdate = Impedir que { -brand-short-name } instale o actualice complementos de sistema.
policy-DisableTelemetry = Deshabilitar la telemetría.
policy-DisplayMenuBar = Desplegar la barra de menús de forma predeterminada.
policy-DNSOverHTTPS = Configurar el DNS sobre HTTPS.
policy-DontCheckDefaultClient = Deshabilitar la verificación de cliente predeterminado al inicio.
policy-DownloadDirectory = Establecer y bloquear el directorio de descargas.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Habilitar o deshabilitar el bloqueo de contenido y bloquearlo opcionalmente.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Habilitar o deshabilitar extensiones de medios cifrados y opcionalmente, bloquearlos.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar o bloquear extensiones. La opción Instalar toma direcciones URL o rutas como parámetros. Las opciones desinstalar y bloquear toman ID de extensión.
policy-ExtensionSettings = Administrar todos los aspectos de la instalación de extensiones.
policy-ExtensionUpdate = Habilitar o deshabilitar la actualización automática de extensiones.
policy-Handlers = Configurar gestores de aplicación predeterminados.
policy-HardwareAcceleration = Si el valor es falso, se desactiva la aceleración por hardware.
policy-InstallAddonsPermission = Permitir a ciertos sitios instalar complementos.
policy-LegacyProfiles = Deshabilitar la función que obliga a tener un perfil separado para cada instalación.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar la configuración de comportamiento tradicional de SameSite para las cookies de forma predeterminada.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Volver al comportamiento tradicional de SameSite para las cookies en sitios específicos.

##

policy-LocalFileLinks = Permitir a sitios web específicos para enlazar a archivos locales.
policy-ManualAppUpdateOnly = Permitir solo actualizaciones manuales y no notificar al usuario sobre las actualizaciones.
policy-NetworkPrediction = Habilitar o deshabilitar predicción de red (búsqueda previa de DNS).
policy-OfferToSaveLogins = Aplicar la configuración para permitir que { -brand-short-name } ofrezca recordar inicios de sesión y contraseñas guardadas. Se aceptan valores verdaderos y falsos.
policy-OfferToSaveLoginsDefault = Establecer el valor predeterminado para permitir que { -brand-short-name } te ofrezca recordar inicios de sesión y contraseñas guardados. Se aceptan valores verdaderos y falsos.
policy-OverrideFirstRunPage = Anular la primera página de ejecución. Establece esta política en blanco si deseas deshabilitar la primera página de ejecución.
policy-OverridePostUpdatePage = Anular la página “Novedades” posterior a la actualización. Establece esta política en blanco si deseas deshabilitar la página posterior a la actualización.
policy-PasswordManagerEnabled = Habilitar guardar contraseñas en el administrador de contraseñas.
# PDF.js and PDF should not be translated
policy-PDFjs = Deshabilitar o configurar PDF.js, el visor de PDF integrado en { -brand-short-name }.
policy-Permissions2 = Configurar permisos para cámara, micrófono, ubicación, notificaciones y reproducción automática.
policy-Preferences = Establecer y bloquear el valor para un subconjunto de preferencias.
policy-PrimaryPassword = Requerir o evitar el uso de una contraseña maestra.
policy-PromptForDownloadLocation = Preguntar dónde guardar los archivos al descargar.
policy-Proxy = Configurar ajustes de proxy.
policy-RequestedLocales = Establecer la lista de localizaciones solicitadas para la aplicación, ordenadas por preferencia.
policy-SanitizeOnShutdown2 = Borrar datos de navegación al cerrar.
policy-SearchEngines = Configurar los ajustes de motor de búsqueda. Esta política solo está disponible en la versión Extended Support Release (ESR).
policy-SearchSuggestEnabled = Habilitar o deshabilitar sugerencias de búsqueda.
# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar módulos PKCS #11.
policy-SSLVersionMax = Establecer la versión máxima de SSL.
policy-SSLVersionMin = Establecer la versión mínima de SSL.
policy-SupportMenu = Agregar un elemento personalizado de asistencia al menú de ayuda.
policy-UserMessaging = No mostrar ciertos mensajes al usuario.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloquear sitios web para que no sean visitados. Consulta la documentación para obtener más detalles sobre el formato.
