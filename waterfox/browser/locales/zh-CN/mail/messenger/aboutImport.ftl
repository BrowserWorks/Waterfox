# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = 导入
export-page-title = 导出

## Header

import-start = 导入工具
import-start-title = 从应用程序或文件导入设置或数据。
import-from-app = 从应用程序导入
import-file = 从文件导入
import-file-title = 选择文件以导入其内容。
import-address-book-title = 导入通讯录文件
import-calendar-title = 导入日历文件
export-profile = 导出

## Buttons

button-back = 上一步
button-continue = 继续
button-export = 导出
button-finish = 完成

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple 邮件
source-seamonkey = 从已安装的 { app-name-seamonkey } 导入
source-seamonkey-description = 从 { app-name-seamonkey } 配置文件导入设置、过滤器、消息和其他数据。
source-outlook = 从 { app-name-outlook } 导入
source-outlook-description = 从 { app-name-outlook } 导入账户、通讯录和消息。
source-becky = 从 { app-name-becky } 导入
source-becky-description = 从 { app-name-becky }导入通讯录和消息。
source-apple-mail = 从 { app-name-apple-mail } 导入
source-apple-mail-description = 从 { app-name-apple-mail } 导入消息。
source-file2 = 从文件导入

## Import from file selections

file-profile2 = 导入备份配置文件
file-profile-description = 选择以前备份的 Thunderbird 配置文件 (.zip)
file-calendar = 导入日历
file-addressbook = 导入通讯录

## Import from app profile steps

from-app-thunderbird = 从 { app-name-thunderbird } 配置文件导入
from-app-seamonkey = 从 { app-name-seamonkey } 配置文件导入
from-app-outlook = 从 { app-name-outlook } 导入
from-app-becky = 从 { app-name-becky } 导入
from-app-apple-mail = 从 { app-name-apple-mail } 导入
profiles-pane-title-thunderbird = 从 { app-name-thunderbird } 配置文件导入设置和数据。
profiles-pane-title-seamonkey = 从 { app-name-seamonkey } 配置文件导入设置和数据。
profiles-pane-title-outlook = 从 { app-name-outlook } 导入数据。
profiles-pane-title-becky = 从 { app-name-becky } 导入数据。
profiles-pane-title-apple-mail = 从 { app-name-apple-mail } 导入消息。
profile-source = 从配置文件导入
profile-file-picker-directory = 选择配置文件目录
profile-file-picker-archive = 选择 <strong>ZIP</strong> 文件
profile-file-picker-archive-description = ZIP 文件必须小于 2GB。
profile-file-picker-archive-title = 选择 ZIP 文件（小于 2GB）
items-pane-title2 = 选择要导入的内容：
items-pane-profile-name = 配置文件名称：
items-pane-checkbox-accounts = 账户和设置
items-pane-checkbox-address-books = 通讯录
items-pane-checkbox-calendars = 日历
items-pane-checkbox-mail-messages = 邮件消息

## Import from address book file steps

addr-book-csv-file = Tab 键或逗号分隔文件（.csv、.tsv）
addr-book-ldif-file = LDIF 文件（.ldif）
addr-book-vcard-file = vCard 文件（.vcf、.vcard）
addr-book-sqlite-file = SQLite 数据库文件（.sqlite）
addr-book-mab-file = Mork 数据库文件（.mab）
addr-book-file-picker = 选择通讯录文件
addr-book-csv-field-map-title = 匹配字段名称
addr-book-csv-field-map-desc = 选择与来源字段对应的通讯录字段，可取消勾选不想导入的字段。
addr-book-directories-pane-source = 源文件：

## Import from calendar file steps

import-from-calendar-file-desc = 选择您要导入的 iCalendar（.ics）文件。
calendar-items-title = 选择要导入的项目。
calendar-items-loading = 正在加载项目…
calendar-items-filter-input =
    .placeholder = 过滤项目…
calendar-select-all-items = 全选
calendar-deselect-all-items = 取消全选

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = 导入中... { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = 导出中… { $progressPercent }
progress-pane-finished-desc2 = 完成。
error-pane-title = 错误
error-message-failed = 导入意外失败，错误控制台中可能提供有更多信息。
error-failed-to-parse-ics-file = 文件中未找到可导入项目。
error-export-failed = 导入意外失败，错误控制台中可能提供更多信息。
error-message-no-profile = 找不到配置文件。

## <csv-field-map> element

csv-first-row-contains-headers = 第一行包含字段名称
csv-source-field = 来源字段
csv-source-first-record = 第一条记录
csv-source-second-record = 第二条记录
csv-target-field = 通讯录字段

## Export tab

export-open-profile-folder = 打开配置文件夹
export-file-picker2 = 导出为 ZIP 文件
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = 要导入的数据
summary-pane-start = 开始导入
summary-pane-start-over = 重启导入工具

## Footer area

footer-help = 需要帮助？
footer-import-documentation = 导入文档
footer-export-documentation = 导出文档
footer-support-forum = 技术支持论坛

## Step navigation on top of the wizard pages

step-list =
    .aria-label = 导入步骤
step-confirm = 确认
# Variables:
# $number (number) - step number
step-count = { $number }
