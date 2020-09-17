# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Dopórucone rozšyrjenje
cfr-doorhanger-feature-heading = Dopórucona funkcija
cfr-doorhanger-pintab-heading = Wopytajśo to: Rejtarik pśipěś

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Cogodla se to pokazujo

cfr-doorhanger-extension-cancel-button = Nic něnto
    .accesskey = N

cfr-doorhanger-extension-ok-button = Něnto pśidaś
    .accesskey = d
cfr-doorhanger-pintab-ok-button = Toś ten rejtarik pśipěś
    .accesskey = T

cfr-doorhanger-extension-manage-settings-button = Dopóruceńske nastajenja zastojaś
    .accesskey = D

cfr-doorhanger-extension-never-show-recommendation = Toś to dopórucenje njepokazaś
    .accesskey = T

cfr-doorhanger-extension-learn-more-link = Dalšne informacije

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = wót { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Pórucenje
cfr-doorhanger-extension-notification2 = Dopórucenje
    .tooltiptext = Dopórucenje rozšyrjenja
    .a11y-announcement = Dopórucenje rozšyrjenja k dispoziciji

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Dopórucenje
    .tooltiptext = Dopórucenje funkcije
    .a11y-announcement = Dopórucenje funkcije k dispoziciji

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } gwězdka
            [two] { $total } gwězdce
            [few] { $total } gwězdki
           *[other] { $total } gwězdkow
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } wužywaŕ
        [two] { $total } wužywarja
        [few] { $total } wužywarje
       *[other] { $total } wužywarjow
    }

cfr-doorhanger-pintab-description = Mějśo lažki pśistup k swójim nejwěcej wužywane sedła. Źaržćo sedła w rejtariku wócynjone (samo gaž znowego startujośo)

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klikniśo z pšaweju tastu</b> na rejtarik, kótaryž cośo pśipěś.
cfr-doorhanger-pintab-step2 = Wubjeŕśo <b>Rejtarik pśipěś</b> z menija.
cfr-doorhanger-pintab-step3 = Jolic sedło ma aktualizaciju, buźośo módry dypk na swójom pśipětem rejtariku wiźeś.

cfr-doorhanger-pintab-animation-pause = Pawza
cfr-doorhanger-pintab-animation-resume = Pókšacowaś


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronizěrujśo swóje cytańske znamjenja wšuźi.
cfr-doorhanger-bookmark-fxa-body = Wjelicna namakanka! Njewóstawajśo bźez toś togo cytańskego znamjenja na swójich mobilnych rědach. Zachopśo z { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronizěrujśo něnto cytańske znamjenja…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Tłocašk Zacyniś
    .title = Zacyniś

## Protections panel

cfr-protections-panel-header = Pśeglědujśo bźez togo, aby wam slědowało
cfr-protections-panel-body = Wobchowajśo swóje daty za sebje. { -brand-short-name } was pśed wjele z nejcesćejych pśeslědowakow šćita, kótarež slěduju, což online gótujośo.
cfr-protections-panel-link-text = Dalšne informacije

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nowa funkcija:

cfr-whatsnew-button =
    .label = Nowe funkcije a změny
    .tooltiptext = Nowe funkcije a změny

cfr-whatsnew-panel-header = Nowe funkcije a změny

cfr-whatsnew-release-notes-link-text = Wersijowe informacije cytaś

cfr-whatsnew-fx70-title = { -brand-short-name } šěščej za wašu priwatnosć wójujo
cfr-whatsnew-fx70-body = Nejnowša aktualizacija funkciju slědowański šćit pólěpšujo a wólažcujo wěcej nježli gdy do togo, wěste gronidła za kužde sedło napóraś.

cfr-whatsnew-tracking-protect-title = Šćitajśo se pśed pśeslědowakami
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } wjele cestych pśeslědowakow socialnych a drugich sedłow, kótarež
    slěduju, což online gótujośo.
cfr-whatsnew-tracking-protect-link-text = Wašu rozpšawu pokazaś

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Pśeslědowak jo se zablokěrował
        [two] Pśeslědowaka stej se zablokěrowałej
        [few] Pśeslědowaki su se zablokěrowali
       *[other] Přeslědowaki su se zablokěrowali
    }
