# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = 注意して進んでください！
about-config-intro-warning-text = 高度な設定を変更すると、{ -brand-short-name } のセキュリティ、パフォーマンスに深刻な問題を引き起こす恐れがあります。
about-config-intro-warning-checkbox = これらの設定にアクセスするときは、警告を表示する
about-config-intro-warning-button = 危険性を承知の上で使用する

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = これらの設定を変更すると、{ -brand-short-name } のセキュリティ、パフォーマンスに深刻な問題を引き起こす恐れがあります。

about-config-page-title = 高度な設定

about-config-search-input1 =
    .placeholder = 設定名を検索
about-config-show-all = すべて表示

about-config-show-only-modified = 変更された設定のみ表示する

about-config-pref-add-button =
    .title = 新規作成
about-config-pref-toggle-button =
    .title = 切り替え
about-config-pref-edit-button =
    .title = 値を変更
about-config-pref-save-button =
    .title = 保存
about-config-pref-reset-button =
    .title = リセット
about-config-pref-delete-button =
    .title = 削除

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = 真偽値
about-config-pref-add-type-number = 整数値
about-config-pref-add-type-string = 文字列

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (初期設定値)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (変更されています)
