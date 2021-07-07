# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = おすすめの拡張機能
cfr-doorhanger-feature-heading = おすすめの機能

##

cfr-doorhanger-extension-sumo-link =
  .tooltiptext = サポート記事を表示します

cfr-doorhanger-extension-cancel-button = 後で
  .accesskey = N

cfr-doorhanger-extension-ok-button = 追加
  .accesskey = A

cfr-doorhanger-extension-manage-settings-button = おすすめの設定を管理
  .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = このおすすめは表示しない
  .accesskey = S

cfr-doorhanger-extension-learn-more-link = 詳細

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = 作成者: { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = おすすめ
cfr-doorhanger-extension-notification2 = おすすめ
  .tooltiptext = おすすめの拡張機能です
  .a11y-announcement = おすすめの拡張機能があります

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = おすすめ
  .tooltiptext = おすすめの機能です
  .a11y-announcement = おすすめの機能があります

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
  .tooltiptext = { $total } つ星
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users = { $total } ユーザー

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = どこからでもブックマークを同期します。
cfr-doorhanger-bookmark-fxa-body = 見つかっちゃった。ブックマークをこの端末だけに残しておかないで同期して。{ -fxaccount-brand-name } を始めましょう。
cfr-doorhanger-bookmark-fxa-link-text = ブックマークを今すぐ同期...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
  .aria-label = 閉じるボタン
  .title = 閉じる

## Protections panel

cfr-protections-panel-header = 追跡を遮断する
cfr-protections-panel-body = あなたのデータはあなた自身だけに。{ -brand-short-name } はオンラインでのあなたの行動を追跡するよく知られた数多くのトラッカーからあなたを守ります。
cfr-protections-panel-link-text = 詳細

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = 新機能:

cfr-whatsnew-button =
  .label = 新着情報
  .tooltiptext = 新着情報です

cfr-whatsnew-release-notes-link-text = リリースノートをご確認ください

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
  { $blockedCount ->
    *[other] { DATETIME($date, month: "long", year: "numeric") } 以降、{ -brand-short-name } は <b>{ $blockedCount } 個</b>以上のトラッカーをブロックしました！
  }
cfr-doorhanger-milestone-ok-button = 確認
  .accesskey = S
cfr-doorhanger-milestone-close-button = 閉じる
  .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = プライバシーは重要です。{ -brand-short-name } はあなたのブラウジングを保護するため、パートナーサービスが対応するときは常に DNS 要求を安全にお届けします。
cfr-doorhanger-doh-header = 暗号化 DNS でより安全に
cfr-doorhanger-doh-primary-button-2 = OK
  .accesskey = O
cfr-doorhanger-doh-secondary-button = 無効にする
  .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = プライバシーは重要です。{ -brand-short-name } がウェブサイトをそれぞれ他のサイトから分離、サンドボックス化するため、パスワードやクレジットカード番号、他の重要な情報が盗まれにくくなりました。
cfr-doorhanger-fission-header = サイトの分離
cfr-doorhanger-fission-primary-button = OK、有効にする
  .accesskey = O
cfr-doorhanger-fission-secondary-button = 詳細
  .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = このバージョンの { -brand-short-name } では、このサイトの動画を正しく再生できません。今すぐ、動画に完全対応する { -brand-short-name } に更新しましょう。
cfr-doorhanger-video-support-header = { -brand-short-name } を更新して動画を再生
cfr-doorhanger-video-support-primary-button = 今すぐ更新
  .accesskey = U

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = 公共 Wi-Fi を使うかのように
spotlight-public-wifi-vpn-body = あなたの行動と訪問先を秘匿するなら、VPN を検討してみましょう。空港や喫茶店のような公共の場所でブラウジングするときのプライバシーを保護します。
spotlight-public-wifi-vpn-primary-button = { -mozilla-vpn-brand-name } でプライバシーを確保
  .accesskey = S
spotlight-public-wifi-vpn-link = 後で
  .accesskey = N
