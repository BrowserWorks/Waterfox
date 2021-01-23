# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Clauder

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Optiones
           *[other] Preferentias
        }

pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Composition
category-compose =
    .tooltiptext = Composition

pane-privacy-title = Confidentialitate e securitate
category-privacy =
    .tooltiptext = Confidentialitate e securitate

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Agenda
category-calendar =
    .tooltiptext = Agenda

general-language-and-appearance-header = Lingua e apparentia

general-incoming-mail-header = Messages entrante

general-files-and-attachment-header = Files e annexos

general-tags-header = Etiquettas

general-reading-and-display-header = Leger e monstrar

general-updates-header = Actualisationes

general-network-and-diskspace-header = Rete e spatio sur disco

general-indexing-label = Indexar

composition-category-header = Composition

composition-attachments-header = Annexos

composition-spelling-title = Orthographia

compose-html-style-title = Stylo HTML

composition-addressing-header = Adresses

privacy-main-header = Confidentialitate

privacy-passwords-header = Contrasignos

privacy-junk-header = Indesirate

collection-header = Collecta e uso de datos per { -brand-short-name }

collection-description = Nos nos effortia pro lassar te in le commando e colliger solmente lo que nos ha necessitate pro provider e meliorar { -brand-short-name } a totes. Nos sempre demanda permission ante reciper informationes personal.
collection-privacy-notice = Aviso de confidentialitate

collection-health-report-telemetry-disabled = Tu non plus permitte que { -vendor-short-name } captura datos technic e de interaction. Tote le datos jam capturate essera delite intra 30 dies.
collection-health-report-telemetry-disabled-link = Saper plus

collection-health-report =
    .label = Permitter que { -brand-short-name } invia datos technic e de interaction a { -vendor-short-name }
    .accesskey = P
collection-health-report-link = Saper plus

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Le reporto de datos es inactive pro iste configuration de compilation

collection-backlogged-crash-reports =
    .label = Permitter a { -brand-short-name } de inviar reportos de collapso arretrate in tu nomine
    .accesskey = c
collection-backlogged-crash-reports-link = Saper plus

privacy-security-header = Securitate

privacy-scam-detection-title = Revelamento de fraude

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Certificatos

chat-pane-header = Chat

chat-status-title = Stato

chat-notifications-title = Notificationes

chat-pane-styling-header = Stylos

choose-messenger-language-description = Elige le linguas usate pro monstrar menus, messages, e notificationes per { -brand-short-name }.
manage-messenger-languages-button =
    .label = Definir alternativas…
    .accesskey = a
confirm-messenger-language-change-description = Reinitiar { -brand-short-name } pro applicar iste cambiamentos
confirm-messenger-language-change-button = Applicar e reinitiar

update-setting-write-failure-title = Impossibile registrar preferentias de actualisation

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } ha incontrate un error e non ha potite registrar iste cambiamento. Nota que modificar iste preferentia de actualisation necessita le permission de scriber al file mentionate infra. Tu, o un administrator de systema, pote forsan corriger le problema per conceder al gruppo Usatores le controlo complete de iste file.
    
    Impossibile scriber al file: { $path }

update-in-progress-title = Actualisation in curso

update-in-progress-message = Vole tu que { -brand-short-name } continua iste actualisation?

update-in-progress-ok-button = &Discartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar

addons-button = Extensiones e themas

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pro crear un contrasigno principal, insere tu credentiales de accesso a Windows. Isto permitte de garantir le securitate de tu contos.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crea un contrasigno principal

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pro crear un contrasigno primari, insere tu credentiales de accesso a Windows. Isto permitte de garantir le securitate de tu contos.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Crear un contrasigno primari

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Pagina initial de { -brand-short-name }

start-page-label =
    .label = Quando { -brand-short-name } es lanceate, monstra le pagina initial in le area de messages
    .accesskey = Q

