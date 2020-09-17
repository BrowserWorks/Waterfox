# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 700px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Dèan lethbhreac
    .accesskey = c

select-all =
    .key = A
menu-select-all =
    .label = Tagh a h-uile
    .accesskey = T

general-tab =
    .label = Coitcheann
    .accesskey = c
general-title =
    .value = Tiotal:
general-url =
    .value = Seòladh:
general-type =
    .value = Seòrsa:
general-mode =
    .value = Modh reandaraidh:
general-size =
    .value = Meud:
general-referrer =
    .value = An t-URL on dàinigear:
general-modified =
    .value = Air atharrachadh:
general-encoding =
    .value = Còdachadh an teacsa:
general-meta-name =
    .label = Ainm
general-meta-content =
    .label = Susbaint

media-tab =
    .label = Meadhanan
    .accesskey = M
media-location =
    .value = Àite:
media-text =
    .value = Teacsa co-cheangailte:
media-alt-header =
    .label = Roghainn teacsa eile
media-address =
    .label = Seòladh
media-type =
    .label = Seòrsa
media-size =
    .label = Meud
media-count =
    .label = Cunntas
media-dimension =
    .value = Meudachd:
media-long-desc =
    .value = An tuairisgeul fada:
media-save-as =
    .label = Sàbhail mar…
    .accesskey = a
media-save-image-as =
    .label = Sàbhail mar…
    .accesskey = e

perm-tab =
    .label = Ceadachan
    .accesskey = C
permissions-for =
    .value = Ceadachan airson:

security-tab =
    .label = Tèarainteachd
    .accesskey = n
security-view =
    .label = Seall an teisteanas
    .accesskey = V
security-view-unknown = Neo-aithnichte
    .value = Neo-aithnichte
security-view-identity =
    .value = Dearbh-aithne na làraich-lìn
security-view-identity-owner =
    .value = Sealbhadair:
security-view-identity-domain =
    .value = Làrach-lìn:
security-view-identity-verifier =
    .value = Air a dhearbhadh le:
security-view-identity-validity =
    .value = Falbhaidh an ùine air:
security-view-privacy =
    .value = Prìobhaideachd ⁊ eachdraidh

security-view-privacy-history-value = Na thadhail mi air an làrach-lìn seo ro an-diugh?
security-view-privacy-sitedata-value = A bheil an làrach seo a’ stòradh fiosrachadh air a’ choimpiutair agam?

security-view-privacy-clearsitedata =
    .label = Falamhaich na briosgaidean is dàta nan làrach
    .accesskey = C

security-view-privacy-passwords-value = A bheil mi air facal-faire a shàbhaladh air an làrach seo?

security-view-privacy-viewpasswords =
    .label = Faclan-faire a shàbhail thu
    .accesskey = w
security-view-technical =
    .value = Mion-fhiosrachadh teicnigeach

help-button =
    .label = Cobhair

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Tha, na briosgaidean is { $value } { $unit } de dhàta làraichean
security-site-data-only = Tha, { $value } { $unit } de dhàta làraichean

security-site-data-cookies-only = Tha, na briosgaidean
security-site-data-no = Chan eil

image-size-unknown = Neo-aithnichte
page-info-not-specified =
    .value = Gun sònrachadh
not-set-alternative-text = Gun sònrachadh
not-set-date = Gun sònrachadh
media-img = Dealbh
media-bg-img = Cùlaibh
media-border-img = Iomall
media-list-img = Peilear
media-cursor = A' chuileag
media-object = Oibseact
media-embed = Leabaich
media-link = Ìomhaigheag
media-input = Cuir a-steach
media-video = Video
media-audio = Fuaim
saved-passwords-yes = Tha
saved-passwords-no = Chan eil

no-page-title =
    .value = Duilleag gun tiotal:
general-quirks-mode =
    .value = Am modh cuilbheartach
general-strict-mode =
    .value = Am modh gèillidh le stannardan
page-info-security-no-owner =
    .value = Chan eil an làrach-lìn seo a' nochdadh fiosrachadh mu na sealbhadairean.
media-select-folder = Tagh pasgan san dèid na dealbhan a shàbhaladh
media-unknown-not-cached =
    .value = Neo-aithnichte (gun tasgadh)
permissions-use-default =
    .label = Cleachd an roghainn bhunaiteach
security-no-visits = Chan eil

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta ({ $tags } taga)
            [two] Meta ({ $tags } thaga)
            [few] Meta ({ $tags } tagaichean)
           *[other] Meta ({ $tags } taga)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Chan eil gin
        [one] Tha, { $visits } turas
        [two] Tha, { $visits } thuras
        [few] Tha, { $visits } turais
       *[other] Tha, { $visits } turas
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } byte)
            [two] { $kb } KB ({ $bytes } bytes)
            [few] { $kb } KB ({ $bytes } bytes)
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
            [one] Dealbh { $type } (beòthaichte, { $frames } fhrèam)
            [two] Dealbh { $type } (beòthaichte, { $frames } fhrèam)
            [few] Dealbh { $type } (beòthaichte, { $frames } frèamaichean)
           *[other] Dealbh { $type } (beòthaichte, { $frames } frèam)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Dealbh { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (scaled to { $scaledx }px × { $scaledy }px)

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
    .label = Cuir bacadh air dealbhan o { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Fiosrachadh na duilleige - { $website }
page-info-frame =
    .title = Fiosrachadh an fhrèama - { $website }
