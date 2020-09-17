# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = ભલામણ કરેલ એક્સ્ટેંશન
cfr-doorhanger-feature-heading = ભલામણ લક્ષણ
cfr-doorhanger-pintab-heading = આને અજમાવો: ટૅબ પિન કરો

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = શા માટે હું આ જોઈ રહ્યો છું

cfr-doorhanger-extension-cancel-button = હમણાં નહિ
    .accesskey = N

cfr-doorhanger-extension-ok-button = હમણાંજ ઉમેરો
    .accesskey = A
cfr-doorhanger-pintab-ok-button = આ ટેબ પિન કરો
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = ભલામણ સેટિંગ્સ મેનેજ કરો
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = મને આ ભલામણ બતાવશો નહીં
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = વધુ શીખો

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } દ્વારા

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = ભલામણ
cfr-doorhanger-extension-notification2 = ભલામણ
    .tooltiptext = ભલામણ કરેલ એક્સેટેંશન
    .a11y-announcement = ભલામણ કરેલ એક્સેટેંશન ઉપલબ્ધ છે

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = ભલામણ
    .tooltiptext = લક્ષણ ભલામણ
    .a11y-announcement = લક્ષણ ભલામણ ઉપલબ્ધ છે

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } સ્ટાર
           *[other] { $total } સ્ટાર્સ
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } વપરાશકર્તા
       *[other] { $total } વપરાશકર્તાઓ
    }

cfr-doorhanger-pintab-description = તમારી સૌથી વધુ ઉપયોગમાં લેવાતી સાઇટ્સની સરળ ઍક્સેસ મેળવો. સાઇટ્સને ટેબમાં ખોલો (તમે ફરીથી શરૂ કરો ત્યારે પણ).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = તમે જે ટૅબને પિન કરવા માંગો છો તેના પર <b>જમણી ક્લિક કરો.</b>
cfr-doorhanger-pintab-step2 = મેનૂમાંથી <b>પિન ટૅબ</ b> પસંદ કરો.
cfr-doorhanger-pintab-step3 = જો સાઇટમાં એક અપડેટ હોય તો તમને તમારા પિન કરેલા ટેબ પર વાદળી બિંદુ દેખાશે.

cfr-doorhanger-pintab-animation-pause = અટકાવો
cfr-doorhanger-pintab-animation-resume = ફરી શરૂ કરો


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = દરેક જગ્યાએ તમારા બુકમાર્ક્સ સમન્વયિત કરો.
cfr-doorhanger-bookmark-fxa-body = મહાન શોધ! હવે તમારા મોબાઇલ ઉપકરણો પર આ બુકમાર્ક વિના છોડી શકાશે નહીં. { -fxaccount-brand-name } થી પ્રારંભ કરો.
cfr-doorhanger-bookmark-fxa-link-text = હવે બુકમાર્ક્સ સમન્વયિત કરો...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = બંધ કરો બટન
    .title = બંધ

## Protections panel

cfr-protections-panel-header = અનુસર્યા વિના બ્રાઉઝ કરો
cfr-protections-panel-link-text = વધુ જાણો

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = નવી સુવિધા:

cfr-whatsnew-button =
    .label = નવું શું છે
    .tooltiptext = નવું શું છે

cfr-whatsnew-panel-header = નવું શું છે

cfr-whatsnew-tracking-protect-title = પોતાને ટ્રેકર્સથી બચાવો
cfr-whatsnew-tracking-protect-link-text = તમારો અહેવાલ જુઓ

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] ટ્રેકર્સ અવરોધિત
       *[other] ટ્રેકર્સ અવરોધિત
    }
cfr-whatsnew-tracking-blocked-link-text = અહેવાલ જુઓ

cfr-whatsnew-lockwise-backup-title = તમારા પાસવર્ડ્સનો બેક અપ લો
cfr-whatsnew-lockwise-backup-link-text = બેકઅપ ચાલુ કરો

## Search Bar


## Picture-in-Picture


## Permission Prompt


## Fingerprinter Counter


## Bookmark Sync


## Login Sync


## Send Tab


## Firefox Send


## Social Tracking Protection


## Enhanced Tracking Protection Milestones


## What’s New Panel Content for Firefox 76


## Lockwise message


## Vulnerable Passwords message


## Picture-in-Picture fullscreen message


## Protections Dashboard message


## Better PDF message


## DOH Message


## What's new: Cookies message

