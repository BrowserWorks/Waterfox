# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = សម្អាតទិន្នន័យ
    .style = width: 35em

clear-site-data-description = ការសម្អាតខូឃីនិងទិន្នន័យ​​គេហទំព័រ​ដែលបានរក្សាទុកដោយ { -brand-short-name } អាចចុះឈ្មោះអ្នកចេញពី​គេហទំព័រ និង​លុប​​ខ្លឹមសារ​​​បណ្ដាញ​​គ្មាន​អ៊ីនធឺណិត​ចេញ។ ការសម្អាតទិន្នន័យឃ្លាំងមិនប៉ះពាល់ដល់ការចូលរបស់អ្នកទេ។

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = ខូឃី និងទិន្នន័យ​គេហទំព័រ ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = ខូឃី និងទិន្នន័យគេហទំព័រ
    .accesskey = S

clear-site-data-cookies-info = អ្នក​អាច​ចេញ​ពី​គេហទំព័រ​នានា ប្រសិនបើ​បាន​សម្អាត

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = ខ្លឹមសារ​បណ្ដាញ​ដែល​បាន​ចងចាំ ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = ខ្លឹមសារ​បណ្ដាញ​ដែល​បាន​ចងចាំ
    .accesskey = W

clear-site-data-cache-info = នឹងតម្រូវឲ្យគេហទំព័រផ្ទុករូបភាព និងទិន្នន័យឡើងវិញ

clear-site-data-cancel =
    .label = បោះបង់
    .accesskey = C

clear-site-data-clear =
    .label = សម្អាត
    .accesskey = l
