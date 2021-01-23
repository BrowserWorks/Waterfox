# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopier
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Merk alt
    .accesskey = M

close-dialog =
    .key = w

general-tab =
    .label = Generelt
    .accesskey = G
general-title =
    .value = Tittel:
general-url =
    .value = Adresse:
general-type =
    .value = Type:
general-mode =
    .value = Gjengivelsesmodus:
general-size =
    .value = Størrelse:
general-referrer =
    .value = Refererende URL:
general-modified =
    .value = Sist endret:
general-encoding =
    .value = Tekstkoding:
general-meta-name =
    .label = Navn
general-meta-content =
    .label = Innhold

media-tab =
    .label = Medier
    .accesskey = M
media-location =
    .value = Adresse:
media-text =
    .value = Assosiert tekst:
media-alt-header =
    .label = Alternativ tekst
media-address =
    .label = Adresse
media-type =
    .label = Type
media-size =
    .label = Størrelse
media-count =
    .label = Antall
media-dimension =
    .value = Dimensjoner:
media-long-desc =
    .value = Lang beskrivelse:
media-save-as =
    .label = Lagre som …
    .accesskey = s
media-save-image-as =
    .label = Lagre som …
    .accesskey = e

perm-tab =
    .label = Tillatelser
    .accesskey = T
permissions-for =
    .value = Tillatelser for:

security-tab =
    .label = Sikkerhet
    .accesskey = S
security-view =
    .label = Vis sertifikat
    .accesskey = V
security-view-unknown = Ukjent
    .value = Ukjent
security-view-identity =
    .value = Nettstedsidentitet
security-view-identity-owner =
    .value = Eier:
security-view-identity-domain =
    .value = Nettsted:
security-view-identity-verifier =
    .value = Verifisert av:
security-view-identity-validity =
    .value = Utløper:
security-view-privacy =
    .value = Personvern og historikk

security-view-privacy-history-value = Har jeg besøkt dette nettstedet tidligere?
security-view-privacy-sitedata-value = Lagrer dette nettstedet informasjon på datamaskinen min?

security-view-privacy-clearsitedata =
    .label = Fjern infokapsler og nettstedsdata
    .accesskey = k

security-view-privacy-passwords-value = Har jeg lagret passord for dette nettstedet?

security-view-privacy-viewpasswords =
    .label = Vis lagrede passord
    .accesskey = s
security-view-technical =
    .value = Tekniske detaljer

help-button =
    .label = Hjelp

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ja, infokapsler og { $value } { $unit } nettstedsdata
security-site-data-only = Ja, { $value } { $unit } nettstedsdata

security-site-data-cookies-only = Ja, infokapsler
security-site-data-no = Nei

image-size-unknown = Ukjent
page-info-not-specified =
    .value = Ikke angitt
not-set-alternative-text = Ikke angitt
not-set-date = Ikke angitt
media-img = Bilde
media-bg-img = Bakgrunn
media-border-img = Kantlinje
media-list-img = Punktlistebilde
media-cursor = Pekerbilde
media-object = Objekt
media-embed = Innbundet
media-link = Ikon
media-input = Inputt
media-video = Video
media-audio = Lyd
saved-passwords-yes = Ja
saved-passwords-no = Nei

no-page-title =
    .value = Uten tittel:
general-quirks-mode =
    .value = Særmodus
general-strict-mode =
    .value = Standardmodus
page-info-security-no-owner =
    .value = Dette nettstedet oppgir ikke info om eieren.
media-select-folder = Velg en mappe for å lagre bildene
media-unknown-not-cached =
    .value = Ukjent (ikke i hurtiglager)
permissions-use-default =
    .label = Bruk standard
security-no-visits = Nei

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tagg)
           *[other] Meta ({ $tags } tagger)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nei
        [one] Ja, én gang
       *[other] Ja, { $visits } ganger
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
            [one] { $type } bilde (animert, { $frames } ramme)
           *[other] { $type } bilde (animert, { $frames } rammer)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type }-bilde

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } px × { $dimy } px (skalert til { $scaledx } px × { $scaledy } px)

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
    .label = Blokker bilder fra { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Sideinformasjon - { $website }
page-info-frame =
    .title = Rammeinformasjon - { $website }
