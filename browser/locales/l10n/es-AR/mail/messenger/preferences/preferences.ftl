# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Cerrar

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }

pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Redacción
category-compose =
    .tooltiptext = Redacción

pane-privacy-title = Privacidad y seguridad
category-privacy =
    .tooltiptext = Privacidad y seguridad

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Calendar
category-calendar =
    .tooltiptext = Calendar

general-language-and-appearance-header = Idioma y apariencia

general-incoming-mail-header = Correos electrónicos entrantes

general-files-and-attachment-header = Archivos y adjuntos

general-tags-header = Etiquetas

general-reading-and-display-header = Lectura y visualización

general-updates-header = Actualizaciones

general-network-and-diskspace-header = Red y espacio en el disco

general-indexing-label = Indexación

composition-category-header = Composición

composition-attachments-header = Adjuntos

composition-spelling-title = Ortografía

compose-html-style-title = Estilo HTML

composition-addressing-header = Direccionamiento

privacy-main-header = Privacidad

privacy-passwords-header = Contraseñas

privacy-junk-header = Basura

collection-header = Recolección de datos y uso de { -brand-short-name }

collection-description = Nos esforzamos por proporcionarle opciones y recolectar solamente lo que necesitamos para proveer y mejorar { -brand-short-name } para todos. Siempre pedimos permiso antes de recibir información personal.
collection-privacy-notice = Nota de privacidad

collection-health-report-telemetry-disabled = Ya no permite que { -vendor-short-name } capture datos técnicos y de interacción. Todos los datos anteriores se eliminarán dentro de los 30 días.
collection-health-report-telemetry-disabled-link = Conocer más

collection-health-report =
    .label = Permitir que { -brand-short-name } envíe información técnica y de interacción a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Conocer más

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = El informe de datos está deshabilitado para esta configuración de compilación

collection-backlogged-crash-reports =
    .label = Permitir que { -brand-short-name } envíe informes de fallos pendientes en su nombre
    .accesskey = c
collection-backlogged-crash-reports-link = Conocer más

privacy-security-header = Seguridad

privacy-scam-detection-title = Detección de fraude

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Certificados

chat-pane-header = Chat

chat-status-title = Estado

chat-notifications-title = Notificaciones

chat-pane-styling-header = Estilo

choose-messenger-language-description = Elija los idiomas para mostrar los menús, mensajes y notificaciones de { -brand-short-name }.
manage-messenger-languages-button =
    .label = Establecer alternativas…
    .accesskey = l
confirm-messenger-language-change-description = Reinicie { -brand-short-name } para aplicar estos cambios
confirm-messenger-language-change-button = Aplicar y reiniciar

update-setting-write-failure-title = Error al guardar las preferencias de actualización

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } encontró un error y no guardó este cambio. Tenga en cuenta que la configuración de esta preferencia de actualización requiere permiso para escribir en el archivo que se encuentra a continuación. Es posible que usted o un administrador del sistema puedan resolver el error otorgando el control total de este archivo al grupo de Usuarios.
    
    No se pudo escribir en el archivo: { $path }

update-in-progress-title = Actualización en progreso

update-in-progress-message = ¿Quiere que { -brand-short-name } continúe con esta actualización?

update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar

addons-button = Extensiones & Temas

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para crear una contraseña maestra, ingrese sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crear una contraseña maestra

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear su contraseña maestra, ingrese sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = crear una contraseña maestra

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Página de inicio de { -brand-short-name }

start-page-label =
    .label = Cuando se inicie { -brand-short-name }, mostrar la página de inicio en el área de mensajes
    .accesskey = i

location-label =
    .value = Dirección:
    .accesskey = c
restore-default-label =
    .label = Restaurar predeterminados
    .accesskey = R

default-search-engine = Buscador predeterminado
add-search-engine =
    .label = Agregar desde archivo
    .accesskey = A
remove-search-engine =
    .label = Eliminar
    .accesskey = E

