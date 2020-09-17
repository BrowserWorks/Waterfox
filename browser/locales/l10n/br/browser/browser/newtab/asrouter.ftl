# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Askouezh erbedet
cfr-doorhanger-feature-heading = Keweriuster erbedet
cfr-doorhanger-pintab-heading = Klaskit an dra-se: spilhennañ an ivinell

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Perak e welan an dra-mañ

cfr-doorhanger-extension-cancel-button = Ket bremañ
    .accesskey = K

cfr-doorhanger-extension-ok-button = Ouzhpennañ bremañ
    .accesskey = O
cfr-doorhanger-pintab-ok-button = Spilhennañ an ivinell-mañ
    .accesskey = S

cfr-doorhanger-extension-manage-settings-button = Merañ an arventennoù erbediñ
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = Na ziskouez din an erbedadenn-mañ
    .accesskey = N

cfr-doorhanger-extension-learn-more-link = Gouzout hiroc'h

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = gant { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Erbedadennoù
cfr-doorhanger-extension-notification2 = Erbedadenn
    .tooltiptext = Erbedadenn askouezh
    .a11y-announcement = Erbedadenn askouezh egerzh

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Erbedadenn
    .tooltiptext = Erbedadenn keweriuster
    .a11y-announcement = Un erbedadenn keweriuster nevez a zo da lenn

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } steredenn
            [two] { $total } steredenn
            [few] { $total } steredenn
            [many] { $total } a steredennoù
           *[other] { $total } steredenn
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } arveriad
        [two] { $total } arveriad
        [few] { $total } arveriad
        [many] { $total } a arveriadoù
       *[other] { $total } arveriad
    }

cfr-doorhanger-pintab-description = Haezit al lec'hiennoù gwellañ deoc'h en un doare aes. Mirit al lec'hiennoù digor en un ivinell (zoken pa adloc'hit).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klikit dehou</b> war an ivinell a fell deoc'h spilhennañ.
cfr-doorhanger-pintab-step2 = Dibabit <b>Spilhennañ an ivinell</b> el lañser.
cfr-doorhanger-pintab-step3 = Ma vez un hizivadenn gant al lec'hienn e welot ur pik glas war an ivinell spilhennet.

cfr-doorhanger-pintab-animation-pause = Ehaniñ
cfr-doorhanger-pintab-animation-resume = Kenderc'hel


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Goubredit ho sinedoù e pep lec'h.
cfr-doorhanger-bookmark-fxa-body = Kavet ho peus ul lec'hienn a-zoare! Bremañ eo dav deoc'h adkavout ar sined-mañ war ho trevnadoù hezoug. Krogit gant : { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Goubredit ar sinedoù bremañ...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Afell serriñ
    .title = Serriñ

## Protections panel

cfr-protections-panel-header = Merdeit hep bezañ heuliet
cfr-protections-panel-body = Mirit ho roadennoù ganeoc'h. { -brand-short-name } a warez ac'hanoc'h eus lodenn vrasañ an heulierien a sell ouzh ar pezh a rit enlinenn.
cfr-protections-panel-link-text = Gouzout hiroc'h

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Keweriuster nevez:

cfr-whatsnew-button =
    .label = Petra nevez
    .tooltiptext = Petra nevez

cfr-whatsnew-panel-header = Petra nevez

cfr-whatsnew-release-notes-link-text = Lenn an notennoù ermaeziañ

cfr-whatsnew-fx70-title = { -brand-short-name } a stourm evit ho puhez prevez
cfr-whatsnew-fx70-body = Gant an hizivadenn ziwezhañ eo kreñvaet ar gwarez a-enep d'an heuliañ hag aesoc'h c'hoazh eo da grouiñ gerioù-tremen diogel evit pep lec'hienn.

cfr-whatsnew-tracking-protect-title = Gwarezit ac'hanoc'h a-enep d'an heulierien
cfr-whatsnew-tracking-protect-body = { -brand-short-name } a stank meur a heulier kevredadel hag etre-lec'hienn a vez o spiañ ar pezh a rit enlinenn.
cfr-whatsnew-tracking-protect-link-text = Gwelout ho tanevell

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Heulier stanket
        [two] Heulierien stanket
        [few] Heulierien stanket
        [many] Heulierien stanket
       *[other] Heulierien stanket
    }
