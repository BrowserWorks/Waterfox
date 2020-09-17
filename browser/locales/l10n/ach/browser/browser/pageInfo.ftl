# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Lok
    .accesskey = L

select-all =
    .key = A
menu-select-all =
    .label = Yer weng
    .accesskey = w

close-dialog =
    .key = w

general-tab =
    .label = Lumuku
    .accesskey = G
general-title =
    .value = Wiye madit:
general-url =
    .value = Kanonge:
general-type =
    .value = Kit:
general-mode =
    .value = Kit me nyuto:
general-size =
    .value = Dit:
general-referrer =
    .value = URL ma tiko:
general-modified =
    .value = Kiyubu:
general-encoding =
    .value = Loko coc i kod:
general-meta-name =
    .label = Nying
general-meta-content =
    .label = Gin manonge iye

media-tab =
    .label = Adyere
    .accesskey = M
media-location =
    .value = Kabedo:
media-text =
    .value = Coc marwate:
media-alt-header =
    .label = Coc ma leyo aleya
media-address =
    .label = Kanonge
media-type =
    .label = Kit
media-size =
    .label = Dit
media-count =
    .label = Kwano
media-dimension =
    .value = Kit dite:
media-long-desc =
    .value = Lok ikome mabor:
media-save-as =
    .label = Gwok calo…
    .accesskey = A
media-save-image-as =
    .label = Gwok calo…
    .accesskey = e

perm-tab =
    .label = Rukuca
    .accesskey = P
permissions-for =
    .value = Rukuca pi:

security-tab =
    .label = Ber bedo
    .accesskey = S
security-view =
    .label = Nen karatac lok ada
    .accesskey = V
security-view-unknown = Pe ngene
    .value = Pe ngene
security-view-identity =
    .value = Gin ma moko ada pa kakube
security-view-identity-owner =
    .value = Rwode:
security-view-identity-domain =
    .value = Kakube:
security-view-identity-verifier =
    .value = Lamoko ne aye:
security-view-identity-validity =
    .value = Kare ne bitum i:
security-view-privacy =
    .value = Mung ki gin mukato

security-view-privacy-history-value = Mono alimo kakube man con mapat ki tin?
security-view-privacy-sitedata-value = Kakube man tye kakano ngec i kompiuta mamega?

security-view-privacy-clearsitedata =
    .label = Jwa Angija ki Data me kakube
    .accesskey = J

security-view-privacy-passwords-value = Mono agwoko mung me donyo pi kakube man?

security-view-privacy-viewpasswords =
    .label = Nen mung me donyo ma kigwoko
    .accesskey = w
security-view-technical =
    .value = Lok matut pi ludiro ne

help-button =
    .label = Kony

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Eyo, angija ki { $value } { $unit } me data me kakube
security-site-data-only = Eyo, { $value } { $unit } me data me kakube

security-site-data-cookies-only = Eyo, angija
security-site-data-no = Pe

image-size-unknown = Pe ngene
page-info-not-specified =
    .value = Pe kicimo
not-set-alternative-text = Pe kicimo
not-set-date = Pe kicimo
media-img = Cal
media-bg-img = Ngeye
media-border-img = Twoke
media-list-img = Ricac
media-cursor = Lacim
media-object = Jami
media-embed = Keto i kine
media-link = Cal
media-input = Ket iye
media-video = Vidio
media-audio = Dwon
saved-passwords-yes = Eyo
saved-passwords-no = Pe

no-page-title =
    .value = Pot buk mape kicoyo wiye:
general-quirks-mode =
    .value = Kit ma pe ngene
general-strict-mode =
    .value = Kit ma lubo la por
page-info-security-no-owner =
    .value = Kabedo me kube man pe poko ngec me nga ma rwode.
media-select-folder = Yer boc me gwoko cal iye
media-unknown-not-cached =
    .value = Pe ngene (pe kikano)
permissions-use-default =
    .label = Tii ki makwongo
security-no-visits = Pe

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Pe
        [one] Eyo, kicel
       *[other] Eyo, tyen { $visits }
    }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Cal

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (scaled to { $scaledx }px × { $scaledy }px)

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
    .label = Geng cal ki bot{ $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Ngec me pot buk - { $website }
page-info-frame =
    .title = Ngec me Purem - { $website }