minimize-to-tray-label =
    .label = Cuando { -brand-short-name } está minimizado, muévalo a la bandeja
    .accesskey = m

new-message-arrival = Cuando llegue un nuevo mensaje:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Reproducir el siguiente archivo de sonido:
           *[other] Reproducir un sonido
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] p
        }
mail-play-button =
    .label = Reproducir
    .accesskey = d

change-dock-icon = Cambiar preferencias para el ícono de la aplicación
app-icon-options =
    .label = Opciones de ícono de la aplicación…
    .accesskey = n

notification-settings = Alertas y el sonido predeterminado pueden deshabilitarse en la vista de notificaciones de las preferencias del sistema.

animated-alert-label =
    .label = Mostrar una alerta
    .accesskey = M
customize-alert-label =
    .label = Personalizar…
    .accesskey = z

tray-icon-label =
    .label = Mostrar un ícono en sistema
    .accesskey = t

mail-system-sound-label =
    .label = Sonido predeterminado para nuevo correo
    .accesskey = D
mail-custom-sound-label =
    .label = Usar el siguiente archivo de sonido
    .accesskey = U
mail-browse-sound-button =
    .label = Examinar…
    .accesskey = x

enable-gloda-search-label =
    .label = Habilitar indexado y búsqueda global
    .accesskey = i

datetime-formatting-legend = Formato de fecha y hora
language-selector-legend = Idioma

allow-hw-accel =
    .label = Usar aceleración por hardware cuando esté disponible
    .accesskey = h

store-type-label =
    .value = Tipo de almacenamiento de mensajes para nuevas cuentas:
    .accesskey = T

mbox-store-label =
    .label = Un archivo por carpeta (mbox)
maildir-store-label =
    .label = Un archivo por mensaje (maildir)

scrolling-legend = Desplazamiento
autoscroll-label =
    .label = Usar autodesplazamiento
    .accesskey = U
smooth-scrolling-label =
    .label = Usar desplazamiento suave
    .accesskey = m

system-integration-legend = Integración con el sistema
always-check-default =
    .label = Siempre verificar si { -brand-short-name } es el cliente de correo predeterminado al iniciar
    .accesskey = l
check-default-button =
    .label = Verificar ahora…
    .accesskey = V

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Búsqueda de Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Permitir que { search-engine-name } busque mensajes
    .accesskey = S

config-editor-button =
    .label = Editor de configuración…
    .accesskey = g

return-receipts-description = Determine cómo { -brand-short-name } maneja los acuses de recibo
return-receipts-button =
    .label = Acuses de recibo…
    .accesskey = r

