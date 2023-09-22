# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = Užbaigti paskyros kūrimą

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = Paskyra atjungta

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = Siųsti į visus įrenginius

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = Tvarkyti įrenginius…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = Prisijungti su { $email } iš naujo
account-verify = Patvirtinti { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = Siųsti į visus įrenginius
account-manage-devices-titlecase = Tvarkyti įrenginius…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = Nėra susietų įrenginių.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = Sužinokite apie kortelių siuntimą…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = Susieti kitą įrenginį…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = Paskyra nepatvirtinta
account-send-tab-to-device-verify = Patvirtinkite savo paskyrą…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = Šis kompiuteris dabar sujungtas su „{ $deviceName }“.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = Šis kompiuteris dabar sujungtas su naujuoju įrenginiu.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = Sėkmingai prisijungėte

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = Šis kompiuteris buvo atjungtas.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = Gauta kortelė
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = Kortelė iš „{ $deviceName }“

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = Gauta kortelių

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device =
    { $tabCount ->
        [one] Iš „{ $deviceName }“ atkeliavo { $tabCount } kortelė
        [few] Iš „{ $deviceName }“ atkeliavo { $tabCount } kortelės
       *[other] Iš „{ $deviceName }“ atkeliavo { $tabCount } kortelių
    }
account-multiple-tabs-arriving-from-multiple-devices =
    { $tabCount ->
        [one] Iš jūsų susietų įrenginių atkeliavo { $tabCount } kortelė
        [few] Iš jūsų susietų įrenginių atkeliavo { $tabCount } kortelės
       *[other] Iš jūsų susietų įrenginių atkeliavo { $tabCount } kortelių
    }
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device =
    { $tabCount ->
        [one] Atkeliavo { $tabCount } kortelė
        [few] Atkeliavo { $tabCount } kortelės
       *[other] Atkeliavo { $tabCount } kortelių
    }
