# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } yessewḥel { $count } n uneḍfaṛ smana yezrin
       *[other] { -brand-short-name } yessewḥel { $count } n yineḍfaṛen smana yezrin
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> n uneḍfaṛ yewḥel seg { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> n yineḍfaṛen weḥlen seg { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } ad ikemmel ad isewḥel ineḍfaṛen deg yisfuyla n tunigin tusligt, maca ur iḥerrez ara lǧeṛṛa n wayen iweḥlen.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Ineḍfaṛen { -brand-short-name } ttwaḥebsen ddurt-agi

protection-report-webpage-title = Ammesten n tfelwit n usenqed
protection-report-page-content-title = Ammesten n tfelwit n usenqed
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } yezmer ad yeḥrez tabaḍnit-ik ɣef wayen yeffren mi ara tettinigeḍ. D agzul udmawan n tigra-nni, daɣen akked yifecka akken ad yezg usenqed n tɣellist-inek srid.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } Iḥerrez tabaḍnit-ik ɣef wayen yeffren mi ara tettinigeḍ. D agzul udmawan n tigra-nni, daɣen akked yifecka akken ad yezg usenqed n tɣellist-inek srid.

protection-report-settings-link = Sefrek iɣewwaṛen-ik n tbaḍnit d tɣellist.

etp-card-title-always = Ammesten mgal aḍfaṛ yettwaseǧhed: Yezga iteddu
etp-card-title-custom-not-blocking = Ammesten mgal aḍfaṛ yettwaseǧhed: Yensa
etp-card-content-description = { -brand-short-name } yessewḥal s wudem awurman tikebbaniyin ara ak-iḍefren deg web.
protection-report-etp-card-content-custom-not-blocking = Meṛṛa ammesten yensa akka tura. Fren ineḍfaṛen ara tesweḥleḍ s usefrek n yiɣewwaṛen n ummesten n { -brand-short-name }.
protection-report-manage-protections = Sefrek iɣewwaṛen

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Ass-a

# This string is used to describe the graph for screenreader users.
graph-legend-description = Udlif igebren amḍan amatu n yal anaw n uneḍfaṛ iweḥlen smana-a.

social-tab-title = Ineḍfaṛen n iẓeḍwa imettanen
social-tab-contant = Iẓeḍwa n tmetti srusun ineḍfaren deg yesmal web-nniḍen akken ad ḍefren ayen txedmeḍ, tettwaliḍ, akken d wayen tettnezziheḍ srid. Ayagi yettaǧǧa tikebbaniyin n yiẓeḍwa n tmetti ad issinen ugar n wayen tbeṭṭuḍ deg yimeɣna-k n yiẓeḍwa n tmetti. <a data-l10n-name="learn-more-link"> Issin ugar</a>

cookie-tab-title = Inagan n tuqqna i uḍfaṛ gar yismal
cookie-tab-content = Inagan-a n tuqqna ṭṭafaṛen-k seg usmel ɣer wayeḍ akken ad d-leqqḍen isefka ɣef wayen i t xeddmeḍ srid. Tgen-ten wiyaḍ am yimberraḥen akked tkabbaniyin n tesleḍt. Asewḥel n yinagan n tuqqna gar yismal, ad isenɣeṣ amḍan n udellel i k-yeṭṭafaṛen seg usmel ɣer wayeḍ. <a data-l10n-name="learn-more-link">Issin ugar</a>

tracker-tab-title = Agbur n uḍfaṛ
tracker-tab-description = Ismal Web zemren ad d-salin adellel, tividyutin akked igburen izɣarayen i igebren iferdisen n uḍfaṛ. Asewḥel n ugbur yettwasemras akked ad yesɣiwel asali n yisebtar, maca kra n tqeffalin, tiferkiyin neɣ urtan n tuqqna zemren ur teddun ara. <a data-l10n-name="learn-more-link">Issin ugar</a>

fingerprinter-tab-title = Idsilen umḍinen
fingerprinter-tab-content = Idsilen umḍinen leqqḍen-d iɣewwaṛen seg yiminig-ik akked uselkim-ik akken ad rnun amaqnu fell-ak. Aseqdec n udsil-a umḍin, zemren ad k-ḍefṛen gar yismal iɣer i trezzuḍ. <a data-l10n-name="learn-more-link">Issin ugar</a>

cryptominer-tab-title = Ikripṭuminaren
cryptominer-tab-content = Ikripṭuminaren seqdacen tazmert n usiḍen n unagraw-ik akken ad kksen tadrimt tumḍint. Iskripten n yikripṭuminaren sseɣṣen aẓru-ik, saẓayen aselkim-ik, daɣen zemren ad salin tafaturt-ik n ṣṣehd. <a data-l10n-name="learn-more-link">Issin ugar</a>

protections-close-button2 =
    .aria-label = Mdel
    .title = Mdel
  