update-app-legend = Actualizaciones de { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versión { $version }

allow-description = Permitir que { -brand-short-name }
automatic-updates-label =
    .label = Instalar actualizaciones automáticamente (recomendado: seguridad aumentada)
    .accesskey = a
check-updates-label =
    .label = Buscar actualizaciones, pero dejarme decidir si las instalo
    .accesskey = c

update-history-button =
    .label = Mostrar historial de actualizaciones
    .accesskey = h

use-service =
    .label = Usar un servicio en segundo plano para instalar actualizaciones
    .accesskey = z

cross-user-udpate-warning = Esta configuración se aplicará a todas las cuentas de Windows y perfiles de { -brand-short-name } usando esta instalación de { -brand-short-name }.

networking-legend = Conexión
proxy-config-description = Configurar cómo { -brand-short-name } se conectará a Internet.

network-settings-button =
    .label = Configuración…
    .accesskey = n

offline-legend = Sin conexión
offline-settings = Configurar las opciones 'Sin conexión'

offline-settings-button =
    .label = Sin conexión…
    .accesskey = S

diskspace-legend = Espacio en disco
offline-compact-folder =
    .label = Compactar carpetas cuando se recuperen más de
    .accesskey = e

compact-folder-size =
    .value = MB en total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Usar hasta
    .accesskey = U

use-cache-after = MB de espacio para caché

##

smart-cache-label =
    .label = Anular administración automática de caché
    .accesskey = u

clear-cache-button =
    .label = Borrar ahora
    .accesskey = B

fonts-legend = Tipografía y colores

default-font-label =
    .value = Tipografía predeterminada:
    .accesskey = d

default-size-label =
    .value = Tamaño:
    .accesskey = T

font-options-button =
    .label = Avanzadas…
    .accesskey = A

color-options-button =
    .label = Colores…
    .accesskey = C

display-width-legend = Mensajes de texto plano

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Mostrar emoticones como gráficos
    .accesskey = g

display-text-label = Cuando se muestren mensajes de texto plano citados:

style-label =
    .value = Estilo:
    .accesskey = E

regular-style-item =
    .label = Regular
bold-style-item =
    .label = Negrita
italic-style-item =
    .label = Itálica
bold-italic-style-item =
    .label = Negrita itálica

size-label =
    .value = Tamaño:
    .accesskey = T

regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Más grande
smaller-size-item =
    .label = Más pequeño

quoted-text-color =
    .label = Color:
    .accesskey = o

search-input =
    .placeholder = Buscar

type-column-label =
    .label = Tipo de contenido
    .accesskey = T

action-column-label =
    .label = Acción
    .accesskey = A

save-to-label =
    .label = Guardar archivos en
    .accesskey = G

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Elegir…
           *[other] Examinar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] x
        }

always-ask-label =
    .label = Preguntarme siempre dónde guardar los archivos
    .accesskey = P


display-tags-text = Las etiquetas pueden ser usadas para categorizar y priorizar sus mensajes.

new-tag-button =
    .label = Nuevo…
    .accesskey = N

edit-tag-button =
    .label = Editar…
    .accesskey = E

delete-tag-button =
    .label = Borrar
    .accesskey = B

auto-mark-as-read =
    .label = Marcar mensajes como leídos automáticamente
    .accesskey = A

mark-read-no-delay =
    .label = Inmediatamente en pantalla
    .accesskey = I

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Después de mostrar por
    .accesskey = D

seconds-label = segundos

##

open-msg-label =
    .value = Abrir mensajes en:

open-msg-tab =
    .label = Una nueva pestaña
    .accesskey = t

open-msg-window =
    .label = Una nueva ventana de mensaje
    .accesskey = n

open-msg-ex-window =
    .label = Una ventana de mensaje existente
    .accesskey = e

close-move-delete =
    .label = Cerrar ventana/pestaña de mensaje al mover o borrar
    .accesskey = C

display-name-label =
    .value = Nombre para mostrar:

condensed-addresses-label =
    .label = Ver solamente el nombre a mostrar para personas en mi libreta de direcciones
    .accesskey = S

## Compose Tab

forward-label =
    .value = Reenviar mensajes:
    .accesskey = m

inline-label =
    .label = Incorporado

as-attachment-label =
    .label = Como adjunto

extension-label =
    .label = Agregar la extensión al nombre de archivo
    .accesskey = n

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Guardar todo automáticamente cada
    .accesskey = u

auto-save-end = minutos

##

warn-on-send-accel-key =
    .label = Confirmar cuando se usan atajos de teclados para enviar mensajes
    .accesskey = C

spellcheck-label =
    .label = Verificar ortografía antes de enviar
    .accesskey = V

spellcheck-inline-label =
    .label = Verificar ortografía mientras se escribe
    .accesskey = e

language-popup-label =
    .value = Idioma:
    .accesskey = I

download-dictionaries-link = Descargar más diccionarios

font-label =
    .value = Tipografía:
    .accesskey = g

font-size-label =
    .value = Tamaño:
    .accesskey = z

default-colors-label =
    .label = Usar los colores predeterminados del lector
    .accesskey = d

font-color-label =
    .value = Color del texto:
    .accesskey = x

bg-color-label =
    .value = Color de fondo:
    .accesskey = f

