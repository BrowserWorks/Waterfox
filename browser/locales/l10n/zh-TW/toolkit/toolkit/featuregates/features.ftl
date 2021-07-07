# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = 開啟實驗中的 CSS 瀑布流版面功能支援。若需此功能的簡易說明，請參考<a data-l10n-name="explainer">本文件</a>。若想提供意見回饋，請到<a data-l10n-name="w3c-issue">此 GitHub issue</a> 或<a data-l10n-name="bug">此 bug</a> 留言。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-cascade-layers =
    .label = CSS: Cascade Layers
experimental-features-css-cascade-layers-description = 開啟支援 CSS Cascade Layers 功能。若需更多資訊，請參考<a data-l10n-name="spec">正在設計中的規格</a>。若遇到與此功能相關的任何 bug 請回報，並 block <a data-l10n-name="bugzilla">bug 1699215</a>。
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
experimental-features-media-jxl =
    .label = 媒體: JPEG XL 格式
experimental-features-media-jxl-description = 開啟此功能後，{ -brand-short-name } 將支援 JPEG XL（JXL）格式，這種加強過的新版圖檔格式支援不失真壓縮，讓您可從傳統的 JPEG 格式轉型升級。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1539075</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = 我們根據 <a data-l10n-name="whatwg">WHATWG 標準規格</a>，更新了 <a data-l10n-name="mdn-inputmode">inputmode</a> 全域屬性的實作，但還需要有其他修改，才能讓它可以用於 contenteditable 內容。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1205133</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = 加入建構子到 <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> 介面以及一系列相關的修改，讓您可直接建立新的樣式表，而不需要將樣式表加入到 HTML 當中。此功能讓您更簡單就能建立用於 <a data-l10n-name="mdn-shadowdom">Shadow DOM</a> 的可重複使用樣式表。若需更多資訊，請參考 <a data-l10n-name="bugzilla">bug 1520690</a>。
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
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = WebRTC Global Mute Toggles
experimental-features-webrtc-global-mute-toggles-description = 新增對 WebRTC 全域分享指示器的控制元件，讓使用者能夠完全關閉麥克風與攝影機訊號來源。
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k Lockdown
experimental-features-win32k-lockdown-description = 於瀏覽器分頁中不再使用 Win32k API。可增加安全性，但目前可能還不穩定或容易出錯。（僅適用於 Windows）
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = 開啟改善 JavaScript 效能與記憶體使用量的專案計畫: Warp。
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission（網站隔離）
experimental-features-fission-description = Fission（網站隔離）是 { -brand-short-name } 的一個實驗性功能，針對網站的安全性問題提供另一道保護。Fission 透過將各個網站隔離在不同的處理程序中，讓惡意網站更難取得您造訪的其他頁面當中的資訊。這是 { -brand-short-name } 的一組重大架構變更，若您能協助測試並回報遇到的任何問題，我們會非常感激。若需更多資訊，請參考 <a data-l10n-name="wiki">wiki</a> 內容。
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = 支援多組子母畫面
experimental-features-multi-pip-description = 實驗性支援同時開啟多組子母畫面。
# Search during IME
experimental-features-ime-search =
    .label = 網址列: 於輸入法未選字時就顯示搜尋引擎回傳的結果
experimental-features-ime-search-description = 東亞與印度語系使用者須使用輸入法才能在標準鍵盤輸入各種文字。開啟此實驗功能後將在輸入字根的過程中保持開啟網址列面板，並根據使用者輸入內容顯示搜尋結果與建議。請注意: 某些輸入法可能會顯示輸入面板，蓋過網址列顯示的結果，因此建議您只在使用的輸入法不會顯示輸入面板，或顯示的面板不會覆蓋搜尋框時，開啟此設定。
