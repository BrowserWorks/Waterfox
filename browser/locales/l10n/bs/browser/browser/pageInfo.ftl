# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopiraj
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Označi sve
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Opće
    .accesskey = O
general-title =
    .value = Naslov:
general-url =
    .value = Adresa:
general-type =
    .value = Tip:
general-mode =
    .value = Tip prikaza:
general-size =
    .value = Veličina:
general-referrer =
    .value = Referirajući URL:
general-modified =
    .value = Izmijenjeno:
general-encoding =
    .value = Kodna stranica teksta:
general-meta-name =
    .label = Naziv
general-meta-content =
    .label = Sadržaj

media-tab =
    .label = Mediji
    .accesskey = M
media-location =
    .value = Lokacija:
media-text =
    .value = Pridruženi tekst:
media-alt-header =
    .label = Alternativni tekst
media-address =
    .label = Adresa
media-type =
    .label = Tip
media-size =
    .label = Veličina
media-count =
    .label = Ukupno
media-dimension =
    .value = Dimenzije:
media-long-desc =
    .value = Dugi opis:
media-save-as =
    .label = Spasi kao…
    .accesskey = a
media-save-image-as =
    .label = Spasi kao…
    .accesskey = e

perm-tab =
    .label = Dozvole
    .accesskey = D
permissions-for =
    .value = Dozvole za:

security-tab =
    .label = Sigurnost
    .accesskey = S
security-view =
    .label = Prikaži certifikat
    .accesskey = V
security-view-unknown = Nepoznato
    .value = Nepoznato
security-view-identity =
    .value = Identitet web stranice
security-view-identity-owner =
    .value = Vlasnik:
security-view-identity-domain =
    .value = Web stranica:
security-view-identity-verifier =
    .value = Ovjerio:
security-view-identity-validity =
    .value = Ističe:
security-view-privacy =
    .value = Privatnost & Historija

security-view-privacy-history-value = Da li sam posjetio ovu web stranicu ranije danas?
security-view-privacy-sitedata-value = Da li ova web stranica pohranjuje podatke na moj računar?

security-view-privacy-clearsitedata =
    .label = Obriši kolačiće i podatke stranice
    .accesskey = O

security-view-privacy-passwords-value = Da li sam spasio ijednu lozinku za ovu web stranicu?

security-view-privacy-viewpasswords =
    .label = Prikaži spašene lozinke
    .accesskey = w
security-view-technical =
    .value = Tehnički detalji

help-button =
    .label = Pomoć

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Da, kolačiće o { $value } { $unit } podataka stranice
security-site-data-only = Da, { $value } { $unit } podataka stranice

security-site-data-cookies-only = Da, kolačiće
security-site-data-no = Ne

image-size-unknown = Nepoznato
page-info-not-specified =
    .value = Neodređeno
not-set-alternative-text = Neodređeno
not-set-date = Neodređeno
media-img = Slika
media-bg-img = Pozadina
media-border-img = Border
media-list-img = Bullet
media-cursor = Kursor
media-object = Objekat
media-embed = Ugrađeni objekat
media-link = Ikona
media-input = Unos
media-video = Video
media-audio = Audio
saved-passwords-yes = Da
saved-passwords-no = Ne

no-page-title =
    .value = Nenaslovljena stranica:
general-quirks-mode =
    .value = Quirks režim
general-strict-mode =
    .value = Režim poštivanja standarda
page-info-security-no-owner =
    .value = Ova web stranica ne pruža informacije o vlasništvu.
media-select-folder = Odaberite direktorij za spašavanje slika
media-unknown-not-cached =
    .value = Nepoznato (nije keširano)
permissions-use-default =
    .label = Koristi izvorno
security-no-visits = Ne

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
            [few] Meta ({ $tags } taga)
           *[many] Meta ({ $tags } tagova)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne
        [one] Da, jednom
        [few] Da, dvaput
       *[many] Da, { $visits } puta
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
            [few] { $kb } KB ({ $bytes } bajta)
           *[many] { $kb } KB ({ $bytes } bajta)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Slika (animirana, { $frames } frejm)
            [few] { $type } Slika (animirana, { $frames } frejma)
           *[many] { $type } Slika (animirana, { $frames } frejmova)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Slika

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skalirano na { $scaledx }px × { $scaledy }px)

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
    .label = Blokiraj slike od { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Podaci o stranici - { $website }
page-info-frame =
    .title = Podaci o okviru - { $website }
