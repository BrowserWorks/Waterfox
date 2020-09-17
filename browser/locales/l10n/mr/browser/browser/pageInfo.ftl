# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = प्रत बनवा
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = सर्व निवडा
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = साधारण
    .accesskey = G
general-title =
    .value = शिर्षक:
general-url =
    .value = पत्ता:
general-type =
    .value = प्रकार:
general-mode =
    .value = दृश्य स्थिती :
general-size =
    .value = आकार:
general-referrer =
    .value = संदर्भित URL:
general-modified =
    .value = बदलेले:
general-encoding =
    .value = मजकूर प्रसंकेतन:
general-meta-name =
    .label = नाव
general-meta-content =
    .label = मजकुर

media-tab =
    .label = मिडीया
    .accesskey = M
media-location =
    .value = स्थान:
media-text =
    .value = संबंधित पाठ्य:
media-alt-header =
    .label = पर्यायी गद्य
media-address =
    .label = पत्ता
media-type =
    .label = प्रकार
media-size =
    .label = आकार
media-count =
    .label = मोजमाप
media-dimension =
    .value = माप:
media-long-desc =
    .value = मोठे वर्णन:
media-save-as =
    .label = असे साठवा…
    .accesskey = A
media-save-image-as =
    .label = असे साठवा…
    .accesskey = e

perm-tab =
    .label = परवानगी
    .accesskey = P
permissions-for =
    .value = करीता परवानगी:

security-tab =
    .label = सुरक्षा
    .accesskey = S
security-view =
    .label = प्रमाणपत्र पहा
    .accesskey = V
security-view-unknown = अपरिचीत
    .value = अपरिचीत
security-view-identity =
    .value = संकेत स्थळ ओळख
security-view-identity-owner =
    .value = मालक:
security-view-identity-domain =
    .value = संकेतस्थळ:
security-view-identity-verifier =
    .value = तर्फे तपासलेले:
security-view-identity-validity =
    .value = कालबाह्य होण्याची वेळ:
security-view-privacy =
    .value = गोपनीयता आणि इतिहास

security-view-privacy-history-value = आज या संकेत स्थळाला आधि भेट दिली होती का?
security-view-privacy-sitedata-value = हे संकेत स्थळ संगणकावर माहिती संचयीत करत आहे का?

security-view-privacy-clearsitedata =
    .label = कुकीज आणि साईट माहिती पुसा
    .accesskey = C

security-view-privacy-passwords-value = या संकेत स्थळास कुठलेही पासवर्ड संचयीत केले गेले आहे का?

security-view-privacy-viewpasswords =
    .label = संचयीत पासवर्ड पहा
    .accesskey = w
security-view-technical =
    .value = तांत्रिक तपशील

help-button =
    .label = मदत

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = होय, कुकीज आणि { $value } { $unit } साइट डेटा
security-site-data-only = होय, { $value } { $unit } साइट डेटा

security-site-data-cookies-only = होय, कुकिज
security-site-data-no = नाही

image-size-unknown = अपिरिचीत
page-info-not-specified =
    .value = निश्चित न केलेले
not-set-alternative-text = निश्चित न केलेले
not-set-date = निश्चित न केलेले
media-img = प्रतिमा
media-bg-img = पार्श्वभूमी
media-border-img = किनार
media-list-img = बूलेट
media-cursor = कर्सर
media-object = घटक
media-embed = अंतर्भूत
media-link = चित्रसंकेत
media-input = आदान
media-video = व्हिडिओ
media-audio = ऑडिओ
saved-passwords-yes = होय
saved-passwords-no = नाही

no-page-title =
    .value = विनाशिर्षक पृष्ठ:
general-quirks-mode =
    .value = Quirks पद्धती
general-strict-mode =
    .value = प्रमाणित पद्धती
page-info-security-no-owner =
    .value = हे संकेत स्थळ मालकीय माहिती पुरवत नाही.
media-select-folder = प्रतिमा संचयीत करण्याकरीता संचयीका निवडा
media-unknown-not-cached =
    .value = अपरिचीत (कॅश्ड नाही)
permissions-use-default =
    .label = पूर्वनिर्धारित वापरा
security-no-visits = नाही

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] मेटा (1 टॅग)
           *[other] मेटा ({ $tags } टॅग)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] नाही
        [one] होय, एकदा
       *[other] होय { $visits }वेळा
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } byte)
           *[other] { $kb } KB ({ $bytes } bytes)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } प्रतिमा (अ‍ॅनिमेटेड, { $frames } फ्रेम)
           *[other] { $type } प्रतिमा (अ‍ॅनिमेटेड, { $frames } फ्रेम)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } प्रतिमा

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px करीता सुस्थीत केले गेले)

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
    .label = { $website } पासून प्रतिमा रोखा
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = पृष्ठाविषयक माहिती - { $website }
page-info-frame =
    .title = पटलविषयक माहिती - { $website }