location-label =
    .value = Adresse:
    .accesskey = e
restore-default-label =
    .label = Restaurar le predefinition
    .accesskey = R

default-search-engine = Motor de recerca predefinite
add-search-engine =
    .label = Adder per file
    .accesskey = A
remove-search-engine =
    .label = Remover
    .accesskey = v

minimize-to-tray-label =
    .label = Quando { -brand-short-name } es minimisate, mover lo al zona del avisos
    .accesskey = m

new-message-arrival = Quando nove messages arriva:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Reproducer le file sonor sequente:
           *[other] Reproducer un sono
        }
    .accesskey =
        { PLATFORM() ->
            [macos] t
           *[other] n
        }
mail-play-button =
    .label = Reproducer
    .accesskey = R

change-dock-icon = Cambiar preferentias pro le icone del app
app-icon-options =
    .label = Optiones del icone del app…
    .accesskey = n

notification-settings = Le alertas e le sono predefinite pote esser disactivate in le pannello de notification in le preferentias del systema.

animated-alert-label =
    .label = Monstrar un alerta
    .accesskey = M
customize-alert-label =
    .label = Personalisar…
    .accesskey = P

tray-icon-label =
    .label = Monstrar un icone del zona del avisos
    .accesskey = a

mail-system-sound-label =
    .label = Sono predefinite de systema pro nove email
    .accesskey = S
mail-custom-sound-label =
    .label = Utilisar le file sonor sequente
    .accesskey = U
mail-browse-sound-button =
    .label = Foliettar…
    .accesskey = F

enable-gloda-search-label =
    .label = Activar le recerca e indexation global
    .accesskey = g

datetime-formatting-legend = Formato de data e hora
language-selector-legend = Lingua

allow-hw-accel =
    .label = Usar le acceleration de hardware quando disponibile
    .accesskey = h

store-type-label =
    .value = Typo de magazinage del message pro nove contos:
    .accesskey = T

mbox-store-label =
    .label = File per dossier (mbox)
maildir-store-label =
    .label = File per message (maildir)

scrolling-legend = Rolamento
autoscroll-label =
    .label = Usar rolamento automatic
    .accesskey = U
smooth-scrolling-label =
    .label = Usar le rolamento suave
    .accesskey = s

system-integration-legend = Integration de systema
always-check-default =
    .label = Verifica sempre si { -brand-short-name } es le cliente email predefinite al initiation
    .accesskey = s
check-default-button =
    .label = Controlar ora…
    .accesskey = o

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Puncto luce
        [windows] Recerca de Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Permitter a { search-engine-name } de cercar messages
    .accesskey = P

config-editor-button =
    .label = Editor de configuration…
    .accesskey = c

return-receipts-description = Determinar como { -brand-short-name } tracta le receptas de retorno
return-receipts-button =
    .label = Receptas de retorno…
    .accesskey = R

update-app-legend = Actualisationes de { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }

allow-description = Permitter { -brand-short-name } a
automatic-updates-label =
    .label = Installar automaticamente actualisationes (recommendate: major securitate)
    .accesskey = a
check-updates-label =
    .label = Recercar actualisationes, ma permitter que tu selige si los installar
    .accesskey = R

update-history-button =
    .label = Monstrar le chronologia del actualisationes
    .accesskey = c

use-service =
    .label = Usar un servicio in secunde plano pro installar le actualisationes
    .accesskey = s

cross-user-udpate-warning = Iste configuration se applicara a tote le contos de Windows e profilos de { -brand-short-name } que usa iste installation de { -brand-short-name }.

networking-legend = Connexion
proxy-config-description = Configurar como { -brand-short-name } se connecte a Internet

network-settings-button =
    .label = Parametros…
    .accesskey = S

offline-legend = Foras de linea
offline-settings = Configurar le parametros offline

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Spatio sur disco
offline-compact-folder =
    .label = Compactar tote le dossiers quando se recupera plus de
    .accesskey = t

