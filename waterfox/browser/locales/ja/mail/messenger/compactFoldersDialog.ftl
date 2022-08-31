# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = フォルダーの最適化
    .style = width: 50em;
compact-dialog =
    .buttonlabelaccept = 今すぐ最適化
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = 後で通知する
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = 詳細情報...
    .buttonaccesskeyextra1 = L
# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } はメールフォルダーのパフォーマンスを向上させるため定期的にファイルをメンテナンスする必要があります。この操作でメッセージに変更を加えずにディスク領域を { $data } 確保できます。今後 { -brand-short-name } が自動的に最適化を行うように設定するには、[{ compact-dialog.buttonlabelaccept }] を選ぶ前に、下のオプションにチェックを入れてください。
compact-dialog-never-ask-checkbox =
    .label = 今後は自動的にフォルダーを最適化する
    .accesskey = a
