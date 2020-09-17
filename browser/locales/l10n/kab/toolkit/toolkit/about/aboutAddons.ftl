# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Ldi amsefrak n izegrar
addons-page-title = Ldi amsefrak n izegrar

search-header =
    .placeholder = Nadi addons.mozilla.org
    .searchbuttonlabel = Nadi

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ur ɣur-k ara azegrir yettwasebden n tewsit-agi

list-empty-available-updates =
    .value = ulac ileqman yettwafen

list-empty-recent-updates =
    .value = Acḥal aya ur tesnifleḍ ara izegrar-ik

list-empty-find-updates =
    .label = Senqed ma llan ileqman

list-empty-button =
    .label = Issin ugar ɣef izegrar

help-button = Tallelt izegrar
sidebar-help-button-title =
    .title = Tallelt izegrar

preferences =
    { PLATFORM() ->
        [windows] Iɣewwaren n { -brand-short-name }
       *[other] Ismenyifen n { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Iɣewwaren n { -brand-short-name }
           *[other] Ismenyifen n { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Kra n iseɣzaf ur ţwasenqeden ara

show-all-extensions-button =
    .label = Sken akk iseɣzaf

cmd-show-details =
    .label = Sken ugar n telɣut
    .accesskey = S

cmd-find-updates =
    .label = Nadi ileqman
    .accesskey = N

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Iγewwaṛen
           *[other] Ismenyifen
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }

cmd-enable-theme =
    .label = Snes asentel
    .accesskey = S

cmd-disable-theme =
    .label = Kkes asentel
    .accesskey = K

cmd-install-addon =
    .label = Sebded
    .accesskey = S

cmd-contribute =
    .label = Ţekki
    .accesskey = k
    .tooltiptext = Ţekki di tneflit n uzegrir

detail-version =
    .label = Lqem

detail-last-updated =
    .label = Aleqqem aneggaru

detail-contributions-description = Aneflay n uzegrir-agi isutur-ak-d tallelt akken ad iseddu taneflit-ines ticki tmuddeḍ-as cwiṭ n tewsa.

detail-contributions-button = Ttekki
    .title = Ttekki deg usnerni n uzegrir-agi
    .accesskey = T

detail-update-type =
    .value = Aleqqem awurman

detail-update-default =
    .label = Awennez amezwaru
    .tooltiptext = Sebded ileqman s wudem awurman ma yella d-amezwer kan.

detail-update-automatic =
    .label = Yermed
    .tooltiptext = Sebded ileqman s wudem awurman

detail-update-manual =
    .label = Yensa
    .tooltiptext = Ur sebdad ara ileqman s wudem awurman

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Sker deg usfaylu uslig

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ur yettusireg ara deg isfuyla usligen
detail-private-disallowed-description2 = Asiɣzef-a ur yettwaselkam ara deg tunigt tusrigt. <a data-l10n-name="learn-more">Issin ugar</label>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Yesra anekcum ɣer isfuyla usligen
detail-private-required-description2 = Asiɣzef-a ɣur-s anekcum ɣer urmud-ik srid deg tunigt. <a data-l10n-name="learn-more">Issin ugar</label>

detail-private-browsing-on =
    .label = Sireg
    .tooltiptext = Sermed aya deg iccer uslig

detail-private-browsing-off =
    .label = Ur ttaǧǧa ara
    .tooltiptext = Insa deg timinigin tusligin

detail-home =
    .label = Asebter agejdan

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Amaɣnu n uzegrir

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Senqed ma llan ileqman imaynuten
    .accesskey = S
    .tooltiptext = senqed ileqman n uzegrir-agi

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Iγewwaṛen
           *[other] Ismenyifen
        }
    .accesskey =
        { PLATFORM() ->
            [windows] w
           *[other] I
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Snifel iɣewwaṛen n uzegrir-agi
           *[other] Snifel ismenyaf n uzegrir-agi
        }

detail-rating =
    .value = Adakaḍ

addon-restart-now =
    .label = Ales asenker tura

disabled-unsigned-heading =
    .value = Kra n izegrar yettwassensen

disabled-unsigned-description = Izegrar-agi ur ttwasneqden ara i useqdec n { -brand-short-name }. Tzemreḍ <label data-l10n-name="find-addons">nadi izegrar igdazalen</label> neɣ suter aneflay aten id-isenqed.

disabled-unsigned-learn-more = Issin ugar ɣef ayen n mahel akken ak-d-mudd ugar n tɣellist s srid.

disabled-unsigned-devinfo = ineflayen yebɣan ad sneqden izegrar nsen zemren ad d-awin ugar n telɣut ma ɣṛan <label data-l10n-name="learn-more">s ufus</label>.

plugin-deprecation-description = Tettut kra? Kra nizegrar ur ttwasefranken ara tura di { -brand-short-name }. <label data-l10n-name="learn-more">Issin ugar</label>

legacy-warning-show-legacy = Sken akk iseɣzaf iqburen

legacy-extensions =
    .value = Iseγzaf iqburen

legacy-extensions-description = Iseγzaf-agi ur sεin ara ilugan n { -brand-short-name } imiranen γef aya ittwasensen. <label data-l10n-name="legacy-learn-more">Issin ugar ɣef usnifel ɣer izegrar</label>

private-browsing-description2 =
    { -brand-short-name } ittbeddil tarrayt make iteddu deg tunigt tusrigt. Ula dyiwen n usiɣzef are ternuḍ ɣer 
    { -brand-short-name } ur yettwaselkam swudem amezwer deg usfaylu uslig. Ma yella ur t-termideḍ ara deg yiɣewwaren, 
    asiɣzef ur iteddu ara deg tunigt tusrigt, daɣen ur ikeččem ara ɣer urmud-ik
    srid. Nexdem abeddel-a akken akken tunigt-ik tusligt ad teqqim d tabadnit.
    <label data-l10n-name="private-browsing-learn-more">Issin amek ara tesferkeḍ iɣewwaren n usiɣzef</label>

addon-category-discover = Iwellihen
addon-category-discover-title =
    .title = Iwellihen
addon-category-extension = Isiɣzaf
addon-category-extension-title =
    .title = Isiɣzaf
addon-category-theme = Isental
addon-category-theme-title =
    .title = Isental
addon-category-plugin = Izegrar
addon-category-plugin-title =
    .title = Izegrar
addon-category-dictionary = Imawalen
addon-category-dictionary-title =
    .title = Imawalen
addon-category-locale = Tutlayin
addon-category-locale-title =
    .title = Tutlayin
addon-category-available-updates = Ileqman yellan
addon-category-available-updates-title =
    .title = Ileqman yellan
addon-category-recent-updates = Ileqman n melmi kan
addon-category-recent-updates-title =
    .title = Ileqman n melmi kan

## These are global warnings

extensions-warning-safe-mode = Armad n izegrar yekkes-it uskar aɣalsan.
extensions-warning-check-compatibility = Asenqed n umṣada n izegrar ur yermid ara. Yezmer ad tesɛuḍ izegrar ur yemṣadan ara.
extensions-warning-check-compatibility-button = Rmed
    .title = Rmed asenqed n tisiḍent
extensions-warning-update-security = Asenqed n ileqman n tɣellist n izegrar ur yermid ara. Yezmer ad tesɛuḍ yir izegrar.
extensions-warning-update-security-button = Rmed
    .title = Rmed asenqed n ileqman n tɣellist i yezgrar isemmadanen


## Strings connected to add-on updates

addon-updates-check-for-updates = Nadi ileqman
    .accesskey = N
addon-updates-view-updates = Sken ileqman n melmi kan
    .accesskey = S

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Leqqem s wudem awurman izegrar
    .accesskey = L

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Rmed aleqqem awurman i yizegrar meṛṛa
    .accesskey = R
addon-updates-reset-updates-to-manual = Tukksa n urmad n uleqqem awurman n izegrar meṛṛa
    .accesskey = T

## Status messages displayed when updating add-ons

addon-updates-updating = Aleqqem n izegrar
addon-updates-installed = Izegrar-inek ttwaleqqmen.
addon-updates-none-found = ulac ileqman yettwafen
addon-updates-manual-updates-found = Sken ileqman yellan

## Add-on install/debug strings for page options menu

addon-install-from-file = Sebded azegrir seg ufaylu…
    .accesskey = S
addon-install-from-file-dialog-title = Fren azegrir ad tesbeddeḍ
addon-install-from-file-filter-name = Izegrar
addon-open-about-debugging = Izegrar n tseɣtit
    .accesskey = I

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Sefrek inegzumen n isiɣzaf
    .accesskey = i

shortcuts-no-addons = Ur ɣur-k ara ula d yiwen n usiɣzef iremden.
shortcuts-no-commands = Isiɣzaf id-iteddun ur sɛin ara inegzumen:
shortcuts-input =
    .placeholder = Sekcem anegzum

shortcuts-browserAction2 = Rmed taqeffalt n ufeggag n yifecka
shortcuts-pageAction = Rmed tigawt n usebter
shortcuts-sidebarAction = Sken/Fer agalis adisan

shortcuts-modifier-mac = Seddu Ctrl, Alt, neɣ ⌘
shortcuts-modifier-other = Seddu Ctrl neɣ Alt
shortcuts-invalid = Yir tuddsa
shortcuts-letter = Sekcem asekkil
shortcuts-system = Ur yezmir ad isnifel anegzum n { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Sleg anegzum

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } yettwaseqdec am unegzum deg ddeqs n yimukan. Inegzumen imsinen zemren ad d-glun s tiddin ur nelhi ara.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Iseqdac-it yakan { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Sken { $numberToShow } nniḍen
       *[other] Sken { $numberToShow } nniḍen
    }

shortcuts-card-collapse-button = Sken qel

header-back-button =
    .title = Uɣal ɣer deffir

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Isiɣzaf akked isental am yisnasen i  yiminig-ik ara k-yeǧǧen ad temmestneḍ awalen-ik uffiren, ad tessadreḍ tividyutin, ad d-tafeḍ tignatin yelhan, ad tesweḥleḍ adellel udhim, ad tbeddleḍ udem n yiminig,atg. Iseɣzanen-a imeẓyanen deg tuget xeddmen-ten ineflayen ilelliyen. A-tt-a kra n tefrant anida { -brand-product-name }<a data-l10n-name="learn-more-trigger">yettwellih</a> i tɣellist, tamellit akked tmahilin meqqren.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Kra seg yiwellihen-a d udmawanen. Tagrumma-a tebna ɣef yisiɣzaf-nniḍen
    i tesbeddeḍ, iɣewwaren n umaɣnu-ik akked tiddadanin n useqdec.
discopane-notice-learn-more = Lmed ugar

privacy-policy = Tasertit n tbaḍnit

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = sɣur<a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Iseqdacen: { $dailyUsers }
install-extension-button = Rnu ɣer { -brand-product-name }
install-theme-button = Sebded asentel
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Sefrek
find-more-addons = Aff-d ugar n izegrar

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Ugar n iɣewwaṛen

## Add-on actions

report-addon-button = Aneqqis
remove-addon-button = Kkes
# The link will always be shown after the other text.
remove-addon-disabled-button = UR izmir ara ad yettwakkes <a data-l10n-name="link">Acuɣer?</a>
disable-addon-button = Ssens
enable-addon-button = Rmed
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Rmed
preferences-addon-button =
    { PLATFORM() ->
        [windows] iɣewwaṛen
       *[other] Ismenyifen
    }
details-addon-button = Talqayt
release-notes-addon-button = Iwenniten n lqem
permissions-addon-button = Tisirag

extension-enabled-heading = Irmed
extension-disabled-heading = Yensa

theme-enabled-heading = Irmed
theme-disabled-heading = Yensa

plugin-enabled-heading = Irmed
plugin-disabled-heading = Yensa

dictionary-enabled-heading = Irmed
dictionary-disabled-heading = Arurmid

locale-enabled-heading = Irmed
locale-disabled-heading = Arurmid

ask-to-activate-button = Suter armed
always-activate-button = Rmed yal tikelt
never-activate-button = weṛǧin ad yermed

addon-detail-author-label = Ameskar
addon-detail-version-label = Lqem
addon-detail-last-updated-label = Aleqqem aneggaru
addon-detail-homepage-label = Asebter agejdan
addon-detail-rating-label = Tizmilin

# Message for add-ons with a staged pending update.
install-postponed-message = Asiɣzef-a ad yettwaleqqem mi ara iɛawed { -brand-short-name } asenker.
install-postponed-button = Leqqem tura

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Yettwasezmel { NUMBER($rating, maximumFractionDigits: 1) } ɣef 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } ( d arurmid)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } iceggiren
       *[other] { $numberOfReviews } iceggiren
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> yettwakkes.
pending-uninstall-undo-button = Sefsex

