# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Supprimer le champ { $type }
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } avec une adresse, utilisez la touche flèche gauche pour la sélectionner.
       *[other] { $type } avec { $count } adresses, utilisez la touche flèche gauche pour les sélectionner.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email } : appuyez sur Entrée pour modifier, ou Supprimer pour retirer.
       *[other] { $email }, 1 sur { $count } : appuyez sur Entrée pour modifier, ou Supprimer pour retirer.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } n’est pas une adresse électronique valide
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } ne figure pas dans votre carnet d’adresses
pill-action-edit =
    .label = Modifier l’adresse
    .accesskey = M
pill-action-move-to =
    .label = Déplacer vers Pour
    .accesskey = p
pill-action-move-cc =
    .label = Déplacer vers Copie à
    .accesskey = c
pill-action-move-bcc =
    .label = Déplacer vers Copie cachée à
    .accesskey = h
pill-action-expand-list =
    .label = Développer la liste
    .accesskey = D

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Maj+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Panneau des pièces jointes
    .accesskey = n
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Joindre
    .tooltiptext = Ajouter une pièce jointe ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Ajouter une pièce jointe…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = Ajouter une pièce jointe…
    .accesskey = j
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Fichier(s)…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Joindre fichier(s)…
    .accesskey = f
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } pièce jointe
           *[other] { $count } pièces jointes
        }
    .accesskey = o
expand-attachment-pane-tooltip =
    .tooltiptext = Afficher le volet des pièces jointes ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Masquer le volet des pièces jointes ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Afficher le volet des pièces jointes ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Masquer le volet des pièces jointes ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Ajouter comme pièce jointe
       *[other] Ajouter comme pièces jointes
    }
drop-file-label-inline =
    { $count ->
        [one] Ajouter au corps du message
       *[other] Ajouter au corps du message
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = En premier
move-attachment-left-panel-button =
    .label = Vers la gauche
move-attachment-right-panel-button =
    .label = Vers la droite
move-attachment-last-panel-button =
    .label = En dernier
button-return-receipt =
    .label = Accusé de réception
    .tooltiptext = Demander un accusé de réception pour ce message

# Encryption

message-to-be-signed-icon =
    .alt = Signer le message
message-to-be-encrypted-icon =
    .alt = Chiffrer le message

# Addressing Area

to-compose-address-row-label =
    .value = Pour
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Champ { to-compose-address-row-label.value }
    .accesskey = p
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Afficher le champ { to-compose-address-row-label.value } ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Copie à
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Champ { cc-compose-address-row-label.value }
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Afficher le champ { cc-compose-address-row-label.value } ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Copie cachée à
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Champ { bcc-compose-address-row-label.value }
    .accesskey = h
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Afficher le champ { bcc-compose-address-row-label.value } ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = Les { $count } destinataires en « Pour » et « Copie à » verront les adresses des autres. Vous pouvez éviter de révéler les destinataires en utilisant plutôt « Copie cachée à ».
to-address-row-label =
    .value = Pour
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Champ Pour
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Pour
    .accesskey = P
#   $key (String) - the shortcut key for this field
show-to-row-button = Pour
    .title = Afficher le champ Pour ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Copie à
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Champ Copie à
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Copie à
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Copie à
    .title = Afficher le champ Copie à ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Copie cachée à
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Champ Copie cachée à
    .accesskey = h
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Copie cachée à
    .accesskey = h
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Copie cachée à
    .title = Afficher le champ Copie cachée à ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Autres champs d’adressage à afficher
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Votre message a un destinataire public. Vous pouvez éviter de révéler les destinataires en utilisant plutôt « Copie cachée à ».
       *[other] Les { $count } destinataires en « Pour » et « Copie à » verront les adresses des autres. Vous pouvez éviter de révéler les destinataires en utilisant plutôt « Copie cachée à ».
    }
many-public-recipients-bcc =
    .label = Utiliser plutôt la Copie cachée
    .accesskey = U
many-public-recipients-ignore =
    .label = Garder les destinataires publics
    .accesskey = G
many-public-recipients-prompt-title = Trop de destinataires publics
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Votre message a un destinataire public. Cela peut être un problème de confidentialité. Vous pouvez l’éviter en déplaçant plutôt le destinataire vers « Copie cachée à ».
       *[other] Votre message a { $count } destinataires publics, qui pourront voir les adresses les uns des autres. Cela peut être un problème de confidentialité. Vous pouvez éviter de divulguer les destinataires en déplaçant plutôt ceux-ci vers « Copie cachée à ».
    }
many-public-recipients-prompt-cancel = Annuler l’envoi
many-public-recipients-prompt-send = Envoyer quand même

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Une identité unique correspondant à l’adresse d’expédition n’a pas été trouvée. Le message sera envoyé en utilisant l’adresse d’expédition actuelle avec les paramètres de l’identité { $identity }.
encrypted-bcc-warning = Lors de l’envoi d’un message chiffré, les destinataires en copie cachée ne sont pas complètement masqués. Tous les destinataires pourraient les identifier.
encrypted-bcc-ignore-button = C’est compris

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Supprimer le style du texte
