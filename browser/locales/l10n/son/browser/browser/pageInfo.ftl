# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Berandi
    .accesskey = B

select-all =
    .key = A
menu-select-all =
    .label = Kul suuba
    .accesskey = K

general-tab =
    .label = Kulhaya
    .accesskey = G
general-title =
    .value = Maa:
general-url =
    .value = URL aderesu:
general-type =
    .value = Dumi:
general-mode =
    .value = Williyan alhaali:
general-size =
    .value = Adadu:
general-referrer =
    .value = Fellandi URL:
general-modified =
    .value = Barmayante:
general-encoding =
    .value = Hantum harfu-hawyan:
general-meta-name =
    .label = Maa
general-meta-content =
    .label = Gundekuna

media-tab =
    .label = Alhabar goyjinay
    .accesskey = M
media-location =
    .value = Gorodoo:
media-text =
    .value = Kalimaɲaa kuru kondante:
media-alt-header =
    .label = Kalimaɲaa kuru bere-berante:
media-address =
    .label = Aderesu
media-type =
    .label = Dumi
media-size =
    .label = Adadu
media-count =
    .label = Hinna
media-dimension =
    .value = Alkadarey:
media-long-desc =
    .value = Šilbayyan kuku:
media-save-as =
    .label = Gaabu sanda…
    .accesskey = A
media-save-image-as =
    .label = Gaabu sanda…
    .accesskey = e

perm-tab =
    .label = Duɲeyaney
    .accesskey = P
permissions-for =
    .value = Duɲeyan woo se:

security-tab =
    .label = Saajaw
    .accesskey = S
security-view =
    .label = Tabatiyan-tiira guna
    .accesskey = V
security-view-unknown = Šibayante
    .value = Šibayante
security-view-identity =
    .value = Interneti nungu boŋtammaasa
security-view-identity-owner =
    .value = Koy:
security-view-identity-domain =
    .value = Interneti nungu:
security-view-identity-verifier =
    .value = Kaŋ woo n'a koroši:
security-view-privacy =
    .value = Sutura nda taariki

security-view-privacy-history-value = Wala yan ka bay ka Interneti nungoo woo naaru ka bisa?

security-view-privacy-passwords-value = Ya n' ka šennikufal kulyaŋ gaabu Interneti nungoo woo se?

security-view-privacy-viewpasswords =
    .label = Šennikufal gaabuntey guna
    .accesskey = w
security-view-technical =
    .value = Goywaanay šilbayhayey

help-button =
    .label = Faaba

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

image-size-unknown = Šibayante
page-info-not-specified =
    .value = Ši tabatante
not-set-alternative-text = Ši tabatante
not-set-date = Ši tabatante
media-img = Bii
media-bg-img = Bandafaari
media-border-img = Hirri
media-list-img = Tonbi warga
media-cursor = Moo dirandikaw
media-object = Haya
media-embed = Dam gam
media-link = Bii
media-input = Damhaya
media-video = Widewo
media-audio = Jinde
saved-passwords-yes = Ayyo
saved-passwords-no = Kalaa

no-page-title =
    .value = Moo bila nda maa:
general-quirks-mode =
    .value = Jijiriyan alhaali
general-strict-mode =
    .value = Dumi tabatante alhaaley
page-info-security-no-owner =
    .value = Interneti nungoo woo ši mayray alhabar noo.
media-select-folder = Foolo suuba ka biyey gaabu
media-unknown-not-cached =
    .value = Šibayante (manti tugante)
permissions-use-default =
    .label = Tilasu goyandi
security-no-visits = Kalaa

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } bii

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (zimamandi { $scaledx }px × { $scaledy }px ga)

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
    .label = Biyey gagay { $website } ga
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Moo alhabar - { $website }
page-info-frame =
    .title = Kunga alhabar - { $website }
