# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

copy =
    .key = C
menu-copy =
    .label = Kopieer
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Kies almal
    .accesskey = a

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
    .value = Soort:
general-mode =
    .value = Weergeemodus:
general-size =
    .value = Grootte:
general-referrer =
    .value = Verwyser-URL:
general-modified =
    .value = Gewysig:
general-encoding =
    .value = Teksenkodering:
general-meta-name =
    .label = Naam
general-meta-content =
    .label = Inhoud

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Ligging:
media-text =
    .value = Geassosieerde teks:
media-alt-header =
    .label = Alternatiewe teks
media-address =
    .label = Adres
media-type =
    .label = Soort
media-size =
    .label = Grootte
media-count =
    .label = Telling
media-dimension =
    .value = Dimensies:
media-long-desc =
    .value = Lang beskrywing:
media-save-as =
    .label = Stoor as…
    .accesskey = A
media-save-image-as =
    .label = Stoor as…
    .accesskey = r

perm-tab =
    .label = Toestemming
    .accesskey = T
permissions-for =
    .value = Toestemmings vir:

security-tab =
    .label = Sekuriteit
    .accesskey = S
security-view =
    .label = Bekyk sertifikaat
    .accesskey = B
security-view-unknown = Onbekend
    .value = Onbekend
security-view-identity =
    .value = Webwerfidentiteit
security-view-identity-owner =
    .value = Eienaar:
security-view-identity-domain =
    .value = Webwerf:
security-view-identity-verifier =
    .value = Geverifieer deur:
security-view-identity-validity =
    .value = Verval op:
security-view-privacy =
    .value = Privaatheid en geskiedenis

security-view-privacy-history-value = Het ek hierdie webwerf voor vandag besoek?

security-view-privacy-passwords-value = Het ek enige wagwoorde vir hierdie webwerf gestoor?

security-view-privacy-viewpasswords =
    .label = Bekyk gestoorde wagwoorde
    .accesskey = w
security-view-technical =
    .value = Tegniese details

help-button =
    .label = Hulp

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies-only = Ja, koekies
security-site-data-no = Nee

image-size-unknown = Onbekend
page-info-not-specified =
    .value = Nie gespesifiseer nie
not-set-alternative-text = Nie gespesifiseer nie
not-set-date = Nie gespesifiseer nie
media-img = Prent
media-bg-img = Agtergrond
media-border-img = Rand
media-list-img = Koeëltjie
media-cursor = Wyser
media-object = Objek
media-embed = Ingebed
media-link = Ikoon
media-input = Toevoer
media-video = Video
media-audio = Klank
saved-passwords-yes = Ja
saved-passwords-no = Nee

no-page-title =
    .value = Titellose bladsy:
general-quirks-mode =
    .value = Glipsmodus
general-strict-mode =
    .value = Standaardversoeningmodus
page-info-security-no-owner =
    .value = Hierdie webwerf verskaf nie eienaarsinligting nie.
media-select-folder = Kies 'n vouer om die prente te stoor
media-unknown-not-cached =
    .value = Onbekend (nie gekas nie)
permissions-use-default =
    .label = Gebruik verstek
security-no-visits = Nee

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nee
        [one] Ja, een keer
       *[other] Ja, { $visits } keer
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KG ({ $bytes } greep)
           *[other] { $kb } KG ({ $bytes } grepe)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type }-prent

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (vergroot/verklein na { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } KG

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Blokkeer prente vanaf { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Bladsyinfo - { $website }
page-info-frame =
    .title = Raaminfo - { $website }
