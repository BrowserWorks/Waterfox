# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Odstrani polje { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Odstrani polje { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } z enim naslovom, uporabite tipko leve puščice, da ga izberete.
        [two] { $type } z { $count } naslovoma, uporabite tipko leve puščice, da ju izberete.
        [few] { $type } s { $count } naslovi, uporabite tipko leve puščice, da jih izberete.
       *[other] { $type } s { $count } naslovi, uporabite tipko leve puščice, da jih izberete.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: pritisnite Enter za urejanje ali Delete za odstranitev
        [two] { $email }, 1 od { $count }: pritisnite Enter za urejanje ali Delete za odstranitev
        [few] { $email }, 1 od { $count }: pritisnite Enter za urejanje ali Delete za odstranitev
       *[other] { $email }, 1 od { $count }: pritisnite Enter za urejanje ali Delete za odstranitev
    }

pill-action-edit =
    .label = Uredi naslov
    .accesskey = U

pill-action-move-to =
    .label = Premakni v Za
    .accesskey = Z

pill-action-move-cc =
    .label = Premakni v Kp
    .accesskey = K

pill-action-move-bcc =
    .label = Premakni v Skp
    .accesskey = S

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } priponka
            [one] { $count } priponka
            [two] { $count } priponki
            [few] { $count } priponke
           *[other] { $count } priponke
        }
    .accesskey = p

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } priponka
            [one] { $count } priponka
            [two] { $count } priponki
            [few] { $count } priponke
           *[other] { $count } priponk
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Povratnica
    .tooltiptext = Zahtevaj potrdilo o prejemu za to sporočilo
