# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 640px; min-height: 540px;

copy =
    .key = C
menu-copy =
    .label = Kopírovat
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Vybrat vše
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Obecné
    .accesskey = O
general-title =
    .value = Název stránky:
general-url =
    .value = Adresa:
general-type =
    .value = Typ:
general-mode =
    .value = Režim vykreslování:
general-size =
    .value = Velikost:
general-referrer =
    .value = Odkazující URL:
general-modified =
    .value = Změněno:
general-encoding =
    .value = Znaková sada textu:
general-meta-name =
    .label = Název
general-meta-content =
    .label = Obsah

media-tab =
    .label = Média
    .accesskey = M
media-location =
    .value = Adresa:
media-text =
    .value = Přidružený text:
media-alt-header =
    .label = Alternativní text
media-address =
    .label = Adresa
media-type =
    .label = Typ
media-size =
    .label = Velikost
media-count =
    .label = Počet
media-dimension =
    .value = Rozměry:
media-long-desc =
    .value = Dlouhý popis:
media-save-as =
    .label = Uložit jako…
    .accesskey = j
media-save-image-as =
    .label = Uložit jako…
    .accesskey = a

perm-tab =
    .label = Oprávnění
    .accesskey = p
permissions-for =
    .value = Oprávnění serveru

security-tab =
    .label = Zabezpečení
    .accesskey = b
security-view =
    .label = Zobrazit certifikát
    .accesskey = c
security-view-unknown = Neznámý
    .value = Neznámý
security-view-identity =
    .value = Identita webového serveru
security-view-identity-owner =
    .value = Vlastník:
security-view-identity-domain =
    .value = Webový server:
security-view-identity-verifier =
    .value = Ověřil:
security-view-identity-validity =
    .value = Platnost do:
security-view-privacy =
    .value = Soukromí a historie

security-view-privacy-history-value = Navštívil jsem už někdy tento server?
security-view-privacy-sitedata-value = Má tento server na mém počítači uložena nějaká data?

security-view-privacy-clearsitedata =
    .label = Vymazat cookies a uložená data
    .accesskey = c

security-view-privacy-passwords-value = Mám pro tento server uložená hesla?

security-view-privacy-viewpasswords =
    .label = Zobrazit uložená hesla
    .accesskey = h
security-view-technical =
    .value = Technické detaily

help-button =
    .label = Nápověda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ano, cookies a { $value } { $unit } dat
security-site-data-only = Ano, { $value } { $unit } dat

security-site-data-cookies-only = Ano, cookies
security-site-data-no = Ne

##

image-size-unknown = Neznámý
page-info-not-specified =
    .value = Neurčeno
not-set-alternative-text = Neurčeno
not-set-date = Neurčeno
media-img = Obrázek
media-bg-img = Pozadí
media-border-img = Okraj
media-list-img = Odrážka
media-cursor = Kurzor
media-object = Objekt
media-embed = Vložený
media-link = Ikona
media-input = Vstup
media-video = Video
media-audio = Audio
saved-passwords-yes = Ano
saved-passwords-no = Ne

no-page-title =
    .value = Stránka bez názvu
general-quirks-mode =
    .value = Režim zpětné kompatibility
general-strict-mode =
    .value = Režim platných standardů
page-info-security-no-owner =
    .value = Tato stránka neposkytuje informace o vlastníkovi
media-select-folder = Zvolte složku pro uložení obrázků
media-unknown-not-cached =
    .value = Neznámá (není v mezipaměti)
permissions-use-default =
    .label = Použít výchozí
security-no-visits = Ne

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
            [few] Meta ({ $tags } tagy)
           *[other] Meta ({ $tags } tagů)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne
        [one] Ano, jednou
        [few] Ano, { $visits } krát
       *[other] Ano, { $visits } krát
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
            [few] { $kb } KB ({ $bytes } bajty)
           *[other] { $kb } KB ({ $bytes } bajtů)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } obrázek (animovaný, { $frames } snímek)
            [few] { $type } obrázek (animovaný, { $frames } snímky)
           *[other] { $type } obrázek (animovaný, { $frames } snímků)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Obrázek typu { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (změněno na { $scaledx }px × { $scaledy }px)

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
    .label = Blokovat obrázky ze serveru { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = Informace o stránce - { $website }
page-info-frame =
    .title = Informace o rámu - { $website }
