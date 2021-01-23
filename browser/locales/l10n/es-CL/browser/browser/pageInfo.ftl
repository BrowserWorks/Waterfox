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
    .label = Seleccionar todo
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = General
    .accesskey = G
general-title =
    .value = Título:
general-url =
    .value = Dirección:
general-type =
    .value = Tipo:
general-mode =
    .value = Modo de renderizado:
general-size =
    .value = Tamaño:
general-referrer =
    .value = URL de referencia:
general-modified =
    .value = Modificado:
general-encoding =
    .value = Codificación del texto:
general-meta-name =
    .label = Nombre
general-meta-content =
    .label = Contenido

media-tab =
    .label = Medios
    .accesskey = M
media-location =
    .value = Dirección:
media-text =
    .value = Texto asociado:
media-alt-header =
    .label = Texto alternativo
media-address =
    .label = Dirección
media-type =
    .label = Tipo
media-size =
    .label = Tamaño
media-count =
    .label = Cuenta
media-dimension =
    .value = Dimensiones:
media-long-desc =
    .value = Descripción larga:
media-save-as =
    .label = Guardar como…
    .accesskey = A
media-save-image-as =
    .label = Guardar como…
    .accesskey = e

perm-tab =
    .label = Permisos
    .accesskey = P
permissions-for =
    .value = Permisos para:

security-tab =
    .label = Seguridad
    .accesskey = S
security-view =
    .label = Ver certificado
    .accesskey = V
security-view-unknown = Desconocido
    .value = Desconocido
security-view-identity =
    .value = Desconocido
security-view-identity-owner =
    .value = Dueño:
security-view-identity-domain =
    .value = Sitio:
security-view-identity-verifier =
    .value = Verificado por:
security-view-identity-validity =
    .value = Expira el:
security-view-privacy =
    .value = Privacidad e historial

security-view-privacy-history-value = ¿He visitado este sitio web anteriormente?
security-view-privacy-sitedata-value = ¿Está este sitio web almacenando información en mi computador?

security-view-privacy-clearsitedata =
    .label = Limpiar cookies y datos del sitio
    .accesskey = C

security-view-privacy-passwords-value = ¿He guardado contraseñas para este sitio web?

security-view-privacy-viewpasswords =
    .label = Ver contraseñas guardadas
    .accesskey = w
security-view-technical =
    .value = Detalles técnicos

help-button =
    .label = Ayuda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Sí, cookies y { $value } { $unit } de datos del sitio
security-site-data-only = Sí, { $value } { $unit } de datos del sitio

security-site-data-cookies-only = Sí, cookies
security-site-data-no = No

image-size-unknown = Desconocido
page-info-not-specified =
    .value = No especificado
not-set-alternative-text = No especificado
not-set-date = No especificado
media-img = Imagen
media-bg-img = Fondo
media-border-img = Borde
media-list-img = Viñeta
media-cursor = Cursor
media-object = Objeto
media-embed = Incrustado
media-link = Icono
media-input = Entrada
media-video = Video
media-audio = Audio
saved-passwords-yes = Sí
saved-passwords-no = No

no-page-title =
    .value = Página sin título:
general-quirks-mode =
    .value = Modo de compatibilidad
general-strict-mode =
    .value = Modo de cumplimiento de estándares
page-info-security-no-owner =
    .value = Este sitio web no ha suministrado información del propietario.
media-select-folder = Selecciona una carpeta donde guardar las imágenes
media-unknown-not-cached =
    .value = Desconocido (no cacheado)
permissions-use-default =
    .label = Usar predeterminados
security-no-visits = No

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 etiqueta)
           *[other] Meta ({ $tags } etiquetas)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] No
        [one] Sí, una vez
       *[other] Sí, { $visits } veces
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
            [one] { $type } Imagen (animada, { $frames } cuadro)
           *[other] { $type } Imagen (animada, { $frames } cuadros)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imagen { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (redimensionada a { $scaledx }px × { $scaledy }px)

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
    .label = Bloquear imágenes de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Información de la página - { $website }
page-info-frame =
    .title = Información del marco - { $website }
