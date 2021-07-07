# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = { $type }-Eingabefeld entfernen

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = { $type }-Eingabefeld entfernen

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = { $type }-Eingabefeld entfernen

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label = { $count ->
    [0]     { $type }
    [one]   { $type } mit einer Adresse, Pfeil-nach-links-Taste zum Auswählen verwenden
    *[other] { $type } mit { $count } Adressen, Pfeil-nach-links-Taste zum Auswählen verwenden
}

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label = { $count ->
    [one]   { $email }: zum Bearbeiten Eingabetaste drücken, Entfernen-Taste zum Entfernen.
    *[other] { $email }, 1 von { $count }: zum Bearbeiten Eingabetaste drücken, Entfernen-Taste zum Entfernen.
}

#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } ist keine gültige E-Mail-Adresse.

#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } ist nicht in Ihrem Adressbuch.

pill-action-edit =
    .label = Adresse bearbeiten
    .accesskey = r

pill-action-move-to =
    .label = Verschieben zu An
    .accesskey = A

pill-action-move-cc =
    .label = Verschieben zu Kopie (CC)
    .accesskey = C

pill-action-move-bcc =
    .label = Verschieben zu Blindkopie (BCC)
    .accesskey = B

pill-action-expand-list =
    .label = Liste durch ihre Kontakte ersetzen
    .accesskey = z

# Attachment widget

ctrl-cmd-shift-pretty-prefix = {
  PLATFORM() ->
    [macos] ⇧ ⌘{" "}
   *[other] Strg+Umschalt+
}

trigger-attachment-picker-key = A
toggle-attachment-pane-key = M

menuitem-toggle-attachment-pane =
    .label = Anhangbereich
    .accesskey = n
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }

toolbar-button-add-attachment =
    .label = Anhängen
    .tooltiptext = Anhang hinzufügen ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })

add-attachment-notification-reminder =
    .label = Anhang hinzufügen…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }

menuitem-attach-files =
    .label = Datei(en)…
    .accesskey = D
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = Datei(en) anhängen…
    .accesskey = D
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count = { $count ->
    [1]      { $count } Anhang
    *[other] { $count } Anhänge
}

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext = { $count ->
        [1]      { $count } Anhang
        *[other] { $count } Anhänge
    }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

expand-attachment-pane-tooltip =
    .tooltiptext = Anhangbereich anzeigen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

collapse-attachment-pane-tooltip =
    .tooltiptext = Anhangbereich ausblenden ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

drop-file-label-attachment = { $count ->
    [one]   Als Anhang hinzufügen
   *[other] Als Anhänge hinzufügen
}

drop-file-label-inline = { $count ->
    [one]   In Nachricht einfügen
   *[other] In Nachricht einfügen
}

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = An Anfang verschieben
move-attachment-left-panel-button =
    .label = Nach links verschieben
move-attachment-right-panel-button =
    .label = Nach rechts verschieben
move-attachment-last-panel-button =
    .label = An Ende verschieben

button-return-receipt =
    .label = Empfangsbestätigung
    .tooltiptext = Eine Empfangsbestätigung für diese Nachricht anfordern

#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
consider-bcc-notification = Die {$count} Empfänger in den Feldern "An" und "Kopie (CC)" können die Adressen aller Beteiligten in diesen Feldern sehen. Das Veröffentlichen der Empfänger kann durch Verwenden des Feldes "Blindkopie (BCC)" verhindert werden.

# Addressing Area

to-compose-address-row-label =
    .value = An

#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Feld "{ to-compose-address-row-label.value }"
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Anzeigen des Feldes "{ to-compose-address-row-label.value }" ({ to-compose-show-address-row-menuitem.acceltext })

cc-compose-address-row-label =
    .value = Kopie (CC)

#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Feld "{ cc-compose-address-row-label.value }"
    .accesskey = K
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Anzeigen des Feldes "{ cc-compose-address-row-label.value }" ({ cc-compose-show-address-row-menuitem.acceltext })

bcc-compose-address-row-label =
    .value = Blindkopie (BCC)

#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Feld "{ bcc-compose-address-row-label.value }"
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Anzeigen des Feldes "{ bcc-compose-address-row-label.value }" ({ bcc-compose-show-address-row-menuitem.acceltext })

#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = Die {$count} Empfänger in den Feldern "An" und "Kopie (CC)" können die Adressen aller Beteiligten in diesen Feldern sehen. Das Veröffentlichen der Empfänger kann durch Verwenden des Feldes "Blindkopie (BCC)" verhindert werden.

many-public-recipients-bcc =
  .label = Blindkopie (BCC) stattdessen verwenden
  .accesskey = C

many-public-recipients-ignore =
  .label = Empfänger öffentlich belassen
  .accesskey  = E

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Es wurde keine Identität gefunden, welche mit der E-Mail-Adresse im "Von"-Feld übereinstimmt. Die Nachricht wird mit der derzeit im "Von"-Feld eingegebenen Adresse und den Einstellungen von { $identity } gesendet.
