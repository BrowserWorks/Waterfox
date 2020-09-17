# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = डेटा खालीगर्नुहोस्
    .style = width: 35em

clear-site-data-description = { -brand-short-name }ले भण्डारण गरेको कुकीहरु र साइट डाटा हटाउनाले, तपाईँ वेबसाइटहरूबाट बाहिरिन सक्नु हुनेछ र अफलाइन वेब सामग्रीहरु पनि हट्न सक्नेछन् । क्यास डाटा खाली गर्नाले तपाईंका लगिनहरूलाई असर पार्दैन ।

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = कुकीहरू र साइट डाटा ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = कुकीहरू र साइट डाटा
    .accesskey = S

clear-site-data-cookies-info = यदि साइट डाटा सफा गर्नुभयो/हटाउनु भयो भने तपाइँ वेबसाइटहरूबाट बाहिरिन सक्नुहुनेछ

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = क्यास्ड वेब सामग्री ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = क्यास्ड वेब सामग्री
    .accesskey = W

clear-site-data-cache-info = वेबसाइटहरूको तस्बिरहरु र डाटा पुनः लोड गर्न आवश्यक पर्दछ

clear-site-data-cancel =
    .label = रद्द गर्नुहोस्
    .accesskey = C

clear-site-data-clear =
    .label = खाली गर्नुहोस्
    .accesskey = l
