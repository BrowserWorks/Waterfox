# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = 閉じる
preferences-doc-title = 設定
category-list =
    .aria-label = カテゴリー
pane-general-title = 一般
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = 編集
category-compose =
    .tooltiptext = 編集
pane-privacy-title = プライバシーとセキュリティ
category-privacy =
    .tooltiptext = プライバシーとセキュリティ
pane-chat-title = チャット
category-chat =
    .tooltiptext = チャット
pane-calendar-title = カレンダー
category-calendar =
    .tooltiptext = カレンダー
general-language-and-appearance-header = 言語と外観
general-incoming-mail-header = 新着メールの通知
general-files-and-attachment-header = ファイルと添付
general-tags-header = タグ
general-reading-and-display-header = 既読と表示
general-updates-header = 更新
general-network-and-diskspace-header = ネットワークとディスク領域
general-indexing-label = 索引データベース
composition-category-header = 編集
composition-attachments-header = 添付ファイル
composition-spelling-title = スペルチェック
compose-html-style-title = HTML スタイル
composition-addressing-header = アドレス入力
privacy-main-header = プライバシー
privacy-passwords-header = パスワード
privacy-junk-header = 迷惑メール
collection-header = { -brand-short-name } のデータ収集と利用について
collection-description = 私たちはユーザーに選択肢を提供し、{ -brand-short-name } をすべての人に提供し改善するために必要なものだけを収集するよう努力しています。私たちは、個人情報を受け取る前に、常にユーザーの許可を求めます。
collection-privacy-notice = 個人情報保護方針
collection-health-report-telemetry-disabled = { -vendor-short-name } への技術的な対話データの送信の許可を取り消しました。過去のデータは 30 日以内にすべて削除されます。
collection-health-report-telemetry-disabled-link = 詳細情報
collection-health-report =
    .label = { -brand-short-name } が技術的な対話データを { -vendor-short-name } へ送信することを許可する
    .accesskey = r
collection-health-report-link = 詳細情報
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = このビルド設定ではヘルスレポートが無効化されています
collection-backlogged-crash-reports =
    .label = { -brand-short-name } があなたに代わって未送信のクラッシュレポートを送信することを許可する
    .accesskey = c
collection-backlogged-crash-reports-link = 詳細情報

privacy-security-header = セキュリティ
privacy-scam-detection-title = 詐欺メール
privacy-anti-virus-title = ウイルス対策
privacy-certificates-title = 証明書
chat-pane-header = チャット
chat-status-title = アカウントの状態
chat-notifications-title = 通知
chat-pane-styling-header = メッセージスタイル
choose-messenger-language-description = メニューやメッセージ、{ -brand-short-name } からの通知の表示に使用する言語を選んでください。
manage-messenger-languages-button =
    .label = 代替言語を設定...
    .accesskey = l
confirm-messenger-language-change-description = これらの変更を適用するには { -brand-short-name } を再起動してください
confirm-messenger-language-change-button = 適用して再起動
update-setting-write-failure-title = 変更した設定の保存エラー
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } がエラーに遭遇したため変更を保存できませんでした。この設定変更を保存するには、以下のファイルの書き込み権限が必要なことに注意してください。あなたかシステム管理者が、このファイルにユーザーグループのフルコントロール権限を与えると、エラーを解決できる可能性があります。
    
    ファイルに書き込みできません: { $path }
update-in-progress-title = 更新中
update-in-progress-message = この { -brand-short-name } の更新を続行しますか？
update-in-progress-ok-button = 破棄(&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = 続行(&C)
account-button = アカウント設定
open-addons-sidebar-button = アドオンとテーマ

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
# en-US: "Primary Password"
primary-password-os-auth-dialog-message-win = マスターパスワードを作成するには、Windows のログイン資格情報を入力してください。これはアカウントのセキュリティ保護に役立ちます。
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = マスターパスワードを作成
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name } スタートページ
start-page-label =
    .label = { -brand-short-name } の起動時にメッセージペインにスタートページを表示する
    .accesskey = W