cfr-whatsnew-tracking-blocked-subtitle = Abaoe { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Gwelout an danevell

cfr-whatsnew-lockwise-backup-title = Gwarediñ ho kerioù-tremen
cfr-whatsnew-lockwise-backup-body = Bremañ eo gouest da grouiñ gerioù-tremen diogel a c'hallit gwelet eus kement lec'h a gennaskit outañ.
cfr-whatsnew-lockwise-backup-link-text = Gweredekaat ar gwaredoù

cfr-whatsnew-lockwise-take-title = Kemerit ho kerioù-tremen ganeoc'h
cfr-whatsnew-lockwise-take-body = Gant arload hezoug { -lockwise-brand-short-name } e c'hallit gwelout ho kerioù-tremen gwaredet adalek forzh pe lec'h.
cfr-whatsnew-lockwise-take-link-text = Kaout an arload

## Search Bar

cfr-whatsnew-searchbar-title = Skrivit nebeutoc'h ha kavit muioc'h gant ar varrenn chomlec'hioù
cfr-whatsnew-searchbar-body-topsites = Bremañ, diuzit ar varrenn chomlec'hioù, ha dont a raio war wel ur voest gant ereoù etrezek ho lec'hiennoù gwellañ.
cfr-whatsnew-searchbar-icon-alt-text = Arlun gwerenn-greskiñ

## Picture-in-Picture

cfr-whatsnew-pip-header = Sellit ouzh videoioù en ur verdeiñ
cfr-whatsnew-pip-body = Skeudenn-ouzh-skeudenn a lak ar video en ur prenestr war neuñv evit ma c'hallfec'h e sellet en ul labourat war ivinelloù all.
cfr-whatsnew-pip-cta = Gouzout hiroc'h

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Nebeutoc'h a brenestroù diflugell torr-penn
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } a vir al lec'hiennoù da c'houlenn kas deoc'h kemennadennoù diflugell ent emgefreek
cfr-whatsnew-permission-prompt-cta = Gouzout hiroc'h

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Dinoer roudoù niverel stanket
        [two] Dinoerien roudoù niverel stanket
        [few] Dinoerien roudoù niverel stanket
        [many] Dinoerien roudoù niverel stanket
       *[other] Dinoerien roudoù niverel stanket
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } a stank meur a zinoer roudoù niverel a zastum en un doare kuzh titouroù diwar-benn ho trevnad hag ho oberiantiz evit krouiñ un aelad bruderezh diwar ho penn.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Dinoerien roudoù niverel
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } a c'hall stankañ meur a zinoer roudoù niverel a zastum en un doare kuzh titouroù diwar-benn ho trevnad hag ho oberiantiz evit krouiñ un aelad bruderezh diwar ho penn.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Kaout ar sined-mañ war ho pellgomz
cfr-doorhanger-sync-bookmarks-body = Tapit ho sinedoù, gerioù-tremen roll istor ha muioc'h c'hoazh e pep lec'h ma 'z oc'h kennasket ouzh { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Gweredekaat { -sync-brand-short-name }
    .accesskey = G

## Login Sync

cfr-doorhanger-sync-logins-header = Na zisoñjit ket ho ker-tremen ken
cfr-doorhanger-sync-logins-body = Kadavit ha goubredit ho kerioù-tremen war ho holl drevnadoù.
cfr-doorhanger-sync-logins-ok-button = Gweredekaat { -sync-brand-short-name }
    .accesskey = G

## Send Tab

