# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } 疑難排解模式
    .style = width: 37em;

troubleshoot-mode-description = 請使用 { -brand-short-name } 的疑難排解模式來檢查瀏覽器的各種問題。將暫時停用附加元件與自訂設定。

troubleshoot-mode-description2 = 您可以進行下面部份或全部的調整:

troubleshoot-mode-disable-addons =
    .label = 停用所有附加元件
    .accesskey = D

troubleshoot-mode-reset-toolbars =
    .label = 重設工具列與控制元件
    .accesskey = R

troubleshoot-mode-change-and-restart =
    .label = 執行變更項目並重新啟動
    .accesskey = M

troubleshoot-mode-continue =
    .label = 以疑難排解模式繼續
    .accesskey = C

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] 結束
           *[other] 離開
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
