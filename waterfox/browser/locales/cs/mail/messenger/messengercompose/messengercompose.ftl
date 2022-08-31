# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Formát odesílání
    .accesskey = F
compose-send-auto-menu-item =
    .label = Automaticky
    .accesskey = A
compose-send-both-menu-item =
    .label = HTML a prostý text
    .accesskey = a
compose-send-html-menu-item =
    .label = Pouze HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Pouze prostý text
    .accesskey = p

## Addressing widget

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
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Vybrat všechny adresy v poli { $type }
    .accesskey = a
pill-action-select-all-pills =
    .label = Vybrat všechny adresy
    .accesskey = v
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

## Attachment widget

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
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Moje vizitka vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = Můj veřejný klíč OpenPGP
    .accesskey = k
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } příloha
        [one] { $count } příloha
        [few] { $count } přílohy
       *[other] { $count } příloh
    }
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

## Reorder Attachment Panel

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

## Encryption

encryption-menu =
    .label = Zabezpečení
    .accesskey = b
encryption-toggle =
    .label = Zašifrovat
    .tooltiptext = Ochrání zprávu pomocí koncového šifrování
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Nastavení šifrování OpenPGP
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Nastavení šifrování S/MIME
signing-toggle =
    .label = Podepsat
    .tooltiptext = Připojit k této zprávě elektronický podpis
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Zašifrovat
    .accesskey = Z
menu-encrypt-subject =
    .label = Zašifrovat předmět
    .accesskey = f
menu-sign =
    .label = Elektronicky podepsat
    .accesskey = i
menu-manage-keys =
    .label = Asistent pro správu klíčů
    .accesskey = A
menu-view-certificates =
    .label = Zobrazit certifikáty příjemců
    .accesskey = c
menu-open-key-manager =
    .label = Správce klíčů
    .accesskey = k
openpgp-key-issue-notification-one = Pro použití koncového šifrování nejprve odstraňte chyby klíče pro { $addr }
openpgp-key-issue-notification-many =
    { $count ->
        [one] Pro použití koncového šifrování nejprve odstraňte chyby klíče pro jednoho příjemce.
        [few] Pro použití koncového šifrování nejprve odstraňte chyby klíčů pro { $count } příjemce.
       *[other] Pro použití koncového šifrování nejprve odstraňte chyby klíčů pro { $count } příjemců.
    }
smime-cert-issue-notification-one = Pro použití koncového šifrování nejprve odstraňte chyby certifikátu pro { $addr }
smime-cert-issue-notification-many =
    { $count ->
        [one] Pro použití koncového šifrování nejprve odstraňte chyby certifikátu pro jednoho příjemce.
        [few] Pro použití koncového šifrování nejprve odstraňte chyby certifikátů pro { $count } příjemce.
       *[other] Pro použití koncového šifrování nejprve odstraňte chyby certifikátů pro { $count } příjemců.
    }
key-notification-disable-encryption =
    .label = Nešifrovat
    .accesskey = N
    .tooltiptext = Vypne koncové šifrování
key-notification-resolve =
    .label = Vyřešit…
    .accesskey = y
    .tooltiptext = Otevře asistenta klíčů OpenPGP
can-encrypt-smime-notification = Koncové šifrování S/MIME je dostupné.
can-encrypt-openpgp-notification = Koncové šifrování OpenPGP je dostupné.
can-e2e-encrypt-button =
    .label = Šifrovat
    .accesskey = a

## Addressing Area

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

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Nahráno do neznámého účtu úložiště.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } - soubor poslaný přes úložiště
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = Soubor { $filename } byl poslán přes úložiště. Stáhnout ho můžete z odkazu níže.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] Připojil jsem k tomuto e-mailu { $count } soubor:
        [few] Připojil jsem k tomuto e-mailu { $count } soubory:
       *[other] Připojil jsem k tomuto e-mailu { $count } souborů:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Zjistit více o službě { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Další informace o službách { $firstLinks } a { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Odkaz chráněný heslem
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Posílání souborů přes úložiště:
cloud-file-template-size = Velikost:
cloud-file-template-link = Odkaz:
cloud-file-template-password-protected-link = Odkaz chráněný heslem:
cloud-file-template-expiry-date = Datum vypršení platnosti:
cloud-file-template-download-limit = Omezení počtu stažení:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Chyba spojení
cloud-file-connection-error = { -brand-short-name } je offline, ke službě { $provider } se nelze připojit.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Nahrávání souboru { $filename } do služby { $provider } se nezdařilo
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Chyba přejmenování
cloud-file-rename-error = Vyskytl se problém s přejmenováním souboru { $filename } ve službě { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Přejmenování souboru { $filename } se ve službě { $provider } nezdařilo
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } nepodporuje přejmenování již nahraných souborů.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Chyba posílání souborů přes úložiště
cloud-file-attachment-error = Nepodařilo se aktualizovat soubor { $filename } posílaný přes úložiště, protože byla jeho místní kopie přesunuta nebo smazána.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Chyba účtu úložiště
cloud-file-account-error = Nepodařilo se aktualizovat soubor { $filename } posílaný přes úložiště, protože byl účet úložiště smazán.

## Link Preview

link-preview-title = Náhled odkazu
link-preview-description = { -brand-short-name } může k odkazům vkládaným do zprávy přidat náhled.
link-preview-autoadd = Automaticky přidávat náhledy odkazů, pokud je to možné
link-preview-replace-now = Chcete přidat náhled tohoto odkazu?
link-preview-yes-replace = Ano

## Dictionary selection popup

spell-add-dictionaries =
    .label = Přidat slovník…
    .accesskey = a
