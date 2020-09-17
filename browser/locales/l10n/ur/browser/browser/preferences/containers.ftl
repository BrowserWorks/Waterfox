# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = نئے حامل کا اضافہ کریں
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } حامل ترجیحات
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

containers-name-label = نام
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = ایک حامل نام داخل کریں

containers-icon-label = آئکن
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = رنگ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = مکمل
    .accesskey = D

containers-color-blue =
    .label = نیلا
containers-color-turquoise =
    .label = فیروزی
containers-color-green =
    .label = سبز
containers-color-yellow =
    .label = پیلا
containers-color-orange =
    .label = زرد
containers-color-red =
    .label = لال
containers-color-pink =
    .label = گلابی
containers-color-purple =
    .label = مزید سیکھیں
containers-color-toolbar =
    .label = ٹول بار ملائے

containers-icon-fence =
    .label = باڑ
containers-icon-fingerprint =
    .label = انگلیوں کے نشان
containers-icon-briefcase =
    .label = بریف کیس
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ڈالر کا نشان
containers-icon-cart =
    .label = خریداری کی ٹوکری
containers-icon-circle =
    .label = نقتہ
containers-icon-vacation =
    .label = چھٹى
containers-icon-gift =
    .label = تحفہ
containers-icon-food =
    .label = کھانا
containers-icon-fruit =
    .label = پھل
containers-icon-pet =
    .label = پیٹ
containers-icon-tree =
    .label = ‏‏درخت
containers-icon-chill =
    .label = چل
