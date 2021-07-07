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
    .label = Seleziona tutto
    .accesskey = t

close-dialog =
    .key = w

general-tab =
    .label = Generale
    .accesskey = G
general-title =
    .value = Titolo:
general-url =
    .value = Indirizzo:
general-type =
    .value = Tipo:
general-mode =
    .value = Modalità di visualizzazione:
general-size =
    .value = Dimensione file:
general-referrer =
    .value = Indirizzo referente:
general-modified =
    .value = Modificato:
general-encoding =
    .value = Codifica testo:
general-meta-name =
    .label = Nome
general-meta-content =
    .label = Valore

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Indirizzo:
media-text =
    .value = Testo associato:
media-alt-header =
    .label = Testo alternativo
media-address =
    .label = Indirizzo
media-type =
    .label = Tipo
media-size =
    .label = Dimensione
media-count =
    .label = Numero
media-dimension =
    .value = Dimensioni:
media-long-desc =
    .value = Descrizione estesa:
media-save-as =
    .label = Salva con nome…
    .accesskey = A
media-save-image-as =
    .label = Salva con nome…
    .accesskey = e

perm-tab =
    .label = Permessi
    .accesskey = P
permissions-for =
    .value = Permessi per:

security-tab =
    .label = Sicurezza
    .accesskey = S
security-view =
    .label = Visualizza certificato
    .accesskey = V
security-view-unknown = Sconosciuto
    .value = Sconosciuto
security-view-identity =
    .value = Identità sito web
security-view-identity-owner =
    .value = Proprietario:
security-view-identity-domain =
    .value = Sito web:
security-view-identity-verifier =
    .value = Verificata da:
security-view-identity-validity =
    .value = Scade il:
security-view-privacy =
    .value = Privacy e cronologia

security-view-privacy-history-value = Questo sito è già stato visitato prima di oggi?
security-view-privacy-sitedata-value = Questo sito web sta memorizzando informazioni sul computer?

security-view-privacy-clearsitedata =
    .label = Elimina cookie e dati dei siti web
    .accesskey = E

security-view-privacy-passwords-value = Esistono password memorizzate per questo sito web?

security-view-privacy-viewpasswords =
    .label = Mostra password
    .accesskey = w
security-view-technical =
    .value = Dettagli tecnici

help-button =
    .label = Guida

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Sì, cookie e { $value } { $unit } di dati
security-site-data-only = Sì, { $value } { $unit } di dati

security-site-data-cookies-only = Sì, cookie
security-site-data-no = No

image-size-unknown = Sconosciuto
page-info-not-specified =
    .value = Non specificato
not-set-alternative-text = Non specificato
not-set-date = Non specificato
media-img = Immagine
media-bg-img = Sfondo
media-border-img = Bordo
media-list-img = Punto elenco
media-cursor = Cursore
media-object = Oggetto
media-embed = Incorporato
media-link = Icona
media-input = Input
media-video = Video
media-audio = Audio
saved-passwords-yes = Sì
saved-passwords-no = No

no-page-title =
    .value = Pagina senza nome:
general-quirks-mode =
    .value = Quirks mode
general-strict-mode =
    .value = Modalità rispetto standard
page-info-security-no-owner =
    .value = Non sono disponibili informazioni sul proprietario di questo sito web.
media-select-folder = Selezionare una cartella per salvare l’immagine
media-unknown-not-cached =
    .value = Sconosciuto (non in cache)
permissions-use-default =
    .label = Utilizza predefiniti
security-no-visits = No

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value = Meta ({ $tags } tag)

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] No
        [one] Sì, 1 volta
       *[other] Sì, { $visits } volte
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value = { $kb } kB ({ $bytes } byte)

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value = { $type } Immagine (animata, { $frames } frame)

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Immagine { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (ridimensionata a { $scaledx }px × { $scaledy }px)

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
    .label = Blocca immagini da { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informazioni pagina – { $website }
page-info-frame =
    .title = Informazioni riquadro – { $website }
