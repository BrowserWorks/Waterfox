# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Verzendopmaak
    .accesskey = o
compose-send-auto-menu-item =
    .label = Automatisch
    .accesskey = A
compose-send-both-menu-item =
    .label = Zowel HTML als platte tekst
    .accesskey = Z
compose-send-html-menu-item =
    .label = Alleen HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Alleen platte tekst
    .accesskey = p

## Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Het veld { $type } verwijderen
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } met een adres, gebruik de linkerpijltoets om de focus erop te zetten.
       *[other] { $type } met { $count } adressen, gebruik de linkerpijltoets om de focus erop te zetten.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: druk Enter om te bewerken, Delete om te verwijderen.
       *[other] { $email }, 1 van { $count }: druk Enter om te bewerken, Delete om te verwijderen.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } is geen geldig e-mailadres
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } staat niet in uw adresboek
pill-action-edit =
    .label = Adres bewerken
    .accesskey = d
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Alle adressen in { $type } selecteren
    .accesskey = A
pill-action-select-all-pills =
    .label = Alle adressen selecteren
    .accesskey = c
pill-action-move-to =
    .label = Verplaatsen naar Aan
    .accesskey = A
pill-action-move-cc =
    .label = Verplaatsen naar Cc
    .accesskey = c
pill-action-move-bcc =
    .label = Verplaatsen naar Bcc
    .accesskey = B
pill-action-expand-list =
    .label = Lijst uitvouwen
    .accesskey = w

## Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Bijlagepaneel
    .accesskey = l
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Koppelen
    .tooltiptext = Een bijlage toevoegen ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder2 =
    .label = Bijlage toevoegen…
    .accesskey = B
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Bestand(en)…
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Bestand(en) koppelen…
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Mijn vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = Mijn openbare OpenPGP-sleutel
    .accesskey = s
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } bijlage
        [one] { $count } bijlage
       *[other] { $count } bijlagen
    }
attachment-area-show =
    .title = Het bijlagevenster tonen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Het bijlagevenster verbergen ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Als bijlage toevoegen
       *[other] Als bijlagen toevoegen
    }
drop-file-label-inline =
    { $count ->
        [one] Inline toevoegen
       *[other] Inline toevoegen
    }

## Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Naar de eerste
move-attachment-left-panel-button =
    .label = Naar links
move-attachment-right-panel-button =
    .label = Naar rechts
move-attachment-last-panel-button =
    .label = Naar de laatste
button-return-receipt =
    .label = Ontvangstbevestiging
    .tooltiptext = Een ontvangstbevestiging voor dit bericht vragen

## Encryption

encryption-menu =
    .label = Beveiliging
    .accesskey = v
encryption-toggle =
    .label = Versleutelen
    .tooltiptext = End-to-end-versleuteling gebruiken voor dit bericht
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = OpenPGP-versleutelingsinstellingen bekijken of wijzigen
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = S/MIME-versleutelingsinstellingen bekijken of wijzigen
signing-toggle =
    .label = Ondertekenen
    .tooltiptext = Digitale ondertekening gebruiken voor dit bericht
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Versleutelen
    .accesskey = V
menu-encrypt-subject =
    .label = Onderwerp versleutelen
    .accesskey = d
menu-sign =
    .label = Digitaal ondertekenen
    .accesskey = i
menu-manage-keys =
    .label = Sleutelassistent
    .accesskey = a
menu-view-certificates =
    .label = Certificaten van ontvangers bekijken
    .accesskey = b
menu-open-key-manager =
    .label = Sleutelbeheerder
    .accesskey = h
openpgp-key-issue-notification-one = End-to-end-versleuteling vereist het oplossen van sleutelproblemen voor { $addr }
openpgp-key-issue-notification-many = End-to-end-versleuteling vereist het oplossen van sleutelproblemen voor { $count } ontvangers.
smime-cert-issue-notification-one = End-to-end-versleuteling vereist het oplossen van certificaatproblemen voor { $addr }.
smime-cert-issue-notification-many = End-to-end-versleuteling vereist het oplossen van certificaatproblemen voor { $count } ontvangers.
key-notification-disable-encryption =
    .label = Niet versleutelen
    .accesskey = i
    .tooltiptext = End-to-end-versleuteling uitschakelen
key-notification-resolve =
    .label = Oplossen…
    .accesskey = l
    .tooltiptext = De OpenPGP-sleutelassistent openen
