# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = 分頁降載
about-unloads-intro-1 = { -brand-short-name } 提供自動卸載分頁的功能，來防止應用程式因記憶體不足發生錯誤。此功能會依照多個屬性來決定接下來要卸除哪個分頁。此頁面顯示 { -brand-short-name } 如何排序分頁的優先程度，以及觸發降載時會卸載哪些分頁。
about-unloads-intro-2 = 下方將依照 { -brand-short-name } 卸載分頁的順序來顯示目前開啟的分頁。以<strong>粗體字</strong>顯示的處理程序 ID 表示它們處理網頁的頂層畫框內容；以<em>斜體字</em>顯示的分頁則代表其處理程序是由其他不同分頁共同使用中。您可以點擊下方的「<em>卸載</em>」來進行分頁降載。
about-unloads-intro = { -brand-short-name } 提供自動卸載分頁的功能，來防止應用程式因系統記憶體不足而發生錯誤。此功能會依照多個屬性來決定接下來要卸除哪個分頁。此頁面顯示 { -brand-short-name } 如何排序分頁的優先程度，以及觸發降載時會卸載哪些分頁。您可點擊下方的<em>卸載</em>按鈕來手動觸發此功能。
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = 若需有關本頁面與此功能的更多資訊，請參考 <a data-l10n-name="doc-link">Tab Unloading</a> 一文。
about-unloads-last-updated = 最後更新於: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = 卸載
    .title = 卸載最高優先權的分頁
about-unloads-no-unloadable-tab = 沒有可卸載的分頁。
about-unloads-column-priority = 優先權
about-unloads-column-host = 主機
about-unloads-column-last-accessed = 最後存取於
about-unloads-column-weight = 基礎權重
    .title = 會根據分頁的各種屬性，例如是否正在播放音訊、WebRTC 等計算出這個值，並根據此值排序分頁。
about-unloads-column-sortweight = 次要權重
    .title = 根據基礎權重排序分頁後，會根據分頁記憶體用量、處理程序數量算出這個值，再以此權重排序。
about-unloads-column-memory = 記憶體
    .title = 分頁的記憶體用量估計值
about-unloads-column-processes = 處理程序 ID
    .title = 處理分頁內容的處理程序 ID 清單
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
