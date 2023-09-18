# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = 開新分頁
    .accesskey = w
reload-tab =
    .label = 重新載入分頁
    .accesskey = R
select-all-tabs =
    .label = 選擇所有分頁
    .accesskey = S
tab-context-play-tab =
    .label = 播放分頁
    .accesskey = P
tab-context-play-tabs =
    .label = 播放分頁
    .accesskey = y
duplicate-tab =
    .label = 複製分頁
    .accesskey = D
duplicate-tabs =
    .label = 複製分頁
    .accesskey = D
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = 關閉左方分頁
    .accesskey = l
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = 關閉右方分頁
    .accesskey = i
close-other-tabs =
    .label = 關閉其他分頁
    .accesskey = o
reload-tabs =
    .label = 重新載入分頁
    .accesskey = R
pin-tab =
    .label = 釘選分頁
    .accesskey = P
unpin-tab =
    .label = 還原成普通分頁
    .accesskey = b
pin-selected-tabs =
    .label = 釘選分頁
    .accesskey = P
unpin-selected-tabs =
    .label = 還原成普通分頁
    .accesskey = b
bookmark-selected-tabs =
    .label = 將分頁加入書籤…
    .accesskey = k
bookmark-tab =
    .label = 將分頁加入書籤
    .accesskey = B
tab-context-bookmark-tab =
    .label = 將分頁加入書籤…
    .accesskey = B
tab-context-open-in-new-container-tab =
    .label = 用新容器分頁開啟
    .accesskey = e
move-to-start =
    .label = 移動至開頭
    .accesskey = S
move-to-end =
    .label = 移動至結尾
    .accesskey = E
move-to-new-window =
    .label = 移動到新視窗
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = 關閉多個分頁
    .accesskey = M
tab-context-share-url =
    .label = 分享
    .accesskey = h

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] 回復關閉的分頁
           *[other] 回復關閉的 { $tabCount } 個分頁
        }
    .accesskey = o
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] 關閉分頁
           *[other] 關閉 { $tabCount } 個分頁
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
           *[other] 移動分頁
        }
    .accesskey = v
tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [1] 將分頁傳送到其他裝置
           *[other] 將 { $tabCount } 個分頁傳送到其他裝置
        }
    .accesskey = n
