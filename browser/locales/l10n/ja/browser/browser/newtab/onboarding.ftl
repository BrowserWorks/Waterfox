# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = 詳細
onboarding-button-label-get-started = はじめる

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } にようこそ
onboarding-welcome-body = ブラウザーを手に入れました。<br/>残りの { -brand-product-name } の製品も手に入れましょう。
onboarding-welcome-learn-more = 役立つ点についての詳細
onboarding-welcome-modal-get-body = ブラウザーをインストールできました。<br/>今すぐ { -brand-product-name } を最大限に活用しましょう。
onboarding-welcome-modal-supercharge-body = プライバシー保護を充実させましょう。
onboarding-welcome-modal-privacy-body = ブラウザーをインストールできました。プライバシー保護をさらに追加しましょう。
onboarding-welcome-modal-family-learn-more = { -brand-product-name } ファミリー製品について
onboarding-welcome-form-header = はじめる

onboarding-join-form-body = メールアドレスを入力すると参加できます。
onboarding-join-form-email =
    .placeholder = メールアドレスを入力してください
onboarding-join-form-email-error = 有効なメールアドレスが必要です
onboarding-join-form-legal = 進むと <a data-l10n-name="terms">利用規約</a> と <a data-l10n-name="privacy">プライバシーに関する通知</a> に同意したとみなします。
onboarding-join-form-continue = 続行

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = アカウントは登録済みですか？
# Text for link to submit the sign in form
onboarding-join-form-signin = ログイン

onboarding-start-browsing-button-label = ブラウジングを開始
onboarding-cards-dismiss =
    .title = 閉じる
    .aria-label = 閉じる

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span> にようこそ
onboarding-multistage-welcome-subtitle = 高速で安全、プライバシー第一の、非営利組織によるブラウザーです。
onboarding-multistage-welcome-primary-button-label = 初期設定を開始
onboarding-multistage-welcome-secondary-button-label = ログイン
onboarding-multistage-welcome-secondary-button-text = アカウントをお持ちですか？

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = パスワード、ブックマーク、<span data-l10n-name="zap">その他のデータ</span>を<br/>インポートしましょう。
onboarding-multistage-import-subtitle = その他のブラウザーからですか？ 簡単に { -brand-short-name } に持ち込めます。
onboarding-multistage-import-primary-button-label = インポートを開始
onboarding-multistage-import-secondary-button-label = 後で

# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = この端末から見つかったサイトを表示しています。{ -brand-short-name } は、あなたがこれらのサイトをインポートすることを選択しない限り、他のブラウザーからデータを保存または同期することはありません。

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = はじめる: { $current } / { $total } ページ

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = <span data-l10n-name="zap">テーマ</span>を選択してください
onboarding-multistage-theme-subtitle = テーマで { -brand-short-name } をパーソナライズできます
onboarding-multistage-theme-primary-button-label = テーマを保存
onboarding-multistage-theme-secondary-button-label = 後で

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 自動

# System refers to the operating system
onboarding-multistage-theme-description-automatic = システムのテーマを使用

onboarding-multistage-theme-label-light = Light
onboarding-multistage-theme-label-dark = Dark
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title = あなたの OS のボタン、メニュー、ウィンドウの外観を継承します
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }

# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title = 明るい外観のボタン、メニュー、ウィンドウを使用します
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }

# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title = 暗い外観のボタン、メニュー、ウィンドウを使用します
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }

# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title = カラフルな外観のボタン、メニュー、ウィンドウを使用します
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = あなたの OS のボタン、メニュー、ウィンドウの外観を継承します

# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = あなたの OS のボタン、メニュー、ウィンドウの外観を継承します

# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = 明るい外観のボタン、メニュー、ウィンドウを使用します

# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = 明るい外観のボタン、メニュー、ウィンドウを使用します

# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = 暗い外観のボタン、メニュー、ウィンドウを使用します

# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = 暗い外観のボタン、メニュー、ウィンドウを使用します

# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = カラフルな外観のボタン、メニュー、ウィンドウを使用します

# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = カラフルな外観のボタン、メニュー、ウィンドウを使用します

## Welcome full page string

onboarding-fullpage-welcome-subheader = できることを探し始めましょう。
onboarding-fullpage-form-email =
    .placeholder = あなたのメールアドレス...

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } をあなたとともに
onboarding-sync-welcome-content = すべての端末で、ブックマーク、履歴、パスワード、その他の設定を取得できます。
onboarding-sync-welcome-learn-more-link = Firefox アカウントに関する詳細情報

