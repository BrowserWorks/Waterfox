# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Chilab'en K'amal
cfr-doorhanger-feature-heading = Chilab'en Samaj
cfr-doorhanger-pintab-heading = Tatojtob'ej rere': Pin Tab

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Aruma nintz'ët re'

cfr-doorhanger-extension-cancel-button = Wakami Mani
    .accesskey = M

cfr-doorhanger-extension-ok-button = Titz'aqatisäx Wakami
    .accesskey = T
cfr-doorhanger-pintab-ok-button = Tinak'ab'äx Re Ruwi' Re'
    .accesskey = T

cfr-doorhanger-extension-manage-settings-button = Kenuk'samajïx taq Kinuk'ulem Chilab'enïk
    .accesskey = K

cfr-doorhanger-extension-never-show-recommendation = Man Tik'ut re Chilab'enïk re'
    .accesskey = T

cfr-doorhanger-extension-learn-more-link = Tetamäx ch'aqa' chik

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = ruma { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Chilab'enïk
cfr-doorhanger-extension-notification2 = Chilab'enïk
    .tooltiptext = Ruchilab'exik k'amal
    .a11y-announcement = Ruchilab'exik k'amal k'o

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Chilab'enïk
    .tooltiptext = Rub'anikil chilab'enïk
    .a11y-announcement = Rub'anikil chilab'enïk k'o

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ch'umil
           *[other] { $total } taq ch'umil
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } okisanel
       *[other] { $total } okisanela'
    }

cfr-doorhanger-pintab-description = Katok anin pa ri ruxaq ak'amaya'l yalan nawokisaj. Ke'ajaqa' kan ri taq ruxaq k'amaya'l pa jun ruwi' (achi'el toq natikirisaj).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Ajkiq'a'-pitz'oj</b> pa ri ruwi' nawajo' nanak'ab'a'.
cfr-doorhanger-pintab-step2 = Ticha' <b>Nak'oj Ruwi'</b> pa ri k'utsamaj.
cfr-doorhanger-pintab-step3 = We k'o jun ruk'exoj ri ruxaq k'amaya'l, xtatz'ët jun xar chuq' pa ri ruwi' nak'ab'an.

cfr-doorhanger-pintab-animation-pause = Tiq'at
cfr-doorhanger-pintab-animation-resume = Titikïr chik el


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Xab'akuchi' Ke'axima' ri taq ayaketal.
cfr-doorhanger-bookmark-fxa-body = ¡Nïm ri xilitäj! Wakami man xa xe tarayij re yaketal re' pan taq awokisab'al. Tatikirisaj rik'in jun { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Wakami yexim taq yaketal...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Tz'apïy pitz'b'äl
    .title = Titz'apïx

## Protections panel

cfr-protections-panel-header = Katok pa k'amaya'l akuchi' man yatoqäx ta
cfr-protections-panel-body = Tik'oje' pan aq'a' ri awetamab'al. { -brand-short-name } yatruto' pa kiq'a' ri ojqanela' at kojqan toq yatok pa k'amab'ey.
cfr-protections-panel-link-text = Tetamäx ch'aqa' chik

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = K'ak'a' samaj:

cfr-whatsnew-button =
    .label = K'ak'a' Rutzijol
    .tooltiptext = K'ak'a' Rutzijol

cfr-whatsnew-panel-header = Achike natzijoj

cfr-whatsnew-release-notes-link-text = Tasik'ij ri k'ak'a' rutzijol

cfr-whatsnew-fx70-title = { -brand-short-name } wakami nuya' rejqalem ri awichinanem
cfr-whatsnew-fx70-body =
    Ri ruk'isib'äl k'exoj nrutzilaj ri Chajinïk chuwäch Ojqanem chuqa' nub'än
    chi man k'ayew ta ye'atz'ük ütz ewan taq tzij kichin ri taq ruxaq.

cfr-whatsnew-tracking-protect-title = Tachajij awi' chi kiwäch ri ojqanela'
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } ke'aqata' k'ïy winäq ojqanela' chuqa' xoch'in taq ruxaq ri
    nikitzeqelb'ej ri asamaj pa k'amab'ey.
cfr-whatsnew-tracking-protect-link-text = Tatz'eta' ri Atzijol.

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Q'aton ojqanel
       *[other] Eq'aton ojqanela'
    }
