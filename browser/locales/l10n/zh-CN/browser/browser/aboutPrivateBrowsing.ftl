# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 打开隐私窗口
    .accesskey = P
about-private-browsing-search-placeholder = 在网络上搜索
about-private-browsing-info-title = 您已进入隐私窗口
about-private-browsing-info-myths = 正确认识隐私浏览功能
about-private-browsing =
    .title = 在网络上搜索
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = 使用 { $engine } 搜索，或者输入网址
about-private-browsing-handoff-no-engine =
    .title = 搜索或输入网址
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = 使用 { $engine } 搜索，或者输入网址
about-private-browsing-handoff-text-no-engine = 搜索或输入网址
about-private-browsing-not-private = 您当前不在隐私窗口中。
about-private-browsing-info-description = { -brand-short-name } 会在退出本程序或关闭所有隐私浏览标签页和窗口时，清除您在隐私浏览模式中的搜索记录与浏览历史。虽然这样仍无法对网站和电信运营商匿名，但还是可以更简单地防止其他使用此计算机的人得知您的上网活动。
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
