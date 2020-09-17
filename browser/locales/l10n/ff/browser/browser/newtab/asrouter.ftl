# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Jokkel basiyangel
cfr-doorhanger-feature-heading = Fannu basiyaaɗo
cfr-doorhanger-pintab-heading = Eto ɗum: Ñippu tabbere

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Hol ko waɗi mi yiyde ɗumɗoo

cfr-doorhanger-extension-cancel-button = Wonaa jooni
    .accesskey = N

cfr-doorhanger-extension-ok-button = Ɓeydu jooni
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Ñippu ndee tabbere
    .accesskey = Ñ

cfr-doorhanger-extension-manage-settings-button = Toppito teelte baggingol
    .accesskey = T

cfr-doorhanger-extension-never-show-recommendation = Hoto hollu am ndee wagginoore
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = Jokku taro

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = baɗɗo { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Wasiya

cfr-doorhanger-extension-notification2 = Wasiya
    .tooltiptext = Wagginoore timmitere
    .a11y-announcement = Wagginoore timmitere ina heɓoo

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Wagginoore
    .tooltiptext = Wagginoore fannu
    .a11y-announcement = Wagginoore fannu ina heɓoo

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } hoodere
           *[other] { $total } koode
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } kuutoro
       *[other] { $total } huutorɓe
    }

cfr-doorhanger-pintab-description = Yetto no weeɓiri e lowe maa ɓurɗe huutoreede. Waɗ lowe ɗee gudditiiɗe e tabbere (hay nde puɗɗitto-ɗaa).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Dobo-ñaamo</b>e tabbere njiɗɗaa ñippude ndee.
cfr-doorhanger-pintab-step2 = Suɓo <b>ñippu tabbere</b>nder dosol ngol.
cfr-doorhanger-pintab-step3 = SO lowre ndee dañii hesɗitinere maa yiy toɓɓel bulawel e tabbere maa ñippaande ndee.

cfr-doorhanger-pintab-animation-pause = Sabbo
cfr-doorhanger-pintab-animation-resume = Fuɗɗito


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Jokkondir maantore maa kala nokku.
cfr-doorhanger-bookmark-fxa-link-text = Jokkondir maantore jooni…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Butoŋ uddugol
    .title = Uddu

## Protections panel

cfr-protections-panel-header = Wanngo tawo a rewindaaka
cfr-protections-panel-body = Mooftan hoore maa keɓe maa. { -brand-short-name } ina reen maa e ko heewi e rewindotooɓe ɓurɓe wooweede rewooɓe e maa e ceŋogol.
cfr-protections-panel-link-text = Ɓeydu humpito

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Fannuji kesi:

cfr-whatsnew-button =
    .label = Ko Hesɗi
    .tooltiptext = Ko Hesɗi

cfr-whatsnew-panel-header = Ko Hesɗi

cfr-whatsnew-release-notes-link-text = Tar konngol bayyinol

cfr-whatsnew-fx70-title = { -brand-short-name }ina haɓee jooni no feewi ngam suturo maa

cfr-whatsnew-tracking-protect-title = Reen hoore maa e rewindotooɓe
cfr-whatsnew-tracking-protect-link-text = Yiy jaŋtol maa

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rewindotooɓe daaƴaaɓe
       *[other] Rewindotooɓe daaƴaaɓe
    }
cfr-whatsnew-tracking-blocked-subtitle = Gila { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Yiy jaŋtol

cfr-whatsnew-lockwise-backup-title = Danndu pinle maa
cfr-whatsnew-lockwise-backup-body = Jooni yeñtin pinle kisɗe ɗe mbaawɗaa heɓde kala ɗo ceŋiɗaa.

cfr-whatsnew-lockwise-take-title = Nawor pinle maa
cfr-whatsnew-lockwise-take-body =
    Jaaɓnirgal cinndel { -lockwise-brand-short-name } ngal ina newnan maa yettaade e kisal
    pinle maa danndaaɗe ka ɗo ngonɗaa.
cfr-whatsnew-lockwise-take-link-text = Heɓ jaaɓnirgal ngal

## Search Bar

cfr-whatsnew-searchbar-title = Tappu seeɗa, yiytu ko heese e palal ñiiɓirde
cfr-whatsnew-searchbar-body-topsites = Jooni, suɓo palal ñiiɓirde ngal, e maa boyet werto wonndude e jokke faade e lowe maa dowrowe.

## Picture-in-Picture

cfr-whatsnew-pip-header = Yeeɓ widewooji saanga nde mbanngoto-ɗaa
cfr-whatsnew-pip-cta = Ɓeydu humpito

## Permission Prompt

cfr-whatsnew-permission-prompt-cta = Ɓeydu humpito

## Fingerprinter Counter


## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Heɓ ngol maantorol e cinndel maa
cfr-doorhanger-sync-bookmarks-body = Naw maantore mma, pinle maa, aslol maa e goɗɗe kala ɗo ceŋiɗaa e { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Huɓɓu { -sync-brand-short-name }…
    .accesskey = H

## Login Sync

cfr-doorhanger-sync-logins-header = Hoto majjin finnde maa kadi abadaa.
cfr-doorhanger-sync-logins-body = Mooftu etee yahdin pinle maa e kaɓirɗe maa fof e kisal.
cfr-doorhanger-sync-logins-ok-button = Huɓɓu { -sync-brand-short-name }…
    .accesskey = H

## Send Tab

cfr-doorhanger-send-tab-header = Tar ɗum e yahdu
cfr-doorhanger-send-tab-body = Tabbere Neldude ina weeɓnan-maa lollinde ngol jokkol e cinndel maa walla kala nokku ceŋiɗaa e { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Eto neldude tabbere
    .accesskey = E

## Firefox Send

cfr-doorhanger-firefox-send-header = Lollin oo PDF e kisal
cfr-doorhanger-firefox-send-ok-button = Eto { -send-brand-name }
    .accesskey = E

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Yiy ndeenkaaji ɗii
    .accesskey = N
cfr-doorhanger-socialtracking-close-button = Uddu
    .accesskey = U
cfr-doorhanger-socialtracking-dont-show-again = Hoto hollam ɓatakuuji mbaaɗi nii goɗngol
    .accesskey = H

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } daaƴaama e<b>{ $blockedCount }</b>rewindottoɓe gila { $date }!
       *[other] { -brand-short-name } daaƴaama e<b>{ $blockedCount }</b>rewindottoɓe gila { $date }!
    }
cfr-doorhanger-milestone-ok-button = Yiy fof
    .accesskey = Y

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Sos pinle kisɗe no weeɓiri
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } Maandel

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Heɓ jeertine baɗte pinle jaafɗe
cfr-whatsnew-passwords-icon-alt = Maandel coktirgal finnde yaafnde

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Ƴettu njaajeendi yaynirde natal-nder-natal
cfr-whatsnew-pip-fullscreen-icon-alt = Maandel natal-nder-natal

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