cfr-whatsnew-tracking-blocked-subtitle = Pa { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Titz'et ri Rutzijol

cfr-whatsnew-lockwise-backup-title = Ke'awachib'ej ri ewan taq atzij
cfr-whatsnew-lockwise-backup-body = Wakami yatikïr ye'atz'ük ütz ewan taq tzij, achoq kik'in yatikïr yatok xab'akuchi nawajo.
cfr-whatsnew-lockwise-backup-link-text = Ketzij jikomal taq wachib'enïk

cfr-whatsnew-lockwise-take-title = Ke'ak'waj ri ewan taq atzij awik'in
cfr-whatsnew-lockwise-take-body =
    Ri { -lockwise-brand-short-name } oyonib'äl chokoy nuya' q'ij chawe ütz yatok pa ri
    jikomal taq kiwachib'enik ewan atzij xab'akuchi.
cfr-whatsnew-lockwise-take-link-text = Tak'ulu' ri chokoy

## Search Bar

cfr-whatsnew-searchbar-title = Katz'ib'an jub'a', tawila' k'ïy rik'in ri rukajtz'ik ochochib'äl
cfr-whatsnew-searchbar-body-topsites = Wakami xa xe tacha' ri rukajtz'ik ochochib'äl richin nirik'itäj jun kajtz'ik rik'in riruximik kik'in nima'q taq ruxaq.
cfr-whatsnew-searchbar-icon-alt-text = Ruwachib'al tzub'äl

## Picture-in-Picture

cfr-whatsnew-pip-header = Ke'atz'eta' silowäch toq atokinäq pa k'amaya'l
cfr-whatsnew-pip-body = Ri Picture-in-picture nuk'üt ri silowäch pa jun wachin tzuwäch richin yatikïr natz'ët toq yasamäj pa jun chik ruwi'.
cfr-whatsnew-pip-cta = Tetamäx ch'aqa' chik

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Nitz taq pop-ups itzel taq ruxaq
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } wakami yeruq'ät taq ruxaq richin chi man pa kiyonil tikik'utuj nikitäq jun elenel rutzijol chawe.
cfr-whatsnew-permission-prompt-cta = Tetamäx ch'aqa' chik

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Xq'at b'anöy ruwi' q'ab'aj
       *[other] Xeq'at b'anöy ruwi' q'ab'aj
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } yeruq'ät k'ïy taq fingerprinter, ri yekimöl pan ewäl ri retamab'al awokisab'al chuqa' taq b'anoj richin ninuk' jun ruwäch ab'i' chi rij eltzijol.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } nitikïr yeruq'ät taq fingerprinter, ri yekimöl pan ewäl ri retamab'al awokisab'al chuqa' taq b'anoj richin ninuk' jun ruwäch ab'i' chi rij eltzijol.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Taya' re yaketal re' pan awoyonib'al
cfr-doorhanger-sync-bookmarks-body = Ke'ak'waj ri taq ayaketal, ewan atzij, natab'äl chuqa' ch'aqa' chik pa xab'achike k'ojlib'äl akuchi' natikirisaj molojri'ïl pa { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Titzij { -sync-brand-short-name }
    .accesskey = i

## Login Sync

cfr-doorhanger-sync-logins-header = Man Tasäch chik jun Ewan Tzij
cfr-doorhanger-sync-logins-body = Ütz ke'ayaka' ri ewan taq atzij chuqa' ke'axima' pa ronojel awokisab'al.
cfr-doorhanger-sync-logins-ok-button = Titzij { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Tisik'ïx re re' pa b'enam
cfr-doorhanger-send-tab-recipe-header = Tik'wäx re retal rikil pa rute' q'aq'
cfr-doorhanger-send-tab-body = Send Tab anin nuya' q'ij chawe nakomonij re ximöy tzij re' pan awoyonib'al o xab'akuchi' k'ojlib'äl akuchi' natikirisaj molojri'ïl pa { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Tatojtob'ej Send Tab
    .accesskey = t

## Firefox Send

cfr-doorhanger-firefox-send-header = Ütz tikomonïx re PDF re'
cfr-doorhanger-firefox-send-body = Ke'akolo' ri nïm taq awuj chuwäch itzel kitz'etik winaqi' rik'in chijun ewan rusik'ixik chuqa' rik'in jun ximonel, ri nisach el toq nik'is.
cfr-doorhanger-firefox-send-ok-button = Titojtob'ëx { -send-brand-name }
    .accesskey = t

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ketz'et taq chajinem
    .accesskey = h
cfr-doorhanger-socialtracking-close-button = Titz'apïx
    .accesskey = t
cfr-doorhanger-socialtracking-dont-show-again = Man kek'ut chik pe taq rutzijol achi'el re'
    .accesskey = M
cfr-doorhanger-socialtracking-heading = { -brand-short-name } xuq'ät chi jun aj winäq k'amab'ey yatrojqaj wawe'
cfr-doorhanger-socialtracking-description = K'atzinel ri awichinanem. { -brand-short-name } wakami yeruq'ät ri kojqanela' aj winäq k'amab'ey, nuq'ät runimilem tzij yetikïr nikimöl chi rij ri nasamajij pa k'amab'ey.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } xuq'ät jun tz'etöy retal ruwi' q'ab'aj pa re ruxaq re'
cfr-doorhanger-fingerprinters-description = Nïm ri awichinanem. { -brand-short-name } wakami yeruq'ät ri tz'etöy retal ruwi' q'ab'aj, ri yekimöl kich'akulal retamab'al retal winäq chi rij ri rokisab'al richin nrojqaj.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } xuq'ät jun ajkriptomin pa re ruxaq re'
cfr-doorhanger-cryptominers-description = Nïm ri awichinanem. { -brand-short-name } wakami yeruq'ät ri ajkriptomin, nikokisaj ruchuqa' rukematz'ib'il aq'inoj richin nrelesaj kematz'ib'il pwäq.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] ¡{ -brand-short-name } xeruq'ät k'ïy <b>{ $blockedCount }</b> taq ojqanela' pa { $date }!
       *[other] ¡{ -brand-short-name } xeruq'ät k'ïy <b>{ $blockedCount }</b> taq ojqanela' pa { $date }!
    }
