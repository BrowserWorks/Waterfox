# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Natto
    .accesskey = N

select-all =
    .key = A
menu-select-all =
    .label = Labo Fof
    .accesskey = F

close-dialog =
    .key = W

general-tab =
    .label = Kuuɓal
    .accesskey = G
general-title =
    .value = Tiitoonde:
general-url =
    .value = Ñiiɓirde:
general-type =
    .value = Fannu:
general-mode =
    .value = Mbayka Yonkito:
general-size =
    .value = Ɓetol:
general-referrer =
    .value = URL Ruttorde:
general-modified =
    .value = Baylaaɗo:
general-encoding =
    .value = Dokkitannde Binndi:
general-meta-name =
    .label = Innde
general-meta-content =
    .label = Loowdi

media-tab =
    .label = Mejaaje
    .accesskey = M
media-location =
    .value = Nokkuure:
media-text =
    .value = Binndo Jahdingol:
media-alt-header =
    .label = Binndol Lomtinirgol
media-address =
    .label = Ñiiɓirde
media-type =
    .label = Fannu
media-size =
    .label = Ɓeto
media-count =
    .label = Limoore
media-dimension =
    .value = Ɓetanɗe:
media-long-desc =
    .value = Cifagol Juutngol:
media-save-as =
    .label = Danndu e Innde…
    .accesskey = A
media-save-image-as =
    .label = Danndu e Innde…
    .accesskey = e

perm-tab =
    .label = Jamirooje
    .accesskey = P
permissions-for =
    .value = Jamirooje:

security-tab =
    .label = Kisal
    .accesskey = S
security-view =
    .label = Hollu Seedamfaagu
    .accesskey = V
security-view-unknown = Anndaaka
    .value = Anndaaka
security-view-identity =
    .value = Innitol Lowre Geese
security-view-identity-owner =
    .value = Jeyɗo:
security-view-identity-domain =
    .value = Lowre geese:
security-view-identity-verifier =
    .value = Ƴeewtii ko:
security-view-identity-validity =
    .value = Gasata ko:
security-view-privacy =
    .value = Aslol & Suturo

security-view-privacy-history-value = Mi meeɗii yillaade ndee lowre ko adii hannde?
security-view-privacy-sitedata-value = Mate ndee lowre geese woni ko e mooftude kabaruuji e ordinateer maa?

security-view-privacy-clearsitedata =
    .label = Momtu Kuukiije kam e Keɓe Lowre
    .accesskey = C

security-view-privacy-passwords-value = Mi danndii finndeeji ndee lowre geese?

security-view-privacy-viewpasswords =
    .label = Hollu Finndeeji Danndaaɗi
    .accesskey = w
security-view-technical =
    .value = Cariiɗo Karallaagal

help-button =
    .label = Ballal

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Eey, kuukiije kam e { $value } { $unit } keɓe lowre ndee
security-site-data-only = Eey, { $value }{ $unit } keɓe lowre ndee

security-site-data-cookies-only = Eey, kuukiije
security-site-data-no = Alaa

image-size-unknown = Anndaaka
page-info-not-specified =
    .value = Laɓɓinaaka
not-set-alternative-text = Laɓɓinaaka
not-set-date = Laɓɓinaaka
media-img = Natal
media-bg-img = Cakkital
media-border-img = Ŋorol
media-list-img = Korwal
media-cursor = Jamngel
media-object = Piiyol
media-embed = Soomtor
media-link = Maandel
media-input = Naatnal
media-video = Widewo
media-audio = Ojoo
saved-passwords-yes = Eey
saved-passwords-no = Alaa

no-page-title =
    .value = Hello Ngo Tiitaaka:
general-quirks-mode =
    .value = Mbayka Quirks
general-strict-mode =
    .value = Mbayka ɗooftagol nanondiraaɗe
page-info-security-no-owner =
    .value = Ndee lowre geese hokkataa humpito jeyal.
media-select-folder = Labo Runngere ngam Danndude Nate ɗee
media-unknown-not-cached =
    .value = Anndaaka (kaasaaka)
permissions-use-default =
    .label = Huutoro Goowaaɗo
security-no-visits = Alaa

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Alaa
        [one] Eey, laawol gootol
       *[other] Eey, { $visits } sahaa
    }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Natal

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (werannde { $scaledx }px × { $scaledy }px)

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
    .label = Falo Nate immiiɗe e { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Humpito Hello - { $website }
page-info-frame =
    .title = Humpito Kaarewol - { $website }
