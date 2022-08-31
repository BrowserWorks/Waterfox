# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = 設定とデータのインポート
export-page-title = エクスポート

## Header

import-start = インポートツール
import-start-title = 設定やデータをプログラムまたはファイルからインポートします。
import-start-description = インポート元のソースを選択してください。インポートする必要のあるデータは後で選べます。
import-from-app = プログラムからインポート
import-file = ファイルからインポート
import-file-title = インポートするファイルのコンテンツの種類を選択してください。
import-file-description = 以前バックアップしたプロファイル、アドレス帳、カレンダーから選んでください。
import-address-book-title = アドレス帳ファイルをインポート
import-calendar-title = カレンダーファイルをインポート
export-profile = エクスポート

## Buttons

button-back = 戻る
button-continue = 次へ
button-export = エクスポート
button-finish = 完了

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = 別にインストールした { app-name-thunderbird } からインポートする
source-thunderbird-description = 別にインストールした { app-name-thunderbird } プロファイルから設定、フィルター、メッセージおよび他のデータをインポートします。
source-seamonkey = { app-name-seamonkey } からインポートする
source-seamonkey-description = { app-name-seamonkey } プロファイルから設定、フィルター、メッセージおよび他のデータをインポートします。
source-outlook = { app-name-outlook } からインポートする
source-outlook-description = { app-name-outlook } からアカウント、アドレス帳およびメッセージをインポートします。
source-becky = { app-name-becky } からインポートする
source-becky-description = { app-name-becky } からアドレス帳およびメッセージをインポートします。
source-apple-mail = { app-name-apple-mail } からインポートする
source-apple-mail-description = { app-name-apple-mail } からメッセージをインポートします。
source-file2 = ファイルからインポートする
source-file-description = ファイルを選択してアドレス帳、カレンダー、またはプロファイルのバックアップ (ZIP ファイル) をインポートします。

## Import from file selections

file-profile2 = バックアップしたプロファイルをインポートする
file-profile-description = 以前にバックアップ保存した Thunderbird プロファイル (.zip) を選択します
file-calendar = カレンダーをインポートする
file-calendar-description = エクスポートしたカレンダーまたは予定 (.ics) を含むファイルを選択します
file-addressbook = アドレス帳をインポートする
file-addressbook-description = エクスポートしたアドレス帳および連絡先を含むファイルを選択します

## Import from app profile steps

from-app-thunderbird = { app-name-thunderbird } プロファイルからのインポート
from-app-seamonkey = { app-name-seamonkey } プロファイルからのインポート
from-app-outlook = { app-name-outlook } からのインポート
from-app-becky = { app-name-becky } からのインポート
from-app-apple-mail = { app-name-apple-mail } からのインポート
profiles-pane-title-thunderbird = { app-name-thunderbird } プロファイルから設定とデータをインポートします。
profiles-pane-title-seamonkey = { app-name-seamonkey } プロファイルから設定とデータをインポートします。
profiles-pane-title-outlook = { app-name-outlook } からデータをインポートします。
profiles-pane-title-becky = { app-name-becky } からデータをインポートします。
profiles-pane-title-apple-mail = { app-name-apple-mail } からメッセージをインポートします。
profile-source = プロファイルからインポート
# $profileName (string) - name of the profile
profile-source-named = <strong>"{ $profileName }"</strong> プロファイルからインポートする
profile-file-picker-directory = プロファイルフォルダーを選択する
profile-file-picker-archive = <strong>ZIP</strong> ファイルを選択する
profile-file-picker-archive-description = ZIP ファイルのサイズは 2GB までです。
profile-file-picker-archive-title = ZIP ファイルの選択 (2GB サイズ制限)
items-pane-title2 = インポートするコンテンツを選んでください:
items-pane-directory = ディレクトリー:
items-pane-profile-name = プロファイル名:
items-pane-checkbox-accounts = アカウントと設定
items-pane-checkbox-address-books = アドレス帳
items-pane-checkbox-calendars = カレンダー
items-pane-checkbox-mail-messages = メールメッセージ
items-pane-override = 既存のデータや同一のデータは上書きされません。

