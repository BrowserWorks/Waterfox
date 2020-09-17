# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = নতুন কন্টেইনার যোগ
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } কন্টেইনার পছন্দসমূহ
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

containers-name-label = নাম
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = কন্টেইনারের নাম লিখুন

containers-icon-label = আইকন
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = রঙ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = সম্পন্ন
    .accesskey = D

containers-color-blue =
    .label = নীল
containers-color-turquoise =
    .label = ফিরোজা
containers-color-green =
    .label = সবুজ
containers-color-yellow =
    .label = হলুদ
containers-color-orange =
    .label = কমলা
containers-color-red =
    .label = লাল
containers-color-pink =
    .label = গোলাপি
containers-color-purple =
    .label = বেগুনি
containers-color-toolbar =
    .label = ম্যাচ টুলবার

containers-icon-fence =
    .label = বেষ্টনী
containers-icon-fingerprint =
    .label = আঙ্গুলের ছাপ
containers-icon-briefcase =
    .label = ব্রিফকেস
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ডলার চিহ্ন
containers-icon-cart =
    .label = বাজারের ঝুড়ি
containers-icon-circle =
    .label = ডট
containers-icon-vacation =
    .label = ছুটি
containers-icon-gift =
    .label = উপহার
containers-icon-food =
    .label = খাদ্য
containers-icon-fruit =
    .label = ফল
containers-icon-pet =
    .label = পৌষ্য
containers-icon-tree =
    .label = গাছ
containers-icon-chill =
    .label = চিল
