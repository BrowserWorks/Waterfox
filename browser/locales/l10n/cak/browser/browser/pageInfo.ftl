# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Tiwachib'ëx
    .accesskey = c

select-all =
    .key = A
menu-select-all =
    .label = Ticha' Ronojel
    .accesskey = R

close-dialog =
    .key = w

general-tab =
    .label = Chijun
    .accesskey = C
general-title =
    .value = B'i'aj:
general-url =
    .value = Ochochib'äl:
general-type =
    .value = Ruwäch:
general-mode =
    .value = Pa'äl pa chuwäch rub'anikil:
general-size =
    .value = Nimilem:
general-referrer =
    .value = Atux JAY:
general-modified =
    .value = K'exon:
general-encoding =
    .value = Rucholajil rucholajem tzij:
general-meta-name =
    .label = B'i'aj
general-meta-content =
    .label = rupam

media-tab =
    .label = K'ïy k'oxom
    .accesskey = K
media-location =
    .value = Ochochib'al:
media-text =
    .value = Ximon chi rucholajem tzij:
media-alt-header =
    .label = Cha'el rucholajem tzij
media-address =
    .label = Ochochib'äl
media-type =
    .label = Ruwäch
media-size =
    .label = Nimilem
media-count =
    .label = Ajilab'äl
media-dimension =
    .value = Runimilem:
media-long-desc =
    .value = Nïm cholonem:
media-save-as =
    .label = Tiyak Achi'el…
    .accesskey = A
media-save-image-as =
    .label = Tiyak Achi'el…
    .accesskey = y

perm-tab =
    .label = Taq ya'oj q'ij
    .accesskey = o
permissions-for =
    .value = Taq ruya'ik q'ij richin:

security-tab =
    .label = Jikomal
    .accesskey = J
security-view =
    .label = Tatz'eta' ruwujil b'i'aj
    .accesskey = W
security-view-unknown = Man etaman ta ruwäch
    .value = Man etaman ta ruwäch
security-view-identity =
    .value = Ruk'utwachib'al ruxaq k'amaya'l
security-view-identity-owner =
    .value = Rajaw
security-view-identity-domain =
    .value = Ruxaq k'amaya'l:
security-view-identity-verifier =
    .value = Jikib'an ruma:
security-view-identity-validity =
    .value = Nik'is ruq'ijul ri:
security-view-privacy =
    .value = Ichinanem chuqa' natab'äl

security-view-privacy-history-value = ¿La nintz'ët chik re jun ruxaq k'amaya'l re'?
security-view-privacy-sitedata-value = ¿La yeruyäk na'oj pa nukematz'ib' re ajk'amaya'l ruxaq re'?

security-view-privacy-clearsitedata =
    .label = Keyuj ri taq Kaxlanwäy chuqa' Kitzij Ruxaq K'amaya'l
    .accesskey = K

security-view-privacy-passwords-value = ¿La xeyak ewan taq rutzij re ruxaq k'amaya'l re'?

security-view-privacy-viewpasswords =
    .label = Ketz'et ri yakäl ewan taq tzij
    .accesskey = w
security-view-technical =
    .value = Etamanel taq B'anikil

help-button =
    .label = Tob'äl

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ja', taq kaxlanwey chuqa' { $value } { $unit } kitzij ruxaq k'amaya'l
security-site-data-only = Ja', { $value } { $unit } kitzij ruxaq k'amaya'l

security-site-data-cookies-only = Ja', taq kaxlanwäy
security-site-data-no = Mani

image-size-unknown = Man etaman ta ruwäch
page-info-not-specified =
    .value = Man jikib'an ta
not-set-alternative-text = Man jikib'an ta
not-set-date = Man jikib'an ta
media-img = Wachib'äl
media-bg-img = Rupam
media-border-img = Ruchi'
media-list-img = Weqoj
media-cursor = Retal ch'oy
media-object = Wachinäq
media-embed = Tik'ase'
media-link = Wachib'äl
media-input = Okitz'ib'
media-video = Silowachib'äl
media-audio = K'oxomal
saved-passwords-yes = Ja'
saved-passwords-no = Mani

no-page-title =
    .value = Majun rub'i' ri ruxaq:
general-quirks-mode =
    .value = Rub'eyal  nuk'än
general-strict-mode =
    .value = K'omonel rub'anikil kik'in jikïl taq b'eyal
page-info-security-no-owner =
    .value = Re jun ruxaq k'amaya'l re' man nuya' ta rutzijol chi rij ri rajaw.
media-select-folder = Tacha' jun yakb'äl akuchi' yatikir nayäk ri taq wachb'äl
media-unknown-not-cached =
    .value = Man etaman ta ruwäch (man jumejyak ta)
permissions-use-default =
    .label = Tokisäx ri ruk'amon wi pe
security-no-visits = Mani

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
        [0] Manäq
        [one] Ja', jumul
       *[other] Ja'{ $visits } mul
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } bit)
           *[other] { $kb } KB ({ $bytes } taq bit)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Wachib'äl (silon, { $frames } frame)
           *[other] { $type } Wachib'äl (silon, { $frames } taq frame)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Wachib'äl

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (jotob'an pa { $scaledx }px × { $scaledy }px)

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
    .label = Keq'at taq ruwachib'al { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Na'oj pa ruwi' re ruxaq - { $website }
page-info-frame =
    .title = Na'oj chi rij re ruchi' re' - { $website }
