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
preferences-tab-title =
    .title = Preferencias
preferences-doc-title = Preferencias
category-list =
    .aria-label = Categorías
pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Composición
category-compose =
    .tooltiptext = Composición
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
general-incoming-mail-header = Correos entrantes
general-files-and-attachment-header = Archivos y adjuntos
general-tags-header = Etiquetas
general-reading-and-display-header = Lectura y visualización
general-updates-header = Actualizaciones
general-network-and-diskspace-header = Red y espacio en el disco
general-indexing-label = Indexado
composition-category-header = Composición
composition-attachments-header = Adjuntos
composition-spelling-title = Ortografía
compose-html-style-title = Estilo HTML
composition-addressing-header = Direccionamiento
privacy-main-header = Privacidad
privacy-passwords-header = Contraseñas
privacy-junk-header = Basura
collection-header = { -brand-short-name } Recolección y uso de datos
collection-description = Nos esforzamos en proveerte opciones y recolectar sólo lo que necesitamos para mantener disponible y mejorar { -brand-short-name } para todos. Siempre pedimos permiso antes de recibir información personal.
collection-privacy-notice = Aviso de privacidad
collection-health-report-telemetry-disabled = Ya no estás permitiendo a { -vendor-short-name } capturar datos técnicos y de interacción. Todos los datos anteriores serán eliminados dentro de 30 días.
collection-health-report-telemetry-disabled-link = Saber más
collection-health-report =
    .label = Permitir a { -brand-short-name } enviar datos técnicos y de interacción a { -vendor-short-name }
    .accesskey = P
collection-health-report-link = Saber más
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = El reporte de datos está deshabilitado para esta configuración de compilación
collection-backlogged-crash-reports =
    .label = Permitir a { -brand-short-name } enviar reportes de fallas pasadas en su nombre
    .accesskey = P
collection-backlogged-crash-reports-link = Saber más
privacy-security-header = Seguridad
privacy-scam-detection-title = Detección de fraude
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certificados
chat-pane-header = Chat
chat-status-title = Estatus
chat-notifications-title = Notificaciones
chat-pane-styling-header = Estilo
choose-messenger-language-description = Elige los idiomas para mostrar los menús, mensajes y notificaciones de { -brand-short-name }.
manage-messenger-languages-button =
    .label = Establecer alternativas…
    .accesskey = l
confirm-messenger-language-change-description = Reiniciar { -brand-short-name } para aplicar estos cambios
confirm-messenger-language-change-button = Aplicar y reiniciar
update-setting-write-failure-title = Error al guardar las preferencias de actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } encontró un error y no guardó este cambio. Ten en cuenta que la configuración de esta preferencia de actualización requiere permiso para escribir en el archivo que se encuentra a continuación. Es posible que tú o un administrador del sistema puedan resolver el error otorgando el control total de este archivo al grupo de Usuarios.
    
    No se pudo escribir en el archivo: { $path }
update-in-progress-title = Actualización en progreso
update-in-progress-message = ¿Quieres que { -brand-short-name } continúe con esta actualización?
update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar
addons-button = Extensiones y temas
account-button = Configuración de la cuenta
open-addons-sidebar-button = Complementos y temas

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para crear una contraseña maestra, proporciona tus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de tus cuentas.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crear una contraseña maestra
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear una contraseña principal, proporciona los datos de acceso de Windows. Esto ayuda a proteger la seguridad de las cuentas.
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
    .label = Cuando se inicia { -brand-short-name }, mostrar la página de inicio en el área de mensajes
    .accesskey = W
location-label =
    .value = Ubicación:
    .accesskey = o
restore-default-label =
    .label = Restaurar Predeterminado
    .accesskey = R
default-search-engine = Motor de búsqueda predeterminado
add-search-engine =
    .label = Agregar desde archivo
    .accesskey = A
remove-search-engine =
    .label = Eliminar
    .accesskey = v
minimize-to-tray-label =
    .label = Mover { -brand-short-name } a la bandeja cuando es minimizado
    .accesskey = m
new-message-arrival = Cuando los mensajes lleguen:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Reproducir el siguiente archivo de sonido:
           *[other] Reproducir un sonido
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = Reproducir
    .accesskey = P
change-dock-icon = Cambiar las preferencias para el ícono de la aplicación
app-icon-options =
    .label = Opciones de íconos de la aplicación…
    .accesskey = n
notification-settings = Alertas y el sonido predeterminado pueden deshabilitarse en la vista de notificaciones de las preferencias del sistema.
animated-alert-label =
    .label = Mostrar una alerta
    .accesskey = S
