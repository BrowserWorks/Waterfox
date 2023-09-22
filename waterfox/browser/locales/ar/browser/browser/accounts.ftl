# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Used as the FxA toolbar menu item value when user has not
# finished setting up an account.
account-finish-account-setup = أنهِ إعداد الحساب

# Used as the FxA toolbar menu item title when the user
# needs to reconnect their account.
account-disconnected2 = فُصل الحساب

# Menu item that sends a tab to all synced devices.
account-send-to-all-devices = أرسله إلى كل الأجهزة

# Menu item that links to the Waterfox Accounts settings for connected devices.
account-manage-devices = أدِر الأجهزة…

## Variables:
##   $email (String): = Email address of user's Waterfox Account.

account-reconnect = أعِد توصيل { $email }
account-verify = أكّد { $email }

## Displayed in the Send Tab/Page/Link to Device context menu when right clicking a tab, a page or a link.

account-send-to-all-devices-titlecase = أرسله إلى كل الأجهزة
account-manage-devices-titlecase = أدِر الأجهزة…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the account has only 1 device connected.

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-status = لا أجهزة متصلة

# Redirects to a marketing page.
account-send-tab-to-device-singledevice-learnmore = اطلع على المزيد عن إرسال الألسنة…

# Redirects to an FxAccounts page that tells to you to connect another device.
account-send-tab-to-device-connectdevice = صِلْ جهازا آخر…

## Displayed in the Send Tabs context menu when right clicking a tab, a page or a link
## and the Sync account is unverified. Redirects to the Sync preferences page.

account-send-tab-to-device-verify-status = الحساب غير مُؤكّد
account-send-tab-to-device-verify = أكّد حسابك…

## These strings are used in a notification shown when a new device joins the Waterfox account.

# Variables:
#   $deviceName (String): the name of the new device
account-connection-connected-with = أصبح هذا الحاسوب الآن متصلًا مع { $deviceName }.

# Used when the name of the new device is not known.
account-connection-connected-with-noname = صار هذا الحاسوب متصلًا الآن مع جهاز جديد.

# Used in a notification shown after a Waterfox account is connected to the current device.
account-connection-connected = نجح الولوج إلى حسابك

# Used in a notification shown after the Waterfox account was disconnected remotely.
account-connection-disconnected = قُطع اتصال هذا الحاسوب.

## These strings are used in a notification shown when we're opening
## a single tab another device sent us to display.
## The body for this notification is the URL of the received tab.

account-single-tab-arriving-title = وصل لسان
# Variables:
#   $deviceName (String): the device name.
account-single-tab-arriving-from-device-title = لسان من { $deviceName }

# Used when a tab from a remote device arrives but the URL must be truncated.
# Should display the URL with an indication that it's been truncated.
# Variables:
#   $url (String): the portion of the URL that remains after truncation.
account-single-tab-arriving-truncated-url = { $url }…

## These strings are used in a notification shown when we're opening
## multiple tabs another device or devices sent us to display.
## Variables:
##   $tabCount (Number): the number of tabs received

account-multiple-tabs-arriving-title = وصل لسان

# Variables:
#   $deviceName (String): the device name.
account-multiple-tabs-arriving-from-single-device =
    { $tabCount ->
        [one] وصل لسان من { $deviceName }
        [two] وصل لسانين من { $deviceName }
        [few] وصلت { $tabCount } ألسنة من { $deviceName }
        [many] وصل { $tabCount } لسانًا من { $deviceName }
       *[other] وصل { $tabCount } لسان من { $deviceName }
    }
account-multiple-tabs-arriving-from-multiple-devices =
    { $tabCount ->
        [one] وصل لسان من أجهزتك المتصلة
        [two] وصل لسانين من أجهزتك المتصلة
        [few] وصلت { $tabCount } ألسنة من أجهزتك المتصلة
        [many] وصل { $tabCount } لسانًا من أجهزتك المتصلة
       *[other] وصل { $tabCount } لسان من أجهزتك المتصلة
    }
# This version is used when we don't know any device names.
account-multiple-tabs-arriving-from-unknown-device =
    { $tabCount ->
        [one] وصل لسان
        [two] وصل لسانين
        [few] وصلت { $tabCount } ألسنة
        [many] وصل { $tabCount } لسانًا
       *[other] وصل { $tabCount } لسان
    }
