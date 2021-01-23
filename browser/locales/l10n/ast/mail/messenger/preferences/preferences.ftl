# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencies
        }

pane-compose-title = Redaición
category-compose =
    .tooltiptext = Redaición

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Páxina d'aniciu de { -brand-short-name }

start-page-label =
    .label = Al aniciase { -brand-short-name }, amosar la páxina d'aniciu nel área de mensaxes
    .accesskey = i

location-label =
    .value = Direición:
    .accesskey = D
restore-default-label =
    .label = Restablecer predetermináu
    .accesskey = R

default-search-engine = Motor de gueta por defeutu

new-message-arrival = Cuando aporten mensaxes nuevos:
mail-play-button =
    .label = Reproducir
    .accesskey = r

change-dock-icon = Camudar les preferencies del iconu de l'aplicación
app-icon-options =
    .label = Opciones del iconu de l'aplicación…
    .accesskey = c

animated-alert-label =
    .label = Amosar un avisu/alerta
    .accesskey = M
customize-alert-label =
    .label = Personalizar…
    .accesskey = P

tray-icon-label =
    .label = Amosar un iconu na bandexa
    .accesskey = a

mail-custom-sound-label =
    .label = Usar el siguiente ficheru de soníu
    .accesskey = U
mail-browse-sound-button =
    .label = Desaminar…
    .accesskey = E

enable-gloda-search-label =
    .label = Activar indexador y gueta global
    .accesskey = A

allow-hw-accel =
    .label = Usar aceleración per hardware al tar disponible
    .accesskey = h

store-type-label =
    .value = Triba d'almacenamientu de mensaxes pa cuentes nueves:
    .accesskey = T

mbox-store-label =
    .label = Ficheru per carpeta (mbox)
maildir-store-label =
    .label = Ficheru per mensaxe (maildir)

scrolling-legend = Desplazamientu
autoscroll-label =
    .label = Usar desplazamientu automáticu
    .accesskey = U
smooth-scrolling-label =
    .label = Usar desplazamientu suave
    .accesskey = d

system-integration-legend = Integración col sistema
always-check-default =
    .label = Comprobar siempre al aniciar si { -brand-short-name } ye'l veceru de corréu por omisión
    .accesskey = C
check-default-button =
    .label = Comprobar agora…
    .accesskey = b

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Permitir que { search-engine-name } guete nos mensaxes
    .accesskey = P

config-editor-button =
    .label = Editor de configuración…
    .accesskey = E

return-receipts-description = Determinar cómo xestiona { -brand-short-name } los acuses de recibu
return-receipts-button =
    .label = Acuses de recibu…
    .accesskey = r

automatic-updates-label =
    .label = Instalar anovamientos automáticamente (recomiéndase: ameyora la seguridá)
    .accesskey = I
check-updates-label =
    .label = Guetar anovamientos, pero permitime elexir si los instalo
    .accesskey = G

update-history-button =
    .label = Amosar historial d'anovamientos
    .accesskey = M

use-service =
    .label = Usar un serviciu en segundu planu pa instalar anovamientos
    .accesskey = v

networking-legend = Conexón
proxy-config-description = Configurar cómo se coneuta { -brand-short-name } a Internet

network-settings-button =
    .label = Configuración…
    .accesskey = C

offline-legend = Desconeutáu
offline-settings = Configurar mou ensin conexón

offline-settings-button =
    .label = Ensin conexón…
    .accesskey = S

diskspace-legend = Espaciu en discu
offline-compact-folder =
    .label = Compautar toles carpetes cuando s'aforren más de
    .accesskey = C

compact-folder-size =
    .value = MB en total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Usar hasta
    .accesskey = U

use-cache-after = MB d'espaciu pa la caché

##

clear-cache-button =
    .label = Llimpiar agora
    .accesskey = L

fonts-legend = Fontes y colores

default-font-label =
    .value = Fonte de lletra por defeutu:
    .accesskey = e

default-size-label =
    .value = Tamañu:
    .accesskey = T

font-options-button =
    .label = Avanzaes…
    .accesskey = v

color-options-button =
    .label = Colores…
    .accesskey = C

