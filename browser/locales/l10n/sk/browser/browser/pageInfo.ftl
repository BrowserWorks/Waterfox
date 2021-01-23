# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 650px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopírovať
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Vybrať všetko
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Všeobecné
    .accesskey = V
general-title =
    .value = Názov:
general-url =
    .value = Adresa:
general-type =
    .value = Typ:
general-mode =
    .value = Spôsob vykreslenia:
general-size =
    .value = Veľkosť:
general-referrer =
    .value = Odkazujúca adresa URL:
general-modified =
    .value = Upravená:
general-encoding =
    .value = Kódovanie textu:
general-meta-name =
    .label = Názov
general-meta-content =
    .label = Obsah

media-tab =
    .label = Médiá
    .accesskey = M
media-location =
    .value = Adresa:
media-text =
    .value = Priradený text:
media-alt-header =
    .label = Alternatívny text
media-address =
    .label = Adresa
media-type =
    .label = Typ
media-size =
    .label = Veľkosť
media-count =
    .label = Počet
media-dimension =
    .value = Rozmery:
media-long-desc =
    .value = Dlhý popis:
media-save-as =
    .label = Uložiť ako…
    .accesskey = U
media-save-image-as =
    .label = Uložiť ako…
    .accesskey = a

perm-tab =
    .label = Povolenia
    .accesskey = P
permissions-for =
    .value = Povolenia pre:

security-tab =
    .label = Zabezpečenie
    .accesskey = Z
security-view =
    .label = Zobraziť certifikát
    .accesskey = c
security-view-unknown = neznámy
    .value = neznámy
security-view-identity =
    .value = Identita webovej stránky
security-view-identity-owner =
    .value = Vlastník:
security-view-identity-domain =
    .value = Webová stránka:
security-view-identity-verifier =
    .value = Overil ju:
security-view-identity-validity =
    .value = Koniec platnosti:
security-view-privacy =
    .value = Súkromie a história

security-view-privacy-history-value = Navštívil som túto stránku v minulosti?
security-view-privacy-sitedata-value = Ukladá táto stránka informácie na mojom počítači?

security-view-privacy-clearsitedata =
    .label = Vymazať cookies a údaje stránok
    .accesskey = c

security-view-privacy-passwords-value = Uložil som pre túto stránku nejaké heslá?

security-view-privacy-viewpasswords =
    .label = Zobraziť uložené heslá
    .accesskey = u
security-view-technical =
    .value = Technické detaily

help-button =
    .label = Pomocník

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Áno, cookies a { $value } { $unit } údajov stránok
security-site-data-only = Áno, { $value } { $unit } údajov stránok

security-site-data-cookies-only = Áno, cookies
security-site-data-no = Nie

image-size-unknown = Neznáme
page-info-not-specified =
    .value = Nie je zadané
not-set-alternative-text = Nie je zadané
not-set-date = Nie je zadané
media-img = Obrázok
media-bg-img = Pozadie
media-border-img = Okraj
media-list-img = Odrážka
media-cursor = Kurzor
media-object = Objekt
media-embed = Vložené
media-link = Ikona
media-input = Vstup
media-video = Video
media-audio = Zvuk
saved-passwords-yes = Áno
saved-passwords-no = Nie

no-page-title =
    .value = Bez názvu
general-quirks-mode =
    .value = Režim ako staršie prehliadače (Quirks)
general-strict-mode =
    .value = Kompatibilný so štandardami
page-info-security-no-owner =
    .value = Táto stránka neposkytuje informácie o majiteľovi.
media-select-folder = Vyberte priečinok na uloženie obrázkov
media-unknown-not-cached =
    .value = Neznáme (nie je vo vyrovnávacej pamäti)
permissions-use-default =
    .label = Použiť predvolené
security-no-visits = Nie

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 značka)
            [few] Meta ({ $tags } značky)
           *[other] Meta ({ $tags } značiek)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nie
        [one] Áno, raz
        [few] Áno, { $visits }-krát
       *[other] Áno, { $visits }-krát
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } kB ({ $bytes } bajt)
            [few] { $kb } kB ({ $bytes } bajty)
           *[other] { $kb } kB ({ $bytes } bajtov)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } obrázok (animovaný, { $frames } snímok)
            [few] { $type } obrázok (animovaný, { $frames } snímky)
           *[other] { $type } obrázok (animovaný, { $frames } snímkov)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Obrázok { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } px × { $dimy } px (zmenšený na { $scaledx } px × { $scaledy } px)

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
media-file-size = { $size } kB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Blokovať obrázky z { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informácie o stránke - { $website }
page-info-frame =
    .title = Informácie o rámci - { $website }
