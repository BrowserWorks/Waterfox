# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopyahin
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Piliin ang Lahat
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = Pangkalahatan
    .accesskey = G
general-title =
    .value = Pamagat:
general-url =
    .value = Address:
general-type =
    .value = Uri:
general-mode =
    .value = Render Mode:
general-size =
    .value = Sukat:
general-referrer =
    .value = Pinanggalingan na URL:
general-modified =
    .value = Binago:
general-encoding =
    .value = Text Encoding:
general-meta-name =
    .label = Pangalan
general-meta-content =
    .label = Nilalaman

media-tab =
    .label = Mga Media
    .accesskey = M
media-location =
    .value = Lokasyon:
media-text =
    .value = Kaugnay na Text:
media-alt-header =
    .label = Alternate na Text
media-address =
    .label = Address
media-type =
    .label = Uri
media-size =
    .label = Sukat
media-count =
    .label = Bilang
media-dimension =
    .value = Mga sukat:
media-long-desc =
    .value = mahabang paglalarawan:
media-save-as =
    .label = I-save Bilang…
    .accesskey = A
media-save-image-as =
    .label = I-save Bilang…
    .accesskey = e

perm-tab =
    .label = Mga Pahintulot
    .accesskey = P
permissions-for =
    .value = Mga pahintulot para sa:

security-tab =
    .label = Seguridad
    .accesskey = S
security-view =
    .label = Tingnan ang Sertipiko
    .accesskey = V
security-view-unknown = Hindi kilala
    .value = Hindi kilala
security-view-identity =
    .value = Website Identity
security-view-identity-owner =
    .value = May-ari:
security-view-identity-domain =
    .value = Website:
security-view-identity-verifier =
    .value = Pinatunayan ng:
security-view-identity-validity =
    .value = Mag-e-expire sa:
security-view-privacy =
    .value = Pribasiya at Kasaysayan

security-view-privacy-history-value = Nabisita ko na ba ang website na ito bago ngayon?
security-view-privacy-sitedata-value = Ang website ba na ito ay nag-iimbak ng impormasyon sa aking computer?

security-view-privacy-clearsitedata =
    .label = Burahin ang mga Cookie at Site Data
    .accesskey = C

security-view-privacy-passwords-value = Nakapag-save na ba ako ng mga password para sa website na ito?

security-view-privacy-viewpasswords =
    .label = Tingnan ang mga Naka-save na Password
    .accesskey = w
security-view-technical =
    .value = Detalyeng Pangteknikal

help-button =
    .label = Tulong

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Oo, mga cookie at { $value } { $unit } ng site data
security-site-data-only = Oo, { $value } { $unit } ng site data

security-site-data-cookies-only = Oo, mga cookie
security-site-data-no = Hindi

image-size-unknown = Hindi alam
page-info-not-specified =
    .value = Hindi tukoy
not-set-alternative-text = Hindi tukoy
not-set-date = Hindi tukoy
media-img = Larawan
media-bg-img = Background
media-border-img = Gilid
media-list-img = Punto
media-cursor = Cursor
media-object = Object
media-embed = Embed
media-link = Icon
media-input = Input
media-video = Bidyo
media-audio = Tunog
saved-passwords-yes = Oo
saved-passwords-no = Hindi

no-page-title =
    .value = Walang Pamagat na Pahina:
general-quirks-mode =
    .value = Quirks mode
general-strict-mode =
    .value = Standards compliance mode
page-info-security-no-owner =
    .value = Ang website na ito ay hindi nagbibigay ng impormasyon tungkol sa pagmamay-ari.
media-select-folder = Pumili ng Folder na Paglalagyan ng mga Larawan
media-unknown-not-cached =
    .value = Hindi tukoy (hindi naka-cache)
permissions-use-default =
    .label = Gamitin ang Default
security-no-visits = Hindi

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
           *[other] Meta ({ $tags } tag)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Hindi
        [one] Oo, isang beses
       *[other] Oo, { $visits } beses
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
            [one] Larawang { $type } (animated, { $frames } frame)
           *[other] Larawang { $type } (animated, { $frames } frame)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Larawang { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (naka-scale sa { $scaledx }px × { $scaledy }px)

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
    .label = Harangin ang mga larawan mula sa { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Tungkol sa Pahina - { $website }
page-info-frame =
    .title = Tungkol sa Frame - { $website }
