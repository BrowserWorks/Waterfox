# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Kinuk'samajel taq tz'aqat
addons-page-title = Kinuk'samajel taq tz'aqat
search-header =
    .placeholder = Tikanöx addons.mozilla.org
    .searchbuttonlabel = Tikanöx
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Man ayakon ta re ruwäch tz'aqat re'
list-empty-available-updates =
    .value = Majun taq k'exoj ruwäch xe'ilitäj
list-empty-recent-updates =
    .value = Majun k'ak'a' k'exoj ab'anon chi ke ri taq tz'aqat
list-empty-find-updates =
    .label = Kenik'öx Taq K'exoj
list-empty-button =
    .label = Tetamäx ch'aqa' chik chi kij ri taq tz'aqat
help-button = Kitob'al Tz'aqat
sidebar-help-button-title =
    .title = Kitob'al Tz'aqat
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Taq Cha'oj
       *[other] { -brand-short-name } Taq Ajowab'äl
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Taq Cha'oj
           *[other] { -brand-short-name } Taq Ajowab'äl
        }
show-unsigned-extensions-button =
    .label = Jujun taq k'amal man tikirel ta yenik'öx
show-all-extensions-button =
    .label = Kek'ut pe konojel ri taq ruk'amal
cmd-show-details =
    .label = Kek'ut pe ch'aqa' chik rutzijol
    .accesskey = K
cmd-find-updates =
    .label = Kekanöx taq k'exoj
    .accesskey = K
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Taq cha'oj
           *[other] Taq ajowab'äl
        }
    .accesskey =
        { PLATFORM() ->
            [windows] c
           *[other] a
        }
cmd-enable-theme =
    .label = Tokisäx wachinel
    .accesskey = T
cmd-disable-theme =
    .label = Tiq'at rokisaxik wachinel
    .accesskey = r
cmd-install-addon =
    .label = Tiyak
    .accesskey = T
cmd-contribute =
    .label = Kato'on
    .accesskey = K
    .tooltiptext = Kato'on chi nisamajïx re tz'aqat re'
detail-version =
    .label = Ruwäch
detail-last-updated =
    .label = Ruk'isib'äl K'exoj
detail-contributions-description = Ri runuk'unel re tz'aqat re', nuk'utuj chawe chi tato' rik'in rub'anik, rik'in naya' jun ko'öl ato'ik.
detail-contributions-button = Kato'on
    .title = Kato'on richin nib'an re chokoy re'
    .accesskey = K
detail-update-type =
    .value = K'exoj pa kiyonil
detail-update-default =
    .label = Jikib'an wi
    .tooltiptext = Pa kiyonil keyak ri taq k'exoj, xa xe we kan e k'o wi
detail-update-automatic =
    .label = Titzij
    .tooltiptext = Kiyonïl keyak ri taq k'exoj
detail-update-manual =
    .label = Chupül
    .tooltiptext = Man keyak pa kiyonil ri taq k'exoj
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Kesamajïx pa Ichinan Tzuwäch
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Man ya'on ta q'ij pan Ichinan Tzuwäch
detail-private-disallowed-description2 = Man nisamäj ta pa ichinan okem pa k'amaya'l re k'amal re'. <a data-l10n-name="learn-more">Tetamäx ch'aqa' chik</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Nrajo' Okem pa Ichinan Tzuwäch
detail-private-required-description2 = Re k'amal re' tikirel nok pa samaj pa k'amab'ey toq k'o pa ichinan okem pa k'amaya'l. <a data-l10n-name="learn-more">Tetamäx ch'aqa' chik</a>
detail-private-browsing-on =
    .label = Tiya' q'ij
    .tooltiptext = Titz'ij pa Ichinan Okem pa K'amaya'l
detail-private-browsing-off =
    .label = Man Tiya' Q'ij
    .tooltiptext = Tichup pa Ichinan Okem pa K'amaya'l
detail-home =
    .label = Tikirib'äl ruxaq
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Ruwäch rub'i' tz'aqat
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Kenik'öx taq K'exoj
    .accesskey = o
    .tooltiptext = Kenik'öx kik'exoj re taq tz'aqat re'
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Taq cha'oj
           *[other] Taq ajowab'äl
        }
    .accesskey =
        { PLATFORM() ->
            [windows] c
           *[other] a
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Kejal ri taq rucha'oj re tz'aqat re'
           *[other] Kejal ri taq rajowaxik re tz'aqat re'
        }
