# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 開啟隱私視窗
    .accesskey = P
about-private-browsing-search-placeholder = 搜尋 Web
about-private-browsing-info-title = 您在隱私瀏覽視窗當中
about-private-browsing-search-btn =
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
about-private-browsing-info-description-private-window = 隱私瀏覽視窗: { -brand-short-name } 會在您關閉所有隱私視窗後清除搜尋與瀏覽紀錄，但這麼做還無法使您匿名。
about-private-browsing-info-description-simplified = { -brand-short-name } 會在您關閉所有隱私視窗後清除搜尋與瀏覽紀錄，但這麼做還無法使您匿名。
about-private-browsing-learn-more-link = 了解更多
about-private-browsing-hide-activity = 隨處上網，隱藏行為活動與位置紀錄
about-private-browsing-get-privacy = 隨時隨地上網都獲得隱私保護
about-private-browsing-hide-activity-1 = 使用 { -mozilla-vpn-brand-name } 隱藏上網紀錄與位置資訊。就算使用公用 Wi-Fi，只要輕鬆一點即可建立安全連線。
about-private-browsing-prominent-cta = 使用 { -mozilla-vpn-brand-name } 保持隱私
about-private-browsing-focus-promo-cta = 下載 { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: 隨身上網隱私都有保護
about-private-browsing-focus-promo-text = 我們的隱私瀏覽專用 App 可在每次瀏覽結束時都清除您的上網紀錄與 Cookie。

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = 隱私上網隨身帶著走
about-private-browsing-focus-promo-text-b = 若您想搜尋一些不想被手機內建瀏覽器發現的東西，可使用 { -focus-brand-name } 進行隱私搜尋。
about-private-browsing-focus-promo-header-c = 讓行動上網的隱私保護更上一層樓
about-private-browsing-focus-promo-text-c = { -focus-brand-name } 會自動為您封鎖廣告與追蹤器，並在結束上網時清除瀏覽紀錄。
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
about-private-browsing-promo-close-button =
    .title = 關閉

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = 只要點一下，自動進入隱私瀏覽模式
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] 固定在 Dock
       *[other] 釘選到工作列
    }
about-private-browsing-pin-promo-title = 不留下任何 Cookie 與瀏覽紀錄。隱私瀏覽不留痕跡。
