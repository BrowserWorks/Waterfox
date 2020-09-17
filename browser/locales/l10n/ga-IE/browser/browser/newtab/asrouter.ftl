# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Eisínteacht Mholta
cfr-doorhanger-feature-heading = Gné Mholta
cfr-doorhanger-pintab-heading = Bain triail as seo: Cluaisín a Phionnáil

##

cfr-doorhanger-extension-cancel-button = Níl Anois
    .accesskey = N

cfr-doorhanger-pintab-ok-button = Pionnáil an Cluaisín Seo
    .accesskey = P

cfr-doorhanger-extension-never-show-recommendation = Ná taispeáin an moladh seo dom
    .accesskey = t

cfr-doorhanger-extension-learn-more-link = Tuilleadh eolais

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = le { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Moladh

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } réiltín
            [two] { $total } réiltín
            [few] { $total } réiltín
            [many] { $total } réiltín
           *[other] { $total } réiltín
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } úsáideoir
        [two] { $total } úsáideoir
        [few] { $total } úsáideoir
        [many] { $total } n-úsáideoir
       *[other] { $total } úsáideoir
    }

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-animation-pause = Cuir ar Sos
cfr-doorhanger-pintab-animation-resume = Atosaigh


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-link-text = Sioncronaigh leabharmharcanna anois…

## Protections panel

cfr-protections-panel-link-text = Tuilleadh eolais

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Gné nua:

cfr-whatsnew-button =
    .label = Gnéithe Nua
    .tooltiptext = Gnéithe Nua

cfr-whatsnew-panel-header = Gnéithe Nua

cfr-whatsnew-release-notes-link-text = Léigh na nótaí eisiúna

cfr-whatsnew-tracking-blocked-subtitle = Ó { DATETIME($earliestDate, month: "long", year: "numeric") }

cfr-whatsnew-lockwise-backup-link-text = Cuir cúltacaí ar siúl

cfr-whatsnew-lockwise-take-title = Beir do chuid focal faire leat
cfr-whatsnew-lockwise-take-link-text = Faigh an aip

## Search Bar

## Picture-in-Picture

cfr-whatsnew-pip-header = Breathnaigh ar fhíseáin le linn brabhsála
cfr-whatsnew-pip-cta = Tuilleadh eolais

## Permission Prompt

cfr-whatsnew-permission-prompt-cta = Tuilleadh eolais

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Cuireadh cosc ar mhéarlorgaire amháin
        [two] Cuireadh cosc ar mhéarlorgairí
        [few] Cuireadh cosc ar mhéarlorgairí
        [many] Cuireadh cosc ar mhéarlorgairí
       *[other] Cuireadh cosc ar mhéarlorgairí
    }

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Méarlorgairí

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Faigh an leabharmharc ar d'fhón
cfr-doorhanger-sync-bookmarks-ok-button = Cuir { -sync-brand-short-name } ar siúl
    .accesskey = C

## Login Sync

cfr-doorhanger-sync-logins-header = Ná caill focal faire arís
cfr-doorhanger-sync-logins-ok-button = Cuir { -sync-brand-short-name } ar siúl
    .accesskey = C

## Send Tab


## Firefox Send

cfr-doorhanger-firefox-send-ok-button = Bain triail as { -send-brand-name }
    .accesskey = t

## Social Tracking Protection

cfr-doorhanger-socialtracking-close-button = Dún
    .accesskey = D
cfr-doorhanger-socialtracking-dont-show-again = Ná taispeáin teachtaireachtaí cosúil leis seo dom arís
    .accesskey = N
cfr-doorhanger-socialtracking-heading = Chuir { -brand-short-name } cosc ar líonra sóisialta a bhí ag iarraidh thú a lorg
cfr-doorhanger-fingerprinters-heading = Chuir { -brand-short-name } cosc ar mhéarlorgaire ar an leathanach seo
cfr-doorhanger-cryptominers-heading = Chuir { -brand-short-name } cosc ar chriptimhianadóir ar an leathanach seo

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] Níos mó ná <b>{ $blockedCount }</b> lorgaire coiscthe ag { -brand-short-name } ó { $date }!
        [two] Níos mó ná <b>{ $blockedCount }</b> lorgaire coiscthe ag { -brand-short-name } ó { $date }!
        [few] Níos mó ná <b>{ $blockedCount }</b> lorgaire coiscthe ag { -brand-short-name } ó { $date }!
        [many] Níos mó ná <b>{ $blockedCount }</b> lorgaire coiscthe ag { -brand-short-name } ó { $date }!
       *[other] Níos mó ná <b>{ $blockedCount }</b> lorgaire coiscthe ag { -brand-short-name } ó { $date }!
    }
cfr-doorhanger-milestone-ok-button = Féach Uile
    .accesskey = F

## What’s New Panel Content for Firefox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

