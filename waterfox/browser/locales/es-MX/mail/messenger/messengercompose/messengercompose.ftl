# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Formato de envío
    .accesskey = F
compose-send-auto-menu-item =
    .label = Automático
    .accesskey = A
compose-send-both-menu-item =
    .label = Tanto HTML como Texto sin formato
    .accesskey = B
compose-send-html-menu-item =
    .label = Solo HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Solo Texto sin formato
    .accesskey = P

## Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Eliminar el campo { $type }
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } con una dirección, usa la tecla de flecha izquierda para enfocarte en ella.
       *[other] { $type } con { $count } direcciones, usa la tecla de flecha izquierda para enfocarte en ellas.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: presiona Enter para editar, Borrar para eliminar.
       *[other] { $email }, 1 de { $count }: presiona Enter para editar, Eliminar para eliminar.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } no es una dirección de correo electrónico válida
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } no está en tu libreta de direcciones
pill-action-edit =
    .label = Editar dirección
    .accesskey = E
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Seleccionar todas las direcciones en { $type }
    .accesskey = A
pill-action-select-all-pills =
    .label = Seleccionar todas las direcciones
    .accesskey = S
pill-action-move-to =
    .label = Mover a Para
    .accesskey = M
pill-action-move-cc =
    .label = Mover a Cc
    .accesskey = C
pill-action-move-bcc =
    .label = Mover a Cco
    .accesskey = C
pill-action-expand-list =
    .label = Expandir lista
    .accesskey = x

## Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Mayús+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Panel de adjuntos
    .accesskey = e
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Adjuntar
    .tooltiptext = Agregar un adjunto ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder2 =
    .label = Agregar un archivo adjunto…
    .accesskey = A
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Archivo(s)…
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Adjuntar archivo(s)…
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Mi vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = Mi clave pública OpenPGP
    .accesskey = c
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } adjunto
        [one] { $count } adjuntos
       *[other] { $count } adjuntos
    }
attachment-area-show =
    .title = Mostrar el panel de adjuntos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Ocultar el panel de adjuntos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Agregar como adjunto
       *[other] Agregar como adjuntos
    }
drop-file-label-inline =
    { $count ->
        [one] Insertar en línea
       *[other] Insertar en línea
    }

## Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Mover al inicio
move-attachment-left-panel-button =
    .label = Mover a la izquierda
move-attachment-right-panel-button =
    .label = Mover a la derecha
move-attachment-last-panel-button =
    .label = Mover al último
button-return-receipt =
    .label = Recibo
    .tooltiptext = Solicitar un de recibo de respuesta para este mensaje

## Encryption

encryption-menu =
    .label = Seguridad
    .accesskey = g
encryption-toggle =
    .label = Cifrar
    .tooltiptext = Usar cifrado de extremo a extremo para este mensaje.
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Ver o cambiar la configuración de cifrado de OpenPGP
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Ver o cambiar la configuración de cifrado de S/MIME
signing-toggle =
    .label = Firma
    .tooltiptext = Usar firma digital para este mensaje
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Cifrar
    .accesskey = C
menu-encrypt-subject =
    .label = Cifrar asunto
    .accesskey = B
menu-sign =
    .label = Firmar digitalmente
    .accesskey = i
menu-manage-keys =
    .label = Asistente de claves
    .accesskey = A
menu-view-certificates =
    .label = Ver certificados de destinatarios
    .accesskey = V
menu-open-key-manager =
    .label = Gestor de claves
    .accesskey = G
openpgp-key-issue-notification-one = El cifrado de extremo a extremo requiere resolver problemas clave para { $addr }
openpgp-key-issue-notification-many = El cifrado de extremo a extremo requiere resolver problemas de claves para { $count } destinatarios.
smime-cert-issue-notification-one = El cifrado de extremo a extremo requiere resolver problemas de certificados para { $addr }.
smime-cert-issue-notification-many = El cifrado de extremo a extremo requiere resolver problemas de certificados para { $count } destinatarios.
key-notification-disable-encryption =
    .label = No cifrar
    .accesskey = N
    .tooltiptext = Deshabilitar el cifrado de extremo a extremo
key-notification-resolve =
    .label = Resolver…
    .accesskey = R
    .tooltiptext = Abrir el asistente de claves de OpenPGP
