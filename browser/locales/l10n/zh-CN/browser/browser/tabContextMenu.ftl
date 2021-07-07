# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = 新建标签页
    .accesskey = w
reload-tab =
    .label = 刷新标签页
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = 关闭左侧标签页
    .accesskey = l
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = 关闭右侧标签页
    .accesskey = i
close-other-tabs =
    .label = 关闭其他标签页
    .accesskey = o
reload-tabs =
    .label = 刷新标签页
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
tab-context-open-in-new-container-tab =
    .label = 新建身份标签页打开
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
tab-context-share-url =
    .label = 共享
    .accesskey = h
tab-context-share-more =
    .label = 更多…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] 恢复关闭的标签页
           *[other] 恢复关闭的 { $tabCount } 个标签页
        }
    .accesskey = o
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