addon-detail-updates-label = Sireg aleqqem awurman
addon-detail-updates-radio-default = Amezwer
addon-detail-updates-radio-on = Yermed
addon-detail-updates-radio-off = Yensa
addon-detail-update-check-label = Senqed ma llan ileqman
install-update-button = Leqqem

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Yettusireg def usfaylu uslig kan
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Ma yettwasireg, asiɣzef ad yekcem ɣer urmud-ik srid deg tunigt tusrigt.<a data-l10n-name="learn-more">Issin ugar</label>
addon-detail-private-browsing-allow = Sireg
addon-detail-private-browsing-disallow = Ur ttaǧǧa ara

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } ur ittwelleh ala isiɣzaf yemṣadan d yilugan-nneɣ icudden ɣer tɣellist akked timellit.
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Ileqman yellan
recent-updates-heading = Ileqman n melmi kan

release-notes-loading = Asali…
release-notes-error = Suref-aɣ, teḍṛa-d tuccḍa deg usali n iwenniten n lqem.

addon-permissions-empty = Asiɣzef-agi ur yesra ara tisirag

recommended-extensions-heading = Isiɣzaf ihulen
recommended-themes-heading = Isental ihulen

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Tḥulfaḍ iman-ik tesnulfuyeḍ? <a data-l10n-name="link">Rnu asentel-ik s Firefox Color.</a>

## Page headings

extension-heading = Sefrek isiɣzaf-ik/im
theme-heading = Sefrek isental-ik/im
plugin-heading = Sefrek izegrar-ik/im
dictionary-heading = Sefrek imawalen-ik/im
locale-heading = Sefrekl tutlayin-ik/im
updates-heading = Sefrek ileqman-ik
discover-heading = Err { -brand-short-name }-ik d udmawan
shortcuts-heading = Sefrek inegzumen n isiɣzaf

default-heading-search-label = Aff-d ugar n yizegrar
addons-heading-search-input =
    .placeholder = Nadi addons.mozilla.org

addon-page-options-button =
    .title = Ifecka i yizegrar imaṛṛa
