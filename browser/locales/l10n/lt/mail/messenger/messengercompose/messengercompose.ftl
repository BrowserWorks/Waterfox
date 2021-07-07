# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] Yra vienas “{ $type }“ adresatas, naudokite „Rodyklė kairė" klavišą kad jį parinktumėte.
        [few] Yra { $count } „{ $type }“ adresatai, naudokite „Rodyklė kairė" klavišą kad juo parinktumėte.
       *[other] Yra { $count } „{ $type }“ adresatų, naudokite „Rodyklė kairė" klavišą kad juos parinktumėte.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] „{ $email }“: klavišas „Įvesti“ leidžia redaguoti, klavišas “Šalinti“ jį pašalins.
        [few] „{ $email }“, 1 iš { $count }: klavišas „Įvesti“ leidžia juos redaguoti, klavišas “Šalinti“ juos pašalins.
       *[other] „{ $email }“, 1 iš { $count }: klavišas „Įvesti“ leidžia juos redaguoti, klavišas “Šalinti“ juos pašalins.
    }

#   $email (String) - the email address
pill-tooltip-invalid-address = „{ $email }“ nėra tinkamas el. pašto adresas

#   $email (String) - the email address
pill-tooltip-not-in-address-book = „{ $email }“ nėra jūsų adresų knygoje

pill-action-edit =
    .label = Keisti adresą
    .accesskey = e

pill-action-move-to =
    .label = Perkelti į Kam
    .accesskey = k

pill-action-move-cc =
    .label = Perkelti į CC
    .accesskey = c

pill-action-move-bcc =
    .label = Perkelti į BCC
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
    .label = Priedų polangis
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }

toolbar-button-add-attachment =
    .label = Pridėti
    .tooltiptext = Pridėti ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })

add-attachment-notification-reminder =
    .label = Priedai …
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }

menuitem-attach-files =
    .label = Failas (-ai)…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = Prisegti failą (-us)…
    .accesskey = f
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } priedų
            [one] { $count } priedas
            [few] { $count } priedai
           *[other] { $count } priedų
        }
    .accesskey = m

expand-attachment-pane-tooltip =
    .tooltiptext = Rodyti priedų polangį ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

collapse-attachment-pane-tooltip =
    .tooltiptext = Slėpti priedų polangį ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

drop-file-label-attachment =
    { $count ->
        [one] Pridėti kaip priedą
        [few] Pridėti kaip priedus
       *[other] Pridėti kaip priedus
    }

drop-file-label-inline =
    { $count ->
        [one] Įterpti į turinį
        [few] Įterpti į turinį
       *[other] Įterpti į turinį
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Perkelti į pradžią
move-attachment-left-panel-button =
    .label = Perkelti kairėn
move-attachment-right-panel-button =
    .label = Perkelti dešinėn
move-attachment-last-panel-button =
    .label = Perkelti į pabaigą

button-return-receipt =
    .label = Patvirtinimas
    .tooltiptext = Paprašyti pristatymo patvirtinimo šiam pranešimui

# Encryption

# Addressing Area

to-compose-address-row-label =
    .value = Kam

#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = { to-compose-address-row-label.value } laukas
    .accesskey = l
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Parodyti { to-compose-address-row-label.value } lauką ({ to-compose-show-address-row-menuitem.acceltext })

cc-compose-address-row-label =
    .value = Kopija

#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = { cc-compose-address-row-label.value } lauks
    .accesskey = l
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Parodo { cc-compose-address-row-label.value } lauką ({ cc-compose-show-address-row-menuitem.acceltext })

bcc-compose-address-row-label =
    .value = Nematoma kopija

#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = { bcc-compose-address-row-label.value } laukas
    .accesskey = l
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }

bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Parodo { bcc-compose-address-row-label.value } lauką ({ bcc-compose-show-address-row-menuitem.acceltext })

#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = { $count } gavėjai iš „To“ ir „Cc“ gali matyti vienas kito adresą. Jei norite to išvengti, naudokite nematomas kopijas (Bcc).


many-public-recipients-bcc =
    .label = Vietoj to naudoti nematomas kopijas (BCC)
    .accesskey = n

many-public-recipients-ignore =
    .label = Gavėjai matys kitus adresus
    .accesskey = m

## Notifications

## Editing

# Tools

