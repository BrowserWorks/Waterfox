# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = เสร็จสิ้นการตั้งค่าบัญชี

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = ตัดการเชื่อมต่อบัญชีแล้ว

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = ส่งไปยังอุปกรณ์ทั้งหมด

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = จัดการอุปกรณ์…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = เชื่อมต่อ { $email } ใหม่
account-verify = ยืนยัน { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = ส่งไปยังอุปกรณ์ทั้งหมด
account-manage-devices-titlecase = จัดการอุปกรณ์…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = ไม่มีอุปกรณ์ที่เชื่อมต่อ

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = เรียนรู้เกี่ยวกับการส่งแท็บ…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = เชื่อมต่ออุปกรณ์อื่น…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = บัญชีไม่ได้รับการยืนยัน
account-send-tab-to-device-verify = ยืนยันบัญชีของคุณ…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name(capitalization: "title") }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = คอมพิวเตอร์นี้เชื่อมต่อกับ { $deviceName } แล้ว

# Used when the name of the new device is not known.
account-connection-connected-with-noname = คอมพิวเตอร์นี้เชื่อมต่อกับอุปกรณ์ใหม่แล้ว

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = คุณได้ลงชื่อเข้าเรียบร้อยแล้ว

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = ตัดการเชื่อมต่อคอมพิวเตอร์นี้แล้ว

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = ได้รับแท็บ
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = แท็บจาก { $deviceName }

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = ได้รับแท็บ

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device = มี { $tabCount } แท็บเข้ามาจาก { $deviceName }
account-multiple-tabs-arriving-from-multiple-devices = มี { $tabCount } แท็บเข้ามาจากอุปกรณ์ที่เชื่อมต่อของคุณ
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device = มี { $tabCount } แท็บเข้ามา