detail-rating =
    .value = Kejqalem
addon-restart-now =
    .label = Titikirisäx chik wakami
disabled-unsigned-heading =
    .value = Jujun taq tz'aqat xechup
disabled-unsigned-description = Re taq tz'aqat re' man xenik'öx ta richin ye'okisáx pa { -brand-short-name }. Tatikïr <label data-l10n-name="find-addons">Ke'ilitäj taq jalwachinïk</label> tik'utüx chi re ri nuk'unel chi kerunik'oj.
disabled-unsigned-learn-more = Tetamäx ch'aqa' chik pa ruwi' ri qarayib'al richin yatqato' chi k'o achajinik pa k'amab'ey.
disabled-unsigned-devinfo = Nuk'unela' nikajo' yekinik'oj ri taq kitz'aqat, tikirel tikisik'ij ri qichin <label data-l10n-name="learn-more">etamawuj</label>.
plugin-deprecation-description = ¿La k'o nanataj? Jujun taq nak'ab'äl man nikixïm ta chik ki' ruma { -brand-short-name }. <label data-l10n-name="learn-more">Tetamäx ch'aqa' chik.</label>
legacy-warning-show-legacy = Kek'ut pe ri kochin taq k'amal
legacy-extensions =
    .value = Kochin taq K'amal
legacy-extensions-description = Re taq k'amal re' man nikik'äm ta ki' rik'in current { -brand-short-name } taq rub'eyal richin chi xechuputäj. <label data-l10n-name="legacy-learn-more">Tetamäx chi kij ri kijaloj taq tzaqät</label>
private-browsing-description2 =
    { -brand-short-name } yerujäl achike rub'eyal yesamäj ri taq k'amal pa ri ichinan okem pa k'amaya'l. Xab'achike k'ak'a' k'amall xtatz'aqatisaj pa
    { -brand-short-name } man xtisamäj ta el achi'el k'o pa Ichinan Tzuwäch. Xa xe we naya' q'ij chi re pa runuk'ulem, ri 
    k'amal man xtisamäj ta pa ichinan okem pa k'amaya'l, chuqa' man xkatikïr ta xkatok pa ri asamaj richin k'amab'ey
    chi ri'. Xqab'än re jaloj re' richin nichinäx ri ichinan awokem pa k'amaya'l
    <label data-l10n-name="private-browsing-learn-more">Tawetamaj achike rub'eyal ninuk'samajïx ri runuk'ulem k'amal.</label>
addon-category-discover = Taq chilab'enïk
addon-category-discover-title =
    .title = Taq chilab'enïk
addon-category-extension = Taq k'amal
addon-category-extension-title =
    .title = Taq k'amal
addon-category-theme = Taq wachinel
addon-category-theme-title =
    .title = Taq wachinel
addon-category-plugin = Taq nak'ab'äl
addon-category-plugin-title =
    .title = Taq nak'ab'äl
addon-category-dictionary = Taq soltzij
addon-category-dictionary-title =
    .title = Taq soltzij
addon-category-locale = Taq ch'ab'äl
addon-category-locale-title =
    .title = Taq ch'ab'äl
addon-category-available-updates = Taq K'exoj K'o
addon-category-available-updates-title =
    .title = Taq K'exoj K'o
addon-category-recent-updates = K'ak'a' taq K'exoj
addon-category-recent-updates-title =
    .title = K'ak'a' taq K'exoj

## These are global warnings

extensions-warning-safe-mode = Konojel ri taq tz'aqat xechup pa ri ütz rub'eyal.
extensions-warning-check-compatibility = Chupül ri runuk'oxik richin we nikik'äm ki' ri taq tz'aqat. Rik'in jub'a' k'o jujun taq tz'aqat, ri man nikik'äm ta ki'.
extensions-warning-check-compatibility-button = Titzij
    .title = Titzij ri runik'oxik richin chi nikik'äm ki' ri taq tz'aqat.
extensions-warning-update-security = Chupül ri runik'oxik chajinïk richin kik'exoj taq tz'aqat. Rik'in jub'a' k'o pa k'ayewal ri awokik'amaya'l kuma ri taq k'exoj.
extensions-warning-update-security-button = Titzij
    .title = Titzij ri ya'öl retal chajinïk richin nik'ex ri tz'aqat