location-label =
    .value = URL:
    .accesskey = o
restore-default-label =
    .label = 既定値に戻す
    .accesskey = R
default-search-engine = 既定の検索エンジン
add-search-engine =
    .label = ファイルから追加
    .accesskey = A
remove-search-engine =
    .label = 削除
    .accesskey = v
minimize-to-tray-label =
    .label = 最小化した { -brand-short-name } をタスクトレイにしまう
    .accesskey = m
new-message-arrival = 新着メッセージの通知
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] 次のサウンドファイルを鳴らす:
           *[other] 音を鳴らす
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = 再生
    .accesskey = P
change-dock-icon = アプリケーションアイコンの設定を変更します
app-icon-options =
    .label = アプリケーションアイコンのオプション...
    .accesskey = n
notification-settings = 通知と既定のサウンドはシステム環境設定の通知ペインで無効化できます。
animated-alert-label =
    .label = デスクトップ通知を表示する
    .accesskey = S
customize-alert-label =
    .label = カスタマイズ...
    .accesskey = C
biff-use-system-alert =
    .label = システムの通知を使用する
tray-icon-unread-label =
    .label = 未読メッセージのトレイアイコンを表示する
    .accesskey = t
tray-icon-unread-description = 小さいタスクバーボタンを使用する場合に推奨されます。
mail-system-sound-label =
    .label = 新着メールの既定のシステムサウンド
    .accesskey = D
mail-custom-sound-label =
    .label = 次のサウンドファイルを使用する:
    .accesskey = U
mail-browse-sound-button =
    .label = 参照...
    .accesskey = B
enable-gloda-search-label =
    .label = グローバル検索と索引データベースを有効にする
    .accesskey = G
datetime-formatting-legend = 日付と時刻の書式
language-selector-legend = 言語
allow-hw-accel =
    .label = ハードウェアアクセラレーション機能を使用する (可能な場合)
    .accesskey = h
store-type-label =
    .value = 新しいアカウントのメッセージ格納形式:
    .accesskey = T
mbox-store-label =
    .label = フォルダー単位 (mbox 形式)
maildir-store-label =
    .label = メッセージ単位 (maildir 形式)
scrolling-legend = スクロール
autoscroll-label =
    .label = 自動スクロール機能を使用する
    .accesskey = U
smooth-scrolling-label =
    .label = スムーズスクロール機能を使用する
    .accesskey = m
system-integration-legend = システム統合
always-check-default =
    .label = 起動時に { -brand-short-name } が既定のクライアントとして設定されているか確認する
    .accesskey = A
check-default-button =
    .label = 今すぐ確認...
    .accesskey = N
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
search-integration-label =
    .label = { search-engine-name } によるメッセージの検索を許可する
    .accesskey = S
config-editor-button =
    .label = 設定エディター...
    .accesskey = C
return-receipts-description = { -brand-short-name } の開封確認の取り扱い方を設定します。
return-receipts-button =
    .label = 開封確認...
    .accesskey = R
update-app-legend = { -brand-short-name } の更新
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = バージョン { $version }
allow-description = { -brand-short-name } の更新動作
automatic-updates-label =
    .label = 更新を自動的にインストールする (推奨: セキュリティ向上)
    .accesskey = A
check-updates-label =
    .label = 更新を確認するが、インストールするかどうかを選択する
    .accesskey = C
update-history-button =
    .label = 更新履歴を表示
    .accesskey = p
use-service =
    .label = 更新のインストールにバックグラウンドサービスを使用する
    .accesskey = b
cross-user-udpate-warning = この設定はすべての Windows アカウントと、このバージョンの { -brand-short-name } で使用するすべてのプロファイルに適用されます。
networking-legend = 接続
proxy-config-description = { -brand-short-name } のインターネットへの接続方式 (DNS over HTTPS、プロキシー) を設定します。
network-settings-button =
    .label = 接続設定...
    .accesskey = S
offline-legend = オフライン
offline-settings = オフライン時の動作を設定します。
offline-settings-button =
    .label = オフライン設定...
    .accesskey = O