cfr-doorhanger-send-tab-header = Lennit an dra-se pa fell deoc'h
cfr-doorhanger-send-tab-recipe-header = Kasit ar rekipe-mañ er gegin
cfr-doorhanger-send-tab-body = Gant "Kas an ivinell" e c'hallit rannañ an ere-mañ d'ho pellgomz pe forzh pelec'h mard hoc'h kennasket ouzh { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Esaeit da gas an ivinell
    .accesskey = E

## Firefox Send

cfr-doorhanger-firefox-send-header = Rannit ar restr PDF-mañ en un doare diogel
cfr-doorhanger-firefox-send-body = Mirit ho teulioù kizidik da vezañ spiet gant an enrinegañ penn-ouzh-penn hag un ere a vo dilamet ur wech ma vo echu ganeoc'h.
cfr-doorhanger-firefox-send-ok-button = Esaeit { -send-brand-name }
    .accesskey = E

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Gwelout ar gwarezioù
    .accesskey = G
cfr-doorhanger-socialtracking-close-button = Serriñ
    .accesskey = S
cfr-doorhanger-socialtracking-dont-show-again = Na ziskouez din kemennadennoù evel-se en-dro
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } en deus harzhet ur rouedad kevredadel d'hoc'h heuliañ amañ
cfr-doorhanger-socialtracking-description = Pouezus eo ho puhez prevez. { -brand-short-name } a stank an heulierien media kevredadel boutin evit bevenniñ ar c'hementad a roadennoù a c'hallont dastum diwar-benn ar pezh a rit enlinenn.
cfr-doorhanger-fingerprinters-heading = Stanket eo bet un dinoerien roudoù niverel gant { -brand-short-name } war ar bajenn-mañ
cfr-doorhanger-fingerprinters-description = Pouezus eo ho puhez prevez. { -brand-short-name } a stank an dinoerien roudoù niverel, a zastum titouroù a c'hall servij da adanavezout ac'hanoc'h hag heuliañ ac'hanoc'h.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } en deus stanket ur c'hriptogleuzier war ar bajenn-mañ
cfr-doorhanger-cryptominers-description = Pouezus eo ho puhez prevez. { -brand-short-name } a stank kriptogleuzierien, a c'hall implij galloud jediñ ho reizhiad evit mengleuziañ arc'hant niverel.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> heulier gant { -brand-short-name } abaoe { $date }!Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> heulier gant { -brand-short-name } abaoe { $date }!
        [two] Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> heulier gant { -brand-short-name } abaoe { $date }!
        [few] Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> heulier gant { -brand-short-name } abaoe { $date }!
        [many] Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> a heulierien gant { -brand-short-name } abaoe { $date }!
       *[other] Stanket ez eus bet ouzhpenn <b>{ $blockedCount }</b> heulier gant { -brand-short-name } abaoe { $date }!
    }
cfr-doorhanger-milestone-ok-button = Gwelet pep tra
    .accesskey = G

cfr-doorhanger-milestone-close-button = Serriñ
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Krouit gerioù-tremen en un doare aes
cfr-whatsnew-lockwise-body = Diaes eo soñjal en ur ger-tremen dibar ha diogel evit pep kont. En ur grouiñ ur ger-tremen, diuzit maezienn ar ger-tremen evit ober gant unan diogel ha ganet gant { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = arlun { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Resevit galvoù-diwall a-zivout gerioù-tremen en arvar.
cfr-whatsnew-passwords-body = Gouzout a oar mat ar stlenn-laeron e vez adimplijet an hevelep gerioù-tremen gant an dud. Ma rit kement-se hag e vez diskuilhet roadennoù unan eus al lec'hiennoù-se e welot ur galv-diwall e { -lockwise-brand-short-name } a lâro deoc'h cheñch ho ker-tremen war al lec'hiennoù-se.
cfr-whatsnew-passwords-icon-alt = arlun ger-tremen arvarus

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Tremen e mod skramm a-bezh
cfr-whatsnew-pip-fullscreen-body = Pa lakait ur video da vezañ en ur prenestr distag e c'hallit bremañ daouglikañ war ar prenestr-mañ evit mont er skramm a-bezh.
cfr-whatsnew-pip-fullscreen-icon-alt = Arlun skeudenn-ouzh-skeudenn

## Protections Dashboard message

cfr-whatsnew-protections-header = Gwarez en un taol-lagad

## Better PDF message


## DOH Message

cfr-doorhanger-doh-secondary-button = Diweredekaat
    .accesskey = D

## What's new: Cookies message

