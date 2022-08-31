# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Configuración de cuenta

## Header

account-setup-title = Configurar su dirección de correo electrónico existente.
account-setup-description = Para utilizar su cuenta de correo electrónico actual, introduzca sus credenciales.
account-setup-secondary-description = { -brand-product-name } buscará automáticamente una configuración de servidor recomendada y que funcione.
account-setup-success-title = Cuenta creada correctamente
account-setup-success-description = Ahora puede usar esta cuenta con { -brand-short-name }.
account-setup-success-secondary-description = Puede mejorar la experiencia conectando servicios relacionados y configurando los ajustes de cuenta avanzados.

## Form fields

account-setup-name-label = Nombre completo
    .accesskey = N
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe
account-setup-name-info-icon =
    .title = Su nombre, como se mostrará a otros usuarios
account-setup-name-warning-icon =
    .title = Por favor, introduzca su nombre
account-setup-email-label = Dirección de correo electrónico
    .accesskey = e
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-email-info-icon =
    .title = Su correo electrónico existente
account-setup-email-warning-icon =
    .title = Dirección de correo electrónico no válida
account-setup-password-label = Contraseña
    .accesskey = C
    .title = Opcional, solo se usará para validar el nombre de usuario
account-provisioner-button = Obtener una nueva dirección de correo electrónico
    .accesskey = O
account-setup-password-toggle-show =
    .title = Mostrar contraseña en texto sin cifrar
account-setup-password-toggle-hide =
    .title = Ocultar contraseña
account-setup-remember-password = Recordar contraseña
    .accesskey = m
account-setup-exchange-label = Nombre de usuario
    .accesskey = d
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = DOMINIO\nombredeusuario
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Inicio de sesión del dominio

## Action buttons

account-setup-button-cancel = Cancelar
    .accesskey = a
account-setup-button-manual-config = Configurar manualmente
    .accesskey = m
account-setup-button-stop = Detener
    .accesskey = D
account-setup-button-retest = Volver a comprobar
    .accesskey = V
account-setup-button-continue = Continuar
    .accesskey = C
account-setup-button-done = Hecho
    .accesskey = H

## Notifications

account-setup-looking-up-settings = Buscando la configuración…
account-setup-looking-up-settings-guess = Buscando configuración: Intentando con nombres de servidor comunes…
account-setup-looking-up-settings-half-manual = Buscando configuración: Probando el servidor…
account-setup-looking-up-disk = Buscando configuración: instalación de { -brand-short-name }…
account-setup-looking-up-isp = Buscando configuración: Proveedor de correo electrónico…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Buscando configuración: base de datos ISP de Waterfox…
account-setup-looking-up-mx = Buscando configuración: dominio de correo entrante…
account-setup-looking-up-exchange = Buscando configuración: servidor de Exchange…
account-setup-checking-password = Comprobando la contraseña…
account-setup-installing-addon = Descargando e instalando complemento…
account-setup-success-half-manual = Se encontraron las siguientes configuraciones al sondear el servidor indicado:
account-setup-success-guess = Configuración encontrada probando nombres de servidor comunes.
account-setup-success-guess-offline = Está trabajando sin conexión. Hemos adivinado algunos parámetros pero tendrá que introducir la configuración correcta.
account-setup-success-password = Contraseña correcta
account-setup-success-addon = El complemento se instaló correctamente
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Configuración encontrada en la base de datos de ISP de Waterfox.
account-setup-success-settings-disk = Configuración encontrada en la instalación de { -brand-short-name }.
account-setup-success-settings-isp = Configuración encontrada en el proveedor de correo electrónico.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Configuración encontrada para un servidor de Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Configuración inicial
account-setup-step2-image =
    .title = Cargando…
account-setup-step3-image =
    .title = Configuración encontrada
account-setup-step4-image =
    .title = Error de conexión
account-setup-step5-image =
    .title = Cuenta creada
