# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Asiɣzef yelhan
cfr-doorhanger-feature-heading = Timahilin ihulen
cfr-doorhanger-pintab-heading = Ɛreḍ aya: senṭeḍ iccer

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Acuɣer i d-yettban waya

cfr-doorhanger-extension-cancel-button = Mačči tura
    .accesskey = T

cfr-doorhanger-extension-ok-button = Rnu Tura
    .accesskey = N
cfr-doorhanger-pintab-ok-button = Senṭeḍ iccer-agi
    .accesskey = S

cfr-doorhanger-extension-manage-settings-button = Sefrek Iɣewwaṛen n wahul
    .accesskey = S

cfr-doorhanger-extension-never-show-recommendation = Ur yid-skan ara Ahul Agi
    .accesskey = U

cfr-doorhanger-extension-learn-more-link = Issin ugar

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = S { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Awelleh
cfr-doorhanger-extension-notification2 = Iwellihen
    .tooltiptext = Iseɣzaf ihulen
    .a11y-announcement = Iseɣzaf ihulen i yellan

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Iwellihen
    .tooltiptext = Timahaltin ihulen
    .a11y-announcement = Timahaltin ihulen i yellan

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } itri
           *[other] { $total } itran
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } aseqdac
       *[other] { $total } iseqdacen
    }

cfr-doorhanger-pintab-description = Awi anekcum fessusen ɣer yismal-ik i tesseqdaceḍ aṭas. Eǧǧ ismal ldin deg yiccer (xas ma tulseḍ tanekra).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Si s tqeffalt tayeffust</ b> ɣef yiccer i tebɣiḍ ad ɛelqeḍ.
cfr-doorhanger-pintab-step2 = Fren<b>Siggez iccer</b> seg umuɣ.
cfr-doorhanger-pintab-step3 = Ma yella asmel yettwalqem ad twaliḍ aggaz anili yettban-d deg iccer-ik iɛelqen.

cfr-doorhanger-pintab-animation-pause = Asteɛfu
cfr-doorhanger-pintab-animation-resume = Kemmel


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Mtawi ticraḍ n yisebter ar wanida tebɣiḍ.
cfr-doorhanger-bookmark-fxa-body = Tufiḍ tiwizet! Tura, af-d tacreḍt n usebter ɣef yibenkan-ik izirazen, d lawan ad tesqedceḍ { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Mtawi ticraḍ n yisebtar tura...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Taqeffalt n umdal
    .title = Amdal

## Protections panel

cfr-protections-panel-header = Inig war ma ḍefṛen-k
cfr-protections-panel-body = Ḥrez isefka-ik i kečč. { -brand-short-name } ad k-yemmesten seg tuget n yineḍfaṛen yettwassnen i yeṭṭafaṛen ayen i txeddmeḍ srid.
cfr-protections-panel-link-text = Issin ugar

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Timahilin timaynutin:

cfr-whatsnew-button =
    .label = Amaynut
    .tooltiptext = Amaynut

cfr-whatsnew-panel-header = Amaynut

cfr-whatsnew-release-notes-link-text = Ɣer tizmilin n lqem.

cfr-whatsnew-fx70-title = { -brand-short-name } yettnaḍaḥ tura ugar ɣef tudert-ik tabaḍnit
cfr-whatsnew-fx70-body = Lqem aneggaru yesnerna tamahilt n ummesten mgal aḍfaṛ daɣen urǧin yella yessifses am akka, timerna n wawalen uffiren iɣelsanen i yal asmel.

cfr-whatsnew-tracking-protect-title = Mmesten iman-ik seg yineḍfaren.
cfr-whatsnew-tracking-protect-body = { -brand-short-name } yessewḥal ddeqs n yineḍfaren inmettiyen akked igrismal yettwassnen i yeṭṭafaṛen ayen i txeddmeḍ srid.
cfr-whatsnew-tracking-protect-link-text = Wali aneqqis-ik

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Ineḍfaṛar ittwaḥbes
       *[other] Ineḍfaṛen ttwaḥebsen
    }
