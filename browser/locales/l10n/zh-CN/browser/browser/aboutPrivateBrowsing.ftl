# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 打开隐私窗口
    .accesskey = P
about-private-browsing-search-placeholder = 在网络上搜索
about-private-browsing-info-title = 您已进入隐私窗口
about-private-browsing-info-myths = 隐私浏览功能的常见误解
about-private-browsing =
    .title = 在网络上搜索
about-private-browsing-not-private = 您当前不在隐私窗口中。
about-private-browsing-info-description = { -brand-short-name } 在您退出本程序或关闭所有隐私浏览标签页和窗口时，将清除您的搜索记录与浏览历史。虽然这样做不会使您对网站或电信运营商匿名，但还是可以更简单地让使用此计算机的人无法得知您在网上的活动。
about-private-browsing-need-more-privacy = 需要更多隐私吗？
about-private-browsing-turn-on-vpn = 请试用 { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } 是您在隐私窗口中的默认搜索引擎
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] 若要在隐私窗口中使用专门的搜索引擎，请在<a data-l10n-name="link-options">选项</a>中设置
       *[other] 若要在隐私窗口中使用专门的搜索引擎，请在<a data-l10n-name="link-options">首选项</a>中设置
    }
about-private-browsing-search-banner-close-button =
    .aria-label = 关闭
