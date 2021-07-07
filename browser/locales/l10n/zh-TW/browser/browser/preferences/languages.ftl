# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = 網頁語言設定
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = 一張網頁有時候會有不同語言的版本，請選擇要顯示的語言版本順序

languages-customize-spoof-english =
    .label = 為了加強保護隱私，要求載入英文版網頁

languages-customize-moveup =
    .label = 上移
    .accesskey = U

languages-customize-movedown =
    .label = 下移
    .accesskey = D

languages-customize-remove =
    .label = 移除
    .accesskey = R

languages-customize-select-language =
    .placeholder = 選擇要新增的語言…

languages-customize-add =
    .label = 新增
    .accesskey = A

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = { -brand-short-name } 語言設定
    .style = width: 40em

browser-languages-description = { -brand-short-name } 將會以第一種語言作為您的預設語言，並根據所選的順序在需要時顯示其他語言。

browser-languages-search = 搜尋更多語言…

browser-languages-searching =
    .label = 正在搜尋語言…

browser-languages-downloading =
    .label = 下載中…

browser-languages-select-language =
    .label = 選擇要新增的語言…
    .placeholder = 選擇要新增的語言…

browser-languages-installed-label = 已安裝的語言
browser-languages-available-label = 可用語言

browser-languages-error = { -brand-short-name } 目前無法更新您的語言套件。請確認您是否已連線至網際網路，或可再試一次。
