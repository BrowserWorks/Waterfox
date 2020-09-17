# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = अनुशंसित एक्सटेंशन
cfr-doorhanger-feature-heading = अनुशंसित विशेषता
cfr-doorhanger-pintab-heading = इसे आज़माएं: पिन टैब

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = मैं यह क्यों देख रहा हूँ

cfr-doorhanger-extension-cancel-button = अभी नहीं
    .accesskey = N

cfr-doorhanger-extension-ok-button = अभी जोड़ें
    .accesskey = A
cfr-doorhanger-pintab-ok-button = इस टैब को पिन करें
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = अनुशंसा सेटिंग प्रबंधित करें|
    .accesskey = म

cfr-doorhanger-extension-never-show-recommendation = मुझे यह अनुशंसा न दिखाएं
    .accesskey = स

cfr-doorhanger-extension-learn-more-link = अधिक जानें

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } द्वारा

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = सिफारिश
cfr-doorhanger-extension-notification2 = अनुशंसा
    .tooltiptext = विस्तारक अनुशंसा
    .a11y-announcement = विस्तारक अनुशंसा उपलब्ध

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = अनुशंसा
    .tooltiptext = विशेषता अनुशंसा
    .a11y-announcement = विशेषता अनुशंसा उपलब्ध

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } स्टार
           *[other] { $total } स्टार्स
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } उपयोगकर्ता
       *[other] { $total } उपयोग्कत्तायें
    }

cfr-doorhanger-pintab-description = अपनी सबसे अधिक उपयोग की जाने वाली साइटों तक आसान पहुंच प्राप्त करें। साइटों को एक टैब में खुला रखें (यहां तक कि जब आप फिर से खोलें)।

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = उस टैब के ऊपर <b>राइट-क्लिक करें</b> जिसे आप पिन करना चाहते हैं।
cfr-doorhanger-pintab-step2 = मेन्यू से <b>पिन टैब</b> चुनें।
cfr-doorhanger-pintab-step3 = अगर साइट पर कोई अपडेट हो तो आपको पिन किए गए टैब पर एक नीला डॉट दिखाई देगा।

cfr-doorhanger-pintab-animation-pause = ठहरें
cfr-doorhanger-pintab-animation-resume = फिर से शुरू करें


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = अपने बुकमार्क हर जगह सिंक करें।
cfr-doorhanger-bookmark-fxa-body = शानदार खोज! अब आपके मोबाइल उपकरणों पर इस बुकमार्क को छोड़ा जाएगा। एक { -fxaccount-brand-name } के साथ आरंभ करें।
cfr-doorhanger-bookmark-fxa-link-text = अभी बुकमार्क सिंक करें...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = बटन बंद करें
    .title = बंद करें

## Protections panel

cfr-protections-panel-header = पीछा किये बिना ब्राउज़ करें
cfr-protections-panel-link-text = अधिक जानें

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = नई विशेषताएँ:

cfr-whatsnew-button =
    .label = क्या नया है
    .tooltiptext = क्या नया है

cfr-whatsnew-panel-header = क्या नया है

cfr-whatsnew-release-notes-link-text = रिलीज नोट्स पढ़ें

cfr-whatsnew-tracking-protect-title = ट्रैकर्स से खुद को बचाएं
cfr-whatsnew-tracking-protect-link-text = अपनी रिपोर्ट देखें

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] ट्रैकर अवरुद्ध
       *[other] ट्रैकर्स अवरुद्ध
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } से
cfr-whatsnew-tracking-blocked-link-text = रिपोर्ट देखें

cfr-whatsnew-lockwise-backup-title = अपने पासवर्ड का बैकअप लें
cfr-whatsnew-lockwise-backup-body = अब एक सुरक्षित पासवर्ड बनाएं जिसका उपयोग आप कहीं भी साइन इन करने के लिए कर सकते हैं।
cfr-whatsnew-lockwise-backup-link-text = बैकअप चालू करें

cfr-whatsnew-lockwise-take-title = अपना पासवर्ड अपने साथ रखें
cfr-whatsnew-lockwise-take-link-text = एप्प प्राप्त करें

## Search Bar


## Picture-in-Picture

cfr-whatsnew-pip-header = ब्राउज़ करते समय वीडियो देखें
cfr-whatsnew-pip-cta = और अधिक जानें

## Permission Prompt

cfr-whatsnew-permission-prompt-header = कुछ खीझ दिलाने वाली साइट पॉप-अप
cfr-whatsnew-permission-prompt-cta = और अधिक जानें

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] फ़िंगरप्रिंटर अवरूद्ध किया गया
       *[other] फ़िंगरप्रिंटर अवरूद्ध किए गए
    }

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = फिंगरप्रिंटर

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = इस बुकमार्क को अपने फ़ोन पर प्राप्त करें
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } चालू करें
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = पासवर्ड को फिर कभी न खोएं
cfr-doorhanger-sync-logins-body = अपने पासवर्ड को अपने सभी उपकरणों पर सुरक्षापूर्ण तरीके से रखें और सिंक करें।
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } चालू करें
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = इस पर पढ़ें
cfr-doorhanger-send-tab-recipe-header = इस रेसिपी को किचन तक ले जाएं
cfr-doorhanger-send-tab-ok-button = टैब भेजने का प्रयास करें
    .accesskey = ट

## Firefox Send

cfr-doorhanger-firefox-send-header = सुरक्षापूर्वक इस PDF को साझा करें
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } आज़माएं
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = सुरक्षा देखें
    .accesskey = स
cfr-doorhanger-socialtracking-close-button = बंद करें
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = इस तरह के संदेश मुझे दोबारा ना दिखाएं
    .accesskey = D
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } ने इस पृष्ठ पर एक फिंगरप्रिंटर को अवरुद्ध किया
cfr-doorhanger-fingerprinters-description = आपकी गोपनीयता मायने रखती है। { -brand-short-name } अब फिंगरप्रिंटर को अवरुद्ध करता है, जो आपको ट्रैक करने के लिए आपके उपकरण के बारे में विशिष्ट पहचान योग्य कुछ जानकारी एकत्र करता है।
cfr-doorhanger-cryptominers-heading = { -brand-short-name } ने इस पृष्ठ पर एक क्रिप्टोमाइनर को अवरुद्ध किया

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = सभी देखें
    .accesskey = S

cfr-doorhanger-milestone-close-button = बंद करें
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = आसानी से सुरक्षित पासवर्ड बनाएं
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } आइकॉन

## Vulnerable Passwords message


## Picture-in-Picture fullscreen message


## Protections Dashboard message


## Better PDF message

cfr-whatsnew-better-pdf-header = बेहतर PDF अनुभव

## DOH Message


## What's new: Cookies message

