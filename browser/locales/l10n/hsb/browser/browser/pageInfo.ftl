# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Kopěrować
    .accesskey = K

select-all =
    .key = A
menu-select-all =
    .label = Wšě wubrać
    .accesskey = b

close-dialog =
    .key = w

general-tab =
    .label = Powšitkowne
    .accesskey = P
general-title =
    .value = Titul:
general-url =
    .value = Adresa:
general-type =
    .value = Typ:
general-mode =
    .value = Zwobraznjenski modus:
general-size =
    .value = Wulkosć:
general-referrer =
    .value = Wróćopokazowacy URL:
general-modified =
    .value = Změnjeny:
general-encoding =
    .value = Tekstowe kodowanje:
general-meta-name =
    .label = Mjeno
general-meta-content =
    .label = Wobsah

media-tab =
    .label = Medije
    .accesskey = M
media-location =
    .value = Adresa:
media-text =
    .value = Přisłušny tekst:
media-alt-header =
    .label = Alternatiwny tekst
media-address =
    .label = Adresa
media-type =
    .label = Typ
media-size =
    .label = Wulkosć
media-count =
    .label = Ličba
media-dimension =
    .value = Wotměry:
media-long-desc =
    .value = Dołhe wopisanje:
media-save-as =
    .label = Składować jako…
    .accesskey = S
media-save-image-as =
    .label = Składować jako…
    .accesskey = k

perm-tab =
    .label = Prawa
    .accesskey = P
permissions-for =
    .value = Prawa za:

security-tab =
    .label = Wěstota
    .accesskey = W
security-view =
    .label = Certifikat sej wobhladać
    .accesskey = C
security-view-unknown = Njeznaty
    .value = Njeznaty
security-view-identity =
    .value = Identita websydła
security-view-identity-owner =
    .value = Wobsedźer:
security-view-identity-domain =
    .value = Websydło:
security-view-identity-verifier =
    .value = Přepruwowany wot:
security-view-identity-validity =
    .value = Spadnje:
security-view-privacy =
    .value = Priwatnosć a historija

security-view-privacy-history-value = Sym tute websydło hižo prjedy wopytał?
security-view-privacy-sitedata-value = Składuje tute websydło informacije na mojim ličaku?

security-view-privacy-clearsitedata =
    .label = Placki a sydłowe daty zhašeć
    .accesskey = P

security-view-privacy-passwords-value = Su so hesła za tute websydło składowali?

security-view-privacy-viewpasswords =
    .label = Składowane hesła sej wobhladać
    .accesskey = h
security-view-technical =
    .value = Techniske podrobnosće

help-button =
    .label = Pomoc

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Haj, placki a { $value } { $unit } sydłowych datow
security-site-data-only = Haj, { $value } { $unit } sydłowych datow

security-site-data-cookies-only = Haj, placki
security-site-data-no = Ně

image-size-unknown = Njeznaty
page-info-not-specified =
    .value = Njepodaty
not-set-alternative-text = Njepodaty
not-set-date = Njepodaty
media-img = Wobraz
media-bg-img = Pozadk
media-border-img = Ramik
media-list-img = Naličenje
media-cursor = Kursor
media-object = Objekt
media-embed = Zapřijeć
media-link = Symbol
media-input = Zapodaće
media-video = Widejo
media-audio = Awdio
saved-passwords-yes = Haj
saved-passwords-no = Ně

no-page-title =
    .value = Strona bjez titula:
general-quirks-mode =
    .value = Modus kompatibelnosće
general-strict-mode =
    .value = Modus konformnosće ze standardami
page-info-security-no-owner =
    .value = Websydło njedodawa informacije wo wobsedźerstwje.
media-select-folder = Wubjerće rjadowak za składowanje wobrazow
media-unknown-not-cached =
    .value = Njeznaty (njepufrowany)
permissions-use-default =
    .label = Standard wužiwać
security-no-visits = Ně

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta ({ $tags } značka)
            [two] Meta ({ $tags } značce)
            [few] Meta ({ $tags } znački)
           *[other] Meta ({ $tags } značkow)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ně
        [one] Haj, { $visits } króć
        [two] Haj, { $visits } króć
        [few] Haj, { $visits } króć
       *[other] Haj, { $visits } króć
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bajt)
            [two] { $kb } KB ({ $bytes } bajtaj)
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
            [two] Wobraz { $type } (animěrowany, { $frames } wobłukaj)
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
    .value = { $dimx }px × { $dimy }px (skalowany do { $scaledx }px × { $scaledy }px)

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
    .label = Wobrazy z { $website } blokować
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Info wo stronje - { $website }
page-info-frame =
    .title = Info wo wobłuku - { $website }
