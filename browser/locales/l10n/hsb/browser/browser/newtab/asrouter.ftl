# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Doporučene rozšěrjenje
cfr-doorhanger-feature-heading = Doporučena funkcija
cfr-doorhanger-pintab-heading = Spytajće to: Rajtark připjeć

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Čehodla so to pokazuje

cfr-doorhanger-extension-cancel-button = Nic nětko
    .accesskey = N

cfr-doorhanger-extension-ok-button = Nětko přidać
    .accesskey = d
cfr-doorhanger-pintab-ok-button = Tutón rajtark připjeć
    .accesskey = T

cfr-doorhanger-extension-manage-settings-button = Doporučenske nastajenja rjadować
    .accesskey = D

cfr-doorhanger-extension-never-show-recommendation = Tute doporučenje njepokazać
    .accesskey = T

cfr-doorhanger-extension-learn-more-link = Dalše informacije

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = wot { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Doporučenje
cfr-doorhanger-extension-notification2 = Doporučenje
    .tooltiptext = Doporučenje rozšěrjenja
    .a11y-announcement = Doporučenje rozšěrjenja k dispoziciji

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Doporučenje
    .tooltiptext = Doporučenje funkcije
    .a11y-announcement = Doporučenje funkcije k dispoziciji

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } hwěžka
            [two] { $total } hwěžce
            [few] { $total } hwěžki
           *[other] { $total } hwěžkow
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } wužiwar
        [two] { $total } wužiwarjej
        [few] { $total } wužiwarjo
       *[other] { $total } wužiwarjow
    }

cfr-doorhanger-pintab-description = Mějće lochki přistup na swoje najwjace wužiwane sydła. Dźeržće sydła w rajtarku wočinjene (samo hdyž znowa startujeće)

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klikńće z prawej tastu</b> na rajtark, kotryž chceće připjeć.
cfr-doorhanger-pintab-step2 = Wubjerće <b>Rajtark připjeć</b> z menija.
cfr-doorhanger-pintab-step3 = Jeli sydło ma aktualizaciju, budźeće módry dypk na swojim připjatym rajtarku widźeć.

cfr-doorhanger-pintab-animation-pause = Přestawka
cfr-doorhanger-pintab-animation-resume = Pokročować


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronizujće swoje zapołožki wšudźe.
cfr-doorhanger-bookmark-fxa-body = Wulkotna namakanka! Njewostawajće bjez tuteje zapołožki na swojich mobilnych gratach. Započńće z { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronizujće nětko zapołožki…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Tłóčatko Začinić
    .title = Začinić

## Protections panel

cfr-protections-panel-header = Přehladujće bjez toho, zo by wam slědowało
cfr-protections-panel-body = Wobchowajće swoje daty za sebje. { -brand-short-name } was před wjele z najhusćišich přesćěhowakow škita, kotrež slěduja, štož online činiće.
cfr-protections-panel-link-text = Dalše informacije

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nowa funkcija:

cfr-whatsnew-button =
    .label = Nowe funkcije a změny
    .tooltiptext = Nowe funkcije a změny

cfr-whatsnew-panel-header = Nowe funkcije a změny

cfr-whatsnew-release-notes-link-text = Wersijowe informacije čitać

cfr-whatsnew-fx70-title = { -brand-short-name } ćešo za wašu priwatnosć wojuje
cfr-whatsnew-fx70-body = Najnowša aktualizacija funkciju slědowanski škit polěpša a wosnadnja bóle hač hdy prjedy, wěste hesła za kóžde sydło wutworić.

cfr-whatsnew-tracking-protect-title = Škitajće so před přesćěhowakami
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } wjele hustych přesćěhowakow socialnych a druhich sydłow, kotrež
    slěduja, štož online činiće.
cfr-whatsnew-tracking-protect-link-text = Wašu rozprawu pokazać

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Přesćěhowak je so zablokował
        [two] Přesćěhowakaj stej so zablokowałoj
        [few] Přesćěhowaki su so zablokowali
       *[other] Přesćěhowaki su so zablokowali
    }
