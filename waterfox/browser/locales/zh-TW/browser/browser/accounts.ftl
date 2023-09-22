# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = 完成帳號設定

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = 帳號已取消連結

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = 傳送到所有裝置

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = 管理裝置…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = 重新連線至 { $email }
account-verify = 確認 { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = 傳送到所有裝置
account-manage-devices-titlecase = 管理裝置…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = 沒有已連結的裝置

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = 了解傳送分頁…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = 連結其他裝置…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = 帳號未驗證
account-send-tab-to-device-verify = 確認您的帳號…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name(capitalization: "title") }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = 此電腦已連結至 { $deviceName }。

# Used when the name of the new device is not known.
account-connection-connected-with-noname = 此電腦已與新裝置連結。

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = 成功登入

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = 此電腦已取消連結。

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = 收到分頁
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = 來自 { $deviceName } 的分頁

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = 收到分頁

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device = 收到來自 { $deviceName } 的 { $tabCount } 個分頁
account-multiple-tabs-arriving-from-multiple-devices = 收到來自您已連結的裝置的 { $tabCount } 個分頁
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device = 收到 { $tabCount } 個分頁