cfr-whatsnew-tracking-blocked-subtitle = Wót { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Rozpšawu pokazaś

cfr-whatsnew-lockwise-backup-title = Zawěsććo swóje gronidła
cfr-whatsnew-lockwise-backup-body = Napórajśo něnto wěste gronidła, ku kótarymž maśo wšuźi pśistup, źož se pśizjawijośo.
cfr-whatsnew-lockwise-backup-link-text = Zawěsćenja zmóžniś

cfr-whatsnew-lockwise-take-title = Wzejśo swóje gronidła sobu
cfr-whatsnew-lockwise-take-body = Mobilne nałoženje { -lockwise-brand-short-name } wam wěsty pśistup k wašym zawěsćonym gronidłam wót wšuźi zmóžnja,
cfr-whatsnew-lockwise-take-link-text = Wobstarajśo se nałoženje

## Search Bar

cfr-whatsnew-searchbar-title = Pišćo mjenjej a namakajśo wěcej z adresowym pólom
cfr-whatsnew-searchbar-body-topsites = Wubjeŕśo něnto jadnorje adresowe pólo a  kašćik z wótkazami na waše nejlubše sedła se wócynijo.
cfr-whatsnew-searchbar-icon-alt-text = Lupowy symbol

## Picture-in-Picture

cfr-whatsnew-pip-header = Woglědajśo se wideo, mjaztym až pśeglědujośo
cfr-whatsnew-pip-body = Funkcija Wobraz-we-wobrazu wideo w znošujucem se woknje pokazujo, aby se wy jo mógał woglědaś, gaž w drugich rejtarikach źěłaśo.
cfr-whatsnew-pip-cta = Dalšne informacije

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mjenjej gramnych wuskokujuych woknow
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } něnto websedłam zawoborujo, awtomatiski se pšašaś, lěc směju wuskokujuce powěsći pósłaś.
cfr-whatsnew-permission-prompt-cta = Dalšne informacije

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Palcowy wótśišć zablokěrowany
        [two] Palcowej wótśišća zablokěrowanej
        [few] Palcowe wótśišće zablokěrowane
       *[other] Palcowe wótśišće zablokěrowane
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } wjele palcowych śišćow blokěrujo, kótarež informacije wó wašom rěźe a akcijach gromaźe, aby wabjeński profil wó was napórali.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Palcowe wótśišće
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } móžo wjele palcowych śišćow blokěrowaś, kótarež informacije wó wašom rěźe a akcijach gromaźe, aby wabjeński profil wó was napórali.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Spórajśo toś to cytańske znamje na swój telefon
cfr-doorhanger-sync-bookmarks-body = Wzejśo swóje cytańske znamjenja, gronidła, historiju a wěcej wšuźi sobu, źož sćo se pśizjawił pla { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } zmóžniś
    .accesskey = m

## Login Sync

cfr-doorhanger-sync-logins-header = Njezgubujśo nigda wěcej gronidło
cfr-doorhanger-sync-logins-body = Składujśo a synchronizěrujśo swóje gronidł ze wšymi swójimi rědami.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } zmóžniś
    .accesskey = z

## Send Tab

cfr-doorhanger-send-tab-header = Cytajśo to pó droze
cfr-doorhanger-send-tab-recipe-header = Spórajśo toś ten recept do kuchnje
cfr-doorhanger-send-tab-body = Send Tab wam zmóžnja, toś ten wótkaz lažko ze swójim telefonom źěliś abo wšuźi, źož sćo se pśizjawił pla { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Send Tab wopytaś
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Źělśo toś ten PDF wěsće
cfr-doorhanger-firefox-send-body = Šćitajśo swóje sensibelne dokumenty pśed narskimi póglědnjenjami z koděrowanim kóńc do kóńca a z wótkazom, kótaryž se zgubijo, gaž sćo gótowy.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } wopytaś
    .accesskey = o

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Šćit pokazaś
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Zacyniś
    .accesskey = Z
cfr-doorhanger-socialtracking-dont-show-again = Powěsći ako toś tu wěcej njepokazaś
    .accesskey = P
