# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = 新分頁
newtab-settings-button =
    .title = 自訂您的新分頁頁面
newtab-personalize-button-label = 個人化
    .title = 個人化新分頁
    .aria-label = 個人化新分頁
newtab-personalize-dialog-label =
    .aria-label = 個人化

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = 搜尋
    .aria-label = 搜尋
newtab-search-box-search-the-web-text = 搜尋 Web
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = 使用 { $engine } 搜尋或輸入網址
newtab-search-box-handoff-text-no-engine = 搜尋或輸入網址
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = 使用 { $engine } 搜尋或輸入網址
    .title = 使用 { $engine } 搜尋或輸入網址
    .aria-label = 使用 { $engine } 搜尋或輸入網址
newtab-search-box-handoff-input-no-engine =
    .placeholder = 搜尋或輸入網址
    .title = 搜尋或輸入網址
    .aria-label = 搜尋或輸入網址
newtab-search-box-search-the-web-input =
    .placeholder = 搜尋 Web
    .title = 搜尋 Web
    .aria-label = 搜尋 Web
newtab-search-box-text = 搜尋 Web
newtab-search-box-input =
    .placeholder = 搜尋 Web
    .aria-label = 搜尋 Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = 新增搜尋引擎
newtab-topsites-add-topsites-header = 新增熱門網站
newtab-topsites-add-shortcut-header = 新增捷徑
newtab-topsites-edit-topsites-header = 編輯熱門網站
newtab-topsites-edit-shortcut-header = 編輯捷徑
newtab-topsites-title-label = 標題
newtab-topsites-title-input =
    .placeholder = 輸入標題
newtab-topsites-url-label = 網址
newtab-topsites-url-input =
    .placeholder = 輸入或貼上網址
newtab-topsites-url-validation = 請輸入有效的網址
newtab-topsites-image-url-label = 自訂圖片網址
newtab-topsites-use-image-link = 使用自訂圖片…
newtab-topsites-image-validation = 圖片載入失敗，請改用不同網址。

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = 取消
newtab-topsites-delete-history-button = 從瀏覽紀錄刪除
newtab-topsites-save-button = 儲存
newtab-topsites-preview-button = 預覽
newtab-topsites-add-button = 新增

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = 您確定要刪除此頁面的所有瀏覽紀錄？
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = 此動作無法復原。

## Top Sites - Sponsored label

newtab-topsite-sponsored = 贊助項目

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = 開啟選單
    .aria-label = 開啟選單
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = 移除
    .aria-label = 移除
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = 開啟選單
    .aria-label = 開啟 { $title } 的右鍵選單
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = 編輯此網站
    .aria-label = 編輯此網站

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = 編輯
newtab-menu-open-new-window = 用新視窗開啟
newtab-menu-open-new-private-window = 用新隱私視窗開啟
newtab-menu-dismiss = 隱藏
newtab-menu-pin = 釘選
newtab-menu-unpin = 取消釘選
newtab-menu-delete-history = 從瀏覽紀錄刪除
newtab-menu-save-to-pocket = 儲存至 { -pocket-brand-name }
newtab-menu-delete-pocket = 從 { -pocket-brand-name } 刪除
newtab-menu-archive-pocket = 在 { -pocket-brand-name } 裡封存
newtab-menu-show-privacy-info = 我們的贊助商與您的隱私權

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = 完成
newtab-privacy-modal-button-manage = 管理贊助內容設定
newtab-privacy-modal-header = 您的隱私相當重要。
newtab-privacy-modal-paragraph-2 = 除了提供吸引人的文章之外，我們還與贊助商合作提供與您相關，且經精挑細選的內容。請放心，<strong>您的上網資料絕對不會流出於您電腦上的 { -brand-product-name } 之外</strong>— 我們跟我們的贊助商都不會看到。
newtab-privacy-modal-link = 了解我們如何在提供新分頁內容的同時確保您的隱私

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = 移除書籤
# Bookmark is a verb here.
newtab-menu-bookmark = 書籤

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = 複製下載鏈結
newtab-menu-go-to-download-page = 前往下載頁面
newtab-menu-remove-download = 自下載記錄移除

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] 顯示於 Finder
       *[other] 開啟所在資料夾
    }
newtab-menu-open-file = 開啟檔案

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = 造訪過的網站
newtab-label-bookmarked = 已加入書籤
newtab-label-removed-bookmark = 已移除書籤
newtab-label-recommended = 熱門
newtab-label-saved = 已儲存至 { -pocket-brand-name }
newtab-label-download = 已下載
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · 贊助
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = 由 { $sponsor } 贊助

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = 移除段落
newtab-section-menu-collapse-section = 摺疊段落
newtab-section-menu-expand-section = 展開段落
newtab-section-menu-manage-section = 管理段落
newtab-section-menu-manage-webext = 管理擴充套件
newtab-section-menu-add-topsite = 新增熱門網站
newtab-section-menu-add-search-engine = 新增搜尋引擎
newtab-section-menu-move-up = 上移
newtab-section-menu-move-down = 下移
newtab-section-menu-privacy-notice = 隱私權公告

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = 摺疊段落
newtab-section-expand-section-label =
    .aria-label = 展開段落

## Section Headers.

newtab-section-header-topsites = 熱門網站
newtab-section-header-highlights = 精選網站
newtab-section-header-recent-activity = 近期動態
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } 推薦

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = 開始上網，我們就會把您在網路上發現的好文章、影片、剛加入書籤的頁面顯示於此。
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = 所有文章都讀完啦！晚點再來，{ $provider } 將提供更多推薦故事。等不及了？選擇熱門主題，看看 Web 上各式精采資訊。

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = 都讀完了！
newtab-discovery-empty-section-topstories-content = 晚點再回來看看有沒有新鮮事。
newtab-discovery-empty-section-topstories-try-again-button = 重試
newtab-discovery-empty-section-topstories-loading = 載入中…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = 唉呀，暫時無法載入此區塊。

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = 熱門主題:
newtab-pocket-more-recommendations = 更多推薦項目
newtab-pocket-learn-more = 了解更多
newtab-pocket-cta-button = 取得 { -pocket-brand-name }
newtab-pocket-cta-text = 將您喜愛的故事儲存到 { -pocket-brand-name }，閱讀一篇篇好文章。

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = 唉唷，載入內容時發生錯誤。
newtab-error-fallback-refresh-link = 請重新整理頁面再試一次。

## Customization Menu

newtab-custom-shortcuts-title = 捷徑
newtab-custom-shortcuts-subtitle = 您儲存或造訪過的網站
newtab-custom-row-selector =
    { $num ->
       *[other] { $num } 行
    }
newtab-custom-sponsored-sites = 贊助捷徑
newtab-custom-pocket-title = 由 { -pocket-brand-name } 推薦
newtab-custom-pocket-subtitle = 由 { -brand-product-name } 的姊妹作 { -pocket-brand-name } 精心策展的內容
newtab-custom-pocket-sponsored = 贊助內容
newtab-custom-recent-title = 近期動態
newtab-custom-recent-subtitle = 近期造訪過的網站與內容精選
newtab-custom-close-button = 關閉
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = 隻字片語
newtab-custom-snippets-subtitle = 來自 { -vendor-short-name } 及 { -brand-product-name } 的使用秘訣與新聞
newtab-custom-settings = 管理更多設定
