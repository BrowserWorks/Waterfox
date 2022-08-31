# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Másolás
    .accesskey = M

select-all =
    .key = A
menu-select-all =
    .label = Minden kijelölése
    .accesskey = d

close-dialog =
    .key = w

general-tab =
    .label = Általános
    .accesskey = l
general-title =
    .value = Cím:
general-url =
    .value = Cím:
general-type =
    .value = Típus:
general-mode =
    .value = Megjelenítési mód:
general-size =
    .value = Méret:
general-referrer =
    .value = Hivatkozó URL:
general-modified =
    .value = Módosítva:
general-encoding =
    .value = Szövegkódolás:
general-meta-name =
    .label = Név
general-meta-content =
    .label = Tartalom

media-tab =
    .label = Média
    .accesskey = M
media-location =
    .value = Hely:
media-text =
    .value = Kapcsolódó szöveg:
media-alt-header =
    .label = Alternatív szöveg
media-address =
    .label = Cím
media-type =
    .label = Típus
media-size =
    .label = Méret
media-count =
    .label = Darab
media-dimension =
    .value = Méretek:
media-long-desc =
    .value = Hosszú leírás:
media-save-as =
    .label = Mentés másként…
    .accesskey = M
media-save-image-as =
    .label = Mentés másként…
    .accesskey = e

perm-tab =
    .label = Engedélyek
    .accesskey = E
permissions-for =
    .value = Engedélyezés:

security-tab =
    .label = Biztonság
    .accesskey = B
security-view =
    .label = Tanúsítvány megtekintése
    .accesskey = T
security-view-unknown = Ismeretlen
    .value = Ismeretlen
security-view-identity =
    .value = Webhely azonosítása
security-view-identity-owner =
    .value = Tulajdonos:
security-view-identity-domain =
    .value = Webhely:
security-view-identity-verifier =
    .value = Ellenőrizte:
security-view-identity-validity =
    .value = Lejárat:
security-view-privacy =
    .value = Adatvédelem és előzmények

security-view-privacy-history-value = Megnéztem már ezt a webhelyet korábban?
security-view-privacy-sitedata-value = Tárol ez a webhely adatokat a számítógépemen?

security-view-privacy-clearsitedata =
    .label = Sütik és oldaladatok törlése
    .accesskey = t

security-view-privacy-passwords-value = Mentettem jelszavakat ehhez a webhelyhez?

security-view-privacy-viewpasswords =
    .label = Mentett jelszavak megtekintése
    .accesskey = M
security-view-technical =
    .value = Technikai részletek

help-button =
    .label = Súgó

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Igen, sütiket és { $value } { $unit } oldaladatot
security-site-data-only = Igen, { $value } { $unit } oldaladatot

security-site-data-cookies-only = Igen, sütiket
security-site-data-no = Nem

##

image-size-unknown = Ismeretlen
page-info-not-specified =
    .value = Nincs megadva
not-set-alternative-text = Nincs megadva
not-set-date = Nincs megadva
media-img = Kép
media-bg-img = Háttér
media-border-img = Szegély
media-list-img = Felsorolásjel
media-cursor = Kurzor
media-object = Objektum
media-embed = Beágyazott
media-link = Ikon
media-input = Bevitel
media-video = Video
media-audio = Hang
saved-passwords-yes = Igen
saved-passwords-no = Nem

no-page-title =
    .value = Névtelen oldal:
general-quirks-mode =
    .value = Kompatibilitási mód
general-strict-mode =
    .value = Szigorú szabványkompatibilitási mód
page-info-security-no-owner =
    .value = Ez a webhely nem szolgáltat információkat a tulajdonosáról.
media-select-folder = Mappa kijelölése a képek mentéséhez
media-unknown-not-cached =
    .value = Ismeretlen (nincs a gyorsítótárban)
permissions-use-default =
    .label = Alapértelmezés használata
security-no-visits = Nem

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 címke)
           *[other] Meta ({ $tags } címke)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nem
        [one] Igen, egyszer
       *[other] Igen, { $visits } alkalommal
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bájt)
           *[other] { $kb } KB ({ $bytes } bájt)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type }-kép (animált, { $frames } képkocka)
           *[other] { $type }-kép (animált, { $frames } képkocka)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } kép

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (átméretezve: { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Képek blokkolása a(z) { $website } helyről
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Oldal adatai – { $website }
page-info-frame =
    .title = Keret adatai – { $website }