## Strings connected to add-on updates

addon-updates-check-for-updates = Kenik'öx taq K'exoj
    .accesskey = K
addon-updates-view-updates = Ketz'et k'ak'a' taq k'exoj
    .accesskey = K

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = kek'ex taq tz'aqat pa kiyonil
    .accesskey = k

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Titzolïx chi kij konojel ri taq tz'aqat richin kek'ex pa kiyonil
    .accesskey = T
addon-updates-reset-updates-to-manual = Titzolïx chi kij konojel ri taq tz'aqat richin kek'ex pa chi q'ab'aj.
    .accesskey = T

## Status messages displayed when updating add-ons

addon-updates-updating = Tajin yek'ex ri taq tz'aqat
addon-updates-installed = Xek'extäj re taq atz'aqat re'.
addon-updates-none-found = Majun taq k'exoj ruwäch xe'ilitäj
addon-updates-manual-updates-found = Ketz'et ri taq k'exoj e k'o

## Add-on install/debug strings for page options menu

addon-install-from-file = Tiyak ri tz'aqat rik'in ri yakb'äl…
    .accesskey = T
addon-install-from-file-dialog-title = Ticha' re tz'aqat re' richin niyak qa
addon-install-from-file-filter-name = Taq tz'aqat
addon-open-about-debugging = Kechojmirisäx taq Tz'aqat
    .accesskey = c

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Kenuk'samajïx Kichojokem taq K'amal
    .accesskey = i
shortcuts-no-addons = Majun ak'amal atzijon.
shortcuts-no-commands = Re taq k'amal re' majun ruq'a' rokem pitz'b'äl:
shortcuts-input =
    .placeholder = Tatz'ib'aj jun chojokem
shortcuts-browserAction2 = Titzij rupitz'b'al rukajtz'ik samajib'äl
shortcuts-pageAction = Titzij rub'anoj ruxaq
shortcuts-sidebarAction = Tik'exlöx ri ajxikin kajtz'ik
shortcuts-modifier-mac = Titz'aqatisäx Ctrl, Alt o ⌘
shortcuts-modifier-other = Titz'aqatisäx Ctrl o Alt
shortcuts-invalid = Man okel ta ri tunuj
shortcuts-letter = Tatz'ib'aj jun tz'ib'
shortcuts-system = Man yatikïr ta nayüj jun { -brand-short-name } chojokem
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Kamulun chojokem
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } man xa xe ta pa jun chojokem nokisäx. Ri kamulun chojokem yetikïr nikib'än jun man oyob'en ta chi b'anikil.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Okisan chik ruma { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Tik'ut { $numberToShow } Ch'aqa' Chik
       *[other] Kek'ut { $numberToShow } Ch'aqa' Chik
    }
