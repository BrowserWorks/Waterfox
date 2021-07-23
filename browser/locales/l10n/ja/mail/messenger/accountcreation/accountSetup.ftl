# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = アカウントのセットアップ

## Header

account-setup-title = 既存のメールアドレスのセットアップ
account-setup-description = 現在のメールアドレスを使用するには、そのアカウント情報を記入してください。<br/>
    { -brand-product-name } が自動的に有効なサーバー設定を検索します。

## Form fields

account-setup-name-label = あなたのお名前
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe
account-setup-name-info-icon =
    .title = 受信者に表示される名前です
account-setup-name-warning-icon =
    .title = お名前を入力してください
account-setup-email-label = メールアドレス
    .accesskey = E
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-email-info-icon =
    .title = 既存のメールアドレスです
account-setup-email-warning-icon =
    .title = メールアドレスが正しくありません
account-setup-password-label = パスワード
    .accesskey = P
    .title = 任意です。ユーザー名の検証にのみ使用されます
account-provisioner-button = 新しいメールアドレスを取得
    .accesskey = G
account-setup-password-toggle =
    .title = パスワードを表示または隠す
account-setup-remember-password = パスワードを記憶する
    .accesskey = m
account-setup-exchange-label = ログイン名
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = YOURDOMAIN\yourusername
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = ドメインへのログイン

## Action buttons

account-setup-button-cancel = キャンセル
    .accesskey = a
account-setup-button-manual-config = 手動設定
    .accesskey = m
account-setup-button-stop = 中止
    .accesskey = S
account-setup-button-retest = 再テスト
    .accesskey = t
account-setup-button-continue = 続ける
    .accesskey = C
account-setup-button-done = 完了
    .accesskey = D

## Notifications

account-setup-looking-up-settings = アカウント設定を検索しています...
account-setup-looking-up-settings-guess = アカウント設定の検索: 一般的なサーバー名で検索しています...
account-setup-looking-up-settings-half-manual = アカウント設定の検索: サーバーを調べています...
account-setup-looking-up-disk = アカウント設定の検索: { -brand-short-name } のインストールフォルダーから検索しています...
account-setup-looking-up-isp = アカウント設定の検索: メールプロバイダーから検索しています...
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = アカウント設定の検索: Mozilla ISP データベースから検索しています...
account-setup-looking-up-mx = アカウント設定の検索: 受信メールのドメインから検索しています...
account-setup-looking-up-exchange = アカウント設定の検索: Exchange サーバーから検索しています...
account-setup-checking-password = パスワードを確認しています...
account-setup-installing-addon = アドオンをダウンロードしてインストールしています...
account-setup-success-half-manual = 次のアカウント設定が、指定されたサーバーを調べることにより見つかりました:
account-setup-success-guess = アカウント設定が、一般的なサーバー名で検索したことにより見つかりました。
account-setup-success-guess-offline = 現在オフラインモードです。仮設定を行いましたが、正しい設定を入力してオンラインで確認する必要があります。
account-setup-success-password = パスワード OK
account-setup-success-addon = アドオンのインストールが完了しました
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = アカウント設定が Mozilla ISP データベースから見つかりました。
account-setup-success-settings-disk = アカウント設定が { -brand-short-name } のインストールフォルダーから見つかりました。
account-setup-success-settings-isp = アカウント設定がメールプロバイダーから見つかりました。
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = アカウント設定が Microsoft Exchange サーバーから見つかりました。

## Illustrations

account-setup-step1-image =
    .title = 初期セットアップ
account-setup-step2-image =
    .title = 読み込み中...
account-setup-step3-image =
    .title = 設定が見つかりました
account-setup-step4-image =
    .title = 接続エラー
