# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = Dokończ konfigurację konta

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = Konto zostało rozłączone

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = Wyślij do wszystkich urządzeń

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = Zarządzaj urządzeniami…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = Połącz ponownie z kontem { $email }
account-verify = Zweryfikuj adres { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = Wyślij do wszystkich urządzeń
account-manage-devices-titlecase = Zarządzaj urządzeniami…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = Brak połączonych urządzeń

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = Więcej o przesyłaniu kart…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = Połącz inne urządzenie…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = Konto nie zostało zweryfikowane
account-send-tab-to-device-verify = Zweryfikuj konto…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = Ten komputer jest teraz połączony z urządzeniem { $deviceName }.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = Ten komputer jest teraz połączony z nowym urządzeniem.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = Pomyślnie zalogowano

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = Ten komputer został rozłączony.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = Przychodząca karta
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = Karta z urządzenia { $deviceName }

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = Przychodzące karty

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device =
    { $tabCount ->
        [one] { $tabCount } karta od „{ $deviceName }”.
        [few] { $tabCount } karty od „{ $deviceName }”.
       *[many] { $tabCount } kart od „{ $deviceName }”.
    }
account-multiple-tabs-arriving-from-multiple-devices =
    { $tabCount ->
        [one] { $tabCount } karta od połączonych urządzeń.
        [few] { $tabCount } karty od połączonych urządzeń.
       *[many] { $tabCount } kart od połączonych urządzeń.
    }
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device =
    { $tabCount ->
        [one] { $tabCount } przychodząca karta
        [few] { $tabCount } przychodzące karty
       *[many] { $tabCount } przychodzących kart
    }
