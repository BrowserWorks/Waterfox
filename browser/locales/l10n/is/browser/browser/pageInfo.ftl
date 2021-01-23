# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Afrita
    .accesskey = A

select-all =
    .key = A
menu-select-all =
    .label = Velja allt
    .accesskey = j

general-tab =
    .label = Almennt
    .accesskey = A
general-title =
    .value = Titill:
general-url =
    .value = Staðsetning:
general-type =
    .value = Tegund:
general-mode =
    .value = Teiknihamur:
general-size =
    .value = Stærð:
general-referrer =
    .value = URL bakvísun:
general-modified =
    .value = Breytt:
general-encoding =
    .value = Stafatafla:
general-meta-name =
    .label = Nafn
general-meta-content =
    .label = Innihald

media-tab =
    .label = Gögn
    .accesskey = G
media-location =
    .value = Staðsetning:
media-text =
    .value = Tengdur texti:
media-alt-header =
    .label = Aukatexti
media-address =
    .label = Staðsetning
media-type =
    .label = Tegund
media-size =
    .label = Stærð
media-count =
    .label = Fjöldi
media-dimension =
    .value = Víddir:
media-long-desc =
    .value = Löng lýsing:
media-save-as =
    .label = Vista sem…
    .accesskey = V
media-save-image-as =
    .label = Vista sem…
    .accesskey = e

perm-tab =
    .label = Heimildir
    .accesskey = H
permissions-for =
    .value = Heimildir fyrir:

security-tab =
    .label = Öryggi
    .accesskey = Ö
security-view =
    .label = Skoða skilríki
    .accesskey = S
security-view-unknown = Óþekkt
    .value = Óþekkt
security-view-identity =
    .value = Auðkenni vefsvæðis
security-view-identity-owner =
    .value = Eigandi:
security-view-identity-domain =
    .value = Vefsetur:
security-view-identity-verifier =
    .value = Staðfest af:
security-view-identity-validity =
    .value = Rennur út:
security-view-privacy =
    .value = Friðhelgi og ferill

security-view-privacy-history-value = Hef ég skoðað þetta vefsvæði áður?
security-view-privacy-sitedata-value = Er þessi vefsíða að geyma upplýsingar á tölvunni minni?

security-view-privacy-clearsitedata =
    .label = Hreinsa smákökur og gögn vefsvæðis
    .accesskey = ö

security-view-privacy-passwords-value = Hef ég vistað eitthvað lykilorð fyrir þetta vefsvæði?

security-view-privacy-viewpasswords =
    .label = Skoða vistuð lykilorð
    .accesskey = S
security-view-technical =
    .value = Tæknileg atriði

help-button =
    .label = Help

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Já, smákökur og { $value } { $unit } af gögnum vefsvæðis
security-site-data-only = Já, { $value } { $unit } af gögnum vefsvæðis

security-site-data-cookies-only = Já, smákökur
security-site-data-no = Nei

image-size-unknown = Óþekkt
page-info-not-specified =
    .value = Ekki skilgreint
not-set-alternative-text = Ekki skilgreint
not-set-date = Ekki skilgreint
media-img = Mynd
media-bg-img = Bakgrunnur
media-border-img = Jaðar
media-list-img = Áherslumerki
media-cursor = Bendill
media-object = Finna hlut
media-embed = Ívefja
media-link = Táknmynd
media-input = Inntak
media-video = Myndband
media-audio = Hljóð
saved-passwords-yes = Já
saved-passwords-no = Nei

no-page-title =
    .value = Ónefnt síða:
general-quirks-mode =
    .value = Gallahamur
general-strict-mode =
    .value = Staðalhamur
page-info-security-no-owner =
    .value = Þetta vefsvæði sendir ekki upplýsingar um eiganda.
media-select-folder = Veldu möppu til að vista myndirnar
media-unknown-not-cached =
    .value = Óþekkt (ekki í skyndiminni)
permissions-use-default =
    .label = Nota sjálfgefið
security-no-visits = Nei

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
           *[other] Meta ({ $tags } tags)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Nei
        [one] Já, einu sinni
       *[other] Já, { $visits } sinnum
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bæti)
           *[other] { $kb } KB ({ $bytes } bæti)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Mynd (animated, { $frames } frame)
           *[other] { $type } Myndir (animated, { $frames } frames)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Mynd

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (skalað í { $scaledx }px × { $scaledy }px)

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
    .label = Loka á myndir frá { $website }
    .accesskey = L

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Upplýsingar síðu - { $website }
page-info-frame =
    .title = Rammaupplýsingar - { $website }