restore-html-label =
    .label = Restaurar predeterminados
    .accesskey = R

default-format-label =
    .label = Usar formato de párrafo en vez de texto de cuerpo por defecto
    .accesskey = p

format-description = Configurar el comportamiento del formato de texto

send-options-label =
    .label = Opciones de envío…
    .accesskey = O

autocomplete-description = Al escribir una dirección, buscar coincidencias en:

ab-label =
    .label = Libretas de direcciones locales
    .accesskey = d

directories-label =
    .label = Servidor de directorios:
    .accesskey = S

directories-none-label =
    .none = Ninguno

edit-directories-label =
    .label = Editar directorios…
    .accesskey = E

email-picker-label =
    .label = Añadir automáticamente las direcciones de correo salientes a mi:
    .accesskey = s

default-directory-label =
    .value = Directorio de inicio predeterminado en la ventana de la libreta de direcciones:
    .accesskey = s

default-last-label =
    .none = Último directorio usado

attachment-label =
    .label = Comprobar adjuntos faltantes
    .accesskey = j

attachment-options-label =
    .label = Palabras…
    .accesskey = P

enable-cloud-share =
    .label = Ofrecer para compartir archivos de más de
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Agregar…
    .accesskey = A
    .defaultlabel = Agregar…

remove-cloud-account =
    .label = Eliminar
    .accesskey = r

find-cloud-providers =
    .value = Buscar más proveedores…

cloud-account-description = Agregar un nuevo servicio de almacenamiento Filelink


## Privacy Tab

mail-content = Contenido de correo

remote-content-label =
    .label = Permitir contenido remoto en mensajes
    .accesskey = a

exceptions-button =
    .label = Excepciones…
    .accesskey = E

remote-content-info =
    .value = Conozca más sobre los problemas de privacidad del contenido remoto

web-content = Contenido web

history-label =
    .label = Recordar sitios web y enlaces que haya visitado
    .accesskey = R

cookies-label =
    .label = Aceptar cookies de los sitios
    .accesskey = A

third-party-label =
    .value = Aceptar cookies de terceros:
    .accesskey = c

third-party-always =
    .label = Siempre
third-party-never =
    .label = Nunca
third-party-visited =
    .label = De visitados

keep-label =
    .value = Mantener hasta:
    .accesskey = h

keep-expire =
    .label = que expiren
keep-close =
    .label = que cierre { -brand-short-name }
keep-ask =
    .label = preguntarme cada vez

cookies-button =
    .label = Mostrar cookies…
    .accesskey = S

do-not-track-label =
    .label = Enviar a los sitios una señal de “No rastrear” indicando que no quiere ser rastreado
    .accesskey = n

learn-button =
    .label = Conocer más

passwords-description = { -brand-short-name } puede recordar las contraseñas para todas sus cuentas.

passwords-button =
    .label = Contraseñas guardadas…
    .accesskey = s

master-password-description = Una contraseña maestra protege todas sus contraseñas pero deberá ingresarla una vez por sesión.

master-password-label =
    .label = Usar una contraseña maestra
    .accesskey = m

master-password-button =
    .label = Cambiar contraseña maestra…
    .accesskey = C


primary-password-description = Una contraseña maestra protege todas sus contraseñas pero deberá ingresarla una vez por sesión.

primary-password-label =
    .label = Usar una contraseña maestra
    .accesskey = U

primary-password-button =
    .label = Cambiar la contraseña maestra…
    .accesskey = C

forms-primary-pw-fips-title = Se encuentra actualmente en modo FIPS. FIPS requiere una contraseña maestra no vacía.
forms-master-pw-fips-desc = Cambio de contraseña fallido


junk-description = Configuración predeterminada de correo basura. Las configuraciones específicas de cada cuenta deben ser realizadas en Configuración de cuentas.

junk-label =
    .label = Cuando marque mensajes como basura:
    .accesskey = C

