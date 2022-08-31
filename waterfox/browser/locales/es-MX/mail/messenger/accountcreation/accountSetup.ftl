# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Configuración de cuenta

## Header

account-setup-title = Configurar tu dirección de correo electrónico existente.

account-setup-description = Para utilizar tu dirección de correo electrónico actual, rellena tu credenciales.

account-setup-secondary-description = { -brand-product-name } buscará automáticamente una configuración de servidor recomendada y que funcione.

account-setup-success-title = Cuenta creada correctamente

account-setup-success-description = Ahora puedes usar esta cuenta con { -brand-short-name }.

account-setup-success-secondary-description = Puedes mejorar la experiencia conectando servicios relacionados y configurando la configuración de cuentas avanzadas.

## Form fields

account-setup-name-label = Tu nombre completo
    .accesskey = n

# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe

account-setup-name-info-icon =
    .title = Tu nombre, como se muestra a otros usuarios


account-setup-name-warning-icon =
    .title = Por favor, ingresa tu nombre

account-setup-email-label = Dirección de correo electrónico
    .accesskey = D

account-setup-email-input =
    .placeholder = john.doe@example.com

account-setup-email-info-icon =
    .title = Tu correo electrónico existente

account-setup-email-warning-icon =
    .title = Dirección de correo electrónico no válido

account-setup-password-label = Contraseña
    .accesskey = C
    .title = Opcional, solo es usará para validar el nombre de usuario

account-provisioner-button = Obtener una nueva dirección de correo electrónico
    .accesskey = O

account-setup-password-toggle-show =
    .title = Mostrar contraseña en texto sin cifrar

account-setup-password-toggle-hide =
    .title = Ocultar contraseña

account-setup-remember-password = Recordar contraseña
    .accesskey = m

account-setup-exchange-label = Tu inicio de sesión
    .accesskey = i

#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = TUDOMINIO\tunombredeusuario

#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Inicio de sesión de dominio

## Action buttons

account-setup-button-cancel = Cancelar
    .accesskey = a

account-setup-button-manual-config = Configurar manualmente
    .accesskey = m

account-setup-button-stop = Detener
    .accesskey = D

account-setup-button-retest = Volver a probar
    .accesskey = V

account-setup-button-continue = Continuar
    .accesskey = C

account-setup-button-done = Hecho
    .accesskey = H

## Notifications

account-setup-looking-up-settings = Buscando la configuración…

account-setup-looking-up-settings-guess = Buscando configuración: Intentando con nombres de servidor comunes…

account-setup-looking-up-settings-half-manual = Buscando configuración: probando el servidor…

account-setup-looking-up-disk = Buscando configuración: instalación de { -brand-short-name }…

account-setup-looking-up-isp = Buscando configuración: Proveedor de correo electrónico…

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Buscando configuración: base de datos ISP de Waterfox…

account-setup-looking-up-mx = Buscando configuración: dominio de correo entrante…

account-setup-looking-up-exchange = Buscando la configuración: servidor de Exchange…

account-setup-checking-password = Verificando contraseña…

account-setup-installing-addon = Descargando e instalando complemento…

account-setup-success-half-manual = Se encontraron las siguientes configuraciones probando el servidor proporcionado:

account-setup-success-guess = Se ha encontrado la configuración probando los nombres de los servidores que se utilizan comúnmente.

account-setup-success-guess-offline = No estás conectado. Se han adivinado algunas configuraciones pero necesitarás ingresar la configuración correcta.

account-setup-success-password = Contraseña correcta

account-setup-success-addon = El complemento se instaló correctamente

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Se ha encontrado la configuración en la base de datos ISP de Waterfox.

account-setup-success-settings-disk = Configuración encontrada en la instalación de { -brand-short-name }.

account-setup-success-settings-isp = Se ha encontrado la configuración en el proveedor de correo electrónico.

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

account-setup-privacy-footnote2 = Tus credenciales solo se almacenarán localmente en tu  equipo.

account-setup-selection-help = ¿No estás seguro de qué seleccionar?

account-setup-selection-error = ¿Necesitas ayuda?

account-setup-success-help = ¿No estás seguro de tus próximos pasos?

