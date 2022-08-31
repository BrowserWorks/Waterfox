# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

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

menuitem-attach-files =
    .label = Failas (-ai)…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = Prisegti failą (-us)…
    .accesskey = f
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

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


many-public-recipients-bcc =
    .label = Vietoj to naudoti nematomas kopijas (BCC)
    .accesskey = n

many-public-recipients-ignore =
    .label = Gavėjai matys kitus adresus
    .accesskey = m

## Notifications

## Editing

# Tools

## Filelink

# Placeholder file

# Template

# Messages

## Link Preview

## Dictionary selection popup

