# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = 開啟實驗中的 CSS 瀑布流版面功能支援。若需此功能的簡易說明，請參考<a data-l10n-name="explainer">本文件</a>。若想提供意見回饋，請到<a data-l10n-name="w3c-issue">此 GitHub issue</a> 或<a data-l10n-name="bug">此 bug</a> 留言。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = 這組新的 API 針對使用裝置或電腦上的<a data-l10n-name="wikipedia">圖形處理單元</a>進行計算與繪圖提供了底層支援。<a data-l10n-name="spec">標準規格</a>仍在規劃中。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1602129</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = 開啟此功能後，{ -brand-short-name } 就會支援 AV1 圖片檔案格式（AVIF）。這是應用了 AV1 影片壓縮演算法以縮小檔案大小的靜態圖片檔案格式。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1443863</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = 我們根據 <a data-l10n-name="whatwg">WHATWG 標準規格</a>，更新了 <a data-l10n-name="mdn-inputmode">inputmode</a> 全域屬性的實作，但還需要有其他修改，才能讓它可以用於 contenteditable 內容。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1205133</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = 在 <a data-l10n-name="link">&lt;link&gt;</a> 元素中，<a data-l10n-name="rel">rel</a> 的屬性值 <code>"preload"</code> 是透過在頁面載入前先下載部分資源，確保能夠更早取用並且更不容易阻擋頁面呈現，以幫助改善效能。若需更多資訊，請參考<a data-l10n-name="readmore">《Preloading content with <code>rel="preload"</code>》</a>或 <a data-l10n-name="bugzilla">bug 1583604</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = 允許聚焦樣式僅在使用鍵盤（例如: 使用 Tab 鍵切換）而非滑鼠或其他指向裝置聚焦到按鈕、表單控制元件等元素時，套用聚焦效果。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1617600</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = 當 <a data-l10n-name="mdn-input">&lt;input&gt;</a>、<a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> 元素，以及任何 <a data-l10n-name="mdn-contenteditable">contenteditable</a> 屬性啟用的元素的值變更前，會觸發全域的 <a data-l10n-name="mdn-beforeinput">beforeinput</a> 事件。此事件可讓網頁應用程式蓋過瀏覽器的預設介面互動行為（例如: 應用程式可防止使用者輸入某些特殊字元，或修改貼上的含樣式字串，只允許部分樣式）。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = 加入建構子到 <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> 介面以及一系列相關的修改，讓您可直接建立新的樣式表，而不需要將樣式表加入到 HTML 當中。此功能讓您更簡單就能建立用於 <a data-l10n-name="mdn-shadowdom">Shadow DOM</a> 的可重複使用樣式表。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1520690</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = { -brand-short-name } 對 Media Session API 的整套實作目前都還在實驗中。此 API 是用來自訂對媒體相關通知的處理方式、管理媒體播放介面展現的事件與資料、以及取得媒體檔案的後設資料。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1112032</a>。

experimental-features-devtools-color-scheme-simulation =
    .label = Developer Tools: Color Scheme Simulation
experimental-features-devtools-color-scheme-simulation-description = 加入用來模擬不同配色的選項，讓您可以測試 <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a> 媒體查詢。使用此媒體查詢功能，可讓您的樣式表回覆使用者偏好使用亮色或暗色介面。此功能讓您可以不需要更改瀏覽器或作業系統設定（若瀏覽器使用系統相關設定的話）就能直接進行測試。若需更多資訊，請參考 <a data-l10n-name="bugzilla1">bug 1550804</a> 及 <a data-l10n-name="bugzilla2">bug 1137699</a>。

experimental-features-devtools-execution-context-selector =
    .label = Developer Tools: Execution Context Selector
experimental-features-devtools-execution-context-selector-description = 此功能會在主控台的命令列顯示按鈕，讓您可以切換表達式要執行的環境。若需更多資訊，請參考 <a data-l10n-name="bugzilla1">bug 1605154</a> 及 <a data-l10n-name="bugzilla2">bug 1605153</a>。

experimental-features-devtools-compatibility-panel =
    .label = Developer Tools: Compatibility Panel
experimental-features-devtools-compatibility-panel-description = 在「頁面檢測器」中加入側面版，顯示應用程式的跨瀏覽器相容性狀態。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1584464</a>。

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax by default
experimental-features-cookie-samesite-lax-by-default2-description = 若未指定「SameSite」屬性，就將 Cookie 預設設定為「SameSite=lax」。開發者必須明確指定「SameSite=None」才能維持現有行為，不受限制使用 Cookie。

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None requires secure attribute
experimental-features-cookie-samesite-none-requires-secure2-description = 使用「SameSite=None」屬性設定的 Cookie 必須再加上 secure 屬性。必須先開啟「Cookies: SameSite=Lax by default」才能開啟此功能。

# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home startup cache
experimental-features-abouthome-startup-cache-description = 啟動時，對預設載入的 about:home 文件進行快取，以改善啟動效能。

experimental-features-print-preview-tab-modal =
    .label = Print Preview Redesign
experimental-features-print-preview-tab-modal-description = 帶來重新設計過的預覽列印功能，並讓此功能在 macOS 也能使用。此功能在某些情況下，可能會造成列印功能故障，並且還沒有包含完整的列印選項。若要使用完整列印功能，請點擊列印面板當中的「使用系統對話框列印…」。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = 將來自相同網域但不同通訊協定的 Cookie（例如 http://example.com 及 https://example.com 之間）視為  cross-site 而非 same-site。可改善安全性，但可能會造成網頁故障。

# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Developer Tools: Service Worker debugging
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = 在「除錯器」面板當中開啟對 Service Worker 的實驗性支援。此功能可能會拖慢開發者工具運作，並增加記憶體消耗量。

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Graphics: Smooth Pinch Zoom
experimental-features-graphics-desktop-zooming-description = 開啟對觸控螢幕與精準觸控板的平滑手指縮放支援。
