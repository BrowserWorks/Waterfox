# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Copiar
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Seliger toto
    .accesskey = t

close-dialog =
    .key = w

general-tab =
    .label = General
    .accesskey = G
general-title =
    .value = Titulo:
general-url =
    .value = Adresse:
general-type =
    .value = Typo:
general-mode =
    .value = Modo de presentar:
general-size =
    .value = Dimension:
general-referrer =
    .value = URL referente:
general-modified =
    .value = Modificate:
general-encoding =
    .value = Codification del texto:
general-meta-name =
    .label = Nomine
general-meta-content =
    .label = Contento

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Adresse:
media-text =
    .value = Texto associate:
media-alt-header =
    .label = Texto alternative
media-address =
    .label = Adresse
media-type =
    .label = Typo
media-size =
    .label = Dimension
media-count =
    .label = Quantitate
media-dimension =
    .value = Dimensiones:
media-long-desc =
    .value = Description longe:
media-save-as =
    .label = Salvar como…
    .accesskey = A
media-save-image-as =
    .label = Salvar como…
    .accesskey = e

perm-tab =
    .label = Permissiones
    .accesskey = P
permissions-for =
    .value = Permissiones pro:

security-tab =
    .label = Securitate
    .accesskey = S
security-view =
    .label = Vider le certificato
    .accesskey = V
security-view-unknown = Incognite
    .value = Incognite
security-view-identity =
    .value = Identitate del sito web
security-view-identity-owner =
    .value = Proprietario:
security-view-identity-domain =
    .value = Sito web:
security-view-identity-verifier =
    .value = Verificate per:
security-view-identity-validity =
    .value = Expira le:
security-view-privacy =
    .value = Confidentialitate e chronologia

security-view-privacy-history-value = Ha io visitate iste sito web anteriormente?
security-view-privacy-sitedata-value = Esque iste sito web salva informationes in mi computator?

security-view-privacy-clearsitedata =
    .label = Eliminar le cookies e le datos de sito
    .accesskey = E

security-view-privacy-passwords-value = Ha io salvate alcun contrasigno pro iste sito web?

security-view-privacy-viewpasswords =
    .label = Vider le contrasignos salvate
    .accesskey = w
security-view-technical =
    .value = Detalios technic

help-button =
    .label = Adjuta

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Si, cookies e { $value } { $unit } de datos de sito
security-site-data-only = Si, { $value } { $unit } de datos de sito

security-site-data-cookies-only = Si, cookies
security-site-data-no = No

image-size-unknown = Incognite
page-info-not-specified =
    .value = Non specificate
not-set-alternative-text = Non specificate
not-set-date = Non specificate
media-img = Imagine
media-bg-img = Fundo
media-border-img = Bordo
media-list-img = Bolletta
media-cursor = Cursor
media-object = Objecto
media-embed = Incorporate
media-link = Icone
media-input = Entrata
media-video = Video
media-audio = Audio
saved-passwords-yes = Si
saved-passwords-no = No

no-page-title =
    .value = Pagina sin titulo:
general-quirks-mode =
    .value = Modo de compatibilitate
general-strict-mode =
    .value = Modo de conformitate al standards
page-info-security-no-owner =
    .value = Le sito web non provide informationes super su proprietario.
media-select-folder = Selige un dossier ubi salvar le imagines
media-unknown-not-cached =
    .value = Incognite (non in cache)
permissions-use-default =
    .label = Usar le predefinition
security-no-visits = No

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
        [0] No
        [one] Si, un vice
       *[other] Si, { $visits } vices
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
            [one] { $type } Imagine (animate, { $frames } quadro)
           *[other] { $type } Imagine (animate, { $frames } quadros)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imagine { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (redimensionate a { $scaledx }px × { $scaledy }px)

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
    .label = Blocar le imagines ab { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informationes del pagina - { $website }
page-info-frame =
    .title = Informationes del quadro - { $website }