account-setup-documentation-help = Documentación de instalación

account-setup-forum-help = Foro de soporte

account-setup-privacy-help = Política de privacidad

account-setup-getting-started = Comenzar

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Configuración disponible
       *[other] Configuraciones disponibles
    }

account-setup-result-imap-description = Mantén tus carpetas y correos electrónicos sincronizados en tu servidor

account-setup-result-pop-description = Mantén tus carpetas y correos electrónicos en tu computadora

# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Usar el servidor de Microsoft Exchange o los servicios en la nube de Office365

account-setup-incoming-title = Entrante

account-setup-outgoing-title = Saliente

account-setup-username-title = Nombre de usuario

account-setup-exchange-title = Servidor

account-setup-result-no-encryption = Sin cifrar

account-setup-result-ssl = SSL/TLS

account-setup-result-starttls = STARTTLS

account-setup-result-outgoing-existing = Usar servidor SMTP de salida existente

# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Entrante: { $incoming }, saliente: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Autenticación fallida. Las credenciales ingresadas son incorrectas o se requiere un nombre de usuario diferente para iniciar sesión. Este nombre de usuario suele ser tu inicio de sesión para el dominio de Windows con o sin el dominio (por ejemplo, janedoe o AD\\janedoe).

account-setup-credentials-wrong = Autenticación fallida. Por favor, comprueba el nombre de usuario y contraseña

account-setup-find-settings-failed = { -brand-short-name } no pudo encontrar la configuración de tu cuenta de correo electrónico

account-setup-exchange-config-unverifiable = No se pudo verificar la configuración. Si tu nombre de usuario y contraseña son correctos, es probable que el administrador del servidor haya inhabilitado la configuración seleccionada para tu cuenta. Intenta seleccionar otro protocolo.

account-setup-provisioner-error = Se produjo un error al configurar tu nueva cuenta en { -brand-short-name }. Por favor, intenta configurar manualmente tu cuenta con tus credenciales.

## Manual configuration area

account-setup-manual-config-title = Configuración manual

account-setup-incoming-server-legend = Servidor entrante

account-setup-protocol-label = Protocolo:

account-setup-hostname-label = Nombre del servidor:

account-setup-port-label = Puerto:
    .title = Establecer el número del puerto en 0 para la detección automática

account-setup-auto-description = { -brand-short-name } intentará detectar automáticamente los campos que se dejan en blanco.

account-setup-ssl-label = Seguridad de la conexión:

account-setup-outgoing-server-legend = Servidor de salida

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Autodetectar

ssl-no-authentication-option = Sin autenticación

ssl-cleartext-password-option = Contraseña normal

ssl-encrypted-password-option = Contraseña cifrada

## Incoming/Outgoing SSL options

ssl-noencryption-option = Ninguno

account-setup-auth-label = Método de autenticación:

account-setup-username-label = Nombre de usuario:

account-setup-advanced-setup-button = Configuración avanzada
    .accesskey = a

## Warning insecure server dialog

account-setup-insecure-title = ¡Advertencia!

account-setup-insecure-incoming-title = Configuraciones de entrada:

account-setup-insecure-outgoing-title = Configuraciones de salida:

# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> no usa cifrado.

account-setup-warning-cleartext-details = Los servidores de correo inseguros no utilizan conexiones cifradas para proteger tus contraseñas e información privada. Al conectarse a este servidor, podrías exponer tu contraseña e información privada.

account-setup-insecure-server-checkbox = Entiendo los riesgos
    .accesskey = E

account-setup-insecure-description = { -brand-short-name } puede permitirte llegar a tu correo, utilizando las configuraciones proporcionadas. Sin embargo, debes contactar a tu administrador o proveedor de correo electrónico con respecto a estas conexiones incorrectas. Mira las <a data-l10n-name="thunderbird-faq-link">preguntas frecuentes de Thunderbird</a> para más información.

insecure-dialog-cancel-button = Cambiar la configuración
    .accesskey = o

insecure-dialog-confirm-button = Confirmar
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } encontró la información de configuración de tu cuenta en { $domain }. ¿Quieres continuar y enviar tus credenciales?

