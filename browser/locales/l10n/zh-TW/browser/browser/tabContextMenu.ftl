# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = 重新載入分頁
    .accesskey = R
select-all-tabs =
    .label = 選擇所有分頁
    .accesskey = S
duplicate-tab =
    .label = 複製分頁
    .accesskey = D
duplicate-tabs =
    .label = 複製分頁
    .accesskey = D
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
reopen-in-container =
    .label = 使用容器開啟
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

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] 復原已關閉分頁
           *[other] 復原已關閉分頁
        }
    .accesskey = U
close-tab =
    .label = 關閉分頁
    .accesskey = c
close-tabs =
    .label = 關閉分頁
    .accesskey = S
move-tabs =
    .label = 移動分頁
    .accesskey = v
move-tab =
    .label = 移動分頁
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
           *[other] 關閉分頁
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
           *[other] 移動分頁
        }
    .accesskey = v