account-setup-privacy-footnote2 = Sus credenciales solo se almacenarán localmente en su ordenador.
account-setup-selection-help = ¿No está seguro de qué seleccionar?
account-setup-selection-error = ¿Necesita ayuda?
account-setup-success-help = ¿No está seguro de cómo continuar?
account-setup-documentation-help = Documentación de configuración
account-setup-forum-help = Foro de asistencia
account-setup-privacy-help = Política de privacidad
account-setup-getting-started = Primeros pasos

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Configuración disponible
       *[other] Configuraciones disponibles
    }
account-setup-result-imap-description = Mantener sus carpetas y correos electrónicos sincronizados en su servidor
account-setup-result-pop-description = Mantener sus carpetas y correos electrónicos en su equipo
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Usar el servidor Microsoft Exchange o los servicios en la nube de Office365
account-setup-incoming-title = Entrante
account-setup-outgoing-title = Saliente
account-setup-username-title = Nombre de usuario
account-setup-exchange-title = Servidor
account-setup-result-no-encryption = Sin cifrar
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Usar el servidor SMTP saliente existente
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Entrante: { $incoming }, Saliente: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Error en la autenticación. O las credenciales introducidas son incorrectas o se requiere un nombre de usuario distinto para iniciar sesión. Este nombre de usuario suele ser el inicio de sesión en el dominio de Windows con o sin el dominio (p. ej., juanperez o AD\\juanperez)
account-setup-credentials-wrong = Error en la autenticación. Por favor, compruebe el nombre de usuario y la contraseña
account-setup-find-settings-failed = { -brand-short-name } no ha podido encontrar la configuración de la cuenta de correo electrónico
account-setup-exchange-config-unverifiable = No se ha podido comprobar la configuración. Si su nombre de usuario y contraseña son correctos, es probable que el administrador del servidor haya deshabilitado la configuración seleccionada para su cuenta. Intente seleccionar otro protocolo.
account-setup-provisioner-error = Se ha producido un error al configurar la nueva cuenta en { -brand-short-name }. Intente configurar manualmente la cuenta con sus credenciales.

## Manual configuration area

account-setup-manual-config-title = Configuración manual
account-setup-incoming-server-legend = Servidor entrante
account-setup-protocol-label = Protocolo:
account-setup-hostname-label = Nombre del servidor:
account-setup-port-label = Puerto:
    .title = Establecer el puerto a 0 para la detección automática
account-setup-auto-description = { -brand-short-name } intentará detectar automáticamente los campos que se han dejado en blanco.
account-setup-ssl-label = Seguridad de la conexión:
account-setup-outgoing-server-legend = Servidor saliente

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Detectar automáticamente
ssl-no-authentication-option = Sin autenticación
ssl-cleartext-password-option = Contraseña normal
ssl-encrypted-password-option = Contraseña cifrada

## Incoming/Outgoing SSL options

ssl-noencryption-option = Ninguna
account-setup-auth-label = Método de autenticación:
account-setup-username-label = Nombre de usuario:
account-setup-advanced-setup-button = Configuración avanzada
    .accesskey = a

## Warning insecure server dialog

account-setup-insecure-title = ¡Advertencia!
account-setup-insecure-incoming-title = Ajustes de entrada:
account-setup-insecure-outgoing-title = Ajustes de salida:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = El servidor <b>{ $server }</b> no usa cifrado.
account-setup-warning-cleartext-details = Los servidores de correo inseguros no usan conexiones cifradas para proteger sus contraseñas e información privada. Al conectarse a este servidor podría estar exponiendo su contraseña e información privada.
account-setup-insecure-server-checkbox = Entiendo los riesgos
    .accesskey = i
account-setup-insecure-description = { -brand-short-name } le permite acceder a su correo utilizando las configuraciones proporcionadas. Sin embargo, debería contactar con su administrador o proveedor de correo electrónico respecto a estas conexiones inapropiadas. Consulte las <a data-l10n-name="thunderbird-faq-link">preguntas frecuentes sobre Thunderbird</a> para obtener más información.
insecure-dialog-cancel-button = Cambiar la configuración
    .accesskey = o
insecure-dialog-confirm-button = Confirmar
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } ha encontrado la información de configuración de su cuenta en { $domain }. ¿Desea continuar y enviar sus credenciales?
exchange-dialog-confirm-button = Iniciar sesión
exchange-dialog-cancel-button = Cancelar

