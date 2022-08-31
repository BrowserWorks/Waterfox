# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 620px; min-height: 580px;

copy =
    .key = C
menu-copy =
    .label = Kopiëren
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Alles selecteren
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = Algemeen
    .accesskey = A
general-title =
    .value = Titel:
general-url =
    .value = Adres:
general-type =
    .value = Type:
general-mode =
    .value = Rendermodus:
general-size =
    .value = Grootte:
general-referrer =
    .value = Verwijzende URL:
general-modified =
    .value = Gewijzigd:
general-encoding =
    .value = Tekstcodering:
general-meta-name =
    .label = Naam
general-meta-content =
    .label = Inhoud

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Locatie:
media-text =
    .value = Geassocieerde tekst:
media-alt-header =
    .label = Alternatieve tekst
media-address =
    .label = Adres
media-type =
    .label = Type
media-size =
    .label = Grootte
media-count =
    .label = Aantal
media-dimension =
    .value = Afmetingen:
media-long-desc =
    .value = Lange beschrijving:
media-save-as =
    .label = Opslaan als…
    .accesskey = l
media-save-image-as =
    .label = Opslaan als…
    .accesskey = p

perm-tab =
    .label = Toestemmingen
    .accesskey = T
permissions-for =
    .value = Toestemmingen voor:

security-tab =
    .label = Beveiliging
    .accesskey = B
security-view =
    .label = Certificaat bekijken
    .accesskey = C
security-view-unknown = Onbekend
    .value = Onbekend
security-view-identity =
    .value = Website-identiteit
security-view-identity-owner =
    .value = Eigenaar:
security-view-identity-domain =
    .value = Website:
security-view-identity-verifier =
    .value = Geverifieerd door:
security-view-identity-validity =
    .value = Verloopt op:
security-view-privacy =
    .value = Privacy & geschiedenis

security-view-privacy-history-value = Heb ik deze website eerder dan vandaag bezocht?
security-view-privacy-sitedata-value = Slaat deze website informatie op op mijn computer?

security-view-privacy-clearsitedata =
    .label = Cookies en websitegegevens wissen
    .accesskey = k

security-view-privacy-passwords-value = Heb ik wachtwoorden opgeslagen voor deze website?

security-view-privacy-viewpasswords =
    .label = Opgeslagen wachtwoorden bekijken
    .accesskey = w
security-view-technical =
    .value = Technische details

help-button =
    .label = Help

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ja, cookies en { $value } { $unit } aan websitegegevens
security-site-data-only = Ja, { $value } { $unit } aan websitegegevens

security-site-data-cookies-only = Ja, cookies
security-site-data-no = Nee

##

image-size-unknown = Onbekend
page-info-not-specified =
    .value = Niet gespecificeerd
not-set-alternative-text = Niet gespecificeerd
not-set-date = Niet gespecificeerd
media-img = Afbeelding
media-bg-img = Achtergrond
media-border-img = Rand
media-list-img = Opsommingsteken
media-cursor = Cursor
media-object = Object
media-embed = Ingebed
media-link = Pictogram
media-input = Invoer
media-video = Video
media-audio = Audio
saved-passwords-yes = Ja
saved-passwords-no = Nee

no-page-title =
    .value = Pagina zonder titel:
general-quirks-mode =
    .value = Quirksmodus
general-strict-mode =
    .value = Standaardenmodus
page-info-security-no-owner =
    .value = Deze website verstrekt geen eigendomsinformatie.
media-select-folder = Selecteer een map voor het opslaan van de afbeeldingen
media-unknown-not-cached =
    .value = Onbekend (niet gebufferd)
permissions-use-default =
    .label = Standaard gebruiken
security-no-visits = Nee

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
           *[other] Meta ({ $tags } tags)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nee
        [one] Ja, eenmaal
       *[other] Ja, { $visits } maal
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } byte)
           *[other] { $kb } KB ({ $bytes } bytes)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type }-afbeelding (geanimeerd, { $frames } frame)
           *[other] { $type }-afbeelding (geanimeerd, { $frames } frames)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type }-afbeelding

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (geschaald naar { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Afbeeldingen van { $website } blokkeren
    .accesskey = e

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Pagina-info - { $website }
page-info-frame =
    .title = Deelvensterinfo - { $website }
