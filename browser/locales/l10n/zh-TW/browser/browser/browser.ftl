# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - Waterfox
# private - "Waterfox Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name }（隱私瀏覽模式）
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name }（隱私瀏覽模式）
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - Waterfox
# "private" - "Waterfox Waterfox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } —（隱私瀏覽模式）
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } —（隱私瀏覽模式）
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = 檢視網站資訊

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = 開啟安裝訊息面板
urlbar-web-notification-anchor =
    .tooltiptext = 變更您是否要收到來自此網站的通知
urlbar-midi-notification-anchor =
    .tooltiptext = 開啟 MIDI 面板
urlbar-eme-notification-anchor =
    .tooltiptext = 管理 DRM 軟體使用
urlbar-web-authn-anchor =
    .tooltiptext = 開啟 Web 身份驗證面板
urlbar-canvas-notification-anchor =
    .tooltiptext = 管理 canvas 資料取得權限
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = 管理您是否要與網站分享麥克風
urlbar-default-notification-anchor =
    .tooltiptext = 開啟訊息面板
urlbar-geolocation-notification-anchor =
    .tooltiptext = 開啟位置請求面板
urlbar-xr-notification-anchor =
    .tooltiptext = 開啟虛擬實境權限面板
urlbar-storage-access-anchor =
    .tooltiptext = 開啟瀏覽活動權限面板
urlbar-translate-notification-anchor =
    .tooltiptext = 翻譯此頁面
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = 管理您是否要與網站分享視窗或畫面
urlbar-indexed-db-notification-anchor =
    .tooltiptext = 開啟離線儲存訊息面板
urlbar-password-notification-anchor =
    .tooltiptext = 開啟儲存密碼訊息面板
urlbar-translated-notification-anchor =
    .tooltiptext = 管理頁面翻譯
urlbar-plugins-notification-anchor =
    .tooltiptext = 管理附加元件使用情況
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = 管理您是否要與網站分享攝影機及/或麥克風
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = 管理是否要與網站分享其他音效輸出裝置
urlbar-autoplay-notification-anchor =
    .tooltiptext = 開啟自動播放面板
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = 將資料儲存於持續性儲存空間
urlbar-addons-notification-anchor =
    .tooltiptext = 開啟附加元件安裝訊息面板
urlbar-tip-help-icon =
    .title = 取得幫助
urlbar-search-tips-confirm = 好的，知道了
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = 秘訣:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = 打得更少，找到更多: 直接從網址列進行 { $engineName } 搜尋。
urlbar-search-tips-redirect-2 = 在網址列進行搜尋，就可看見由 { $engineName } 及瀏覽紀錄提供的搜尋建議。
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = 使用此捷徑，讓您更快找到想要的東西。

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = 書籤
urlbar-search-mode-tabs = 分頁
urlbar-search-mode-history = 瀏覽紀錄

##

urlbar-geolocation-blocked =
    .tooltiptext = 您已封鎖此網站取得您所在位置資訊的權限。
urlbar-xr-blocked =
    .tooltiptext = 您已封鎖此網站的虛擬實境裝置存取權限。
urlbar-web-notifications-blocked =
    .tooltiptext = 您已封鎖此網站推送通知的權限。
urlbar-camera-blocked =
    .tooltiptext = 您已封鎖此網站的攝影機存取權限。
urlbar-microphone-blocked =
    .tooltiptext = 您已封鎖此網站存取您麥克風的權限。
urlbar-screen-blocked =
    .tooltiptext = 您已封鎖此網站分享您螢幕畫面的權限。
urlbar-persistent-storage-blocked =
    .tooltiptext = 您已封鎖此網站儲存資料至持續性儲存空間。
urlbar-popup-blocked =
    .tooltiptext = 您封鎖了此網站的彈出視窗。
urlbar-autoplay-media-blocked =
    .tooltiptext = 您已封鎖此網站自動播放有聲音的媒體內容。
urlbar-canvas-blocked =
    .tooltiptext = 您已封鎖此網站讀取 canvas 資料的權限。
urlbar-midi-blocked =
    .tooltiptext = 您已封鎖此網站的 MIDI 存取權限。
urlbar-install-blocked =
    .tooltiptext = 您已封鎖此網站安裝附加元件。
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = 編輯此書籤 ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = 將本頁加入書籤 ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = 管理擴充套件…
page-action-remove-extension =
    .label = 移除擴充套件

## Auto-hide Context Menu

full-screen-autohide =
    .label = 隱藏工具列
    .accesskey = H
full-screen-exit =
    .label = 離開全螢幕模式
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = 這次使用下列搜尋引擎搜尋:
search-one-offs-change-settings-compact-button =
    .tooltiptext = 修改搜尋設定