display-width-legend = Mensaxes de testu ensin formatu

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Amosar fustaxes como gráficos
    .accesskey = A

display-text-label = Al amosar mensaxes de testu ensin formatu:

style-label =
    .value = Estilu:
    .accesskey = E

regular-style-item =
    .label = Regular
bold-style-item =
    .label = Negrina
italic-style-item =
    .label = Cursiva
bold-italic-style-item =
    .label = Negrina cursiva

size-label =
    .value = Tamañu:
    .accesskey = a

regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Mayor
smaller-size-item =
    .label = Menor

quoted-text-color =
    .label = Color:
    .accesskey = o

search-input =
    .placeholder = Guetar

type-column-label =
    .label = Triba de conteníu
    .accesskey = T

action-column-label =
    .label = Aición
    .accesskey = A

save-to-label =
    .label = Guardar ficheros en
    .accesskey = G

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Elexir…
           *[other] Desaminar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] s
        }

always-ask-label =
    .label = Entrugame siempre aú guardar ficheros
    .accesskey = P


display-tags-text = Les etiquetes puen usase pa categorizar y priorizar los tos mensaxes.

delete-tag-button =
    .label = Desaniciar
    .accesskey = r

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).


##


## Compose Tab

forward-label =
    .value = Reunviar mensaxes:
    .accesskey = m

inline-label =
    .label = Incorporáu

as-attachment-label =
    .label = Como axuntu

extension-label =
    .label = Amestar estensión al nome de ficheru
    .accesskey = A

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Guardar automáticamente cada
    .accesskey = G

auto-save-end = minutos

##

warn-on-send-accel-key =
    .label = Confirmar al usar l'atayu de tecláu pal unviu de mensaxes
    .accesskey = n

spellcheck-label =
    .label = Comprobar la ortografía enantes d'unviar
    .accesskey = C

spellcheck-inline-label =
    .label = Activar correición ortográfica al escribir
    .accesskey = v

language-popup-label =
    .value = Llingua:
    .accesskey = L

download-dictionaries-link = Descargar más diccionarios

font-label =
    .value = Fonte de lletra:
    .accesskey = T

font-color-label =
    .value = Color del testu:
    .accesskey = s

bg-color-label =
    .value = Color de fondu:
    .accesskey = C

restore-html-label =
    .label = Restaurar valores por omisión
    .accesskey = R

default-format-label =
    .label = Usar formatu párrafu en cuentes del testu de cuerpu por defeutu
    .accesskey = P

format-description = Configurar comportamientu del formatu de testu

send-options-label =
    .label = Opciones d'unviu…
    .accesskey = v

autocomplete-description = Al unviar mensaxes, guetar entraes coincidentes en:

ab-label =
    .label = Llibretes de direiciones llocales
    .accesskey = L

directories-label =
    .label = Sirvidor de direutoriu:
    .accesskey = S

directories-none-label =
    .none = Dengún

edit-directories-label =
    .label = Editar direutorios…
    .accesskey = E

email-picker-label =
    .label = Amestar automáticamente les direiciones de corréu saliente al mio/mios:
    .accesskey = A

attachment-label =
    .label = Comprobar axuntos escaecíos
    .accesskey = b

attachment-options-label =
    .label = Pallabres clave…
    .accesskey = P

enable-cloud-share =
    .label = Ufrilu pa compartir ficheros mayores de
cloud-share-size =
    .value = MB

remove-cloud-account =
    .label = Desaniciar
    .accesskey = n

cloud-account-description = Amestar un serviciu nuevu d'almacenamientu Filelink


## Privacy Tab

mail-content = Conteníu de corréu

remote-content-label =
    .label = Permitir conteníu remotu nos mensaxes
    .accesskey = P

exceptions-button =
    .label = Esceiciones…
    .accesskey = n

remote-content-info =
    .value = Saber más tocante a los problemas de privacidá del conteníu remotu

web-content = Conteníu web

history-label =
    .label = Recordar sitios web y enllaces que visité
    .accesskey = R

cookies-label =
    .label = Aceutar cookies de los sitios
    .accesskey = A

third-party-label =
    .value = Aceutar cookies de terceros:
    .accesskey = d