## Dismiss account creation dialog

exit-dialog-title = No se ha configurado ninguna cuenta de correo electrónico
exit-dialog-description = ¿Está seguro de que quiere cancelar el proceso de configuración? Puede usar { -brand-short-name } sin una cuenta de correo electrónico, pero muchas funciones no estarán disponibles.
account-setup-no-account-checkbox = Usar { -brand-short-name } sin una cuenta de correo electrónico
    .accesskey = U
exit-dialog-cancel-button = Continuar la configuración
    .accesskey = C
exit-dialog-confirm-button = Salir de la configuración
    .accesskey = S

## Alert dialogs

account-setup-creation-error-title = Error al crear la cuenta
account-setup-error-server-exists = El servidor de entrada ya existe.
account-setup-confirm-advanced-title = Confirmar configuración avanzada
account-setup-confirm-advanced-description = Este cuadro de diálogo se cerrará y se creará una cuenta con la configuración actual, aunque la configuración sea incorrecta. ¿Quiere continuar?

## Addon installation section

account-setup-addon-install-title = Instalar
account-setup-addon-install-intro = Un complemento de terceros puede permitirle acceder a su cuenta de correo electrónico en este servidor:
account-setup-addon-no-protocol = Desafortunadamente, este servidor de correo no admite protocolos abiertos. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Configuración de la cuenta
account-setup-encryption-button = Cifrado de extremo a extremo
account-setup-signature-button = Añadir una firma
account-setup-dictionaries-button = Descargar diccionarios
account-setup-address-book-carddav-button = Conectarse a una libreta de direcciones CardDAV
account-setup-address-book-ldap-button = Conectarse a una libreta de direcciones LDAP
account-setup-calendar-button = Conectarse a un calendario remoto
account-setup-linked-services-title = Conectar sus servicios vinculados
account-setup-linked-services-description = { -brand-short-name } ha detectado otros servicios vinculados a su cuenta de correo electrónico.
account-setup-no-linked-description = Configure otros servicios para aprovechar al máximo su experiencia con { -brand-short-name }.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } ha encontrado una libreta de direcciones vinculada a su cuenta de correo electrónico.
       *[other] { -brand-short-name } ha encontrado { $count } libretas de direcciones vinculadas a su cuenta de correo electrónico.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } ha encontrado un calendario vinculado a su cuenta de correo electrónico.
       *[other] { -brand-short-name } ha encontrado { $count } calendarios vinculados a su cuenta de correo electrónico.
    }
account-setup-button-finish = Finalizar
    .accesskey = F
account-setup-looking-up-address-books = Buscando libretas de direcciones...
account-setup-looking-up-calendars = Buscando calendarios...
account-setup-address-books-button = Libretas de direcciones
account-setup-calendars-button = Calendarios
account-setup-connect-link = Conectar
account-setup-existing-address-book = Conectada
    .title = Libreta de direcciones conectada
account-setup-existing-calendar = Conectado
    .title = Calendario conectado
account-setup-connect-all-calendars = Conectar todos los calendarios
account-setup-connect-all-address-books = Conectar todas las libretas de direcciones

## Calendar synchronization dialog

calendar-dialog-title = Conectar el calendario
calendar-dialog-cancel-button = Cancelar
    .accesskey = C
calendar-dialog-confirm-button = Conectar
    .accesskey = n
account-setup-calendar-name-label = Nombre
account-setup-calendar-name-input =
    .placeholder = Mi calendario
account-setup-calendar-color-label = Color
account-setup-calendar-refresh-label = Actualizar
account-setup-calendar-refresh-manual = Manualmente
account-setup-calendar-refresh-interval =
    { $count ->
        [one] Cada minuto
       *[other] Cada { $count } minutos
    }
account-setup-calendar-read-only = Sólo lectura
    .accesskey = r
account-setup-calendar-show-reminders = Mostrar recordatorios
    .accesskey = s
account-setup-calendar-offline-support = Ayuda sin conexión
    .accesskey = o
