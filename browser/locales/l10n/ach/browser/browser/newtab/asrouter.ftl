# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Lamed ma kicwako
cfr-doorhanger-pintab-heading = Tem man: Mwon dirica matidi

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Pi ngo atye kaneno man

cfr-doorhanger-extension-cancel-button = Pe kombedi
    .accesskey = P

cfr-doorhanger-extension-ok-button = Med kombedi
    .accesskey = M
cfr-doorhanger-pintab-ok-button = Mwon dirica matidi man
    .accesskey = M

cfr-doorhanger-extension-learn-more-link = Nong ngec mapol

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = ki { $name }

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

cfr-doorhanger-pintab-description = Nong donyo mayot i kakube ma itiyo kwedgi loyo. Gwok kakube ayaba i dirica matidi (kadi ka i nwoyo cako).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step2 = Yer <b>Mwon Dirica matidi</b> ki i gin ayera.

cfr-doorhanger-pintab-animation-pause = Juki
cfr-doorhanger-pintab-animation-resume = Mede


## Firefox Accounts Message


## Protections panel

cfr-protections-panel-header = Yeny ma nongo pe kilubo kor in
cfr-protections-panel-body = Gwok data mamegi boti keni. { -brand-short-name } gwoki ki ikom lulub kor mapol ata ma pol kare lubo kor ngo ma itimo iwiyamo.
cfr-protections-panel-link-text = Nong ngec mapol

## What's New toolbar button and panel

cfr-whatsnew-button =
    .label = Ngo Manyen
    .tooltiptext = Ngo Manyen

cfr-whatsnew-panel-header = Ngo Manyen

cfr-whatsnew-fx70-title = { -brand-short-name } dong lwenyo matek kato pi mung mamegi

cfr-whatsnew-tracking-protect-title = Gwokke ki ikom lulub kor
cfr-whatsnew-tracking-protect-link-text = Nen Ripot Mamegi

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Kigengo lalub kor
       *[other] Kigengo lulub kor
    }
cfr-whatsnew-tracking-blocked-subtitle = Nicake { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Nen Ripot

cfr-whatsnew-lockwise-take-title = Cwal mung me donyo mamegi kwedi
cfr-whatsnew-lockwise-take-link-text = Nong purugram ne

## Search Bar

## Picture-in-Picture

cfr-whatsnew-pip-cta = Nong ngec mapol

## Permission Prompt

cfr-whatsnew-permission-prompt-cta = Nong ngec mapol

## Fingerprinter Counter


## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Nong alamabuk man i cim mamegi
cfr-doorhanger-sync-bookmarks-body = Cwal alamabuk mamegi, mung me donyo, gin mukato ki mapol ka weng ma i donyo iyie { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Cak { -sync-brand-short-name }
    .accesskey = C

## Login Sync

cfr-doorhanger-sync-logins-header = Pe Irweny Mung me donyo Doki Matwal
cfr-doorhanger-sync-logins-ok-button = Cak { -sync-brand-short-name }
    .accesskey = C

## Send Tab

cfr-doorhanger-send-tab-body = Send Tab weko inywako mayot kakube man ki cim mamegi onyo ka mo keken ma idonyo iyie { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Tem Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Nywak PDF man ki ber bedo
cfr-doorhanger-firefox-send-ok-button = Tem { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Nen Gwokke
    .accesskey = N
cfr-doorhanger-socialtracking-close-button = Lor
    .accesskey = L
cfr-doorhanger-socialtracking-dont-show-again = Pe doki inyuta kwena calo man
    .accesskey = P

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } gengo lulub kor makato <b>{ $blockedCount }</b> nicake { $date }!
    }
cfr-doorhanger-milestone-ok-button = Nen Weng
    .accesskey = N

## What’s New Panel Content for Firefox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

