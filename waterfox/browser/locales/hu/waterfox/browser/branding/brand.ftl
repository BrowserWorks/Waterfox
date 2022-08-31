# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Waterfox and Waterfox Brand
##
## Waterfox and Waterfox must be treated as a brand.
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
       *[nominative] Waterfox
        [accusative] Waterfoxot
        [instrumental] Waterfoxszal
    }
-brand-short-name =
    { $case ->
       *[nominative] Waterfox
        [accusative] Waterfoxot
        [instrumental] Waterfoxszal
    }
-brand-full-name = Waterfox
# This brand name can be used in messages where the product name needs to
# remain unchanged across different versions (Nightly, Beta, etc.).
-brand-product-name =
    { $case ->
       *[nominative] Waterfox
        [accusative] Waterfoxot
        [instrumental] Waterfoxszal
    }
-vendor-short-name =
    { $ending ->
       *[normal]
            { $case ->
               *[upper] Waterfox
                [lower] mozilla
            }
        [accented]
            { $case ->
               *[upper] Mozillá
                [lower] mozillá
            }
    }
trademarkInfo = A Waterfox és a Waterfox logó a Waterfox Limited védjegye.
