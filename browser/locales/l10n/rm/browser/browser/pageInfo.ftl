# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 600px;

copy =
    .key = C
menu-copy =
    .label = Copiar
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Selecziunar tut
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = General
    .accesskey = G
general-title =
    .value = Titel:
general-url =
    .value = Adressa:
general-type =
    .value = Tip:
general-mode =
    .value = Modus da vista:
general-size =
    .value = Grondezza:
general-referrer =
    .value = URL che renviescha:
general-modified =
    .value = Modifitgà:
general-encoding =
    .value = Codaziun dal text:
general-meta-name =
    .label = Num
general-meta-content =
    .label = Cuntegn

media-tab =
    .label = Medias
    .accesskey = M
media-location =
    .value = Adressa:
media-text =
    .value = Text allocà:
media-alt-header =
    .label = Text alternativ
media-address =
    .label = Adressa
media-type =
    .label = Tip
media-size =
    .label = Grondezza
media-count =
    .label = Dumber
media-dimension =
    .value = Dimensiun:
media-long-desc =
    .value = Descripziun detagliada:
media-save-as =
    .label = Memorisar sut…
    .accesskey = s
media-save-image-as =
    .label = Memorisar sut…
    .accesskey = e

perm-tab =
    .label = Autorisaziuns
    .accesskey = A
permissions-for =
    .value = Autorisaziuns per:

security-tab =
    .label = Segirezza
    .accesskey = S
security-view =
    .label = Mussar il certificat
    .accesskey = c
security-view-unknown = Betg enconuschent
    .value = Betg enconuschent
security-view-identity =
    .value = Identitad da la website
security-view-identity-owner =
    .value = Possessur:
security-view-identity-domain =
    .value = Website:
security-view-identity-verifier =
    .value = Verifitgà da:
security-view-identity-validity =
    .value = Scada ils:
security-view-privacy =
    .value = Protecziun da datas & cronica

security-view-privacy-history-value = Hai jau gia visità ina giada questa website?
security-view-privacy-sitedata-value = Memorisescha questa website infurmaziuns sin mes computer?

security-view-privacy-clearsitedata =
    .label = Stizzar cookies e datas da websites
    .accesskey = c

security-view-privacy-passwords-value = Hai jau memorisà pleds-clav per questa website?

security-view-privacy-viewpasswords =
    .label = Mussar ils pleds-clav
    .accesskey = u
security-view-technical =
    .value = Detagls tecnics

help-button =
    .label = Agid

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Gea, cookies e { $value } { $unit } datas da websites
security-site-data-only = Gea, { $value } { $unit } datas da websites

security-site-data-cookies-only = Gea, cookies
security-site-data-no = Na

image-size-unknown = Betg enconuschent
page-info-not-specified =
    .value = Betg inditgà
not-set-alternative-text = Betg inditgà
not-set-date = Betg inditgà
media-img = Grafica
media-bg-img = Fund davos
media-border-img = Bordura
media-list-img = Simbol d'enumeraziun
media-cursor = Cursur
media-object = Object
media-embed = Integrà
media-link = Simbol
media-input = Endataziun
media-video = Video
media-audio = Audio
saved-passwords-yes = Gea
saved-passwords-no = Na

no-page-title =
    .value = Pagina senza num:
general-quirks-mode =
    .value = Modus da cumpatibilitad (Quirks)
general-strict-mode =
    .value = Modus confurm al standard
page-info-security-no-owner =
    .value = Questa website na porscha naginas infurmaziuns davart il proprietari.
media-select-folder = Tscherna in ordinatur per memorisar las graficas
media-unknown-not-cached =
    .value = Betg enconuschent (betg en il cache)
permissions-use-default =
    .label = Utilisar il standard
security-no-visits = Na

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
        [0] Na
        [one] Gea, ina giada
       *[other] Gea, { $visits } giadas
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
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
            [one] Maletg { $type } (animà, { $frames } maletg singul)
           *[other] Maletg { $type } (animà, { $frames } maletgs singuls)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Grafica { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (redimensiunà a { $scaledx }px × { $scaledy }px)

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
    .label = Bloccar las graficas da { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Infurmaziun davart la pagina - { $website }
page-info-frame =
    .title = Infurmaziun davart il frame - { $website }
