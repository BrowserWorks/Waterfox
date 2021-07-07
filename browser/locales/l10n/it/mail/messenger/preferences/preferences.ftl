# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Chiudi
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opzioni
           *[other] Preferenze
        }
preferences-tab-title =
    .title = Preferenze
preferences-doc-title = Preferenze
category-list =
    .aria-label = Categorie
pane-general-title = Generale
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Composizione
category-compose =
    .tooltiptext = Composizione
pane-privacy-title = Privacy e sicurezza
category-privacy =
    .tooltiptext = Privacy e sicurezza
pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat
pane-calendar-title = Calendario
category-calendar =
    .tooltiptext = Calendario
general-language-and-appearance-header = Lingua e aspetto
general-incoming-mail-header = Posta in arrivo
general-files-and-attachment-header = File e allegati
general-tags-header = Etichette
general-reading-and-display-header = Lettura e visualizzazione
general-updates-header = Aggiornamenti
general-network-and-diskspace-header = Rete e spazio su disco
general-indexing-label = Indicizzazione
composition-category-header = Composizione
composition-attachments-header = Allegati
composition-spelling-title = Ortografia
compose-html-style-title = Stile HTML
composition-addressing-header = Indirizzamento
privacy-main-header = Privacy
privacy-passwords-header = Password
privacy-junk-header = Indesiderata
collection-header = Raccolta e utilizzo dati di { -brand-short-name }
collection-description = Cerchiamo di garantire agli utenti la possibilità di scegliere, raccogliendo solo i dati necessari per realizzare e migliorare { -brand-short-name } per tutti. Prima di raccogliere dati personali, chiediamo sempre l’autorizzazione.
collection-privacy-notice = Informativa sulla privacy
collection-health-report-telemetry-disabled = { -vendor-short-name } non ha più il permesso di raccogliere dati tecnici e relativi all’interazione con Thunderbird. Tutti i dati esistenti verranno rimossi entro 30 giorni.
collection-health-report-telemetry-disabled-link = Ulteriori informazioni
collection-health-report =
    .label = Consenti a { -brand-short-name } di inviare a { -vendor-short-name } dati tecnici e di interazione
    .accesskey = d
collection-health-report-link = Ulteriori informazioni
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = L’invio dei dati è stato disattivato nella configurazione utilizzata per questa build
collection-backlogged-crash-reports =
    .label = Consenti a { -brand-short-name } di inviare segnalazioni di arresto anomalo in sospeso
    .accesskey = s
collection-backlogged-crash-reports-link = Ulteriori informazioni
privacy-security-header = Sicurezza
privacy-scam-detection-title = Rilevamento frodi
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certificati
chat-pane-header = Chat
chat-status-title = Stato
chat-notifications-title = Notifiche
chat-pane-styling-header = Stili
choose-messenger-language-description = Scegliere le lingue utilizzate per visualizzare i menu, i messaggi e le notifiche tra { -brand-short-name }
manage-messenger-languages-button =
    .label = Imposta alternative…
    .accesskey = I
confirm-messenger-language-change-description = Riavviare { -brand-short-name } per applicare queste modifiche
confirm-messenger-language-change-button = Applica e riavvia
update-setting-write-failure-title = Errore salvataggio preferenze di aggiornamento
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    Si è verificato un errore e questa modifica non è stata salvata. Per aggiornare le preferenze è necessario avere i permessi di scrittura sul file indicato in seguito. Dovrebbe essere possibile correggere il problema assegnando al gruppo Utenti il pieno controllo di questo file.
    
    Impossibile scrivere il file: { $path }
update-in-progress-title = Aggiornamento in corso
update-in-progress-message = Procedere con l’aggiornamento di { -brand-short-name }?
update-in-progress-ok-button = I&nterrompi
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continua
addons-button = Estensioni e temi
account-button = Impostazioni account
open-addons-sidebar-button = Componenti aggiuntivi e temi

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Per creare una password principale, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = creare una password principale
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Per creare una password principale, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = creare una password principale
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = Pagina iniziale di { -brand-short-name }
start-page-label =
    .label = All’apertura di { -brand-short-name } mostra la pagina iniziale nell’area messaggi
    .accesskey = d
location-label =
    .value = Posizione:
    .accesskey = n