third-party-always =
    .label = Siempre
third-party-never =
    .label = Enxamás
third-party-visited =
    .label = De sitios visitaos

keep-label =
    .value = Caltener hasta que:
    .accesskey = C

keep-expire =
    .label = caduquen
keep-close =
    .label = zarre { -brand-short-name }
keep-ask =
    .label = entrugame cada vegada

cookies-button =
    .label = Amosar cookies…
    .accesskey = A

passwords-description = { -brand-short-name } pue recordar les contraseñes de toles cuentes.

passwords-button =
    .label = Contraseñes guardaes…
    .accesskey = C

master-password-description = Una contraseña maestra protexe toles contraseñes, pero tienes d'introducila una vegada por sesión.

master-password-label =
    .label = Usar una contraseña maestra
    .accesskey = U

master-password-button =
    .label = Camudar contraseña maestra…
    .accesskey = C


junk-description = Afita la to configuración predeterminada pal corréu non deseáu. La configuración específica de cada cuenta pue axustase na Configuración de les cuentes.

junk-label =
    .label = Cuando conseño los mensaxes como puxarra:
    .accesskey = C

junk-move-label =
    .label = Movelos a la carpeta "Corréu puxarra" de la cuenta
    .accesskey = o

junk-delete-label =
    .label = Desanicialos
    .accesskey = D

junk-read-label =
    .label = Conseñar como lleíos los mensaxes calificaos como puxarra
    .accesskey = M

junk-log-label =
    .label = Activar el rexistru del filtru adautativu de corréu puxarra
    .accesskey = A

junk-log-button =
    .label = Amosar el rexistru
    .accesskey = s

reset-junk-button =
    .label = Reaniciar datos d'entrenamientu
    .accesskey = R

phishing-description = { -brand-short-name } pue analizar mensaxes pa identificar los que seyan fraudulentos guetando téuniques comunes usaes pa engañate.

phishing-label =
    .label = Avisame si'l mensaxe que toi lleendo paez un mensaxe fraudulentu
    .accesskey = D

antivirus-description = { -brand-short-name } pue facer cenciellamente que'l software antivirus analice'l corréu entrante a la gueta de virus enantes de que se guarden llocalmente.

antivirus-label =
    .label = Permitir a los antivirus poner en cuarentena mensaxes individuales
    .accesskey = P

certificate-description = Cuando un sirvidor solicite'l mio certificáu personal:

certificate-auto =
    .label = Seleicionar ún automáticamente
    .accesskey = S

certificate-ask =
    .label = Entrugame cada vegada
    .accesskey = E

ocsp-label =
    .label = Entrugar a los sirvidores respondedores de OCSP pa confirmar la validez actual de los certificaos
    .accesskey = u

## Chat Tab

startup-label =
    .value = Al aniciar { -brand-short-name }:
    .accesskey = A

offline-label =
    .label = Caltener ensin coneutar les mios cuentes de chat

auto-connect-label =
    .label = Coneutar a les mios cuentes automáticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Permitir a los mios contautos saber que toi inactivu tres
    .accesskey = P

idle-time-label = minutos d'actividá

##

away-message-label =
    .label = y afitar el mio estáu a Ausente con esti mensaxe d'estáu:
    .accesskey = t

send-typing-label =
    .label = Unviar notificaciones d'escritura en conversaciones
    .accesskey = U

notification-label = Cuando aporten mensaxes dirixíos a mi:

show-notification-label =
    .label = Amosar una notificación:
    .accesskey = M

notification-all =
    .label = col nome del remitente y una vista preliminar del mensaxe
notification-name =
    .label = col nome del remitente namái
notification-empty =
    .label = ensin nenguna información

chat-play-sound-label =
    .label = Reproducir un soníu
    .accesskey = R

chat-play-button =
    .label = Reproducir
    .accesskey = c

chat-system-sound-label =
    .label = Soníu por defeutu del sistema pal corréu nuevu
    .accesskey = S

chat-custom-sound-label =
    .label = Usar el siguiente ficheru de soníu
    .accesskey = U

chat-browse-sound-button =
    .label = Desaminar…
    .accesskey = s

## Preferences UI Search Results

