# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = A(z) { $type } mező eltávolítása
#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = A(z) { $type } mező eltávolítása
#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = A(z) { $type } mező eltávolítása
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } egy címmel, használja a bal nyíl billentyűt a ráfókuszáláshoz.
       *[other] { $type } { $count } címmel, használja a bal nyíl billentyűt a rájuk fókuszáláshoz.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: nyomjon Entert a szerkesztéshez, Delete gombot az eltávolításhoz.
       *[other] { $email }, 1 / { $count }: nyomjon Entert a szerkesztéshez, Delete gombot az eltávolításhoz.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } nem érvényes e-mail-cím
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } nincs a címjegyzékében
pill-action-edit =
    .label = Cím szerkesztése
    .accesskey = e
pill-action-move-to =
    .label = Áthelyezés a címzettbe
    .accesskey = t
pill-action-move-cc =
    .label = Áthelyezés a másolatba
    .accesskey = m
pill-action-move-bcc =
    .label = Áthelyezés a vakmásolatba
    .accesskey = v
pill-action-expand-list =
    .label = Lista kibontása
    .accesskey = b

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Mellékletek ablaktábla
    .accesskey = M
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Melléklet
    .tooltiptext = Melléklet hozzáadása ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Melléklet hozzáadása…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Fájlok…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Fájlok csatolása…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } melléklet
            [one] { $count } melléklet
           *[other] { $count } melléklet
        }
    .accesskey = m
#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } melléklet
            [one] { $count } melléklet
           *[other] { $count } melléklet
        }
#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }
expand-attachment-pane-tooltip =
    .tooltiptext = A mellékletek ablaktábla megjelenítése ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = A mellékletek ablaktábla elrejtése ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Hozzáadás mellékletként
       *[other] Hozzáadás mellékletekként
    }
drop-file-label-inline =
    { $count ->
        [one] Hozzáfűzés soron belül
       *[other] Hozzáfűzés soron belül
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Áthelyezés elsőnek
move-attachment-left-panel-button =
    .label = Áthelyezés balra
move-attachment-right-panel-button =
    .label = Áthelyezés jobbra
move-attachment-last-panel-button =
    .label = Áthelyezés utolsónak
button-return-receipt =
    .label = Visszaigazolás
    .tooltiptext = Visszaigazolás kérése az üzenetről

# Addressing Area

to-compose-address-row-label =
    .value = Címzett
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = { to-compose-address-row-label.value } mező
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = A { to-compose-address-row-label.value } mező megjelenítése ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Másolatot kap
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = { cc-compose-address-row-label.value } mező
    .accesskey = M
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = A { cc-compose-address-row-label.value } mező megjelenítése ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Rejtett másolatot kap
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = { bcc-compose-address-row-label.value } mező
    .accesskey = R
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = A { bcc-compose-address-row-label.value } mező megjelenítése ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = A címzett és másolatot kapó { $count } partner látni fogja egymás címét. Elkerülheti a címzettek közzétételét, ha helyette titkos másolatot használ.
many-public-recipients-bcc =
    .label = Helyette titkos másolat használata
    .accesskey = H
many-public-recipients-ignore =
    .label = A címzettek legyenek nyilvánosak
    .accesskey = l

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Nem található egyedi személyazonosság, amely egyezik a feladó címével. Az üzenete a jelenlegi Feladó mező, és a(z) { $identity } személyazonosság beállításaival lesz elküldve.
encrypted-bcc-warning = Titkosított üzenet küldésekor a Titkos másolatot kapóként hozzáadott címzettjei nincsenek teljesen elrejtve. Minden címzett képes lehet azonosítani őket.
encrypted-bcc-ignore-button = Értettem
