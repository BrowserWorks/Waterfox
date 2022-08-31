# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

toolbar-button-firefox-view =
  .label = { -firefoxview-brand-name }
  .tooltiptext = { -firefoxview-brand-name }

menu-tools-firefox-view =
  .label = { -firefoxview-brand-name }
  .accesskey = F

firefoxview-page-title = { -firefoxview-brand-name }

firefoxview-close-button =
  .title = 閉じる
  .aria-label = 閉じる

# Used instead of the localized relative time when a timestamp is within a minute or so of now
firefoxview-just-now-timestamp = たった今

# This is a headline for an area in the product where users can resume and re-open tabs they have previously viewed on other devices.
firefoxview-tabpickup-header = タブの選択
firefoxview-tabpickup-description = 他の端末からページを開きます。

firefoxview-tabpickup-recenttabs-description = 最近のタブ一覧がここに表示されます

# Variables:
#  $percentValue (Number): the percentage value for setup completion
firefoxview-tabpickup-progress-label = { $percentValue }% 完了

firefoxview-tabpickup-step-signin-header = 端末間をシームレスに切り替える
firefoxview-tabpickup-step-signin-description = ここから携帯端末のタブを取り出すには、最初にログインするかアカウントを作成します。
firefoxview-tabpickup-step-signin-primarybutton = 続行

firefoxview-tabpickup-adddevice-header = 携帯電話やタブレットの { -brand-product-name } と同期
firefoxview-tabpickup-adddevice-description = モバイル版 { -brand-product-name } をダウンロードして、ログインしてください。
firefoxview-tabpickup-adddevice-learn-how = 仕組みについて
firefoxview-tabpickup-adddevice-primarybutton = モバイル版 { -brand-product-name } を入手

firefoxview-tabpickup-synctabs-header = タブの同期を有効にする
firefoxview-tabpickup-synctabs-description = { -brand-short-name } に端末間のタブ共有を許可してください。
firefoxview-tabpickup-synctabs-learn-how = 仕組みについて
firefoxview-tabpickup-synctabs-primarybutton = 開いたタブを同期

firefoxview-tabpickup-fxa-admin-disabled-header = あなたの所属組織は同期を無効にしています
firefoxview-tabpickup-fxa-admin-disabled-description = { -brand-short-name } は端末間のタブ共有ができません。あなたの所属組織の管理者が同期を無効にしています。

firefoxview-tabpickup-network-offline-header = インターネット接続を確認してください
firefoxview-tabpickup-network-offline-description = ファイアウォールまたはプロキシーを利用している場合は、{ -brand-short-name } にウェブへのアクセスが許可されているか確認してください。
firefoxview-tabpickup-network-offline-primarybutton = 再試行

firefoxview-tabpickup-sync-error-header = 同期に問題が発生しています
firefoxview-tabpickup-sync-error-description = { -brand-short-name } はただいまサービスに接続できません。数分後にやり直してください。
firefoxview-tabpickup-sync-error-primarybutton = 再試行

firefoxview-tabpickup-syncing = タブを同期しています。しばらくお待ちください。

firefoxview-mobile-promo-header = 携帯電話やタブレットからタブを取り出す
firefoxview-mobile-promo-description = 携帯端末の直近のタブを表示するには、iOS または Android の { -brand-product-name } にログインしてください。
firefoxview-mobile-promo-primarybutton = モバイル版 { -brand-product-name } を入手

firefoxview-mobile-confirmation-header = 🎉 おめでとうございます！
firefoxview-mobile-confirmation-description = 携帯電話やタブレットから { -brand-product-name } のタブを取り出せるようになりました。

firefoxview-closed-tabs-title = 最近閉じたタブ
firefoxview-closed-tabs-collapse-button =
  .title = 最近閉じたタブ一覧を表示または隠す

firefoxview-closed-tabs-description = この端末で閉じたページを開きなおします。
firefoxview-closed-tabs-placeholder = <strong>最近閉じたページはありません</strong><br/>閉じたタブをなくす心配はありません。いつでもここで復旧できます。

# refers to the last tab that was used
firefoxview-pickup-tabs-badge = 最終アクティブ

# Variables:
#   $targetURI (string) - URL that will be opened in the new tab
firefoxview-tabs-list-tab-button =
  .title = { $targetURI } を新しいタブで開く

firefoxview-try-colorways-button = カラーテーマを試す
firefoxview-no-current-colorway-collection = 新しいカラーテーマが登場しました
firefoxview-change-colorway-button = カラーテーマを変更

# Variables:
#  $intensity (String): Colorway intensity
#  $collection (String): Colorway Collection name
firefoxview-colorway-description = { $intensity } · { $collection }

firefoxview-synced-tabs-placeholder = <strong>表示できるものはまだありません</strong><br/>他の端末の { -brand-product-name } でページを開くと、ここから取り出せます。
