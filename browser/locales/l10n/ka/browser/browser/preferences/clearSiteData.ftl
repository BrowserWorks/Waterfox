# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = მონაცემების გასუფთავება
    .style = width: 35em

clear-site-data-description = ყველა ფუნთუშისა და საიტის მონაცემის გასუფთავების შედეგად, რომელთაც { -brand-short-name } ინახავს, შესაძლოა ვებსაიტებზე შესული ანგარიშებიდან გამოხვიდეთ. დროებითი კეშის გასუფთავება კი არ იმოქმედებს თქვენს ანგარიშებზე.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = ფუნთუშები და საიტის მონაცემები ({ $amount } { $unit })
    .accesskey = ს

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = ფუნთუშები და საიტის მონაცემები
    .accesskey = ს

clear-site-data-cookies-info = გასუფთავების შედეგად, შესაძლოა საიტებზე შესული ანგარიშებიდან გამოხვიდეთ

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = დროებითი ვებშიგთავსი ({ $amount } { $unit })
    .accesskey = ვ

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = დროებითი ვებშიგთავსი
    .accesskey = ვ

clear-site-data-cache-info = ვებსაიტები საჭიროებს სურათების და მონაცემების განსაახლებლად

clear-site-data-cancel =
    .label = გაუქმება
    .accesskey = ქ

clear-site-data-clear =
    .label = გასუფთავება
    .accesskey = ფ
