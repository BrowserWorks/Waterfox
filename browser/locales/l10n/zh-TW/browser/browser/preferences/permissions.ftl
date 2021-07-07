# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = 例外網站
    .style = width: 45em

permissions-close-key =
    .key = w

permissions-address = 網站網址
    .accesskey = d

permissions-block =
    .label = 封鎖
    .accesskey = B

permissions-session =
    .label = 此次瀏覽階段允許
    .accesskey = S

permissions-allow =
    .label = 允許
    .accesskey = A

permissions-button-off =
    .label = 關閉
    .accesskey = O

permissions-button-off-temporarily =
    .label = 暫時關閉
    .accesskey = T

permissions-site-name =
    .label = 網站

permissions-status =
    .label = 狀態

permissions-remove =
    .label = 移除網站
    .accesskey = R

permissions-remove-all =
    .label = 移除所有網站
    .accesskey = e

permission-dialog =
    .buttonlabelaccept = 儲存變更
    .buttonaccesskeyaccept = S

permissions-autoplay-menu = 對所有網站的預設行為:

permissions-searchbox =
    .placeholder = 搜尋網站

permissions-capabilities-autoplay-allow =
    .label = 允許自動播放影音內容
permissions-capabilities-autoplay-block =
    .label = 封鎖音訊
permissions-capabilities-autoplay-blockall =
    .label = 封鎖影音內容

permissions-capabilities-allow =
    .label = 允許
permissions-capabilities-block =
    .label = 阻擋
permissions-capabilities-prompt =
    .label = 總是詢問

permissions-capabilities-listitem-allow =
    .value = 允許
permissions-capabilities-listitem-block =
    .value = 阻擋
permissions-capabilities-listitem-allow-session =
    .value = 此次瀏覽階段允許

permissions-capabilities-listitem-off =
    .value = 關閉
permissions-capabilities-listitem-off-temporarily =
    .value = 暫時關閉

## Invalid Hostname Dialog

permissions-invalid-uri-title = 輸入的主機名稱不正確
permissions-invalid-uri-label = 請輸入正確的主機名稱

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = 加強型追蹤保護的例外
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = 您已針對下列網站關閉保護。

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = 例外 - Cookie 與網站資料
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = 您可以指定哪些網站是否可以設定 Cookie 和儲存網站資料。請在下方輸入要指定的完整網址，然後點擊「封鎖」、「此次瀏覽階段允許」或「允許」。

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = 例外 - 純 HTTPS 模式
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = 您可以針對特定網站關閉純 HTTPS 模式。連線到這些網站時，{ -brand-short-name } 不會嘗試升級為安全的 HTTPS 連線。例外網站不會在隱私保護視窗中生效。

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = 允許彈出視窗的網站
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = 您可以指定哪些網站可以開啟彈出型視窗 (Pop-up)。請輸入完整網址後按「允許」。

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = 儲存的登入資訊 - 例外
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = 將不會儲存下列網站的登入資訊

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = 允許安裝附加元件的網站
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = 您可以指定哪些網站可以安裝附加元件。請輸入完整網址後按「允許」。

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = 設定 - 自動播放
    .style = { permissions-window.style }
permissions-site-autoplay-desc = 您可以在此處管理不遵守預設自動播放設定的網站。

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = 設定 - 通知權限
    .style = { permissions-window.style }
permissions-site-notification-desc = 下列網站要求傳送通知給您。您可指定允許哪些網站傳送通知，也可以封鎖新的通知傳送請求。
permissions-site-notification-disable-label =
    .label = 封鎖新網站傳送通知的請求
permissions-site-notification-disable-desc = 將防止上列以外的網站請您允許傳送通知。封鎖傳送通知的權限可能會影響某些網站的功能。

## Site Permissions - Location

permissions-site-location-window =
    .title = 設定 - 位置權限
    .style = { permissions-window.style }
permissions-site-location-desc = 下列網站要求取得您的所在地點。您可指定允許哪些網站取得您的所在地點，也可以封鎖新的位置取得請求。
permissions-site-location-disable-label =
    .label = 封鎖新網站取得您所在位置的請求
permissions-site-location-disable-desc = 將防止上列以外的網站請您允許取得您所在位置。封鎖取得所在位置的權限可能會影響某些網站的功能。

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = 設定 - 虛擬實境權限
    .style = { permissions-window.style }
permissions-site-xr-desc = 下列網站要求使用您的虛擬實境裝置。您可指定允許哪些網站使用 VR 裝置，也可以封鎖新的 VR 裝置使用請求。
permissions-site-xr-disable-label =
    .label = 封鎖新網站使用您虛擬裝置的請求
permissions-site-xr-disable-desc = 將防止上列以外的網站請求使用您的虛擬實境裝置。封鎖虛擬實境裝置的使用權限可能會影響某些網站的功能。

## Site Permissions - Camera

permissions-site-camera-window =
    .title = 設定 - 攝影機權限
    .style = { permissions-window.style }
permissions-site-camera-desc = 下列網站要求使用您的攝影機。您可指定允許哪些網站使用您的攝影機，也可以封鎖新的攝影機使用請求。
permissions-site-camera-disable-label =
    .label = 封鎖新網站使用您攝影機的請求
permissions-site-camera-disable-desc = 將防止上列以外的網站請您允許使用攝影機。封鎖使用攝影機的權限可能會影響某些網站的功能。

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = 設定 - 麥克風權限
    .style = { permissions-window.style }
permissions-site-microphone-desc = 下列網站要求使用您的麥克風。您可指定允許哪些網站使用您的麥克風，也可以封鎖新的麥克風使用請求。
permissions-site-microphone-disable-label =
    .label = 封鎖新網站使用您麥克風的請求
permissions-site-microphone-disable-desc = 將防止上列以外的網站請您允許使用麥克風。封鎖使用麥克風的權限可能會影響某些網站的功能。
