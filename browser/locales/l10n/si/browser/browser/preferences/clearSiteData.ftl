# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = දත්ත හිස් කරන්න
    .style = width: 35em

clear-site-data-description = { -brand-short-name } මගින් ගබඩා කර ඇති සියළු කුකී හා අඩවි දත්ත පිරිසිදු කිරීමෙන් ඔබ ජාල අඩවි වලින් ඉවත් වීම හා මාර්ග ගත නොවන ජාල අන්තර්ගතයන් ඉවත් වීම සිදු විය හැක. කෑශ් පිරිසිදු කිරීම ඔබේ පිවිසීම් වෙත බල නොපායි.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = කුකී සහ ජාල අඩවි දත්ත ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = කුකී සහ ජාල අඩවි දත්ත
    .accesskey = S

clear-site-data-cookies-info = පිරිසිදු කළ හොත් ඔබ ජාල අඩවි වලින් ඉවත් විය හැක

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = කෑශ් කළ ජාල අන්තර්ගතයන් ({ $amount }{ $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = කෑශ් කළ ජාල අන්තර්ගතය
    .accesskey = W

clear-site-data-cache-info = ජාල අඩවි විසින් පින්තූර හා දත්ත යළි පූර්ණයක් අවශ්‍ය විය හැක

clear-site-data-cancel =
    .label = අවලංගු කරන්න
    .accesskey = C

clear-site-data-clear =
    .label = පිරිසිදු
    .accesskey = l
