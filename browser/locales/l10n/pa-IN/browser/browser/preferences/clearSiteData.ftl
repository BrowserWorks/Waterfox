# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = ਡੇਟਾ ਸਾਫ਼ ਕਰੋ
    .style = width: 35em

clear-site-data-description = { -brand-short-name } ਵਲੋਂ ਸੰਭਾਲੇ ਗਏ ਸਾਰੇ ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡਾਟੇ ਨੂੰ ਸਾਫ਼ ਕੀਤਾ ਜਾਵੇਗਾ, ਜਿਸ ਨਾਲ ਤੁਸੀਂ ਵੈੱਬਸਾਈਟਾਂ ਤੋਂ ਸਾਈਨ ਆਉਟ ਹੋ ਜਾਉਂਗੇ ਅਤੇ ਆਫ਼ਲਾਈਨ ਵੈੱਬ ਸਮੱਗਰੀ ਹਟਾਈ ਜਾਵੇਗੀ। ਕੈਸ਼ ਡਾਟੇ ਨੂੰ ਸਾਫ਼ ਕਰਨ ਨਾਲ ਤੁਹਾਡੇ ਲਾਗਇਨ ਉੱਤੇ ਕੋਈ ਫ਼ਰਕ ਨਹੀਂ ਪਵੇਗਾ।

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡੇਟਾ ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡੇਟਾ
    .accesskey = S

clear-site-data-cookies-info = ਜੇ ਸਾਫ਼ ਕੀਤਾ ਤਾਂ ਤੁਸੀਂ ਵੈੱਬਸਾਈਟਾਂ ਤੋਂ ਸਾਈਨ ਆਉਟ ਹੋ ਸਕਦੇ ਹੋ

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = ਕੈਸ਼ ਕੀਤੀ ਵੈੱਬ ਸਮੱਗਰੀ ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = ਕੈਸ਼ ਕੀਤੀ ਵੈੱਬ ਸਮੱਗਰੀ
    .accesskey = W

clear-site-data-cache-info = ਵੈੱਬਸਾਈਟਾਂ ਨੂੰ ਚਿੱਤਰ ਤੇ ਡਾਟਾ ਮੁੜ-ਲੋਡ ਕਰ ਦੀ ਲੋੜ ਹੋਵੇਗੀ

clear-site-data-cancel =
    .label = ਰੱਦ ਕਰੋ
    .accesskey = C

clear-site-data-clear =
    .label = ਸਾਫ਼ ਕਰੋ
    .accesskey = l
