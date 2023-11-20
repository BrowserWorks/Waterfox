# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Recommended Extension
cfr-doorhanger-feature-heading = Recommended Feature

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Why am I seeing this

cfr-doorhanger-extension-cancel-button = Not Now
    .accesskey = N

cfr-doorhanger-extension-ok-button = Add Now
    .accesskey = A

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

## Waterfox Accounts Message

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

cfr-whatsnew-release-notes-link-text = Read the release notes

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } blocked over <b>{ $blockedCount }</b> trackers since { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = See All
    .accesskey = S
cfr-doorhanger-milestone-close-button = Close
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = Your privacy matters. { -brand-short-name } now securely routes your DNS requests whenever possible to a partner service to protect you while you browse.
cfr-doorhanger-doh-header = More secure, encrypted DNS lookups
cfr-doorhanger-doh-primary-button-2 = Okay
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Disable
    .accesskey = D

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videos on this site may not play correctly on this version of { -brand-short-name }. For full video support, update { -brand-short-name } now.
cfr-doorhanger-video-support-header = Update { -brand-short-name } to play video
cfr-doorhanger-video-support-primary-button = Update Now
    .accesskey = U

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Looks like you’re using public Wi-Fi
spotlight-public-wifi-vpn-body = To hide your location and browsing activity, consider a Virtual Private Network. It will help keep you protected when browsing in public places like airports and coffee shops.
spotlight-public-wifi-vpn-primary-button = Stay private with { -mozilla-vpn-brand-name }
    .accesskey = S
spotlight-public-wifi-vpn-link = Not Now
    .accesskey = N

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = A better internet starts with you
spotlight-better-internet-body = When you use { -brand-short-name }, you’re voting for an open and accessible internet that’s better for everyone.
spotlight-peace-mind-header = We’ve got you covered
spotlight-peace-mind-body = Every month, { -brand-short-name } blocks an average of over 3,000 trackers per user. Because nothing, especially privacy nuisances like trackers, should stand between you and the good internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Keep in Dock
       *[other] Pin to taskbar
    }
spotlight-pin-secondary-button = Not now

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

mr2022-background-update-toast-title = New { -brand-short-name }. More private. Fewer trackers. No compromises.
mr2022-background-update-toast-text = Try the newest { -brand-short-name } now, upgraded with our strongest anti-tracking protection yet.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = Open { -brand-shorter-name } Now

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Remind Me Later

## Waterfox View CFR

firefoxview-cfr-primarybutton = Try it
    .accesskey = T
firefoxview-cfr-secondarybutton = Not now
    .accesskey = N
firefoxview-cfr-header-v2 = Quickly pick up where you left off
firefoxview-cfr-body-v2 = Get recently closed tabs back, plus seamlessly hop between devices with { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Say hello to { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Want that open tab on your phone? Grab it. Need that site you just visited? Poof, it’s back with { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = See how it works
firefoxview-spotlight-promo-secondarybutton = Skip

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Choose colourway
    .accesskey = C

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Colour your browser with { -brand-short-name } exclusive shades inspired by voices that changed culture.
colorways-cfr-header-28days = Independent Voices colourways expire January 16
colorways-cfr-header-14days = Independent Voices colourways expire in two weeks
colorways-cfr-header-7days = Independent Voices colourways expire this week
colorways-cfr-header-today = Independent Voices colourways expire today

## Cookie Banner Handling CFR

cfr-cbh-header = Allow { -brand-short-name } to reject cookie banners?
cfr-cbh-body = { -brand-short-name } can automatically reject many cookie banner requests.
cfr-cbh-confirm-button = Reject cookie banners
    .accesskey = R
cfr-cbh-dismiss-button = Not now
    .accesskey = N

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = We’ve got you covered
july-jam-body = Every month, { -brand-short-name } blocks an average of 3,000+ trackers per user, giving you safe, speedy access to the good internet.
july-jam-set-default-primary = Open my links with { -brand-short-name }
fox-doodle-pin-headline = Welcome back

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Here’s a quick reminder that you can keep your favourite indie browser just one click away.
fox-doodle-pin-primary = Open my links with { -brand-short-name }
fox-doodle-pin-secondary = Not now

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>Your PDFs now open in { -brand-short-name }.</strong> Edit or sign forms directly in your browser. To change, search “PDF” in settings.
set-default-pdf-handler-primary = Got it

## FxA sync CFR

fxa-sync-cfr-header = New device in your future?
fxa-sync-cfr-body = Make sure your latest bookmarks, passwords, and tabs come with you any time you open a new { -brand-product-name } browser.
fxa-sync-cfr-primary = Learn more
    .accesskey = L
fxa-sync-cfr-secondary = Remind me later
    .accesskey = R

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Using an older device?
device-migration-fxa-spotlight-body = Back up your data to make sure you don’t lose important info like bookmarks and passwords — especially if you switch to a new device.
device-migration-fxa-spotlight-primary-button = How to back up my data
device-migration-fxa-spotlight-link = Remind me later