onboarding-sync-form-input =
    .placeholder = メールアドレス

onboarding-sync-form-continue-button = 続行
onboarding-sync-form-skip-login-button = この手順をスキップ

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = メールアドレスを入力してください
onboarding-sync-form-sub-header = { -sync-brand-name } の利用を続けるために必要です


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = ご使用の端末すべてのプライバシーを尊重する一連のツールを使いましょう。

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = 私たちが尊重する個人データ保護の約束: 最小限に、安全に。隠し事をしない。

onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = ご使用のどの端末の { -brand-product-name } でもブックマーク、パスワード、履歴などを共有できます。

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = 既知のデータ漏洩にあなたの個人情報が含まれていた場合に通知を受けられます。

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = 持ち出しできる保護されたパスワード管理ができます。


## These strings belong to the individual onboarding messages.

## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = 追跡からのユーザー保護
onboarding-tracking-protection-text2 = { -brand-short-name } はユーザーをオンラインで追跡するウェブサイトを抑止し、ウェブ上の広告による追跡を困難にします。
onboarding-tracking-protection-button2 = 仕組みについて

onboarding-data-sync-title = 設定もいつも一緒に
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = { -brand-product-name } をどこでも使えるように、ブックマーク、パスワードなどを同期しましょう。
onboarding-data-sync-button2 = { -sync-brand-short-name } にログイン

onboarding-firefox-monitor-title = データの漏洩に備えて
onboarding-firefox-monitor-text2 = { -monitor-brand-name } は既知のデータの漏洩にあなたのメールアドレスが使われたか監視し、新たな漏洩があったときに警告します。
onboarding-firefox-monitor-button = アカウント登録

onboarding-browse-privately-title = プライベートブラウジング
onboarding-browse-privately-text = プライベートブラウジングは検索履歴と閲覧履歴を消去し、あなたのコンピューターの他のユーザーから秘密を守ります。
onboarding-browse-privately-button = プライベートウィンドウを開く

onboarding-firefox-send-title = 共有ファイルをプライベートに
onboarding-firefox-send-text2 = ファイルを { -send-brand-name } にアップロードすると、エンドツーエンド暗号化付きで共有できます。自動期限付きリンクも生成されます。
onboarding-firefox-send-button = { -send-brand-name } を試す

onboarding-mobile-phone-title = スマートフォンにも { -brand-product-name } を
onboarding-mobile-phone-text = { -brand-product-name } for iOS / Android をダウンロードして、端末間でデータを同期しましょう。
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = モバイル版ブラウザーをダウンロード

onboarding-send-tabs-title = 手軽にタブ送信
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = URL をコピーしたりブラウザーを切り替えたりせずに、端末間で簡単にページを共有できます。
onboarding-send-tabs-button = タブ送信を始めてみる

onboarding-pocket-anywhere-title = どこでも視聴
onboarding-pocket-anywhere-text2 = { -pocket-brand-name } アプリでお気に入りのコンテンツをオフラインに保存できます。後からいつでも読んだり視たりするのに便利です。
onboarding-pocket-anywhere-button = { -pocket-brand-name } を試す

onboarding-lockwise-strong-passwords-title = 強固なパスワードを作成、保存
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } は強固なパスワードをその場で作成し、一か所にすべて保存します。
onboarding-lockwise-strong-passwords-button = ログイン情報を管理

onboarding-facebook-container-title = Facebook に境界線を
onboarding-facebook-container-text2 = { -facebook-container-brand-name } を使うと Facebook プロファイルが隔離されるので、Facebook のターゲティング広告が機能しにくくなります。
onboarding-facebook-container-button = 拡張機能を追加

onboarding-import-browser-settings-title = ブックマークやパスワードなどをインポート
onboarding-import-browser-settings-text = すぐに飛び込もう - Chrome からサイトと設定を簡単に持ち込めます。
onboarding-import-browser-settings-button = Chrome からデータをインポートする

onboarding-personal-data-promise-title = プライバシー第一の設計
onboarding-personal-data-promise-text = { -brand-product-name } は、ユーザーデータの取得を最小限にし、それを保護し、使用目的を明確にすることにより、あなたのデータを尊重します。
onboarding-personal-data-promise-button = 私たちの誓約を確認する

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = おめでとうございます。{ -brand-short-name } をインストールできました。

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = <icon></icon><b>{ $addon-name } を今すぐインストールしましょう。</b>
return-to-amo-extension-button = 拡張機能を追加
return-to-amo-get-started-button = { -brand-short-name } を開始
