# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = ចាប់ផ្ដើម​ដំណើរការ​ដោយ​ប្រុងប្រយ័ត្ន
about-config-intro-warning-text = ការផ្លាស់ប្តូរចំណង់ចំណូលចិត្តនៃការកំណត់រចនាសម្ព័ន្ធកម្រិតខ្ពស់អាចជះឥទ្ធិពលដល់ការអនុវត្ត ឬសុវត្ថិភាព { -brand-short-name } ។
about-config-intro-warning-checkbox = ដាស់តឿន​ខ្ញុំ នៅពេលខ្ញុំព្យាយាមចូលប្រើចំណូលចិត្តទាំងនេះ
about-config-intro-warning-button = ព្រម​ទទួល​ហានិភ័យ​នេះ រួច​បន្ត



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ការផ្លាស់ប្តូរចំណង់ចំណូលចិត្តទាំងនេះអាច​ប៉ះពាល់​ដល់ការអនុវត្ត ឬសុវត្ថិភាព { -brand-short-name }។

about-config-page-title = ចំណង់ចំណូលចិត្តកម្រិតខ្ពស់

about-config-search-input1 =
    .placeholder = ស្វែងរកឈ្មោះចំណូលចិត្ត
about-config-show-all = បង្ហាញ​ទាំងអស់

about-config-pref-add-button =
    .title = បញ្ចូល
about-config-pref-toggle-button =
    .title = បិទ/បើក
about-config-pref-edit-button =
    .title = កែសម្រួល
about-config-pref-save-button =
    .title = រក្សាទុក
about-config-pref-reset-button =
    .title = កំណត់ឡើងវិញ
about-config-pref-delete-button =
    .title = លុប

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = ប៊ូលីន
about-config-pref-add-type-number = លេខ
about-config-pref-add-type-string = អក្សរ

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (លំនាំដើម)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (តាមបំណង)
