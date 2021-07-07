# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = WebExtension が chrome.storage.managed を経由してアクセス可能なポリシーを設定します。

policy-AppAutoUpdate = アプリケーションの自動更新を有効または無効にします。

policy-AppUpdateURL = アプリケーションのカスタム更新 URL を設定します。

policy-Authentication = ウェブサイトが対応する統合認証の設定を行います。

policy-BackgroundAppUpdate2 = バックグラウンド更新を有効または無効にします。

policy-BlockAboutAddons = アドオンマネージャー (about:addons) へのアクセスをブロックします。

policy-BlockAboutConfig = about:config ページへのアクセスをブロックします。

policy-BlockAboutProfiles = about:profiles ページへのアクセスをブロックします。

policy-BlockAboutSupport = about:support ページへのアクセスをブロックします。

policy-CaptivePortal = キャプティブポータルサポートを有効または無効にします。

policy-CertificatesDescription = 証明書を追加、または組み込みの証明書を利用します。

policy-Cookies = Cookie の保存をウェブサイトに許可または拒否します。

policy-DisableBuiltinPDFViewer = { -brand-short-name } 組み込みの PDF ビューアーの PDF.js を無効にします。

policy-DisabledCiphers = 暗号を無効にします。

policy-DefaultDownloadDirectory = 既定のダウンロードディレクトリーを設定します。

policy-DisableAppUpdate = { -brand-short-name } の更新を禁止します。

policy-DisableDefaultClientAgent = 既定のクライアントエージェントのアクションをすべて禁止します。Windows のみ有効です。他のプラットフォームにはエージェントがありません。

policy-DisableDeveloperTools = 開発ツールへのアクセスをブロックします。

policy-DisableFeedbackCommands = ヘルプメニューのフィードバックの送信 (フィードバックと詐欺サイトの報告の送信) を無効にします。

policy-DisableForgetButton = [忘れる] ボタンへのアクセスを禁止します。

policy-DisableFormHistory = 検索とフォームの入力履歴を記憶しないようにします。

policy-DisableMasterPasswordCreation = true の場合、マスターパスワードを作成できません。

policy-DisablePasswordReveal = 保存されたパスワードの開示を許可しないようにします。

policy-DisableProfileImport = メニューコマンド [他のプログラムからデータをインポート] を無効にします。

policy-DisableSafeMode = セーフモードで再起動する機能を無効にします。注意: Shift キーでセーフモードを起動する機能は、Windows でグループポリシーを利用する場合のみ無効にできます。

policy-DisableSecurityBypass = ユーザーが特定のセキュリティ警告を回避できないようにします。

policy-DisableSystemAddonUpdate = { -brand-short-name } のシステムアドオンのインストールと更新を禁止します。

policy-DisableTelemetry = Telemetry をオフにします。

policy-DisplayMenuBar = メニューバーを既定で表示します。

policy-DNSOverHTTPS =  DNS over HTTPS の設定を指示します。

policy-DontCheckDefaultClient = 起動時に既定のクライアントか確認する機能を無効にします。

policy-DownloadDirectory = ダウンロードディレクトリーを設定し、ロックします。

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = コンテンツブロッキングを有効または無効にし、任意で設定をロックします。

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Encrypted Media Extensions を有効または無効にし、任意で設定をロックします。

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = 拡張機能をインストール、削除、またはロックします。インストールは URL とパスを指定します。削除とロックは拡張機能の ID を指定します。

policy-ExtensionSettings = 拡張機能のインストール全般を管理します。

policy-ExtensionUpdate = 拡張機能の自動更新を有効または無効にします。

policy-Handlers = 既定のアプリケーションハンドラーを設定します。

policy-HardwareAcceleration = false の場合、ハードウェアアクセラレーションをオフにします。

policy-InstallAddonsPermission = 特定のウェブサイトにアドオンのインストールを許可します。

policy-LegacyProfiles = インストールごとにプロファイルが分割されるのを強制的に無効にします。

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = 従来の SameSite Cookie の動作設定を既定で有効にします。

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = 特定のサイトでは従来の SameSite Cookie の動作に戻します。

##

policy-LocalFileLinks = 特定のウェブサイトにローカルファイルへのリンクを許可します。

policy-ManualAppUpdateOnly = 更新を手動のみにし、ユーザーに更新を通知しないようにします。

policy-NetworkPrediction = 先読み機能 (DNS プリフェッチ) を有効または無効にします。

policy-OfferToSaveLogins = { -brand-short-name } に保存したログイン情報とパスワードを利用する設定を強制します。値は true か false を設定します。

policy-OfferToSaveLoginsDefault = { -brand-short-name } に保存したログイン情報とパスワードを利用する設定の既定値を設定します。値は true か false を設定します。

policy-OverrideFirstRunPage = 初回起動時に表示されるページを上書きします。初回起動時のページを無効にする場合は、このポリシーの設定をブランクにします。

policy-OverridePostUpdatePage = 更新後に表示される更新情報ページを上書きします。更新後のページを無効にするには、このポリシーの設定をブランクにします。

policy-PasswordManagerEnabled = パスワードマネージャーへのパスワードの保存を有効にします。

# PDF.js and PDF should not be translated
policy-PDFjs = { -brand-short-name } の組み込み PDF ビューアー PDF.js を無効化または設定します。

policy-Permissions2 = カメラ、マイク、位置情報、通知、自動再生の許可設定を変更します。

policy-Preferences = 設定のサブセットに対する値を設定してロックします。

policy-PrimaryPassword = マスターパスワードの使用を要求または抑止します。

policy-PromptForDownloadLocation = ダウンロード時にファイルの保存先を確認します。

policy-Proxy = プロキシーの設定を指示します。

policy-RequestedLocales = アプリケーションに要求される言語リストと優先順位を設定します。

policy-SanitizeOnShutdown2 = 終了時にナビゲーションデータを消去します。

policy-SearchEngines = 検索エンジンの設定を指示します。このポリシーは延長サポート版 (ESR) のみ有効です。

policy-SearchSuggestEnabled = 検索候補の表示機能を有効または無効にします。

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 モジュールをインストールします。

policy-SSLVersionMax = SSL の最高バージョンを設定します。

policy-SSLVersionMin = SSL の最低バージョンを設定します。

policy-SupportMenu = ヘルプメニューにカスタムサポートメニューを追加します。

policy-UserMessaging = 特定のメッセージをユーザーに表示しません。

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = ウェブサイトを訪問済みにしません。書式の詳細はドキュメントをご覧ください。
