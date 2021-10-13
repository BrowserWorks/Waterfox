# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopiera
    .accesskey = o

select-all =
    .key = A
menu-select-all =
    .label = Markera allt
    .accesskey = M

close-dialog =
    .key = w

general-tab =
    .label = Allmänt
    .accesskey = A
general-title =
    .value = Titel:
general-url =
    .value = Adress:
general-type =
    .value = Typ:
general-mode =
    .value = Renderingsläge:
general-size =
    .value = Storlek:
general-referrer =
    .value = Anvisande URL:
general-modified =
    .value = Ändrad:
general-encoding =
    .value = Teckenkodning:
general-meta-name =
    .label = Namn
general-meta-content =
    .label = Innehåll

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Adress:
media-text =
    .value = Tillhörande text:
media-alt-header =
    .label = Alternativ text
media-address =
    .label = Adress
media-type =
    .label = Typ
media-size =
    .label = Storlek
media-count =
    .label = Antal gånger
media-dimension =
    .value = Dimension:
media-long-desc =
    .value = Lång beskrivning:
media-save-as =
    .label = Spara som…
    .accesskey = S
media-save-image-as =
    .label = Spara som…
    .accesskey = p

perm-tab =
    .label = Rättigheter
    .accesskey = t
permissions-for =
    .value = Rättigheter för:

security-tab =
    .label = Säkerhet
    .accesskey = ä
security-view =
    .label = Visa certifikat
    .accesskey = V
security-view-unknown = Okänt
    .value = Okänt
security-view-identity =
    .value = Webbplatsens identitet
security-view-identity-owner =
    .value = Ägare:
security-view-identity-domain =
    .value = Webbplats:
security-view-identity-verifier =
    .value = Verifierad av:
security-view-identity-validity =
    .value = Upphör:
security-view-privacy =
    .value = Sekretess & historik

security-view-privacy-history-value = Har jag besökt den här webbplatsen tidigare dagar?
security-view-privacy-sitedata-value = Lagrar denna webbplats information på min dator?

security-view-privacy-clearsitedata =
    .label = Rensa kakor och webbplatsdata
    .accesskey = R

security-view-privacy-passwords-value = Har jag sparat några lösenord för den här webbplatsen?

security-view-privacy-viewpasswords =
    .label = Visa sparade lösenord
    .accesskey = ö
security-view-technical =
    .value = Tekniska detaljer

help-button =
    .label = Hjälp

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ja, kakor och { $value } { $unit } webbplatsdata
security-site-data-only = Ja, { $value } { $unit } webbplatsdata

security-site-data-cookies-only = Ja, kakor
security-site-data-no = Nej

##

image-size-unknown = Okänd
page-info-not-specified =
    .value = Ej angivet
not-set-alternative-text = Ej angivet
not-set-date = Ej angivet
media-img = Bild
media-bg-img = Bakgrund
media-border-img = Ram
media-list-img = Punkt
media-cursor = Pekare
media-object = Objekt
media-embed = Inbäddad
media-link = Ikon
media-input = Inmatning
media-video = Video
media-audio = Ljud
saved-passwords-yes = Ja
saved-passwords-no = Nej

no-page-title =
    .value = Namnlös sida:
general-quirks-mode =
    .value = Tolerant läge
general-strict-mode =
    .value = Strikt enligt standard
page-info-security-no-owner =
    .value = Webbplatsen har inte lämnat någon information om ägaren.
media-select-folder = Välj en mapp att spara bilderna i
media-unknown-not-cached =
    .value = Okänd (ej cachad)
permissions-use-default =
    .label = Använd standard
security-no-visits = Nej

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tagg)
           *[other] Meta ({ $tags } taggar)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nej
        [one] Ja, en gång
       *[other] Ja, { $visits } gånger
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } kB ({ $bytes } byte)
           *[other] { $kb } kB ({ $bytes } byte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } bild (animerad, { $frames } ram)
           *[other] { $type } bild (animerad, { $frames } ramar)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } bild

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skalad till { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } kB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Blockera bilder från { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Sidinfo - { $website }
page-info-frame =
    .title = Raminfo - { $website }
