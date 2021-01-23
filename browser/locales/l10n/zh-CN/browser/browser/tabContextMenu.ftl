# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = 重载标签页
    .accesskey = R
select-all-tabs =
    .label = 选择所有标签页
    .accesskey = S
duplicate-tab =
    .label = 克隆标签页
    .accesskey = D
duplicate-tabs =
    .label = 克隆标签页
    .accesskey = D
close-tabs-to-the-end =
    .label = 关闭右侧标签页
    .accesskey = i
close-other-tabs =
    .label = 关闭其他标签页
    .accesskey = o
reload-tabs =
    .label = 重载标签页
    .accesskey = R
pin-tab =
    .label = 固定标签页
    .accesskey = P
unpin-tab =
    .label = 取消固定标签页
    .accesskey = b
pin-selected-tabs =
    .label = 固定标签页
    .accesskey = P
unpin-selected-tabs =
    .label = 取消固定标签页
    .accesskey = b
bookmark-selected-tabs =
    .label = 为标签页添加书签…
    .accesskey = k
bookmark-tab =
    .label = 为标签页添加书签
    .accesskey = B
reopen-in-container =
    .label = 用身份标签页打开
    .accesskey = e
move-to-start =
    .label = 移动到开头
    .accesskey = S
move-to-end =
    .label = 移动到末尾
    .accesskey = E
move-to-new-window =
    .label = 移动到新窗口
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = 批量关闭标签页
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] 恢复关闭的标签页
           *[other] 恢复关闭的标签页
        }
    .accesskey = U
close-tab =
    .label = 关闭标签页
    .accesskey = c
close-tabs =
    .label = 关闭标签页
    .accesskey = S
move-tabs =
    .label = 移动标签页
    .accesskey = v
move-tab =
    .label = 移动标签页
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] 关闭标签页
           *[other] 关闭标签页
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] 移动标签页
           *[other] 移动标签页
        }
    .accesskey = v
