# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Mbohasarã
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Eiporavopa
    .accesskey = E

close-dialog =
    .key = w

general-tab =
    .label = Tuichakue
    .accesskey = G
general-title =
    .value = Teratee:
general-url =
    .value = Tape:
general-type =
    .value = Peteĩchagua:
general-mode =
    .value = Moha’ãnga reko:
general-size =
    .value = Tuichakue:
general-referrer =
    .value = URL mamoguápa:
general-modified =
    .value = Moambuepyréva:
general-encoding =
    .value = Moñe’ẽrã mbopapapy:
general-meta-name =
    .label = Téra
general-meta-content =
    .label = Tetepy

media-tab =
    .label = Hupytyha
    .accesskey = M
media-location =
    .value = Kundaharape:
media-text =
    .value = Moñe’ẽrã hesegua:
media-alt-header =
    .label = Moñe’ẽrã mokõiguáva
media-address =
    .label = Tape
media-type =
    .label = Mba’eichagua
media-size =
    .label = Tuichakue
media-count =
    .label = Mba’ete
media-dimension =
    .value = Jepysokue:
media-long-desc =
    .value = Myesakãha ipukúva:
media-save-as =
    .label = Ñongatu pyahu…
    .accesskey = A
media-save-image-as =
    .label = Ñongatu pyahu…
    .accesskey = e

perm-tab =
    .label = Moneĩ
    .accesskey = P
permissions-for =
    .value = Emoneĩ hag̃ua:

security-tab =
    .label = Tekorosã
    .accesskey = S
security-view =
    .label = Mboajepyre jehecha
    .accesskey = V
security-view-unknown = Ojekuaa’ỹva
    .value = Ojekuaa’ỹva
security-view-identity =
    .value = Ñanduti renda reratee
security-view-identity-owner =
    .value = Mba’ejára:
security-view-identity-domain =
    .value = Ñanduti renda:
security-view-identity-verifier =
    .value = Ojehechapyréva:
security-view-identity-validity =
    .value = Ndoikovéitama ag̃a:
security-view-privacy =
    .value = Ñemigua ha tembiasakue

security-view-privacy-history-value = Ojehechámapa ko ñanduti renda ymavegua
security-view-privacy-sitedata-value = ¿Ko ñanduti renda ombyaty marandu che mohendahápe?

security-view-privacy-clearsitedata =
    .label = Emboguete umi kookie ha mba’ekuaarã tenda pegua
    .accesskey = C

security-view-privacy-passwords-value = Oñeñongatúpa ñe’ẽñemi ko ñanduti rendápe

security-view-privacy-viewpasswords =
    .label = Terañemi ñongatuguáva jehecha
    .accesskey = w
security-view-technical =
    .value = Mba’emimi aporekoguáva

help-button =
    .label = Ñepytyvõ

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Hẽe, umi kookie ha { $value } { $unit } tendakuéra mba’ekuaarã
security-site-data-only = Hẽe,{ $value } { $unit } tendakuéra mba’ekuaarã

security-site-data-cookies-only = Hẽe, umi kookie
security-site-data-no = Ahániri

image-size-unknown = Ojekuaa’ỹva
page-info-not-specified =
    .value = Moha’eñopyre’ỹva
not-set-alternative-text = Moha’eñopyre’ỹva
not-set-date = Moha’eñopyre’ỹva
media-img = Ta´ãnga
media-bg-img = Tugua
media-border-img = Tembe’y
media-list-img = Ta’ãngamirĩ
media-cursor = Hekaha
media-object = Mba’e
media-embed = Jupapo
media-link = Ta’ãnga’i
media-input = Jeikeha
media-video = Ta´ãngamyi
media-audio = Hendupyrã
saved-passwords-yes = Héẽ
saved-passwords-no = Nahániri

no-page-title =
    .value = Kuatiarogue heratee’ỹva:
general-quirks-mode =
    .value = Ayvu okupytýva
general-strict-mode =
    .value = Jokupytyreko ipukukue jekuaáva ndive
page-info-security-no-owner =
    .value = Ko ñanduti renda nomomarandúi ijára rehegua.
media-select-folder = Eiporavo peteĩ ñongatuha ta’ãngakuéra rendarã
media-unknown-not-cached =
    .value = Ojekuaa’ỹva (ndaha’éi kachépe)
permissions-use-default =
    .label = Ijypykue jepuru
security-no-visits = Nahániri

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Hupityséva (1 teramoĩ)
           *[other] Hupityséva ({ $tags } teramoĩ)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ahániri
        [one] Heẽ, peteĩ jey
       *[other] Heẽ, { $visits } jey
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
            [one] { $type } Ta’ãnga (kyre’ỹ, { $frames } kora)
           *[other] { $type } Ta’ãnga (kyre’ỹ, { $frames } korakuéra)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Ta’ãnga { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px x { $dimy }px (ojupíva { $scaledx }px-pe x { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px x { $dimy }px

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
    .label = Ta’ãnga { $website } rehegua jejoko
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Kuatiarogue rehegua marandu - { $website }
page-info-frame =
    .title = Kora rehegua marandu - { $website }
