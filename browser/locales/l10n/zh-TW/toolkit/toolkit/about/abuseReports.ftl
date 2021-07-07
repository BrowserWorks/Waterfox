# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = 回報 { $addon-name }

abuse-report-title-extension = 回報此擴充套件給 { -vendor-short-name }
abuse-report-title-theme = 回報此佈景主題給 { -vendor-short-name }
abuse-report-subtitle = 有什麼問題？

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = by <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = 不確定要選擇哪項嗎？<a data-l10n-name="learnmore-link">了解關於回報擴充套件與佈景主題的相關資訊</a>

abuse-report-submit-description = 請描述問題（選填）
abuse-report-textarea =
    .placeholder = 如果有更多細節，我們可以比較簡單就找到問題的根源。請描述您遇到了哪些問題，也非常感謝您協助我們，確保網路環境的健康。
abuse-report-submit-note = 註: 請不要在回報內容中放入個人資訊（姓名、E-Mail 信箱、電話號碼、地址等）。{ -vendor-short-name } 會永久保留回報內容的相關紀錄。

## Panel buttons.

abuse-report-cancel-button = 取消
abuse-report-next-button = 下一頁
abuse-report-goback-button = 上一頁
abuse-report-submit-button = 送出

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = 已取消回報 <span data-l10n-name="addon-name">{ $addon-name }</span>。
abuse-report-messagebar-submitting = 正在傳送 <span data-l10n-name="addon-name">{ $addon-name }</span> 的報告。
abuse-report-messagebar-submitted = 感謝您回報。您想要移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 嗎？
abuse-report-messagebar-submitted-noremove = 感謝您回報。
abuse-report-messagebar-removed-extension = 感謝您回報。已移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 擴充套件。
abuse-report-messagebar-removed-theme = 感謝您回報。已移除 <span data-l10n-name="addon-name">{ $addon-name }</span> 佈景主題。
abuse-report-messagebar-error = 傳送<span data-l10n-name="addon-name">{ $addon-name }</span> 的報告時，發生錯誤。
abuse-report-messagebar-error-recent-submit = 由於最近傳送過另一份報告，並未傳送 <span data-l10n-name="addon-name">{ $addon-name }</span> 的報告。

## Message bars actions.

abuse-report-messagebar-action-remove-extension = 好，移除它
abuse-report-messagebar-action-keep-extension = 不用，請保留
abuse-report-messagebar-action-remove-theme = 好，移除它
abuse-report-messagebar-action-keep-theme = 不用，請保留
abuse-report-messagebar-action-retry = 重試
abuse-report-messagebar-action-cancel = 取消

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = 它破壞了我的電腦或洩漏我的資料
abuse-report-damage-example = 例如: 安裝有害軟體，或竊取電腦資料

abuse-report-spam-reason-v2 = 它包含垃圾內容或插入多餘的廣告
abuse-report-spam-example = 例如: 在網頁中插入廣告

abuse-report-settings-reason-v2 = 它沒有先詢問我或預先通知，就更改了我的搜尋引擎、首頁、新分頁頁面
abuse-report-settings-suggestions = 回報問題前，您可以嘗試調整瀏覽器設定:
abuse-report-settings-suggestions-search = 更改您的預設搜尋設定
abuse-report-settings-suggestions-homepage = 更改您的首頁與新分頁頁面

abuse-report-deceptive-reason-v2 = 它偽裝成與其無關的東西
abuse-report-deceptive-example = 例如: 在描述中誤導使用者，或使用誤導圖片

abuse-report-broken-reason-extension-v2 = 它無法正常運作、造成網站無法運作、拖慢 { -brand-product-name }
abuse-report-broken-reason-theme-v2 = 它無法運作或破壞瀏覽器顯示內容
abuse-report-broken-example = 例如: 某些功能運作很慢、很難或無法使用，或是造成某些網站中的一部分無法載入，或看起來不正常
abuse-report-broken-suggestions-extension = 聽起來您遇到 Bug 了。除了在此回報之外，能夠解決功能問題的最佳方式是直接連絡擴充套件的開發者。<a data-l10n-name="support-link">請造訪擴充套件網站</a>來取得開發者的連絡資訊。
abuse-report-broken-suggestions-theme = 聽起來您遇到 Bug 了。除了在此回報之外，能夠解決功能問題的最佳方式是直接連絡佈景主題的開發者。<a data-l10n-name="support-link">請造訪佈景主題網站</a>來取得開發者的連絡資訊。

abuse-report-policy-reason-v2 = 它散播仇恨、暴力、非法內容
abuse-report-policy-suggestions = 註: 若有著作權與商標問題，請依另一個流程處理。<a data-l10n-name="report-infringement-link">請依照本文當中的指示</a>來回報問題。

abuse-report-unwanted-reason-v2 = 我從未安裝此套件，也不知道如何移除
abuse-report-unwanted-example = 例如: 電腦上的某套應用程式未經我同意就安裝了這個套件

abuse-report-other-reason = 其他原因

