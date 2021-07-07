# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = 指定文字列に一致する次の部分を検索します
findbar-previous =
    .tooltiptext = 指定文字列に一致する 1 つ前の部分を検索します

findbar-find-button-close =
    .tooltiptext = 検索バーを閉じます

findbar-highlight-all2 =
    .label = すべて強調表示
    .accesskey = { PLATFORM() ->
        [macos] l
       *[other] a
    }
    .tooltiptext = 指定文字列に一致するすべての部分を強調表示します

findbar-case-sensitive =
    .label = 大文字/小文字を区別
    .accesskey = c
    .tooltiptext = 大文字/小文字を区別して検索します

findbar-match-diacritics =
    .label = 発音区別符号を区別
    .accesskey = i
    .tooltiptext = アクセント付きの文字をその基底文字と区別します (例えば “resume” を検索しても “résumé” と一致しません)

findbar-entire-word =
    .label = 単語単位
    .accesskey = w
    .tooltiptext = 指定文字列に一致する単語を検索します
