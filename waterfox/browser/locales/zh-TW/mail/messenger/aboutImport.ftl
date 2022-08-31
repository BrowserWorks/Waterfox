# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = 匯入
export-page-title = 匯出

## Header

import-start = 匯入工具
import-start-title = 從應用程式或檔案匯入設定或資料。
import-start-description = 請選擇要匯入的來源資料位置，稍後會再詢問您要匯入哪些資料。
import-from-app = 從應用程式匯入
import-file = 從檔案匯入
import-file-title = 請選擇要匯入內容的檔案。
import-file-description = 選擇匯入先前被分的設定檔、通訊錄或行事曆。
import-address-book-title = 匯入通訊錄檔案
import-calendar-title = 匯入行事曆檔案
export-profile = 匯出

## Buttons

button-back = 返回
button-continue = 繼續
button-export = 匯出
button-finish = 完成

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = 從另一套 { app-name-thunderbird } 匯入
source-thunderbird-description = 從 { app-name-thunderbird } 設定檔匯入設定、過濾器、訊息與其他資料。
source-seamonkey = 從安裝好的 { app-name-seamonkey } 匯入
source-seamonkey-description = 從 { app-name-seamonkey } 設定檔匯入設定、過濾器、訊息與其他資料。
source-outlook = 從 { app-name-outlook } 匯入
source-outlook-description = 從 { app-name-outlook } 匯入帳號、通訊錄與郵件訊息。
source-becky = 從 { app-name-becky } 匯入
source-becky-description = 從 { app-name-becky } 匯入帳號、通訊錄與郵件訊息。
source-apple-mail = 從 { app-name-apple-mail } 匯入
source-apple-mail-description = 從 { app-name-apple-mail } 匯入相關訊息。
source-file2 = 從檔案匯入
source-file-description = 請選擇檔案來匯入通訊錄、行事曆，或設定檔備份（ZIP 檔格式）。

## Import from file selections

file-profile2 = 匯入設定檔備份
file-profile-description = 請選擇先前備份的 Thunderbird 設定檔 (.zip)
file-calendar = 匯入行事曆
file-calendar-description = 請選擇先前匯出的行事曆或事件 (.ics)
file-addressbook = 匯入通訊錄
file-addressbook-description = 選擇包含先前匯出的通訊錄與聯絡人的備份檔

## Import from app profile steps

from-app-thunderbird = 從 { app-name-thunderbird } 設定檔匯入
from-app-seamonkey = 從 { app-name-seamonkey } 設定檔匯入
from-app-outlook = 從 { app-name-outlook } 匯入
from-app-becky = 從 { app-name-becky } 匯入
from-app-apple-mail = 從 { app-name-apple-mail } 匯入
profiles-pane-title-thunderbird = 從 { app-name-thunderbird } 設定檔匯入相關設定與資料。
profiles-pane-title-seamonkey = 從 { app-name-seamonkey } 設定檔匯入相關設定與資料。
profiles-pane-title-outlook = 從 { app-name-outlook } 匯入相關資料。
profiles-pane-title-becky = 從 { app-name-becky } 匯入相關資料。
profiles-pane-title-apple-mail = 從 { app-name-apple-mail } 匯入相關訊息。
profile-source = 從設定檔匯入
# $profileName (string) - name of the profile
profile-source-named = 從設定檔<strong>「{ $profileName }」</strong>匯入
profile-file-picker-directory = 請選擇設定檔資料夾
profile-file-picker-archive = 請選擇 <strong>ZIP</strong> 檔
profile-file-picker-archive-description = ZIP 檔必須小於 2GB。
profile-file-picker-archive-title = 請選擇 ZIP 檔（小於 2GB）
items-pane-title2 = 請選擇要匯入的項目:
items-pane-directory = 資料夾:
items-pane-profile-name = 設定檔名稱:
items-pane-checkbox-accounts = 帳號與設定
items-pane-checkbox-address-books = 通訊錄
items-pane-checkbox-calendars = 行事曆
items-pane-checkbox-mail-messages = 郵件訊息
items-pane-override = 將不會覆蓋現有的資料。