customize-alert-label =
    .label = Personalizar…
    .accesskey = C
tray-icon-label =
    .label = Mostrar un icono de bandeja
    .accesskey = t
biff-use-system-alert =
    .label = Usar la notificación del sistema
tray-icon-unread-label =
    .label = Mostrar un ícono en la bandeja para mensajes no leídos
    .accesskey = t
tray-icon-unread-description = Recomendado al usar botones pequeños en la barra de tareas
mail-system-sound-label =
    .label = Sonido predeterminado del sistema para nuevo correo
    .accesskey = D
mail-custom-sound-label =
    .label = Usar el siguiente archivo de sonido
    .accesskey = U
mail-browse-sound-button =
    .label = Examinar…
    .accesskey = B
enable-gloda-search-label =
    .label = Habilitar indexado y búsqueda global
    .accesskey = G
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
system-integration-legend = Integración de sistema
always-check-default =
    .label = Siempre verificar si { -brand-short-name } es el cliente de correo predeterminado al iniciar
    .accesskey = A
check-default-button =
    .label = Verificar ahora…
    .accesskey = N
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Destacar
        [windows] Ventana de búsqueda
       *[other] { "" }
    }
search-integration-label =
    .label = Permitir que { search-engine-name } busque mensajes
    .accesskey = S
config-editor-button =
    .label = Configurar editor…
    .accesskey = C
return-receipts-description = Determinar cómo { -brand-short-name } maneja los acuses de recibo
return-receipts-button =
    .label = Acuses de recibo…
    .accesskey = R
