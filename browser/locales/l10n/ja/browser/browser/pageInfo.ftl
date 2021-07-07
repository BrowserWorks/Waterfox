# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 540px;

copy =
    .key = C
menu-copy =
    .label = コピー
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = すべて選択
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = 一般
    .accesskey = G
general-title =
    .value = タイトル:
general-url =
    .value = アドレス:
general-type =
    .value = MIME タイプ:
general-mode =
    .value = 描画モード:
general-size =
    .value = サイズ:
general-referrer =
    .value = 参照元 URL:
general-modified =
    .value = 更新日時:
general-encoding =
    .value = テキストエンコーディング:
general-meta-name =
    .label = 名前
general-meta-content =
    .label = 値

media-tab =
    .label = メディア
    .accesskey = M
media-location =
    .value = アドレス (URL):
# media-text (^^; Associated Text
media-text =
    .value = 関連テキスト:
media-alt-header =
    .label = 代替テキスト
media-address =
    .label = URL
media-type =
    .label = 種類
media-size =
    .label = サイズ
media-count =
    .label = カウント
media-dimension =
    .value = 寸法:
media-long-desc =
    .value = 詳細説明:
media-save-as =
    .label = 名前を付けて保存...
    .accesskey = A
media-save-image-as =
    .label = 名前を付けて保存...
    .accesskey = e

perm-tab =
    .label = サイト別設定
    .accesskey = P
permissions-for =
    .value = 対象サイト:

security-tab =
    .label = セキュリティ
    .accesskey = S
security-view =
    .label = 証明書を表示...
    .accesskey = V
security-view-unknown = 不明
    .value = 不明
security-view-identity =
    .value = ウェブサイトの識別情報
security-view-identity-owner =
    .value = 運営者:
security-view-identity-domain =
    .value = ウェブサイト:
security-view-identity-verifier =
    .value = 認証局:
security-view-identity-validity =
    .value = 有効期限:
security-view-privacy =
    .value = プライバシーと履歴

security-view-privacy-history-value = 昨日までにこのサイトを表示したことがあるか
security-view-privacy-sitedata-value = このサイトはコンピューターに情報を保存しているか

security-view-privacy-clearsitedata =
    .label = Cookie とサイトデータを消去
    .accesskey = C

security-view-privacy-passwords-value = このサイトのパスワードを保存しているか

security-view-privacy-viewpasswords =
    .label = パスワードを表示...
    .accesskey = w
security-view-technical =
    .value = 技術情報

help-button =
    .label = ヘルプ

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = はい、Cookie と { $value } { $unit } のサイトデータ
security-site-data-only = はい、{ $value } { $unit } のサイトデータ

security-site-data-cookies-only = はい、Cookie のみ
security-site-data-no = いいえ

##

image-size-unknown = 不明
page-info-not-specified =
    .value = なし
not-set-alternative-text = なし
not-set-date = なし
media-img = 画像
media-bg-img = 背景画像
media-border-img = ボーダーの画像
media-list-img = リストのマーカー画像
media-cursor = カーソル
media-object = オブジェクト
media-embed = 埋め込みオブジェクト
media-link = アイコン
media-input = 入力
media-video = 動画
media-audio = 音声
saved-passwords-yes = はい
saved-passwords-no = いいえ

no-page-title =
    .value = ページタイトルなし:
general-quirks-mode =
    .value = Quirks (後方互換) モード
general-strict-mode =
    .value = Standards Compliant (標準準拠) モード
page-info-security-no-owner =
    .value = 検証され信頼できる運営者情報はありません
media-select-folder = 画像を保存するフォルダーを選択してください
media-unknown-not-cached =
    .value = 不明 (キャッシュなし)
permissions-use-default =
    .label = 標準設定を使用する
security-no-visits = いいえ

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value = Meta 要素一覧 ({ $tags } 要素)

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] いいえ
       *[other] はい、{ $visits } 回
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value = { $kb } KB ({ $bytes } バイト)

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value = { $type } 画像 (アニメーション, { $frames } フレーム)

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } 画像

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px ({ $scaledx }px × { $scaledy }px で表示)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = { $website } の画像をブロック
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = ページ情報 — { $website }
page-info-frame =
    .title = フレーム情報 — { $website }