## Import from address book file steps

import-from-addr-book-file-description = 請選擇您通訊錄的檔案格式。
addr-book-csv-file = 逗點或 Tab 分隔文件（.csv、.tsv）
addr-book-ldif-file = LDIF 檔案（.ldif）
addr-book-vcard-file = vCard 檔案（.vcf、.vcard）
addr-book-sqlite-file = SQLite 資料庫檔案（.sqlite）
addr-book-mab-file = Mork 資料庫檔案（.mab）
addr-book-file-picker = 選擇通訊錄檔案
addr-book-csv-field-map-title = 對應欄位名稱
addr-book-csv-field-map-desc = 選擇來源欄位與通訊錄欄位之間的對應關係，可取消勾選不想匯入的欄位。
addr-book-directories-title = 請選擇要將選擇的資料匯入到哪裡
addr-book-directories-pane-source = 來源檔案:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = 建立名為<strong>「{ $addressBookName }」</strong>的新目錄
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = 將選擇的資料匯入「{ $addressBookName }」目錄
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = 將建立新的通訊錄「{ $addressBookName }」。

## Import from calendar file steps

import-from-calendar-file-desc = 請選擇您要匯入的 iCalendar（.ics）檔案。
calendar-items-title = 請選擇要匯入的項目。
calendar-items-loading = 正在載入項目…
calendar-items-filter-input =
    .placeholder = 過濾項目…
calendar-select-all-items = 選擇全部
calendar-deselect-all-items = 取消選擇全部
calendar-target-title = 請選擇要將選擇的項目匯入到哪裡。
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = 建立名為<strong>「{ $targetCalendar }」</strong>的新行事曆
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
       *[other] 將 { $itemCount } 個項目匯入到「{ $targetCalendar }」行事曆
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = 將建立名為「{ $targetCalendar }」的新行事曆。

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = 匯入中… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = 匯出中… { $progressPercent }
progress-pane-finished-desc2 = 完成。
error-pane-title = 錯誤
error-message-zip-file-too-big2 = 選擇的 ZIP 檔案大小超過 2GB。請先解壓縮，然後改匯入解壓縮的資料夾。
error-message-extract-zip-file-failed2 = ZIP 檔解壓縮失敗，請手動解壓縮，並重新匯入解開的資料夾。
error-message-failed = 發生未預期的匯入失敗，錯誤主控台中可能有更多資訊。
error-failed-to-parse-ics-file = 檔案中找不到可匯入的項目。
error-export-failed = 發生未預期的匯出失敗，錯誤主控台中可能有更多資訊。
error-message-no-profile = 找不到設定檔。

## <csv-field-map> element

csv-first-row-contains-headers = 第一行為標題
csv-source-field = 來源欄位
csv-source-first-record = 第一筆資料
csv-source-second-record = 第二筆資料
csv-target-field = 通訊錄欄位

## Export tab

export-profile-title = 將帳號、訊息、通訊錄、設定匯出成 ZIP 檔。
export-profile-description = 若您目前的設定檔超過 2GB，建議您手動備份。
export-open-profile-folder = 開啟設定檔目錄
export-file-picker2 = 匯出成 ZIP 檔
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = 要匯入的資料
summary-pane-start = 開始匯入
summary-pane-warning = 匯入完成後，需重新啟動 { -brand-product-name }。
summary-pane-start-over = 重新啟動匯入工具

## Footer area

footer-help = 需要幫忙嗎？
footer-import-documentation = 匯入文件
footer-export-documentation = 匯出文件
footer-support-forum = 技術支援討論區

## Step navigation on top of the wizard pages

step-list =
    .aria-label = 匯入步驟
step-confirm = 確認
# Variables:
# $number (number) - step number
step-count = { $number }