update-app-legend = Actualizaciones de { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versión { $version }
allow-description = Permitir que { -brand-short-name }
automatic-updates-label =
    .label = Instalar actualizaciones automáticamente (recomendado: seguridad aumentada)
    .accesskey = A
check-updates-label =
    .label = Buscar actualizaciones, pero dejarme decidir si las instalo
    .accesskey = C
update-history-button =
    .label = Mostrar historial de actualizaciones
    .accesskey = p
use-service =
    .label = Usar un servicio en segundo plano para instalar actualizaciones
    .accesskey = b
cross-user-udpate-warning = Esta configuración se aplicará a todas las cuentas de Windows y perfiles de { -brand-short-name } usando esta instalación de { -brand-short-name }.
networking-legend = Conexión
proxy-config-description = Configurar cómo { -brand-short-name } se conecta a Internet
network-settings-button =
    .label = Configuración…
    .accesskey = S
offline-legend = Sin conexión
offline-settings = Configurar ajustes sin conexión
offline-settings-button =
    .label = Sin conexión…
    .accesskey = O
diskspace-legend = Espacio en disco
offline-compact-folder =
    .label = Compactar carpetas cuando se recuperen más de
    .accesskey = a
compact-folder-size =
    .value = MB en total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Utilizar hasta
    .accesskey = U
use-cache-after = MB de espacio para el caché

##

smart-cache-label =
    .label = Anular la administración automática de caché
    .accesskey = v
clear-cache-button =
    .label = Limpiar ahora
    .accesskey = C
fonts-legend = Fuentes & colores
default-font-label =
    .value = Fuente predeterminada:
    .accesskey = D
default-size-label =
    .value = Tamaño:
    .accesskey = S
font-options-button =
    .label = Avanzado…
    .accesskey = A
color-options-button =
    .label = Colores…
    .accesskey = C
display-width-legend = Mensajes de texto plano
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Mostrar emoticones como gráficos
    .accesskey = e
display-text-label = Cuando se muestren mensajes de texto plano citados:
style-label =
    .value = Estilo:
    .accesskey = y
regular-style-item =
    .label = Regular
bold-style-item =
    .label = Negrita
italic-style-item =
    .label = Cursiva
bold-italic-style-item =
    .label = Negrita cursiva
size-label =
    .value = Tamaño:
    .accesskey = z
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
search-handler-table =
    .placeholder = Filtrar tipos de contenido y acciones
type-column-label =
    .label = Tipo de contenido
    .accesskey = T
action-column-label =
    .label = Acción
    .accesskey = A
save-to-label =
    .label = Guardar archivos en
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Seleccionar…
           *[other] Buscar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
always-ask-label =
    .label = Siempre preguntarme dónde guardar los archivos
    .accesskey = A
display-tags-text = Las etiquetas pueden ser usadas para categorizar y priorizar tus mensajes.
new-tag-button =
    .label = Nuevo…
    .accesskey = N
edit-tag-button =
    .label = Editar…
    .accesskey = E
delete-tag-button =
    .label = Eliminar
    .accesskey = D
auto-mark-as-read =
    .label = Automáticamente marcar mensajes como leídos
    .accesskey = A
mark-read-no-delay =
    .label = Inmediatamente en pantalla
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Después de mostrar para
    .accesskey = d
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
    .label = Mostrar solo el nombre para mostrar de las personas en mi libreta de direcciones
    .accesskey = S

## Compose Tab

forward-label =
    .value = Reenviar mensajes:
    .accesskey = F
inline-label =
    .label = En el cuerpo del mensaje
as-attachment-label =
    .label = Como adjunto
extension-label =
    .label = agregar extensión al nombre del archivo
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Autoguardar cada
    .accesskey = A
auto-save-end = minutos

##

warn-on-send-accel-key =
    .label = Confirmar cuando se usen atajos de teclados para enviar mensajes
    .accesskey = C
spellcheck-label =
    .label = Revisa tu ortografía antes de enviar
    .accesskey = C
spellcheck-inline-label =
    .label = Habilitar ortografía mientras se escribe
    .accesskey = E
language-popup-label =
    .value = Idioma:
    .accesskey = L
download-dictionaries-link = Descargar más diccionarios
font-label =
    .value = Fuente:
    .accesskey = n
font-size-label =
    .value = Tamaño:
    .accesskey = z
default-colors-label =
    .label = Usar colores predeterminados de lector
    .accesskey = d
font-color-label =
    .value = Color del texto:
    .accesskey = T
bg-color-label =
    .value = Color de fondo:
    .accesskey = B
restore-html-label =
    .label = Restaurar predeterminados
    .accesskey = R
default-format-label =
    .label = Usar formato de párrafo en vez de texto de cuerpo predeterminadamente
    .accesskey = P
format-description = Configurar el comportamiento del formato de texto
send-options-label =
    .label = Enviar opciones…
    .accesskey = S
autocomplete-description = Al escribir una dirección, buscar coincidencias en:
ab-label =
    .label = Libreta de direcciones locales
    .accesskey = L
directories-label =
    .label = Servidor de directorio:
    .accesskey = D
directories-none-label =
    .none = Ninguno
edit-directories-label =
    .label = Editar directorios…
    .accesskey = E
email-picker-label =
    .label = Agregar automáticamente las direcciones de correo salientes a mi:
    .accesskey = A
default-directory-label =
    .value = Directorio de inicio predeterminado en la ventana de la libreta de direcciones:
    .accesskey = S
default-last-label =
    .none = Último directorio usado
attachment-label =
    .label = Comprobar si hay archivos adjuntos faltantes
    .accesskey = m
attachment-options-label =
    .label = Palabras clave…
    .accesskey = K
enable-cloud-share =
    .label = Ofrecer compartir para archivos más grandes que
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Agregar…
    .accesskey = A
    .defaultlabel = Agregar…
remove-cloud-account =
    .label = Eliminar
    .accesskey = R
find-cloud-providers =
    .value = Encontrar más proveedores…
cloud-account-description = Agregar un nuevo servicio de almacenamiento Filelink

## Privacy Tab

mail-content = Contenido del correo
remote-content-label =
    .label = Permitir contenido remoto en mensajes
    .accesskey = m
exceptions-button =
    .label = Excepciones…
    .accesskey = E
remote-content-info =
    .value = Saber más sobre los problemas de privacidad del contenido remoto
web-content = Contenido web
history-label =
    .label = Recordar sitios web y enlaces que he visitado
    .accesskey = R
cookies-label =
    .label = Aceptar cookies de sitios web
    .accesskey = A
third-party-label =
    .value = Aceptar cookies de terceros:
    .accesskey = c
third-party-always =
    .label = Siempre
third-party-never =
    .label = Nunca
third-party-visited =
    .label = De sitios visitados
keep-label =
    .value = Mantener hasta:
    .accesskey = K
keep-expire =
    .label = expiran
keep-close =
    .label = cierra { -brand-short-name }
keep-ask =
    .label = preguntarme cada vez
cookies-button =
    .label = Mostrar cookies…
    .accesskey = S
do-not-track-label =
    .label = Enviar a los sitios web una señal de “No Rastrear” para decir que no quieres ser rastreado
    .accesskey = n
learn-button =
    .label = Saber más
passwords-description = { -brand-short-name } puede recordar contraseñas para todas tus cuentas.
passwords-button =
    .label = Contraseñas guardadas…
    .accesskey = S
master-password-description = Una contraseña maestra protege todas tus contraseñas, pero debes ingresarla una vez por sesión.
master-password-label =
    .label = Usar una contraseña maestra
    .accesskey = U
master-password-button =
    .label = Cambiar contraseña maestra…
    .accesskey = C
primary-password-description = La contraseña principal protegerá el resto de tus contraseñas, pero deberás proporcionarla una vez por sesión.
primary-password-label =
    .label = Utilizar una contraseña principal
    .accesskey = U
primary-password-button =
    .label = Cambiar contraseña principal…
    .accesskey = C
forms-primary-pw-fips-title = En este momento se utiliza el modo FIPS. FIPS requiere una contraseña principal no vacía.
forms-master-pw-fips-desc = El cambio de la contraseña ha fallado
junk-description = Configuración predeterminada de correo basura. Las configuraciones específicas de cada cuenta deben ser realizadas en configuración de cuentas.
junk-label =
    .label = Cuando marco mensajes como basura:
    .accesskey = W
junk-move-label =
    .label = Moverlos a la carpeta de correo basura
    .accesskey = o
junk-delete-label =
    .label = Eliminarlos
    .accesskey = D
junk-read-label =
    .label = Marcar mensajes determinados para ser basura como leídos
    .accesskey = M
junk-log-label =
    .label = Habilitar el registro del filtro de basura adaptativo
    .accesskey = E
junk-log-button =
    .label = Mostrar registro
    .accesskey = S
reset-junk-button =
    .label = Borrar entrenamiento
    .accesskey = R
phishing-description = { -brand-short-name } puede analizar mensajes buscando correos sospechosos de fraude buscando las técnicas más conocidas con que puedan engañarlo.
phishing-label =
    .label = Decirme si el mensaje que estoy leyendo es sospechosos de fraude de correo
    .accesskey = T
antivirus-description = { -brand-short-name } puede hacer más fácil que el software anti-virus analice el correo entrante en busca de virus antes de almacenarlo localmente.
antivirus-label =
    .label = Permitir a los clientes anti-virus poner en cuarentena mensajes entrantes individuales
    .accesskey = A
certificate-description = Cuando un servidor solicite mi certificado personal:
certificate-auto =
    .label = Seleccionar uno automáticamente
    .accesskey = S
certificate-ask =
    .label = Preguntarme cada vez
    .accesskey = A
ocsp-label =
    .label = Consultar servidores de respuesta OCSP para confirmar la validez actual de los certificados
    .accesskey = Q
certificate-button =
    .label = Administrar certificados…
    .accesskey = M
security-devices-button =
    .label = Dispositivos de seguridad…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Cuando { -brand-short-name } inicie:
    .accesskey = s
offline-label =
    .label = Mantener mis cuentas de chat sin conexión
auto-connect-label =
    .label = Conectar mis cuentas de chat automáticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Informar a mis contactos que estoy inactivo después de
    .accesskey = I
idle-time-label = minutos de inactividad

##

away-message-label =
    .label = y establecer mi estado como Ausente con el siguiente mensaje de estado:
    .accesskey = A
send-typing-label =
    .label = Enviar notificaciones de escritura en conversaciones
    .accesskey = t
notification-label = Cuando lleguen mensajes dirigidos a ti:
show-notification-label =
    .label = Mostrar una notificación:
    .accesskey = c
notification-all =
    .label = con nombre de remitente y vista previa de mensaje
notification-name =
    .label = solo con nombre de remitente
notification-empty =
    .label = sin ninguna información
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animar el ícono del dock
           *[other] Hacer visible el elemento de la barra de tareas
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = Reproducir un sonido
    .accesskey = d
chat-play-button =
    .label = Reproducir
    .accesskey = P
chat-system-sound-label =
    .label = Sonido predeterminado para correo nuevo
    .accesskey = D
chat-custom-sound-label =
    .label = Usar el siguiente archivo de sonido
    .accesskey = U
chat-browse-sound-button =
    .label = Buscar…
    .accesskey = B
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
no-preview-label = No está disponible la vista previa
no-preview-description = Este tema no es válido o no está actualmente disponible (deshabilitar complemento, modo seguro, …).
chat-variant-label =
    .value = Variante:
    .accesskey = V
chat-header-label =
    .label = Mostrar encabezado
    .accesskey = H
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
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Buscar en preferencias

## Preferences UI Search Results

search-results-header = Resultados de la búsqueda
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] No se han encontrado resultados en Opciones para “<span data-l10n-name="query"></span>”.
       *[other] No se han encontrado resultados en Preferencias para “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = ¿Necesitas ayuda? Visita el soporte de <a data-l10n-name="url">{ -brand-short-name }</a>
