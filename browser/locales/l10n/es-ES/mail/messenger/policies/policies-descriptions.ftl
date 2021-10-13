# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Establecer políticas a las que WebExtensions puedan acceder a través de chrome.storage.managed.

policy-AppAutoUpdate = Activar o desactivar la actualización automática de la aplicación.

policy-AppUpdateURL = Establecer una URL de actualización personalizada.

policy-Authentication = Configurar identificación integrada en los sitios web que la admitan.

policy-BlockAboutAddons = Bloquear el acceso al administrador de complementos (about:addons).

policy-BlockAboutConfig = Bloquear el acceso a la página about:config.

policy-BlockAboutProfiles = Bloquear el acceso a la página about:profiles.

policy-BlockAboutSupport = Bloquear el acceso a la página about:support.

policy-CaptivePortal = Activar o desactivar la compatibilidad con un portal cautivo.

policy-CertificatesDescription = Añadir certificados o usar certificados incluidos de serie.

policy-Cookies = Permitir o denegar a los sitios web enviar cookies.

policy-DisabledCiphers = Desactivar cifrados.

policy-DefaultDownloadDirectory = Establecer el directorio de descargas predeterminado.

policy-DisableAppUpdate = Impedir que { -brand-short-name } se actualice.

policy-DisableDefaultClientAgent = Impedir que el agente de cliente por omisión lleve a cabo ninguna acción. Solo es aplicable a Windows; otras plataformas no tienen el agente.

policy-DisableDeveloperTools = Bloquear el acceso a las herramientas de desarrollo.

policy-DisableFeedbackCommands = Desactivar las opciones para enviar información desde el menú Ayuda (Enviar opiniones e Informar de sitio fraudulento).

policy-DisableForgetButton = Impedir el acceso al botón Olvidar.

policy-DisableFormHistory = No recordar el historial de búsquedas y formularios.

policy-DisableMasterPasswordCreation = Si Verdadero, no se puede crear una contraseña maestra.

policy-DisablePasswordReveal = No permitir que se revelen las contraseñas en las credenciales guardadas.

policy-DisableProfileImport = Desactivar la opción de menú para importar datos desde otra aplicación.

policy-DisableSafeMode = Desactivar la funcionalidad para reiniciar en modo seguro. Nota: la tecla Mayúsculas para entrar en modo seguro solo puede desactivarse en Windows usando políticas de grupo.

policy-DisableSecurityBypass = Impedir que el usuario se salte ciertas advertencias de seguridad.

policy-DisableSystemAddonUpdate = Impedir que { -brand-short-name } instale y actualice complementos de sistema.

policy-DisableTelemetry = Desactivar Telemetry.

policy-DisplayMenuBar = Mostrar la barra de menú por defecto.

policy-DNSOverHTTPS = Configurar DNS sobre HTTPS.

policy-DontCheckDefaultClient = Desactivar la comprobación de cliente predeterminado al iniciar.

policy-DownloadDirectory = Establecer y bloquear el directorio de descargas.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activar o desactivar el bloqueo de contenido e impedir su modificación.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activar o desactivar las extensiones cifradas de medios y opcionalmente bloquearlos.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalar, desinstalar o bloquear exensiones. La opción Instalar admite URL o rutas como parámetros. Las opciones Desinstalar y Bloquear admiten ID de extensiones.

policy-ExtensionSettings = Administrar todos los aspectos de la instalación de extensiones.

policy-ExtensionUpdate = Activar o desactivar actualizaciones automáticas de extensiones.

policy-HardwareAcceleration = Si falso, desactivar la aceleración hardware.

policy-InstallAddonsPermission = Permitir a ciertos sitios web instalar complementos.

policy-LegacyProfiles = Disable the feature enforcing a separate profile for each installation.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activar el ajuste de comportamiento de la cookie SameSite por omisión anterior.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Revertir al comportamiento anterior de SameSite para las cookies de sitios específicos.

##

policy-LocalFileLinks = Permitir a sitios web específicos enlazar a archivos locales.

policy-NetworkPrediction = Activar o desactivar la predicción de red (precarga DNS).

policy-OfferToSaveLogins = Forzar el ajuste para permitir a { -brand-short-name } ofrecer recordar los inicios de sesión y contraseñas guardadas. Se aceptan valores Verdadero y Falso.

policy-OfferToSaveLoginsDefault = Configurar el valor por omisión para permitir a { -brand-short-name } ofrecer recordar las credenciales y contraseñas guardadas. Se aceptan valores Verdadero y Falso.

policy-OverrideFirstRunPage = Reemplazar la página de primera ejecución. Establezca esta política en blanco si quiere desactivar la página de primera ejecución.

policy-OverridePostUpdatePage = Reemplazar la página "Novedades" tras una actualización. Establezca esta política en blanco si quiere desactivar la página tras una actualización.

policy-PasswordManagerEnabled = Activar el guardado de contraseñas en el administrador de contraseñas.

# PDF.js and PDF should not be translated
policy-PDFjs = Desactivar o configurar PDF.js, el visor PDF incorporado en { -brand-short-name }.

policy-Permissions2 = Configurar permisos de la cámara, micrófono, ubicación, notificaciones y autorreproducción.

policy-Preferences = Establecer y bloquear el valor de un subconjunto de preferencias.

policy-PromptForDownloadLocation = Preguntar dónde guardar los archivos al guardar.

policy-Proxy = Configurar los ajustes de proxy.

policy-RequestedLocales = Configurar la lista de idiomas solicitados para la aplicación en orden de preferencia.

policy-SanitizeOnShutdown2 = Limpiar los datos de navegación al cerrar.

policy-SearchEngines = Configurar los ajustes de buscadores. Esta política solo está disponible en la versión de asistencia extendida (ESR).

policy-SearchSuggestEnabled = Activar o desactivar sugerencias de búsqueda.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalar módulos PKCS #11.

policy-SSLVersionMax = Establecer la versión SSL máxima.

policy-SSLVersionMin = Establecer la versión SSL mínima.

policy-SupportMenu = Añadir una opción de menú personalizada en el menú Ayuda.

policy-UserMessaging = No mstrar ciertos mensajes al usuario.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloquear la visita de sitios web. Vea la documentación para más detalles sobre el formato.
