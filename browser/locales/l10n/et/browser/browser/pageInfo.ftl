# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 970px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Kopeeri
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Vali kõik
    .accesskey = V

close-dialog =
    .key = w

general-tab =
    .label = Üldine
    .accesskey = l
general-title =
    .value = Pealkiri:
general-url =
    .value = Aadress:
general-type =
    .value = Tüüp:
general-mode =
    .value = Esitusviis:
general-size =
    .value = Suurus:
general-referrer =
    .value = Viitav URL:
general-modified =
    .value = Muudetud:
general-encoding =
    .value = Teksti kodeering:
general-meta-name =
    .label = Nimi
general-meta-content =
    .label = Sisu

media-tab =
    .label = Meedia
    .accesskey = M
media-location =
    .value = Asukoht:
media-text =
    .value = Seonduv tekst:
media-alt-header =
    .label = Alternatiivne tekst
media-address =
    .label = Aadress
media-type =
    .label = Tüüp
media-size =
    .label = Suurus
media-count =
    .label = Arv
media-dimension =
    .value = Mõõtmed:
media-long-desc =
    .value = Pikk kirjeldus:
media-save-as =
    .label = Salvesta kui...
    .accesskey = S
media-save-image-as =
    .label = Salvesta kui...
    .accesskey = e

perm-tab =
    .label = Õigused
    .accesskey = i
permissions-for =
    .value = Õigused veebilehele:

security-tab =
    .label = Turvalisus
    .accesskey = r
security-view =
    .label = Vaata sertifikaati
    .accesskey = V
security-view-unknown = Tundmatu
    .value = Tundmatu
security-view-identity =
    .value = Veebilehe identiteet
security-view-identity-owner =
    .value = Omanik:
security-view-identity-domain =
    .value = Veebileht:
security-view-identity-verifier =
    .value = Verifitseerija:
security-view-identity-validity =
    .value = Aegub:
security-view-privacy =
    .value = Privaatsus ja ajalugu

security-view-privacy-history-value = Kas ma olen enne tänast seda lehte juba külastanud?
security-view-privacy-sitedata-value = Kas see veebileht salvestab infot minu arvutisse?

security-view-privacy-clearsitedata =
    .label = Kustuta küpsised ja saidi andmed
    .accesskey = K

security-view-privacy-passwords-value = Kas ma olen salvestanud selle veebilehe paroole?

security-view-privacy-viewpasswords =
    .label = Vaata salvestatud paroole
    .accesskey = s
security-view-technical =
    .value = Tehnilised üksikasjad

help-button =
    .label = Abi

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Jah, küpsiseid ja { $value } { $unit } saidi andmeid
security-site-data-only = Jah, { $value } { $unit } saidi andmeid

security-site-data-cookies-only = Jah, küpsiseid
security-site-data-no = Ei

image-size-unknown = Tundmatu
page-info-not-specified =
    .value = Määramata
not-set-alternative-text = Määramata
not-set-date = Määramata
media-img = Pilt
media-bg-img = Taust
media-border-img = Piirjoon
media-list-img = Täpp
media-cursor = Kursor
media-object = Objekt
media-embed = Põimitud
media-link = Ikoon
media-input = Sisend
media-video = Video
media-audio = Audio
saved-passwords-yes = Jah
saved-passwords-no = Ei

no-page-title =
    .value = Nimetu leht:
general-quirks-mode =
    .value = Lodev režiim
general-strict-mode =
    .value = Standardipõhine režiim
page-info-security-no-owner =
    .value = Sellel lehel puudub omaniku info.
media-select-folder = Vali kaust, kuhu pilt salvestada
media-unknown-not-cached =
    .value = Tundmatu (puudub puhvermälust)
permissions-use-default =
    .label = Kasutatakse vaikeväärtust
security-no-visits = Ei

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 silt)
           *[other] Meta ({ $tags } silti)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ei
        [one] Jah, korra
       *[other] Jah, { $visits } korda
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KiB  ({ $bytes } bait)
           *[other] { $kb } KiB ({ $bytes } baiti)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } pilt (animeeritud, { $frames } kaader)
           *[other] { $type } pilt (animeeritud, { $frames } kaadrit)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } pilt

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skaleeritud suurusele { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size }KiB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Pilte aadressilt { $website } ei laadita
    .accesskey = P

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Veebilehe teave - { $website }
page-info-frame =
    .title = Paneeli teave - { $website }
