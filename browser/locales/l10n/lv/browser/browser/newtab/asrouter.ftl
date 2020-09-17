# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Ieteicams paplašinājums

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kāpēc es šo redzu

cfr-doorhanger-extension-cancel-button = Ne tagad
    .accesskey = N

cfr-doorhanger-extension-ok-button = Pievienot
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Parvaldit ieteikumu iestatījumus
    .accesskey = m

cfr-doorhanger-extension-never-show-recommendation = Neuzrādīt man šo ieteikumu
    .accesskey = N

cfr-doorhanger-extension-learn-more-link = Uzzināt vairāk

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = autors { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Ieteikums

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [zero] { $total } zvaigzne
            [one] { $total } zvaigznes
           *[other] { $total } zvaigžņu
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [zero] { $total } lietotājs
        [one] { $total } lietotāji
       *[other] { $total } lietotāju
    }

## These messages are steps on how to use the feature and are shown together.


## Firefox Accounts Message


## Protections panel


## What's New toolbar button and panel

cfr-whatsnew-button =
    .label = Kas jauns?
    .tooltiptext = Kas jauns?

cfr-whatsnew-panel-header = Kas jauns?

cfr-whatsnew-release-notes-link-text = Izlasiet laidiena piezīmes

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [zero] Bloķēts izsekotājs
        [one] Bloķēti izsekotāji
       *[other] Bloķēti izsekotāji
    }
cfr-whatsnew-tracking-blocked-link-text = Aplūkot ziņojumu

cfr-whatsnew-lockwise-backup-title = Dublējiet savas paroles
cfr-whatsnew-lockwise-backup-body = Tagad ģenerējiet drošas paroles, kurām varat piekļūt visur, kur pierakstāties.
cfr-whatsnew-lockwise-backup-link-text = Ieslēdziet dublēšanu

cfr-whatsnew-lockwise-take-title = Paņemiet paroles sev līdz

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

