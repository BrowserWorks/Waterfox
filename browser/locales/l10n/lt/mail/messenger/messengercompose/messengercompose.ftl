# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Pašalinti lauką { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Pašalinti „{ $type }“ lauką

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

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } priedai
            [one] { $count }priedas
            [few] { $count }priedai
           *[other] { $count } priedų
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Patvirtinimas
    .tooltiptext = Paprašyti pristatymo patvirtinimo šiam pranešimui
