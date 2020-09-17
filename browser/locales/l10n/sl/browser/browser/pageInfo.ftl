# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Kopiraj
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Izberi vse
    .accesskey = V

close-dialog =
    .key = w

general-tab =
    .label = Splošno
    .accesskey = S
general-title =
    .value = Naslov:
general-url =
    .value = Spletni naslov:
general-type =
    .value = Vrsta:
general-mode =
    .value = Način izrisovanja:
general-size =
    .value = Velikost:
general-referrer =
    .value = URL napotitelja:
general-modified =
    .value = Spremenjeno:
general-encoding =
    .value = Kodiranje besedila:
general-meta-name =
    .label = Ime
general-meta-content =
    .label = Vsebina

media-tab =
    .label = Večpredstavnost
    .accesskey = V
media-location =
    .value = Naslov:
media-text =
    .value = Povezano besedilo:
media-alt-header =
    .label = Nadomestno besedilo
media-address =
    .label = Naslov
media-type =
    .label = Vrsta
media-size =
    .label = Velikost
media-count =
    .label = Število
media-dimension =
    .value = Mere:
media-long-desc =
    .value = Dolg opis:
media-save-as =
    .label = Shrani kot ...
    .accesskey = h
media-save-image-as =
    .label = Shrani kot ...
    .accesskey = r

perm-tab =
    .label = Dovoljenja
    .accesskey = D
permissions-for =
    .value = Dovoljenja za:

security-tab =
    .label = Varnost
    .accesskey = A
security-view =
    .label = Preglej digitalno potrdilo
    .accesskey = P
security-view-unknown = Neznano
    .value = Neznano
security-view-identity =
    .value = Identiteta spletne strani
security-view-identity-owner =
    .value = Lastnik:
security-view-identity-domain =
    .value = Spletna stran:
security-view-identity-verifier =
    .value = Preveril:
security-view-identity-validity =
    .value = Poteče:
security-view-privacy =
    .value = Zasebnost in zgodovina

security-view-privacy-history-value = Ali sem to stran obiskal že kdaj pred današnjim dnem?
security-view-privacy-sitedata-value = Ali ta spletna stran shranjuje podatke na moj računalnik?

security-view-privacy-clearsitedata =
    .label = Počisti piškotke in podatke strani
    .accesskey = č

security-view-privacy-passwords-value = Ali sem shranil kakšno geslo za to stran?

security-view-privacy-viewpasswords =
    .label = Preglej shranjena gesla
    .accesskey = g
security-view-technical =
    .value = Tehnične podrobnosti

help-button =
    .label = Pomoč

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Da, piškotke in { $value } { $unit } podatkov strani
security-site-data-only = Da, { $value } { $unit } podatkov strani

security-site-data-cookies-only = Da, piškotke
security-site-data-no = Ne

image-size-unknown = Neznano
page-info-not-specified =
    .value = Ni določeno
not-set-alternative-text = Ni določeno
not-set-date = Ni določeno
media-img = Slika
media-bg-img = Ozadje
media-border-img = Okvir
media-list-img = Oznaka
media-cursor = Kazalec
media-object = Predmet
media-embed = Znotraj strani
media-link = Ikona
media-input = Vnos
media-video = Video
media-audio = Zvok
saved-passwords-yes = Da
saved-passwords-no = Ne

no-page-title =
    .value = Neimenovana stran:
general-quirks-mode =
    .value = Način prilagoditve
general-strict-mode =
    .value = Način v skladu s standardi
page-info-security-no-owner =
    .value = Ta spletna stran ne vsebuje podatkov o lastništvu.
media-select-folder = Izberite mapo za shranjevanje slik
media-unknown-not-cached =
    .value = Neznano (ni predpomnjeno)
permissions-use-default =
    .label = Uporabi privzeto
security-no-visits = Ne

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta ({ $tags } oznaka)
            [two] Meta ({ $tags } oznaki)
            [few] Meta ({ $tags } oznake)
           *[other] Meta ({ $tags } oznak)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne
        [one] Da, enkrat
        [two] Da, { $visits }-krat
        [few] Da, { $visits }-krat
       *[other] Da, { $visits }-krat
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
            [two] { $kb } KB ({ $bytes } bajta)
            [few] { $kb } KB ({ $bytes } bajte)
           *[other] { $kb } KB ({ $bytes } bajtov)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Slika { $type } (animacija, { $frames } sličica)
            [two] Slika { $type } (animacija, { $frames } sličici)
            [few] Slika { $type } (animacija, { $frames } sličice)
           *[other] Slika { $type } (animacija, { $frames } sličic)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } slika

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (pomanjšano na { $scaledx }px × { $scaledy }px)

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
    .label = Prepovej slike s strani { $website }
    .accesskey = P

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Podatki o strani – { $website }
page-info-frame =
    .title = Podatki o okvirju: { $website }
