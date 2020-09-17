# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Inirerekomendang Extension
cfr-doorhanger-feature-heading = Inirerekomenda na Tampok
cfr-doorhanger-pintab-heading = Subukan: Mag-pin ng Tab

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Bakit ko nakikita ito
cfr-doorhanger-extension-cancel-button = Hindi Ngayon
    .accesskey = H
cfr-doorhanger-extension-ok-button = Idagdag Ngayon
    .accesskey = A
cfr-doorhanger-pintab-ok-button = I-pin itong Tab
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = Mangasiwa sa Rekomendasyong Itinakda
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = Itago ang Rekomendasyong ito
    .accesskey = I
cfr-doorhanger-extension-learn-more-link = Alamin
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = ni { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomendasyon
cfr-doorhanger-extension-notification2 = Rekomendasyon
    .tooltiptext = Rekomendasyon
    .a11y-announcement = Rekomendasyon
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomendasyon
    .tooltiptext = Rekomendasyon
    .a11y-announcement = Rekomendasyon

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } bituin
           *[other] { $total } mga bituin
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } taga-gamit
       *[other] { $total } mga taga-gamit
    }
cfr-doorhanger-pintab-description = I-access ang mga pinakaginagamit mong site sa pinakamadaling paraan. Panatilihing bukas ang mga site sa isang tab (kahit magrestart ka pa).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Mag-<b>Right-click</b> sa tab na gusto mong i-pin.
cfr-doorhanger-pintab-step2 = Piliin ang <b>Pin Tab</b> mula sa menu.
cfr-doorhanger-pintab-step3 = Kung ang site ay may pagbabago may makikitang asul na tuldok sa iyong naka-pin na tab.
cfr-doorhanger-pintab-animation-pause = Sandaling ihinto
cfr-doorhanger-pintab-animation-resume = Ipagpatuloy

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = I-sync mo ang mga bookmark mo kahit saan.
cfr-doorhanger-bookmark-fxa-body = Magaling! Ngayon huwag kang magpaiwan nang wala ang bookmark na ito sa mga mobile devices mo. Simulan mo sa pamamagitan ng { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = I-sync na ang mga bookmark...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Button para isara
    .title = Isara

## Protections panel

cfr-protections-panel-header = Mag-browse nang hindi sinusundan
cfr-protections-panel-body = Itago mo ang data na para sa iyo lamang. Pinoprotektahan ka ng { -brand-short-name } mula sa mga karaniwang tracker na nagmamanman sa mga gawain mo online.
cfr-protections-panel-link-text = Karagdagang kaalaman

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Bagong tampok:
cfr-whatsnew-button =
    .label = Ano ang Bago
    .tooltiptext = Ano ang Bago
cfr-whatsnew-panel-header = Ano ang Bago
cfr-whatsnew-release-notes-link-text = Basahin ang mga release note
cfr-whatsnew-fx70-title = Ipinaglalaban ka ng { -brand-short-name } para sa iyong privacy.
cfr-whatsnew-fx70-body = Pinaigi sa pinakabagong update ang Tracking Protection feature at lalong pinadali ang paggawa ng ligtas na mga password para sa bawat site.
cfr-whatsnew-tracking-protect-title = Protektahan ang iyong sarili mula sa mga tracker
cfr-whatsnew-tracking-protect-body = Hinaharang ng { -brand-short-name } ang karaniwang mga social at cross-site tracker na nagmamanman sa mga gawain mo online.
cfr-whatsnew-tracking-protect-link-text = Tingnan ang Iyong Ulat
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Tracker na naharang
       *[other] Mga tracker na naharang
    }
cfr-whatsnew-tracking-blocked-subtitle = Magmula pa noong { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Tingnan ang Ulat
cfr-whatsnew-lockwise-backup-title = I-back up ang iyong mga password
cfr-whatsnew-lockwise-backup-body = Ngayon ay nakagagawa na ng mga ligtas na password na pwede mong ma-access saan man ka mag-sign in.
cfr-whatsnew-lockwise-backup-link-text = Buksan ang mga backup
cfr-whatsnew-lockwise-take-title = Dalhin kahit saan ang iyong mga password
cfr-whatsnew-lockwise-take-body = Hinahayaan ka ng { -lockwise-brand-short-name } mobile app na ligtas na ma-access kahit saan ang iyong mga naka-backup na mga password.
cfr-whatsnew-lockwise-take-link-text = Kunin ang app

## Search Bar

cfr-whatsnew-searchbar-title = Mag-type nang mas kaunti at maghanap nang mas marami sa address bar
cfr-whatsnew-searchbar-body-topsites = Ngayon, piliin lang ang address bar, at may magpapakitang box na may mga link sa mga top site mo.
cfr-whatsnew-searchbar-icon-alt-text = Magnifying glass icon

## Picture-in-Picture

cfr-whatsnew-pip-header = Manood ng mga video habang ikaw ay nagba-browse
cfr-whatsnew-pip-body = Binubuksan ng Picture-in-picture ang video sa lumulutang na window para maaari kang manood habang abala sa ibang mga tab.
cfr-whatsnew-pip-cta = Alamin

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mas kaunting nakaiinis na mga pop-up
cfr-whatsnew-permission-prompt-body = Hinaharangan na ngayon ng { -brand-shorter-name } ang mga site na kusang humihiling na magpadala ng mga pop-up na mensahe sa iyo.
cfr-whatsnew-permission-prompt-cta = Alamin

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Naharang na Fingerprinter
       *[other] Naharang na mga Fingerprinter
    }