cfr-doorhanger-milestone-ok-button = Titzet Ronojel
    .accesskey = t

cfr-doorhanger-milestone-close-button = Titz'apïx
    .accesskey = t

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Ke'atz'uku' aninäq jikïl ewan taq tzij
cfr-whatsnew-lockwise-body = K'ayew nich'ob' xa jun chuqa' jikïl ewan kitzij jujun rub'i' taqoya'l. Toq nitz'uk jun ewan tzij, tacha' ri ruk'ojlem ewan tzij richin nokisäx jun jikïl ewan tzij tz'ukun ruma { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } wachib'äl

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Tak'ulu' rutzijol kik'ayewal tz'ilanel ewan taq tzij
cfr-whatsnew-passwords-body = Ri ajjak ketaman chi ri winaqi' yekokisaj chik jub'ey ri ewan tzij. We xawokisaj jun ewan tzij pa jalajöj taq ruxaq k'amaya'l chuqa' we jun chi ke ri ruxaq k'amaya'l ri' nitz'iläx ri taq rutzij, xtatz'ët jun rutzijol k'ayewal pa { -lockwise-brand-short-name } richin najäl ri ewan atzij pa ri ruxaq k'amaya'l ri'.
cfr-whatsnew-passwords-icon-alt = Ruwachib'al tz'ilanel ewan tzij

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Tik'wäx ri picture-in-picture pa tz'aqät ruwäch
cfr-whatsnew-pip-fullscreen-body = Toq nak'waj jun silowäch pa jun xik'anel tzuwäch, yatikïr chik naya' ka'i' pitz'oj pa ruwi' ri tzuwäch richin nitz'aqatisäx rutzub'al.
cfr-whatsnew-pip-fullscreen-icon-alt = Ruwachib'al Picture-in-picture

## Protections Dashboard message

cfr-whatsnew-protections-header = Taq chajinïk wakami
cfr-whatsnew-protections-body = Ri rupas chajinïk eruk'wan ko'öl taq kitzijol kitz'ilanem tzij chuqa' kinuk'samajixik ewan taq tzij. Wakami yatikïr natz'ët jarupe' taq tz'ilanem xesol richin natz'ët we jun chi ke ri ewan taq atzij ayakon xtz'iläx pa jun tz'ilanem tzij.
cfr-whatsnew-protections-cta-link = Titz'et Kipas Chajinïk
cfr-whatsnew-protections-icon-alt = Ruwachib'al Pokob'

## Better PDF message

cfr-whatsnew-better-pdf-header = Jeb'ël etamab'äl chi rij PDF
cfr-whatsnew-better-pdf-body = Wakami ri aj PDF taq wuj jumul yejaq pa { -brand-short-name }, akuchi' k'o apon pan aq'a' ronojel ri asamaj.

## DOH Message

cfr-doorhanger-doh-body = K'o rejqalem ri awichinanem. { -brand-short-name } wakami nrojqaj rub'ey pa jikil rub'eyal ri DNS taq k'utuj, akuchi' k'o chi k'o jun achib'ilan samaj richin yatruchajij toq yatok pa k'amaya'l.
cfr-doorhanger-doh-header = Kikanoxik jikïl chuqa' man etaman ta rusik'ixik taq DNS
cfr-doorhanger-doh-primary-button = ÜTZ, Wetaman chik
    .accesskey = T
cfr-doorhanger-doh-secondary-button = Tichup
    .accesskey = h

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Yonil taq chajinïk chuwäch q'olonel rub'eyal richin ojqanem
cfr-whatsnew-clear-cookies-body = Jujun ojqanela' yatkik'waj pa juley taq ajk'amaya'l ruxaq ri nikib'än kinuk'ulem cookies pan ewäl. { -brand-short-name } ruyonil yeruyüj wakami ri cookies richin man katkojqaj ta.
cfr-whatsnew-clear-cookies-image-alt = Ruwachib'al q'aton cookie
