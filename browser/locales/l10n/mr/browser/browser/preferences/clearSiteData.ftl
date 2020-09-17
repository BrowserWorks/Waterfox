# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = माहिती पुसा
    .style = width: 35em

clear-site-data-description = सर्व कुकीज आणि { -brand-short-name } द्वारे संचयित केलेली साइट डेटा पुसल्याने आपण संकेतस्थळातून साइन आउट होऊ शकता आणि वेब वरील मजकूर काढला जाऊ शकतो . कॅशे पुसल्याने आपल्या लॉगिन वर काहीही परिणाम होणार नाही.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = कुकीज आणि संकेतस्थळाची माहिती ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = कूकीज आणि संकेतस्थळाची माहिती
    .accesskey = S

clear-site-data-cookies-info = नष्ट केल्यास आपण संकेतस्थळातून साइन आउट होऊ शकता

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = कॅशे केलेले वेब मजकूर ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = कॅश केलेला वेब मजकूर
    .accesskey = W

clear-site-data-cache-info = संकेतस्थळांना प्रतिमा आणि माहिती पुन्हा लोड करावी लागेल

clear-site-data-cancel =
    .label = रद्द करा
    .accesskey = C

clear-site-data-clear =
    .label = नष्ट करा
    .accesskey = l
