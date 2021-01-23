# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Copiar
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Esbillar too
    .accesskey = a

general-tab =
    .label = Xeneral
    .accesskey = X
general-title =
    .value = Títulu:
general-url =
    .value = Direición:
general-type =
    .value = Triba:
general-mode =
    .value = Mou de renderizáu:
general-size =
    .value = Tamañu:
general-referrer =
    .value = URL de referencia:
general-modified =
    .value = Modificáu:
general-encoding =
    .value = Codificación de testu:
general-meta-name =
    .label = Nome
general-meta-content =
    .label = Conteníu

media-tab =
    .label = Medios
    .accesskey = M
media-location =
    .value = Direición:
media-text =
    .value = Testu asociáu:
media-alt-header =
    .label = Testu alternativu
media-address =
    .label = Direición
media-type =
    .label = Triba
media-size =
    .label = Tamañu
media-count =
    .label = Cuenta
media-dimension =
    .value = Dimensiones:
media-long-desc =
    .value = Descripción llarga:
media-save-as =
    .label = Guardar como…
    .accesskey = c
media-save-image-as =
    .label = Guardar como…
    .accesskey = e

perm-tab =
    .label = Permisos
    .accesskey = P
permissions-for =
    .value = Permisos pa:

security-tab =
    .label = Seguranza
    .accesskey = S
security-view =
    .label = Ver certificáu
    .accesskey = V
security-view-unknown = Desconocíu
    .value = Desconocíu
security-view-identity =
    .value = Identidá del sitiu web
security-view-identity-owner =
    .value = Propietariu:
security-view-identity-domain =
    .value = Sitiu web:
security-view-identity-verifier =
    .value = Verificáu por:
security-view-identity-validity =
    .value = Caduca'l
security-view-privacy =
    .value = Privacidá ya historial

security-view-privacy-history-value = ¿Visité esti sitiu web enantes?

security-view-privacy-passwords-value = ¿Guardé cualesquier contraseña pa esti sitiu web?

security-view-privacy-viewpasswords =
    .label = Ver contraseñes guardaes
    .accesskey = V
security-view-technical =
    .value = Detalles téunicos

help-button =
    .label = Ayuda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-no = Non

image-size-unknown = Desconocíu
page-info-not-specified =
    .value = Nun s'especificó
not-set-alternative-text = Nun s'especificó
not-set-date = Nun s'especificó
media-img = Imaxe
media-bg-img = Fondu
media-border-img = Berbesu
media-list-img = Viñeta
media-cursor = Cursor
media-object = Oxetu
media-embed = Integráu
media-link = Iconu
media-input = Entrada
media-video = Videu
media-audio = Audiu
saved-passwords-yes = Sí
saved-passwords-no = Non

no-page-title =
    .value = Páxina ensin títulu
general-quirks-mode =
    .value = Mou de compatibilidá
general-strict-mode =
    .value = Mou compatible colos estándares
page-info-security-no-owner =
    .value = Esti sitiu web nun apurre información tocante al so propietariu.
media-select-folder = Esbilla una carpeta pa guardar les imáxenes
media-unknown-not-cached =
    .value = Desconocíu (nun ta caché)
permissions-use-default =
    .label = Usar predetermináu
security-no-visits = Non

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imaxe { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (escaláu a { $scaledx }px × { $scaledy }px)

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
    .label = Bloquiar imáxenes de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Información de páxina - { $website }
page-info-frame =
    .title = Información del marcu - { $website }
