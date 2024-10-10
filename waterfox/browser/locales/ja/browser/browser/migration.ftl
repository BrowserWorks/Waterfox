# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = 設定移行ウィザード
import-from =
    { PLATFORM() ->
        [windows] オプション、ブックマーク、履歴、パスワード、その他のデータをインポートする対象を選んでください:
       *[other] 設定、ブックマーク、履歴、パスワード、その他のデータをインポートする対象を選んでください:
    }
import-from-bookmarks = ブックマークをインポートする対象を選んでください:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = 設定をインポートしない
    .accesskey = D
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-opera =
    .label = Opera
    .accesskey = O
import-from-vivaldi =
    .label = Vivaldi
    .accesskey = V
import-from-brave =
    .label = Brave
    .accesskey = r
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
import-from-opera-gx =
    .label = Opera GX
    .accesskey = G
no-migration-sources = ブックマーク、履歴やパスワードなどのインポートする設定やデータを持つプログラムが見つかりませんでした。
import-source-page-title = 設定とデータのインポート
import-items-page-title = インポートする項目
import-items-description = インポートする項目を選択してください:
import-permissions-page-title = { -brand-short-name } に権限が必要
# Do not translate "Safari" (the name of the browser on Apple devices)
import-safari-permissions-string = macOS で Safari のデータにアクセスするには、{ -brand-short-name } に明示的な許可が必要です。[続行] をクリックして、表示される Finder のダイアログで “Safari” フォルダーを選択し、"開く" をクリックしてください。
import-migrating-page-title = インポートしています...
import-migrating-description = 次の項目を現在インポートしています...
import-select-profile-page-title = プロファイルの選択
import-select-profile-description = インポートするプロファイルを選択してください:
import-done-page-title = インポート完了
import-done-description = 次のデータが正常にインポートされました:
import-close-source-browser = 続ける前に、選択したブラウザーが閉じられていることを確認してください。
source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-chrome = Google Chrome
imported-safari-reading-list = リーディングリスト (Safari から)
imported-edge-reading-list = リーディングリスト (Edge から)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookie
browser-data-cookies-label =
    .value = Cookie
browser-data-history-checkbox =
    .label = { $browser ->
        [firefox] 履歴とブックマーク
       *[other] 表示履歴
    }
browser-data-history-label =
    .value = { $browser ->
        [firefox] 履歴とブックマーク
       *[other] 表示履歴
    }
browser-data-formdata-checkbox =
    .label = 入力フォームの履歴
browser-data-formdata-label =
    .value = 入力フォームの履歴
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = 保存されているパスワード
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = 保存されているパスワード
browser-data-bookmarks-checkbox =
    .label = { $browser ->
        [ie] お気に入り
        [edge] お気に入り
       *[other] ブックマーク
    }
browser-data-bookmarks-label =
    .value = { $browser ->
        [ie] お気に入り
        [edge] お気に入り
       *[other] ブックマーク
    }
browser-data-otherdata-checkbox =
    .label = その他のデータ
browser-data-otherdata-label =
    .label = その他のデータ
browser-data-session-checkbox =
    .label = ウィンドウとタブ
browser-data-session-label =
    .value = ウィンドウとタブ
browser-data-payment-methods-checkbox =
    .label = 支払い方法
browser-data-payment-methods-label =
    .value = 支払い方法
