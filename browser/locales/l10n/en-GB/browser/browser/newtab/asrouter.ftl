# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Recommended Extension
cfr-doorhanger-feature-heading = Recommended Feature
cfr-doorhanger-pintab-heading = Try This: Pin Tab

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Why am I seeing this
cfr-doorhanger-extension-cancel-button = Not Now
    .accesskey = N
cfr-doorhanger-extension-ok-button = Add Now
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Pin This Tab
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = Manage Recommendation Settings
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = Don’t Show Me This Recommendation
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = Learn more
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = by { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recommendation
cfr-doorhanger-extension-notification2 = Recommendation
    .tooltiptext = Extension recommendation
    .a11y-announcement = Extension recommendation available
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recommendation
    .tooltiptext = Feature recommendation
    .a11y-announcement = Feature recommendation available

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } star
           *[other] { $total } stars
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } user
       *[other] { $total } users
    }
cfr-doorhanger-pintab-description = Get easy access to your most-used sites. Keep sites open in a tab (even when you restart).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Right-click</b> on the tab you want to pin.
cfr-doorhanger-pintab-step2 = Select <b>Pin Tab</b> from the menu.
cfr-doorhanger-pintab-step3 = If the site has an update you’ll see a blue dot on your pinned tab.
cfr-doorhanger-pintab-animation-pause = Pause
cfr-doorhanger-pintab-animation-resume = Resume

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronise your bookmarks everywhere.
cfr-doorhanger-bookmark-fxa-body = Great find! Now don’t be left without this bookmark on your mobile devices. Get Started with a { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronise bookmarks now…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Close button
    .title = Close

## Protections panel

cfr-protections-panel-header = Browse without being followed
cfr-protections-panel-body = Keep your data to yourself. { -brand-short-name } protects you from many of the most common trackers that follow what you do online.
cfr-protections-panel-link-text = Learn more

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = New feature:
cfr-whatsnew-button =
    .label = What’s New
    .tooltiptext = What’s New
cfr-whatsnew-panel-header = What’s New
cfr-whatsnew-release-notes-link-text = Read the release notes
cfr-whatsnew-fx70-title = { -brand-short-name } now fights harder for your privacy
cfr-whatsnew-fx70-body =
    The latest update enhances the Tracking Protection feature and makes it
    easier than ever to create secure passwords for every site.
cfr-whatsnew-tracking-protect-title = Protect yourself from trackers
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blocks many common social and cross-site trackers that
    follow what you do online.
cfr-whatsnew-tracking-protect-link-text = View Your Report
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Tracker blocked
       *[other] Trackers blocked
    }
