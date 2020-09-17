# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Leudachan a mholamaid
cfr-doorhanger-feature-heading = Gleus a mholamaid
cfr-doorhanger-pintab-heading = Feuch seo: Prìnich an taba

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Carson a tha mi a’ faicinn seo?

cfr-doorhanger-extension-cancel-button = Chan ann an-dràsta
    .accesskey = d

cfr-doorhanger-extension-ok-button = Cuir ris an-dràsta
    .accesskey = C
cfr-doorhanger-pintab-ok-button = Prìnich an taba seo
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Stiùirich roghainnean nam molaidhean
    .accesskey = m

cfr-doorhanger-extension-never-show-recommendation = Na seall am moladh seo dhomh
    .accesskey = s

cfr-doorhanger-extension-learn-more-link = Barrachd fiosrachaidh

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = le { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Moladh

cfr-doorhanger-extension-notification2 = Moladh
    .tooltiptext = Leudachan a mholamaid
    .a11y-announcement = Tha moladh leudachain ann

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Moladh
    .tooltiptext = Gleus a mholamaid
    .a11y-announcement = Tha moladh gleus ann

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } rionnag
            [two] { $total } rionnag
            [few] { $total } rionnagan
           *[other] { $total } rionnag
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } chleachdaiche
        [two] { $total } chleachdaiche
        [few] { $total } cleachdaichean
       *[other] { $total } cleachdaiche
    }

cfr-doorhanger-pintab-description = Faigh cothrom luath air na làraichean a chleachdas tu gu tric. Cùm làraichean fosgailte ’nan tabaichean (fiù ma nì thu ath-thòiseachadh).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Dèan briogadh deas</b> air an taba a tha thu airson prìneachadh.
cfr-doorhanger-pintab-step2 = Tagh <b>Prìnich an taba</b> on chlàr-taice.
cfr-doorhanger-pintab-step3 = Ma thig ùrachadh air an làrach, chì thu dotag ghorm air an taba phrìnichte agad.

cfr-doorhanger-pintab-animation-pause = Cuir ’na stad
cfr-doorhanger-pintab-animation-resume = Lean air


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sioncronaich na comharran-lìn agad àite sam bith.
cfr-doorhanger-bookmark-fxa-body = Abair faodalach! Nise, na bi as aonais a’ chomharra-lìn seo air na h-uidheaman mobile agad. Faigh { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sioncronaich na comharran-lìn an-dràsta…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Am putan airson dùnadh
    .title = Dùin

## Protections panel

cfr-protections-panel-header = Dèan brabhsadh gun daoine a’ cumail sùil ort
cfr-protections-panel-body = Cùm an dàta agad agad fhèin. Dìonaidh { -brand-short-name } thu o mhòran dhe na tracaichean as cumanta a leanas mun cuairt thu air an lìon.
cfr-protections-panel-link-text = Barrachd fiosrachaidh

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Gleus ùr:

cfr-whatsnew-button =
    .label = Na tha ùr
    .tooltiptext = Na tha ùr

cfr-whatsnew-panel-header = Na tha ùr

cfr-whatsnew-release-notes-link-text = Leugh na nòtaichean sgaoilidh

cfr-whatsnew-fx70-title = Tha { -brand-short-name } a’ strì nas cruaidhe airson do phrìobhaideachd a-nis
cfr-whatsnew-fx70-body =
    Tha an t-ùrachadh seo a’ cur spionnadh sa ghleus a dhìonas o thracadh thu agus
    nì e fiù nas fhasa e faclan-faire tèarainte a chruthachadh airson gach làrach.

cfr-whatsnew-tracking-protect-title = Dìon thu fhèin o thracaichean
cfr-whatsnew-tracking-protect-body =
    Bacaidh { -brand-short-name } mòran dhe na tracaichean cumanta a leanas riut
    air feadh làraichean agus nam meadhanan sòisealta.
cfr-whatsnew-tracking-protect-link-text = Seall an aithisg agad

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] tracaiche air a bhacadh
        [two] thracaiche air a bhacadh
        [few] tracaichean air am bacadh
       *[other] tracaiche air am bacadh
    }
cfr-whatsnew-tracking-blocked-subtitle = A-mach o { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Seall an aithisg

cfr-whatsnew-lockwise-backup-title = Dèan lethbhreac-glèidhidh dhe na faclan-faire agad
cfr-whatsnew-lockwise-backup-body = Gin faclan-faire tèarainte a-nis as urrainn dhut cleachdadh àite sam bith far an clàraich thu a-steach.
cfr-whatsnew-lockwise-backup-link-text = Cuir na lethbhreacan-glèidhidh air

cfr-whatsnew-lockwise-take-title = Thoir leat na faclan-faire agad
cfr-whatsnew-lockwise-take-body =
    Bheir an aplacaid mobile { -lockwise-brand-short-name } cothrom tèarainte dhut
    air na faclan-faire a rinn thu lethbhreac-glèidhidh dhiubh ge be càit am bi thu.
cfr-whatsnew-lockwise-take-link-text = Faigh an aplacaid

## Search Bar

cfr-whatsnew-searchbar-title = Faigh lorg air rudan nas luaithe le nas lugha de sgrìobhadh le bàr an t-seolaidh
cfr-whatsnew-searchbar-body-topsites = Nise, cha leig thu leas ach bàr an t-seòlaidh a thaghadh agus nochdaidh bogsa le ceanglaichean ri brod nan làrach agad.
cfr-whatsnew-searchbar-icon-alt-text = Ìomhaigheag na glainne-mheudachaidh

## Picture-in-Picture

cfr-whatsnew-pip-header = Coimhead air videothan fhad ’s a nì thu brabhsadh
cfr-whatsnew-pip-body = Cuiridh an gleus “Dealbh am broinn deilbh” videothan ann an uinneag air fleod ach an urrainn dhut coimhead air fhad ’s a nì thu obair sna tabaichean eile.
cfr-whatsnew-pip-cta = Barrachd fiosrachaidh

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Nas lugha de phriob-uinneagan a bhriseas a-steach ort air làraichean
cfr-whatsnew-permission-prompt-body = Cumaidh { -brand-shorter-name } làraichean o bhith a’ cur teachdaireachdan fèin-obrachail ann am priob-uinneagan thugad a-nis.
cfr-whatsnew-permission-prompt-cta = Barrachd fiosrachaidh

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] lorgaiche-meur air a bhacadh
        [two] lorgaiche-meur air a bhacadh
        [few] lorgaichean-meur air am bacadh
       *[other] lorgaiche-meur air am bacadh
    }
