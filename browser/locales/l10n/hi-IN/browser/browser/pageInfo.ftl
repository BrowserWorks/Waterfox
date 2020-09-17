# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = नकल लें
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = सभी चुनें
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = सामान्य‌‌‌
    .accesskey = G‌
general-title =
    .value = शीर्षक:
general-url =
    .value = पता‌:
general-type =
    .value = प्रकार‌:
general-mode =
    .value = रेंडर वि‌धि:
general-size =
    .value = आका‌र:
general-referrer =
    .value = संदर्भ URL‌:
general-modified =
    .value = रूपांतरि‌त:
general-encoding =
    .value = पाठ एनको‌डिं‌ग:
general-meta-name =
    .label = नाम‌
general-meta-content =
    .label = विषयवस्तु

media-tab =
    .label = मीडिया‌
    .accesskey = M
media-location =
    .value = स्था‌न:
media-text =
    .value = संबंधित ‌पाठ:
media-alt-header =
    .label = वैकल्पिक‌ पाठ
media-address =
    .label = पता‌
media-type =
    .label = प्रका‌र
media-size =
    .label = आकार‌
media-count =
    .label = गिनती‌
media-dimension =
    .value = आया‌म:
media-long-desc =
    .value = लंबा विव‌रण:
media-save-as =
    .label = ऐसे सहेजें…
    .accesskey = A
media-save-image-as =
    .label = ऐसे सहेजें…
    .accesskey = e

perm-tab =
    .label = अनुमति‌
    .accesskey = P
permissions-for =
    .value = इसके लिए अनुमति‌:

security-tab =
    .label = सुरक्षा‌
    .accesskey = S
security-view =
    .label = प्रमाणपत्र देखें‌
    .accesskey = V
security-view-unknown = अज्ञात‌
    .value = अज्ञात‌
security-view-identity =
    .value = वेब साइट‌ सुरक्षा
security-view-identity-owner =
    .value = स्वामी‌:
security-view-identity-domain =
    .value = वेब साइट‌:
security-view-identity-verifier =
    .value = इसके द्वारा सत्यापित: ‌
security-view-identity-validity =
    .value = पर समाप्त:
security-view-privacy =
    .value = गोपनीयता व इतिहास‌

security-view-privacy-history-value = क्या मैंने यह वेब साइट आज से पहले देखा‌ है?
security-view-privacy-sitedata-value = क्या यह वेब साइट मेरे कंप्यूटर पर सूचना जमा‌ कर रही है?

security-view-privacy-clearsitedata =
    .label = कूकीज़ तथा साइट डेटा हटायें
    .accesskey = C

security-view-privacy-passwords-value = क्या‌ मैंने कोई कूटशब्द इस वेबसाइट के लिए सहेजा है?

security-view-privacy-viewpasswords =
    .label = सहेजा गया कूटशब्द‌ देखें
    .accesskey = w
security-view-technical =
    .value = तकनीकी विवरण‌

help-button =
    .label = मदद‌

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = हाँ, साइट डेटा की { $value } { $unit } और कुकीज़
security-site-data-only = हाँ, साइट डेटा का { $value } { $unit }

security-site-data-cookies-only = हाँ, कुकीज़
security-site-data-no = नहीं

image-size-unknown = अज्ञा‌त
page-info-not-specified =
    .value = निर्दिष्ट‌ नहीं
not-set-alternative-text = निर्दिष्ट‌ नहीं
not-set-date = निर्दिष्ट‌ नहीं
media-img = चित्र
media-bg-img = पृष्ठभू‌मि
media-border-img = किना‌रा
media-list-img = बुले‌ट
media-cursor = संकेत‌‌क
media-object = व‌स्तु
media-embed = अंतःस्था‌पित
media-link = प्रती‌क
media-input = इन‌पुट
media-video = वीडि‌यो
media-audio = ऑडि‌यो
saved-passwords-yes = हाँ‌
saved-passwords-no = नहीं‌

no-page-title =
    .value = बेनाम पृ‌ष्ठ:
general-quirks-mode =
    .value = क्वर्क स्थिति
general-strict-mode =
    .value = मानक संगत स्थिति
page-info-security-no-owner =
    .value = यह वेबसाइट स्वामित्व सूचना नहीं देती है.
media-select-folder = चित्रों को सहेजने के लिए फ़ोल्डर चुनें
media-unknown-not-cached =
    .value = अज्ञात (अस्थाई भंडारण नहीं)
permissions-use-default =
    .label = तयशुदा का प्रयो‌‌‌ग करें
security-no-visits = नहीं‌

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] मेटा (1 टैग)
           *[other] मेटा ({ $tags } टैग्स)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] नहीं
        [one] हाँ, एक बार
       *[other] हाँ, { $visits } बार
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
            [one] { $type } छवि (ऐनिमेटेड, { $frames } फ्रेम)
           *[other] { $type } छवि (ऐनिमेटेड, { $frames } फ्रेम)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } छवि‌

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px में मापित)

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
    .label = { $website } से छवियों को रोकें‌
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = पृष्ठ सूचना - { $website }‌
page-info-frame =
    .title = फ्रेम सूचना - { $website }‌
