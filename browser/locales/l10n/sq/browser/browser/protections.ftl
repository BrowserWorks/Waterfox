# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } bllokoi { $count } gjurmues gjatë javës së kaluar
       *[other] { -brand-short-name } bllokoi { $count } gjurmues gjatë javës së kaluar
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> gjurmues i bblokuar që prej { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> gjurmues të bblokuar që prej { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } vazhdon të bllokojë gjurmues në Dritare Private, por nuk mban ndonjë regjistër se ç’është bllokuar.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Gjurmues që { -brand-short-name } bllokoi këtë javë

protection-report-webpage-title = Pult Mbrojtjesh
protection-report-page-content-title = Pult Mbrojtjesh
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name }-i mund të mbrojë privatësinë tuaj në prapaskenë, teksa shfletoni. Kjo është një përmbledhje e personalizuar e këtyre mbrojtjeve, përfshi mjete për të marrë kontrollin e sigurisë tuaj internetore.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name }-i mbron privatësinë tuaj në prapaskenë, teksa shfletoni. Kjo është një përmbledhje e personalizuar e këtyre mbrojtjeve, përfshi mjete për të marrë kontrollin e sigurisë tuaj internetore.

protection-report-settings-link = Administroni rregullime tuajat të privatësisë dhe sigurisë

etp-card-title-always = Mbrojtje e Thelluar Nga Gjurmimi: Përherë On
etp-card-title-custom-not-blocking = Mbrojtje e Thelluar Nga Gjurmimi: OFF
etp-card-content-description = { -brand-short-name }-i ndal automatikisht shoqëri t’ju ndjekin fshehtazi nëpër internet.
protection-report-etp-card-content-custom-not-blocking = Krejt mbrojtjet janë të çaktivizuara. Duke administruar rregullimet tuaja për mbrojtje { -brand-short-name }, zgjidhni cilët gjurmues të bllokohen.
protection-report-manage-protections = Administroni Rregullime

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Sot

# This string is used to describe the graph for screenreader users.
graph-legend-description = Një grafik që përmban numrin gjithsej sa herë është bllokuar çdo lloj gjurmuesi këtë javë.

social-tab-title = Gjurmues Prej Mediash Shoqërore
social-tab-contant = Gjurmuesit prej rrjete shoqërore vendosin gjurmues në sajte të tjerë për të ndjekur ç’bëni, ç’shihni dhe vëzhgoni kur jeni në internet. Kjo u lejon shoqërive të rrjeteve shoqërore të mësojnë më tepër rreth jush, tej asaj çka ndani me të tjerët në profilet tuaj në media shoqërore. <a data-l10n-name="learn-more-link">Mësoni më tepër</a>

cookie-tab-title = Cookies Gjurmimi Nga Sajte Në Sajte
cookie-tab-content = Këto cookies ju ndjekin nga sajti në sajt për të grumbulluar të dhëna rreth çka bëni në internet. Ato depozitohen nga palë të treta, të tilla si reklamues dhe shoqëri analizash. Bllokimi i cookie-ve që ju ndjekin nga sajti në sajt ul numrin e reklamave që ju ndjekin ngado. <a data-l10n-name="learn-more-link">Mësoni më tepër</a>

tracker-tab-title = Lëndë Gjurmimi
tracker-tab-description = Sajtet mund të ngarkojnë reklama, video dhe tjetër lëndë të jashtme me kod gjurmimi. Bllokimi i lëndës gjurmuese mund të ndihmojë për ngarkimin më të shpejtë të sajteve, por disa butona, formularë dhe fusha kredenciale hyrjesh mund të mos punojnë. <a data-l10n-name="learn-more-link">Mësoni më tepër</a>

fingerprinter-tab-title = Krijues shenjash gishtash
fingerprinter-tab-content = Krijuesit e shenjave të gishtave (<em>Fingerprinters</em>) grumbullojnë rregullime nga shfletuesi dhe kompjuteri juaj për të krijuar një profil rreth jush. Duke përdorur këto shenja dixhitale gishtash, ata mund t’ju ndjekin nëpër sajte të ndryshme. <a data-l10n-name="learn-more-link">Mësoni më tepër</a>

cryptominer-tab-title = Nxjerrës kriptomonedhash
cryptominer-tab-content = Nxjerrësit e kriptomonedhave e përdorin fuqinë përllogaritëse të sistemit tuaj për të nxjerrë para dixhitale. Programthet për nxjerrje kriptomonedhash konsumojnë energjinë e baterisë tuaj, ngadalësojnë kompjuterin tuaj dhe mund të sjellin shtim të faturës tuaj për energjinë. <a data-l10n-name="learn-more-link">Mësoni më tepër</a>

protections-close-button2 =
    .aria-label = Mbylle
    .title = Mbylle
  
