# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = បន្ថែម​ប្រអប់​ផ្ទុក​ថ្មី
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = ចំណូលចិត្ត​ប្រអប់​ផ្ទុក { $name }
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

containers-name-label = ឈ្មោះ
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = បញ្ចូល​ឈ្មោះ​ប្រអប់

containers-icon-label = រូបតំណាង
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = ពណ៌
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = ធ្វើ​រួច
    .accesskey = D

containers-color-blue =
    .label = ខៀវ
containers-color-turquoise =
    .label = បៃតង​ស្រាល
containers-color-green =
    .label = បៃតង
containers-color-yellow =
    .label = លឿង
containers-color-orange =
    .label = ទឹកក្រូច
containers-color-red =
    .label = ក្រហម
containers-color-pink =
    .label = ផ្កា​ឈូក
containers-color-purple =
    .label = ស្វាយ
containers-color-toolbar =
    .label = ផ្គូផ្គងរបារឧបករណ៍

containers-icon-fence =
    .label = របង
containers-icon-fingerprint =
    .label = ស្នាម​ម្រាមដៃ
containers-icon-briefcase =
    .label = កាតាប
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = សញ្ញា​ដុល្លារ
containers-icon-cart =
    .label = រទេះ​ទិញ​អីវ៉ាន់
containers-icon-circle =
    .label = ចំណុច
containers-icon-vacation =
    .label = វិស្សមកាល
containers-icon-gift =
    .label = អំណោយ
containers-icon-food =
    .label = អាហារ
containers-icon-fruit =
    .label = ផ្លែឈើ
containers-icon-pet =
    .label = សត្វចិញ្ចឹម
containers-icon-tree =
    .label = ដើមឈើ
containers-icon-chill =
    .label = កក់ក្ដៅ