cfr-doorhanger-socialtracking-heading = { -brand-short-name } socialnej seśi zawoborał, wam how slědowaś
cfr-doorhanger-socialtracking-description = Waša priwatnosć jo wažna. { -brand-short-name } něnto zwucone pśeslědowaki socialnych medijow blokěrujo, wobgranicujo tšochu datow, kótarež mógu wó tom zběraś, což wy online gótujośo.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } jo zablokěrował palcowe wótśišće na toś tom boku
cfr-doorhanger-fingerprinters-description = Waša priwatnosć jo wažna. { -brand-short-name } něnto palcowe wótśišće blokěrujo, kótarež jasnje idenficěrujobne informacije wó wašom rěźe gromaźe, aby wam slědowali.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } jo zablokěrował kryptokopak na toś tom boku
cfr-doorhanger-cryptominers-description = Waša priwatnosć jo wažna. { -brand-short-name } něnto kryptokopaki blokěrujo, kótarež liceńske wugbaśe wašogo systema wužywaju, aby digitalne pjenjeze wudobywali.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } jo zablokěrował wušej <b>{ $blockedCount }</b> pśeslědowaka wót { $date }!
        [two] { -brand-short-name } jo zablokěrował wušej <b>{ $blockedCount }</b> pśeslědowakowu wót { $date }!
        [few] { -brand-short-name } jo zablokěrował wušej <b>{ $blockedCount }</b> pśeslědowakow wót { $date }!
       *[other] { -brand-short-name } jo zablokěrował wušej <b>{ $blockedCount }</b> pśeslědowakow wót { $date }!
    }
cfr-doorhanger-milestone-ok-button = Wšykne pokazaś
    .accesskey = k

cfr-doorhanger-milestone-close-button = Zacyniś
    .accesskey = Z

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Wěste gronidła lažko napóraś
cfr-whatsnew-lockwise-body = Jo śěžko na to mysliś, jadnorazowe, wěste gronidła za kužde konto wužywaś. Gaž gronidło napórajośo, wubjeŕśo gronidkowe pólo, aby wěste, napórane gronidło z { -brand-shorter-name } wužywał.
cfr-whatsnew-lockwise-icon-alt = Symbol { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Dostańśo warnowanja wó zranliwych gronidłach
cfr-whatsnew-passwords-body = Hackery wěźe, až luźe te samske gronidła wužywaju. Jolic sćo wužył to samske gronidło na někotarych sedłach, a jadno z tych sedłow jo było w datowej źěrje, buźośo warnowanje w { -lockwise-brand-short-name } wiźeś, až maśo swójo gronidło na tych sedłach změniś.
cfr-whatsnew-passwords-icon-alt = Symbol kluca zranliwego gronidła

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Połnu wobrazowku wobraz-we-wobrazu wužywaś
cfr-whatsnew-pip-fullscreen-body = Gaž wideo do znošujucego se wokna tkajośo, móžośo dwójcy na to wokno kliknuś, aby se jo w połnej wobrazowce woglědał.
cfr-whatsnew-pip-fullscreen-icon-alt = Symbol wobraz-we-wobrazu

## Protections Dashboard message

cfr-whatsnew-protections-header = Šćity na jadno póglědnjenje
cfr-whatsnew-protections-body = Pśeglěd šćitow zespominujuce rozpšawy wó datowych źěrach a zastojanju gronidłow. Móžośo něnto slědowaś, wjele źěrow sćo rozwězał a wiźeś, lěc jadno abo wěcej gronidłow jo było datowej źěrje wustajone.
cfr-whatsnew-protections-cta-link = Pśeglěd šćitow pokazaś
cfr-whatsnew-protections-icon-alt = Šćitowy symbol

## Better PDF message

cfr-whatsnew-better-pdf-header = Lěpše PDF-dožywjenje
cfr-whatsnew-better-pdf-body = PDF-dokumenty se něnto direktnje w { -brand-short-name } wócynjaju, bźeztogo aby musył źěłowy wótběg pśetergnuś.

## DOH Message

cfr-doorhanger-doh-body = Waša priwatnosć jo wažna. { -brand-short-name } něnto, gažkuli jo móžno, partnaŕskej słužbje waše DNS-napšašowanja wěsće pśenosujo, aby was šćitał, mjaztym až pśeglědujośo.
cfr-doorhanger-doh-header = Wěcej wěstych skoděrowanych DNS-pytanjow
cfr-doorhanger-doh-primary-button = W pórěźe, som zrozměł
    .accesskey = r
cfr-doorhanger-doh-secondary-button = Znjemóžniś
    .accesskey = Z

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Awtomatiski šćit pśed zakśebjatnymi slědowańskimi taktikami
cfr-whatsnew-clear-cookies-body = Někotare pśeslědowaki was k drugim websedłam dalej pósrědnjaju, kótarež kšajźu cookieje stajaju. { -brand-short-name } něnto te cookieje awtomatiski lašujo, až  njeby móžno było, wam slědowaś.
cfr-whatsnew-clear-cookies-image-alt = Ilustracija za zablokěrowany cookie