shortcuts-card-collapse-button = Tik'ut pe Jub'a'
header-back-button =
    .title = Titzolin

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Ri taq k'amal chuqa' ri taq wachinel e ruchokoy okik'amaya'l chuqa' nikiya' q'ij chi re
    ye'achajij ri ewan taq  tzij, ye'aqasaj taq silowäch, ye'akanoj taq sujuj, ye'aq'ät taq eltzijol,
    najäl ruwäch ri okik'amaya'l chuqa' ch'aqa' chik. Jutaqil e aj röx winäq ri yeb'anon re ko'öl taq runuk'samaj cholkema'. Niqasüj jun rucha'oj { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">echilab'en</a> pa metz'etel
    jikomal, rub'eyal nisamäj chuqa' rusamaj.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Jujun chi ke re taq chilab'enïk re' e'ichinan. K'o kixe'el pa jujun chik taq k'amal e'ayakon, kajowab'al rub'i' awäch chuqa' rumolob'a' rokisaxik.
discopane-notice-learn-more = Tetamäx ch'aqa' chik
privacy-policy = Ichinan Na'oj
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = ruma <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Okisanela': { $dailyUsers }
install-extension-button = Titz'aqatisäx pa { -brand-product-name }
install-theme-button = Tiyak Wachinel
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Tinuk'samajïx
find-more-addons = Kekanöx ch'aqa' chik taq tz'aqat
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Ch'aqa' chik taq Cha'oj

## Add-on actions

report-addon-button = Tiya' rutzijol
remove-addon-button = Tiyuj
# The link will always be shown after the other text.
remove-addon-disabled-button = Man Tikirel ta Niyuj el <a data-l10n-name="link">¿Aruma?</a>
disable-addon-button = Tichup
enable-addon-button = Titzij
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Titzij
preferences-addon-button =
    { PLATFORM() ->
        [windows] Taq cha'oj
       *[other] Taq ajowab'äl
    }
details-addon-button = Taq b'anikil
release-notes-addon-button = Ruch'utitzijol Ruwäch
permissions-addon-button = Taq ya'oj q'ij
extension-enabled-heading = Tzijon
extension-disabled-heading = Chupun
theme-enabled-heading = Tzijon
theme-disabled-heading = Chupun
plugin-enabled-heading = Tzijon
plugin-disabled-heading = Chupun
dictionary-enabled-heading = Tzijon
dictionary-disabled-heading = Chupun
locale-enabled-heading = Tzijon
locale-disabled-heading = Chupun
ask-to-activate-button = Tik'utüx chi Nitzij
always-activate-button = Junelïk Tzijïl
never-activate-button = Majub'ey Titzij
addon-detail-author-label = B'anel
addon-detail-version-label = Ruwäch
addon-detail-last-updated-label = Ruk'isib'äl K'exoj
addon-detail-homepage-label = Tikirib'äl ruxaq
addon-detail-rating-label = Kejqalem
# Message for add-ons with a staged pending update.
install-postponed-message = Re k'amal re' xtik'extäj toq xtitikïr chik { -brand-short-name }.
install-postponed-button = Tik'exWakami
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Retal ruq'ij { NUMBER($rating, maximumFractionDigits: 1) } richin 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (chupun)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } nik'oj
       *[other] { $numberOfReviews } taq nik'oj
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Xyuj el <span data-l10n-name="addon-name">{ $addon }</span>.
pending-uninstall-undo-button = Titzolïx
addon-detail-updates-label = Tiya' q'ij chi ke ri Kiyonil k'exoj
addon-detail-updates-radio-default = K'o wi
addon-detail-updates-radio-on = Titzij
addon-detail-updates-radio-off = Chupül
addon-detail-update-check-label = Kenik'öx taq K'exoj
install-update-button = Tik'ex
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Tiya' q'ij pa taq ichinan tzuwäch
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Toq tzij, ri k'amal pa ronojel samaj xtok wi toq atokinäq pa k'amaya'l pan ichinan rub'anikil. <a data-l10n-name="learn-more">Tetamäx ch'aqa' chik</a>
addon-detail-private-browsing-allow = Tiya' q'ij
addon-detail-private-browsing-disallow = Man Tiya' Q'ij
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } xa xe yeruchilab'ej taq k'amal kojqan rub'eyal qajikomal chuqa' rub'eyal qasamaj
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Taq K'exoj K'o
recent-updates-heading = K'ak'a' taq K'exoj
release-notes-loading = Nisamäj…
release-notes-error = Takuyu' qamak, xa xk'ulwachitäj jun sachoj toq nok pa ch'utaq rutzijol ri ko'öl wuj.
addon-permissions-empty = Majun ya'oj q'ij nrajo re k'amal re'
recommended-extensions-heading = Chilab'en taq K'amal
recommended-themes-heading = Chilab'en taq Wachinel
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = ¿La at na'owinäq? <a data-l10n-name="link">Tatz'uku' awachinel rik'in ri Firefox Color.</a>

## Page headings

extension-heading = Ke'anuk'samajij ri taq ak'amal
theme-heading = Ke'anuk'samajij ri taq awachinel
plugin-heading = Ke'anuk'samajij ri taq anak'ab'al
dictionary-heading = Ke'anuk'samajij ri taq asoltzij
locale-heading = Ke'anuk'samajij ri taq ach'ab'äl
updates-heading = Ke'anuk'samajij ri taq Ak'exoj
discover-heading = Tawichinaj { -brand-short-name }
shortcuts-heading = Kenuk'samajïx Kichojokem taq K'amal
default-heading-search-label = Kekanöx ch'aqa' chik taq tz'aqat
addons-heading-search-input =
    .placeholder = Tikanöx addons.mozilla.org
addon-page-options-button =
    .title = Taq kisamajib'al konojel ri taq tz'aqat
