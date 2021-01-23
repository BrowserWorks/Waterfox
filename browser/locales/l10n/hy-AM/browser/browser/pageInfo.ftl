# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Պատճենել
    .accesskey = Պ

select-all =
    .key = A
menu-select-all =
    .label = Նշել բոլորը
    .accesskey = բ

close-dialog =
    .key = w

general-tab =
    .label = Ընդհանուր
    .accesskey = G
general-title =
    .value = Վերնագիր․
general-url =
    .value = Հասցեն.
general-type =
    .value = Տեսակը.
general-mode =
    .value = Ցուցադրման Եղանակը.
general-size =
    .value = Չափը.
general-referrer =
    .value = Հղվող URL-ն.
general-modified =
    .value = Փոփոխված է.
general-encoding =
    .value = Տեքստի կոդավորումը.
general-meta-name =
    .label = Անվանումը
general-meta-content =
    .label = Բովանդակություն

media-tab =
    .label = Մեդիա
    .accesskey = M
media-location =
    .value = Տեղը.
media-text =
    .value = Կապակցված Տեքստ`
media-alt-header =
    .label = Այլնտրանք. ՏԵքստ
media-address =
    .label = Հասցեն
media-type =
    .label = Տեսակը
media-size =
    .label = Չափը
media-count =
    .label = Քանակը
media-dimension =
    .value = Չափերը`
media-long-desc =
    .value = Երկար Նկարագրություն.
media-save-as =
    .label = Պահպանել որպես…
    .accesskey = A
media-save-image-as =
    .label = Պահպանել որպես…
    .accesskey = e

perm-tab =
    .label = Թույլտվություններ
    .accesskey = Ի
permissions-for =
    .value = Թույլտվություններ՝

security-tab =
    .label = Անվտանգություն
    .accesskey = S
security-view =
    .label = Դիտել վկայագիրը
    .accesskey = V
security-view-unknown = Անհայտ
    .value = Անհայտ
security-view-identity =
    .value = Վեբ Կայքի ինքնությունը
security-view-identity-owner =
    .value = Սեփականատեր`
security-view-identity-domain =
    .value = Վեբ Կայք`
security-view-identity-verifier =
    .value = Ստուգվել է`
security-view-identity-validity =
    .value = Սպառվում է՝
security-view-privacy =
    .value = Գաղտնիությունը և պատմությունը

security-view-privacy-history-value = Ես այցելե՞լ էմ այս կայք մինչև այսօր
security-view-privacy-sitedata-value = Այս կայքը տեղեկություններ պահու՞մ է համակարգչում:

security-view-privacy-clearsitedata =
    .label = Մաքրել Cookie-ները և կայքի տվյալները
    .accesskey = C

security-view-privacy-passwords-value = Պահպանե՞լ եմ արդյոք գաղտնաբառեր այս կայքի համար

security-view-privacy-viewpasswords =
    .label = Դիտել Հիշած Գաղտնաբառերը
    .accesskey = w
security-view-technical =
    .value = Տեխնիկական Մանրամասնություններ

help-button =
    .label = Օգնություն

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Այո, cookie-ները և կայքի տվյալները՝ { $value } { $unit }
security-site-data-only = Այո, կայքի տվյալներ՝ { $value } { $unit }

security-site-data-cookies-only = Այո, cookie-ներ
security-site-data-no = Ոչ

image-size-unknown = Անհայտ
page-info-not-specified =
    .value = Նշված չէ
not-set-alternative-text = Նշված չէ
not-set-date = Նշված չէ
media-img = Նկար
media-bg-img = Խորապատկեր
media-border-img = Եզրագիծը
media-list-img = Կետանիշերով
media-cursor = Կուրսորը
media-object = Օբյեկտ
media-embed = Ներփակված
media-link = Մանրանկար
media-input = Մուտքագրում
media-video = Տեսաֆայլ
media-audio = Աուդիո
saved-passwords-yes = Այո
saved-passwords-no = Ոչ՜

no-page-title =
    .value = Անվերնագիր էջ`
general-quirks-mode =
    .value = Համատեղելիության Եղանակ (Quirks)
general-strict-mode =
    .value = Ստանդարտներին համաձայն եղանակ
page-info-security-no-owner =
    .value = Այս վեբ կայքը չի տրամադրում իր սեփականատիրոջ ինֆորմացիան:
media-select-folder = Ընտրեք թղթապանակ՝ պատկերները պահպանելու համար
media-unknown-not-cached =
    .value = Անհայտ (չի մտապահվել)
permissions-use-default =
    .label = Օգտ. լռելյայն
security-no-visits = Ոչ՜

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Մետա (1 պիտակ)
           *[other] Մետա ({ $tags } պիտակ)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Ոչ
        [one] Այո, մեկ անգամ
       *[other] Այո, { $visits } անգամ
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } ԿԲ ({ $bytes } բայթ)
           *[other] { $kb } ԿԲ ({ $bytes } բայթ)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] { $type } Պատկեր (շարժունացված, { $frames } շրջանակ)
           *[other] { $type } Պատկեր (շարժունացված, { $frames } շրջանակ)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Նկար { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (մասշտաբը` { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } ԿԲ

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Փակել Նկարները { $website }-ից
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Էջի Մասին - { $website }
page-info-frame =
    .title = Շրջանակի մասին - { $website }
