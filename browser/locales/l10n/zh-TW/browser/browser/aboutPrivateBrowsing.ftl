# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 開啟隱私視窗
    .accesskey = P
about-private-browsing-search-placeholder = 搜尋 Web
about-private-browsing-info-title = 您在隱私瀏覽視窗當中
about-private-browsing-info-myths = 隱私瀏覽功能的常見迷思
about-private-browsing =
    .title = 搜尋 Web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = 使用 { $engine } 搜尋或輸入網址
about-private-browsing-handoff-no-engine =
    .title = 搜尋或輸入網址
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = 使用 { $engine } 搜尋或輸入網址
about-private-browsing-handoff-text-no-engine = 搜尋或輸入網址
about-private-browsing-not-private = 您目前不在隱私瀏覽視窗當中。
about-private-browsing-info-description = { -brand-short-name } 會在結束或關閉所有隱私瀏覽分頁與視窗時，清除您的搜尋與上網紀錄。雖然這樣做不會讓您對網站或電信業者匿名，但還是可以更簡單就讓與您使用相同電腦的人無法得知您在線上做了什麼事。
about-private-browsing-need-more-privacy = 需要更多隱私嗎？
about-private-browsing-turn-on-vpn = 請試用 { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = 在隱私瀏覽視窗中，會預設使用 { $engineName } 進行搜尋
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] 可到<a data-l10n-name="link-options">選項</a>切換成不同搜尋引擎
       *[other] 可到<a data-l10n-name="link-options">偏好設定</a>切換成不同搜尋引擎
    }
about-private-browsing-search-banner-close-button =
    .aria-label = 關閉
