# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

app-manager-window =
    .title = プログラムの管理
    .style = width: 30em; min-height: 20em;

app-manager-remove =
    .label = 削除
    .accesskey = R

# Variables:
#   $type (String) - the URI scheme of the link (e.g. mailto:)
app-manager-handle-protocol = { $type } リンクを取り扱うプログラムには次のものが登録されています。

# Variables:
#   $type (String) - the MIME type (e.g. application/binary)
app-manager-handle-file = { $type } ファイルを取り扱うプログラムには次のものが登録されています。

## These strings are followed, on a new line,
## by the URL or path of the application.

app-manager-web-app-info = このウェブアプリケーションの URL:
app-manager-local-app-info = このプログラムの場所:
