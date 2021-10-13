# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

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

# Attachment widget

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
add-attachment-notification-reminder =
    .label = Aggiungi allegato…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
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
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    { $count ->
        [1] { $count } allegato
       *[other] { $count } allegati
    }
expand-attachment-pane-tooltip =
    .tooltiptext = Mostra il pannello degli allegati ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Nascondi il pannello degli allegati ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
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

# Reorder Attachment Panel

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

# Encryption

message-to-be-signed-icon =
    .alt = Firma il messaggio
message-to-be-encrypted-icon =
    .alt = Critta il messaggio

# Addressing Area

to-compose-address-row-label =
    .value = A
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Campo { to-compose-address-row-label.value }
    .accesskey = a
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Mostra campo { to-compose-address-row-label.value } ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Campo { cc-compose-address-row-label.value }
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Mostra campo { cc-compose-address-row-label.value } ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Ccn
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Campo { bcc-compose-address-row-label.value }
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Mostra campo { bcc-compose-address-row-label.value } ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = I { $count } destinatari inseriti nei campi A e Cc possono vedere i rispettivi indirizzi. Puoi evitare di mostrare gli indirizzi dei destinatari utilizzando Ccn.
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