cfr-whatsnew-tracking-blocked-subtitle = Since { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = View Report
cfr-whatsnew-lockwise-backup-title = Back up your passwords
cfr-whatsnew-lockwise-backup-body = Now generate secure passwords you can access anywhere you sign in.
cfr-whatsnew-lockwise-backup-link-text = Turn on backups
cfr-whatsnew-lockwise-take-title = Take your passwords with you
cfr-whatsnew-lockwise-take-body =
    The { -lockwise-brand-short-name } mobile app lets you securely access your
    backed up passwords from anywhere.
cfr-whatsnew-lockwise-take-link-text = Get the app

## Search Bar

cfr-whatsnew-searchbar-title = Type less, find more with the address bar
cfr-whatsnew-searchbar-body-topsites = Now, just select the address bar, and a box will expand with links to your top sites.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Magnifying glass icon

## Picture-in-Picture

cfr-whatsnew-pip-header = Watch videos while you browse
cfr-whatsnew-pip-body = Picture-in-picture pops video into a floating window so you can watch while working in other tabs.
cfr-whatsnew-pip-cta = Learn more

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Fewer annoying site pop-ups
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } now blocks sites from automatically asking to send you pop-up messages.
cfr-whatsnew-permission-prompt-cta = Learn more

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter blocked
       *[other] Fingerprinters blocked
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blocks many fingerprinters that secretly gather information about your device and actions to create an advertising profile of you.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } can block fingerprinters that secretly gather information about your device and actions to create an advertising profile of you.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Get this bookmark on your phone
cfr-doorhanger-sync-bookmarks-body = Take your bookmarks, passwords, history and more everywhere you’re signed into { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Turn on { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Never Lose a Password Again
cfr-doorhanger-sync-logins-body = Securely store and synchronise your passwords to all your devices.
cfr-doorhanger-sync-logins-ok-button = Turn on { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Read this on the go
cfr-doorhanger-send-tab-recipe-header = Take this recipe to the kitchen
cfr-doorhanger-send-tab-body = Send Tab lets you easily share this link to your phone or anywhere you’re signed in to { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Try Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Share this PDF securely
cfr-doorhanger-firefox-send-body = Keep your sensitive documents safe from prying eyes with end-to-end encryption and a link that disappears when you’re done.
cfr-doorhanger-firefox-send-ok-button = Try { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = See Protections
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Close
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Don’t show me messages like this again
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } stopped a social network from tracking you here
cfr-doorhanger-socialtracking-description = Your privacy matters. { -brand-short-name } now blocks common social media trackers, limiting how much data they can collect about what you do online.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blocked a fingerprinter on this page
cfr-doorhanger-fingerprinters-description = Your privacy matters. { -brand-short-name } now blocks fingerprinters, which collect pieces of uniquely identifiable information about your device to track you.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blocked a cryptominer on this page
cfr-doorhanger-cryptominers-description = Your privacy matters. { -brand-short-name } now blocks cryptominers, which use your system’s computing power to mine digital money.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } blocked over <b>{ $blockedCount }</b> trackers since { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } blocked over <b>{ $blockedCount }</b> trackers since { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = See All
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Easily create secure passwords
cfr-whatsnew-lockwise-body = It’s difficult to think of unique, secure passwords for every account. When creating a password, select the password field to use a secure, generated password from { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } icon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Get alerts about vulnerable passwords
cfr-whatsnew-passwords-body = Hackers know people reuse the same passwords. If you used the same password on multiple sites, and one of those sites was in a data breach, you’ll see an alert in { -lockwise-brand-short-name } to change your password on those sites.
cfr-whatsnew-passwords-icon-alt = Vulnerable password key icon

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Take picture-in-picture fullscreen
cfr-whatsnew-pip-fullscreen-body = When you pop a video into a floating window, you can now double-click on that window to go fullscreen.
cfr-whatsnew-pip-fullscreen-icon-alt = Picture-in-picture icon

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Close
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Protections at a glance
cfr-whatsnew-protections-body = The Protections Dashboard includes summary reports about data breaches and password management. You can now track how many breaches you’ve resolved, and see if any of your saved passwords may have been exposed in a data breach.
cfr-whatsnew-protections-cta-link = View Protections Dashboard
cfr-whatsnew-protections-icon-alt = Shield icon

## Better PDF message

cfr-whatsnew-better-pdf-header = Better PDF experience
cfr-whatsnew-better-pdf-body = PDF documents now open directly in { -brand-short-name }, keeping your workflow within easy reach.

## DOH Message

cfr-doorhanger-doh-body = Your privacy matters. { -brand-short-name } now securely routes your DNS requests whenever possible to a partner service to protect you while you browse.
cfr-doorhanger-doh-header = More secure, encrypted DNS lookups
cfr-doorhanger-doh-primary-button-2 = Okay
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Disable
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Your privacy matters. { -brand-short-name } now isolates, or sandboxes, web sites from each other, which makes it harder for hackers to steal passwords, credit card numbers, and other sensitive information.
cfr-doorhanger-fission-header = Site Isolation
cfr-doorhanger-fission-primary-button = OK, Got it
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Learn more
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatic protection from sneaky tracking tactics
cfr-whatsnew-clear-cookies-body = Some trackers redirect you to other web sites that secretly set cookies. { -brand-short-name } now automatically clears those cookies so you can’t be followed.
cfr-whatsnew-clear-cookies-image-alt = Cookie blocked illustration

## What's new: Media controls message

cfr-whatsnew-media-keys-header = More media controls
cfr-whatsnew-media-keys-body = Play and pause audio or video right from your keyboard or headset, making it easy to control media from another tab, program, or even when your computer is locked. You can also move between tracks using the forward and back keys.
cfr-whatsnew-media-keys-button = Learn how

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Search shortcuts in the address bar
cfr-whatsnew-search-shortcuts-body = Now, when you type a search engine or specific site into the address bar, a blue shortcut will appear in the search suggestions beneath. Select that shortcut to complete your search directly from the address bar.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Protection from malicious supercookies
cfr-whatsnew-supercookies-body = Web sites can secretly attach a “supercookie” to your browser that can follow you around the web, even after you clear your cookies. { -brand-short-name } now provides strong protection against supercookies so they can’t be used to track your online activities from one site to the next.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Better bookmarking
cfr-whatsnew-bookmarking-body = It’s easier to keep track of your favourite sites. { -brand-short-name } now remembers your preferred location for saved bookmarks, shows the bookmarks toolbar by default on new tabs, and gives you easy access to the rest of your bookmarks via a toolbar folder.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Comprehensive protection from cross-site cookie tracking
cfr-whatsnew-cross-site-tracking-body = You can now opt in to better protection from cookie tracking. { -brand-short-name } can isolate your activities and data to the site you’re currently on so information stored in the browser isn’t shared between web sites.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videos on this site may not play correctly on this version of { -brand-short-name }. For full video support, update { -brand-short-name } now.
cfr-doorhanger-video-support-header = Update { -brand-short-name } to play video
cfr-doorhanger-video-support-primary-button = Update Now
    .accesskey = U