can-encrypt-smime-notification = S/MIME end-to-end-versleuteling is mogelijk.
can-encrypt-openpgp-notification = OpenPGP end-to-end-versleuteling is mogelijk.
can-e2e-encrypt-button =
    .label = Versleutelen
    .accesskey = V

## Addressing Area

to-address-row-label =
    .value = Aan
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Aan-veld
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Aan
    .accesskey = A
#   $key (String) - the shortcut key for this field
show-to-row-button = Aan
    .title = Aan-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Cc-veld
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Cc-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Bcc
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Bcc-veld
    .accesskey = B
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Bcc
    .accesskey = B
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Bcc
    .title = Bcc-veld tonen ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Andere te tonen adresvelden
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Uw bericht heeft een openbare ontvanger. U kunt voorkomen dat ontvangers worden onthuld door in plaats hiervan Bcc te gebruiken.
       *[other] De { $count } ontvangers in Aan en Cc zullen elkaars adres zien. U kunt voorkomen dat ontvangers worden onthuld door in plaats hiervan Bcc te gebruiken.
    }
many-public-recipients-bcc =
    .label = In plaats hiervan Bcc gebruiken
    .accesskey = g
many-public-recipients-ignore =
    .label = Ontvangers openbaar laten
    .accesskey = l
many-public-recipients-prompt-title = Te veel openbare ontvangers
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Uw bericht heeft een openbare ontvanger. Dit kan een privacyprobleem zijn. U kunt dit voorkomen door de ontvanger in plaats van Aan/Cc naar Bcc te verplaatsen.
       *[other] Uw bericht heeft { $count } openbare ontvangers, die elkaars adressen kunnen zien. Dit kan een privacyprobleem zijn. U kunt voorkomen dat ontvangers openbaar worden gemaakt door ontvangers in plaats van Aan/Cc naar Bcc te verplaatsen.
    }
many-public-recipients-prompt-cancel = Verzenden annuleren
many-public-recipients-prompt-send = Toch verzenden

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Er is geen unieke identiteit gevonden die met het Van-adres overeenkomt. Het bericht zal worden verzonden met het Van-veld en de instellingen van identiteit { $identity }.
encrypted-bcc-warning = Als u een versleuteld bericht verstuurt, worden ontvangers in Bcc niet volledig verborgen. Alle ontvangers kunnen ze mogelijk identificeren.
encrypted-bcc-ignore-button = Begrepen

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Tekstopmaak verwijderen

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Geüpload naar een onbekende Filelink-account.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } – Filelink-bijlage
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = Het bestand { $filename } is als Filelink bijgevoegd. Het is te downloaden via onderstaande koppeling.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] Ik heb { $count } bestand aan dit e-mailbericht gekoppeld:
       *[other] Ik heb { $count } bestanden aan dit e-mailbericht gekoppeld:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Meer info over { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Meer info over { $firstLinks } en { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Met wachtwoord beveiligde koppeling
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Filelink-service:
cloud-file-template-size = Grootte:
cloud-file-template-link = Koppeling:
cloud-file-template-password-protected-link = Met wachtwoord beveiligde koppeling:
cloud-file-template-expiry-date = Vervaldatum:
cloud-file-template-download-limit = Downloadlimiet:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Verbindingsfout
cloud-file-connection-error = { -brand-short-name } is offline. Kan geen verbinding maken met { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Uploaden van { $filename } naar { $provider } mislukt
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Fout bij hernoemen
cloud-file-rename-error = Er is een probleem opgetreden bij het hernoemen van { $filename } op { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Hernoemen van { $filename } op { $provider } mislukt
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } ondersteunt het hernoemen van reeds geüploade bestanden niet.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Filelink-bijlagefout
cloud-file-attachment-error = Kan de Filelink-bijlage { $filename } niet bijwerken, omdat het lokale bestand is verplaatst of verwijderd.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Filelink-accountfout
cloud-file-account-error = Kan de Filelink-bijlage { $filename } niet bijwerken, omdat de Filelink-account is verwijderd.

## Link Preview

link-preview-title = Koppelingsvoorbeeld
link-preview-description = { -brand-short-name } kan een ingesloten voorbeeld toevoegen bij het plakken van koppelingen.
link-preview-autoadd = Koppelingsvoorbeelden indien mogelijk automatisch toevoegen
link-preview-replace-now = Een koppelingsvoorbeeld voor deze koppeling toevoegen?
link-preview-yes-replace = Ja

## Dictionary selection popup

spell-add-dictionaries =
    .label = Woordenboeken toevoegen…
    .accesskey = t
