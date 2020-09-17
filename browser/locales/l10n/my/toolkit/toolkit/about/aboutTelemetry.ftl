# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = ကွန်ယက်စာတို(ပင်းန်) ဒေတာရင်းမြစ်။
about-telemetry-show-archived-ping-data = သိမ်းထားသည့် ပင်းန် ဒေတာ
about-telemetry-show-subsession-data = အချိန်ခွဲသိမ်း ဒေတာကို ပြပါ
about-telemetry-choose-ping = ပင်းန်ကို ရွေးရန်။
about-telemetry-archive-ping-header = ပင်းန်
about-telemetry-page-title = Telemetry Data
about-telemetry-general-data-section = အထွေထွေ အချက်အလက်
about-telemetry-environment-data-section = Environment Data
about-telemetry-session-info-section = အသုံးပြုမှုကာလအချက်အလက်
about-telemetry-scalar-section =
      
      Scalars
      
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = Histograms
about-telemetry-keyed-histogram-section = ကီးများဖြင့် ဇယားကွက်
about-telemetry-events-section = Events
about-telemetry-simple-measurements-section = ရိုးရှင်းသော တိုင်းတာချက်များ
about-telemetry-slow-sql-section = Slow SQL Statements
about-telemetry-addon-details-section = Add-on Details
about-telemetry-captured-stacks-section = Captured Stacks
about-telemetry-late-writes-section = နောက်ကျသောရေးသားချက်
about-telemetry-raw = JSON အကြမ်းထည်
about-telemetry-full-sql-warning = NOTE: Slow SQL debugging is enabled. Full SQL strings may be displayed below but they will not be submitted to Telemetry.
about-telemetry-fetch-stack-symbols = အကန့်များထဲမှ လုပ်ဆောင်ချက်အမည်များအာ:ဆွဲထုတ်ပါ
about-telemetry-hide-stack-symbols = မူရင်းမှတ်သားချက်များအားပြပါ
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = This page shows the information about performance, hardware, usage and customizations collected by Telemetry. This information is submitted to { $telemetryServerOwner } to help improve { -brand-full-name }.
# button label to copy the histogram
about-telemetry-histogram-copy = ကူးယူပါ
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Slow SQL Statements on Main Thread
about-telemetry-slow-sql-other = Slow SQL Statements on Helper Threads
about-telemetry-slow-sql-hits = Hits
about-telemetry-slow-sql-average = ပျှမ်းမျှအချိန် (ms)
about-telemetry-slow-sql-statement = ထုတ်ပြန်ချက်
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = အတ်အွန် အိုင်ဒီ
about-telemetry-addon-table-details = အသေးစိတ်များ
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } Provider
about-telemetry-keys-header = ဂုဏ်သတ္တိများ
about-telemetry-names-header = အမည်
about-telemetry-values-header = တန်ဖိုး
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (မှတ်သားချက်များ- { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Late Write #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Memory map:
about-telemetry-error-fetching-symbols = သင်္ကေတများအားရယူနေစဉ် ပြတ်တောက်သွားသှ်။ အင်တာနက်သို့ချိတ်ဆက်မှူအား စစ်ဆေးကြည့်ပါရန်။
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = ကဏ္ဍ
about-telemetry-method-header = နည်းလမ်း
about-telemetry-object-header = အရာ
about-telemetry-extra-header = အပို
