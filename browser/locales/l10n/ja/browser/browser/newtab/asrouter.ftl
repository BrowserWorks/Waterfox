# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = おすすめの拡張機能
cfr-doorhanger-feature-heading = おすすめの機能
cfr-doorhanger-pintab-heading = タブのピン留めを試してみる

##

cfr-doorhanger-extension-sumo-link =
  .tooltiptext = サポート記事を表示します

cfr-doorhanger-extension-cancel-button = 後で
  .accesskey = N

cfr-doorhanger-extension-ok-button = 追加
  .accesskey = A
cfr-doorhanger-pintab-ok-button = このタブをピン留め
  .accesskey = P

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

cfr-doorhanger-pintab-description = よく見るサイトに簡単にアクセスできます。再起動してもサイトを開いたままにできます。

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = ピン留めしたいタブで<b>右クリック</b>します。
cfr-doorhanger-pintab-step2 = メニューから<b>タブをピン留め</b>を選択します。
cfr-doorhanger-pintab-step3 = サイトに更新があると、ピン留めしたタブに青い点が表示されます。

cfr-doorhanger-pintab-animation-pause = 停止
cfr-doorhanger-pintab-animation-resume = 再生


## Firefox Accounts Message

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

cfr-whatsnew-panel-header = 新着情報

cfr-whatsnew-release-notes-link-text = リリースノートをご確認ください

cfr-whatsnew-fx70-title = { -brand-short-name } はあなたのプライバシーのために、今まさに戦っています
cfr-whatsnew-fx70-body =
   最新アップデートでは、トラッキング防止機能を強化し、
   サイトごとの安全なパスワード生成がより簡単にできるようになりました。

cfr-whatsnew-tracking-protect-title = トラッカーから身を守ります
cfr-whatsnew-tracking-protect-body =
   { -brand-short-name } はオンラインであなたを追跡する
   多くの一般的なソーシャルトラッカーとクロスサイトトラッカーをブロックします。
cfr-whatsnew-tracking-protect-link-text = 報告を確認

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title = { $blockedCount }  個のトラッカーをブロックしました
cfr-whatsnew-tracking-blocked-subtitle =
   { DATETIME($earliestDate, month: "long", year: "numeric") } から
cfr-whatsnew-tracking-blocked-link-text = 報告を確認

cfr-whatsnew-lockwise-backup-title = パスワードをバックアップ
cfr-whatsnew-lockwise-backup-body =
   ログインすればどの端末でも使える安全なパスワードを生成できます。
cfr-whatsnew-lockwise-backup-link-text = バックアップをオンにする

cfr-whatsnew-lockwise-take-title = パスワードもご一緒に
cfr-whatsnew-lockwise-take-body =
   { -lockwise-brand-short-name } アプリで、どの端末からでも
   バックアップしたパスワードに安全にアクセスできます。
cfr-whatsnew-lockwise-take-link-text = アプリを入手

## Search Bar

cfr-whatsnew-searchbar-title = アドレスバーからクリック一つで
cfr-whatsnew-searchbar-body-topsites = アドレスバーを選択するだけで、よく見るサイトのリンクが展開されます。

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = 虫眼鏡アイコン

## Picture-in-Picture

cfr-whatsnew-pip-header = 動画をながら見
cfr-whatsnew-pip-body = ピクチャーインピクチャー機能で、動画だけを小さいウィンドウで再生できます。他のタブで作業しながらでも視聴できます。
cfr-whatsnew-pip-cta = 詳細

## Permission Prompt

cfr-whatsnew-permission-prompt-header = 迷惑なポップアップをより少なく
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } がウェブサイトによるポップアップ通知の確認をブロックするようになりました。
cfr-whatsnew-permission-prompt-cta = 詳細

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header = { $fingerprinterCount } 個のフィンガープリント採取をブロックしました
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } は、あなたの広告プロフィールを作るために端末と行動に関する情報を密かに収集する、フィンガープリント採取の多くをブロックします。

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = フィンガープリント採取
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } は、あなたの広告プロフィールを作るために端末と行動に関する情報を密かに収集する、フィンガープリント採取をブロックできます。

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = このブックマークを携帯電話で使う
cfr-doorhanger-sync-bookmarks-body = ブックマーク、パスワード、履歴などが { -brand-product-name } にログインしたどの端末でも使えます。
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } をオンにする
  .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = 二度とパスワードを忘れないように
cfr-doorhanger-sync-logins-body = パスワードを安全に保存して、あなたのすべての端末に共有できます。
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } をオンにする
  .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = 外出先でこのページを読む
cfr-doorhanger-send-tab-recipe-header = このレシピをキッチンで使う
cfr-doorhanger-send-tab-body = タブ送信でこのリンクを { -brand-product-name } にログインした携帯電話や他の端末と簡単に共有できます。
cfr-doorhanger-send-tab-ok-button = タブ送信を試してみる
  .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = この PDF を安全に共有する
cfr-doorhanger-firefox-send-body = エンドツーエンド暗号化と自動消滅リンクで、機密文書を安全に共有できます。
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } を試してみる
  .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = トラッキング防止機能を確認
  .accesskey = P
cfr-doorhanger-socialtracking-close-button = 閉じる
  .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = このようなメッセージは次から表示しない
  .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } はソーシャルネットワークからの追跡を停止させました
