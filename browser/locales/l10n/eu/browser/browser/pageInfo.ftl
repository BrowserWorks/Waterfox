# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopiatu
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Hautatu dena
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Orokorra
    .accesskey = O
general-title =
    .value = Izenburua:
general-url =
    .value = Helbidea:
general-type =
    .value = Mota:
general-mode =
    .value = Errendatzeko modua:
general-size =
    .value = Tamaina:
general-referrer =
    .value = URL igorlea:
general-modified =
    .value = Aldatuta:
general-encoding =
    .value = Testuaren kodeketa:
general-meta-name =
    .label = Izena
general-meta-content =
    .label = Edukia

media-tab =
    .label = Multimedia
    .accesskey = M
media-location =
    .value = Helbidea:
media-text =
    .value = Lotutako testua:
media-alt-header =
    .label = Testu alternatiboa
media-address =
    .label = Helbidea
media-type =
    .label = Mota
media-size =
    .label = Tamaina
media-count =
    .label = Kopurua
media-dimension =
    .value = Neurriak:
media-long-desc =
    .value = Deskribapen luzea:
media-save-as =
    .label = Gorde honela…
    .accesskey = A
media-save-image-as =
    .label = Gorde honela…
    .accesskey = e

perm-tab =
    .label = Baimenak
    .accesskey = B
permissions-for =
    .value = Honen baimenak:

security-tab =
    .label = Segurtasuna
    .accesskey = S
security-view =
    .label = Ikusi ziurtagiria
    .accesskey = I
security-view-unknown = Ezezaguna
    .value = Ezezaguna
security-view-identity =
    .value = Webgunearen nortasuna
security-view-identity-owner =
    .value = Jabea:
security-view-identity-domain =
    .value = Webgunea:
security-view-identity-verifier =
    .value = Egiaztatzailea:
security-view-identity-validity =
    .value = Iraungitze-data:
security-view-privacy =
    .value = Pribatutasuna eta historia

security-view-privacy-history-value = Webgune hau lehenago bisitatu dut?
security-view-privacy-sitedata-value = Webgune hau informazioa gordetzen ari da nire ordenagailuan?

security-view-privacy-clearsitedata =
    .label = Garbitu cookieak eta guneetako datuak
    .accesskey = G

security-view-privacy-passwords-value = Webgune honetarako pasahitzik gorde dut?

security-view-privacy-viewpasswords =
    .label = Ikusi pasahitzak
    .accesskey = I
security-view-technical =
    .value = Xehetasun teknikoak

help-button =
    .label = Laguntza

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Bai, cookieak eta gunearen datuetako { $value } { $unit }
security-site-data-only = Bai, gunearen datuetako { $value } { $unit }

security-site-data-cookies-only = Bai, cookieak
security-site-data-no = Ez

image-size-unknown = Ezezaguna
page-info-not-specified =
    .value = Zehaztu gabea
not-set-alternative-text = Zehaztu gabea
not-set-date = Zehaztu gabea
media-img = Irudia
media-bg-img = Atzeko planoa
media-border-img = Ertza
media-list-img = Buleta
media-cursor = Kurtsorea
media-object = Objektua
media-embed = Kapsulatua
media-link = Ikonoa
media-input = Sarrera
media-video = Bideoa
media-audio = Audioa
saved-passwords-yes = Bai
saved-passwords-no = Ez

no-page-title =
    .value = Izenbururik gabeko orria
general-quirks-mode =
    .value = Bateragarritasun modua
general-strict-mode =
    .value = Estandarrak betetzeko modua
page-info-security-no-owner =
    .value = Webguneak ez du jabetzaren inguruko argibiderik hornitzen.
media-select-folder = Hautatu irudiak gordetzeko karpeta bat
media-unknown-not-cached =
    .value = Ezezaguna (ez dago cachean)
permissions-use-default =
    .label = Erabili lehenetsia
security-no-visits = Ez

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (etiketa bat)
           *[other] Meta ({ $tags } etiketa)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ez
        [one] Bai, behin
       *[other] Bai, { $visits } aldiz
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB (byte bat)
           *[other] { $kb } KB ({ $bytes } byte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } irudia (biziduna, marko bat)
           *[other] { $type } irudia (biziduna, { $frames } marko)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } irudia

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (eskalatua: { $scaledx }px × { $scaledy }px)

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
    .label = Blokeatu { $website }(e)ko irudiak
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Orriaren informazioa - { $website }
page-info-frame =
    .title = Markoaren informazioa - { $website }
