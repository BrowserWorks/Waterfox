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
    .label = Odaberi sve
    .accesskey = a
close-dialog =
    .key = w
general-tab =
    .label = Opće
    .accesskey = G
general-title =
    .value = Naslov:
general-url =
    .value = Adresa:
general-type =
    .value = Vrsta:
general-mode =
    .value = Način iscrtavanja:
general-size =
    .value = Veličina:
general-referrer =
    .value = Referentni URL:
general-modified =
    .value = Izmijenjeno:
general-encoding =
    .value = Kodiranje teksta:
general-meta-name =
    .label = Naziv
general-meta-content =
    .label = Sadržaj
media-tab =
    .label = Multimedija
    .accesskey = M
media-location =
    .value = Lokacija:
media-text =
    .value = Asocirani tekst:
media-alt-header =
    .label = Alternativni tekst
media-address =
    .label = Adresa
media-type =
    .label = Vrsta
media-size =
    .label = Veličina
media-count =
    .label = Zbroj
media-dimension =
    .value = Dimenzije:
media-long-desc =
    .value = Dugi opis:
media-save-as =
    .label = Spremi kao …
    .accesskey = A
media-save-image-as =
    .label = Spremi kao …
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
    .label = Pregled certifikata
    .accesskey = r
security-view-unknown = Nepoznato
    .value = Nepoznato
security-view-identity =
    .value = Identitet web stranice
security-view-identity-owner =
    .value = Vlasnik:
security-view-identity-domain =
    .value = Web stranica:
security-view-identity-verifier =
    .value = Potvrđeno od:
security-view-identity-validity =
    .value = Isteći će:
security-view-privacy =
    .value = Privatnost i povijest
security-view-privacy-history-value = Je li ova stranica posjećena prije današnjeg dana?
security-view-privacy-sitedata-value = Sprema li ova web stranica podatke na mojem računalu?
security-view-privacy-clearsitedata =
    .label = Izbriši kolačiće i podatke stranica
    .accesskey = I
security-view-privacy-passwords-value = Jesu li spremljene lozinke za ovu web stranicu?
security-view-privacy-viewpasswords =
    .label = Pregled spremljenih lozinki
    .accesskey = z
security-view-technical =
    .value = Tehnički detalji
help-button =
    .label = Pomoć

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Da, kolačiće i { $value } { $unit } podataka
security-site-data-only = Da, { $value } { $unit } podataka
security-site-data-cookies-only = Da, kolačiće
security-site-data-no = Ne
image-size-unknown = Nepoznato
page-info-not-specified =
    .value = Neodređeno
not-set-alternative-text = Neodređeno
not-set-date = Neodređeno
media-img = Slika
media-bg-img = Pozadina
media-border-img = Okvir
media-list-img = Točka isticanja
media-cursor = Pokazivač miša
media-object = Objekt
media-embed = Ugradi
media-link = Ikona
media-input = Unos
media-video = Video
media-audio = Audio
saved-passwords-yes = Da
saved-passwords-no = Ne
no-page-title =
    .value = Neimenovana stranica:
general-quirks-mode =
    .value = Režim za posebne slučajeve
general-strict-mode =
    .value = Režim sukladan standardima
page-info-security-no-owner =
    .value = Ova stranica nema informaciju o vlasništvu.
media-select-folder = Odaberi mapu za spremanje slika
media-unknown-not-cached =
    .value = Nepoznato (nije spremljeno u predmemoriju)
permissions-use-default =
    .label = Koristi standardne vrijednosti
security-no-visits = Ne
# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta oznake ({ $tags } oznaka)
            [few] Meta oznake ({ $tags } oznake)
           *[other] Meta oznake ({ $tags } oznaka)
        }
# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne
        [one] Da, { $visits } puta
        [few] Da, { $visits } puta
       *[other] Da, { $visits } puta
    }
# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajtova)
            [few] { $kb } KB ({ $bytes } bajtova)
           *[other] { $kb } KB ({ $bytes } bajtova)
        }
# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } slika (animirana, { $frames } pokretna slika)
            [few] { $type } slika (animirana, { $frames } pokretne slike)
           *[other] { $type } slika (animirana, { $frames } pokretnih slika)
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
    .value = { $dimx }px × { $dimy }px (sažeto na { $scaledx }px × { $scaledy }px)
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
    .label = Blokiranje slika s { $website }
    .accesskey = B
# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informacije o stranici - { $website }
page-info-frame =
    .title = Informacije o okviru - { $website }
