# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protection-report-manage-protections = सेटिंग व्यवस्थापित करा

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = आज

# This string is used to describe the graph for screenreader users.
graph-legend-description = या आठवड्यात अडवलेल्या प्रत्येक प्रकारच्या ट्रॅकरची एकूण संख्या असलेला आलेख.

social-tab-title = सोशल मीडिया ट्रॅकर

cookie-tab-title = क्रॉस-साईट ट्रॅकिंग कुकी

tracker-tab-title = ट्रॅकिंग मजकूर

fingerprinter-tab-title = फिंगरप्रिंटर

cryptominer-tab-title = क्रिप्टोमाइनर
  
lockwise-title = पुन्हा कधीही पासवर्ड विसरू नका

turn-on-sync = { -sync-brand-short-name } चालू करा…
    .title = सिंक प्राधान्यतावर जा

monitor-title = माहिती उल्लंघनावर लक्ष ठेवा.
monitor-link = हे कसे कार्य करते
auto-scan = आज स्वयंचलितपणे स्कॅन केले

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = सोशल मीडिया ट्रॅकर
    .aria-label =
        { $count ->
            [one] { $count } सोशल मीडिया ट्रॅकर ({ $percentage }%)
           *[other] { $count } सोशल मीडिया ट्रॅकर ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = क्रॉस-साईट ट्रॅकिंग कुकी
    .aria-label =
        { $count ->
            [one] { $count } क्रॉस-साईट ट्रॅकिंग कुकी ({ $percentage }%)
           *[other] { $count } क्रॉस-साईट ट्रॅकिंग कुकी ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = ट्रॅकिंग मजकूर
    .aria-label =
        { $count ->
            [one] { $count } ट्रॅकिंग मजकूर ({ $percentage }%)
           *[other] { $count } ट्रॅकिंग मजकूर ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = फिंगरप्रिंटर
    .aria-label =
        { $count ->
            [one] { $count } फिंगरप्रिंटर ({ $percentage }%)
           *[other] { $count } फिंगरप्रिंटर ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = क्रिप्टोमाइनर
    .aria-label =
        { $count ->
            [one] { $count } क्रिप्टोमाइनर ({ $percentage }%)
           *[other] { $count } क्रिप्टोमाइनर ({ $percentage }%)
        }