diskspace-legend = ディスク領域
offline-compact-folder =
    .label = ディスク領域を合計
    .accesskey = a
offline-compact-folder-automatically =
    .label = 最適化する前に毎回確認する
    .accesskey = b
compact-folder-size =
    .value = MB 以上節約できるときはフォルダーを最適化する

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = ページキャッシュとして
    .accesskey = U
use-cache-after = MB まで使用する

##

smart-cache-label =
    .label = 自動キャッシュ管理設定を上書き
    .accesskey = v
clear-cache-button =
    .label = 今すぐ消去
    .accesskey = C
fonts-legend = フォントと配色
default-font-label =
    .value = 既定のフォント:
    .accesskey = D
default-size-label =
    .value = サイズ:
    .accesskey = S
font-options-button =
    .label = 詳細設定...
    .accesskey = A
color-options-button =
    .label = 配色設定...
    .accesskey = C
display-width-legend = プレーンテキストメッセージ
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = 顔文字をアイコンで表示する
    .accesskey = e
display-text-label = 引用されたテキストメッセージの表示:
style-label =
    .value = 書式:
    .accesskey = y
regular-style-item =
    .label = 標準
bold-style-item =
    .label = 太字
italic-style-item =
    .label = イタリック体
bold-italic-style-item =
    .label = 太字イタリック体
size-label =
    .value = サイズ:
    .accesskey = z
regular-size-item =
    .label = 標準
bigger-size-item =
    .label = 大きく
smaller-size-item =
    .label = 小さく
quoted-text-color =
    .label = 色:
    .accesskey = o
search-handler-table =
    .placeholder = ファイルの種類と動作設定の絞り込み
type-column-label = ファイルの種類
action-column-label = 動作設定
save-to-label =
    .label = 次のフォルダーに保存する:
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] 選択...
           *[other] 参照...
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
always-ask-label =
    .label = ファイルごとに保存先を指定する
    .accesskey = A
display-tags-text = タグを使ってメッセージを分類したり印を付けたりできます。
new-tag-button =
    .label = 新規...
    .accesskey = N
edit-tag-button =
    .label = 編集...
    .accesskey = E
delete-tag-button =
    .label = 削除
    .accesskey = D
auto-mark-as-read =
    .label = メッセージを自動的に既読にする
    .accesskey = A
mark-read-no-delay =
    .label = メッセージの表示直後に既読にする
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = メッセージを
    .accesskey = d
seconds-label = 秒間以上表示していたら既読にする

##

open-msg-label =
    .value = メッセージを次の場所に開く:
open-msg-tab =
    .label = 新しいタブ
    .accesskey = t
open-msg-window =
    .label = 新しいメッセージウィンドウ
    .accesskey = n
open-msg-ex-window =
    .label = 既存のメッセージウィンドウ
    .accesskey = e
close-move-delete =
    .label = 移動時または削除時にメッセージウィンドウまたはタブを閉じる
    .accesskey = C
display-name-label =
    .value = 表示名:
condensed-addresses-label =
    .label = アドレス帳に登録されている人については宛先フィールドで <メールアドレス> 部を表示しない
    .accesskey = S

## Compose Tab

forward-label =
    .value = 転送元のメッセージを:
    .accesskey = F
inline-label =
    .label = メール本文に含める
as-attachment-label =
    .label = ファイルとして添付
extension-label =
    .label = ファイル名に拡張子を付加する
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = 編集中のメッセージを
    .accesskey = A
auto-save-end = 分ごとに下書きとして自動保存する

##

warn-on-send-accel-key =
    .label = キーボードショートカットでメッセージを送信するときは確認する
    .accesskey = C
spellcheck-label =
    .label = 送信前にスペルチェックを行う
    .accesskey = C
spellcheck-inline-label =
    .label = 自動スペルチェックを有効にする
    .accesskey = E
language-popup-label =
    .value = 辞書の言語:
    .accesskey = L
