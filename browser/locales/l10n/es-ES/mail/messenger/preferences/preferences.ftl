# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Cerrar

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

pane-calendar-title = Calendario
category-calendar =
    .tooltiptext = Calendario

general-language-and-appearance-header = Idioma y apariencia

general-incoming-mail-header = Mensajes entrantes

general-files-and-attachment-header = Archivos y adjuntos

general-tags-header = Etiquetas

general-reading-and-display-header = Lectura y visualización

general-updates-header = Actualizaciones

general-network-and-diskspace-header = Red y espacio en disco

general-indexing-label = Indexado

composition-category-header = Redacción

composition-attachments-header = Adjuntos

composition-spelling-title = Ortografía

compose-html-style-title = Estilo HTML

composition-addressing-header = Direcciones

privacy-main-header = Privacidad

privacy-passwords-header = Contraseña

privacy-junk-header = Correo basura

collection-header = Recopilación y uso de datos de { -brand-short-name }

collection-description = Nos esforzamos en proporcionarle opciones y recopilar solo lo necesario para proporcionarle { -brand-short-name } y mejorarlo para todos. Siempre solicitamos permiso antes de recibir información personal.
collection-privacy-notice = Aviso de privacidad

collection-health-report-telemetry-disabled = Ha dejado de permitir a { -vendor-short-name } capturar datos técnicos y de interacción. Todos los datos pasados se eliminarán en 30 días.
collection-health-report-telemetry-disabled-link = Más información

collection-health-report =
    .label = Permitir a { -brand-short-name } enviar datos técnicos y de interacción a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Más información

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = El envío de datos está desactivado en la configuración de este binario

collection-backlogged-crash-reports =
    .label = Permitir a { -brand-short-name } enviar informes de fallo registrados en su nombre
    .accesskey = c
collection-backlogged-crash-reports-link = Más información

privacy-security-header = Seguridad

privacy-scam-detection-title = Detección de fraude

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Certificados

chat-pane-header = Chat

chat-status-title = Estado

chat-notifications-title = Notificaciones

chat-pane-styling-header = Estilo

choose-messenger-language-description = Elija los idiomas usados para mostrar los menús, mensajes y notificaciones de { -brand-short-name }.
manage-messenger-languages-button =
  .label = Configurar alternativas…
  .accesskey = u
confirm-messenger-language-change-description = Reinicie { -brand-short-name } para aplicar los cambios
confirm-messenger-language-change-button = Aplicar y reiniciar

update-setting-write-failure-title = Error al guardar las preferencias de actualización

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } ha encontrado un error y no ha grabado este cambio. Tenga en cuenta que cambiar esta preferencia de actualización requiere permisos para escribir en el archivo de debajo. Usted o un administrador de sistemas pueden resolver el error concediendo al grupo Usuarios control completo sobre este archivo.

    No se puede escribir en el archivo: { $path }

update-in-progress-title = Actualización en progreso

update-in-progress-message = ¿Quiere que { -brand-short-name } continúe con esta actualización?

update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear una contraseña principal, introduzca sus credenciales de inicio de sesión en Windows. Esto ayuda a proteger la seguridad de sus cuentas.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = crear una contraseña principal

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Página de inicio de { -brand-short-name }

start-page-label =
    .label = Al iniciarse { -brand-short-name }, mostrar la página de inicio en el área de mensajes
    .accesskey = i

location-label =
    .value = Dirección:
    .accesskey = D
restore-default-label =
    .label = Rest. valores predet.
    .accesskey = R

default-search-engine = Buscador predeterminado
add-search-engine =
    .label = Añadir desde archivo
    .accesskey = s
remove-search-engine =
    .label = Eliminar
    .accesskey = l

minimize-to-tray-label =
    .label = Cuando se minimiza { -brand-short-name }, moverlo a la bandeja del sistema
    .accesskey = m

new-message-arrival = Cuando lleguen mensajes nuevos:
mail-play-sound-label =
    .label = { PLATFORM() ->
            [macos] Reproducir el siguiente archivo de sonido:
           *[other] Reproducir un sonido
        }
    .accesskey = o
mail-play-button =
    .label = Reproducir
    .accesskey = r

change-dock-icon = Cambiar preferencias del icono de la aplicación
app-icon-options =
    .label = Opciones del icono de la aplicación…
    .accesskey = c

notification-settings = Las alertas y el sonido predeterminado pueden desactivarse en el panel Notificaciones de las preferencias del sistema.

animated-alert-label =
    .label = Mostrar una alerta
    .accesskey = M
customize-alert-label =
    .label = Personalizar…
    .accesskey = P

mail-system-sound-label =
    .label = Sonido del sistema predeterminado para correo nuevo
    .accesskey = S
