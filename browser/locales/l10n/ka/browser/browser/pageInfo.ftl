# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 750px; min-height: 600px;

copy =
    .key = C
menu-copy =
    .label = ასლი
    .accesskey = ლ

select-all =
    .key = A
menu-select-all =
    .label = ყველაფრის მონიშვნა
    .accesskey = ყ

close-dialog =
    .key = w

general-tab =
    .label = ზოგადი
    .accesskey = ზ
general-title =
    .value = სათაური:
general-url =
    .value = მისამართი:
general-type =
    .value = სახეობა:
general-mode =
    .value = ასახვის რეჟიმი:
general-size =
    .value = მოცულობა:
general-referrer =
    .value = დამოწმების URL:
general-modified =
    .value = ბოლო ცვლილება:
general-encoding =
    .value = კოდირება:
general-meta-name =
    .label = სახელი
general-meta-content =
    .label = შიგთავსი

media-tab =
    .label = ფაილები
    .accesskey = ფ
media-location =
    .value = მდებარეობა:
media-text =
    .value = დართული ტექსტი:
media-alt-header =
    .label = ალტერნატული ტექსტი
media-address =
    .label = მისამართი
media-type =
    .label = სახეობა
media-size =
    .label = მოცულობა
media-count =
    .label = რაოდენობა
media-dimension =
    .value = ზომები:
media-long-desc =
    .value = ვრცელი აღწერა:
media-save-as =
    .label = შენახვა როგორც…
    .accesskey = რ
media-save-image-as =
    .label = შენახვა როგორც…
    .accesskey = ე

perm-tab =
    .label = ნებართვები
    .accesskey = ნ
permissions-for =
    .value = ნებართვები საიტისთვის:

security-tab =
    .label = უსაფრთხოება
    .accesskey = უ
security-view =
    .label = სერტიფიკატის ნახვა
    .accesskey = ნ
security-view-unknown = უცნობია
    .value = უცნობია
security-view-identity =
    .value = საიტის ნამდვილობა
security-view-identity-owner =
    .value = მფლობელი:
security-view-identity-domain =
    .value = საიტი:
security-view-identity-verifier =
    .value = დამმოწმებელი:
security-view-identity-validity =
    .value = ვადის გასვლის დრო:
security-view-privacy =
    .value = პირადულობა და ისტორია

security-view-privacy-history-value = ამ საიტზე აქამდე ნამყოფი ვარ?
security-view-privacy-sitedata-value = ინახავს ეს საიტი ჩემს კომპიუტერში ინფორმაციას?

security-view-privacy-clearsitedata =
    .label = ფუნთუშებისა და საიტის მონაცემების გასუფთავება
    .accesskey = გ

security-view-privacy-passwords-value = ამ საიტისთვის პაროლები შენახული მაქვს?

security-view-privacy-viewpasswords =
    .label = შენახული პაროლების ნახვა
    .accesskey = პ
security-view-technical =
    .value = ტექნიკური მონაცემები

help-button =
    .label = დახმარება

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = დიახ, ფუნთუშებსა და { $value } { $unit } მოცულობის მონაცემებს
security-site-data-only = დიახ, { $value }{ $unit } საიტის მონაცემებს

security-site-data-cookies-only = დიახ, ფუნთუშებს
security-site-data-no = არა

image-size-unknown = უცნობი
page-info-not-specified =
    .value = მითითებული არ არის
not-set-alternative-text = მითითებული არ არის
not-set-date = მითითებული არ არის
media-img = გამოსახულება
media-bg-img = ფონი
media-border-img = არშია
media-list-img = ტყვია
media-cursor = კურსორი
media-object = ობიექტი
media-embed = ჩაკერება
media-link = ხატულა
media-input = მიღება
media-video = ვიდეო
media-audio = აუდიო
saved-passwords-yes = დიახ
saved-passwords-no = არა

no-page-title =
    .value = უსახელო გვერდი
general-quirks-mode =
    .value = მოძველებული სტანდარტის
general-strict-mode =
    .value = სტანდარტების შესაბამისი
page-info-security-no-owner =
    .value = ვებსაიტი მფლობელის შესახებ ინფორმაციას არ იძლევა.
media-select-folder = აირჩიეთ საქაღალდე სურათის შესანახად
media-unknown-not-cached =
    .value = უცნობია (არაბუფერირებულია)
permissions-use-default =
    .label = ნაგულისხმევის მითითება
security-no-visits = არა

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] მონაცემები (1 ჭდე)
           *[other] მონაცემები ({ $tags } ჭდე)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] არა
        [one] დიახ, ერთხელ
       *[other] დიახ, { $visits }-ჯერ
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } კბ ({ $bytes } ბაიტი)
           *[other] { $kb } კბ ({ $bytes } ბაიტი)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } გამოსახულება (მოძრავი, { $frames } კადრი)
           *[other] { $type } გამოსახულება (მოძრავი, { $frames } კადრი)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } გამოსახულება

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (დაყვანილი { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } კბ

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = სურათების შეზღუდვა საიტზე { $website }
    .accesskey = ბ

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = გვერდის მონაცემები – { $website }
page-info-frame =
    .title = ჩარჩოს მონაცემები – { $website }
