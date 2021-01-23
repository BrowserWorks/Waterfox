# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = ကွန်တိန်နာအသစ်ထပ်ထည့်ပါ
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } ကွန်တိန်နာ အပြင်အဆင်များ
    .style = width: 45em

containers-window-close =
    .key = w

# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem

containers-name-label = အမည်
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = ကွန်တိန်နာအမည်ရေးပါ

containers-icon-label = ပုံသင်္ကေတ
    .accesskey = l
    .style = { -containers-labels-style }

containers-color-label = အရောင်
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = ပြီးပြီ
    .accesskey = D

containers-color-blue =
    .label = အပြာရောင်
containers-color-turquoise =
    .label = စိမ်းပြာရောင်
containers-color-green =
    .label = အစိမ်းရောင်
containers-color-yellow =
    .label = အဝါရောင်
containers-color-orange =
    .label = လိမ္မော်ရောင်
containers-color-red =
    .label = အနီရောင်
containers-color-pink =
    .label = ပန်းရောင်
containers-color-purple =
    .label = ခရမ်းရောင်

containers-icon-fingerprint =
    .label = လက်ဗွေ
containers-icon-briefcase =
    .label = လက်ဆွဲအိတ်
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ဒေါ်လာသင်္ကေတ
containers-icon-cart =
    .label = ဈေးဝယ်ဆွဲခြင်း
containers-icon-circle =
    .label = အစက်
containers-icon-vacation =
    .label = အားလပ်ရက်
containers-icon-gift =
    .label = လက်ဆောင်
containers-icon-food =
    .label = အစားအစာ
containers-icon-fruit =
    .label = သစ်သီး
containers-icon-pet =
    .label = အိမ်မွေးတိရိစ္ဆာန်
containers-icon-tree =
    .label = သစ်ပင်
containers-icon-chill =
    .label = ပေါ့ပေါ့ပါးပါး
