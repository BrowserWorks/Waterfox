# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Falamhaich an dàta
    .style = width: 45em

clear-site-data-description = Ma dh’fhalamhaicheas tu na briosgaidean is dàta nan làraichean a tha { -brand-short-name } a’ stòradh, dh’fhaoidte gun dèid do chlàradh a-mach à làraichean-lìn agus gum falbh susbaint-lìn far loidhne. Ma dh’fhalamhaicheas tu an tasgadan, cha bhi buaidh air na clàraidhean a-steach.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Briosgaidean is dàta làraichean ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Briosgaidean is dàta làraichean
    .accesskey = S

clear-site-data-cookies-info = Dh’fhaoidte gun dèid do chlàradh a-mach à làraichean-lìn ma dh’fhalamhaicheas tu seo

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Susbaint-lìn san tasgadan ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Susbaint-lìn san tasglann
    .accesskey = W

clear-site-data-cache-info = Sparraidh seo air làraichean-lìn dealbhan is dàta a luchdadh às ùr

clear-site-data-cancel =
    .label = Sguir dheth
    .accesskey = C

clear-site-data-clear =
    .label = Falamhaich
    .accesskey = l