restore-default-label =
    .label = Ripristina predefinita
    .accesskey = R
default-search-engine = Motore di ricerca predefinito
add-search-engine =
    .label = Aggiungi da file
    .accesskey = A
remove-search-engine =
    .label = Rimuovi
    .accesskey = v
minimize-to-tray-label =
    .label = Quando { -brand-short-name } è ridotto a icona, spostalo nell’area di notifica
    .accesskey = n
new-message-arrival = All’arrivo di un messaggio:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Esegui questo file audio:
           *[other] Riproduci un suono
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] o
        }
mail-play-button =
    .label = Ascolta
    .accesskey = A
change-dock-icon = Modifica le preferenze per l’icona dell’app
app-icon-options =
    .label = Opzioni icona applicazione…
    .accesskey = n
notification-settings = È possibile disattivare gli avvisi e il suono predefinito nella sezione Notifiche delle Preferenze di Sistema.
animated-alert-label =
    .label = Mostra un avviso
    .accesskey = M
customize-alert-label =
    .label = Personalizza…
    .accesskey = z
tray-icon-label =
    .label = Mostra un’icona nell’area di notifica
    .accesskey = t
biff-use-system-alert =
    .label = Utilizza la notifica di sistema
tray-icon-unread-label =
    .label = Mostra un’icona nell’area di notifica per i messaggi non letti
    .accesskey = M
tray-icon-unread-description = Consigliato quando si utilizzano i pulsanti di piccole dimensioni nella barra delle applicazioni
mail-system-sound-label =
    .label = Suono predefinito di sistema per nuova posta
    .accesskey = S
mail-custom-sound-label =
    .label = Utilizza questo file audio
    .accesskey = U
mail-browse-sound-button =
    .label = Sfoglia…
    .accesskey = S
enable-gloda-search-label =
    .label = Attiva la ricerca globale e l’indicizzazione
    .accesskey = E
datetime-formatting-legend = Formattazione data e ora
language-selector-legend = Lingua
allow-hw-accel =
    .label = Utilizza l’accelerazione hardware quando disponibile
    .accesskey = h
store-type-label =
    .value = Modalità di salvataggio dei messaggi per i nuovi account:
    .accesskey = T
mbox-store-label =
    .label = File per cartella (mbox)
maildir-store-label =
    .label = Un file per ogni messaggio (maildir)
scrolling-legend = Scrolling
autoscroll-label =
    .label = Utilizza lo scorrimento automatico
    .accesskey = U
smooth-scrolling-label =
    .label = Utilizza lo scorrimento continuo
    .accesskey = m
system-integration-legend = Integrazione col sistema
always-check-default =
    .label = Controlla sempre all’avvio se { -brand-short-name } è il programma di posta predefinito
    .accesskey = A
check-default-button =
    .label = Controlla ora…
    .accesskey = O
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Ricerca di Windows
       *[other] { "" }
    }
search-integration-label =
    .label = Permetti a { search-engine-name } di cercare nei messaggi
    .accesskey = P
config-editor-button =
    .label = Editor di configurazione…
    .accesskey = o
return-receipts-description = Determina come { -brand-short-name } gestisce le ricevute di ritorno
return-receipts-button =
    .label = Ricevute di ritorno…
    .accesskey = R
