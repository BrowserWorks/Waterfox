# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Odebrat pole { $type }
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] Pole typu { $type }
        [one] Pole typu { $type } obsahující jednu adresu, pro její zaměření použijte klávesu se šipkou doleva.
        [few] Pole typu { $type } obsahující { $count } adresy, pro jejich zaměření použijte klávesu se šipkou doleva.
       *[other] Pole typu { $type } obsahující { $count } adres, pro jejich zaměření použijte klávesu se šipkou doleva.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] Adresa { $email }: pro její úpravu stiskněte Enter, pro odebrání Delete.
        [few] Adresa { $email }, jedna z { $count }: pro její úpravu stiskněte Enter, pro odebrání Delete.
       *[other] Adresa { $email }, jedna z { $count }: pro její úpravu stiskněte Enter, pro odebrání Delete.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } není platné e-mailová adresa
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } není ve vašem seznamu kontaktu
pill-action-edit =
    .label = Upravit adresu
    .accesskey = U
pill-action-move-to =
    .label = Přesunout do Komu
    .accesskey = o
pill-action-move-cc =
    .label = Přesunout do Kopie
    .accesskey = p
pill-action-move-bcc =
    .label = Přesunout do Skrytá kopie
    .accesskey = r
pill-action-expand-list =
    .label = Rozbalit seznam
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
    .label = Lišta příloh
    .accesskey = p
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Připojit
    .tooltiptext = Přidat přílohu ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Připojit přílohu…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
add-attachment-notification-reminder2 =
    .label = Připojit přílohu…
    .accesskey = a
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Soubor…
    .accesskey = S
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Připojit soubor…
    .accesskey = s
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] Jedna příloha
            [one] Jedna příloha
            [few] { $count } přílohy
           *[other] { $count } příloh
        }
    .accesskey = h
expand-attachment-pane-tooltip =
    .tooltiptext = Zobrazí lištu příloh ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Skryje lištu příloh ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Zobrazí lištu příloh ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Skryje lištu příloh ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Přidat jako přílohu
        [few] Přidat jako přílohy
       *[other] Přidat jako přílohy
    }
drop-file-label-inline = Vložit do obsahu

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Přesunout na začátek
move-attachment-left-panel-button =
    .label = Přesunout vlevo
move-attachment-right-panel-button =
    .label = Přesunout vpravo
move-attachment-last-panel-button =
    .label = Přesunout na konec
button-return-receipt =
    .label = Potvrzení o přijetí
    .tooltiptext = Zažádá o potvrzení o přijetí této zprávy

# Encryption

message-to-be-signed-icon =
    .alt = Podepsat zprávu
message-to-be-encrypted-icon =
    .alt = Zašifrovat zprávu

# Addressing Area

to-compose-address-row-label =
    .value = Komu
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Pole { to-compose-address-row-label.value }
    .accesskey = K
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Zobrazit pole { to-compose-address-row-label.value } ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Kopie
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Pole { cc-compose-address-row-label.value }
    .accesskey = i
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Zobrazit pole { cc-compose-address-row-label.value } ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Skrytá kopie
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Pole { bcc-compose-address-row-label.value }
    .accesskey = S
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Zobrazit pole { bcc-compose-address-row-label.value } ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info =
    { $count ->
        [one] { "" }
        [few] Celkem { $count } adresáti v polích Komu a Kopie navzájem uvidí své adresy. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
       *[other] Celkem { $count } adresátů v polích Komu a Kopie navzájem uvidí své adresy. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
    }
to-address-row-label =
    .value = Komu
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Pole Komu
    .accesskey = K
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Komu
    .accesskey = K
#   $key (String) - the shortcut key for this field
show-to-row-button = Komu
    .title = Zobrazit pole Komu ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Kopie
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Pole Kopie
    .accesskey = i
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Kopie
    .accesskey = i
#   $key (String) - the shortcut key for this field
show-cc-row-button = Kopie
    .title = Zobrazit pole Kopie ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Skrytá kopie
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Pole Skrytá kopie
    .accesskey = S
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Skrytá kopie
    .accesskey = S
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Skrytá kopie
    .title = Zobrazit pole Skrytá kopie ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Další pole adresátů k zobrazení
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Příjemce této zprávy je uvedený veřejně. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
        [few] Celkem { $count } adresáti v polích Komu a Kopie navzájem uvidí své adresy. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
       *[other] Celkem { $count } adresátů v polích Komu a Kopie navzájem uvidí své adresy. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
    }
many-public-recipients-bcc =
    .label = Použít skrytou kopii
    .accesskey = u
many-public-recipients-ignore =
    .label = Ponechat příjemce veřejně
    .accesskey = n
many-public-recipients-prompt-title = Příliš mnoho veřejných příjemců
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Příjemce této zprávy je uvedený veřejně, což může ohrozit jeho soukromí. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
        [few] Celkem { $count } adresáti v polích Komu a Kopie navzájem uvidí své adresy, což může ohrozit jeho soukromí. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
       *[other] Celkem { $count } adresátů v polích Komu a Kopie navzájem uvidí své adresy, což může ohrozit jeho soukromí. Pokud se tomu chcete vyhnout, použijte pole Skrytá kopie.
    }
many-public-recipients-prompt-cancel = Zrušit odesílání
many-public-recipients-prompt-send = Přesto odeslat

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Unikátní identita odpovídající adrese odesílatele nebyla nalezena. Zpráva bude odeslána s pomocí současné adresy odesílatele a nastavení pro identitu { $identity }.
encrypted-bcc-warning = Při odesílání zašifrované zprávy nejsou příjemci v poli Skrytá kopie zcela utajeni. Všichni příjemci je mohou být schopni identifikovat.
encrypted-bcc-ignore-button = Rozumím

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Odebrat formátování textu