compact-folder-size =
    .value = MB total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Usar usque
    .accesskey = U

use-cache-after = MB de spatio pro le cache

##

smart-cache-label =
    .label = Supplantar le gestion automatic del cache
    .accesskey = u

clear-cache-button =
    .label = Rader ora
    .accesskey = C

fonts-legend = Typos de litteras e colores

default-font-label =
    .value = Typo de character predefinite:
    .accesskey = p

default-size-label =
    .value = Dimension:
    .accesskey = D

font-options-button =
    .label = Avantiate…
    .accesskey = A

color-options-button =
    .label = Colores…
    .accesskey = C

display-width-legend = Messages de texto simple

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Monstrar emoticones como imagines
    .accesskey = e

display-text-label = Quando on monstra messages de texto simple citate:

style-label =
    .value = Stilo:
    .accesskey = y

regular-style-item =
    .label = Regular
bold-style-item =
    .label = Hardite
italic-style-item =
    .label = Italico
bold-italic-style-item =
    .label = Italico hardite

size-label =
    .value = Dimension:
    .accesskey = s

regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Major
smaller-size-item =
    .label = Minor

quoted-text-color =
    .label = Color:
    .accesskey = o

search-input =
    .placeholder = Cercar

type-column-label =
    .label = Typo de contento
    .accesskey = T

action-column-label =
    .label = Action
    .accesskey = A

save-to-label =
    .label = Salvar le files in
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Eliger…
           *[other] Percurrer…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] P
        }

always-ask-label =
    .label = Sempre demandar me ubi salvar le files
    .accesskey = S


display-tags-text = Tags pote esser usate pro categorisar e prioritarisar tu messages.

new-tag-button =
    .label = Nove…
    .accesskey = N

edit-tag-button =
    .label = Rediger…
    .accesskey = R

delete-tag-button =
    .label = Deler
    .accesskey = D

auto-mark-as-read =
    .label = Marcar automaticamente messages como legite
    .accesskey = M

mark-read-no-delay =
    .label = Immediatemente sur le schermo
    .accesskey = I

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Post monstrar pro
    .accesskey = m

seconds-label = secundas

##

open-msg-label =
    .value = Aperir messages in:

open-msg-tab =
    .label = Un nove scheda
    .accesskey = n

open-msg-window =
    .label = Un nove fenestra de message
    .accesskey = n

open-msg-ex-window =
    .label = Un fenestra existente de message
    .accesskey = e

close-move-delete =
    .label = Clauder fenestra/scheda de message al mover o deler
    .accesskey = C

display-name-label =
    .value = Nomine a monstrar:

condensed-addresses-label =
    .label = Monstrar solo nomine a monstrar pro personas in mi libro del adresses
    .accesskey = M

## Compose Tab

forward-label =
    .value = Inviar ultra messages:
    .accesskey = u

inline-label =
    .label = In message

as-attachment-label =
    .label = Como annexo

extension-label =
    .label = adder extension al nomine de file
    .accesskey = a

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Salvar automaticamente cata
    .accesskey = S

auto-save-end = minutas

##

warn-on-send-accel-key =
    .label = Confirmar per le via breve de claviero quando inviar message
    .accesskey = C

spellcheck-label =
    .label = Controlar orthographia ante inviar
    .accesskey = C

spellcheck-inline-label =
    .label = Activar corrector orthographic durante que tu scribe
    .accesskey = A

language-popup-label =
    .value = Lingua:
    .accesskey = L

download-dictionaries-link = Discargar altere dictionarios

font-label =
    .value = Typo de litteras:
    .accesskey = l

font-size-label =
    .value = Dimension:
    .accesskey = d

default-colors-label =
    .label = Usar le colores predefinite del lector
    .accesskey = p

font-color-label =
    .value = Color del texto:
    .accesskey = T

bg-color-label =
    .value = Color de fundo:
    .accesskey = f

