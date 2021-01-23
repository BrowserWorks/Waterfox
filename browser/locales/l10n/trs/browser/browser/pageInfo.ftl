# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Guxun' ñadu'ua
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Ganahui' da'ua ngê ma
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = Da'ua nguéj
    .accesskey = G
general-title =
    .value = Si yugui:
general-url =
    .value = Hiuj gun':
general-type =
    .value = Dugui':
general-mode =
    .value = Render Mode:
general-size =
    .value = Dàj yachìj man:
general-referrer =
    .value = URL nu ma:
general-modified =
    .value = 'Ngà nadunaj:
general-encoding =
    .value = Si kodifikasiôn texto:
general-meta-name =
    .label = Si yuguit
general-meta-content =
    .label = Sa mā

media-tab =
    .label = Sa ni'io'
    .accesskey = M
media-location =
    .value = Dane' huin:
media-text =
    .value = Texto nikaj dugui':
media-alt-header =
    .label = A'ngo texto:
media-address =
    .label = Hiuj gun'
media-type =
    .label = Dugui'
media-size =
    .label = Dàj yachìj man
media-count =
    .label = Cuenta
media-dimension =
    .value = Daj yachij ma:
media-long-desc =
    .value = Nuhuin si taj ma:
media-save-as =
    .label = Na'nïnj so' 'ngà...
    .accesskey = A
media-save-image-as =
    .label = Na'nïnj so' 'ngà...
    .accesskey = e

perm-tab =
    .label = Gachinj ni'iô'
    .accesskey = P
permissions-for =
    .value = Gachinj ni'io' guenda:

security-tab =
    .label = Sa dugumin
    .accesskey = S
security-view =
    .label = Ni'io' sertifikado
    .accesskey = V
security-view-unknown = Sê sa ni'în' huin
    .value = Sê sa ni'în' huin
security-view-identity =
    .value = Daj hua sitio web
security-view-identity-owner =
    .value = Dugui' si'iaj:
security-view-identity-domain =
    .value = Sitio Web:
security-view-identity-verifier =
    .value = 'Ngà ganatsij sa gu'nàj:
security-view-identity-validity =
    .value = Gui nahuij ma huin:
security-view-privacy =
    .value = Sa huìi & riña gaché nu'

security-view-privacy-history-value = 'Ngà gaché nunj riña sitio na ve'ej?
security-view-privacy-sitedata-value = Si nachra sa' sitio na nuguan'an riña si aga'â aj?

security-view-privacy-clearsitedata =
    .label = Nagi'iaj niñu' kookies nī si dato sitio
    .accesskey = C

security-view-privacy-passwords-value = Na'nî sa'aj da'ngà' huìi guenda sitio na ve'ej

security-view-privacy-viewpasswords =
    .label = Ni'io' kontraseña ma sa'aj
    .accesskey = w
security-view-technical =
    .value = Hua a'na' dodò' 'iaj aga' na

help-button =
    .label = Ruguñu'unj

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ga'ue, kookies ni { $value } { $unit } si dato sitio
security-site-data-only = Ga'ue, { $value } { $unit } si dato sitio

security-site-data-cookies-only = Ga'ue, kookies
security-site-data-no = Si ga'ue

image-size-unknown = Sê sa ni'în' huin
page-info-not-specified =
    .value = Nuni'in ahuin si huin
not-set-alternative-text = Nuni'in ahuin si huin
not-set-date = Nuni'in ahuin si huin
media-img = Ñan du'ua
media-bg-img = Si fondoj
media-border-img = Chrej nanikāj du'ua ma
media-list-img = Nej marka
media-cursor = Kursor
media-object = Rasùun
media-embed = Gatu'
media-link = Ikono
media-input = Riña gatu'
media-video = Video
media-audio = Nanee
saved-passwords-yes = Ga'ue
saved-passwords-no = Si ga'ue

no-page-title =
    .value = Nitaj rā pajinâ na hua:
general-quirks-mode =
    .value = Da' ruguñu'unj ma
general-strict-mode =
    .value = Da' ruguñu'unj guña ma
page-info-security-no-owner =
    .value = Nitaj si ni'in sitio na rayi'ì nej si aga't.
media-select-folder = Ganahui 'ngò karpetâ riña na'nïnj sa't nej ña du'ua ma
media-unknown-not-cached =
    .value = Nu ni'in' (nitaj kache)
permissions-use-default =
    .label = Garasun' ru'ua nianj
security-no-visits = Si ga'ue

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
        [0] Si ga'ue
        [one] Ga'ue, 'ngo rïn
       *[other] Ga'ue, { $visits } diû
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bîte)
           *[other] { $kb } KB ({ $bytes } nej bîte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Ñadu'ua (sa siki'i, { $frames } kuâdru)
           *[other] { $type } Ñadu'ua (sa siki'i, { $frames } nej kuâdru)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Nadu'uo'

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (eskalado a { $scaledx }px × { $scaledy }px)

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
    .label = Garun' nej ña du'ua { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Si nuguan' pajinâ - { $website }
page-info-frame =
    .title = Si nuguan' sa taj du'ua ma - { $website }
