# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopēt
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Iezīmēt visu
    .accesskey = v

general-tab =
    .label = Vispārējā
    .accesskey = G
general-title =
    .value = Virsraksts:
general-url =
    .value = Adrese:
general-type =
    .value = Tips:
general-mode =
    .value = Renderēšanas režīms:
general-size =
    .value = Izmērs:
general-referrer =
    .value = Nosūtītāja URL:
general-modified =
    .value = Mainīts:
general-encoding =
    .value = Teksta kodējums:
general-meta-name =
    .label = Nosaukums
general-meta-content =
    .label = Saturs

media-tab =
    .label = Multivide
    .accesskey = M
media-location =
    .value = Adrese:
media-text =
    .value = Piesaistītais teksts:
media-alt-header =
    .label = Alternatīvais teksts
media-address =
    .label = Adrese
media-type =
    .label = Tips
media-size =
    .label = Faila izmērs
media-count =
    .label = Skaits
media-dimension =
    .value = Izmēri:
media-long-desc =
    .value = Garais apraksts:
media-save-as =
    .label = Saglabāt kā...
    .accesskey = A
media-save-image-as =
    .label = Saglabāt kā...
    .accesskey = e

perm-tab =
    .label = Atļaujas
    .accesskey = P
permissions-for =
    .value = Atļaujas lapai:

security-tab =
    .label = Drošība
    .accesskey = S
security-view =
    .label = Skatīt sertifikātu
    .accesskey = f
security-view-unknown = Nezināms
    .value = Nezināms
security-view-identity =
    .value = Mājas lapas identitāte
security-view-identity-owner =
    .value = Īpašnieks:
security-view-identity-domain =
    .value = Mājas lapa:
security-view-identity-verifier =
    .value = Pārbaudījis:
security-view-identity-validity =
    .value = Derīgs līdz:
security-view-privacy =
    .value = Privātums un vēsture

security-view-privacy-history-value = Vai es šo lapu šodien jau esmu apmeklējis?
security-view-privacy-sitedata-value = Vai šī vietne glabā kādu informāciju manā datorā?

security-view-privacy-clearsitedata =
    .label = Notīrīt sīkdatnes un lapu datus
    .accesskey = N

security-view-privacy-passwords-value = Vai man ir saglabātas paroles šai lapai?

security-view-privacy-viewpasswords =
    .label = Skatīt saglabātās paroles
    .accesskey = p
security-view-technical =
    .value = Tehniskā informācija

help-button =
    .label = Palīdzība

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Jā, sīkdatnes un { $value } { $unit } lapas datus
security-site-data-only = Jā, { $value } { $unit } lapas datus

security-site-data-cookies-only = Jā, sīkdatnes
security-site-data-no = Nē

image-size-unknown = Nezināms
page-info-not-specified =
    .value = Nav norādīts
not-set-alternative-text = Nav norādīts
not-set-date = Nav norādīts
media-img = Attēls
media-bg-img = Fons
media-border-img = Apmale
media-list-img = Aizzīme
media-cursor = Kursors
media-object = Objekts
media-embed = Iegults
media-link = Ikona
media-input = Ievade
media-video = Video
media-audio = Audio
saved-passwords-yes = Jā
saved-passwords-no = Nē

no-page-title =
    .value = Nenosaukta lapa:
general-quirks-mode =
    .value = Saderības režīms
general-strict-mode =
    .value = Standartu atbilstības režīms
page-info-security-no-owner =
    .value = Šī mājas lapa nepiedāvā informāciju par savu īpašnieku.
media-select-folder = Izvēlieties mapi, kurā saglabāt attēlus
media-unknown-not-cached =
    .value = Nezināms (nav kešatmiņā)
permissions-use-default =
    .label = Izmantot noklusētos
security-no-visits = Nē

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } attēls

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (izmainīts uz { $scaledx }px × { $scaledy }px)

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
    .label = Bloķēt attēlus no { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informācija par lapu - { $website }
page-info-frame =
    .title = Informācija par ietvaru - { $website }