restore-html-label =
    .label = Restaurar predefinitiones
    .accesskey = R

default-format-label =
    .label = Usar de ordinario Formato paragrapho in vice de Texto corpore
    .accesskey = p

format-description = Configurar comportamento del formato texto

send-options-label =
    .label = Inviar optiones…
    .accesskey = I

autocomplete-description = Quando tu scribe le adresse del messages, presta attention al entratas concordante in:

ab-label =
    .label = Libros del adresses local
    .accesskey = l

directories-label =
    .label = Servitor de directorio:
    .accesskey = d

directories-none-label =
    .none = Nulle

edit-directories-label =
    .label = Redaction de directorios…
    .accesskey = R

email-picker-label =
    .label = Adder automaticamente le adresses de posta exiente a mi:
    .accesskey = A

default-directory-label =
    .value = Directorio initial in le fenestra de libro del adresses:
    .accesskey = i

default-last-label =
    .none = Ultime directorio usate

attachment-label =
    .label = Deteger omission de annexos
    .accesskey = o

attachment-options-label =
    .label = Parolas clave…
    .accesskey = P

enable-cloud-share =
    .label = Offerer compartimento pro files major de
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Adder…
    .accesskey = A
    .defaultlabel = Adder…

remove-cloud-account =
    .label = Remover
    .accesskey = R

find-cloud-providers =
    .value = Trovar plus fornitores…

cloud-account-description = Adder un nove servicio de immagazinage Filelink


## Privacy Tab

mail-content = Contento del posta

remote-content-label =
    .label = Permitter contento remote in messages
    .accesskey = m

exceptions-button =
    .label = Exceptiones…
    .accesskey = E

remote-content-info =
    .value = Saper plus re le problemas de confidentialitate de contento remote

web-content = Contento de web

history-label =
    .label = Rememorar sitos web e ligamines que io ha visitate
    .accesskey = R

cookies-label =
    .label = Acceptar cookies ab le sitos web
    .accesskey = A

third-party-label =
    .value = Acceptar cookies de tertios:
    .accesskey = c

third-party-always =
    .label = Sempre
third-party-never =
    .label = Nunquam
third-party-visited =
    .label = De sitos visitate

keep-label =
    .value = Mantener usque:
    .accesskey = M

keep-expire =
    .label = illos expira
keep-close =
    .label = Io claude { -brand-short-name }
keep-ask =
    .label = questionar me cata vice

cookies-button =
    .label = Monstrar le cookies…
    .accesskey = M

do-not-track-label =
    .label = Inviar al sitos web un signal “Non traciar” indicante que vos non vole esser traciate
    .accesskey = n

learn-button =
    .label = Saper plus

passwords-description = { -brand-short-name } pote rememorar contrasignos pro tote tu contos.

passwords-button =
    .label = Contrasignos salvate
    .accesskey = s

master-password-description = Un Contrasigno maestro protege tote tu contrasignos, ma tu debe inserer lo un vice per session.

master-password-label =
    .label = Usar un contrasigno maestro
    .accesskey = m

master-password-button =
    .label = Modificar le contrasigno maestro…
    .accesskey = m


primary-password-description = Un Contrasigno primari protege tote tu contrasignos, ma tu debe inserer lo un vice per session.

primary-password-label =
    .label = Usar un contrasigno primari
    .accesskey = p

primary-password-button =
    .label = Modificar le contrasigno primari…
    .accesskey = M

forms-primary-pw-fips-title = Tu es actualmente in modo FIPS. Tal modo require un contrasigno primari non vacue.
forms-master-pw-fips-desc = Le cambio de contrasigno ha fallite


junk-description = Configura hic le parametros global de posta indesirate. Le parametros de posta indesirate specific pro cata conto pote esser configurate in Parametros de contos.

junk-label =
    .label = Quando io marca messages como indesirate:
    .accesskey = i

