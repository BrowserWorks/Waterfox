# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Küldési formátum
    .accesskey = f
compose-send-auto-menu-item =
    .label = Automatikus
    .accesskey = A
compose-send-both-menu-item =
    .label = HTML és egyszerű szöveg egyaránt
    .accesskey = s
compose-send-html-menu-item =
    .label = Csak HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Csak egyszerű szöveg
    .accesskey = e

## Addressing widget

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
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Összes cím kiválasztása a következőben: { $type }
    .accesskey = e
pill-action-select-all-pills =
    .label = Összes cím kiválasztása
    .accesskey = k
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

## Attachment widget

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
add-attachment-notification-reminder2 =
    .label = Melléklet hozzáadása…
    .accesskey = a
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Fájlok…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Fájlok csatolása…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Saját vCard
    .accesskey = S
context-menuitem-attach-openpgp-key =
    .label = Saját OpenPGP nyilvános kulcs
    .accesskey = k
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } melléklet
        [one] { $count } melléklet
       *[other] { $count } melléklet
    }
attachment-area-show =
    .title = A mellékletek ablaktábla megjelenítése ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = A mellékletek ablaktábla elrejtése ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
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

## Reorder Attachment Panel

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

## Encryption

encryption-menu =
    .label = Biztonság
    .accesskey = B
encryption-toggle =
    .label = Titkosítás
    .tooltiptext = Végpontok közötti titkosítás használata ehhez az üzenethez
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Az OpenPGP titkosítási beállítások megtekintése vagy módosítása
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Az S/MIME titkosítás beállítások megtekintése vagy módosítása
signing-toggle =
    .label = Aláírás
    .tooltiptext = Digitális aláírás használata ehhez az üzenethez
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Titkosítás
    .accesskey = T
menu-encrypt-subject =
    .label = Tárgy titkosítása
    .accesskey = g
menu-sign =
    .label = Digitális aláírás
    .accesskey = i
menu-manage-keys =
    .label = Kulcssegéd
    .accesskey = s
menu-view-certificates =
    .label = Címzettek tanúsítványainak megtekintése
    .accesskey = C
menu-open-key-manager =
    .label = Kulcskezelő
    .accesskey = K
openpgp-key-issue-notification-one = A végpontok közötti titkosításhoz meg kell oldani a kulcsproblémákat a következőnél: { $addr }
openpgp-key-issue-notification-many = A végpontok közötti titkosításhoz meg kell oldani a kulcsproblémákat { $count } címzettnél.
smime-cert-issue-notification-one = A végpontok közötti titkosításhoz meg kell oldani a tanúsítványproblémákat a következőnél: { $addr }
smime-cert-issue-notification-many = A végpontok közötti titkosításhoz meg kell oldani a tanúsítványproblémákat { $count } címzettnél.
key-notification-disable-encryption =
    .label = Ne titkosítsa
    .accesskey = N
    .tooltiptext = Végpontok közötti titkosítás letiltása
key-notification-resolve =
    .label = Feloldás
    .accesskey = F
    .tooltiptext = Az OpenPGP kulcssegéd megnyitása
can-encrypt-smime-notification = Az S/MIME végpontok közötti titkosítás lehetséges.
can-encrypt-openpgp-notification = Az OpenPGP végpontok közötti titkosítás lehetséges.
can-e2e-encrypt-button =
    .label = Titkosítás
    .accesskey = T

## Addressing Area

to-address-row-label =
    .value = Címzett
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Címzett mező
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Címzett
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-to-row-button = Címzett
    .title = Címzett mező megjelenítése ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Másolatot kap
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Másolatot kap mező
    .accesskey = M
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Másolatot kap
    .accesskey = M
#   $key (String) - the shortcut key for this field
show-cc-row-button = Másolatot kap
    .title = Másolatot kap mező megjelenítése ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Rejtett másolatot kap
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Rejtett másolatot kap
    .accesskey = R
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Rejtett másolatot kap
    .accesskey = R
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Rejtett másolatot kap
    .title = Rejtett másolatot kap mező megjelenítése ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = További megjelenítendő címzési mezők
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Az üzenetének nyilvános címzettje van. Elkerülheti a címzettek közzétételét, ha helyette rejtett másolatot használ.
       *[other] A címzett és másolatot kapó { $count } partner látni fogja egymás címét. Elkerülheti a címzettek közzétételét, ha helyette rejtett másolatot használ.
    }