account-setup-privacy-footnote = あなたの認証情報は私たちの <a data-l10n-name="privacy-policy-link">プライバシーポリシー</a> に従って使用され、ローカルのあなたのコンピュータにのみ保存されます。
account-setup-selection-help = どれを選択したらよいか分からないときは？
account-setup-selection-error = 助けが必要な方は？
account-setup-documentation-help = セットアップのドキュメント
account-setup-forum-help = サポートフォーラム

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] 利用可能な設定
        *[other] 利用可能な設定
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = フォルダーとメールがサーバー上で同期されます
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = フォルダーとメールがあなたのコンピュータに保存されます
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Microsoft Exchange サーバー
account-setup-incoming-title = 受信
account-setup-outgoing-title = 送信
account-setup-username-title = ユーザー名
account-setup-exchange-title = サーバー
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = 暗号化なし
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = 既存の送信 SMTP サーバーを使用
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = 受信: { $incoming }、送信: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = 認証に失敗しました。入力した認証情報が正しくないか、別のユーザー名でログインする必要があります。このユーザー名は Windows ドメインのログイン情報にドメイン名が付与されたものまたは付与されていないものです (例えば foxkeh または AD\\foxkeh)。
account-setup-credentials-wrong = 認証に失敗しました。ユーザー名とパスワードを確認してください。
account-setup-find-settings-failed = { -brand-short-name } がメールアカウントの設定を見つけられませんでした。
account-setup-exchange-config-unverifiable = 設定を検証できませんでした。ユーザー名とパスワードが正しい場合は、サーバー管理者があなたの選択した設定を無効化している可能性があります。別のプロトコルを選択してみてください。

## Manual configuration area

account-setup-manual-config-title = 手動設定
account-setup-incoming-server-legend = 受信サーバー
account-setup-protocol-label = プロトコル:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = ホスト名:
account-setup-port-label = ポート番号:
    .title = 自動検出するにはポート番号を 0 に設定してください
account-setup-auto-description = 空欄のフィールドは { -brand-short-name } が自動検出を試みます。
account-setup-ssl-label = 接続の保護:
account-setup-outgoing-server-legend = 送信サーバー

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = 自動検出
ssl-no-authentication-option = 認証なし
ssl-cleartext-password-option = 通常のパスワード認証
ssl-encrypted-password-option = 暗号化されたパスワード認証

## Incoming/Outgoing SSL options

ssl-noencryption-option = なし
account-setup-auth-label = 認証方式:
account-setup-username-label = ユーザー名:
account-setup-advanced-setup-button = 詳細設定
    .accesskey = A

## Warning insecure server dialog

account-setup-insecure-title = 警告！
account-setup-insecure-incoming-title = 受信設定:
account-setup-insecure-outgoing-title = 送信設定:

# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> への接続は暗号化されません。
account-setup-warning-cleartext-details = 安全でないメールサーバーは、あなたのパスワードやプライバシー情報を守るための暗号化された接続を行いません。このサーバーに接続することによって、あなたのパスワードやプライバシー情報が漏洩する可能性があります。
account-setup-insecure-server-checkbox = 接続する上での危険性を理解しました
    .accesskey = u
account-setup-insecure-description = 提供された設定を使用して { -brand-short-name } であなたのメールを受信することができます。ただし、これらの接続が不適当でないか、サーバーの管理者またはメールプロバイダーに問い合わせてください。詳しい情報は <a data-l10n-name="thunderbird-faq-link">Thunderbird FAQ</a> をご覧ください。
insecure-dialog-cancel-button = 設定を変更
    .accesskey = S
insecure-dialog-confirm-button = 確認
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } が { $domain } 上にあなたのアカウントセットアップ情報を見つけました。続けて認証情報を送信してもよろしいですか？
exchange-dialog-confirm-button = ログイン
exchange-dialog-cancel-button = キャンセル

## Alert dialogs

account-setup-creation-error-title = アカウント作成エラー
account-setup-error-server-exists = 受信サーバーの設定がすでに存在しています。
account-setup-confirm-advanced-title = 詳細設定の確認
account-setup-confirm-advanced-description = このダイアログを閉じると、設定内容が正しくなくても現在の設定でアカウントが作成されます。本当に続けますか？

## Addon installation section

account-setup-addon-install-title = インストール
account-setup-addon-install-intro = サードパーティのアドオンを利用することにより、このサーバー上のメールアカウントにアクセスできます:

account-setup-addon-no-protocol = このメールサーバーは、残念ながらオープンプロトコルに対応していません。{ account-setup-addon-install-intro }
