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
    .label = Seleccionar tot
    .accesskey = S

close-dialog =
    .key = w

general-tab =
    .label = General
    .accesskey = G
general-title =
    .value = Títol :
general-url =
    .value = Adreça :
general-type =
    .value = Tipe :
general-mode =
    .value = Mòde de rendut :
general-size =
    .value = Talha :
general-referrer =
    .value = URL de provenença :
general-modified =
    .value = Modificat :
general-encoding =
    .value = Encodatge del tèxte :
general-meta-name =
    .label = Nom
general-meta-content =
    .label = Contengut

media-tab =
    .label = Mèdia
    .accesskey = M
media-location =
    .value = Emplaçament :
media-text =
    .value = Tèxte associat :
media-alt-header =
    .label = Tèxte alternatiu
media-address =
    .label = Adreça
media-type =
    .label = Tipe
media-size =
    .label = Talha
media-count =
    .label = Nombre
media-dimension =
    .value = Dimensions :
media-long-desc =
    .value = Descripcion longa :
media-save-as =
    .label = Enregistrar jos…
    .accesskey = E
media-save-image-as =
    .label = Enregistrar jos…
    .accesskey = E

perm-tab =
    .label = Permissions
    .accesskey = P
permissions-for =
    .value = Permissions per :

security-tab =
    .label = Seguretat
    .accesskey = S
security-view =
    .label = Visualizar lo certificat
    .accesskey = V
security-view-unknown = Desconegut
    .value = Desconegut
security-view-identity =
    .value = Identitat del site web
security-view-identity-owner =
    .value = Proprietari :
security-view-identity-domain =
    .value = Site web :
security-view-identity-verifier =
    .value = Verificat per :
security-view-identity-validity =
    .value = S'acaba lo :
security-view-privacy =
    .value = Vida privada e istoric

security-view-privacy-history-value = Ai ja visitat aqueste site ?
security-view-privacy-sitedata-value = Aqueste site web collècta d'informacions sus mon ordenador ?

security-view-privacy-clearsitedata =
    .label = Escafar cookies e donadas de site
    .accesskey = E

security-view-privacy-passwords-value = Ai enregistrat un senhal per aqueste site web ?

security-view-privacy-viewpasswords =
    .label = Visualizar los senhals enregistrats
    .accesskey = V
security-view-technical =
    .value = Detalhs tecnics

help-button =
    .label = Ajuda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Òc-ben, de cookies e { $value } { $unit } de donadas de site
security-site-data-only = Òc-ben, { $value } { $unit } de donadas de site

security-site-data-cookies-only = Òc-ben, de cookies
security-site-data-no = Non

image-size-unknown = Desconegut
page-info-not-specified =
    .value = Pas especificat
not-set-alternative-text = Pas especificat
not-set-date = Pas especificat
media-img = Imatge
media-bg-img = Fons
media-border-img = Bordadura
media-list-img = Lista amb piuses
media-cursor = Cursor
media-object = Objècte
media-embed = Embarcat
media-link = Icòna
media-input = Entrada
media-video = Vidèo
media-audio = Àudio
saved-passwords-yes = Òc
saved-passwords-no = Non

no-page-title =
    .value = Pagina sens títol :
general-quirks-mode =
    .value = Mòde de compatibilitat (quirks)
general-strict-mode =
    .value = Mòde de respècte dels estandards
page-info-security-no-owner =
    .value = Aqueste site web dòna pas cap d'informacions sul proprietari.
media-select-folder = Seleccionatz un repertòri ont enregistrar los imatges
media-unknown-not-cached =
    .value = Desconegut (pas dins lo cache)
permissions-use-default =
    .label = Utilizar las valors per defaut
security-no-visits = Non

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 balisa)
           *[other] Meta ({ $tags } balisas)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Non
        [one] Òc, un còp
       *[other] Òc, { $visits } còps
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } Ko ({ $bytes } octet)
           *[other] { $kb } Ko ({ $bytes } octets)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Imatge { $type } (animat, { $frames } calc)
           *[other] Imatge { $type } (animat, { $frames } calques)
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
    .value = { $dimx }px × { $dimy }px (redimensionat a { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } px × { $dimy } px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } Ko

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Blocar los imatges que venon de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informacions sus la pagina - { $website }
page-info-frame =
    .title = Informacions sul quadre - { $website }