cfr-whatsnew-fingerprinter-counter-body = Hinaharang ng { -brand-shorter-name } ang maraming mga fingerprinter na palihim na nangangalap ng impormasyon tungkol sa iyong device at mga pagkilos para gumawa ng isang advertising profile tungkol sa iyo.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Mga Fingerprinter
cfr-whatsnew-fingerprinter-counter-body-alt = Maaaring harangan ng { -brand-shorter-name } ang mga fingerprinter na palihim na nangangalap ng impormasyon ukol sa iyong device at mga action para gumawa ng iyong advertising profile.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Kunin ang bookmark na ito sa iyong telepono
cfr-doorhanger-sync-bookmarks-body = Dalhin mo kahit saan ang iyong mga bookmark, password, kasaysayan at iba pa basta't naka-sign in ka sa { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Buksan ang { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Huwag nang Muling Makalimot ng Password
cfr-doorhanger-sync-logins-body = Ligtas na iimbak at i-sync ang mga password mo sa lahat ng iyong mga device.
cfr-doorhanger-sync-logins-ok-button = Buksan ang { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Basahin habang bumibyahe
cfr-doorhanger-send-tab-recipe-header = Dalhin ang recipe na ito sa kusina
cfr-doorhanger-send-tab-body = Pinapadali ng Send Tab ang pagbahagi ng link na ito sa phone mo o sa kahit saang lugar na naka-sign in ka sa { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Subukan ang Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Ibahagi ang PDF na ito sa ligtas na paraan
cfr-doorhanger-firefox-send-body = Pangalagaan ang iyong mga maselang dokumento gamit ang end-to-end encryption at isang link na nawawala kapag tapos ka na rito.
cfr-doorhanger-firefox-send-ok-button = Subukan ang { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Tingnan ang mga Proteksyon
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Isara
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Huwag na pakita ang mga mensahe na ganito
    .accesskey = H
cfr-doorhanger-socialtracking-heading = Pinigilan ng { -brand-short-name } ang isang social network na sundan ka rito
cfr-doorhanger-socialtracking-description = Mahalaga ang iyong privacy. Hinaharang na ngayon ng { -brand-short-name } ang mga karaniwang social media tracker, nililimitahan kung gaano karaming data ang pwede nilang kolektahin patungkol sa mga gawain mo online.
cfr-doorhanger-fingerprinters-heading = Hinarang ng { -brand-short-name } ang isang fingerprinter sa pahinang ito
cfr-doorhanger-fingerprinters-description = Mahalaga ang iyong privacy. Hinaharang na ngayon ng { -brand-short-name } ang mga fingerprinter, na nangongolekta ng bukod-tanging impormasyon tungkol sa device mo para masundan ka.
cfr-doorhanger-cryptominers-heading = Hinarang ng { -brand-short-name } ang isang cryptominer sa pahinang ito
cfr-doorhanger-cryptominers-description = Mahalaga ang iyong privacy. Hinaharang na ngayon ng { -brand-short-name } ang mga cryptominer, na ginagamit ang computing power ng sistema mo para magmina ng digital money.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } blocked over <b>{ $blockedCount }</b> trackers since { $date }!
    }
cfr-doorhanger-milestone-ok-button = Tingnan Lahat
    .accesskey = T
cfr-doorhanger-milestone-close-button = Isarado
    .accesskey = I

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Gumawa ng ligtas na password nang walang kahirap-hirap
cfr-whatsnew-lockwise-body = Mahirap mag-isip ng kakaiba't ligtas na password sa bawat account. Kapag gumagawa ng password, piliin ang password field para gumamit ng ligtas na nabuong password mula sa { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icon ng { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Tumanggap ng mga alerto tungkol sa mga mahihinang password
cfr-whatsnew-passwords-body = Alam ng mga hacker na inuulit-ulit lang ang mga password na ginagamit ng mga tao. Kung ginamit mo ang kaparehong password sa iba't-ibang mga site, at isa sa mga iyon ay natagpuan sa isang data breach, makakakita ka ng alerto sa { -lockwise-brand-short-name } para baguhin ang password sa site na iyon.
cfr-whatsnew-passwords-icon-alt = Vulnerable password key icon

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = I-fullscreen ang picture-in-picture
cfr-whatsnew-pip-fullscreen-body = Kapag pinanood mo ang isang video sa floating window, pwede mo na itong i-double-click para gawing fullscreen.
cfr-whatsnew-pip-fullscreen-icon-alt = Picture-in-picture icon

## Protections Dashboard message

cfr-whatsnew-protections-cta-link = Tingnan ang Protections Dashboard
cfr-whatsnew-protections-icon-alt = Shield icon

## Better PDF message

cfr-whatsnew-better-pdf-header = Mas magandang PDF experience
cfr-whatsnew-better-pdf-body = Direkta nang magbubukas ang mga PDF document sa { -brand-short-name }, kaya mas madali mo nang gawin ang mga ito.

## DOH Message

cfr-doorhanger-doh-primary-button = OK, Nakuha ko
    .accesskey = O
cfr-doorhanger-doh-secondary-button = i-Disable
    .accesskey = D

## What's new: Cookies message

