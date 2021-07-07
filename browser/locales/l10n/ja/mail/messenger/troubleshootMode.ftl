# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } トラブルシューティングモード
    .style = width: 37em;

troubleshoot-mode-description = { -brand-short-name } のトラブルシューティングモードで問題を診断できます。アドオンと設定変更は一時的に無効化されます。
troubleshoot-mode-description2 = 以下の項目については恒久的に変更できます:
troubleshoot-mode-disable-addons =
    .label = すべてのアドオンを無効化する
    .accesskey = D
troubleshoot-mode-reset-toolbars =
    .label = ツールバーとコントロールをリセットする
    .accesskey = R
troubleshoot-mode-change-and-restart =
    .label = 変更を実行して再起動
    .accesskey = M
troubleshoot-mode-continue =
    .label = トラブルシューティングモードを続ける
    .accesskey = C
troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] 終了
           *[other] 終了
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