cfr-whatsnew-fingerprinter-counter-body = Bacaidh { -brand-shorter-name } iomadh lorgaiche-meur a chruinnicheas fiosrachadh os ìseal mun uidheam agad is mu na nì thu airson pròifil sanasachd a chruthachadh dhìot.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Lorgaichean-meur
cfr-whatsnew-fingerprinter-counter-body-alt = ’S urrainn dha { -brand-shorter-name } iomadh lorgaiche-meur a bhacadh a chruinnicheas fiosrachadh os ìseal mun uidheam agad is mu na nì thu airson pròifil sanasachd a chruthachadh dhìot.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Faigh an comharra-lìn seo air an fhòn agad
cfr-doorhanger-sync-bookmarks-body = Thoir leat na comharran-lìn, faclan-faire, an eachdraidh ’s mòran a bharrachd àite sam bith far an do chlàraich thu a-steach gu { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Cuir { -sync-brand-short-name } air
    .accesskey = C

## Login Sync

cfr-doorhanger-sync-logins-header = Na caill facal-faire a-rithist gu bràth
cfr-doorhanger-sync-logins-body = Cùm is sioncronaich na faclan-faire agad gu tèarainte eadar na h-uidheaman agad.
cfr-doorhanger-sync-logins-ok-button = Cuir { -sync-brand-short-name } air
    .accesskey = C

## Send Tab

cfr-doorhanger-send-tab-header = Leugh seo air an rathad
cfr-doorhanger-send-tab-recipe-header = Thoir leat an reasabaidh seo dhan chidsin
cfr-doorhanger-send-tab-body = Bheir gleus cur nan tabaichean comas dhut an ceangal seo a chur gun fhòn agad no àite sam bith far an do chlàraich thu a-steach gu { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Feuch gleus cur nan taba
    .accesskey = F

## Firefox Send

cfr-doorhanger-firefox-send-header = Co-roinn am PDF seo gu tèarainte
cfr-doorhanger-firefox-send-body = Cùm na sgrìobhainnean dìomhair agad sàbhailte o shùilean sireach le crioptachadh finn-fuainneach agus ceangal a thèid air falbh nuair a bhios tu deiseil leis.
cfr-doorhanger-firefox-send-ok-button = Feuch { -send-brand-name }
    .accesskey = F

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Seall an dìon
    .accesskey = S
cfr-doorhanger-socialtracking-close-button = Dùin
    .accesskey = D
cfr-doorhanger-socialtracking-dont-show-again = Na seall dhomh teachdaireachdan mar seo a-rithist
    .accesskey = N
cfr-doorhanger-socialtracking-heading = Chùm { -brand-short-name } lìonra sòisealta o bhith ’gad thracadh an-seo
cfr-doorhanger-socialtracking-description = Tha do phrìobhaideachd cudromach. Bacaidh { -brand-short-name } tracaichean cumanta nam meadhanan sòisealta a-nis, a’ cuingeachadh an dàta as urrainn dhaibh cruinneachadh mu na nì thu air loidhne.
cfr-doorhanger-fingerprinters-heading = Bhac { -brand-short-name } lorgaiche-meur air an duilleag seo
cfr-doorhanger-fingerprinters-description = Tha do phrìobhaideachd cudromach. Bacaidh { -brand-short-name } lorgaichean-meur a-nis, gleusan a chruinneachas pìosan de dhàta àraidh air an aithnichear an t-uidheam agad gus do thracadh.
cfr-doorhanger-cryptominers-heading = Bhac { -brand-short-name } criopto-mhèinneadair air an duilleag seo
cfr-doorhanger-cryptominers-description = Tha do phrìobhaideachd cudromach. Bacaidh { -brand-short-name } criopto-mhèinneadairean a-nis, gleusan a chleachdas cumhachd a’ choimpiutair agad airson airgead digiteach a mhèinnearachd.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] Bhac { -brand-short-name } barrachd air  <b>{ $blockedCount }</b> tracaiche o { $date }!
        [two] Bhac { -brand-short-name } barrachd air  <b>{ $blockedCount }</b> thracaiche o { $date }!
        [few] Bhac { -brand-short-name } barrachd air  <b>{ $blockedCount }</b> tracaichean o { $date }!
       *[other] Bhac { -brand-short-name } barrachd air  <b>{ $blockedCount }</b> tracaiche o { $date }!
    }
cfr-doorhanger-milestone-ok-button = Seall na h-uile
    .accesskey = S

## What’s New Panel Content for Firefox 76

## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

## DOH Message

## What's new: Cookies message

