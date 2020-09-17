# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Cóipeáil
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Roghnaigh Uile
    .accesskey = U

close-dialog =
    .key = w

general-tab =
    .label = Ginearálta
    .accesskey = G
general-title =
    .value = Teideal:
general-url =
    .value = Seoladh:
general-type =
    .value = Cineál:
general-mode =
    .value = Mód Rindreála:
general-size =
    .value = Méid:
general-referrer =
    .value = URL tagartha:
general-modified =
    .value = Athraithe:
general-encoding =
    .value = Ionchódú Téacs:
general-meta-name =
    .label = Ainm
general-meta-content =
    .label = Ábhar

media-tab =
    .label = Meáin
    .accesskey = M
media-location =
    .value = Suíomh:
media-text =
    .value = Téacs Gaolmhar:
media-alt-header =
    .label = Téacs mar Mhalairt
media-address =
    .label = Seoladh
media-type =
    .label = Cineál
media-size =
    .label = Méid
media-count =
    .label = Líon
media-dimension =
    .value = Toisí:
media-long-desc =
    .value = Cur Síos Fada:
media-save-as =
    .label = Sábháil Mar…
    .accesskey = S
media-save-image-as =
    .label = Sábháil Mar…
    .accesskey = l

perm-tab =
    .label = Ceadanna
    .accesskey = C
permissions-for =
    .value = Ceadanna le haghaidh:

security-tab =
    .label = Slándáil
    .accesskey = S
security-view =
    .label = Taispeáin an Teastas
    .accesskey = T
security-view-unknown = Anaithnid
    .value = Anaithnid
security-view-identity =
    .value = Aitheantas an tSuímh Ghréasáin
security-view-identity-owner =
    .value = Úinéir:
security-view-identity-domain =
    .value = Suíomh Gréasáin:
security-view-identity-verifier =
    .value = Fíoraithe ag:
security-view-identity-validity =
    .value = In éag ar:
security-view-privacy =
    .value = Príobháideachas agus Stair

security-view-privacy-history-value = Ar thug mé cuairt ar an suíomh seo roimh inniu?
security-view-privacy-sitedata-value = An bhfuil an suíomh seo ag stóráil faisnéise ar mo ríomhaire?

security-view-privacy-clearsitedata =
    .label = Glan na Fianáin agus Sonraí Suímh
    .accesskey = G

security-view-privacy-passwords-value = An bhfuil focail fhaire sábháilte agam le haghaidh an tsuímh seo?

security-view-privacy-viewpasswords =
    .label = Taispeáin Focail Fhaire a Sábháladh
    .accesskey = S
security-view-technical =
    .value = Mionsonraí Teicniúla

help-button =
    .label = Cabhair

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Tá, fianáin agus { $value }{ $unit } de shonraí suímh
security-site-data-only = Tá, { $value }{ $unit } de shonraí suímh

security-site-data-cookies-only = Tá, fianáin
security-site-data-no = Níl

image-size-unknown = Anaithnid
page-info-not-specified =
    .value = Gan sonrú
not-set-alternative-text = Gan sonrú
not-set-date = Gan sonrú
media-img = Íomhá
media-bg-img = Cúlra
media-border-img = Imlíne
media-list-img = Urchar
media-cursor = Cúrsóir
media-object = Réad
media-embed = Neadaigh
media-link = Deilbhín
media-input = Ionchur
media-video = Fís
media-audio = Fuaim
saved-passwords-yes = Tá
saved-passwords-no = Níl

no-page-title =
    .value = Leathanach gan Teideal:
general-quirks-mode =
    .value = Mód leithleachais
general-strict-mode =
    .value = Mód oiriúna le caighdeáin
page-info-security-no-owner =
    .value = Ní sholáthraíonn an suíomh seo faisnéis maidir lena úinéirí.
media-select-folder = Roghnaigh Fillteán a Sábhálfar na hÍomhánna Ann
media-unknown-not-cached =
    .value = Anaithnid (gan taisceadh)
permissions-use-default =
    .label = Úsáid Réamhshocrú
security-no-visits = Níl

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (clib amháin)
            [two] Meta ({ $tags } chlib)
            [few] Meta ({ $tags } chlib)
            [many] Meta ({ $tags } gclib)
           *[other] Meta ({ $tags } clib)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Níl
        [one] Tá, uair amháin
        [two] Tá, { $visits } uair
        [few] Tá, { $visits } uaire
        [many] Tá, { $visits } n-uaire
       *[other] Tá, { $visits } uair
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } beart)
            [two] { $kb } KB ({ $bytes } beart)
            [few] { $kb } KB ({ $bytes } beart)
            [many] { $kb } KB ({ $bytes } beart)
           *[other] { $kb } KB ({ $bytes } beart)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Íomhá { $type } (beoite, { $frames } fhráma)
            [two] Íomhá { $type } (beoite, { $frames } fhráma)
            [few] Íomhá { $type } (beoite, { $frames } fhráma)
            [many] Íomhá { $type } (beoite, { $frames } bhfráma)
           *[other] Íomhá { $type } (beoite, { $frames } fráma)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Íomhá { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } picteilín × { $dimy } picteilín (scálaithe go { $scaledx } picteilín × { $scaledy } picteilín)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }pct × { $dimy }pct

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
    .label = Cuir Cosc ar Íomhánna ó { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Sonraí an Leathanaigh - { $website }
page-info-frame =
    .title = Eolas Fráma - { $website }
