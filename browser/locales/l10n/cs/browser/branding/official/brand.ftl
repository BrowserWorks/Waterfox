# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Firefox Brand
##
## Firefox must be treated as a brand, and kept in English.
## It cannot be:
## - Declined to adapt to grammatical case.
## - Transliterated.
## - Translated.
##
## Reference: https://www.mozilla.org/styleguide/communications/translation/

## Firefox and Mozilla Brand
##
## Firefox and Mozilla must be treated as a brand.
##
## They cannot be:
## - Transliterated.
## - Translated.
##
## Declension should be avoided where possible, leaving the original
## brand unaltered in prominent UI positions.
##
## For further details, consult:
## https://mozilla-l10n.github.io/styleguides/mozilla_general/#brands-copyright-and-trademark

-brand-shorter-name =
    { $case ->
       *[nom] Firefox
        [gen] Firefoxu
        [dat] Firefoxu
        [acc] Firefox
        [voc] Firefoxe
        [loc] Firefoxu
        [ins] Firefoxem
    }
    .gender = masculine
-brand-short-name =
    { $case ->
       *[nom] Firefox
        [gen] Firefoxu
        [dat] Firefoxu
        [acc] Firefox
        [voc] Firefoxe
        [loc] Firefoxu
        [ins] Firefoxem
    }
    .gender = masculine
-brand-full-name = Waterfox
# This brand name can be used in messages where the product name needs to
# remain unchanged across different versions (Nightly, Beta, etc.).
-brand-product-name =
    { $case ->
       *[nom] Firefox
        [gen] Firefoxu
        [dat] Firefoxu
        [acc] Firefox
        [voc] Firefoxe
        [loc] Firefoxu
        [ins] Firefoxem
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
trademarkInfo = Waterfox a jeho logo jsou ochrannými známkami organizace Mozilla Foundation.
