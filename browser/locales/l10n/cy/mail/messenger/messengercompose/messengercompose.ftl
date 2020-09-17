# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Tynnwch y maes { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Tynnwch y maes { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [zero] { $type } gydag un cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arno.
        [one] { $type } gyda { $count } cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arnyn nhw.
        [two] { $type } gyda { $count } cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arnyn nhw.
        [few] { $type } gyda { $count } cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arnyn nhw.
        [many] { $type } gyda { $count } cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arnyn nhw.
       *[other] { $type } gyda { $count } cyfeiriad, defnyddiwch fysell y saeth chwith i ganolbwyntio arnyn nhw.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [zero] { $email }, 1 o { $count }: pwyswch Enter i olygu, Delete i ddileu
        [one] { $email }: pwyswch Enter i olygu, Delete i ddileu
        [two] { $email }, 1 o { $count }: pwyswch Enter i olygu, Delete i ddileu
        [few] { $email }, 1 o { $count }: pwyswch Enter i olygu, Delete i ddileu
        [many] { $email }, 1 o { $count }: pwyswch Enter i olygu, Delete i ddileu
       *[other] { $email }, 1 o { $count }: pwyswch Enter i olygu, Delete i ddileu
    }

pill-action-edit =
    .label = Golygu Cyfeiriad
    .accesskey = G

pill-action-move-to =
    .label = Symud i
    .accesskey = S

pill-action-move-cc =
    .label = Symud i CC
    .accesskey = C

pill-action-move-bcc =
    .label = Symud i Bcc
    .accesskey = B

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } Atodiad
            [zero] { $count } Atodiadau
            [one] { $count } Atodiad
            [two] { $count } Atodiad
            [few] { $count } Atodiad
            [many] { $count } Atodiad
           *[other] { $count } Atodiad
        }
    .accesskey = A

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] Atodiadau
            [zero] { $count } Atodiadau
            [one] { $count } Atodiad
            [two] { $count } Atodiad
            [few] { $count } Atodiad
            [many] { $count } Atodiad
           *[other] { $count } Atodiad
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Derbynneb
    .tooltiptext = Gofyn am dderbynneb dychwelyd i'r neges hon