## Import from address book file steps

import-from-addr-book-file-description = アドレス帳データを含むファイルの形式を選択してください。
addr-book-csv-file = カンマまたはタブ区切りのファイル (.csv, .tsv)
addr-book-ldif-file = LDIF ファイル (.ldif)
addr-book-vcard-file = vCard ファイル (.vcf, .vcard)
addr-book-sqlite-file = SQLite データベースファイル (.sqlite)
addr-book-mab-file = Mork データベースファイル (.mab)
addr-book-file-picker = アドレス帳ファイルを選択する
addr-book-csv-field-map-title = 項目名の割り当て
addr-book-csv-field-map-desc = アドレス帳の項目に対応するソースの項目を選択してください。インポートしない項目はチェックを外してください。
addr-book-directories-title = 選んだデータのインポート先を選択してください
addr-book-directories-pane-source = ソースファイル:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = <strong>"{ $addressBookName }"</strong> という名前の新しいディレクトリーを作成します
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = 選んだデータを "{ $addressBookName }" ディレクトリーにインポートします
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = "{ $addressBookName }" という名前の新しいアドレス帳が作成されます。

## Import from calendar file steps

import-from-calendar-file-desc = インポートする iCalendar (.ics) ファイルを選択してください。
calendar-items-title = インポートする項目を選択してください。
calendar-items-loading = 項目の読み込み中...
calendar-items-filter-input =
    .placeholder = 項目の絞り込み...
calendar-select-all-items = すべて選択
calendar-deselect-all-items = @@すべての選択を解除@@
calendar-target-title = 選んだ項目のインポート先を選択してください
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = <strong>"{ $targetCalendar }"</strong> という名前の新しいカレンダーを作成します
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] "{ $targetCalendar }" カレンダーに 1 個の項目をインポートします
       *[other] "{ $targetCalendar }" カレンダーに { $itemCount } 個の項目をインポートします
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = "{ $targetCalendar }" という名前の新しいカレンダーが作成されます。

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = インポート中... { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = エクスポート中... { $progressPercent }
progress-pane-finished-desc2 = 完了。
error-pane-title = エラー
error-message-zip-file-too-big2 = 選択された ZIP ファイルのサイズが 2GB を超えています。まず ZIP ファイルを展開し、その展開したフォルダーからデータをインポートしてください。
error-message-extract-zip-file-failed2 = ZIP ファイルの展開に失敗しました。手動で ZIP ファイルを展開し、その展開したフォルダーからデータをインポートしてください。
error-message-failed = 予期せずインポートに失敗しました。エラーの詳細はエラーコンソールに出力されています。
error-failed-to-parse-ics-file = ファイルにインポート可能な項目が見つかりませんでした。
error-export-failed = 予期せずエクスポートに失敗しました。エラーの詳細はエラーコンソールに出力されています。
error-message-no-profile = プロファイルが見つかりませんでした。

## <csv-field-map> element

csv-first-row-contains-headers = 先頭行に項目名を含む
csv-source-field = ソースの項目
csv-source-first-record = 最初のレコード
csv-source-second-record = 2 番目のレコード
csv-target-field = アドレス帳の項目

## Export tab

export-profile-title = アカウント、メッセージ、アドレス帳、設定を 1 個の ZIP ファイルにエクスポートします。
export-profile-description = 現在のプロファイルのサイズが 2GB より大きいときは、ご自身でバックアップされることをおすすめします。
export-open-profile-folder = プロファイルフォルダーを開く
export-file-picker2 = ZIP ファイルへのエクスポート
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = インポートされるデータ
summary-pane-start = インポート開始
summary-pane-warning = インポート完了後に { -brand-product-name } を再起動する必要があります。
summary-pane-start-over = インポートツールを再開

## Footer area

footer-help = 助けが必要な場合は？
footer-import-documentation = インポートのドキュメント
footer-export-documentation = エクスポートのドキュメント
footer-support-forum = サポートフォーラム

## Step navigation on top of the wizard pages

step-list =
    .aria-label = インポートの手順
step-confirm = 確認
# Variables:
# $number (number) - step number
step-count = { $number }
