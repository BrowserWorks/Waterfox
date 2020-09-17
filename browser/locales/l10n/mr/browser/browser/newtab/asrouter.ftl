# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = शिफारस केलेले विस्तार
cfr-doorhanger-feature-heading = शिफारस केलेले वैशिष्ट्य
cfr-doorhanger-pintab-heading = हे करून पहा: पिन टॅब



##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = मला हे का दिसत आहे

cfr-doorhanger-extension-cancel-button = आत्ता नाही
    .accesskey = N

cfr-doorhanger-extension-ok-button = आत्ताच जोडा
    .accesskey = A
cfr-doorhanger-pintab-ok-button = हा टॅब पिन करा
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = शिफारशी सेटिंग्ज व्यवस्थापित करा
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = मला ही शिफारस दर्शवू नका
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = अधिक जाणा

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } द्वारा

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = शिफारस

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } तारा
           *[other] { $total }  तारे
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } वापरकर्ता
       *[other] { $total } वापरकर्ते
    }

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step2 = मेनूमधून <b>पिन टॅब</b> निवडा.

cfr-doorhanger-pintab-animation-pause = स्तब्ध करा
cfr-doorhanger-pintab-animation-resume = पुन्हा सुरू करा


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = आपले बुकमार्क कुठेही सिंक करा.
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = बंद करा बटण
    .title = बंद करा

## Protections panel

cfr-protections-panel-link-text = अधिक जाणा

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = नवीन वैशिष्ट्य

cfr-whatsnew-button =
    .label = नवीन काय आहे
    .tooltiptext = नवीन काय आहे

cfr-whatsnew-panel-header = नवीन काय आहे

cfr-whatsnew-release-notes-link-text = प्रकाशन नोट्स वाचा

cfr-whatsnew-fx70-title = { -brand-short-name } आता आपल्या गोपनीयतेसाठी कठोर संघर्ष करते

cfr-whatsnew-tracking-protect-title = ट्रॅकर्सपासून स्वतःचे रक्षण करा
cfr-whatsnew-tracking-protect-link-text = आपला अहवाल पहा

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] ट्रॅकर अवरोधित
       *[other] ट्रॅकर अवरोधित
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } पासून
cfr-whatsnew-tracking-blocked-link-text = अहवाल पहा

cfr-whatsnew-lockwise-backup-title = आपले पासवर्ड बॅक-अप करा
cfr-whatsnew-lockwise-backup-link-text = बॅकअप चालू करा

cfr-whatsnew-lockwise-take-title = आपले पासवर्ड आपल्या सोबत न्या
cfr-whatsnew-lockwise-take-link-text = अॅप मिळवा

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = हा बुकमार्क आपल्या फोनवर मिळवा
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } चालू करा
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } चालू करा
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = जाता जाता हे वाचा
cfr-doorhanger-send-tab-recipe-header = ही कृती स्वयंपाकघरात घ्या
cfr-doorhanger-send-tab-ok-button = टॅब पाठवणे वापरून पहा
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } वापरून पहा
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = संरक्षण पहा
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = बंद करा
    .accesskey = C

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = सर्व पाहा
    .accesskey = S

## What’s New Panel Content for Firefox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