exchange-dialog-confirm-button = Iniciar sesión

exchange-dialog-cancel-button = Cancelar

## Dismiss account creation dialog

exit-dialog-title = No se configuró ninguna cuenta de correo electrónico

exit-dialog-description = ¿Estás seguro de que deseas cancelar el proceso de configuración? { -brand-short-name } aún se puede usar sin una cuenta de correo electrónico, pero muchas funciones no estarán disponibles.

account-setup-no-account-checkbox = Usar { -brand-short-name } sin una cuenta de correo electrónico
    .accesskey = U

exit-dialog-cancel-button = Continuar la instalación
    .accesskey = C

exit-dialog-confirm-button = Salir de la configuración
    .accesskey = S

## Alert dialogs

account-setup-creation-error-title = Error al crear la cuenta

account-setup-error-server-exists = El servidor de entrada ya existe.

account-setup-confirm-advanced-title = Confirmar configuración avanzada

account-setup-confirm-advanced-description = Este diálogo se cerrará y se creará una cuenta con la configuración actual, aún cuando la configuración sea incorrecta. ¿Deseas continuar?

## Addon installation section

account-setup-addon-install-title = Instalar

account-setup-addon-install-intro = Un complemento de terceros puede permitirte acceder a tu cuenta de correo electrónico en este servidor:

account-setup-addon-no-protocol = Este servidor de correo desafortunadamente no soporta protocolos abiertos. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Ajustes de la cuenta

account-setup-encryption-button = Cifrado de extremo a extremo

account-setup-signature-button = Agregar una firma

account-setup-dictionaries-button = Descargar diccionarios

account-setup-address-book-carddav-button = Conectarse a una libreta de direcciones CardDAV

account-setup-address-book-ldap-button = Conectarse a una libreta de direcciones LDAP

account-setup-calendar-button = Conectar a un calendario remoto

account-setup-linked-services-title = Conectar tus servicios vinculados

account-setup-linked-services-description = { -brand-short-name } detectó otros servicios vinculados a tu cuenta de correo electrónico.

account-setup-no-linked-description = Configura otros servicios para sacar el máximo partido a tu experiencia de { -brand-short-name }.

# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } encontró una libreta de direcciones vinculada a tu cuenta de correo electrónico.
       *[other] { -brand-short-name } encontró { $count } libretas de direcciones vinculadas a tu cuenta de correo electrónico.
    }

# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } encontró un calendario vinculado a tu cuenta de correo electrónico.
       *[other] { -brand-short-name } encontró { $count } calendarios vinculados a tu cuenta de correo electrónico.
    }

account-setup-button-finish = Finalizar
    .accesskey = F

account-setup-looking-up-address-books = Buscando libretas de direcciones…

account-setup-looking-up-calendars = Buscando calendarios…

account-setup-address-books-button = Libretas de direcciones

account-setup-calendars-button = Calendarios

account-setup-connect-link = Conectar

account-setup-existing-address-book = Conectado
    .title = Libreta de direcciones conectada

account-setup-existing-calendar = Conectado
    .title = Calendario conectado

account-setup-connect-all-calendars = Conectar todos los calendarios

account-setup-connect-all-address-books = Conectar todas las libretas de direcciones

## Calendar synchronization dialog

calendar-dialog-title = Conectar calendario

calendar-dialog-cancel-button = Cancelar
    .accesskey = C

calendar-dialog-confirm-button =
    Conectar
    Conectar
    .accesskey = n

account-setup-calendar-name-label = Nombre

account-setup-calendar-name-input =
    .placeholder = Mi calendario

account-setup-calendar-color-label = Color

account-setup-calendar-refresh-label = Refrescar

account-setup-calendar-refresh-manual = Manualmente

account-setup-calendar-refresh-interval =
    { $count ->
        [one] Cada minuto
       *[other] Cada { $count } minutos
    }

account-setup-calendar-read-only = Sólo lectura
    .accesskey = R

account-setup-calendar-show-reminders = Mostrar recordatorios
    .accesskey = M

account-setup-calendar-offline-support = Soporte sin conexión
    .accesskey = c
