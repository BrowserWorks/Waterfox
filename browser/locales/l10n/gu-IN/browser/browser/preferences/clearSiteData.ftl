# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = માહિતી સાફ કરો
    .style = width: 35em

clear-site-data-description = { -brand-short-name } દ્વારા સંગ્રહિત બધી કૂકીઝ અને સાઇટ ડેટાને સાફ કરી રહ્યું છે તે વેબસાઇટ્સથી તમને સાઇન આઉટ કરી શકે છે અને ઑફલાઇન વેબ સામગ્રીને દૂર કરી શકે છે. કેશ ડેટા નિકાળવા તમારા લૉગિનને અસર કરશે નહીં.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = કૂકીઝ અને સાઈટ ડેટા ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = કૂકીઝ અને સાઈટ ડેટા
    .accesskey = S

clear-site-data-cookies-info = જો સાફ થઈ જાય તો તમે વેબસાઇટ્સમાંથી સાઇન આઉટ થઈ શકો છો

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = કેશ વેબ સામગ્રી ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = કેશ થયેલ વેબ સમાવિષ્ટો
    .accesskey = W

clear-site-data-cache-info = વેબસાઇટ્સને છબીઓ અને ડેટા ફરીથી લોડ કરવાની જરૂર પડશે

clear-site-data-cancel =
    .label = રદ કરો
    .accesskey = C

clear-site-data-clear =
    .label = સાફ કરો
    .accesskey = I