search-one-offs-context-open-new-tab =
    .label = 在新分頁中搜尋
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = 設為預設搜尋引擎
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = 設為隱私瀏覽模式中的預設搜尋引擎
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName }（{ $alias }）
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = 新增「{ $engineName }」
    .tooltiptext = 新增「{ $engineName }」搜尋引擎
    .aria-label = 新增「{ $engineName }」搜尋引擎
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = 新增搜尋引擎

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = 書籤（{ $restrict }）
search-one-offs-tabs =
    .tooltiptext = 分頁（{ $restrict }）
search-one-offs-history =
    .tooltiptext = 瀏覽紀錄（{ $restrict }）

## Bookmark Panel

bookmarks-add-bookmark = 新增書籤
bookmarks-edit-bookmark = 編輯書籤
bookmark-panel-cancel =
    .label = 取消
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [1] 移除書籤
           *[other] 移除 { $count } 筆書籤
        }
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = 儲存時顯示編輯器
    .accesskey = S
bookmark-panel-save-button =
    .label = 儲存
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = { $host } 的網站資訊
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = { $host } 的連線安全性
identity-connection-not-secure = 不安全連線
identity-connection-secure = 安全連線
identity-connection-failure = 連線失敗
identity-connection-internal = 這是安全的 { -brand-short-name } 頁面。
identity-connection-file = 此頁面位於您的電腦上。
identity-extension-page = 此頁面是擴充套件頁面。
identity-active-blocked = { -brand-short-name } 已經封鎖此頁面中不安全的部分。
identity-custom-root = 連線是由 Waterfox 不認識的憑證簽發者所驗證。
identity-passive-loaded = 本頁面中的部分內容（例如圖片）並不安全。
identity-active-loaded = 您已停用此頁面中的保護。
identity-weak-encryption = 此頁面使用了弱強度的加密。
identity-insecure-login-forms = 在此頁面輸入的登入資訊可能會被洩漏。
identity-https-only-connection-upgraded = （升級 HTTPS）
identity-https-only-label = 純 HTTPS 模式
identity-https-only-dropdown-on =
    .label = 開啟
identity-https-only-dropdown-off =
    .label = 關閉
identity-https-only-dropdown-off-temporarily =
    .label = 暫時關閉
identity-https-only-info-turn-on2 = 若您想要 { -brand-short-name } 盡可能升級使用安全連線，請對此網站開啟純 HTTPS 模式。
identity-https-only-info-turn-off2 = 若網頁外觀看起來不正常，您可能會想要針對此網站關閉純 HTTPS 模式，使用不安全的 HTTP 重新載入。
identity-https-only-info-no-upgrade = 無法將網站連線從 HTTP 升級。
identity-permissions-storage-access-header = 跨網站 Cookie
identity-permissions-storage-access-hint = 當您開啟此網站時，這些網站可以使用跨網站 Cookie，並且取得您在此網站的資料。
identity-permissions-storage-access-learn-more = 了解更多
identity-permissions-reload-hint = 您可能需要重新載入頁面才能讓變更生效。
identity-clear-site-data =
    .label = 清除 Cookie 與網站資料…
identity-connection-not-secure-security-view = 您並未安全地連線至此網站。
identity-connection-verified = 您正安全地連線至此網站。
identity-ev-owner-label = 憑證簽發給:
identity-description-custom-root = Waterfox 不認識此憑證簽發者，可能是由您的作業系統或網路管理員所加入的。<label data-l10n-name="link">了解更多</label>
identity-remove-cert-exception =
    .label = 移除例外
    .accesskey = R
identity-description-insecure = 您對此網站的連線並不私密。發送的資訊（像是密碼、訊息、信用卡等等）可能會被其他人看到。
identity-description-insecure-login-forms = 此頁面並不安全，您的登入資訊可能會被洩漏。
identity-description-weak-cipher-intro = 您與此網站間的連線使用了弱強度的加密，並不私密。
identity-description-weak-cipher-risk = 其他人可以看到您的資訊，或修改網站的行為。
identity-description-active-blocked = { -brand-short-name } 已經封鎖此頁面中不安全的部分。<label data-l10n-name="link">了解更多</label>
identity-description-passive-loaded = 您的連線並不私密，提供給此網站的資訊可能會被其他人看到。
identity-description-passive-loaded-insecure = 此網站包含不安全的內容（例如圖片）。<label data-l10n-name="link">了解更多</label>
identity-description-passive-loaded-mixed = 雖然 { -brand-short-name } 已經封鎖部分內容，但頁面中還是有不安全的內容（例如圖片）。<label data-l10n-name="link">了解更多</label>
identity-description-active-loaded = 此網站包含不安全的內容（例如指令碼），與其之間的連線並不私密。
identity-description-active-loaded-insecure = 您提供給此網站的資訊（例如密碼、訊息、信用卡號等等）可能會被其他人看到。
identity-learn-more =
    .value = 了解更多
