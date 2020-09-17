# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = தரவினை அகற்று
    .style = width: 35em

clear-site-data-description = { -brand-short-name } ஆல் சேமிக்கப்பட்ட எல்லா நினைவிகள் மற்றும் தள தரவை அழிப்பது உங்களை வலைத்தளத்திலிருந்து வெளியேற்றுவதோடு இணையமில்லா வலை உள்ளடக்கங்களையும் நீக்கும். தற்காலிக நினைவிடத்தை அழிப்பது புகுபதிகைகளைப் பாதிக்காது.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = நினைவிகளும் தள தரவுகளும் ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = நினைவிகளுத் தள தரவுகளும்
    .accesskey = S

clear-site-data-cookies-info = அழிக்கப்பட்டால் நீங்கள் வலைத்தளங்களிலிருந்து வெளியேற்றப்படலாம்.

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = இடைச்சேமிப்பக தள தரவுகள் ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = இடைச்சேமிப்பக இணைய உள்ளடக்கம்
    .accesskey = W

clear-site-data-cache-info = இணையத்தளங்கள் படங்களையும் தரவுகளையும் மீட்டிறக்க வேண்டி இருக்கும்

clear-site-data-cancel =
    .label = ரத்து
    .accesskey = C

clear-site-data-clear =
    .label = துடை
    .accesskey = l
