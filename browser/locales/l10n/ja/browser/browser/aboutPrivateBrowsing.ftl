# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = プライベートウィンドウを開く
    .accesskey = P
about-private-browsing-search-placeholder = ウェブ検索
about-private-browsing-info-title = プライベートウィンドウです
about-private-browsing-info-myths = プライベートブラウジングに共通する話題
about-private-browsing =
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
about-private-browsing-info-description = ブラウザーを終了するかプライベートブラウジングのタブとウィンドウをすべて閉じると、検索履歴と閲覧履歴を消去します。ウェブサイトとインターネットサービスプロバイダーに対しては匿名化されません。このコンピューターを使う他のユーザーからあなたのオンラインでのプライベートを守るのに役立ちます。

about-private-browsing-need-more-privacy = より厳重なプライバシーが必要ですか？
about-private-browsing-turn-on-vpn = { -mozilla-vpn-brand-name } をお試しください

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } はプライベートウィンドウでの既定の検索エンジンです
about-private-browsing-search-banner-description = {
  PLATFORM() ->
     [windows] 別の検索エンジンを選択するには、<a data-l10n-name="link-options">オプション</a>を開いてください。
    *[other] 別の検索エンジンを選択するには、<a data-l10n-name="link-options">設定</a>を開いてください。
  }
about-private-browsing-search-banner-close-button =
    .aria-label = 閉じる
