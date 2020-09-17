# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = નકલ કરો
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = બધું પસંદ કરો
    .accesskey = A

general-tab =
    .label = સામાન્ય
    .accesskey = G
general-title =
    .value = શીર્ષક:
general-url =
    .value = સરનામું:
general-type =
    .value = પ્રકાર:
general-mode =
    .value = રેન્ડર સ્થિતિ:
general-size =
    .value = માપ:
general-referrer =
    .value = સંદર્ભિત URL:
general-modified =
    .value = સુધારેલ:
general-encoding =
    .value = ટેક્સ્ટ એન્કોડિંગ:
general-meta-name =
    .label = નામ
general-meta-content =
    .label = વિષયસુચી

media-tab =
    .label = મીડિયા
    .accesskey = M
media-location =
    .value = સ્થાન:
media-text =
    .value = સંકલિત લખાણ:
media-alt-header =
    .label = વૈકલ્પિક લખાણ
media-address =
    .label = સરનામું
media-type =
    .label = પ્રકાર
media-size =
    .label = માપ
media-count =
    .label = ગણો
media-dimension =
    .value = પરિમાણો:
media-long-desc =
    .value = લાંબુ વર્ણન:
media-save-as =
    .label = આ રીતે સંગ્રહો...
    .accesskey = A
media-save-image-as =
    .label = આ રીતે સંગ્રહો...
    .accesskey = e

perm-tab =
    .label = પરવાનગીઓ
    .accesskey = P
permissions-for =
    .value = માટેની પરવાનગીઓ:

security-tab =
    .label = સુરક્ષા
    .accesskey = S
security-view =
    .label = પ્રમાણપત્ર જુઓ
    .accesskey = V
security-view-unknown = અજ્ઞાત
    .value = અજ્ઞાત
security-view-identity =
    .value = વેબ સાઈટ ઓળખ
security-view-identity-owner =
    .value = માલિક:
security-view-identity-domain =
    .value = વેબ સાઈટ:
security-view-identity-verifier =
    .value = ચકાસનાર:
security-view-identity-validity =
    .value = ના રોજ સમાપ્ત થયેલ:
security-view-privacy =
    .value = ખાનગીપણું & ઇતિહાસ

security-view-privacy-history-value = શું મેં આ વેબસાઈટની આજે પહેલાં મુલાકાત લીધી છે?
security-view-privacy-sitedata-value = શું આ વેબસાઇટ મારા કમ્પ્યુટર પર માહિતી સ્ટોર કરે છે?

security-view-privacy-clearsitedata =
    .label = કુકીઝ અને સાઇટ ડેટા સાફ કરો
    .accesskey = C

security-view-privacy-passwords-value = શું મેં આ વેબસાઈટ માટે કોઈપણ પાસવર્ડો સંગ્રહ્યા છે?

security-view-privacy-viewpasswords =
    .label = સંગ્રહાયેલ પાસવર્ડો જુઓ
    .accesskey = w
security-view-technical =
    .value = ટેક્નિકલ વિગતો

help-button =
    .label = મદદ

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = હા, કૂકીઝ અને સાઇટ ડેટાના { $value } { $unit }
security-site-data-only = હા, સાઇટ ડેટાના { $value } { $unit }

security-site-data-cookies-only = હા, કૂકીઝ
security-site-data-no = ના

image-size-unknown = અજ્ઞાત
page-info-not-specified =
    .value = સ્પષ્ટ થયેલ નથી
not-set-alternative-text = સ્પષ્ટ થયેલ નથી
not-set-date = સ્પષ્ટ થયેલ નથી
media-img = ચિત્ર
media-bg-img = પાશ્વ ભાગ
media-border-img = કિનારી
media-list-img = બુલેટ
media-cursor = કર્સર
media-object = ઓબ્જેક્ટ
media-embed = જડો
media-link = ચિહ્ન
media-input = ઈનપુટ
media-video = વિડિઓ
media-audio = ઑડિઓ
saved-passwords-yes = હા
saved-passwords-no = ના

no-page-title =
    .value = શીર્ષકવીહિન પાનું:
general-quirks-mode =
    .value = Quirks સ્થિતિ
general-strict-mode =
    .value = પ્રમાણભૂત સુસંગત સ્થિતિ
page-info-security-no-owner =
    .value = આ વેબ સાઈટ માલિક જાણકારી પૂરી પાડતી નથી.
media-select-folder = ચિત્રો સંગ્રહવા માટે ફોલ્ડર પસંદ કરો
media-unknown-not-cached =
    .value = અજ્ઞાત (કેશ થયેલ નથી)
permissions-use-default =
    .label = મૂળભૂત વાપરો
security-no-visits = ના

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
        [0] ના
        [one] હા, એકવાર
       *[other] હા, { $visits } વાર
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
            [one] { $type } Image (animated, { $frames } frame)
           *[other] { $type } Image (animated, { $frames } frames)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } ચિત્ર

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px સુધી ખેંચાયેલ)

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
    .label = { $website } માંથી ચિત્રો અટકાવો
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = પાનાં જાણકારી - { $website }
page-info-frame =
    .title = ચોકઠાં જાણકારી - { $website }
