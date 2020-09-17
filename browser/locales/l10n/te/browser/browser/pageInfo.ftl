# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = కాపీ చేయి
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = అన్నిటినీ ఎంచుకో
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = సాధారణం
    .accesskey = G
general-title =
    .value = శీర్షిక:
general-url =
    .value = చిరునామా:
general-type =
    .value = రకం:
general-mode =
    .value = రెండర్ రీతి:
general-size =
    .value = పరిమాణం:
general-referrer =
    .value = సంప్రదించుచున్న URL:
general-modified =
    .value = సవరించిన:
general-encoding =
    .value = పాఠ్యపు ఎన్‌కోడింగు:
general-meta-name =
    .label = పేరు
general-meta-content =
    .label = విషయసంగ్రహం

media-tab =
    .label = మాధ్యమం
    .accesskey = M
media-location =
    .value = స్థానము:
media-text =
    .value = అనుభందిత పాఠ్యము:
media-alt-header =
    .label = పరిసంభంద పాఠ్యము
media-address =
    .label = చిరునామా
media-type =
    .label = రకం
media-size =
    .label = పరిమాణం
media-count =
    .label = లెక్క
media-dimension =
    .value = కొలతలు:
media-long-desc =
    .value = పొడవైన వివరణ:
media-save-as =
    .label = భద్రపరుచు రీతి…
    .accesskey = A
media-save-image-as =
    .label = భద్రపరుచు రీతి…
    .accesskey = e

perm-tab =
    .label = అనుమతులు
    .accesskey = P
permissions-for =
    .value = దీనికొరకు అనుమతులు:

security-tab =
    .label = రక్షణ
    .accesskey = S
security-view =
    .label = ధృవత్రాన్ని చూడండి
    .accesskey = V
security-view-unknown = తెలియని
    .value = తెలియని
security-view-identity =
    .value = వెబ్‌ సైటు గుర్తింపు
security-view-identity-owner =
    .value = యజమాని:
security-view-identity-domain =
    .value = వెబ్ సైటు:
security-view-identity-verifier =
    .value = దీనిద్వారా నిర్ధారించబడింది:
security-view-identity-validity =
    .value = ఇంతలో గడువుతీరును:
security-view-privacy =
    .value = అంతరంగికత & చరిత్ర

security-view-privacy-history-value = ఈ రోజుకు ముందు నేను ఈ వెబ్ సైటును దర్శించానా?
security-view-privacy-sitedata-value = ఈ వెబ్‌సైటు సమాచారాన్ని నా కంప్యూటరులో నిల్వవుంచుతోందా?

security-view-privacy-clearsitedata =
    .label = కుకీలను, సైటు దత్తాంశాన్నీ తుడిచివేయి
    .accesskey = C

security-view-privacy-passwords-value = ఈ సైటు కోసం నేను ఏమైనా సంకేతపదాలను భద్రపరిచానా?

security-view-privacy-viewpasswords =
    .label = భద్రపరచిన సంకేతపదాలను చూడండి
    .accesskey = w
security-view-technical =
    .value = సాంకేతిక వివరాలు

help-button =
    .label = సహాయం

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = అవును, కుకీలు, { $value } { $unit }ల సైటు డేటా
security-site-data-only = అవును, { $value } { $unit } సైటు దత్తాంశం

security-site-data-cookies-only = అవును, కుకీలు
security-site-data-no = కాదు

image-size-unknown = తెలియని
page-info-not-specified =
    .value = తెలుపబడని
not-set-alternative-text = తెలుపబడని
not-set-date = తెలుపబడని
media-img = చిత్రము
media-bg-img = బ్యాక్‌గ్రౌండు
media-border-img = హద్దు
media-list-img = బుల్లెట్
media-cursor = కర్సర్
media-object = ఆబ్జక్టు
media-embed = పొందుపరచు
media-link = చిహ్నం
media-input = ఇన్‍పుట్
media-video = వీడియో
media-audio = ఆడియో
saved-passwords-yes = అవును
saved-passwords-no = కాదు

no-page-title =
    .value = శీర్షికలేని పేజీ:
general-quirks-mode =
    .value = క్విర్క్సు రీతి
general-strict-mode =
    .value = ప్రమాణాల అనుసరణ రీతి
page-info-security-no-owner =
    .value = ఈ వెబ్ సైటు యజమాని విషయం తెలుపుటలేదు.
media-select-folder = చిత్రములను భద్రపరచుటకు సంచయమును ఎంపికచేసుకొనుము
media-unknown-not-cached =
    .value = తెలియని (క్యాషేకాని)
permissions-use-default =
    .label = అప్రమేయాన్ని వాడు
security-no-visits = కాదు

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] మెటా (1 ట్యాగు)
           *[other] మెటా ({ $tags } ట్యాగులు)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] లేదు
        [one] అవును, ఒకసారి
       *[other] అవును, { $visits }సార్లు
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } బైటు)
           *[other] { $kb } KB ({ $bytes } బైట్లు)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } చిత్రము

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px కు స్కేల్‌చేయబడింది)

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
    .label = { $website } నుండి  చిత్రములను నిరోధించు
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = పేజీ సమాచారం - { $website }
page-info-frame =
    .title = ఫ్రేమ్ సమాచారం - { $website }