identity-disable-mixed-content-blocking =
    .label = 暫時停止保護
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = 啟用保護
    .accesskey = E
identity-more-info-link-text =
    .label = 更多資訊

## Window controls

browser-window-minimize-button =
    .tooltiptext = 最小化
browser-window-maximize-button =
    .tooltiptext = 最大化
browser-window-restore-down-button =
    .tooltiptext = 還原大小
browser-window-close-button =
    .tooltiptext = 關閉

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = 播放中
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = 靜音
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = 已封鎖自動播放
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = 子母畫面

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] 將分頁靜音
       *[other] 將 { $count } 個分頁靜音
    }
browser-tab-unmute =
    { $count ->
        [1] 將分頁取消靜音
       *[other] 將 { $count } 個分頁取消靜音
    }
browser-tab-unblock =
    { $count ->
        [1] 播放分頁聲音
       *[other] 播放 { $count } 個分頁的聲音
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = 匯入書籤…
    .tooltiptext = 將其他瀏覽器的書籤匯入到 { -brand-short-name }。
bookmarks-toolbar-empty-message = 可將書籤放到這個書籤工具列上，方便快速開啟。<a data-l10n-name="manage-bookmarks">管理書籤…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = 攝影機:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = 攝影機
popup-select-microphone-device =
    .value = 麥克風:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = 麥克風
popup-select-speaker-icon =
    .tooltiptext = 音效輸出裝置
popup-all-windows-shared = 將分享您畫面上所有可見的視窗。
popup-screen-sharing-block =
    .label = 封鎖
    .accesskey = B
popup-screen-sharing-always-block =
    .label = 總是封鎖
    .accesskey = w
popup-mute-notifications-checkbox = 分享視窗或畫面時，隱藏網站通知

## WebRTC window or screen share tab switch warning

sharing-warning-window = 您正在分享 { -brand-short-name }，切換到新分頁時會被其他人看到。
sharing-warning-screen = 您正在分享完整畫面，切換到新分頁時會被其他人看到。
sharing-warning-proceed-to-tab =
    .label = 繼續前往分頁
sharing-warning-disable-for-session =
    .label = 在此階段停用分享保護

## DevTools F12 popup

enable-devtools-popup-description = 請透過「網頁開發者」選單開啟開發者工具，才能使用 F12 快速鍵。

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = 搜尋或輸入網址
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = 搜尋 Web
    .aria-label = 使用 { $name } 搜尋
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = 輸入搜尋詞彙
    .aria-label = 搜尋 { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = 輸入搜尋詞彙
    .aria-label = 搜尋書籤
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = 輸入搜尋詞彙
    .aria-label = 搜尋瀏覽紀錄
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = 輸入搜尋詞彙
    .aria-label = 搜尋分頁
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = 使用 { $name } 搜尋或輸入網址
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = 瀏覽器正被遠端控制中（原因: { $component }）
urlbar-permissions-granted =
    .tooltiptext = 您已授予此網站更多權限。
urlbar-switch-to-tab =
    .value = 切換到分頁:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = 擴充套件:
urlbar-go-button =
    .tooltiptext = 按此前往網址列中的網址
urlbar-page-action-button =
    .tooltiptext = 頁面操作

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = 於隱私瀏覽視窗使用 { $engine } 搜尋
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = 用隱私瀏覽視窗搜尋
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = 使用 { $engine } 進行搜尋
urlbar-result-action-sponsored = 贊助項目
urlbar-result-action-switch-tab = 切換至該分頁
urlbar-result-action-visit = 前往
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = 按 Tab 鍵，使用 { $engine } 搜尋
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = 按 Tab 鍵，搜尋 { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = 從網址列直接使用 { $engine } 搜尋
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = 從網址列直接搜尋 { $engine }
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = 複製
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = 搜尋書籤
urlbar-result-action-search-history = 搜尋瀏覽記錄
urlbar-result-action-search-tabs = 搜尋分頁

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine } 建議

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 已進入全螢幕模式
fullscreen-warning-no-domain = 此文件已進入全螢幕模式
fullscreen-exit-button = 離開全螢幕模式（Esc）
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = 離開全螢幕模式（Esc）
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 可控制您的滑鼠游標，按 Esc 取回控制權。
pointerlock-warning-no-domain = 此文件可控制您的滑鼠游標，按 Esc 取回控制權。

## Subframe crash notification

crashed-subframe-message = <strong>此頁面中的部分內容發生錯誤。</strong>您同意的話，可將此問題回報給 { -brand-product-name }，讓我們更快修正。
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = 此頁面中的部分內容發生錯誤。您同意的話，可將此問題回報給 { -brand-product-name }，讓我們更快修正。
crashed-subframe-learnmore-link =
    .value = 了解更多
crashed-subframe-submit =
    .label = 送出報告
    .accesskey = S

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = 管理書籤
bookmarks-recent-bookmarks-panel-subheader = 最近加入的書籤
bookmarks-toolbar-chevron =
    .tooltiptext = 顯示更多書籤
bookmarks-sidebar-content =
    .aria-label = 書籤
bookmarks-menu-button =
    .label = 書籤選單
bookmarks-other-bookmarks-menu =
    .label = 其他書籤
bookmarks-mobile-bookmarks-menu =
    .label = 行動書籤
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] 隱藏書籤側邊欄
           *[other] 檢視書籤欄
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] 隱藏書籤工具列
           *[other] 檢視書籤工具列
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] 隱藏書籤工具列
           *[other] 顯示書籤工具列
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] 從工具列移除書籤選單
           *[other] 在工具列中加入書籤選單
        }