cfr-doorhanger-socialtracking-description = プライバシーは重要です。{ -brand-short-name } は一般的なソーシャルメディアトラッカーをブロックしました。オンラインでのあなたの行動を収集できるデータ量を制限しています。
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } はこのページのフィンガープリント採取をブロックしました
cfr-doorhanger-fingerprinters-description = プライバシーは重要です。{ -brand-short-name } はあなたを追跡するために端末から一意に識別可能な情報を収集する、フィンガープリント採取をブロックしました。
cfr-doorhanger-cryptominers-heading = { -brand-short-name } はこのページの暗号通貨マイニングをブロックしました
cfr-doorhanger-cryptominers-description = プライバシーは重要です。{ -brand-short-name } は暗号通貨の採掘のためにあなたのシステムの計算リソースを利用する、暗号通貨マイニングをブロックしました。

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
  { $blockedCount ->
   *[other] { $date } 以降、{ -brand-short-name } は <b>{ $blockedCount } 個</b>以上のトラッカーをブロックしました！
  }

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
  { $blockedCount ->
    *[other] { DATETIME($date, month: "long", year: "numeric") } 以降、{ -brand-short-name } は <b>{ $blockedCount } 個</b>以上のトラッカーをブロックしました！
  }
cfr-doorhanger-milestone-ok-button = 確認
  .accesskey = S

## What’s New Panel Content for Firefox 76

## Lockwise message

cfr-whatsnew-lockwise-header = 安全なパスワードを簡単に作成
cfr-whatsnew-lockwise-body = アカウントごとに安全でユニークなパスワードを考えるのは難しいです。パスワードを作成するときは、安全にしたいパスワードの入力欄を選択して、{ -brand-shorter-name } からパスワードを生成しましょう。
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } アイコン

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = 脆弱なパスワードを警告します
cfr-whatsnew-passwords-body = ハッカーはよく使い回されるパスワードを知っています。複数のサイトで同じパスワードが使われていて、そのどれか一つでもデータ漏洩があったときは、{ -lockwise-brand-short-name } でそれらのサイトのパスワードを変更するよう警告します。
cfr-whatsnew-passwords-icon-alt = 脆弱なパスワードの鍵アイコン

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = 全画面表示でながら見
cfr-whatsnew-pip-fullscreen-body = 動画だけを別のウィンドウで再生しているとき、ダブルクリックすると全画面表示になります。
cfr-whatsnew-pip-fullscreen-icon-alt = ピクチャーインピクチャーアイコン

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = 閉じる
  .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = パスワードを一発保護
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
cfr-whatsnew-protections-body = プライバシー保護ダッシュボードにデータ漏洩とパスワード管理についての概要報告が含まれるようになりました。解決済みの漏洩データ数の追跡が可能で、漏洩データに保存されたパスワードが含まれているかどうかも確認できます。
cfr-whatsnew-protections-cta-link = プライバシー保護ダッシュボードを表示
cfr-whatsnew-protections-icon-alt = 盾アイコン

## Better PDF message

cfr-whatsnew-better-pdf-header = より良い PDF 表示
cfr-whatsnew-better-pdf-body = ワークフローから外れないように、PDF ドキュメントを直接  { -brand-short-name } で開くようになりました。

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = こっそり追跡を自動的に遮断
cfr-whatsnew-clear-cookies-body = 一部のトラッカーは、Cookie を密かに設定した別のウェブサイトにあなたを誘導します。{ -brand-short-name } はこれらの Cookie を自動的に消去し、追跡されないようにします。
cfr-whatsnew-clear-cookies-image-alt = Cookie ブロックのイラスト

## What's new: Media controls message

cfr-whatsnew-media-keys-header = メディアの操作が充実
cfr-whatsnew-media-keys-body = キーボードやヘッドセットから音声または映像の再生と停止ができるようになり、他のタブからだけでなく、コンピューターがロックされた状態でも簡単にメディアを操作できます。また、進むキーと戻るキーでもトラックを移動できるようになりました。
cfr-whatsnew-media-keys-button = 詳細

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = アドレスバーに検索ショートカット
cfr-whatsnew-search-shortcuts-body = アドレスバーに検索エンジンまたは特定のサイトを入力すると、検索候補の下に青いショートカットが表示されるようになりました。ショートカットを選択すると、アドレスバーからすぐに検索できます。

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = 悪意のある supercookie を遮断
cfr-whatsnew-supercookies-body = ウェブサイトは密かに “supercookie” を発行して、あなたが手動で Cookie を消去しない限りウェブであなたを追跡できます。{ -brand-short-name } は supercookie に対する強固な保護を提供し、サイトをまたがってあなたのオンラインの行動を追跡できないようにします。

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = よりよいブックマーク登録
cfr-whatsnew-bookmarking-body = お気に入りのサイトの管理が簡単になりました。{ -brand-short-name } は保存したブックマークをあなたの好きな場所に記憶し、既定の設定では新しいタブにブックマークツールバーを表示し、ツールバーのフォルダーから他のブックマークにもアクセスできるようになりました。

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = クロスサイトトラッキング Cookie からの包括的な保護
cfr-whatsnew-cross-site-tracking-body = トラッキング Cookie からのよりよい保護を任意で利用できるようになりました。{ -brand-short-name} があなたの行動と個人データを閲覧中のサイトから分離するため、ブラウザーに保存された情報はウェブサイト間で共有されません。

## Full Video Support CFR message

cfr-doorhanger-video-support-body = このバージョンの { -brand-short-name } では、このサイトの動画を正しく再生できません。今すぐ、動画に完全対応する { -brand-short-name } に更新しましょう。
cfr-doorhanger-video-support-header = { -brand-short-name } を更新して動画を再生
cfr-doorhanger-video-support-primary-button = 今すぐ更新
  .accesskey = U
