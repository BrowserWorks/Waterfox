# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Usuń adresy z pola „{ $type }”

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Usuń adresy z pola „{ $type }”

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] Pole „{ $type }” z jednym adresem, użyj strzałki w lewo, aby go aktywować.
        [few] Pole „{ $type }” z { $count } adresami, użyj strzałki w lewo, aby je aktywować.
       *[many] Pole „{ $type }” z { $count } adresami, użyj strzałki w lewo, aby je aktywować.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: naciśnij Enter, aby edytować, Delete, aby usunąć.
        [few] { $email }, 1 z { $count }: naciśnij Enter, aby edytować, Delete, aby usunąć.
       *[many] { $email }, 1 z { $count }: naciśnij Enter, aby edytować, Delete, aby usunąć.
    }

pill-action-edit =
    .label = Edytuj adres
    .accesskey = E

pill-action-move-to =
    .label = Przenieś do pola „Do”
    .accesskey = D

pill-action-move-cc =
    .label = Przenieś do pola „Kopia”
    .accesskey = K

pill-action-move-bcc =
    .label = Przenieś do pola „Ukryta kopia”
    .accesskey = U

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } załącznik
            [one] { $count } załącznik
            [few] { $count } załączniki
           *[many] { $count } załączników
        }
    .accesskey = z

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } załącznik
            [one] { $count } załącznik
            [few] { $count } załączniki
           *[many] { $count } załączników
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Potwierdzenie
    .tooltiptext = Żądaj potwierdzenia dostarczenia tej wiadomości