many-public-recipients-bcc =
    .label = Helyette rejtett másolat használata
    .accesskey = H
many-public-recipients-ignore =
    .label = A címzettek legyenek nyilvánosak
    .accesskey = l
many-public-recipients-prompt-title = Túl sok nyilvános címzett
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Üzenetének nyilvános címzettje van. Ez adatvédelmi aggály lehet. Elkerülheti a címzettek közzétételét, ha áthelyezi a címzetteket a címzett/másolatot kap mezőből a rejtett másolatba.
       *[other] Üzenetének { $count } nyilvános címzettje van, akik láthatják egymás címét. Ez adatvédelmi aggály lehet. Elkerülheti a címzettek közzétételét, ha áthelyezi a címzetteket a címzett/másolatot kap mezőből a rejtett másolatba.
    }
many-public-recipients-prompt-cancel = Küldés megszakítása
many-public-recipients-prompt-send = Küldés mindenképp

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Nem található egyedi személyazonosság, amely egyezik a feladó címével. Az üzenete a jelenlegi Feladó mező, és a(z) { $identity } személyazonosság beállításaival lesz elküldve.
encrypted-bcc-warning = Titkosított üzenet küldésekor a rejtett másolatot kapóként hozzáadott címzettjei nincsenek teljesen elrejtve. Minden címzett képes lehet azonosítani őket.
encrypted-bcc-ignore-button = Értettem

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Szövegstílus eltávolítása

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Egy ismeretlen Filelink-fiókba feltöltve.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } – Filelink-melléklet
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = A(z) { $filename } fájlt Filelink-hivatkozásként csatolták. Az alábbi hivatkozásról tölthető le.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] { $count } fájlt hivatkoztam ehhez az e-mailhez:
       *[other] { $count } fájlt hivatkoztam ehhez az e-mailhez:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Tudjon meg többet a következőről: { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Tudjon meg többet a következőkről: { $firstLinks } és { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Jelszóval védett hivatkozás
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Filelink szolgáltatás:
cloud-file-template-size = Méret:
cloud-file-template-link = Hivatkozás:
cloud-file-template-password-protected-link = Jelszóval védett hivatkozás:
cloud-file-template-expiry-date = Lejárati dátum:
cloud-file-template-download-limit = Letöltési korlát:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Kapcsolódási hiba
cloud-file-connection-error = A { -brand-short-name } kapcsolat nélküli állapotban van. Nem sikerült csatlakozni a(z) { $provider } szolgáltatáshoz.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = A(z) { $filename } feltöltése a(z) { $provider } szolgáltatásba sikertelen
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Átnevezési hiba
cloud-file-rename-error = Probléma lépett fel a(z) { $filename } átnevezésekor a(z) { $provider } szolgáltatásban.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = A(z) { $filename } átnevezése a(z) { $provider } szolgáltatásban sikertelen
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = A(z) { $provider } nem támogatja a már feltöltött fájlok átnevezését.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Filelink melléklethiba
cloud-file-attachment-error = Nem sikerült frissíteni a(z) { $filename } Filelink mellékletet, mert a helyi fájlt áthelyezték vagy törölték.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Filelink fiókhiba
cloud-file-account-error = Nem sikerült frissíteni a(z) { $filename } Filelink mellékletet, mert a Filelink-fiókot törölték.

## Link Preview

link-preview-title = Hivatkozás előnézete
link-preview-description = A { -brand-short-name } beágyazott előnézetet adhat hozzá a hivatkozások beillesztésekor.
link-preview-autoadd = Hivatkozások előnézetének automatikus hozzáadása, ha lehetséges
link-preview-replace-now = Hozzáad egy előnézetet ehhez a hivatkozáshoz?
link-preview-yes-replace = Igen

## Dictionary selection popup

spell-add-dictionaries =
    .label = Szótárak hozzáadása…
    .accesskey = a
