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
remove-address-row-button =
    .title = Usuń adresy z pola „{ $type }”
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
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } nie jest prawidłowym adresem e-mail
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } nie jest w książce adresowej
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
pill-action-expand-list =
    .label = Rozwiń listę
    .accesskey = R

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Lista załączników
    .accesskey = L
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Załącz
    .tooltiptext = Dodaj pliki do tej wiadomości ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Dodaj załącznik…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Plik…
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Załącz plik…
    .accesskey = Z
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
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
expand-attachment-pane-tooltip =
    .tooltiptext = Pokaż listę załączników ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Ukryj listę załączników ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Dodaj jako załącznik
        [few] Dodaj jako załączniki
       *[many] Dodaj jako załączniki
    }
drop-file-label-inline =
    { $count ->
        [one] Wstaw w treści
        [few] Wstaw w treści
       *[many] Wstaw w treści
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Przenieś na początek
move-attachment-left-panel-button =
    .label = Przenieś w lewo
move-attachment-right-panel-button =
    .label = Przenieś w prawo
move-attachment-last-panel-button =
    .label = Przenieś na koniec
button-return-receipt =
    .label = Potwierdzenie
    .tooltiptext = Żądaj potwierdzenia dostarczenia tej wiadomości
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
consider-bcc-notification = { $count } odbiorców w polach Do i Kopia może widzieć swoje adresy. Można uniknąć ujawniania odbiorców, używając zamiast tego pola Ukryta kopia.

# Addressing Area

to-compose-address-row-label =
    .value = Do
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Pole „{ to-compose-address-row-label.value }”
    .accesskey = D
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Pokaż pole „{ to-compose-address-row-label.value }” ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Kopia
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Pole „{ cc-compose-address-row-label.value }”
    .accesskey = K
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Pokaż pole „{ cc-compose-address-row-label.value }” ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Ukryta kopia
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Pole „{ bcc-compose-address-row-label.value }”
    .accesskey = U
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Pokaż pole „{ bcc-compose-address-row-label.value }” ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = { $count } odbiorców w polach Do i Kopia będzie widzieć swoje adresy. Można uniknąć ujawniania odbiorców, używając zamiast tego pola Ukryta kopia.
many-public-recipients-bcc =
    .label = Użyj pola Ukryta kopia
    .accesskey = U
many-public-recipients-ignore =
    .label = Ujawnij odbiorców
    .accesskey = w

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Nie odnaleziono unikalnej tożsamości pasującej do adresu nadawcy. Wiadomość zostanie wysłana za pomocą obecnego pola nadawcy i ustawień z tożsamości „{ $identity }”.
