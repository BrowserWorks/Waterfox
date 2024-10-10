# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = プライベートウィンドウを開く
    .accesskey = P
about-private-browsing-search-placeholder = ウェブ検索
about-private-browsing-info-title = プライベートウィンドウです
about-private-browsing-search-btn =
    .title = ウェブ検索
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = { $engine } で検索、または URL を入力します
about-private-browsing-handoff-no-engine =
    .title = 検索語句、または URL を入力します
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = { $engine } で検索、または URL を入力します
about-private-browsing-handoff-text-no-engine = 検索語句、または URL を入力します
about-private-browsing-not-private = これはプライベートウィンドウではありません。
about-private-browsing-info-description-private-window = プライベートウィンドウ: { -brand-short-name } はプライベートウィンドウをすべて閉じると、検索履歴と閲覧履歴を消去します。匿名化はしません。
about-private-browsing-info-description-simplified = { -brand-short-name } はプライベートウィンドウをすべて閉じると、検索履歴と閲覧履歴を消去しますが、匿名化されているわけではありません。
about-private-browsing-learn-more-link = 詳細情報
about-private-browsing-hide-activity = あなたの行動と訪問先のすべてを秘匿します
about-private-browsing-get-privacy = どこでもプライバシーを確保
about-private-browsing-hide-activity-1 = { -mozilla-vpn-brand-name } であなたの行動と訪問先を秘匿できます。公共 Wi-Fi でもクリックひとつで安全な接続を確保できます。
about-private-browsing-prominent-cta = { -mozilla-vpn-brand-name } でプライバシーを確保
about-private-browsing-focus-promo-cta = { -focus-brand-name } をダウンロード
about-private-browsing-focus-promo-header = { -focus-brand-name }: 出先でプライベートブラウジング
about-private-browsing-focus-promo-text = 私たちのプライベートブラウジング専用モバイルアプリは履歴と Cookie を毎回消去します。

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = あなたの携帯端末にプライベートブラウジングを
about-private-browsing-focus-promo-text-b = いつも使っているモバイルブラウザーでは見たくないプライベートな検索には { -focus-brand-name } をお使いください。
about-private-browsing-focus-promo-header-c = モバイルでの次レベルのプライバシー
about-private-browsing-focus-promo-text-c = { -focus-brand-name } は広告とトラッカーをブロックしながら、毎回履歴を消去します。
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } はプライベートウィンドウでの既定の検索エンジンです
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] 別の検索エンジンを選択するには、<a data-l10n-name="link-options">オプション</a>を開いてください。
       *[other] 別の検索エンジンを選択するには、<a data-l10n-name="link-options">設定</a>を開いてください。
    }
about-private-browsing-search-banner-close-button =
    .aria-label = 閉じる
about-private-browsing-promo-close-button =
    .title = 閉じる

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = クリック一つで自由にプライベートブラウジング
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Dock に追加
       *[other] タスクバーにピン留め
    }
about-private-browsing-pin-promo-title = Cookie や履歴を保存せず、デスクトップからすぐ使えます。誰からも監視されずブラウジングできます。

## Strings used in a promotion message for cookie banner reduction

# Simplified version of the headline if the original text doesn't work
# in your language: `See fewer cookie requests`.
about-private-browsing-cookie-banners-promo-header = Cookie バナーよ去れ！
about-private-browsing-cookie-banners-promo-button = Cookie バナーを減らす
about-private-browsing-cookie-banners-promo-message = 目障りな Cookie ポップアップに { -brand-short-name } が自動的に応答します。可能な場合は { -brand-short-name } がすべて拒否します。
