# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 425px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Eilañ
    .accesskey = i

select-all =
    .key = A
menu-select-all =
    .label = Diuz pep tra
    .accesskey = a

close-dialog =
    .key = w

general-tab =
    .label = Hollek
    .accesskey = o
general-title =
    .value = Titl:
general-url =
    .value = Chomlec'h :
general-type =
    .value = Rizh :
general-mode =
    .value = Mod Neuz :
general-size =
    .value = Ment :
general-referrer =
    .value = URL bukenn :
general-modified =
    .value = Daskemmet :
general-encoding =
    .value = Bonegadur an destenn :
general-meta-name =
    .label = Anv
general-meta-content =
    .label = Endalc'had

media-tab =
    .label = Media
    .accesskey = M
media-location =
    .value = Lec'hiadur :
media-text =
    .value = Testenn kevreet :
media-alt-header =
    .label = Testenn bebeilet
media-address =
    .label = Chomlec'h
media-type =
    .label = Rizh
media-size =
    .label = Ment
media-count =
    .label = Kont
media-dimension =
    .value = Mentoù :
media-long-desc =
    .value = Deskrivadenn gemplezh :
media-save-as =
    .label = Enrollañ evel…
    .accesskey = a
media-save-image-as =
    .label = Enrollañ evel…
    .accesskey = e

perm-tab =
    .label = Aotreoù
    .accesskey = t
permissions-for =
    .value = Aotreoù evit :

security-tab =
    .label = Diogelroez
    .accesskey = g
security-view =
    .label = Gwelout an testeni
    .accesskey = t
security-view-unknown = Dianav
    .value = Dianav
security-view-identity =
    .value = Pivelezh al lec'hienn internet
security-view-identity-owner =
    .value = Perc'henn :
security-view-identity-domain =
    .value = Lec'hienn internet :
security-view-identity-verifier =
    .value = Gwiriet gant :
security-view-identity-validity =
    .value = Diamzeret e vo d'an/ar:
security-view-privacy =
    .value = Buhez prevez ha Roll istor

security-view-privacy-history-value = Ha gweladennet em befe al lec'hienn-mañ a-raok hiziv ?
security-view-privacy-sitedata-value = Daoust hag emañ al lec'hienn-mañ o kadaviñ titouroù war ma urzhiataer?

security-view-privacy-clearsitedata =
    .label = Skarzhañ an toupinoù ha roadennoù lec'hienn
    .accesskey = S

security-view-privacy-passwords-value = Ur ger-tremen am eus enrollet evit al lec'hienn-mañ ?

security-view-privacy-viewpasswords =
    .label = Gwelout ar gerioù-tremen bet enrollet
    .accesskey = g
security-view-technical =
    .value = Munudoù kalvezel

help-button =
    .label = Help

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ya, toupinoù ha  { $value }{ $unit } a roadennoù lec'hienn
security-site-data-only = Ya, { $value } { $unit } a roadennoù lec'hienn

security-site-data-cookies-only = Ya, toupinoù
security-site-data-no = Ket

image-size-unknown = Dianav
page-info-not-specified =
    .value = Anspisaet
not-set-alternative-text = Anerspizet
not-set-date = Anerspizet
media-img = Skeudenn
media-bg-img = Drekleur
media-border-img = Riblenn
media-list-img = Padellig
media-cursor = Biz
media-object = Ergorenn
media-embed = Enkorfañ
media-link = Arlun
media-input = Enank
media-video = Video
media-audio = Klevet
saved-passwords-yes = Ya
saved-passwords-no = Ket

no-page-title =
    .value = Pajennad hep titl :
general-quirks-mode =
    .value = Mod an iskisted
general-strict-mode =
    .value = Mod kenfurmded ar skouerioù
page-info-security-no-owner =
    .value = Al lec'hienn-mañ ne bourchas ket titouroù a-fet pivelezh.
media-select-folder = Diuzañ ur c'havlec'hiad evit enrollañ ar skeudennoù
media-unknown-not-cached =
    .value = Dianav (ket krubuilhet)
permissions-use-default =
    .label = Arverañ an arventennoù dre ziouer
security-no-visits = Ket

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta ({ $tags } skritellig)
            [two] Meta ({ $tags } skritellig)
            [few] Meta ({ $tags } skritellig)
            [many] Meta ({ $tags } a skritelligoù)
           *[other] Meta ({ $tags } skritellig)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ne ra ket
        [one] Ya, { $visits } wech
        [two] Ya, { $visits } wech
        [few] Ya, { $visits } gwech
        [many] Ya, { $visits } a wechoù
       *[other] Ya, { $visits } gwech
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } Ke ({ $bytes } eizhbit)
            [two] { $kb } Ke ({ $bytes } eizhbit)
            [few] { $kb } Ke ({ $bytes } eizhbit)
            [many] { $kb } Ke ({ $bytes } a eizhbitoù)
           *[other] { $kb } Ke ({ $bytes } eizhbit)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Skeudenn { $type } (blivet, { $frames } skeudenn)
            [two] Skeudenn { $type } (blivet, { $frames } skeudenn)
            [few] Skeudenn { $type } (blivet, { $frames } skeudenn)
            [many] Skeudenn { $type } (blivet, { $frames } a skeudennoù)
           *[other] Skeudenn { $type } (blivet, { $frames } skeudenn)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Skeudenn mod { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skeulaet betek { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } Ke

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Herzel ar skeudennoù eus { $website }
    .accesskey = H

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Stlennoù ar bajennad - { $website }
page-info-frame =
    .title = Stlennoù Frammad - { $website }
