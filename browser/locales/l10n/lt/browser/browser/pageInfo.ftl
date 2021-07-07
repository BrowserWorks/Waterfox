# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopijuoti
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Pažymėti viską
    .accesskey = v

close-dialog =
    .key = w

general-tab =
    .label = Bendroji
    .accesskey = B
general-title =
    .value = Pavadinimas:
general-url =
    .value = URL:
general-type =
    .value = Tipas:
general-mode =
    .value = Vaizdavimo būdas:
general-size =
    .value = Dydis:
general-referrer =
    .value = Iš kur ateina:
general-modified =
    .value = Atnaujintas:
general-encoding =
    .value = Simbolių koduotė:
general-meta-name =
    .label = Vardas
general-meta-content =
    .label = Reikšmė

media-tab =
    .label = Įvairialypė terpė
    .accesskey = t
media-location =
    .value = Vieta:
media-text =
    .value = Susietas tekstas:
media-alt-header =
    .label = Alternatyvus tekstas
media-address =
    .label = Adresas
media-type =
    .label = Tipas
media-size =
    .label = Dydis
media-count =
    .label = Kiekis
media-dimension =
    .value = Matmenys:
media-long-desc =
    .value = Ilgas aprašas:
media-save-as =
    .label = Įrašyti kaip…
    .accesskey = r
media-save-image-as =
    .label = Įrašyti kaip…
    .accesskey = š

perm-tab =
    .label = Leidimai
    .accesskey = L
permissions-for =
    .value = Leidimai:

security-tab =
    .label = Saugumas
    .accesskey = S
security-view =
    .label = Rodyti liudijimą
    .accesskey = R
security-view-unknown = Nežinomas
    .value = Nežinomas
security-view-identity =
    .value = Svetainės tapatumas
security-view-identity-owner =
    .value = Savininkas:
security-view-identity-domain =
    .value = Svetainė:
security-view-identity-verifier =
    .value = Tapatumą patvirtino:
security-view-identity-validity =
    .value = Baigiasi:
security-view-privacy =
    .value = Privatumas ir žurnalas

security-view-privacy-history-value = Ar anksčiau jau lankiausi šioje svetainėje?
security-view-privacy-sitedata-value = Ar ši svetainė turi įrašiusi duomenų mano kompiuteryje?

security-view-privacy-clearsitedata =
    .label = Valyti slapukus ir svetainių duomenis
    .accesskey = V

security-view-privacy-passwords-value = Ar turiu įsimintų šios svetainės slaptažodžių?

security-view-privacy-viewpasswords =
    .label = Rodyti slaptažodžius
    .accesskey = o
security-view-technical =
    .value = Techninė informacija

help-button =
    .label = Žinynas

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Taip, slapukų ir { $value } { $unit } svetainės duomenų
security-site-data-only = Taip, { $value } { $unit } svetainės duomenų

security-site-data-cookies-only = Taip, slapukų
security-site-data-no = Ne

image-size-unknown = nežinomas
page-info-not-specified =
    .value = nenurodytas
not-set-alternative-text = nenurodytas
not-set-date = nenurodytas
media-img = paveikslas
media-bg-img = foninis paveikslas
media-border-img = rėmelio paveikslas
media-list-img = suženklintojo sąrašo ženklelis
media-cursor = žymeklis
media-object = objektas
media-embed = Intarpas
media-link = piktograma
media-input = įvestis
media-video = vaizdo įrašas
media-audio = garso įrašas
saved-passwords-yes = Taip
saved-passwords-no = Ne

no-page-title =
    .value = neįvardytas tinklalapis
general-quirks-mode =
    .value = standartų nepaisymo veiksena
general-strict-mode =
    .value = suderinamumo su standartais veiksena
page-info-security-no-owner =
    .value = Ši svetainė nepateikia informacijos apie savininkus.
media-select-folder = Parinkite aplanką, į kurį saugoti paveikslėlius
media-unknown-not-cached =
    .value = Nežinomas (nėra podėlyje)
permissions-use-default =
    .label = Naudoti numatytąją nuostatą
security-no-visits = Ne

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Metainformacija (1 gairė)
            [few] Metainformacija ({ $tags } gairės)
           *[other] Metainformacija ({ $tags } gairių)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne
        [one] Taip, kartą
        [few] Taip, { $visits } kartus
       *[other] Taip, { $visits } kartų
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } baitas)
            [few] { $kb } KB ({ $bytes } baitai)
           *[other] { $kb } KB ({ $bytes } baitų)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } paveikslas (animuotas, { $frames } kadras)
            [few] { $type } paveikslas (animuotas, { $frames } kadrai)
           *[other] { $type } paveikslas (animuotas, { $frames } kadrų)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } paveikslas

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } × { $dimy } taškai (-ų) (dydis pakeistas iki { $scaledx } × { $scaledy } taškų)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } × { $dimy } taškai (-ų)

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
    .label = Nesiųsti paveikslų iš { $website }
    .accesskey = p

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informacija apie tinklalapį – { $website }
page-info-frame =
    .title = Informacija apie kadrą – { $website }
