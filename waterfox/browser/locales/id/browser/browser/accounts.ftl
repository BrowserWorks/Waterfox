# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = Selesaikan Pengaturan Akun

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = Akun terputus

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = Kirim ke Semua Peranti

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = Kelola Perangkat…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = Sambungkan kembali { $email }
account-verify = Verifikasikan { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = Kirim ke Semua Peranti
account-manage-devices-titlecase = Kelola Perangkat…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = Tidak Ada Peranti Terhubung

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = Pelajari Tentang Mengirim Tab…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = Sambungkan Peranti Lain…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = Akun Tidak Terverifikasi
account-send-tab-to-device-verify = Verifikasi Akun Anda…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name(capitalization: "title") }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = Komputer ini sekarang telah terhubung dengan { $deviceName }.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = Komputer ini terhubung dengan perangkat baru.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = Anda berhasil masuk

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = Komputer ini sudah tidak terhubung.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = Tab diterima
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = Tab dari { $deviceName }

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = Tab Diterima

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device = { $tabCount } tab telah diterima dari { $deviceName }
account-multiple-tabs-arriving-from-multiple-devices = { $tabCount } tab telah diterima dari perangkat Anda yang telah terhubung
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device = { $tabCount } tab telah diterima
