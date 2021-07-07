# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = ウェブページの言語設定
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = 一部のウェブページは複数の言語で提供されています。これらのページで使用する言語とその優先順位を設定してください。

languages-customize-spoof-english =
    .label = プライバシー強化のため、英語版のウェブページを表示する

languages-customize-moveup =
    .label = 上へ
    .accesskey = U

languages-customize-movedown =
    .label = 下へ
    .accesskey = D

languages-customize-remove =
    .label = 削除
    .accesskey = R

languages-customize-select-language =
    .placeholder = 追加する言語を選択...

languages-customize-add =
    .label = 追加
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
    .label = { $locale } [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = { -brand-short-name } の言語設定
    .style = width: 40em

browser-languages-description = { -brand-short-name } は最初の言語を既定として表示し、必要ならば優先順位に従って代替言語を表示します。

browser-languages-search = 他の言語を検索...

browser-languages-searching =
    .label = 言語を検索中...

browser-languages-downloading =
    .label = ダウンロード中...

browser-languages-select-language =
    .label = 追加する言語を選択...
    .placeholder = 追加する言語を選択...

browser-languages-installed-label = インストールした言語
browser-languages-available-label = 利用可能な言語

browser-languages-error = { -brand-short-name } は現在、言語を更新できません。インターネット接続を確認して、もう一回試してください。