cfr-whatsnew-tracking-blocked-subtitle = Wot { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Rozprawu pokazać

cfr-whatsnew-lockwise-backup-title = Zawěsćće swoje hesła
cfr-whatsnew-lockwise-backup-body = Wutworće nětko wěste hesła, na kotrež maće wšudźe přistup, hdźež so přizjewiće.
cfr-whatsnew-lockwise-backup-link-text = Zawěsćenja zmóžnić

cfr-whatsnew-lockwise-take-title = Wzmiće swoje hesła sobu
cfr-whatsnew-lockwise-take-body = Mobilne nałoženje { -lockwise-brand-short-name } wam wěsty přistup na swoje zawěsćene hesła wot wšudźe zmóžnja,
cfr-whatsnew-lockwise-take-link-text = Wobstarajće sej nałoženje

## Search Bar

cfr-whatsnew-searchbar-title = Pisajće mjenje a namakajće wjace z adresowym polom
cfr-whatsnew-searchbar-body-topsites = Wubjerće nětko prosće adresowe polo a  kašćik z wotkazami na waše najlubše sydła so wočini.
cfr-whatsnew-searchbar-icon-alt-text = Lupowy symbol

## Picture-in-Picture

cfr-whatsnew-pip-header = Wobhladajće sej wideja, mjeztym zo přehladujeće
cfr-whatsnew-pip-body = Funkcija Wobraz-we-wobrazu widejo w znošowacym so woknje pokazuje, zo byšće sej jo móhł wobhladać, hdyž w druhich rajtarkach dźěłaće.
cfr-whatsnew-pip-cta = Dalše informacije

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mjenje nawalnych wuskakowacych woknow
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } nětko websydła při tym haći, awtomatisce so prašeć, hač smědźa wuskakowace powěsće pósłać.
cfr-whatsnew-permission-prompt-cta = Dalše informacije

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Porstowy wotćišć zablokowany
        [two] Porstowej wotćišćej zablokowanej
        [few] Porstowe wotćišće zablokowane
       *[other] Porstowe wotćišće zablokowane
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } wjele porstowych ćišćow blokuje, kotrež informacije wo wašim graće a akcijach hromadźa, zo bychu wabjenski profil wo was wutworili.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Porstowe wotćišće
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } móže wjele porstowych ćišćow blokować, kotrež informacije wo wašim graće a akcijach hromadźa, zo bychu wabjenski profil wo was wutworili.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Přinjesće tutu zapołožku na swój telefon
cfr-doorhanger-sync-bookmarks-body = Wzmiće swoje zapołožki, hesła, historiju a wjace wšudźe sobu, hdźež sće so pola { -brand-product-name } přizjewił.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } zmóžnić
    .accesskey = m

## Login Sync

cfr-doorhanger-sync-logins-header = Njezhubjejće ženje wjace hesło
cfr-doorhanger-sync-logins-body = Składujće a synchronizujće swoje hesła ze wšěmi swojimi gratami.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } zmóžnić
    .accesskey = z

## Send Tab

cfr-doorhanger-send-tab-header = Čitajće to po puću
cfr-doorhanger-send-tab-recipe-header = Donjesće tutón recept do kuchnje
cfr-doorhanger-send-tab-body = Send Tab wam zmóžnja, tutón wotkaz lochko ze swojim telefonom dźělić abo wšudźe, hdźež sće so pola { -brand-product-name } přizjewił.
cfr-doorhanger-send-tab-ok-button = Send Tab wupruwować
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Dźělće tutón PDF wěsće
cfr-doorhanger-firefox-send-body = Škitajće swoje sensibelne dokumenty před wćipnymi pohladami ze zaklučowanjom kónc do kónca a z wotkazom, kotryž so zhubi, hdyž sće hotowy.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } wupruwować
    .accesskey = u

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Škit pokazać
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Začinić
    .accesskey = Z
cfr-doorhanger-socialtracking-dont-show-again = Powěsće kaž tutu hižo so njepokazać
    .accesskey = P
