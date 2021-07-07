# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = أضف حاوية جديدة
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = إعدادات الحاوية { $name }
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

containers-name-label = الاسم
    .accesskey = س
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = أدخِل اسم الحاوية

containers-icon-label = الأيقونة
    .accesskey = ق
    .style = { -containers-labels-style }

containers-color-label = اللون
    .accesskey = ل
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = تم
    .buttonaccesskeyaccept = ت

containers-color-blue =
    .label = أزرق
containers-color-turquoise =
    .label = تركوازي
containers-color-green =
    .label = أخضر
containers-color-yellow =
    .label = أصفر
containers-color-orange =
    .label = برتقالي
containers-color-red =
    .label = أحمر
containers-color-pink =
    .label = وردي
containers-color-purple =
    .label = أرجواني
containers-color-toolbar =
    .label = لون يتطابق مع شريط الأدوات

containers-icon-fence =
    .label = سياج
containers-icon-fingerprint =
    .label = بصمة
containers-icon-briefcase =
    .label = حقيبة
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = علامة الدولار
containers-icon-cart =
    .label = عربة تسوق
containers-icon-circle =
    .label = نقطة
containers-icon-vacation =
    .label = عطلة
containers-icon-gift =
    .label = هدية
containers-icon-food =
    .label = طعام
containers-icon-fruit =
    .label = فاكهة
containers-icon-pet =
    .label = حيوان أليف
containers-icon-tree =
    .label = شجرة
containers-icon-chill =
    .label = راحة
