# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Copïo
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Dewis Popeth
    .accesskey = P

close-dialog =
    .key = w

general-tab =
    .label = Cyffredinol
    .accesskey = C
general-title =
    .value = Teitl:
general-url =
    .value = Cyfeiriad:
general-type =
    .value = Math:
general-mode =
    .value = Modd Llunio:
general-size =
    .value = Maint:
general-referrer =
    .value = URL cyfeirio:
general-modified =
    .value = Newidiwyd:
general-encoding =
    .value = Amgodiad Testun:
general-meta-name =
    .label = Enw
general-meta-content =
    .label = Cynnwys

media-tab =
    .label = Cyfrwng
    .accesskey = C
media-location =
    .value = Lleoliad:
media-text =
    .value = Testun Cysylltiedig:
media-alt-header =
    .label = Testun Arall
media-address =
    .label = Cyfeiriad
media-type =
    .label = Math
media-size =
    .label = Maint
media-count =
    .label = Cyfrif
media-dimension =
    .value = Maint:
media-long-desc =
    .value = Disgrifiad Hir:
media-save-as =
    .label = Cadw Fel…
    .accesskey = A
media-save-image-as =
    .label = Cadw Fel…
    .accesskey = e

perm-tab =
    .label = Caniatâd
    .accesskey = C
permissions-for =
    .value = Caniatâd ar gyfer:

security-tab =
    .label = Diogelwch
    .accesskey = D
security-view =
    .label = Darllen y Dystysgrif
    .accesskey = D
security-view-unknown = Anhysbys
    .value = Anhysbys
security-view-identity =
    .value = Enw Gwefan
security-view-identity-owner =
    .value = Perchennog:
security-view-identity-domain =
    .value = Gwefan:
security-view-identity-verifier =
    .value = Gwirio gan:
security-view-identity-validity =
    .value = Daw i ben ar:
security-view-privacy =
    .value = Preifatrwydd a Hanes

security-view-privacy-history-value = A ydw i wedi ymweld â'r wefan hon cyn heddiw?
security-view-privacy-sitedata-value = A yw'r wefan yma'n yn cadw gwybodaeth ar fy nghyfrifiadur?

security-view-privacy-clearsitedata =
    .label = Clirio Data Cwcis a Data
    .accesskey = C

security-view-privacy-passwords-value = A ydw i wedi cadw unrhyw gyfrineiriau ar gyfer y wefan yma?

security-view-privacy-viewpasswords =
    .label = Gweld y Cyfrineiriau wedi eu Cadw
    .accesskey = w
security-view-technical =
    .value = Manylion Technegol

help-button =
    .label = Cymorth

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ydy, cwcis a { $value } { $unit } o ddata gwefan
security-site-data-only = Ydy, { $value } { $unit } o ddata gwefan

security-site-data-cookies-only = Ydy, cwcis
security-site-data-no = Na

image-size-unknown = Anhysbys
page-info-not-specified =
    .value = Heb ddiffinio
not-set-alternative-text = Heb ddiffinio
not-set-date = Heb ddiffinio
media-img = Delwedd
media-bg-img = Cefndir
media-border-img = Ymyl
media-list-img = Bwled
media-cursor = Cyrchwr
media-object = Gwrthych
media-embed = Mewnblannu
media-link = Eicon
media-input = Mewnbwn
media-video = Fideo
media-audio = Sain
saved-passwords-yes = Ydw
saved-passwords-no = Na

no-page-title =
    .value = Tudalen heb Deitl:
general-quirks-mode =
    .value = Modd Quirks
general-strict-mode =
    .value = Modd cynnal safonau
page-info-security-no-owner =
    .value = Nid yw'r wefan yn darparu gwybodaeth am ei pherchnogaeth.
media-select-folder = Dewis Ffolder i Gadw'r Delweddau
media-unknown-not-cached =
    .value = Anhysbys (heb ei storio dros dro)
permissions-use-default =
    .label = Defnyddio'r Rhagosodedig
security-no-visits = Na

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [zero] Meta ({ $tags } tagiau)
            [one] Meta (1 tag)
            [two] Meta ({ $tags } dags)
            [few] Meta ({ $tags } tag)
            [many] Meta ({ $tags } tag)
           *[other] Meta ({ $tags } tag)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Na
        [zero] Do, unwaith
        [one] Do, { $visits } waith
        [two] Do, { $visits } waith
        [few] Do, { $visits } gwaith
        [many] Do, { $visits } waith
       *[other] Do, { $visits } gwaith
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [zero] { $kb } KB ({ $bytes } beit)
            [one] { $kb } KB ({ $bytes } beit)
            [two] { $kb } KB ({ $bytes } beit)
            [few] { $kb } KB ({ $bytes } beit)
            [many] { $kb } KB ({ $bytes } beit)
           *[other] { $kb } KB ({ $bytes } beit)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [zero] Delwedd { $type } (animeiddio, { $frames } ffrâm)
            [one] Delwedd { $type } (animeiddio, { $frames } ffrâm)
            [two] Delwedd { $type } (animeiddio, { $frames } ffrâm)
            [few] Delwedd { $type } (animeiddio, { $frames } ffrâm)
            [many] Delwedd { $type } (animeiddio, { $frames } ffrâm)
           *[other] Delwedd { $type } (animeiddio, { $frames } ffrâm)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Delwedd { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (graddio i { $scaledx }px × { $scaledy }px)

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
    .label = Rhwystro Delweddau o { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Gwyb. Tud. - { $website }
page-info-frame =
    .title = Gwyb. Ffrâm - { $website }
