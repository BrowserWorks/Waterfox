# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Copia
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Selecciona-ho tot
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = General
    .accesskey = G
general-title =
    .value = Títol:
general-url =
    .value = Adreça:
general-type =
    .value = Tipus:
general-mode =
    .value = Mode de renderització:
general-size =
    .value = Mida:
general-referrer =
    .value = URL referent:
general-modified =
    .value = Modificat:
general-encoding =
    .value = Codificació del text:
general-meta-name =
    .label = Nom
general-meta-content =
    .label = Contingut

media-tab =
    .label = Multimèdia
    .accesskey = M
media-location =
    .value = Ubicació:
media-text =
    .value = Text associat:
media-alt-header =
    .label = Text alternatiu
media-address =
    .label = Adreça
media-type =
    .label = Tipus
media-size =
    .label = Mida
media-count =
    .label = Recompte
media-dimension =
    .value = Dimensions:
media-long-desc =
    .value = Descripció llarga:
media-save-as =
    .label = Anomena i desa…
    .accesskey = a
media-save-image-as =
    .label = Anomena i desa…
    .accesskey = e

perm-tab =
    .label = Permisos
    .accesskey = P
permissions-for =
    .value = Permisos per:

security-tab =
    .label = Seguretat
    .accesskey = S
security-view =
    .label = Mostra el certificat
    .accesskey = c
security-view-unknown = Desconegut
    .value = Desconegut
security-view-identity =
    .value = Identitat del lloc web
security-view-identity-owner =
    .value = Propietari:
security-view-identity-domain =
    .value = Lloc web:
security-view-identity-verifier =
    .value = Verificat per:
security-view-identity-validity =
    .value = Data de venciment:
security-view-privacy =
    .value = Privadesa i historial

security-view-privacy-history-value = He visitat aquest lloc web abans d'avui?
security-view-privacy-sitedata-value = Aquest lloc web emmagatzema informació al meu ordinador?

security-view-privacy-clearsitedata =
    .label = Esborra les galetes i dades dels llocs
    .accesskey = E

security-view-privacy-passwords-value = He desat cap contrasenya d'aquest lloc web?

security-view-privacy-viewpasswords =
    .label = Mostra les contrasenyes desades
    .accesskey = y
security-view-technical =
    .value = Detalls tècnics

help-button =
    .label = Ajuda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Sí, galetes i { $value } { $unit } de dades del lloc
security-site-data-only = Sí, { $value } { $unit } de dades del lloc

security-site-data-cookies-only = Sí, galetes
security-site-data-no = No

image-size-unknown = Desconegut
page-info-not-specified =
    .value = Sense especificar
not-set-alternative-text = No s'ha especificat
not-set-date = No s'ha especificat
media-img = Imatge
media-bg-img = Fons
media-border-img = Contorn
media-list-img = Pic
media-cursor = Cursor
media-object = Objecte
media-embed = Incrusta
media-link = Icona
media-input = Entrada
media-video = Vídeo
media-audio = Àudio
saved-passwords-yes = Sí
saved-passwords-no = No

no-page-title =
    .value = Pàgina sense títol:
general-quirks-mode =
    .value = Mode de compatibilitat
general-strict-mode =
    .value = Mode de compliment dels estàndards
page-info-security-no-owner =
    .value = Aquest lloc web no proporciona cap informació de propietat.
media-select-folder = Seleccioneu una carpeta on desar les imatges
media-unknown-not-cached =
    .value = Desconegut (no està a la memòria cau)
permissions-use-default =
    .label = Utilitza el valor per defecte
security-no-visits = No

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 etiqueta)
           *[other] Meta ({ $tags } etiquetes)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] No
        [one] Sí, una vegada
       *[other] Sí, { $visits } vegades
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } kB ({ $bytes } byte)
           *[other] { $kb } kB ({ $bytes } bytes)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Imatge { $type } (animada, { $frames } fotograma)
           *[other] Imatge { $type } (animada, { $frames } fotogrames)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imatge { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (escalada a { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } kB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Bloca les imatges de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informació de la pàgina - { $website }
page-info-frame =
    .title = Informació del marc - { $website }