cfr-whatsnew-tracking-blocked-subtitle = Si { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Wali aneqqis

cfr-whatsnew-lockwise-backup-title = Sekles awalen-ik uffiren
cfr-whatsnew-lockwise-backup-body = Tura, sirew-d awalen-ik uffiren iɣelsanen aniɣer i tzemreḍ ad tkecmeḍ sekra wanida teqqneḍ.
cfr-whatsnew-lockwise-backup-link-text = Rmed asekles

cfr-whatsnew-lockwise-take-title = Awi yid-k awalen-ik uffiren
cfr-whatsnew-lockwise-take-body = Asna aziraz { -lockwise-brand-short-name } ad k-yeǧǧ ad tkecmeḍ s wudem aɣelsan ɣer wawalen-ik uffiren yettwaskelsen seg yal amkan.
cfr-whatsnew-lockwise-take-link-text = Awi asnas

## Search Bar

cfr-whatsnew-searchbar-title = Aru cwiṭ, aff aṭas s ufeggag n tansiwin
cfr-whatsnew-searchbar-body-topsites = Tura, fren afeggag n tunigin, ad d-timɣur texxamt s iseɣwan ɣer ismal-ik ifazen.
cfr-whatsnew-searchbar-icon-alt-text = Tignit n lemri isimɣuren

## Picture-in-Picture

cfr-whatsnew-pip-header = Wali tividyutin kečč tettinigeḍ
cfr-whatsnew-pip-body = Askar n usleɣ yeggar tavidyut deg usfaylu ufig akken ad tizmireḍ ad tt-twaliḍ ticki txeddmeḍ deg yiccaren-nniḍen.
cfr-whatsnew-pip-cta = Issin ugar

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Drus n yisfuyal udhimen n yismal yettɛekkiṛen
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } yessewḥal akka tura ismal akken ad ak-d-sutren s wudem awurman tuzna n yiznan deg  yisfuyla udhimen.
cfr-whatsnew-permission-prompt-cta = Issin ugar

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Amaṭṭaf n yidsilen umḍinen iwḥel
       *[other] Imaṭṭaffen n yidsilen umḍinen weḥlen
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } yessewḥal ddeqs n yidsilen umḍinen i d-ileqḍen talɣut-ik s tuffra ɣef yibenk-ik akked tigawin akken ad ixeddem adellel s useqdec n umaɣnu-ik.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Idsilen umḍinen
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } izmer ad iseḥbes idsilen umḍinen i d-ileqḍen talɣut-ik s tuffra ɣef yibenk-ik akked tigawin akken ad ixeddem adellel s useqdec n umaɣnu-ik.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Kcem ɣer tecreḍt-a n usebter ṣef tiliɣri-ik
cfr-doorhanger-sync-bookmarks-body = Awi yid-k ticraḍ-ik n yisebtar, awalen-ik uffiren, azray, d wayen-nniḍen, sekra wanida i teqqneḍ ɣer umiḍan-ik { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Rmed { -sync-brand-short-name }
    .accesskey = R

## Login Sync

cfr-doorhanger-sync-logins-header = Ur sṛuḥuy ara awalen-ik uffiren
cfr-doorhanger-sync-logins-body = Sekles rnu mtawi awalen-ik·im uffiren ɣef yibenkan-ik·im i meṛṛa s wudem aɣelsan.
cfr-doorhanger-sync-logins-ok-button = Rmed { -sync-brand-short-name }
    .accesskey = R

## Send Tab

cfr-doorhanger-send-tab-header = Ɣer aya ticki teleḥḥuḍ
cfr-doorhanger-send-tab-recipe-header = Ɣer amek yettwa wučči-a
cfr-doorhanger-send-tab-body = "Azen Iccer" ad k-yeǧǧ ad siwḍeḍ s wudem afessas aseɣwen-a ɣer tiliɣri-ik neɣ yal ibenk-nniḍen yeqqnen ɣer umiḍan-ik { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Ɛreḍ tuzna n yiccer
    .accesskey = Ɛ

## Firefox Send

cfr-doorhanger-firefox-send-header = Bḍu afaylu-a PDF s wudem aɣelsan
cfr-doorhanger-firefox-send-body = Mmesten arratent-ik ibadniyen seg yir tamuɣli s uwgelhen si ṭṭerf ɣer ṭṭerf akken useɣwen ara yemmten ticki tfukkeḍ.
cfr-doorhanger-firefox-send-ok-button = Reḍ { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Wali tarrayin n ummesten
    .accesskey = W
cfr-doorhanger-socialtracking-close-button = Mdel
    .accesskey = M
cfr-doorhanger-socialtracking-dont-show-again = Ur d-skanay ara iznan am wi tikkelt-nniḍen
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } yessewḥel aẓeṭṭa inmetti akken ad k-yeḍfeṛ dagi
cfr-doorhanger-socialtracking-description = Aqadeṛ n tudert-ik tabaḍnit yeɛna-aɣ. { -brand-short-name } yesseḥal akka tura ineḍfaṛen n yiẓeḍwa inmettiyen yettwassnen, ayen yettarran talast i tnecta n yisefka i zemren ad d-leqḍen armud-ik srid.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } yessewḥel aneḍfaṛ n udsil umḍin ɣef usebter-a.
cfr-doorhanger-fingerprinters-description = Aqader n tbaḍnit-ik teɛna-aɣ. { -brand-short-name } yessewḥal akka tura ineḍfaren n udsilen umḍinen, i d-ileqḍen talɣut tasuft yettwassnen ɣef yibenk-ik akken ad k-yeḍfer.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } yessewḥel akriptuminer ɣef usebter-a.
cfr-doorhanger-cryptominers-description = Aqadeṛ n tudert-ik tusligt d ayen meqqren. { -brand-short-name } yessewḥal akka tura ikriptumniren i yesseqdacen tazmert n usiḍen n unagraw-ik n wammud akken ad d-kksen tadrimt tumḍint.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } iwḥel i { $blockedCount }</b> uneḍfar seg
       *[other] { $date }!
    }