can-encrypt-smime-notification = Es posible usar el cifrado de extremo a extremo S/MIME.
can-encrypt-openpgp-notification = Es posible usar el cifrado de extremo a extremo OpenPGP.
can-e2e-encrypt-button =
    .label = Cifrado
    .accesskey = E

## Addressing Area

to-address-row-label =
    .value = Para
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Campo para
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Para
    .accesskey = P
#   $key (String) - the shortcut key for this field
show-to-row-button = Para
    .title = Mostrar campo Para ({ ctrl-cmd-shift-pretty-prefix })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Campo Cc
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Mostrar campo Cc ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Cco
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Campo Cco
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Cco
    .accesskey = B
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Cco
    .title = Mostrar campo Cco ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Otros campos de direcciones para mostrar
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Tu mensaje tiene un destinatario público. Puedes evitar la divulgación de destinatarios utilizando Cco en su lugar.
       *[other] Los destinatarios de { $count } en Para y Cc verán la dirección de cada uno. Puedes evitar la divulgación de destinatarios utilizando Cco en su lugar.
    }
many-public-recipients-bcc =
    .label = Utiliza Cco en su lugar
    .accesskey = U
many-public-recipients-ignore =
    .label = Mantener públicos a los destinatarios
    .accesskey = M
many-public-recipients-prompt-title = Demasiados destinatarios públicos
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Tu mensaje tiene un destinatario público. Esto puede ser un problema de privacidad. Puedes evitar esto moviendo el destinatario de Para/Cc a Cco en su lugar.
       *[other] Tu mensaje tiene { $count } destinatarios públicos, que podrán ver las direcciones de los demás. Esto puede ser un problema de privacidad. Puedes evitar revelar los destinatarios moviendo los destinatarios de Para/Cc a Cco en su lugar.
    }
many-public-recipients-prompt-cancel = Cancelar envío
many-public-recipients-prompt-send = Enviar de todos modos

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = No se encontró una identidad única que coincida con la dirección del remitente. El mensaje se enviará usando el remitente actual y la configuración de la identidad { $identity }.
encrypted-bcc-warning = Al enviar un mensaje cifrado, los destinatarios en Cco no están completamente ocultos. Todos los destinatarios pueden identificarlos.
encrypted-bcc-ignore-button = Entendido

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Eliminar estilo de texto

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Subido a una cuenta de Filelink desconocida.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = Adjunto de Filelink - { $filename }
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = El archivo { $filename } se adjuntó como Filelink. Se puede descargar desde el siguiente enlace.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] He vinculado el archivo { $count } a este correo electrónico:
       *[other] He vinculado { $count } archivos a este correo electrónico:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Saber más acerca de { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Saber más sobre { $firstLinks } y { $lastLink }
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Enlace protegido por contraseña
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Servicio de Filelink:
cloud-file-template-size = Tamaño:
cloud-file-template-link = Enlace:
cloud-file-template-password-protected-link = Enlace protegido por contraseña:
cloud-file-template-expiry-date = Fecha de expiración:
cloud-file-template-download-limit = Límite de descarga:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Error de conexión
cloud-file-connection-error = { -brand-short-name } está desconectado. No se pudo conectar con { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = No se pudo cargar { $filename } a { $provider }
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Error al renombrar
cloud-file-rename-error = Hubo un problema al cambiar el nombre de { $filename } en { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = No se pudo renombrar { $filename } en { $provider }
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } no admite el cambio de nombre de archivos ya cargados.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Error del adjunto de Filelink
cloud-file-attachment-error = No se pudo actualizar el archivo adjunto de Filelink { $filename }, porque tu archivo local se movió o eliminó.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Error en la cuenta de Filelink
cloud-file-account-error = No se pudo actualizar el archivo adjunto de Filelink { $filename }, porque se ha eliminado tu cuenta de Filelink.

## Link Preview

link-preview-title = Vista previa del enlace
link-preview-description = { -brand-short-name } puede agregar una vista previa incrustrada al pegar enlaces.
link-preview-autoadd = Agregar automáticamente vista previas de enlaces cuando sea posible
link-preview-replace-now = ¿Agregar vista para este enlace?
link-preview-yes-replace = Sí

## Dictionary selection popup

spell-add-dictionaries =
    .label = Agregar diccionarios…
    .accesskey = A
