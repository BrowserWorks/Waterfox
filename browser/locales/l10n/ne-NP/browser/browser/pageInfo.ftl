# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = प्रतिलिपि गर्नुहोस्
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = सबै चयन गर्नुहोस्
    .accesskey = A

general-tab =
    .label = सामान्य
    .accesskey = G
general-title =
    .value = शीर्षक:
general-url =
    .value = ठेगाना:
general-type =
    .value = प्रकार:
general-mode =
    .value = रेन्डर मोड:
general-size =
    .value = साइज:
general-referrer =
    .value = सन्दर्भसित URL:
general-modified =
    .value = परिमार्जित:
general-encoding =
    .value = टेक्स्ट इन्कोडिङ:
general-meta-name =
    .label = नाम
general-meta-content =
    .label = सामग्री

media-tab =
    .label = सञ्चार
    .accesskey = M
media-location =
    .value = स्थान:
media-text =
    .value = सम्बन्धित पाठः
media-alt-header =
    .label = वैकल्पिक पाठ
media-address =
    .label = ठेगाना
media-type =
    .label = प्रकार
media-size =
    .label = साइज
media-count =
    .label = गणना
media-dimension =
    .value = आयामहरूः
media-long-desc =
    .value = लामो वर्णन:
media-save-as =
    .label = यस रूपमा सङ्ग्रह गर्नुहोस्...
    .accesskey = A
media-save-image-as =
    .label = यस रूपमा सङ्ग्रह गर्नुहोस्...
    .accesskey = e

perm-tab =
    .label = अनुमतिहरू
    .accesskey = P
permissions-for =
    .value = यसका लागि अनुमतिहरूः

security-tab =
    .label = सुरक्षा
    .accesskey = S
security-view =
    .label = प्रमाणपत्र हेर्नुहोस्
    .accesskey = V
security-view-unknown = अज्ञात
    .value = अज्ञात
security-view-identity =
    .value = Web Site Identity
security-view-identity-owner =
    .value = मालिक:
security-view-identity-domain =
    .value = Web site:
security-view-identity-verifier =
    .value = रुजू गरिएको:
security-view-identity-validity =
    .value = म्याद समाप्त हुने:
security-view-privacy =
    .value = गोपनीयता & इतिहास

security-view-privacy-history-value = Have I visited this web site prior to today?

security-view-privacy-passwords-value = के मैले यस वेबसाइटको लागि कुनै गोप्यशब्दहरू सङ्ग्रह गरेको छु ?

security-view-privacy-viewpasswords =
    .label = संरक्षित गोप्यशब्दहरू हेर्नुहोस्
    .accesskey = w
security-view-technical =
    .value = प्राबिधिक विवरणहरू

help-button =
    .label = मद्दत

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

image-size-unknown = अज्ञात
page-info-not-specified =
    .value = निर्दिष्ट नगरिएको
not-set-alternative-text = निर्दिष्ट नगरिएको
not-set-date = निर्दिष्ट नगरिएको
media-img = तस्विर
media-bg-img = पृष्ठभूमि
media-border-img = किनारा
media-list-img = गोली चिन्ह
media-cursor = कर्सर
media-object = वस्तु
media-embed = सम्मिलित
media-link = प्रतिमा
media-input = आगत
media-video = भिडियो
media-audio = ध्वनि
saved-passwords-yes = हो
saved-passwords-no = होेइन

no-page-title =
    .value = शीर्षक नभएको पृष्ठ:
general-quirks-mode =
    .value = क्विर्क मोड
general-strict-mode =
    .value = गुणस्तर अनुवृत्ति मोड
page-info-security-no-owner =
    .value = This web site does not supply ownership information.
media-select-folder = तस्विरहरू सङ्ग्रह गर्नको लागि फोल्डर चयन गर्नुहोस
media-unknown-not-cached =
    .value = अज्ञात (क्यास नगरिएको)
permissions-use-default =
    .label = पूर्वनिर्धारित प्रयोग गर्नुहोस्
security-no-visits = होेइन

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } तस्विर

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (नाप { $scaledx }px × { $scaledy }px)

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
    .label = { $website } बाट तस्विरहरू रोक्नुहोस्
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = पृष्ठ जानकारी - { $website }
page-info-frame =
    .title = फ्रेम जानकारी - { $website }
