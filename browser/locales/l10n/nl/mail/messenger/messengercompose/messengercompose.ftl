# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Het veld { $type } verwijderen
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } met een adres, gebruik de linkerpijltoets om de focus erop te zetten.
       *[other] { $type } met { $count } adressen, gebruik de linkerpijltoets om de focus erop te zetten.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: druk Enter om te bewerken, Delete om te verwijderen.
       *[other] { $email }, 1 van { $count }: druk Enter om te bewerken, Delete om te verwijderen.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } is geen geldig e-mailadres
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } staat niet in uw adresboek
pill-action-edit =
    .label = Adres bewerken
    .accesskey = d
pill-action-move-to =
    .label = Verplaatsen naar Aan
    .accesskey = A
pill-action-move-cc =
    .label = Verplaatsen naar Cc
    .accesskey = c
pill-action-move-bcc =
    .label = Verplaatsen naar Bcc
    .accesskey = B
pill-action-expand-list =
    .label = Lijst uitvouwen
    .accesskey = w

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Bijlagepaneel
    .accesskey = l
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Koppelen
    .tooltiptext = Een bijlage toevoegen ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Bijlage toevoegen…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = Bijlage toevoegen…
    .accesskey = B
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Bestand(en)…
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Bestand(en) koppelen…
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [one] { $count } bijlage
           *[other] { $count } bijlagen
        }
    .accesskey = l
expand-attachment-pane-tooltip =
    .tooltiptext = Het bijlagevenster tonen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Het bijlagevenster verbergen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Het bijlagevenster tonen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Het bijlagevenster verbergen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Als bijlage toevoegen
       *[other] Als bijlagen toevoegen
    }
drop-file-label-inline =
    { $count ->
        [one] Inline toevoegen
       *[other] Inline toevoegen
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Naar de eerste
move-attachment-left-panel-button =
    .label = Naar links
move-attachment-right-panel-button =
    .label = Naar rechts
move-attachment-last-panel-button =
    .label = Naar de laatste
button-return-receipt =
    .label = Ontvangstbevestiging
    .tooltiptext = Een ontvangstbevestiging voor dit bericht vragen

# Encryption

message-to-be-signed-icon =
    .alt = Bericht ondertekenen
message-to-be-encrypted-icon =
    .alt = Bericht versleutelen

# Addressing Area

to-compose-address-row-label =
    .value = Aan
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Veld { to-compose-address-row-label.value }
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Veld { to-compose-address-row-label.value } tonen ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Veld { cc-compose-address-row-label.value }
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Veld { cc-compose-address-row-label.value } tonen ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Veld { bcc-compose-address-row-label.value }
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Veld { bcc-compose-address-row-label.value } tonen ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = De { $count } ontvangers in Aan en Cc zullen elkaars adres zien. U kunt voorkomen dat ontvangers worden onthuld door in plaats hiervan Bcc te gebruiken.
to-address-row-label =
    .value = Aan
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Aan-veld
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Aan
    .accesskey = A
#   $key (String) - the shortcut key for this field
show-to-row-button = Aan
    .title = Aan-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Cc-veld
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Cc-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Bcc-veld
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Bcc
    .accesskey = B
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Bcc
    .title = Bcc-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Andere te tonen adresvelden
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Uw bericht heeft een openbare ontvanger. U kunt voorkomen dat ontvangers worden onthuld door in plaats hiervan Bcc te gebruiken.
       *[other] De { $count } ontvangers in Aan en Cc zullen elkaars adres zien. U kunt voorkomen dat ontvangers worden onthuld door in plaats hiervan Bcc te gebruiken.
    }
many-public-recipients-bcc =
    .label = In plaats hiervan Bcc gebruiken
    .accesskey = g
many-public-recipients-ignore =
    .label = Ontvangers openbaar laten
    .accesskey = l
many-public-recipients-prompt-title = Te veel openbare ontvangers
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Uw bericht heeft een openbare ontvanger. Dit kan een privacyprobleem zijn. U kunt dit voorkomen door de ontvanger in plaats van Aan/Cc naar Bcc te verplaatsen.
       *[other] Uw bericht heeft { $count } openbare ontvangers, die elkaars adressen kunnen zien. Dit kan een privacyprobleem zijn. U kunt voorkomen dat ontvangers openbaar worden gemaakt door ontvangers in plaats van Aan/Cc naar Bcc te verplaatsen.
    }
many-public-recipients-prompt-cancel = Verzenden annuleren
many-public-recipients-prompt-send = Toch verzenden

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Er is geen unieke identiteit gevonden die met het Van-adres overeenkomt. Het bericht zal worden verzonden met het Van-veld en de instellingen van identiteit { $identity }.
encrypted-bcc-warning = Als u een versleuteld bericht verstuurt, worden ontvangers in Bcc niet volledig verborgen. Alle ontvangers kunnen ze mogelijk identificeren.
encrypted-bcc-ignore-button = Begrepen

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Tekstopmaak verwijderen