update-app-legend = Aggiornamenti di { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versione { $version }
allow-description = Consenti a { -brand-short-name } di
automatic-updates-label =
    .label = Installa automaticamente aggiornamenti (consigliato: maggiore sicurezza)
    .accesskey = n
check-updates-label =
    .label = Controlla aggiornamenti ma permetti all’utente di scegliere se installarli
    .accesskey = C
update-history-button =
    .label = Mostra cronologia aggiornamenti
    .accesskey = S
use-service =
    .label = Utilizza un servizio di sistema per installare gli aggiornamenti
    .accesskey = U
cross-user-udpate-warning = Questa impostazione si applicherà a tutti gli account Windows e ai profili di { -brand-short-name } che utilizzano questa installazione di { -brand-short-name }.
networking-legend = Connessione
proxy-config-description = Configura il modo in cui { -brand-short-name } si collega a Internet
network-settings-button =
    .label = Impostazioni…
    .accesskey = I
offline-legend = Non in linea
offline-settings = Configura le impostazioni “non in linea”
offline-settings-button =
    .label = Non in linea…
    .accesskey = N
diskspace-legend = Spazio su disco
offline-compact-folder =
    .label = Compatta le cartelle quando è possibile recuperare
    .accesskey = a
compact-folder-size =
    .value = Mb in totale

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Utilizza al massimo
    .accesskey = U
use-cache-after = MB di spazio per la cache

##

smart-cache-label =
    .label = Non utilizzare la gestione automatica della cache
    .accesskey = N
clear-cache-button =
    .label = Pulisci ora
    .accesskey = P
fonts-legend = Caratteri e colori
default-font-label =
    .value = Carattere predefinito:
    .accesskey = C
default-size-label =
    .value = Dim.:
    .accesskey = D
font-options-button =
    .label = Avanzate…
    .accesskey = z
color-options-button =
    .label = Colori…
    .accesskey = l
display-width-legend = Messaggi di testo semplice
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Mostra le faccine in modo grafico
    .accesskey = a
display-text-label = Durante la visualizzazione delle citazioni in testo semplice:
style-label =
    .value = Stile:
    .accesskey = e
regular-style-item =
    .label = Regolare
bold-style-item =
    .label = Grassetto
italic-style-item =
    .label = Corsivo
bold-italic-style-item =
    .label = Grassetto corsivo
size-label =
    .value = Dimensione:
    .accesskey = s
regular-size-item =
    .label = Regolare
bigger-size-item =
    .label = Più grande
smaller-size-item =
    .label = Più piccolo
quoted-text-color =
    .label = Colore:
    .accesskey = o
search-input =
    .placeholder = Cerca
search-handler-table =
    .placeholder = Filtra i tipi di contenuto e le azioni
type-column-label =
    .label = Tipo di contenuto
    .accesskey = T
action-column-label =
    .label = Azione
    .accesskey = A
save-to-label =
    .label = Salva i file in
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Scegliere…
           *[other] Sfoglia…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
always-ask-label =
    .label = Chiedi dove salvare ogni file
    .accesskey = C
display-tags-text = Le etichette possono essere usate per catalogare e dare priorità ai messaggi.
new-tag-button =
    .label = Nuovo…
    .accesskey = N
edit-tag-button =
    .label = Modifica…
    .accesskey = M
delete-tag-button =
    .label = Elimina
    .accesskey = E
auto-mark-as-read =
    .label = Contrassegna automaticamente un messaggio come letto
    .accesskey = C
mark-read-no-delay =
    .label = immediatamente dopo averlo mostrato
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = dopo averlo mostrato per
    .accesskey = d
seconds-label = secondi

##

open-msg-label =
    .value = Aprire i messaggi in:
open-msg-tab =
    .label = nuova scheda
    .accesskey = s
open-msg-window =
    .label = nuova finestra
    .accesskey = f
open-msg-ex-window =
    .label = finestra esistente
    .accesskey = e
close-move-delete =
    .label = Chiudere la finestra/scheda del messaggio in caso sia spostato o cancellato
    .accesskey = C
display-name-label =
    .value = Nome visualizzato:
condensed-addresses-label =
    .label = mostra solo il nome visualizzato per le persone nella rubrica
    .accesskey = m

## Compose Tab

forward-label =
    .value = Inoltra i messaggi:
    .accesskey = I
inline-label =
    .label = nel corpo del messaggio
as-attachment-label =
    .label = come allegati
extension-label =
    .label = Aggiungi l’estensione al nome del file
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Salvataggio automatico ogni
    .accesskey = v
auto-save-end = minuti

##

warn-on-send-accel-key =
    .label = Chiedi conferma quando si utilizza una scorciatoia da tastiera per inviare il messaggio
    .accesskey = h
spellcheck-label =
    .label = Controlla ortografia prima di inviare
    .accesskey = C
spellcheck-inline-label =
    .label = Attiva il controllo ortografico durante la digitazione
    .accesskey = A
language-popup-label =
    .value = Lingua:
    .accesskey = L
download-dictionaries-link = Scarica altri dizionari
font-label =
    .value = Carattere:
    .accesskey = c
font-size-label =
    .value = Dimensione:
    .accesskey = d
default-colors-label =
    .label = Usa i colori predefiniti del lettore
    .accesskey = u
font-color-label =
    .value = Colore del testo:
    .accesskey = o
bg-color-label =
    .value = Colore di sfondo:
    .accesskey = l
restore-html-label =
    .label = Ripristina predefiniti
    .accesskey = R
default-format-label =
    .label = Usare il formato paragrafo come predefinito al posto del Corpo del Messaggio
    .accesskey = P
format-description = Configura la formattazione del testo:
send-options-label =
    .label = Opzioni di invio…
    .accesskey = d
autocomplete-description = Durante la scrittura dell’indirizzo controlla le corrispondenze in:
ab-label =
    .label = Rubriche locali
    .accesskey = u
directories-label =
    .label = Rubrica remota:
    .accesskey = R
directories-none-label =
    .none = nessuna
edit-directories-label =
    .label = Modifica cartelle…
    .accesskey = M
email-picker-label =
    .label = Aggiungi automaticamente l’indirizzo della posta in uscita a:
    .accesskey = A
default-directory-label =
    .value = Directory di avvio predefinita nella finestra rubrica:
    .accesskey = S
default-last-label =
    .none = Ultima directory selezionata
attachment-label =
    .label = Controlla allegati mancanti
    .accesskey = m
attachment-options-label =
    .label = Parole chiave…
    .accesskey = P
enable-cloud-share =
    .label = Offrire la condivisione per file più grandi di
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Aggiungi…
    .accesskey = A
    .defaultlabel = Aggiungi…
remove-cloud-account =
    .label = Elimina
    .accesskey = E
find-cloud-providers =
    .value = Trova altri provider…
cloud-account-description = Aggiungi un nuovo servizio di archiviazione Filelink

## Privacy Tab

mail-content = Contenuto della posta
remote-content-label =
    .label = Permetti contenuti remoti dentro i messaggi
    .accesskey = m
exceptions-button =
    .label = Eccezioni…
    .accesskey = E
remote-content-info =
    .value = Maggiori informazioni sui problemi di privacy dei contenuti remoti
web-content = Contenuto web
history-label =
    .label = Ricorda siti web e link visitati
    .accesskey = R
cookies-label =
    .label = Accetta i cookie dai siti
    .accesskey = A
third-party-label =
    .value = Accetta i cookie di terze parti:
    .accesskey = c
third-party-always =
    .label = sempre
third-party-never =
    .label = mai
third-party-visited =
    .label = dai siti visitati
keep-label =
    .value = Conservali fino:
    .accesskey = f
keep-expire =
    .label = alla loro scadenza
keep-close =
    .label = alla chiusura di { -brand-short-name }
keep-ask =
    .label = chiedi ogni volta
cookies-button =
    .label = Mostra i cookie…
    .accesskey = o
do-not-track-label =
    .label = Comunica ai siti la volontà di non essere tracciato inviando un segnale “Do Not Track”
    .accesskey = n
learn-button =
    .label = Ulteriori informazioni
passwords-description = { -brand-short-name } può memorizzare le password per tutti gli account.
passwords-button =
    .label = Password salvate…
    .accesskey = P
master-password-description = È possibile impostare una Password principale per proteggere tutte le altre password; sarà però obbligatorio digitarla una volta per sessione.
master-password-label =
    .label = Utilizza una password principale
    .accesskey = U
master-password-button =
    .label = Cambia Password principale…
    .accesskey = C
primary-password-description = È possibile impostare una password principale per proteggere tutte le altre password; sarà però obbligatorio digitarla una volta per sessione.
primary-password-label =
    .label = Utilizza una password principale
    .accesskey = U
primary-password-button =
    .label = Cambia la password principale…
    .accesskey = m
forms-primary-pw-fips-title = Si è in modalità FIPS. FIPS richiede che la password principale sia impostata.
forms-master-pw-fips-desc = Modifica della password non riuscita
junk-description = Scegliere le impostazioni predefinite per la posta indesiderata. Le impostazioni di posta indesiderata specifiche possono essere configurate nelle Impostazioni account.
junk-label =
    .label = Quando i messaggi sono segnati come posta indesiderata:
    .accesskey = Q
junk-move-label =
    .label = Spostali nella cartella “Indesiderata” dell’utente
    .accesskey = o
junk-delete-label =
    .label = Eliminali
    .accesskey = E
junk-read-label =
    .label = Segna come già letti tutti i messaggi riconosciuti come posta indesiderata
    .accesskey = M
junk-log-label =
    .label = Attiva registro attività del filtro incrementale per la posta indesiderata
    .accesskey = A
junk-log-button =
    .label = Mostra registro attività
    .accesskey = S
reset-junk-button =
    .label = Elimina i dati di autoistruzione
    .accesskey = z
phishing-description = { -brand-short-name } è in grado di analizzare i messaggi alla ricerca di possibili tentativi di frode, individuando le tecniche più comuni per questo tipo di truffe.
phishing-label =
    .label = Avvisa sempre se il messaggio che si sta leggendo è un possibile tentativo di frode
    .accesskey = e
antivirus-description = { -brand-short-name } è in grado di semplificare il lavoro del software antivirus, permettendo l’analisi della posta in arrivo prima che venga salvata localmente.
antivirus-label =
    .label = Consenti ai programmi antivirus di mettere in quarantena i singoli messaggi in arrivo.
    .accesskey = n
certificate-description = Quando un sito web richiede il certificato personale:
certificate-auto =
    .label = Selezionane uno automaticamente
    .accesskey = S
certificate-ask =
    .label = Chiedere ogni volta
    .accesskey = C
ocsp-label =
    .label = Interrogare i risponditori OCSP per confermare l’attuale validità dei certificati
    .accesskey = e
certificate-button =
    .label = Gestisci certificati…
    .accesskey = G
security-devices-button =
    .label = Dispositivi di sicurezza…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Quando si avvia { -brand-short-name }:
    .accesskey = Q
offline-label =
    .label = Mantieni gli account di chat scollegati
auto-connect-label =
    .label = Collega l’account di chat automaticamente

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Consenti che i miei contatti sappiano che sono Inattivo dopo
    .accesskey = C
idle-time-label = minuti di inattività

##

away-message-label =
    .label = ed imposta il mio stato come “Non disponibile” con questo messaggio:
    .accesskey = e
send-typing-label =
    .label = Mostra le notifiche di scrittura nelle conversazioni
    .accesskey = M
notification-label = Quando arriva un messaggio indirizzato a te:
show-notification-label =
    .label = Mostra una notifica:
    .accesskey = M
notification-all =
    .label = col nome del mittente e una anteprima del messaggio
notification-name =
    .label = solamente col nome del mittente
notification-empty =
    .label = senza alcuna informazione
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Anima l’icona nel dock
           *[other] Fai lampeggiare l’elemento nella barra delle applicazioni
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = Riproduci un suono
    .accesskey = s
chat-play-button =
    .label = Riproduci
    .accesskey = R
chat-system-sound-label =
    .label = Suono predefinito di sistema per nuova posta
    .accesskey = p
chat-custom-sound-label =
    .label = Utilizza questo file audio
    .accesskey = U
chat-browse-sound-button =
    .label = Sfoglia…
    .accesskey = f
theme-label =
    .value = Tema:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Fumetti
style-dark =
    .label = Scuro
style-paper =
    .label = Fogli di carta
style-simple =
    .label = Semplice
preview-label = Anteprima:
no-preview-label = Anteprima non disponibile
no-preview-description = Questo tema non è valido o in questo momento non è disponibile (componente aggiuntivo disattivato, modalità provvisoria, …).
chat-variant-label =
    .value = Variante:
    .accesskey = V
chat-header-label =
    .label = Mostra intestazione
    .accesskey = I
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
            [windows] Trova nelle opzioni
           *[other] Trova nelle preferenze
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
    .style = width: 16em
    .placeholder = Cerca nelle preferenze

## Preferences UI Search Results

search-results-header = Risultati della ricerca
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Siamo spiacenti, nessun risultato trovato per “<span data-l10n-name="query"></span>” nelle opzioni.
       *[other] Siamo spiacenti, nessun risultato trovato per “<span data-l10n-name="query"></span>” nelle preferenze.
    }
search-results-help-link = Hai bisogno di aiuto? Visita <a data-l10n-name="url">il sito web dedicato al supporto di { -brand-short-name }</a>.
