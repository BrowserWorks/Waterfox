# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = நகலெடு
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = அனைத்தையும் தேர்ந்தெடு
    .accesskey = A

general-tab =
    .label = பொது
    .accesskey = G
general-title =
    .value = தலைப்பு:
general-url =
    .value = முகவரி:
general-type =
    .value = வகை:
general-mode =
    .value = காட்டும் முறைமை:
general-size =
    .value = அளவு:
general-referrer =
    .value = குறிப்பிடும் URL:
general-modified =
    .value = மாற்றப்பட்டது:
general-encoding =
    .value = உரை குறியாக்கம்:
general-meta-name =
    .label = பெயர்
general-meta-content =
    .label = உள்ளடக்கம்

media-tab =
    .label = ஊடகம்
    .accesskey = M
media-location =
    .value = இடம்:
media-text =
    .value = தொடர்புடைய உரை:
media-alt-header =
    .label = மாற்று உரை
media-address =
    .label = முகவரி
media-type =
    .label = வகை
media-size =
    .label = அளவு
media-count =
    .label = எண்ணிக்கை
media-dimension =
    .value = பரிமாணங்கள்:
media-long-desc =
    .value = நீண்ட விவரம்:
media-save-as =
    .label = இப்படி சேமி…
    .accesskey = A
media-save-image-as =
    .label = இப்படி சேமி…
    .accesskey = e

perm-tab =
    .label = அனுமதிகள்
    .accesskey = P
permissions-for =
    .value = அனுமதி:

security-tab =
    .label = பாதுகாப்பு
    .accesskey = S
security-view =
    .label = சான்றிதழை பார்வையிடு
    .accesskey = V
security-view-unknown = தெரியாதது
    .value = தெரியாதது
security-view-identity =
    .value = இணைய தள அடையாளம்
security-view-identity-owner =
    .value = உரிமையாளர்:
security-view-identity-domain =
    .value = இணையத்தளம்:
security-view-identity-verifier =
    .value = சரிபார்த்தவர்:
security-view-identity-validity =
    .value = காலாவதியாகிறது:
security-view-privacy =
    .value = தனியுரிமை & வரலாறு

security-view-privacy-history-value = இன்று நான் இந்த இணையதளத்தை முன்பு பார்த்தேனா?
security-view-privacy-sitedata-value = இந்த இணைய தளம் தகவல்களை என்னுடைய கணினியில் சேமிக்கிறதா?

security-view-privacy-clearsitedata =
    .label = நினைவிகள் மற்றும் தள தரவை அழிக்கவும்
    .accesskey = C

security-view-privacy-passwords-value = இந்த இணைய தளத்தின் கடவுச்சொல்லை சேமித்துள்ளேனா?

security-view-privacy-viewpasswords =
    .label = சேமிக்கப்பட்ட கடவுச்சொற்களை பார்வையிடு
    .accesskey = w
security-view-technical =
    .value = தொழில்நுட்ப விவரங்கள்

help-button =
    .label = உதவி

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = ஆம், நினைவிகள் மற்றும் { $value } { $unit } தளத்தின் தரவு
security-site-data-only = ஆம், { $value } { $unit } தளத்தின் தரவு

security-site-data-cookies-only = ஆம், நினைவிகள்
security-site-data-no = இல்லை

image-size-unknown = தெரியாதது
page-info-not-specified =
    .value = குறிப்பிடவில்லை
not-set-alternative-text = குறிப்பிடவில்லை
not-set-date = குறிப்பிடவில்லை
media-img = படம்
media-bg-img = பின்னணி
media-border-img = எல்லையில்
media-list-img = பொட்டு
media-cursor = நிலைக்காட்டி
media-object = பொருள்
media-embed = உட்பொதியப்பட்டது
media-link = சின்னம்
media-input = உள்ளீடு
media-video = காணொளி
media-audio = கேட்பொலி
saved-passwords-yes = ஆம்
saved-passwords-no = இல்லை

no-page-title =
    .value = தலைப்பற்ற பக்கம்:
general-quirks-mode =
    .value = Quirks முறைமை
general-strict-mode =
    .value = தரப்படுத்தப்பட்ட இணக்க முறைமை
page-info-security-no-owner =
    .value = கொடுக்கவில்லை.
media-select-folder = படங்களை சேமிக்க ஒரு அடைவைத் தேர்ந்தெடு
media-unknown-not-cached =
    .value = தெரியாதது (இடையகப்படுத்தாதது)
permissions-use-default =
    .label = முன்னிருப்பைப் பயன்படுத்து
security-no-visits = இல்லை

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } படம்

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px க்கு அளவீடு செய்யப்பட்டது)

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
    .label = { $website } தளத்திலிருந்து படங்களைத் தடு
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = பக்கத் தகவல் - { $website }
page-info-frame =
    .title = சட்டகத் தகவல் - { $website }
