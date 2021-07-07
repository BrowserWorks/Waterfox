# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = 打开
    .accesskey = O
places-open-in-tab =
    .label = 新建标签页打开
    .accesskey = w
places-open-all-bookmarks =
    .label = 打开所有书签
    .accesskey = O
places-open-all-in-tabs =
    .label = 全部打开
    .accesskey = O
places-open-in-window =
    .label = 新建窗口打开
    .accesskey = N
places-open-in-private-window =
    .label = 新建隐私窗口打开
    .accesskey = P
places-add-bookmark =
    .label = 新建书签…
    .accesskey = B
places-add-folder-contextmenu =
    .label = 新建文件夹…
    .accesskey = F
places-add-folder =
    .label = 新建文件夹…
    .accesskey = o
places-add-separator =
    .label = 新建分隔条
    .accesskey = S
places-view =
    .label = 查看
    .accesskey = w
places-by-date =
    .label = 按日期
    .accesskey = D
places-by-site =
    .label = 按站点
    .accesskey = S
places-by-most-visited =
    .label = 按访问次数
    .accesskey = V
places-by-last-visited =
    .label = 按上次访问时间
    .accesskey = L
places-by-day-and-site =
    .label = 按日期和站点
    .accesskey = t
places-history-search =
    .placeholder = 在历史记录中搜索
places-history =
    .aria-label = 历史
places-bookmarks-search =
    .placeholder = 在书签中搜索
places-delete-domain-data =
    .label = 清除此网站相关信息
    .accesskey = F
places-sortby-name =
    .label = 按名称排序
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = 编辑书签…
    .accesskey = i
places-edit-generic =
    .label = 编辑…
    .accesskey = i
places-edit-folder =
    .label = 重命名文件夹…
    .accesskey = e
places-remove-folder =
    .label =
        { $count ->
            [1] 删除文件夹
           *[other] 删除文件夹
        }
    .accesskey = m
places-edit-folder2 =
    .label = 编辑文件夹…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] 删除文件夹
           *[other] 删除文件夹
        }
    .accesskey = D
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = 受控书签
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = 子文件夹
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = 其他书签
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] 删除书签
           *[other] 删除 { $count } 个书签
        }
    .accesskey = e
places-show-in-folder =
    .label = 显示所在文件夹
    .accesskey = F
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] 删除书签
           *[other] 删除书签
        }
    .accesskey = D
places-manage-bookmarks =
    .label = 管理书签
    .accesskey = M
places-forget-about-this-site-confirmation-title = 清除此网站相关信息
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = 此操作将移除与 { $hostOrBaseDomain } 相关的所有数据，包括历史记录、密码、Cookie、缓存和内容首选项。您确定要继续吗？
places-forget-about-this-site-forget = 清除
places-library =
    .title = 我的足迹
    .style = width:700px; height:500px;
places-organize-button =
    .label = 管理
    .tooltiptext = 管理您的书签
    .accesskey = O
places-organize-button-mac =
    .label = 管理
    .tooltiptext = 管理您的书签
places-file-close =
    .label = 关闭
    .accesskey = C
places-cmd-close =
    .key = w
places-view-button =
    .label = 视图
    .tooltiptext = 更换您的视图
    .accesskey = V
places-view-button-mac =
    .label = 视图
    .tooltiptext = 更换您的视图
places-view-menu-columns =
    .label = 显示列
    .accesskey = C
places-view-menu-sort =
    .label = 排序
    .accesskey = S
places-view-sort-unsorted =
    .label = 不排序
    .accesskey = U
places-view-sort-ascending =
    .label = A > Z 升序
    .accesskey = A
places-view-sort-descending =
    .label = Z > A 降序
    .accesskey = Z
places-maintenance-button =
    .label = 导入和备份
    .tooltiptext = 导入及备份您的书签
    .accesskey = I
places-maintenance-button-mac =
    .label = 导入和备份
    .tooltiptext = 导入及备份您的书签
places-cmd-backup =
    .label = 备份…
    .accesskey = B
places-cmd-restore =
    .label = 恢复
    .accesskey = R
places-cmd-restore-from-file =
    .label = 选择文件…
    .accesskey = C
places-import-bookmarks-from-html =
    .label = 从 HTML 文件导入书签…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = 导出书签到 HTML…
    .accesskey = E
places-import-other-browser =
    .label = 从其他浏览器导入数据…
    .accesskey = A
places-view-sort-col-name =
    .label = 名称
places-view-sort-col-tags =
    .label = 标签
places-view-sort-col-url =
    .label = 网址
places-view-sort-col-most-recent-visit =
    .label = 上次访问
places-view-sort-col-visit-count =
    .label = 访问次数
places-view-sort-col-date-added =
    .label = 添加日期
places-view-sort-col-last-modified =
    .label = 修改日期
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = 返回上一步
places-forward-button =
    .tooltiptext = 转到下一页
places-details-pane-select-an-item-description = 选择一个条目来查看或编辑其属性
