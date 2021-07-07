# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = 新标签页
newtab-settings-button =
    .title = 定制您的新标签页
newtab-personalize-icon-label =
    .title = 个性化标签页
    .aria-label = 个性化标签页
newtab-personalize-dialog-label =
    .aria-label = 个性化

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = 搜索
    .aria-label = 搜索
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = 使用 { $engine } 搜索，或者输入网址
newtab-search-box-handoff-text-no-engine = 搜索或输入网址
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = 使用 { $engine } 搜索，或者输入网址
    .title = 使用 { $engine } 搜索，或者输入网址
    .aria-label = 使用 { $engine } 搜索，或者输入网址
newtab-search-box-handoff-input-no-engine =
    .placeholder = 搜索或输入网址
    .title = 搜索或输入网址
    .aria-label = 搜索或输入网址
newtab-search-box-search-the-web-input =
    .placeholder = 在网络上搜索
    .title = 在网络上搜索
    .aria-label = 在网络上搜索
newtab-search-box-text = 网上搜索
newtab-search-box-input =
    .placeholder = 网上搜索
    .aria-label = 网上搜索

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = 添加搜索引擎
newtab-topsites-add-topsites-header = 新建常用网站
newtab-topsites-add-shortcut-header = 新建快捷方式
newtab-topsites-edit-topsites-header = 编辑常用网站
newtab-topsites-edit-shortcut-header = 编辑快捷方式
newtab-topsites-title-label = 标题
newtab-topsites-title-input =
    .placeholder = 输入标题
newtab-topsites-url-label = 网址
newtab-topsites-url-input =
    .placeholder = 输入或粘贴网址
newtab-topsites-url-validation = 需要有效的网址
newtab-topsites-image-url-label = 自定义图像网址
newtab-topsites-use-image-link = 使用自定义图像…
newtab-topsites-image-validation = 图像载入失败。请尝试其他网址。

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = 取消
newtab-topsites-delete-history-button = 从历史记录中删除
newtab-topsites-save-button = 保存
newtab-topsites-preview-button = 预览
newtab-topsites-add-button = 添加

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = 确定删除此页面在您的历史记录中的所有记录？
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = 此操作不能撤销。

## Top Sites - Sponsored label

newtab-topsite-sponsored = 赞助项目

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = 打开菜单
    .aria-label = 打开菜单
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = 移除
    .aria-label = 移除
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = 打开菜单
    .aria-label = 打开 { $title } 的快捷菜单
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = 编辑此网站
    .aria-label = 编辑此网站

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = 编辑
newtab-menu-open-new-window = 新建窗口打开
newtab-menu-open-new-private-window = 新建隐私浏览窗口打开
newtab-menu-dismiss = 隐藏
newtab-menu-pin = 固定
newtab-menu-unpin = 取消固定
newtab-menu-delete-history = 从历史记录中删除
newtab-menu-save-to-pocket = 保存到 { -pocket-brand-name }
newtab-menu-delete-pocket = 从 { -pocket-brand-name } 删除
newtab-menu-archive-pocket = 在 { -pocket-brand-name } 中存档
newtab-menu-show-privacy-info = 我们的赞助商﹠您的隐私

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = 完成
newtab-privacy-modal-button-manage = 管理赞助内容设置
newtab-privacy-modal-header = 隐私是公民的基本权利。
newtab-privacy-modal-paragraph-2 = 除了提供引人入胜的文章之外，我们还与赞助商合作展示有价值，且经甄选的内容。请放心，<strong>您的浏览数据永远只会留在本机 { -brand-product-name }</strong> 中 — 我们看不到，我们的赞助商亦然。
newtab-privacy-modal-link = 了解新标签页如何保障您的隐私

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = 删除书签
# Bookmark is a verb here.
newtab-menu-bookmark = 添加书签

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = 复制下载链接
newtab-menu-go-to-download-page = 前往下载页面
newtab-menu-remove-download = 从历史记录中移除

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] 显示于访达
       *[other] 打开所在文件夹
    }
newtab-menu-open-file = 打开文件

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = 曾经访问
newtab-label-bookmarked = 已加书签
newtab-label-removed-bookmark = 书签已移除
newtab-label-recommended = 趋势
newtab-label-saved = 已保存到 { -pocket-brand-name }
newtab-label-download = 已下载
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · 赞助
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = 由 { $sponsor } 赞助
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } 分钟

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = 移除版块
newtab-section-menu-collapse-section = 折叠版块
newtab-section-menu-expand-section = 展开版块
newtab-section-menu-manage-section = 管理版块
newtab-section-menu-manage-webext = 管理扩展
newtab-section-menu-add-topsite = 添加常用网站
newtab-section-menu-add-search-engine = 添加搜索引擎
newtab-section-menu-move-up = 上移
newtab-section-menu-move-down = 下移
newtab-section-menu-privacy-notice = 隐私声明

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = 折叠版块
newtab-section-expand-section-label =
    .aria-label = 展开版块

## Section Headers.

newtab-section-header-topsites = 常用网站
newtab-section-header-highlights = 集锦
newtab-section-header-recent-activity = 近期动态
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } 推荐

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = 开始网上冲浪之旅吧，之后这里会显示您最近看过或加了书签的精彩文章、视频与其他页面。
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = 所有文章都读完啦！晚点再来，{ $provider } 将推荐更多精彩文章。等不及了？选择热门主题，找到更多网上的好文章。

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = 都读完了！
newtab-discovery-empty-section-topstories-content = 待会再来看是否有新文章。
newtab-discovery-empty-section-topstories-try-again-button = 重试
newtab-discovery-empty-section-topstories-loading = 正在载入…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = 哎呀！无法完全加载此版块。

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = 热门主题：
newtab-pocket-new-topics-title = 想刷到更多文章？看看这些 { -pocket-brand-name } 上的热门主题
newtab-pocket-more-recommendations = 更多推荐
newtab-pocket-learn-more = 详细了解
newtab-pocket-cta-button = 获取 { -pocket-brand-name }
newtab-pocket-cta-text = 将您喜爱的故事保存到 { -pocket-brand-name }，用精彩的读物为思想注入活力。
newtab-pocket-pocket-firefox-family = { -pocket-brand-name } 是 { -brand-product-name } 系列产品的一部分
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = 保存到 { -pocket-brand-name }
newtab-pocket-saved-to-pocket = 已保存到 { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = 加载更多文章

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = 都读完了！
newtab-pocket-last-card-desc = 待会再来看是否有新文章。
newtab-pocket-last-card-image =
    .alt = 都读完了

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = 哎呀，载入内容时发生错误。
newtab-error-fallback-refresh-link = 刷新页面以重试。

## Customization Menu

newtab-custom-shortcuts-title = 快捷方式
newtab-custom-shortcuts-subtitle = 您保存或访问过的网站
newtab-custom-row-selector =
    { $num ->
       *[other] { $num } 行
    }
newtab-custom-sponsored-sites = 赞助商网站
newtab-custom-pocket-title = 由 { -pocket-brand-name } 推荐
newtab-custom-pocket-subtitle = 由 { -brand-product-name } 旗下 { -pocket-brand-name } 策划的特别内容
newtab-custom-pocket-sponsored = 赞助内容
newtab-custom-recent-title = 近期动态
newtab-custom-recent-subtitle = 近期访问的网站与内容精选
newtab-custom-close-button = 关闭
newtab-custom-settings = 管理更多设置
