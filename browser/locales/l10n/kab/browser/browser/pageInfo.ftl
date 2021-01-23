# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Nɣel
    .accesskey = N

select-all =
    .key = A
menu-select-all =
    .label = Ffren Akk
    .accesskey = F

close-dialog =
    .key = w

general-tab =
    .label = Amatu
    .accesskey = G
general-title =
    .value = Azwel:
general-url =
    .value = Tansa:
general-type =
    .value = Tawsit:
general-mode =
    .value = Askar n tririt:
general-size =
    .value = Teɣzi:
general-referrer =
    .value = URL n uɣbalu:
general-modified =
    .value = Ittusnifel:
general-encoding =
    .value = Asettengel n uḍris:
general-meta-name =
    .label = Isem
general-meta-content =
    .label = Agbur

media-tab =
    .label = Allalen n teywalt
    .accesskey = M
media-location =
    .value = Adeg:
media-text =
    .value = Aḍris iccuden:
media-alt-header =
    .label = Aḍris amlellay
media-address =
    .label = Tansa
media-type =
    .label = Tawsit
media-size =
    .label = Teɣzi
media-count =
    .label = Amḍan
media-dimension =
    .value = tisektiwin
media-long-desc =
    .value = Aglam ɣezzifen:
media-save-as =
    .label = Sekles s yisem…
    .accesskey = S
media-save-image-as =
    .label = Sekles s yisem…
    .accesskey = y

perm-tab =
    .label = Tisirag
    .accesskey = P
permissions-for =
    .value = Tisirag i:

security-tab =
    .label = Taɣellist
    .accesskey = S
security-view =
    .label = Sken aselkin
    .accesskey = k
security-view-unknown = Arussin
    .value = Arussin
security-view-identity =
    .value = Tamagit n usmel web
security-view-identity-owner =
    .value = Bab:
security-view-identity-domain =
    .value = Asmel web:
security-view-identity-verifier =
    .value = Isenqed-it:
security-view-identity-validity =
    .value = Ad yemmet di:
security-view-privacy =
    .value = Tudert tusligt d umezgar

security-view-privacy-history-value = Rziɣ yakan ɣer usmel-a web?
security-view-privacy-sitedata-value = Asmel-agi yesseklas talɣut ɣef uselkim-iw?

security-view-privacy-clearsitedata =
    .label = Sfeḍ inagan n tuqna akked isefka n usmel
    .accesskey = C

security-view-privacy-passwords-value = Skelseɣ awal uffir i usmel-a web?

security-view-privacy-viewpasswords =
    .label = Wali awalen uffiren yettwakelsen
    .accesskey = w
security-view-technical =
    .value = Talqayt tatiknikt

help-button =
    .label = Tallelt

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ih, inagan n tuqna akked{ $value } { $unit } seg isefka n usmel
security-site-data-only = Ih, { $value } { $unit } seg isefka n usmel

security-site-data-cookies-only = Ih, inagan n tuqna
security-site-data-no = Ala

image-size-unknown = Arussin
page-info-not-specified =
    .value = Ur d-ittumudd ara
not-set-alternative-text = Ur d-ittumudd ara
not-set-date = Ur d-ittumudd ara
media-img = Tugna
media-bg-img = Agilal
media-border-img = Tama
media-list-img = Tabdart n ikurdan
media-cursor = Taḥnaccaṭ
media-object = Taɣawsa
media-embed = Yuli
media-link = Tignit
media-input = Anekcum
media-video = Tamwalit
media-audio = Ameslaw
saved-passwords-yes = Ih
saved-passwords-no = Ala

no-page-title =
    .value = Asebter war azwel:
general-quirks-mode =
    .value = Askar n tsiḍent (quirks)
general-strict-mode =
    .value = Askar n uqadeṛ n ilugan
page-info-security-no-owner =
    .value = Asmel-a web ur d-yettmuddu ara talɣut ɣef bab-is.
media-select-folder = Fren akaram i usekles n tugniwin
media-unknown-not-cached =
    .value = Arussin (ulac-it deg tuffra)
permissions-use-default =
    .label = Tisirag n tazwara
security-no-visits = Ala

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Aɣef aferdis (1 n tṛekkizt)
           *[other] Iɣef iferdisen ({ $tags } n tṛekkizt)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ala
        [one] Ih, tikkelt kan
       *[other] Ih, { $visits } n tikkal
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KAṬ ( { $bytes } Atamḍan)
           *[other] { $kb } KAṬ ( { $bytes } Itamḍanen)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Tugna { $type } (tettḥerrik, { $frames } askar)
           *[other] Tugna { $type } (tettḥerrik, { $frames } iskaren)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Tugna { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (yuli ɣer { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px x { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KAṬ

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Sewḥel tugniwin i d-yekkan seg { $website }
    .accesskey = u

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Talɣut ɣef usebter -{ $website }
page-info-frame =
    .title = Talɣut ɣef ukatar - { $website }
