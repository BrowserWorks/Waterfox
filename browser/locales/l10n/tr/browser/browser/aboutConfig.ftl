# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Dikkatli olun
about-config-intro-warning-text = Gelişmiş yapılandırma tercihlerini değiştirmek { -brand-short-name } performansını veya güvenliğini etkileyebilir.
about-config-intro-warning-checkbox = Bu tercihlere erişmeye çalıştığımda beni uyar
about-config-intro-warning-button = Riski kabul ederek devam et



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Bu tercihleri değiştirmek { -brand-short-name } performansını veya güvenliğini etkileyebilir.

about-config-page-title = Gelişmiş Tercihler

about-config-search-input1 =
    .placeholder = Tercih adlarında ara
about-config-show-all = Tümünü göster

about-config-pref-add-button =
    .title = Ekle
about-config-pref-toggle-button =
    .title = Değiştir
about-config-pref-edit-button =
    .title = Düzenle
about-config-pref-save-button =
    .title = Kaydet
about-config-pref-reset-button =
    .title = Sıfırla
about-config-pref-delete-button =
    .title = Sil

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Sayı
about-config-pref-add-type-string = Dizgi

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (varsayılan)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (özel)