mobile-app-title = Sewḥel ineḍfaren deg ugar n yibenkan
mobile-app-card-content = Seqdec iminig aziraz s ummesten usliɣ mgal aḍfaṛ n udellel.
mobile-app-links = Iminig { -brand-product-name }  i <a data-l10n-name="android-mobile-inline-link">Android</a> akked <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Ur sṛuḥuy ara awalen-ik uffiren
lockwise-title-logged-in2 = Asefrek n wawal uffir
lockwise-header-content = { -lockwise-brand-name } iseklas awalen uffiren-ik deg iminig-ik s wudem aɣelsan.
lockwise-header-content-logged-in = Sekles rnu mtawi awalen-ik·im uffiren ɣef yibenkan-ik·im i meṛṛa s wudem aɣelsan.
protection-report-save-passwords-button = Sekles awalen uffiren
    .title = Sekles awalen uffiren deg { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Sefrek awalen uffiren
    .title = Sefrek awalen uffiren deg { -lockwise-brand-short-name }
lockwise-mobile-app-title = Awi awalen uffiren anda teddiḍ
lockwise-no-logins-card-content = Seqdec awalen uffiren yettwaskelsen deg  { -brand-short-name } deg yal ibenk.
lockwise-app-links = { -lockwise-brand-name } i <a data-l10n-name="lockwise-android-inline-link">Android</a> akked <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 awal uffir ahat yettwasken-d deg trewla n yisefka.
       *[other] { $count } awalen uffiren ahat ttwaseknen-d deg trewla n yisefka.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 awal-ik uffir yettwakles s wudem aɣelsan.
       *[other] Awalen-ik uffiren ttwakelsen s wudem aɣelsan.
    }
lockwise-how-it-works-link = Amek itteddu

turn-on-sync = Rmed { -sync-brand-short-name }...
    .title = Ldi ismenyifen n umtawi

monitor-title = Sers allen-ik ɣef trewla n yisefka.
monitor-link = Amek iteddu
monitor-header-content-no-account = Ddu ɣer { -monitor-brand-name } akken ad wali ḍ ma tella trewla n yisefka i k-iḥuzan daɣen akken ad tremseḍ ilɣa ticki llant trewliwi timaynutin.
monitor-header-content-signed-in = { -monitor-brand-name } ad k-id-yelɣu ma yella talɣut-ik tban-d deg trewla n yisefka yettwassnen.
monitor-sign-up-link = jerred ɣer yilɣa n trewla n yisefa
    .title = jerred ɣer yilɣa n trewla n yisefa deg { -monitor-brand-name }
auto-scan = Yettwasenqed ass-a akken iwata

monitor-emails-tooltip =
    .title = Sken tansiwin n yimayl yettuεassen ɣef { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Sken tirewliwin n yisefka yettwassnen ɣef { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Sken awalen uffiren i d-ibanen ɣef { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Tansa n yimayl yettuɛassen
       *[other] Tansiwin n yimayl yettuɛassen
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Tarewla n yisefka yettwassnen tḥuza talɣut-ik
       *[other] Tirewliwin n yisefka yettwassnen ḥuzant talɣut-ik
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Tarewla n yisefka yettwassnen, tettucreḍ tefra.
       *[other] Tirewliwin n yisefka yettwassnen, ttucerḍent frant.
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Awal uffir  i ḥuzant trewliwin n yisefka
       *[other] Awalen uffiren i ḥuzant trewliwin n yisefka
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Awal uffir i d-ibanen di trewliwin ur nefri ara.
       *[other] Awalen uffiren i d-ibanen di trewliwin ur nefri ara.
    }

monitor-no-breaches-title = Isallen igerrzen!
monitor-no-breaches-description = Ur tesεiḍ ara tirewliwin ur nettwassen ara. Ma yella ibeddel waya, ad ak-id-nselɣu.
monitor-view-report-link = Wali aneqqis
    .title = Fru tirewliwin deg { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Fru tirewliwin-inek
monitor-breaches-unresolved-description = Mbeεd asenqed n ttfaṣil n trewliwin yerzan tarewla syen tḍefreḍ imecwaṛen n uḥraz n talɣut-inek, tzemreḍ ad tcerḍeḍ ɣef trewliwin frant.
monitor-manage-breaches-link = Sefrek tirewliwin
    .title = Sefrek tirewliwin deg { -monitor-brand-short-name }
monitor-breaches-resolved-title = Igerrez! Tefriḍ akk tirewliwin yettwassnen.
monitor-breaches-resolved-description = Ma yella imayl-inek iban-d deg kra n trewliwin, ad ak-id-nselɣu.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } seg { $numBreaches } trewla yettucarḍen tefra
       *[other] { $numBreachesResolved } seg { $numBreaches } trewliwin yettucarḍen frant
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% immed

monitor-partial-breaches-motivation-title-start = Beddu igerrzen!
monitor-partial-breaches-motivation-title-middle = Kemmel!
monitor-partial-breaches-motivation-title-end = Qrib ad yemmed! Kemmel.
monitor-partial-breaches-motivation-description = Fru tirewliwin i d-yeqqimen deg { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Fru tirewliwin
    .title = Fru tirewliwin deg { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Ineḍfaṛen n  yiẓeḍwa n tmetti
    .aria-label =
        { $count ->
            [one] { $count } Ineḍfaṛen n  yiẓeḍwa n tmetti ({ $percentage } %)
           *[other] { $count } Ineḍfaṛen n  yiẓeḍwa n tmetti ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Inagan n tuqqna i uḍfaṛ gar yismal
    .aria-label =
        { $count ->
            [one] { $count } Inagan n tuqqna i uḍfaṛ gar yismal ({ $percentage }%)
           *[other] { $count } Inagan n tuqqna i uḍfaṛ gar yismal({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Agbur n uḍfaṛ
    .aria-label =
        { $count ->
            [one] { $count } agbur n uḑfar ({ $percentage }%)
           *[other] { $count } agbur n uḑfar ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Idsilen umḍinen
    .aria-label =
        { $count ->
            [one] { $count } idsilen umḍinen ({ $percentage }%)
           *[other] { $count } idsilen umḍinen ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Ikripṭuminaren
    .aria-label =
        { $count ->
            [one] { $count } n Ikripṭuminar ({ $percentage } %)
           *[other] { $count } n Ikripṭuminaren ({ $percentage } %)
        }