download-dictionaries-link = スペルチェックに必要な辞書を追加する
font-label =
    .value = フォント:
    .accesskey = n
font-size-label =
    .value = サイズ:
    .accesskey = z
default-colors-label =
    .label = 既定の色を使用
    .accesskey = d
font-color-label =
    .value = 文字色:
    .accesskey = T
bg-color-label =
    .value = 背景色:
    .accesskey = B
restore-html-label =
    .label = 既定値に戻す
    .accesskey = R
default-format-label =
    .label = 既定で本文テキストの代わりに段落書式を使用する
    .accesskey = P
format-description = 送信するメッセージの形式を設定します。
send-options-label =
    .label = 送信テキスト形式...
    .accesskey = S
autocomplete-description = 以下に登録されているメールアドレスを宛先等の入力時に自動補完する:
ab-label =
    .label = ローカルのアドレス帳
    .accesskey = L
directories-label =
    .label = LDAP サーバー:
    .accesskey = D
directories-none-label =
    .none = なし
edit-directories-label =
    .label = LDAP サーバーの編集...
    .accesskey = E
email-picker-label =
    .label = メール送信時に受信者を次のアドレス帳に自動で追加する:
    .accesskey = A
default-directory-label =
    .value = アドレス帳ウィンドウの初期表示ディレクトリー:
    .accesskey = S
default-last-label =
    .none = 最後に使用したディレクトリー
attachment-label =
    .label = ファイルの添付忘れがないか確認する
    .accesskey = m
attachment-options-label =
    .label = キーワード...
    .accesskey = K
enable-cloud-share =
    .label = 次のサイズより大きなファイルの添付時にリンク共有する:
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = 追加...
    .accesskey = A
    .defaultlabel = 追加...
remove-cloud-account =
    .label = 削除
    .accesskey = R
find-cloud-providers =
    .value = 他のプロバイダーを検索...
cloud-account-description = 新しい Filelink ストレージサービスを追加してください。

## Privacy Tab

mail-content = メールコンテンツ
remote-content-label =
    .label = メッセージ内のリモートコンテンツを許可する
    .accesskey = m
exceptions-button =
    .label = 例外...
    .accesskey = E
remote-content-info =
    .value = リモートコンテンツのプライバシーに係わる問題について
web-content = ウェブコンテンツ
history-label =
    .label = 訪問したウェブサイトとリンクを記憶する
    .accesskey = R
cookies-label =
    .label = サイトから送られてきた Cookie を保存する
    .accesskey = A
third-party-label =
    .value = サードパーティ Cookie の保存:
    .accesskey = c
third-party-always =
    .label = 常に許可
third-party-never =
    .label = 常に拒否
third-party-visited =
    .label = 訪問したサイトのみ許可
keep-label =
    .value = Cookie を保存する期間:
    .accesskey = K
keep-expire =
    .label = サイトが指定した期限まで
keep-close =
    .label = { -brand-short-name } を終了するまで
keep-ask =
    .label = 毎回確認する
cookies-button =
    .label = Cookie を表示...
    .accesskey = S
do-not-track-label =
    .label = ウェブサイトに “Do Not Track” 信号を送り、追跡されたくないことを知らせます
    .accesskey = n
learn-button =
    .label = 詳細情報
passwords-description = { -brand-short-name } で利用するすべてのアカウントのパスワードを保存できます。
passwords-button =
    .label = 保存されているパスワード...
    .accesskey = S
# en-US: "Primary Password"
primary-password-description = マスターパスワードを使用すると、保存されたすべてのパスワードが保護されます。ただし、セッションごとに入力を求められます。
primary-password-label =
    .label = マスターパスワードを使用する
    .accesskey = U
primary-password-button =
    .label = マスターパスワードを変更...
    .accesskey = C
forms-primary-pw-fips-title = 現在 FIPS モードです。FIPS は空でないマスターパスワードを必要とします。
forms-master-pw-fips-desc = パスワードを変更できませんでした
junk-description = 既定の迷惑メールフィルターの動作を設定します。アカウントごとの迷惑メールフィルターの設定は [アカウント設定] で行います。
junk-label =
    .label = 迷惑メールであると手動でマークしたときに次の処理を実行する:
    .accesskey = W
