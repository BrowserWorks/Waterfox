# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Lorgairí ar chuir { -brand-short-name } cosc orthu an tseachtain seo

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Inniu

social-tab-title = Lorgairí Meán Sóisialta

cookie-tab-title = Fianáin Lorgaireachta

tracker-tab-title = Ábhar Lorgaireachta

fingerprinter-tab-title = Méarlorgairí

cryptominer-tab-title = Criptimhianadóirí
  
lockwise-title = Ná déan dearmad d'fhocal faire arís
lockwise-header-content = Stórálann { -lockwise-brand-name } do chuid focal faire slán sábháilte i do bhrabhsálaí.

monitor-link = Conas a oibríonn sé

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Lorgairí Meán Sóisialta
    .aria-label =
        { $count ->
            [one] { $count } lorgaire meán sóisialta ({ $percentage }%)
            [two] { $count } lorgaire meán sóisialta ({ $percentage }%)
            [few] { $count } lorgaire meán sóisialta ({ $percentage }%)
            [many] { $count } lorgaire meán sóisialta ({ $percentage }%)
           *[other] { $count } lorgaire meán sóisialta ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Fianáin Lorgaireachta
    .aria-label =
        { $count ->
            [one] { $count } fhianán lorgaireachta ({ $percentage }%)
            [two] { $count } fhianán lorgaireachta ({ $percentage }%)
            [few] { $count } fhianán lorgaireachta ({ $percentage }%)
            [many] { $count } bhfianán lorgaireachta ({ $percentage }%)
           *[other] { $count } fianán lorgaireachta ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Ábhar Lorgaireachta
    .aria-label =
        { $count ->
            [one] { $count } ábhar lorgaireachta ({ $percentage }%)
            [two] { $count } ábhar lorgaireachta ({ $percentage }%)
            [few] { $count } ábhar lorgaireachta ({ $percentage }%)
            [many] { $count } n-ábhar lorgaireachta ({ $percentage }%)
           *[other] { $count } ábhar lorgaireachta ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Méarlorgairí
    .aria-label =
        { $count ->
            [one] { $count } mhéarlorgaire ({ $percentage }%)
            [two] { $count } mhéarlorgaire ({ $percentage }%)
            [few] { $count } mhéarlorgaire ({ $percentage }%)
            [many] { $count } méarlorgaire ({ $percentage }%)
           *[other] { $count } méarlorgaire ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptimhianadóirí
    .aria-label =
        { $count ->
            [one] { $count } chriptimhianadóir ({ $percentage }%)
            [two] { $count } chriptimhianadóir ({ $percentage }%)
            [few] { $count } chriptimhianadóir ({ $percentage }%)
            [many] { $count } gcriptimhianadóir ({ $percentage }%)
           *[other] { $count } criptimhianadóir ({ $percentage }%)
        }
