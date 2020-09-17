# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Kopjoje
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Përzgjidhe Krejt
    .accesskey = e

close-dialog =
    .key = w

general-tab =
    .label = Të përgjithshme
    .accesskey = P
general-title =
    .value = Titull:
general-url =
    .value = Adresë:
general-type =
    .value = Lloj:
general-mode =
    .value = Mënyrë Hartimi:
general-size =
    .value = Madhësi:
general-referrer =
    .value = URL referuese:
general-modified =
    .value = Ndryshuar më:
general-encoding =
    .value = Kodim Teksti:
general-meta-name =
    .label = Emër
general-meta-content =
    .label = Lëndë

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Vendndodhje:
media-text =
    .value = Tekst Shoqërues:
media-alt-header =
    .label = Tekst Alternativ
media-address =
    .label = Adresë
media-type =
    .label = Lloj
media-size =
    .label = Madhësi
media-count =
    .label = Numër
media-dimension =
    .value = Përmasa:
media-long-desc =
    .value = Përshkrim i Gjatë:
media-save-as =
    .label = Ruajeni Si…
    .accesskey = u
media-save-image-as =
    .label = Ruajeni Si…
    .accesskey = e

perm-tab =
    .label = Leje
    .accesskey = L
permissions-for =
    .value = Leje për:

security-tab =
    .label = Siguri
    .accesskey = S
security-view =
    .label = Shihini Dëshminë
    .accesskey = S
security-view-unknown = E panjohur
    .value = E panjohur
security-view-identity =
    .value = Identitet Sajti
security-view-identity-owner =
    .value = Pronar:
security-view-identity-domain =
    .value = Sajt:
security-view-identity-verifier =
    .value = Vërtetuar nga:
security-view-identity-validity =
    .value = Skadon më:
security-view-privacy =
    .value = Privatësi & Historik

security-view-privacy-history-value = E kam vizituar këtë sajt më herët se sot?
security-view-privacy-sitedata-value = A depoziton ky sajt të dhëna në kompjuterin tim?

security-view-privacy-clearsitedata =
    .label = Spastro Cookie-t dhe të Dhëna Sajti
    .accesskey = p

security-view-privacy-passwords-value = A kam ruajtur ndonjë fjalëkalim për këtë sajt?

security-view-privacy-viewpasswords =
    .label = Shihni Fjalëkalime të Ruajtur
    .accesskey = F
security-view-technical =
    .value = Hollësi Teknike

help-button =
    .label = Ndihmë

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Po, cookies dhe { $value } { $unit } të dhëna sajti
security-site-data-only = Po, { $value } { $unit } të dhëna sajti

security-site-data-cookies-only = Po, cookies
security-site-data-no = Jo

image-size-unknown = E panjohur
page-info-not-specified =
    .value = E pacaktuar
not-set-alternative-text = E pacaktuar
not-set-date = E pacaktuar
media-img = Figurë
media-bg-img = Sfond
media-border-img = Anë
media-list-img = Me pika
media-cursor = Kursor
media-object = Objekt
media-embed = Trupëzo
media-link = Ikonë
media-input = Futje
media-video = Video
media-audio = Audio
saved-passwords-yes = Po
saved-passwords-no = Jo

no-page-title =
    .value = Faqe e Patitull
general-quirks-mode =
    .value = Quirks mode
general-strict-mode =
    .value = Mënyrë përputhje me standardet
page-info-security-no-owner =
    .value = Ky sajt nuk furnizon të dhëna pronësie.
media-select-folder = Përzgjidhni një Dosje në të cilën të Ruhen Figurat
media-unknown-not-cached =
    .value = E panjohur (e paruajtur në fshehtinë)
permissions-use-default =
    .label = Përdor Parazgjedhjet
security-no-visits = Jo

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 etiketë)
           *[other] Meta ({ $tags } etiketa)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Jo
        [one] Po, njëherë
       *[other] Po, { $visits } herë
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
           *[other] { $kb } KB ({ $bytes } bajte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Figurë (e animuar, { $frames } kuadro)
           *[other] { $type } Figurë (e animuar, { $frames } kuadro)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Figurë { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (ripërmasuar në { $scaledx }px × { $scaledy }px)

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
    .label = Bllokoji Figurat nga { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Të dhëna Faqeje - { $website }
page-info-frame =
    .title = Të dhëna Kuadri - { $website }