junk-move-label =
    .label = “迷惑メール” フォルダーへ移動する
    .accesskey = o
junk-delete-label =
    .label = メッセージを削除する
    .accesskey = D
junk-read-label =
    .label = 迷惑メールと判断したメッセージを既読にする
    .accesskey = M
junk-log-label =
    .label = 迷惑メール適応フィルターのログを有効にする
    .accesskey = E
junk-log-button =
    .label = ログを表示
    .accesskey = S
reset-junk-button =
    .label = 判別基準データのリセット
    .accesskey = R
phishing-description = { -brand-short-name } がメッセージを解析して、フィッシング詐欺メールでよく使われる偽装手法が含まれているものを検出できます。
phishing-label =
    .label = 表示中のメッセージに詐欺メールの疑いがあるときに知らせる
    .accesskey = T
antivirus-description = { -brand-short-name } で受信したメッセージを、ローカルに保存する前にウイルス対策ソフトウェアに解析させ、感染したメッセージだけを処理できるようにします。
antivirus-label =
    .label = 受信したメッセージは個別の一時ファイルとして保存してからメールボックスに移動させる
    .accesskey = A
certificate-description = サーバーが個人証明書を要求したとき:
certificate-auto =
    .label = 自動的に選択する
    .accesskey = S
certificate-ask =
    .label = 毎回自分で選択する
    .accesskey = A
ocsp-label =
    .label = OCSP レスポンダーサーバーに問い合わせて証明書の現在の正当性を確認する
    .accesskey = Q
certificate-button =
    .label = 証明書を管理...
    .accesskey = M
security-devices-button =
    .label = セキュリティデバイス...
    .accesskey = D

## Chat Tab

startup-label =
    .value = { -brand-short-name } の起動時:
    .accesskey = s
offline-label =
    .label = チャットアカウントをオフラインにする
auto-connect-label =
    .label = チャットアカウントを自動的に接続する

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = 待機状態が
    .accesskey = I
idle-time-label = 分間続いたらそれを相手に知らせる

##

away-message-label =
    .label = さらに次のステータスメッセージを送信して離席状態にする:
    .accesskey = A
send-typing-label =
    .label = 会話中のタイピング通知を送信する
    .accesskey = t
notification-label = ダイレクトメッセージの通知:
show-notification-label =
    .label = デスクトップ通知の表示:
    .accesskey = c
notification-all =
    .label = 送信者の名前とメッセージプレビュー
notification-name =
    .label = 送信者の名前のみ
notification-empty =
    .label = 情報なし
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] ドックアイコンをアニメーション
           *[other] タスクバーアイテムを点滅
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = 音を鳴らす
    .accesskey = d
chat-play-button =
    .label = 再生
    .accesskey = P
chat-system-sound-label =
    .label = システムの新着メール通知音
    .accesskey = D
chat-custom-sound-label =
    .label = 次のサウンドファイルを使用する
    .accesskey = U
chat-browse-sound-button =
    .label = 参照...
    .accesskey = B
theme-label =
    .value = テーマ:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bubbles
style-dark =
    .label = Dark
style-paper =
    .label = Paper Sheets
style-simple =
    .label = Simple
preview-label = プレビュー:
no-preview-label = プレビューできません
no-preview-description = このテーマは正しくないか現在利用できません (理由: 無効化されたアドオン、セーフモードなど)。
chat-variant-label =
    .value = 色調:
    .accesskey = V
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = 設定を検索

## Preferences UI Search Results

search-results-header = 検索結果
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message = { PLATFORM() ->
    [windows] “<span data-l10n-name="query"></span>” オプションについての検索結果はありません。
    *[other] “<span data-l10n-name="query"></span>” 設定についての検索結果はありません。
}
search-results-help-link = 助けが必要な方は、<a data-l10n-name="url">{ -brand-short-name } サポート</a> をご利用ください
