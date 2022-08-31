# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Formato di invio
    .accesskey = F

compose-send-auto-menu-item =
    .label = Automatico
    .accesskey = A

compose-send-both-menu-item =
    .label = HTML e testo semplice
    .accesskey = H

compose-send-html-menu-item =
    .label = Solo HTML
    .accesskey = S

compose-send-plain-menu-item =
    .label = Solo testo semplice
    .accesskey = t

## Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Elimina il campo { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } con un indirizzo, usa il tasto freccia sinistra per porre il focus su di esso.
       *[other] { $type } con { $count } indirizzi, usa il tasto freccia sinistra per porre il focus su di essi.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: premi Invio per modificare, Canc per eliminare.
       *[other] { $email }, 1 di { $count }: premi Invio per modificare, Canc per eliminare.
    }

#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } non è un indirizzo email valido

#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } non è presente nella rubrica

pill-action-edit =
    .label = Modifica indirizzo
    .accesskey = M

#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Seleziona tutti gli indirizzi in { $type }
    .accesskey = u

pill-action-select-all-pills =
    .label = Seleziona tutti gli indirizzi
    .accesskey = u

pill-action-move-to =
    .label = Sposta in A
    .accesskey = S

pill-action-move-cc =
    .label = Sposta in Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Sposta in Ccn
    .accesskey = n

pill-action-expand-list =
    .label = Espandi elenco
    .accesskey = E

## Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }

trigger-attachment-picker-key = A
toggle-attachment-pane-key = M

menuitem-toggle-attachment-pane =
    .label = Pannello allegati
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }

toolbar-button-add-attachment =
    .label = Allega
    .tooltiptext = Aggiungi un allegato ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })

add-attachment-notification-reminder2 =
    .label = Aggiungi allegato…
    .accesskey = A
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }

menuitem-attach-files =
    .label = File…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = Allega file…
    .accesskey = f
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = La mia vCard
    .accesskey = C

context-menuitem-attach-openpgp-key =
    .label = La mia chiave pubblica OpenPGP
    .accesskey = O

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [one] { $count } allegato
       *[other] { $count } allegati
    }

attachment-area-show =
    .title = Mostra il pannello degli allegati ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

attachment-area-hide =
    .title = Nascondi il pannello degli allegati ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

drop-file-label-attachment =
    { $count ->
        [one] Aggiungi come allegato
       *[other] Aggiungi come allegati
    }

drop-file-label-inline =
    { $count ->
        [one] Aggiungi in linea
       *[other] Aggiungi in linea
    }

## Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Sposta all’inizio
move-attachment-left-panel-button =
    .label = Sposta a sinistra
move-attachment-right-panel-button =
    .label = Sposta a destra
move-attachment-last-panel-button =
    .label = Sposta alla fine

button-return-receipt =
    .label = Ricevuta
    .tooltiptext = Richiedi una ricevuta di ritorno per questo messaggio

## Encryption

encryption-menu =
    .label = Sicurezza
    .accesskey = S

encryption-toggle =
    .label = Critta
    .tooltiptext = Utilizza crittografia end-to-end per questo messaggio

encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Visualizza o modifica le impostazioni della crittografia OpenPGP

encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Visualizza o modifica le impostazioni della crittografia S/MIME

signing-toggle =
    .label = Firma
    .tooltiptext = Utilizza la firma digitale per questo messaggio

menu-openpgp =
    .label = OpenPGP
    .accesskey = O

menu-smime =
    .label = S/MIME
    .accesskey = S

menu-encrypt =
    .label = Critta
    .accesskey = C

menu-encrypt-subject =
    .label = Critta l’oggetto
    .accesskey = o

menu-sign =
    .label = Apponi firma digitale
    .accesskey = f

menu-manage-keys =
    .label = Assistente chiavi
    .accesskey = A

menu-view-certificates =
    .label = Visualizza certificati dei destinatari
    .accesskey = V

menu-open-key-manager =
    .label = Gestore chiavi
    .accesskey = G

openpgp-key-issue-notification-one = Per utilizzare la crittografia end-to-end è necessario risolvere i problemi con la chiave per { $addr }
openpgp-key-issue-notification-many = Per utilizzare la crittografia end-to-end è necessario risolvere i problemi con la chiave per { $count } destinatari.

smime-cert-issue-notification-one = Per utilizzare la crittografia end-to-end è necessario risolvere i problemi con il certificato per { $addr }
smime-cert-issue-notification-many = Per utilizzare la crittografia end-to-end è necessario risolvere i problemi con il certificato per { $count } destinatari.

key-notification-disable-encryption =
    .label = Non crittare
    .accesskey = N
    .tooltiptext = Disattiva la crittografia end-to-end

key-notification-resolve =
    .label = Risolvi…
    .accesskey = R
    .tooltiptext = Apri l’assistente chiavi OpenPGP

