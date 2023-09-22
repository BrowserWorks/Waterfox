# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = { -glean-brand-name } Debug Ping 檢視器

about-glean-page-title2 = 關於 { -glean-brand-name }
about-glean-header = 關於 { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    是一套 { -vendor-short-name } 專案所使用的資料收集程式庫。本介面是設計來讓開發者與測試者能夠手動<a data-l10n-name="fog-link">操作測試</a>。

about-glean-upload-enabled = 已啟用資料上傳。
about-glean-upload-disabled = 已停用資料上傳。
about-glean-upload-enabled-local = 僅允許資料上傳至本機伺服器。
about-glean-upload-fake-enabled = 已停用資料上傳，但我們告訴 { glean-sdk-brand-name } 本功能仍然啟用，這樣才可在本機紀錄資料。註：若您設定了除錯標籤，將無視設定一律將 ping 上傳至 <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a>。

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = 相關的<a data-l10n-name="fog-prefs-and-defines-doc-link">偏好設定與軟體定義</a>包含：
# Variables:
#   $data-upload-pref-value (String): the value of the datareporting.healthreport.uploadEnabled pref. Typically "true", sometimes "false"
# Do not translate strings between <code> </code> tags.
about-glean-data-upload = <code>datareporting.healthreport.uploadEnabled</code>: { $data-upload-pref-value }
# Variables:
#   $local-port-pref-value (Integer): the value of the telemetry.fog.test.localhost_port pref. Typically 0. Can be negative.
# Do not translate strings between <code> </code> tags.
about-glean-local-port = <code>telemetry.fog.test.localhost_port</code>: { $local-port-pref-value }
# Variables:
#   $glean-android-define-value (Boolean): the value of the MOZ_GLEAN_ANDROID define. Typically "false", sometimes "true".
# Do not translate strings between <code> </code> tags.
about-glean-glean-android = <code>MOZ_GLEAN_ANDROID</code>: { $glean-android-define-value }
# Variables:
#   $moz-official-define-value (Boolean): the value of the MOZILLA_OFFICIAL define.
# Do not translate strings between <code> </code> tags.
about-glean-moz-official = <code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = 關於測試
# This message is followed by a numbered list.
about-glean-manual-testing = 完整的操作教學文件撰寫於 <a data-l10n-name="fog-instrumentation-test-doc-link">{ -fog-brand-name } 測試文件</a>與 <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name } 文件</a>中。但簡單來說，如果要手動測試您的測試工具是否正常，應該：

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = （不送出任何 ping）
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = 在左方欄位填寫好記的除錯用標籤，這樣之後才能快速找到您的 ping。
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names = 請從左方清單選擇您的測試儀器所在的位置。若位於<a data-l10n-name="custom-ping-link">自訂 ping</a>，請選擇該項目；否則預設的 <code>event</code> 指標是 <code>event</code>，而其他所有指標的預設值為 <code>metrics</code> ping。
# An in-line check box precedes this string.
about-glean-label-for-log-pings = （若您也想要在送出 Ping 時紀錄下來，請勾選左邊的選取盒，非必選。另外還需要<a data-l10n-name="enable-logging-link">開啟記錄</a>。）
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit = 按下上方按鈕即可將所有 { -glean-brand-name } ping 加上您的標籤，並送出選擇的 ping。（按下按鈕後直到重新啟動應用程式前所送出的 ping 都將標上 <code>{ $debug-tag }</code>。）
about-glean-li-for-visit-gdpv = <a data-l10n-name="gdpv-tagged-pings-link">請到 { glean-debug-ping-viewer-brand-name }頁面即可檢視含有您指定標籤的 ping</a>。按下按鈕後的幾秒鐘後 ping 就應該出現，有時會需要稍等幾分鐘。

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation = 若需進行 <i>ad hoc 臨時測試</i>，也可以在 <code>about:glean</code> 本頁面開啟開發者主控台，使用 <code>Glean.metricCategory.metricName.testGetValue()</code> 等 <code>testGetValue()</code> API 來決定測試儀器中的特定值。


controls-button-label-verbose = 套用設定並送出 ping

about-glean-about-data-header = 關於資料
about-glean-about-data-explanation = 要瀏覽收集的資料清單，請參考 <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } 字典</a>。
