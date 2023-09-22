# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Waterfox and BrowserWorks Brand
##
## Waterfox and BrowserWorks must be treated as a brand.
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
        [gen] Waterfoxu
        [dat] Waterfoxu
        [acc] Waterfox
        [voc] Waterfoxe
        [loc] Waterfoxu
        [ins] Waterfoxem
       *[nom] Waterfox
    }
    .gender = masculine
    .case-status = with-cases
-brand-short-name =
    { $case ->
        [gen] Waterfoxu
        [dat] Waterfoxu
        [acc] Waterfox
        [voc] Waterfoxe
        [loc] Waterfoxu
        [ins] Waterfoxem
       *[nom] Waterfox
    }
    .gender = masculine
    .case-status = with-cases
-brand-shortcut-name =
    { $case ->
        [gen] Waterfoxu
        [dat] Waterfoxu
        [acc] Waterfox
        [voc] Waterfoxe
        [loc] Waterfoxu
        [ins] Waterfoxem
       *[nom] Waterfox
    }
    .gender = masculine
    .case-status = with-cases
-brand-full-name =
    { $case ->
        [gen] Mozilly Waterfoxu
        [dat] Mozille Waterfoxu
        [acc] Mozillu Waterfox
        [voc] Mozillo Waterfoxe
        [loc] Mozille Waterfoxu
        [ins] Mozillou Waterfoxem
       *[nom] Waterfox
    }
    .gender = masculine
    .case-status = with-cases
# This brand name can be used in messages where the product name needs to
# remain unchanged across different versions (Nightly, Beta, etc.).
-brand-product-name =
    { $case ->
        [gen] Waterfoxu
        [dat] Waterfoxu
        [acc] Waterfox
        [voc] Waterfoxe
        [loc] Waterfoxu
        [ins] Waterfoxem
       *[nom] Waterfox
    }
    .gender = masculine
    .case-status = with-cases
-vendor-short-name =
    { $case ->
        [gen] Mozilly
        [dat] Mozille
        [acc] Mozillu
        [voc] Mozillo
        [loc] Mozille
        [ins] Mozillou
       *[nom] BrowserWorks
    }
    .gender = feminine
    .case-status = with-cases
trademarkInfo = Waterfox a jeho loga jsou ochrannými známkami organizace BrowserWorks.
