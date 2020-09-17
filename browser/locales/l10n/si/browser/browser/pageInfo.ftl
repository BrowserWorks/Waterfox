# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = පිටපත් කරන්න
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = සියල්ල තෝරන්න
    .accesskey = A

general-tab =
    .label = සාමාන්‍ය
    .accesskey = G
general-title =
    .value = මාතෘකාව:
general-url =
    .value = ලිපිනය:
general-type =
    .value = වර්‍ගය:
general-mode =
    .value = ජනන ප්‍රකාරය:
general-size =
    .value = විශාලත්වය:
general-referrer =
    .value = යොමු URL:
general-modified =
    .value = වෙනස්කළ:
general-encoding =
    .value = පෙළ සංකේතනය:
general-meta-name =
    .label = නම
general-meta-content =
    .label = අන්තර්ගතය

media-tab =
    .label = මාධ්‍ය
    .accesskey = M
media-location =
    .value = පිහිටීම:
media-text =
    .value = අදාල පෙළ:
media-alt-header =
    .label = අමතර පෙළ
media-address =
    .label = ලිපිනය
media-type =
    .label = වර්‍ගය
media-size =
    .label = විශාලත්වය
media-count =
    .label = ගණන
media-dimension =
    .value = මාන:
media-long-desc =
    .value = දිගු විස්තරය:
media-save-as =
    .label = සුරකින අයුර…
    .accesskey = A
media-save-image-as =
    .label = සුරකින අයුර…
    .accesskey = e

perm-tab =
    .label = බලතල
    .accesskey = P
permissions-for =
    .value = අවසර ලැබෙන්නේ:

security-tab =
    .label = ආරක්ෂාව
    .accesskey = S
security-view =
    .label = සහතිකය දක්වන්න
    .accesskey = V
security-view-unknown = නොදන්නා
    .value = නොදන්නා
security-view-identity =
    .value = ජාල අඩවියේ අනන්‍යතාව
security-view-identity-owner =
    .value = හිමිකරු:
security-view-identity-domain =
    .value = ජාල අඩවිය:
security-view-identity-verifier =
    .value = ස්ථිර කළේ:
security-view-identity-validity =
    .value = කල් ඉකුත් වන්නේ:
security-view-privacy =
    .value = පුද්ගලිකත්වය හා ඉතිහාසය

security-view-privacy-history-value = අද දිනට පෙර මා මෙම අඩවියට පිවිස ඇතිද?

security-view-privacy-passwords-value = මෙම අඩවිය සඳහා මවිසින් කිසිඳු මුරපදයක් සුරැක ඇතිද?

security-view-privacy-viewpasswords =
    .label = සුරැකූ රහස්පද බලන්න
    .accesskey = w
security-view-technical =
    .value = තාක්ෂණික දත්ත

help-button =
    .label = උදව්

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-no = නැත

image-size-unknown = නොදන්නා
page-info-not-specified =
    .value = විශේෂිතව දක්වා නැත
not-set-alternative-text = විශේෂිතව දක්වා නැත
not-set-date = විශේෂිතව දක්වා නැත
media-img = රූපය
media-bg-img = පසුතලය
media-border-img = දාරය
media-list-img = බුලටය
media-cursor = කර්සරය
media-object = වස්තුව
media-embed = කාවැද්දූ
media-link = අයිකනය
media-input = ප්‍රධානය
media-video = දෘශ්‍ය
media-audio = ශ්‍රව්‍ය
saved-passwords-yes = ඔව්
saved-passwords-no = නැත

no-page-title =
    .value = නිර්ණාමික පිටුව:
general-quirks-mode =
    .value = Quirks ආකාරය
general-strict-mode =
    .value = සම්මත අනුකූල ආකාරය
page-info-security-no-owner =
    .value = මෙම වෙබ් අඩවිය අයිතිය පිළිබඳ තොරතුරු සපයන්නේ නැත..
media-select-folder = රූපය සුරකීමට බහලුමක් තෝරන්න
media-unknown-not-cached =
    .value = නොදන්නා (කැච් නොවූ)
permissions-use-default =
    .label = පෙරනිමිය භාවිත කරන්න
security-no-visits = නැත

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } රූපය

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (පරිමාණය { $scaledx }px × { $scaledy }px )

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
    .label = { $website } වෙතින් රූපය අවහිර කරන්න
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = පිටු තොරතුරු - { $website }
page-info-frame =
    .title = රාමු තොරතුරු - { $website }
