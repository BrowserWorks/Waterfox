# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = 계정 설정 완료

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = 계정 연결 끊김

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = 모든 기기에 보내기

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = 기기 관리…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = { $email } 다시 연결
account-verify = { $email } 검증

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = 모든 기기에 보내기
account-manage-devices-titlecase = 기기 관리…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = 연결된 기기 없음

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = 탭 보내기에 대해 알아보기…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = 다른 기기 연결…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = 계정 검증되지 않음
account-send-tab-to-device-verify = 계정 검증…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name(capitalization: "title") }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = 이 컴퓨터는 이제 { $deviceName }와 연결되었습니다.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = 이 컴퓨터는 이제 새 기기와 연결되었습니다.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = 성공적으로 로그인했습니다

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = 이 컴퓨터는 연결이 끊어졌습니다.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = 전송 받은 탭
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = { $deviceName }에서 온 탭

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = 전송 받은 탭

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device = { $deviceName }에서 탭 { $tabCount }개 도착
account-multiple-tabs-arriving-from-multiple-devices = 연결된 기기에서 탭 { $tabCount }개 도착
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device = 탭 { $tabCount }개 도착
