# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopěrowaś
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Wšykno wubraś
    .accesskey = b

close-dialog =
    .key = w

general-tab =
    .label = Powšykne
    .accesskey = P
general-title =
    .value = Titel:
general-url =
    .value = Adresa:
general-type =
    .value = Typ:
general-mode =
    .value = Zwobraznjeński modus:
general-size =
    .value = Wjelikosć:
general-referrer =
    .value = Slědkpokazujucy URL:
general-modified =
    .value = Změnjony:
general-encoding =
    .value = Tekstowe koděrowanje:
general-meta-name =
    .label = Mě
general-meta-content =
    .label = Wopśimjeśe

media-tab =
    .label = Medije
    .accesskey = M
media-location =
    .value = Adresa:
media-text =
    .value = Pśisłušny tekst:
media-alt-header =
    .label = Alternatiwny tekst
media-address =
    .label = Adresa
media-type =
    .label = Typ
media-size =
    .label = Wjelikosć
media-count =
    .label = Licba
media-dimension =
    .value = Wótměry:
media-long-desc =
    .value = Dłujke wopisanje:
media-save-as =
    .label = Składowaś ako…
    .accesskey = S
media-save-image-as =
    .label = Składowaś ako…
    .accesskey = k

perm-tab =
    .label = Pšawa
    .accesskey = P
permissions-for =
    .value = Pšawa za:

security-tab =
    .label = Wěstota
    .accesskey = W
security-view =
    .label = Certifikat se woglědaś
    .accesskey = C
security-view-unknown = Njeznaty
    .value = Njeznaty
security-view-identity =
    .value = Identita websedła
security-view-identity-owner =
    .value = Wobsejźaŕ:
security-view-identity-domain =
    .value = Websedło:
security-view-identity-verifier =
    .value = Pśespytany wót:
security-view-identity-validity =
    .value = Spadnjo:
security-view-privacy =
    .value = Priwatnosć a historija

security-view-privacy-history-value = Som se k toś tomu websedłoju južo do togo woglědał?
security-view-privacy-sitedata-value = Składujo toś to websedło informacije na mójo licadle?

security-view-privacy-clearsitedata =
    .label = Cookieje a sedłowe daty wulašowaś
    .accesskey = C

security-view-privacy-passwords-value = Su se gronidła za toś to websedło składowali?

security-view-privacy-viewpasswords =
    .label = Składowane gronidła se woglědaś
    .accesskey = r
security-view-technical =
    .value = Techniske drobnostki

help-button =
    .label = Pomoc

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Jo, cookieje a { $value } { $unit } sedłowych datow
security-site-data-only = Jo, { $value } { $unit } sedłowych datow

security-site-data-cookies-only = Jo, cookieje
security-site-data-no = Ně

image-size-unknown = Njeznaty
page-info-not-specified =
    .value = Njepódany
not-set-alternative-text = Njepódany
not-set-date = Njepódany
media-img = Wobraz
media-bg-img = Slězyna
media-border-img = Ramik
media-list-img = Nalicenje
media-cursor = Kursor
media-object = Objekt
media-embed = Zapśimjeś
media-link = Symbol
media-input = Zapódaśe
media-video = Wideo
media-audio = Awdio
saved-passwords-yes = Jo
saved-passwords-no = Ně

no-page-title =
    .value = Bok bźez titela:
general-quirks-mode =
    .value = Modus kompatibelnosći
general-strict-mode =
    .value = Modus konformnosći ze standardami
page-info-security-no-owner =
    .value = Websedło njepódawa informacije wó wobsejźarstwje.
media-select-folder = Wubjeŕśo zastojnik za składowanje wobrazow
media-unknown-not-cached =
    .value = Njeznaty (njepufrowany)
permissions-use-default =
    .label = Standard wužywaś
security-no-visits = Ně

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta ({ $tags } wobznamjenje)
            [two] Meta ({ $tags } wobznamjeni)
            [few] Meta ({ $tags } wobznamjenja)
           *[other] Meta ({ $tags } wobznamjenjow)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ně
        [one] Jo, { $visits } raz
        [two] Jo, { $visits } raza
        [few] Jo, { $visits } raze
       *[other] Jo, { $visits } razow
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
            [few] { $kb } KB ({ $bytes } bajty)
           *[other] { $kb } KB ({ $bytes } bajtow)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Wobraz { $type } (animěrowany, { $frames } wobłuk)
            [two] Wobraz { $type } (animěrowany, { $frames } wobłuka)
            [few] Wobraz { $type } (animěrowany, { $frames } wobłuki)
           *[other] Wobraz { $type } (animěrowany, { $frames } wobłukow)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Wobraz { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skalěrowany do { $scaledx }px × { $scaledy }px)

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
    .label = Wobraze z { $website } blokěrowaś
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Info wó boku - { $website }
page-info-frame =
    .title = Info wó wobłuku - { $website }