cfr-doorhanger-milestone-ok-button = Wali akk
    .accesskey = W

cfr-doorhanger-milestone-close-button = Mdel
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Rnu awal uffir aɣelsan s wudem fessusen
cfr-whatsnew-lockwise-body = Ur  fessus ara yal tikket ad txemmemeḍ ɣer wawalen uffiren isufen, iɣelsanen i yal amiḍan. Deg tmerna n wawal uffir, fren urti n wawal uffir akken ad tesqedceḍ awal uffir aɣelsan, ara d-yessirew { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Tignit { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Awi ilɣa ɣef wawalen uffiren fessusen i truẓi
cfr-whatsnew-passwords-body = Imakaren imsenselkamen zran dakken imdanen ttɛawaden aseqdec n kra kan n wawalen uffiren.  Ma yella tsqedceḍ yiwen wawal uffir deg watas n yesmal web, u yella yiwen ger yesmal-agi tella-d degs trewla n yisefka, ad twaliḍ alɣu deg { -lockwise-brand-short-name } akken ad tesnifleḍ awal-ik uffir deg yesmal-nni.
cfr-whatsnew-passwords-icon-alt = Tignit n tsarut n wawal uffir fessusen i truẓi

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Awi agdil aččuran n tugna-deg-tugna
cfr-whatsnew-pip-fullscreen-body = Ticki ara terreḍ tavidyut deg usfaylu ufig, Tzemreḍ tura ad tsiteḍ snat n tikkal ɣef usfaylu-nni akken ad tɛeddiḍ ɣer ugdil aččuran.
cfr-whatsnew-pip-fullscreen-icon-alt = Tignit n tugna-deg-tugna

## Protections Dashboard message

cfr-whatsnew-protections-header = Ammesten deg teṛmect n tiṭ
cfr-whatsnew-protections-body = Tafelwit n usenqed n ummesten tegber-d agzul n y ineqqisen ɣef trewliwin n yisefka d usefrek n wawalen uffiren. Tzemreḍ tura ad ḍefreḍ acḥal n trewliwin i tseɣtaḍ, rnu a twaliḍ ma yella yiwen seg wawalen-inek/inem uffiren yettwaskelsen iban-d deg trewliwin n yisefka.
cfr-whatsnew-protections-cta-link = Wali tafelwit n usenqed
cfr-whatsnew-protections-icon-alt = Tignit Shield

## Better PDF message

cfr-whatsnew-better-pdf-header = Tirmit ifazen n PDF
cfr-whatsnew-better-pdf-body = Imesliyen PDF ttaldayen-d tura srid deg { -brand-short-name }, eǧǧ tiddin n leqdic-ik ɣef wafus.

## DOH Message

cfr-doorhanger-doh-body = Aqader n tudert-ik tabaḍnit yeεna-aɣ. { -brand-short-name } yettawi akka tura s wudem aɣelsan isutar-ik.im DNS a melmi i as-tettunefk tegnit ɣer uqeddac amendid akken ad tettummestneḍ mi ara tettinigeḍ.
cfr-doorhanger-doh-header = Inadiyen DNS s wugar n tɣellist d uwgelhen
cfr-doorhanger-doh-primary-button = IH awi-t-id
    .accesskey = o
cfr-doorhanger-doh-secondary-button = Sens
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Ammesten awurman mgal tiḥila n uḍfar yettkellixen
cfr-whatsnew-clear-cookies-body = Kra n yineḍfaren ttwehhin-k/m ɣer kra n yismal web ideg llan inagan n tuqqna d uffiren. Tura, { -brand-short-name } iseffeḍ s wudem awurman inagan-agi n tuqqna akken ur ssawaḍen ara ad k-ḍefren.
cfr-whatsnew-clear-cookies-image-alt = Unuɣen n yinagan n tuqqna ttusweḥlen
