# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = डेटा मिटायें
    .style = width: 35em

clear-site-data-description = { -brand-short-name } द्वारा जमा सभी कूकीज तथा साइट डेटा मिटाना आपको वेबसाइटों से साइन आउट कर सकता है तथा ऑफलाइन वेब सामग्री को हटा सकता है. कैश डेटा मिटाना आपके लॉग इनो को प्रभावित नहीं करेगा.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = कूकीज़ तथा साइट डेटा ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = कुकीज़ और साइट डेटा
    .accesskey = S

clear-site-data-cookies-info = यदि मिटाते हैं तो आप वेबसाइटों से साईन आउट हो जायेंगे

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = कैश्ड वेब सामग्री ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = कैश्ड वेब सामग्री
    .accesskey = W

clear-site-data-cache-info = वेबसाइटों को छवियाँ तथा डेटा पुनः लोड करने की आवश्यकता होगी

clear-site-data-cancel =
    .label = रद्द करें
    .accesskey = C

clear-site-data-clear =
    .label = मिटायें
    .accesskey = I
