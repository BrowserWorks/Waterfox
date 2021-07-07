# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Thunderbird Brand
##
## Thunderbird must be treated as a brand, and kept in English.
## It cannot be:
## - Transliterated.
## - Translated.
##
## Reference: https://www.mozilla.org/styleguide/communications/translation/

-brand-shorter-name =
    { $case ->
       *[nom] Thunderbird
        [gen] Thunderbirdu
        [dat] Thunderbirdu
        [acc] Thunderbird
        [voc] Thunderbirde
        [loc] Thunderbirdu
        [ins] Thunderbirdem
    }
    .gender = masculine
-brand-short-name =
    { $case ->
       *[nom] Thunderbird
        [gen] Thunderbirdu
        [dat] Thunderbirdu
        [acc] Thunderbird
        [voc] Thunderbirde
        [loc] Thunderbirdu
        [ins] Thunderbirdem
    }
    .gender = masculine
-brand-full-name = Mozilla Thunderbird
# This brand name can be used in messages where the product name needs to
# remain unchanged across different versions (Daily, Beta, etc.).
-brand-product-name =
    { $case ->
       *[nom] Thunderbird
        [gen] Thunderbirdu
        [dat] Thunderbirdu
        [acc] Thunderbird
        [voc] Thunderbirde
        [loc] Thunderbirdu
        [ins] Thunderbirdem
    }
    .gender = masculine
-vendor-short-name =
    { $case ->
       *[nom] Mozilla
        [gen] Mozilly
        [dat] Mozille
        [acc] Mozillu
        [voc] Mozillo
        [loc] Mozille
        [ins] Mozillou
    }
    .gender = feminine
