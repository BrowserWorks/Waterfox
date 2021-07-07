# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Header


## Form fields

account-setup-name-label = Tu nombre completo
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe
account-setup-email-label = Dirección de correo electrónico
    .accesskey = D
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-password-toggle-hide =
    .title = Ocultar contraseña

## Action buttons

account-setup-button-cancel = Cancelar
    .accesskey = a
account-setup-button-manual-config = Configurar manualmente
    .accesskey = m
account-setup-button-stop = Detener
    .accesskey = D
account-setup-button-continue = Continuar
    .accesskey = C
account-setup-button-done = Hecho
    .accesskey = H

## Notifications

account-setup-checking-password = Verificando contraseña…

## Illustrations

account-setup-step2-image =
    .title = Cargando…
account-setup-step5-image =
    .title = Cuenta creada
account-setup-selection-error = ¿Necesitas ayuda?
account-setup-documentation-help = Documentación de instalación
account-setup-forum-help = Foro de soporte
account-setup-privacy-help = Política de privacidad
account-setup-getting-started = Comenzar

## Results area

# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-exchange-title = Servidor
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Sin cifrar
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS

## Error messages


## Manual configuration area

account-setup-manual-config-title = Configuración manual
account-setup-protocol-label = Protocolo:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }

## Incoming/Outgoing SSL Authentication options

ssl-encrypted-password-option = Contraseña cifrada

## Incoming/Outgoing SSL options

ssl-noencryption-option = Ninguno
account-setup-advanced-setup-button = Configuración avanzada
    .accesskey = a

## Warning insecure server dialog

account-setup-insecure-title = ¡Advertencia!
insecure-dialog-cancel-button = Cambiar la configuración
    .accesskey = o
insecure-dialog-confirm-button = Confirmar
    .accesskey = C

## Warning Exchange confirmation dialog

exchange-dialog-confirm-button = Iniciar sesión
exchange-dialog-cancel-button = Cancelar

## Dismiss account creation dialog


## Alert dialogs

account-setup-creation-error-title = Error al crear la cuenta

## Addon installation section

account-setup-addon-install-title = Instalar

## Success view

account-setup-signature-button = Agregar una firma
account-setup-dictionaries-button = Descargar diccionarios
account-setup-button-finish = Finalizar
    .accesskey = F
account-setup-address-books-button = Libretas de direcciones
account-setup-calendars-button = Calendarios
account-setup-connect-link = Conectar
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
