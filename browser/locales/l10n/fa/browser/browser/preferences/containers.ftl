# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = افزودن حامل جدید
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name }ترجیحات حامل
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
    .placeholder = وارد کردن نام حامل

containers-icon-label = شمایل
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = رنگ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = انجام شد
    .accesskey = ا

containers-color-blue =
    .label = آبی
containers-color-turquoise =
    .label = فیروزه
containers-color-green =
    .label = سبز
containers-color-yellow =
    .label = زرد
containers-color-orange =
    .label = نارنجی
containers-color-red =
    .label = قرمز
containers-color-pink =
    .label = صورتی
containers-color-purple =
    .label = بنفش
containers-color-toolbar =
    .label = نوار ابزار مطابقت

containers-icon-fence =
    .label = حصار
containers-icon-fingerprint =
    .label = اثر انگشت
containers-icon-briefcase =
    .label = کیف
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = علامت دلار
containers-icon-cart =
    .label = سبد خرید
containers-icon-circle =
    .label = نقطه
containers-icon-vacation =
    .label = مسافرت
containers-icon-gift =
    .label = هدیه
containers-icon-food =
    .label = غذا
containers-icon-fruit =
    .label = میوه
containers-icon-pet =
    .label = حیوان خانگی
containers-icon-tree =
    .label = درخت
containers-icon-chill =
    .label = آرامش