junk-move-label =
    .label = Mover los al plica "Immunditia" del conto
    .accesskey = l

junk-delete-label =
    .label = Deler los
    .accesskey = D

junk-read-label =
    .label = Marcar como legite le messages detegite como indesirate
    .accesskey = l

junk-log-label =
    .label = Registrar le activitate del filtro adaptive de posta indesirate
    .accesskey = R

junk-log-button =
    .label = Monstrar registro
    .accesskey = M

reset-junk-button =
    .label = Reinitialisar datos de exercitation
    .accesskey = R

phishing-description = { -brand-short-name } pote analysar messages pro fraudes via emails suspecte per recerca del commun technicas usate pro illuder te.

phishing-label =
    .label = Dice me si le message que io lege es un suspecte fraude via email
    .accesskey = D

antivirus-description = { -brand-short-name } pote facilitar al programmas antivirus de deteger viruses in le messages de posta entrante ante que illos se immagazina localmente.

antivirus-label =
    .label = Permitter que programmas antivirus mitte in quarantena singule messages entrante
    .accesskey = P

certificate-description = Quando un servitor requesta mi certificato personal:

certificate-auto =
    .label = Selectionar un automaticamente
    .accesskey = S

certificate-ask =
    .label = Demandar me cata vice
    .accesskey = D

ocsp-label =
    .label = Querer le servitores responditor OCSP pro confirmar le validitate actual del certificatos
    .accesskey = Q

certificate-button =
    .label = Gerer certificatos…
    .accesskey = G

security-devices-button =
    .label = Dispositivos de securitate…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Quando { -brand-short-name } es initiate:
    .accesskey = i

offline-label =
    .label = Mantene mi contos chat sin connexion

auto-connect-label =
    .label = Connecter automaticamente mi contos chat

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Informar mi contactos que io es inactive post
    .accesskey = p

idle-time-label = minutas de inactivitate

##

away-message-label =
    .label = e configura mi stato a Non disponibile con iste message de stato:
    .accesskey = N

send-typing-label =
    .label = Invia avisos de scriptura in conversationes
    .accesskey = I

notification-label = Quando arriva messages directe a te:

show-notification-label =
    .label = Monstrar un notification
    .accesskey = M

notification-all =
    .label = con nomine del expeditor e le vista preliminar del message
notification-name =
    .label = con nomine del expeditor solmente
notification-empty =
    .label = sin information

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animar icone del bassino
           *[other] Fulgurar le elemento in le barra del activitates
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] F
        }

chat-play-sound-label =
    .label = Reproducer un sono
    .accesskey = s

chat-play-button =
    .label = Reproducer
    .accesskey = R

chat-system-sound-label =
    .label = Sono predefinite de systema pro nove email
    .accesskey = P

chat-custom-sound-label =
    .label = Utilisar le file sonor sequente
    .accesskey = U

chat-browse-sound-button =
    .label = Foliettar…
    .accesskey = F

theme-label =
    .value = Thema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bullas
style-dark =
    .label = Obscur
style-paper =
    .label = Folios de papiro
style-simple =
    .label = Simple

preview-label = Vista preliminar:
no-preview-label = Nulle vista preliminar disponibile
no-preview-description = Iste thema non es valide o es actualmente indisponibile (ha disactivate additivo, safe-mode, …).

chat-variant-label =
    .value = Variante:
    .accesskey = V

chat-header-label =
    .label = Monstrar capite
    .accesskey = c

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
            [windows] Cercar in optiones
           *[other] Cercar in preferentias
        }

## Preferences UI Search Results

search-results-header = Resultatos del recerca

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Pardono! Il ha nulle resultatos in le optiones pro “<span data-l10n-name="query"></span>”.
       *[other] Pardono! Il ha nulle resultatos in le preferentias pro “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Require adjuta? Visita <a data-l10n-name="url">Assistentia de { -brand-short-name }</a>