junk-move-label =
    .label = Moverlos a la carpeta "Basura" de la cuenta
    .accesskey = o

junk-delete-label =
    .label = Borrarlos
    .accesskey = B

junk-read-label =
    .label = Marcar los mensajes determinados como basura como ya leídos
    .accesskey = a

junk-log-label =
    .label = Habilitar el registro del filtro de basura adaptativo
    .accesskey = g

junk-log-button =
    .label = Mostrar el registro
    .accesskey = s

reset-junk-button =
    .label = Borrar entrenamiento
    .accesskey = B

phishing-description = { -brand-short-name } puede analizar mensajes buscando correos sospechosos de fraude buscando las técnicas más conocidas con que puedan engañarlo.

phishing-label =
    .label = Avisarme si el mensaje que estoy leyendo puede ser una estafa
    .accesskey = e

antivirus-description = { -brand-short-name } puede facilitar a los antivirus que revisen el correo electrónico antes de ser guardados localmente.

antivirus-label =
    .label = Permitir a los antivirus poner en cuarentena mensajes individualmente
    .accesskey = l

certificate-description = Cuando un servidor solicite mi certificado personal:

certificate-auto =
    .label = Seleccionar uno automáticamente
    .accesskey = m

certificate-ask =
    .label = Preguntarme cada vez
    .accesskey = a

ocsp-label =
    .label = Pedir a los servidores respondedores de OCSP que confirmen la validez actual de los certificados
    .accesskey = O

certificate-button =
    .label = Administrar certificados…
    .accesskey = m

security-devices-button =
    .label = Dispositivos de seguridad…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Al iniciar { -brand-short-name }:
    .accesskey = A

offline-label =
    .label = Mantener mis cuentas de chat desconectadas

auto-connect-label =
    .label = Conectar mis cuentas de chat automáticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Dejar que mis contactos sepan que estoy inactivo después de
    .accesskey = i

idle-time-label = minutos de inactividad

##

away-message-label =
    .label = y establecer mi estado como Ausente con el siguiente mensaje de estado:
    .accesskey = A

send-typing-label =
    .label = Enviar notificaciones de tipeo en las notificaciones
    .accesskey = t

notification-label = Cuando lleguen mensajes dirigidos a usted:

show-notification-label =
    .label = Mostrar una notificación
    .accesskey = c

notification-all =
    .label = con nombre de remitente y vista previa de mensaje
notification-name =
    .label = solo con nombre de remitente
notification-empty =
    .label = sin otra información

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animar el ícono del dock
           *[other] Titilar el elemento de la barra de tareas
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] T
        }

chat-play-sound-label =
    .label = Reproducir un sonido
    .accesskey = d

chat-play-button =
    .label = Reproducir
    .accesskey = p

chat-system-sound-label =
    .label = Sonido predeterminado para nuevo correo
    .accesskey = d

chat-custom-sound-label =
    .label = Usar el siguiente archivo de sonido
    .accesskey = U

chat-browse-sound-button =
    .label = Examinar…
    .accesskey = x

theme-label =
    .value = Tema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Burbujas
style-dark =
    .label = Oscuro
style-paper =
    .label = Hojas de papel
style-simple =
    .label = Simple

preview-label = Vista previa:
no-preview-label = Sin vista previa
no-preview-description = Este tema no es válido o actualmente no está disponible (complemento deshabilitado, modo seguro, …).

chat-variant-label =
    .value = Variante:
    .accesskey = V

chat-header-label =
    .label = Mostrar encabezado
    .accesskey = e

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Buscar en Opciones
           *[other] Buscar en Preferencias
        }

## Preferences UI Search Results

search-results-header = Resultados de búsqueda

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] No hay resultados en Preferencias para “<span data-l10n-name="query"></span>”.
       *[other] No hay resultados en Opciones para “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = ¿Necesita ayuda? Visite <a data-l10n-name="url">Ayuda de { -brand-short-name }</a>

## Preferences UI Search Results