bookmarks-search =
    .label = 搜尋書籤
bookmarks-tools =
    .label = 書籤工具
bookmarks-bookmark-edit-panel =
    .label = 編輯此書籤
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = 書籤工具列
    .accesskey = B
    .aria-label = 書籤
bookmarks-toolbar-menu =
    .label = 書籤工具列
bookmarks-toolbar-placeholder =
    .title = 書籤工具列項目
bookmarks-toolbar-placeholder-button =
    .label = 書籤工具列項目
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = 將目前分頁加入書籤

## Library Panel items

library-bookmarks-menu =
    .label = 書籤
library-recent-activity-title =
    .value = 近期動態

## Pocket toolbar button

save-to-pocket-button =
    .label = 儲存至 { -pocket-brand-name }
    .tooltiptext = 儲存至 { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = 修復文字編碼
    .tooltiptext = 根據訊息內容猜測正確的文字編碼

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = 附加元件與佈景主題
    .tooltiptext = 管理您的附加元件與佈景主題（{ $shortcut }）
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = 設定
    .tooltiptext =
        { PLATFORM() ->
            [macos] 開啟設定頁面（{ $shortcut }）
           *[other] 開啟設定頁面
        }

## More items

more-menu-go-offline =
    .label = 離線模式
    .accesskey = k
toolbar-overflow-customize-button =
    .label = 自訂工具列…
    .accesskey = C
toolbar-button-email-link =
    .label = 寄送鏈結
    .tooltiptext = 寄出本頁面的鏈結
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = 儲存本頁
    .tooltiptext = 儲存此頁面 ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = 開啟檔案
    .tooltiptext = 開啟檔案（{ $shortcut }）
toolbar-button-synced-tabs =
    .label = 同步的分頁
    .tooltiptext = 顯示來自其他裝置的分頁
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = 開新隱私視窗
    .tooltiptext = 新增隱私瀏覽視窗 ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = 此網站的某些影音內容需要使用 DRM 軟體，可能會限制 { -brand-short-name } 能讓您使用的功能。
eme-notifications-drm-content-playing-manage = 管理設定
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = 知道了！
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = 使用者名稱
panel-save-update-password = 密碼

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = 要移除 { $name } 嗎？
addon-removal-abuse-report-checkbox = 回報此擴充套件給 { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = 管理帳號
remote-tabs-sync-now = 立刻同步

##

# "More" item in macOS share menu
menu-share-more =
    .label = 更多…
ui-tour-info-panel-close =
    .tooltiptext = 關閉

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = 允許 { $uriHost } 的彈出型視窗
    .accesskey = p
popups-infobar-block =
    .label = 封鎖 { $uriHost } 的彈出型視窗
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = 擋下彈出型視窗時不顯示此訊息
    .accesskey = D
edit-popup-settings =
    .label = 管理彈出視窗設定…
    .accesskey = M
picture-in-picture-hide-toggle =
    .label = 隱藏子母畫面切換按鈕
    .accesskey = H

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = 導覽
navbar-downloads =
    .label = 下載
navbar-overflow =
    .tooltiptext = 更多工具…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = 列印
    .tooltiptext = 列印此頁面… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = 列印
    .tooltiptext = 列印此頁
navbar-home =
    .label = 首頁
    .tooltiptext = { -brand-short-name } 首頁
navbar-library =
    .label = 收藏庫
    .tooltiptext = 檢視瀏覽紀錄、已存書籤等資料
navbar-search =
    .title = 搜尋
navbar-accessibility-indicator =
    .tooltiptext = 已開啟輔助功能
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = 瀏覽器分頁
tabs-toolbar-new-tab =
    .label = 開新分頁
tabs-toolbar-list-all-tabs =
    .label = 列出所有分頁
    .tooltiptext = 列出所有分頁

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>想開啟先前的分頁？</strong>您可以從 { -brand-short-name } 應用程式選單 <img data-l10n-name="icon"/> 當中的「歷史」重新開啟先前的瀏覽階段。
restore-session-startup-suggestion-button = 告訴我怎麼做