can-encrypt-smime-notification = È possibile utilizzare la crittografia end-to-end S/MIME.

can-encrypt-openpgp-notification = È possibile utilizzare la crittografia end-to-end OpenPGP.

can-e2e-encrypt-button =
    .label = Critta
    .accesskey = C

## Addressing Area

to-address-row-label =
    .value = A

#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Campo A
    .accesskey = a
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = A
    .accesskey = A

#   $key (String) - the shortcut key for this field
show-to-row-button = A
    .title = Mostra il campo A ({ ctrl-cmd-shift-pretty-prefix }{ $key })


cc-address-row-label =
    .value = Cc

#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Campo Cc
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C

#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Mostra il campo Cc ({ ctrl-cmd-shift-pretty-prefix }{ $key })


bcc-address-row-label =
    .value = Ccn

#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Campo Ccn
    .accesskey = o
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Ccn
    .accesskey = n

#   $key (String) - the shortcut key for this field
show-bcc-row-button = Ccn
    .title = Mostra il campo Ccn ({ ctrl-cmd-shift-pretty-prefix }{ $key })

extra-address-rows-menu-button =
    .title = Altri campi destinatario da mostrare

#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Il tuo messaggio ha un destinatario pubblico. Puoi evitare di mostrare gli indirizzi dei destinatari utilizzando Ccn.
       *[other] I { $count } destinatari inseriti nei campi A e Cc possono vedere i rispettivi indirizzi. Puoi evitare di mostrare gli indirizzi dei destinatari utilizzando Ccn.
    }
many-public-recipients-bcc =
    .label = Utilizza Ccn
    .accesskey = U

many-public-recipients-ignore =
    .label = Mantieni i destinatari visibili
    .accesskey = M

many-public-recipients-prompt-title = Troppi destinatari pubblici

#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Il tuo messaggio ha un destinatario pubblico. Questo potrebbe essere un problema di privacy. Puoi evitare di rivelare i destinatari spostando i destinatari da A/Cc a Ccn.
       *[other] Il tuo messaggio ha { $count } destinatari pubblici che potranno vedere gli indirizzi degli altri. Questo potrebbe essere un problema di privacy. Puoi evitare di rivelare i destinatari spostando i destinatari da A/Cc a Ccn.
    }

many-public-recipients-prompt-cancel = Annulla invio
many-public-recipients-prompt-send = Invia comunque

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Non è stata trovata un’identità univoca che corrisponde all’indirizzo Da. Il messaggio verrà inviato utilizzando il campo Da e le impostazioni correnti dall’identità { $identity }.

encrypted-bcc-warning = Quando si invia un messaggio crittato, i destinatari in Ccn non sono completamente nascosti. Tutti i destinatari possono essere in grado di identificarli.

encrypted-bcc-ignore-button = Ho capito

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Rimuovi stili di testo

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Caricato su un account Filelink sconosciuto.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } - Allegato Filelink

# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = Il file { $filename } è stato allegato come Filelink. Può essere scaricato dal link sottostante.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] Ho collegato { $count } file a questa email:
       *[other] Ho collegato { $count } file a questa email:
    }

# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Ulteriori informazioni su { $link }.

# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Ulteriori informazioni su { $firstLinks } e { $lastLink }.

# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Collegamento protetto da password

# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Servizio Filelink:
cloud-file-template-size = Dimensione:
cloud-file-template-link = Collegamento:
cloud-file-template-password-protected-link = Collegamento protetto da password:
cloud-file-template-expiry-date = Data di scadenza:
cloud-file-template-download-limit = Limite di download:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Errore di connessione
cloud-file-connection-error = { -brand-short-name } non è in linea. Impossibile connettersi a { $provider }.

# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Impossibile caricare { $filename } su { $provider }

# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Errore nella ridenominazione
cloud-file-rename-error = Si è verificato un problema durante la ridenominazione di { $filename } su { $provider }.

# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Impossibile rinominare { $filename } su { $provider }

# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } non supporta la ridenominazione di file già caricati.

# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Errore con l’allegato Filelink
cloud-file-attachment-error = Non è stato possibile aggiornare l’allegato Filelink { $filename } in quanto il relativo file locale è stato spostato o eliminato.

# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Errore con l’account Filelink
cloud-file-account-error = Non è stato possibile aggiornare l’allegato Filelink { $filename } in quanto il relativo account Filelink è stato eliminato.

## Link Preview

link-preview-title = Anteprima del link
link-preview-description = { -brand-short-name } può incorporare un’anteprima quando viene inserito un link.
link-preview-autoadd = Aggiungi automaticamente un’anteprima dei link quando possibile
link-preview-replace-now = Aggiungere un’anteprima per questo link?
link-preview-yes-replace = Sì

## Dictionary selection popup

spell-add-dictionaries =
    .label = Aggiungi dizionari…
    .accesskey = z