cfr-doorhanger-socialtracking-heading = { -brand-short-name } je socialnu syć při tym haćił, wam tu slědować
cfr-doorhanger-socialtracking-description = Waša priwatnosć je wažna. { -brand-short-name } nětko zwučene přesćěhowaki socialnych medijow blokuje, wobmjezuje mnóstwo datow, kotrež móža wo tym zběrać, štož wy online činiće.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } je porstowe wotćišće na tutej stronje zablokował
cfr-doorhanger-fingerprinters-description = Waša priwatnosć je wažna. { -brand-short-name } nětko porstowe wotćišće blokuje, kotrež jasnje idenfikujomne informacije wo wašim graće hromadźa, zo bychu wam slědowali.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } je kryptokopak na tutej stronje zablokował
cfr-doorhanger-cryptominers-description = Waša priwatnosć je wažna. { -brand-short-name } nětko kryptokopaki blokuje, kotrež ličenski wukon wašeho systema wužiwaja, zo bychu digitalne pjenjezy wudobyli.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } je přez <b>{ $blockedCount }</b> přesćěhowak wot { $date } zablokował!
        [two] { -brand-short-name } je přez <b>{ $blockedCount }</b> přesćěhowakaj wot { $date } zablokował!
        [few] { -brand-short-name } je přez <b>{ $blockedCount }</b> přesćěhowaki wot { $date } zablokował!
       *[other] { -brand-short-name } je přez <b>{ $blockedCount }</b> přesćěhowakow wot { $date } zablokował!
    }
cfr-doorhanger-milestone-ok-button = Wšě pokazać
    .accesskey = k

cfr-doorhanger-milestone-close-button = Začinić
    .accesskey = Z

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Wěste hesła lochko wutworić
cfr-whatsnew-lockwise-body = Je ćežko na to myslić, jónkróćne, wěste hesła za kóžde konto wužiwać. Hdyž hesło wutworjeće, wubjerće hesłowe polo, zo byšće wěste, spłodźene hesło z { -brand-shorter-name } wužiwał.
cfr-whatsnew-lockwise-icon-alt = Symbol { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Dóstańcé warnowanja wo zranitych hesłach
cfr-whatsnew-passwords-body = Hackerojo wědźa, zo ludźo samsne hesła wužiwaja. Jeli sće samsne hesło na wjacorych sydłach wužił, a jedne z tych sydłow je w datowej dźěrje było, budźeće warnowanje w { -lockwise-brand-short-name } widźeć, zo maće swoje hesło na tych sydłach změnić.
cfr-whatsnew-passwords-icon-alt = Symbol zranitych hesłow

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Połnu wobrazowku wobraz-we-wobrazu wužiwać
cfr-whatsnew-pip-fullscreen-body = Hdyž widejo do znošowaceho so wokna tykaće, móžeće dwójce na te wokno kliknyć, zo byšće jo w połnej wobrazowce wobhladał.
cfr-whatsnew-pip-fullscreen-icon-alt = Symbol wobraz-we-wobrazu

## Protections Dashboard message

cfr-whatsnew-protections-header = Škity na jedne pohladnjenje
cfr-whatsnew-protections-body = Přehlad škitow zjimace rozprawy wo datowych dźěrach a rjadowanju hesłow. Móžeće nětko slědować, kelko dźěrow sće rozrisał a widźeć, hač jedne abo wjace hesłow bě datowej dźěrje wustajene.
cfr-whatsnew-protections-cta-link = Přehlad škitow pokazać
cfr-whatsnew-protections-icon-alt = Tarčowy symbol

## Better PDF message

cfr-whatsnew-better-pdf-header = Lěpše PDF-dožiwjenje
cfr-whatsnew-better-pdf-body = PDF-dokumenty so nětko direktnje w { -brand-short-name } wočinjeja, bjeztoho zo byšće dyrbjał dźěłowy wotběh přetorhnyć.

## DOH Message

cfr-doorhanger-doh-body = Waša priwatnosć je wažna. { -brand-short-name } nětko, hdyžkuli je móžno, partnerskej słužbje waše DNS-naprašowanja wěsće přenošuje, zo by was škitał, mjeztym zo přehladujeće.
cfr-doorhanger-doh-header = Wjace wěstych zaklučowanych DNS-pytanjow
cfr-doorhanger-doh-primary-button = W porjadku, sym zrozumił
    .accesskey = r
cfr-doorhanger-doh-secondary-button = Znjemóžnić
    .accesskey = Z

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Awtomatiski škit před zachribjetnymi slědowanskimi taktikami
cfr-whatsnew-clear-cookies-body = Někotre přesćěhowaki was k druhim websydłam dale sposrědkuja, kotrež skradźu placki stajeja. { -brand-short-name } nětko te placki awtomatisce haša, zo njeby móžno było, wam slědować.
cfr-whatsnew-clear-cookies-image-alt = Ilustracija za zablokowany plack