mail-custom-sound-label =
    .label = Usar el siguiente archivo de sonido
    .accesskey = U
mail-browse-sound-button =
    .label = Examinar…
    .accesskey = x

enable-gloda-search-label =
    .label = Activar indexador y búsqueda global
    .accesskey = A

datetime-formatting-legend = Formato de fecha y hora
language-selector-legend = Idioma

allow-hw-accel =
    .label = Usar aceleración hardware cuando esté disponible
    .accesskey = h

store-type-label =
    .value = Tipo de almacenamiento de mensajes para las nuevas cuentas:
    .accesskey = T

mbox-store-label =
    .label = Archivo por carpeta (mbox)
maildir-store-label =
    .label = Archivo por mensaje (maildir)

scrolling-legend = Desplazamiento
autoscroll-label =
    .label = Usar desplazamiento automático
    .accesskey = U
smooth-scrolling-label =
    .label = Usar desplazamiento suave
    .accesskey = d

system-integration-legend = Integración con el sistema
always-check-default =
    .label = Comprobar siempre al iniciar si { -brand-short-name } es el cliente de correo por omisión
    .accesskey = C
check-default-button =
    .label = Comprobar ahora…
    .accesskey = b

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name = { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Permitir que { search-engine-name } busque en los mensajes
    .accesskey = P

config-editor-button =
    .label = Editor de configuración…
    .accesskey = E

return-receipts-description = Determinar cómo gestiona { -brand-short-name } los acuses de recibo
return-receipts-button =
    .label = Acuses de recibo…
    .accesskey = r

update-app-legend = Actualizaciones de { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versión { $version }

allow-description = Permitir a { -brand-short-name }
automatic-updates-label =
    .label = Instalar actualizaciones automáticamente (recomendado: mejora la seguridad)
    .accesskey = I
check-updates-label =
    .label = Buscar actualizaciones, pero permitirme elegir si las instalo
    .accesskey = B

update-history-button =
    .label = Mostrar historial de actualizaciones
    .accesskey = M

use-service =
    .label = Usar un servicio en segundo plano para instalar actualizaciones
    .accesskey = v

cross-user-udpate-warning = Este ajuste se aplicará a todas las cuentas de Windows y a todos los perfiles de { -brand-short-name } que usen esta instalación de { -brand-short-name }.

networking-legend = Conexión
proxy-config-description = Configurar cómo se conecta { -brand-short-name } a Internet

network-settings-button =
    .label = Configuración…
    .accesskey = C

offline-legend = Sin conexión
offline-settings = Configurar modo sin conexión

offline-settings-button =
    .label = Sin conexión…
    .accesskey = S

diskspace-legend = Espacio en disco
offline-compact-folder =
    .label = Compactar todas las carpetas cuando se ahorren más de
    .accesskey = C

compact-folder-size =
    .value = MB en total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Usar hasta
    .accesskey = U

use-cache-after = MB de espacio para la caché

##

smart-cache-label =
    .label = Desactivar administración automática de caché
    .accesskey = D

clear-cache-button =
    .label = Limpiar ahora
    .accesskey = L

fonts-legend = Tipografías y colores

default-font-label =
    .value = Tipo de letra predeterminado:
    .accesskey = i

default-size-label =
    .value = Tamaño:
    .accesskey = T

font-options-button =
    .label = Avanzadas…
    .accesskey = v

color-options-button =
    .label = Colores…
    .accesskey = C

display-width-legend = Mensajes de texto sin formato

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Mostrar emoticones como gráficos
    .accesskey = M

display-text-label = Al mostrar mensajes citados de texto sin formato:

style-label =
    .value = Estilo:
    .accesskey = E

regular-style-item =
    .label = Normal
bold-style-item =
    .label = Negrita
italic-style-item =
    .label = Cursiva
bold-italic-style-item =
    .label = Negrita cursiva

size-label =
    .value = Tamaño:
    .accesskey = a

regular-size-item =
    .label = Normal
bigger-size-item =
    .label = Mayor
smaller-size-item =
    .label = Menor

quoted-text-color =
    .label = Color:
    .accesskey = o

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
    .label = { PLATFORM() ->
            [macos] Elegir…
           *[other] Examinar…
        }
    .accesskey = { PLATFORM() ->
            [macos] E
           *[other] x
        }

always-ask-label =
    .label = Preguntarme siempre dónde guardar archivos
    .accesskey = P


display-tags-text = Las etiquetas pueden usarse para categorizar y priorizar sus mensajes.

new-tag-button =
    .label = Nuevo…
    .accesskey = N

edit-tag-button =
    .label = Editar…
    .accesskey = E

delete-tag-button =
    .label = Eliminar
    .accesskey = r

auto-mark-as-read =
    .label = Marcar automáticamente mensajes como leídos
    .accesskey = A

mark-read-no-delay =
    .label = Inmediatamente tras mostrarlo
    .accesskey = n

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Tras mostrarlo durante
    .accesskey = d

seconds-label = segundos

##

open-msg-label =
    .value = Abrir mensajes en:

open-msg-tab =
    .label = Una pestaña nueva
    .accesskey = U

open-msg-window =
    .label = Una ventana mens. nueva
    .accesskey = v

open-msg-ex-window =
    .label = Una ventana mens. existente
    .accesskey = s

close-move-delete =
    .label = Cerrar ventana/pestaña del mensaje al moverlo o eliminarlo
    .accesskey = C

display-name-label =
    .value = Nombre mostrado:

condensed-addresses-label =
    .label = Mostrar sólo el atributo 'nombre mostrado' para las personas de mi libreta de direcciones
    .accesskey = b

## Compose Tab

forward-label =
    .value = Reenviar mensajes:
    .accesskey = m

inline-label =
    .label = Incorporados

as-attachment-label =
    .label = Como adjuntos

extension-label =
    .label = Añadir extensión al nombre de archivo
    .accesskey = A

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Guardar automáticamente cada
    .accesskey = G

auto-save-end = minutos

##

warn-on-send-accel-key =
    .label = Confirmar al usar el atajo de teclado para envío de mensajes
    .accesskey = n

spellcheck-label =
    .label = Comprobar la ortografía antes de enviar
    .accesskey = C

spellcheck-inline-label =
    .label = Activar corrección ortográfica al escribir
    .accesskey = v

language-popup-label =
    .value = Idioma:
    .accesskey = I

download-dictionaries-link = Descargar más diccionarios

font-label =
    .value = Tipo de letra:
    .accesskey = T

font-size-label =
    .value = Tamaño:
    .accesskey = m

default-colors-label =
    .label = Usar los colores predeterminados del lector
    .accesskey = d

font-color-label =
    .value = Color del texto:
    .accesskey = x

bg-color-label =
    .value = Color de fondo:
    .accesskey = C

restore-html-label =
    .label = Restaurar valores predeterminados
    .accesskey = R

default-format-label =
    .label = Usar formato de párrafo en lugar de cuerpo de texto por omisión
    .accesskey = P

format-description = Configurar comportamiento del formato de texto

send-options-label =
    .label = Opciones de envío…
    .accesskey = v

autocomplete-description = Al enviar mensajes, buscar entradas coincidentes en:

ab-label =
    .label = Libretas de direcciones locales
    .accesskey = L

directories-label =
    .label = Servidor de directorio:
    .accesskey = S

directories-none-label =
    .none = Ninguno

edit-directories-label =
    .label = Editar directorios…
    .accesskey = E

email-picker-label =
    .label = Añadir automáticamente las direcciones de correo saliente a mi(s):
    .accesskey = A

default-directory-label =
    .value = Directorio de inicio por omisión en la ventana de la libreta de direcciones:
    .accesskey = D

default-last-label =
    .none = Último directorio usado

attachment-label =
    .label = Comprobar adjuntos olvidados
    .accesskey = b

attachment-options-label =
    .label = Palabras clave…
    .accesskey = P

enable-cloud-share =
    .label = Ofrecerlo para compartir archivos mayores de
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Añadir…
    .accesskey = d
    .defaultlabel = Añadir…

remove-cloud-account =
    .label = Eliminar
    .accesskey = m

find-cloud-providers =
    .value = Buscar más proveedores…

cloud-account-description = Añadir un nuevo servicio de almacenamiento Filelink


## Privacy Tab

mail-content = Contenido de correo

remote-content-label =
    .label = Permitir contenido remoto en los mensajes
    .accesskey = P

exceptions-button =
    .label = Excepciones…
    .accesskey = n

remote-content-info =
    .value = Saber más sobre los problemas de privacidad del contenido remoto

web-content = Contenido web

history-label =
    .label = Recordar sitios web y enlaces que he visitado
    .accesskey = R

cookies-label =
    .label = Aceptar cookies de los sitios
    .accesskey = A

third-party-label =
    .value = Aceptar cookies de terceros:
    .accesskey = d

third-party-always =
    .label = Siempre
third-party-never =
    .label = Nunca
third-party-visited =
    .label = De sitios visitados

keep-label =
    .value = Conservar hasta que:
    .accesskey = C

keep-expire =
    .label = caduquen
keep-close =
    .label = cierre { -brand-short-name }
keep-ask =
    .label = preguntarme cada vez

cookies-button =
    .label = Mostrar cookies…
    .accesskey = M

do-not-track-label =
    .label = Enviar a los sitios web una señal "No rastrear" de que no quiere ser rastreado
    .accesskey = n

learn-button =
    .label = Saber más

passwords-description = { -brand-short-name } puede recordar las contraseñas de todas sus cuentas.

passwords-button =
    .label = Contraseñas guardadas…
    .accesskey = C


primary-password-description = Una contraseña principal protege todas sus contraseñas, pero debe introducirla una vez por sesión.

primary-password-label =
    .label = Usar una contraseña principal
    .accesskey = U

primary-password-button =
    .label = Cambiar contraseña principal…
    .accesskey = C

forms-primary-pw-fips-title = En este momento está en modo FIPS. FIPS exige una contraseña principal no vacía.
forms-master-pw-fips-desc = Cambio de contraseña fallido


junk-description = Establezca su configuración predeterminada para el correo no deseado. La configuración específica de cada cuenta puede realizarse en Configuración de las cuentas.

junk-label =
    .label = Cuando marco los mensajes como no deseados:
    .accesskey = C

junk-move-label =
    .label = Moverlos a la carpeta "Correo no deseado" de la cuenta
    .accesskey = o

junk-delete-label =
    .label = Eliminarlos
    .accesskey = E

junk-read-label =
    .label = Marcar como leídos los mensajes calificados como no deseados
    .accesskey = M

junk-log-label =
    .label = Activar el registro del filtro adaptativo de correo basura
    .accesskey = A

junk-log-button =
    .label = Mostrar el registro
    .accesskey = s

reset-junk-button =
    .label = Reiniciar datos de entrenamiento
    .accesskey = R

phishing-description = { -brand-short-name } puede analizar mensajes para identificar los que sean fraudulentos buscando técnicas comunes usadas para engañarle.

phishing-label =
    .label = Decirme si el mensaje que estoy leyendo parece un mensaje fraudulento
    .accesskey = D

antivirus-description = { -brand-short-name } puede hacer fácilmente que el software antivirus analice el correo entrante en busca de virus antes de que se guarde localmente.

antivirus-label =
    .label = Permitir a los antivirus poner en cuarentena mensajes individuales
    .accesskey = P

certificate-description = Cuando un servidor solicite mi certificado personal:

certificate-auto =
    .label = Seleccionar uno automáticamente
    .accesskey = S

certificate-ask =
    .label = Preguntarme cada vez
    .accesskey = P

ocsp-label =
    .label = Preguntar a los servidores respondedores de OCSP para confirmar la validez actual de los certificados
    .accesskey = u

certificate-button =
    .label = Administrar certificados…
    .accesskey = M

security-devices-button =
    .label = Dispositivos de seguridad…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Al iniciar { -brand-short-name }:
    .accesskey = A

offline-label =
    .label = Mantener mis cuentas de chat no conectadas

auto-connect-label =
    .label = Conectar a mis cuentas automáticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Permitir a mis contactos saber que estoy inactivo tras
    .accesskey = P

idle-time-label = minutos de inactividad

##

away-message-label =
    .label = y establecer mi estado en Ausente con este mensaje de estado:
    .accesskey = b

send-typing-label =
    .label = Enviar notificaciones de escritura en conversaciones
    .accesskey = E

notification-label = Cuando lleguen mensajes dirigidos a usted:

show-notification-label =
    .label = Mostrar una notificación:
    .accesskey = M

notification-all =
    .label = con el nombre del remitente y una vista preliminar del mensaje
notification-name =
    .label = con el nombre del remitente únicamente
notification-empty =
    .label = sin ninguna información

notification-type-label =
    .label = { PLATFORM() ->
            [macos] Animar icono del dock
           *[other] Hacer parpadear el elemento de la barra de tareas
        }
    .accesskey = { PLATFORM() ->
            [macos] d
           *[other] H
        }

chat-play-sound-label =
    .label = Reproducir un sonido
    .accesskey = R

chat-play-button =
    .label = Reproducir
    .accesskey = c

chat-system-sound-label =
    .label = Sonido predeterminado del sistema para nuevo correo
    .accesskey = S

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

preview-label = Vista preliminar:
no-preview-label = No está disponible la vista preliminar
no-preview-description = Este tema no es válido o no está actualmente disponible (complemento desactivado, modo seguro…).

chat-variant-label =
    .value = Vaiante:
    .accesskey = V

## Preferences UI Search Results

search-results-header = Resultados de la búsqueda

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message = { PLATFORM() ->
    [windows] ¡Lo sentimos! No hay resultados en Opciones para “<span data-l10n-name="query"></span>”.
    *[other] ¡Lo sentimos! No hay resultados en Preferencias para “<span data-l10n-name="query"></span>”.
}

search-results-help-link = ¿Necesita ayuda? Visite la ayuda de <a data-l10n-name="url">{ -brand-short-name }</a>