mobile-app-title = Bllokoni gjurmues reklamash nëpër më shumë pajisje
mobile-app-card-content = Përdorni shfletuesin për celular me mbrojtje të brendshme kundër gjurmuesve të reklamave
mobile-app-links = Shfletuesi { -brand-product-name } për <a data-l10n-name="android-mobile-inline-link">Android</a> dhe <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Mos harroni kurrë më një fjalëkalim
lockwise-title-logged-in2 = Administrim Fjalëkalimesh
lockwise-header-content = { -lockwise-brand-name } depoziton në mënyrë të sigurt fjalëkalimet tuaj në shfletuesin tuaj.
lockwise-header-content-logged-in = Depozitoni dhe njëkohësoni në mënyrë të sigurt fjalëkalimet tuaj në krejt pajisjet tuaja.
protection-report-save-passwords-button = Ruaj Fjalëkalime
    .title = Ruajini Fjalëkalimet në { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Administroni Fjalëkalime
    .title = Administroni Fjalëkalime në { -lockwise-brand-short-name }
lockwise-mobile-app-title = Merrini fjalëkalimet tuaja kudo
lockwise-no-logins-card-content = Përdorni në çfarëdo pajisje fjalëkalime të ruajtur në { -brand-short-name }.
lockwise-app-links = { -lockwise-brand-name } për <a data-l10n-name="lockwise-android-inline-link">Android</a> dhe <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 fjalëkalim mund të jetë ekspoziar në cenim të dhënash.
       *[other] { $count } fjalëkalime mund të jenë ekspozuar në një cenim të dhënash.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 fjalëkalim u depozitua në mënyrë të sigurt.
       *[other] Fjalëkalimet tuaj po depozitohen në mënyrë të sigurt.
    }
lockwise-how-it-works-link = Si funksionon

turn-on-sync = Aktivizoni { -sync-brand-short-name }…
    .title = Shkoni te parapëlqimet rreth njëkohësimit

monitor-title = Shihni për cenime të dhënash
monitor-link = Si funksionon
monitor-header-content-no-account = Kontrolloni me { -monitor-brand-name } që të shihni nëse keni qenë prekur nga një cenim i ditur të dhënash, dhe merrni sinjalizime mbi cenime të reja.
monitor-header-content-signed-in = { -monitor-brand-name } ju vë në dijeni, nëse të dhënat tuaja janë shfaqur te një cenim i ditur të dhënash.
monitor-sign-up-link = Regjistrohuni për Sinjalizime rreth Cenimesh
    .title = Regjistrohuni në { -monitor-brand-name } për sinjalizime rreth cenimesh
auto-scan = Kontrolluar automatikisht sot

monitor-emails-tooltip =
    .title = Shihni adresa email të mbikëqyrura në { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Shihni cenime të ditur të dhënash në { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Shihni fjalëkalime të ekspozuar në { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Adresë email që mbikëqyret
       *[other] Adresa email që mbikëqyren
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Cenim i ditur të dhënash që ka ekspozuar të dhëna tuajat
       *[other] Cenime të ditur të dhënash që kanë ekspozuar të dhëna tuajat
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Cenim i ditur të dhënash, shënuar si i zgjidhur
       *[other] Cenime të ditur të dhënash, shënuar si të zgjidhur
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Fjalëkalim i ekspozuar në krejt cenimet
       *[other] Fjalëkalime të ekspozuar në krejt cenimet
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Fjalëkalim i ekspozuar në cenime të pazgjidhur
       *[other] Fjalëkalime të ekspozuar në cenime të pazgjidhur
    }

monitor-no-breaches-title = Lajme të mbara!
monitor-no-breaches-description = S’keni cenime të ditura. Nëse kjo punë ndryshon, do t’jua bëjmë të ditur.
monitor-view-report-link = Shiheni Raportin
    .title = Zgjidhni cenime në { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Zgjidhni cenimet tuaja
monitor-breaches-unresolved-description = Pasi të shqyrtoni hollësi cenimesh dhe ndërmerrni hapat për të mbrojtur të dhënat tuaja, mund t’u vini shenjë cenimeve si të zgjidhur.
monitor-manage-breaches-link = Administroni Cenime
    .title = Administroni cenime në { -monitor-brand-short-name }
monitor-breaches-resolved-title = Ju lumtë! I keni zgjidhur krejt cenimet e ditura.
monitor-breaches-resolved-description = Nëse email-i juaj shfaqet në ndonjë cenim të ri, do t’jua bëjmë të ditur.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } nga { $numBreaches } cenime gjithsej shënuar si të zgjidhura
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% e plotësuar

monitor-partial-breaches-motivation-title-start = Fillim i mbarë!
monitor-partial-breaches-motivation-title-middle = Vazhdoni kështu!
monitor-partial-breaches-motivation-title-end = Thuajse mbaruat! Vazhdoni kështu.
monitor-partial-breaches-motivation-description = Zgjidhni pjesën e mbetur të cenimeve te { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Zgjidhni Cenime
    .title = Zgjidhni cenime në { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Gjurmues prej Mediash Shoqërore
    .aria-label =
        { $count ->
            [one] { $count } gjurmues prej mediash shoqërore ({ $percentage }%)
           *[other] { $count } gjurmues prej mediash shoqërore ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies Gjurmimi Nga Sajte Në Sajte
    .aria-label =
        { $count ->
            [one] { $count } cookie gjurmimi nga sajte në sajte ({ $percentage }%)
           *[other] { $count } cookies gjurmimi nga sajte në sajte ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Lëndë Gjurmimi
    .aria-label =
        { $count ->
            [one] { $count } lëndë gjurmimi ({ $percentage }%)
           *[other] { $count } lëndë gjurmimi ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Krijues shenjash gishtash
    .aria-label =
        { $count ->
            [one] { $count } krijues shenjash gishtash ({ $percentage }%)
           *[other] { $count } krijues shenjash gishtash ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Nxjerrës kriptomonedhash
    .aria-label =
        { $count ->
            [one] { $count } nxjerrës kriptomonedhash ({ $percentage }%)
           *[other] { $count } nxjerrës kriptomonedhash ({ $percentage }%)
        }
