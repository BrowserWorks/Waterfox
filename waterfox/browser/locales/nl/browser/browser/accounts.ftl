# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = Aanmaken account voltooien

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = Account niet verbonden

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = Verzenden naar alle apparaten

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = Apparaten beheren…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = { $email } opnieuw koppelen
account-verify = { $email } verifiëren

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = Verzenden naar alle apparaten
account-manage-devices-titlecase = Apparaten beheren…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = Geen apparaten verbonden

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = Meer info over het verzenden van tabbladen…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = Een ander apparaat verbinden…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = Account niet geverifieerd
account-send-tab-to-device-verify = Uw account verifiëren…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# The title shown in a notification when either this device or another device
# has connected to, or disconnected from, a Waterfox account.
account-connection-title = { -fxaccount-brand-name(capitalization: "title") }

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = Deze computer is nu verbonden met { $deviceName }.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = Deze computer is nu verbonden met een nieuw apparaat.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = U bent met succes aangemeld

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = De verbinding van deze computer is verbroken.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = Tabblad ontvangen
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = Tabblad van { $deviceName }

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = Tabbladen ontvangen

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device =
    { $tabCount ->
        [one] { $tabCount } tabblad ontvangen van { $deviceName }
       *[other] { $tabCount } tabbladen ontvangen van { $deviceName }
    }
account-multiple-tabs-arriving-from-multiple-devices =
    { $tabCount ->
        [one] { $tabCount } tabblad ontvangen van uw verbonden apparaten
       *[other] { $tabCount } tabbladen ontvangen van uw verbonden apparaten
    }
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device =
    { $tabCount ->
        [one] { $tabCount } tabblad ontvangen
       *[other] { $tabCount } tabbladen ontvangen
    }
