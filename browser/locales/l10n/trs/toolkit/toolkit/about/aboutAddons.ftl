# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Sa dugumîn nej extensiûn

addons-page-title = Sa dugumîn nej extensiûn

search-header =
    .placeholder = Nana'uì' addons.mozilla.org
    .searchbuttonlabel = Nana'uì'

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Nitaj ngà' si 'ngo komplementô hua dananj nu 'iaj sun 'iát

list-empty-available-updates =
    .value = Nu nari'ìj nej sa nahui nakàa

list-empty-recent-updates =
    .value = Ngà si 'ngo komplemento nu nahuin nakàa ra'ñanj

list-empty-find-updates =
    .label = Nana'uì' nej sanagi'iaj nakàa

list-empty-button =
    .label = Gahuin chrūn doj rayi’î nej komplemênto

help-button = Nej sa hua doj riña sopôrte

sidebar-help-button-title =
    .title = Nej sa hua doj riña sopôrte

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Sa huaa
       *[other] { -brand-short-name } Sa arâj sun yitïnjt
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Sa huaa
           *[other] { -brand-short-name } Sa arâj sun yitïnjt
        }

show-unsigned-extensions-button =
    .label = Nu ga'ue nana'in da'aj nej extensiôn

show-all-extensions-button =
    .label = Ni'iaj daran' extensiôn

cmd-show-details =
    .label = Ni'iaj doj nuguan' a'min rayi'î nan
    .accesskey = S

cmd-find-updates =
    .label = Nana'uì' nej sa ga'ue nahuin nakà
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Sa huā gi'iát
           *[other] Sa arajsunt doj
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Garasun têma
    .accesskey = W

cmd-disable-theme =
    .label = Ga'nïn' ruhuâ si garasunt têma
    .accesskey = W

cmd-install-addon =
    .label = Ga'nìn'
    .accesskey = I

cmd-contribute =
    .label = Rugûñu'unj
    .accesskey = C
    .tooltiptext = Rugûñu'unj da' nahuin hue'ê doj komplementô nan

detail-version =
    .label = Versión

detail-last-updated =
    .label = Sa nagi'iaj nakà rukù nïn't

detail-contributions-description = Dugui' narirà complementô nan ni achín ni'iaj si da' rugûñu'unjt doj san'anj si da' gi'iaj sun si guendâ nahuin hue'ej doj.

detail-contributions-button = Rugûñu'unj
    .title = rugûñu'unj da' ganahuij sa nata' nan
    .accesskey = C

detail-update-type =
    .value = Nej sa nagi'iaj nakà ma'an ma'an

detail-update-default =
    .label = Sa gà' 'na' niñaan
    .tooltiptext = Dunaj nagi'iaj nakà ma'an ma'an sisi ngà daj huaj 'naj

detail-update-automatic =
    .label = Nachrun
    .tooltiptext = Dunaj nagi'iaj nakà ma'an man

detail-update-manual =
    .label = Duna'àj
    .tooltiptext = Si dunajt nagi'iaj nakà ma'an man

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Na'nïn riña Windows huìi

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Si ga'ue riña Windows huìi

detail-private-disallowed-description2 = Ngà aché nun huìt nī nitāj si ‘iaj sun ekstensiûn nan. <a data-l10n-name="learn-more">Gāhuin chrūn doj</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Da'ui na'nïn riña Windows huìi

detail-private-required-description2 = Ngà aché nun huìt nī atûj ekstensiûn na ni’ia sa ‘iát. <a data-l10n-name="learn-more">Gāhuin chrūn doj</a>

detail-private-browsing-on =
    .label = Ga'nïn
    .tooltiptext = Nachrun riña aché nun huìt

detail-private-browsing-off =
    .label = Si ga'ninjt
    .tooltiptext = Guxun man riña aché nun huìt

detail-home =
    .label = Ñanj ayi'ìj

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil taj ma'an

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Nana'uì' sa Nahuin nakà doj
    .accesskey = F
    .tooltiptext = Nana'uì' sa' ga'ue nahuin nakà riña komplementô nan

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Sa huā gi'iát
           *[other] Sa arajsunt doj
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Naduna nej sa nikaj komplementô nan
           *[other] Naduna nej sa garan' ruhuât riña komplementô nan
        }

detail-rating =
    .value = Antaj nikò guìi araj sun man

addon-restart-now =
    .label = Dunayi'ì nakà akuan' nïn

disabled-unsigned-heading =
    .value = Hua da'aj nej komplemênto ni giyichin' nej man

disabled-unsigned-description = Nej komplementô nan ni nu gachin man da' natsij { -brand-short-name }. Ga'ue gi'iát <label data-l10n-name="find-addons">narì' sa ga'ue natu riña nan</label> asi gachinj ni'iaj riña desarroyadô da' natsij man.

disabled-unsigned-learn-more = Gini'in doj rayi'î sun 'iaj ñûnj da' a'ue aché nu hue'êt riña aga' nan.

disabled-unsigned-devinfo = Nej desarroyadô ruhuâ natsij nej si komplementô ni ga'ue gahiaat nej <label data-l10n-name="learn-more">nachrun ra'a</label>.

plugin-deprecation-description = Hua sa nanu ruhuâ raj? Hua da'aj nej plugîn ni nitaj si aran'anj ngà { -brand-short-name }. <label data-l10n-name="learn-more">Gahuin chrun doj</label>

legacy-warning-show-legacy = Ni'iaj nej extensiûn hua nika hia

legacy-extensions =
    .value = Nej extensiûn hua nikaa

legacy-extensions-description = Nitaj si digahuin nej extensiûn nan ngà nej chrej { -brand-short-name } huaa yi'ì dan giyichin' nej man. <label data-l10n-name="legacy-learn-more">Gini'in doj rayi'î nuguan' hua ngà nadunô' 'ngo komplemênto</label>

private-browsing-description2 = { -brand-short-name } nadunaj dàj 'iaj sun nej ekstensiûn riña aché nun huìt. Ahuin man'an ekstensiûn nutà't riña { -brand-short-name } ni gay'ì man'an gi'iaj sun riña Windows huìi. Nda doj si ga'nïnt riña configurasiûn, sani ekstensiûn nan ni si gi'iaj sunj riña aché nun huìt ni si gini'in sa 'iát. Nan huin nagi'iaj ñûnj dadin' ruhuâ ñûnj sisi nda hue'ê ga gache nunt. <label data-l10n-name="private-browsing-learn-more"> Gahuin chrun doj dàj gi'iaj sunt ngà ekstensiûn nan</label>

addon-category-discover = Nuguan' ganikò't
addon-category-discover-title =
    .title = Nuguan' ganikò't
addon-category-extension = Nej extensiûn
addon-category-extension-title =
    .title = Nej extensiûn
addon-category-theme = Tema
addon-category-theme-title =
    .title = Tema
addon-category-plugin = Nej plugin
addon-category-plugin-title =
    .title = Nej plugin
addon-category-dictionary = Nej danj nuguan'an
addon-category-dictionary-title =
    .title = Nej danj nuguan'an
addon-category-locale = Nej nânj (nuguan')
addon-category-locale-title =
    .title = Nej nânj (nuguan')
addon-category-available-updates = Nej sa ga'ue nahuin nakà
addon-category-available-updates-title =
    .title = Nej sa ga'ue nahuin nakà
addon-category-recent-updates = Nej sa hìaj nahuin nakà
addon-category-recent-updates-title =
    .title = Nej sa hìaj nahuin nakà

## These are global warnings

extensions-warning-safe-mode = Giyichin' hue'ê daran' nej komplemênto.
extensions-warning-check-compatibility = Nej sa natsij nej komplemênto nitaj si 'iaj sun. Ga'ue ginu komplemênto nitaj si ara' ngà aga' nan.
extensions-warning-check-compatibility-button = Dugi'iaj sun' man
    .title = Nachrun sa natsij si aran' nej komplemênto ngà nej aga' nan
extensions-warning-update-security = Giyichin' sa natsij si hua nïn 'iaj sun nej komplemênto. Ga'ue ni nahuin nakà 'ngo sa nu garan' ruhuât.
extensions-warning-update-security-button = Dugi'iaj sun' man
    .title = Nachrun sa dugumîn si hua hue'ê nej sa nahuin nakà riña aga' nan


## Strings connected to add-on updates

addon-updates-check-for-updates = Nana'uì' sa Nahuin nakà doj
    .accesskey = C
addon-updates-view-updates = Ni'iaj nej sa hìaj nahuin nakà
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Dunaj nahuin nakà ma'an nej komplemênto
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Na'nïnj ñû daran' nej komplemênto da' ga'ue nahuin nakà ma'an nej man
    .accesskey = R
addon-updates-reset-updates-to-manual = Na'nïnj ñû daran' nej komplemênto da' ga'ue nagi'iaj nakà nej man
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Sa nagi'iaj nakà nej komplemênto
addon-updates-installed = Ngà nahuin nakà nej si komplementôt.
addon-updates-none-found = Nu nari'ìj nej sa nahuin nakàa
addon-updates-manual-updates-found = Ni'iaj nej sa ga'ue nahuin nakà

## Add-on install/debug strings for page options menu

addon-install-from-file = Ga'nïnj Komplemênto asij riña archibô…
    .accesskey = I
addon-install-from-file-dialog-title = Nagui komplemento ruhuât ga'nïnjt
addon-install-from-file-filter-name = Sa rugu ñunúnj
addon-open-about-debugging = Nej komplemênto nagi'iaj depurandô
    .accesskey = B

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Ni'iaj dàj nagi'iát riña ekstensiûn
    .accesskey = S

shortcuts-no-addons = Nitaj ngà' si 'ngo ekstensiûn 'iaj sun 'iát.
shortcuts-no-commands = Nitaj a'ngô nùhuin si hua riña nej ekstensiûn nan:
shortcuts-input =
    .placeholder = Gachrun a'ngò chrej e

shortcuts-pageAction = Dugi'iaj sun si sun pâjina
shortcuts-sidebarAction = Dukuán nun nitïn gu'nàj Toggle

shortcuts-modifier-mac = Na'nïnj Ctrl, Alt, asi ⌘
shortcuts-modifier-other = Na'nïnj Ctrl asi Alt
shortcuts-invalid = Nu narì't nachrun man
shortcuts-letter = Gachrun 'ngo lêchra
shortcuts-system = Si ga'ue durêe't 'ngo akseso direkto { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Narī ñanj du’ua aksêso direkto

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } huā ga’ì hiūj riñā ‘iaj sunj. Nej sa huā dànanj nī ga’ue nadunā sa gi’ia.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Nga arajsun sa gu'nàj { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Digân { $numberToShow } Doj
    }

shortcuts-card-collapse-button = Nadigân Dòj

header-back-button =
    .title = Nanikàj rukù

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Rû' huin 'ngo aplikasiûn huin nej ekstensiûn ngà nej têma guendâ riña sa nana'uî't nuguan'an, ni rugûñu'unj nej man duguminj nej da'nga' huì hua 'iát, nadunïnjt sa ni'iajt, narì't 'ngo sa nïnj du'uee, guxunt nej sa nitaj si ruhuât ni'iajt, nadunat dàj huin ruhuât ruguì' riña sa nana'uî't nuguan'an, ni doj rasuun huaa. Nej rasun li nan sani a'ngô nej duguî' rirà nej man. Hiuj nan mân 'ngo yi'nïn'ïn { -brand-product-name }<a data-l10n-name="learn-more-trigger">ni'ñanj</a> guendâ dgumîn' sa'àj sò', ni da' gi'iaj sun hue'ej ni gi'iaj sun hìo doj.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Hua da'aj nej rasuun na ni ngà huaj 'naj. Dadin' ni'ia dàj hua nej sa ngà nun 'iát,dàj rû' si perfîlt, ni dàj araj sunt nej man.
discopane-notice-learn-more = Gahuin chrūn doj

privacy-policy = Sa garayino’

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = guendâ <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Nej sa araj sun: { $dailyUsers }
install-extension-button = Nutà' guendâ { -brand-product-name }
install-theme-button = ga'nïnj têma
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Ganikaj ñu'un'
find-more-addons = Narì' doj sa nutà't

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Doj sa ga'ue nagi'át

## Add-on actions

report-addon-button = Gutà' 'ngo gakïn'ïn
remove-addon-button = Guxūn
# The link will always be shown after the other text.
remove-addon-disabled-button = Na’ue narè’ej <a data-l10n-name="link">Nù huin saj?</a>
disable-addon-button = Dunikïn'
enable-addon-button = Dugi'iaj sun' man
preferences-addon-button =
    { PLATFORM() ->
        [windows] Sa huaa
       *[other] Sa arajsunt doj
    }
details-addon-button = A'ngô nej sa nika
release-notes-addon-button = Nuguan' ri' riña aga' na
permissions-addon-button = Gachinj ni'iô'

extension-enabled-heading = Ngà 'iaj sunj
extension-disabled-heading = Nitaj si 'iaj sunj

theme-enabled-heading = Ngà 'iaj sunj
theme-disabled-heading = Nitāj si 'iaj sunj

plugin-enabled-heading = Ngà 'iaj sunj
plugin-disabled-heading = Nitāj si 'iaj sunj

dictionary-enabled-heading = Ngà 'iaj sunj
dictionary-disabled-heading = Nitāj si 'iaj sunj

locale-enabled-heading = Ngà 'iaj sunj
locale-disabled-heading = Nitāj si 'iaj sunj

ask-to-activate-button = Gachinj nì'iaj dugi'iaj sunt man
always-activate-button = Dugi'iaj sun yitïnj man
never-activate-button = Nitaj aman dugi'iaj sunt man

addon-detail-author-label = Sí girirà:
addon-detail-version-label = Bersiûn
addon-detail-last-updated-label = Sa nagi'iaj nakà rukù nïn't
addon-detail-homepage-label = Ñanj ayi'ì'
addon-detail-rating-label = Antaj nikò guìi araj sun man

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Naga'uì' sa du'ue { NUMBER($rating, maximumFractionDigits: 1) } asîj yakaj gan'anj 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (nitaj si 'iaj sunj)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } sa natsij
       *[other] { $numberOfReviews } nej sa natsij
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> ngà giyi'nej man.
pending-uninstall-undo-button = Nadurê'

addon-detail-updates-label = Ga'nín nagi'iaj nakà man'an man
addon-detail-updates-radio-default = Sa gà' 'na' niñaan
addon-detail-updates-radio-on = Nachrun
addon-detail-updates-radio-off = Duna'àj
addon-detail-update-check-label = Nana'uì' sa Nahuin nakà doj
install-update-button = Nagi'iaj nakà

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Màn riña nej bentanâ huìi huaj
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Sisi ga'nïn, ekstensiûn nan ga'ue ni'iaj sa 'iát nga aché nun huìt. <a data-l10n-name="learn-more">Gahuin chrun doj</a>
addon-detail-private-browsing-allow = Ga'nïn
addon-detail-private-browsing-disallow = Si ga'nï'

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } nadiganj nej ekstensiûn nikò’ si nuguàn’ ñûnj dàj duguminj nī dàj ‘iaj sunj
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Nej sa ga'ue nahuin nakà
recent-updates-heading = Nej sa hìaj nahuin nakà

release-notes-loading = Hìaj ayi'ij...
release-notes-error = Si ga'man ruhuât sani, ga 'ngo sa gahui a'na' ngà nej si nota versiôn.

addon-permissions-empty = Nitaj si ni'ñanj ekstensiûn nan gà' si 'ngo nuguan arajyinaa

recommended-extensions-heading = Nej ekstensiûn ga'ue garasunt
recommended-themes-heading = Nej temâ ga'ue garasunt

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Ûta hua sa ahui ràt ruhuâ raj? <a data-l10n-name="link">Girirà dàj ga si temât ngà Firefox Color.</a>

## Page headings

extension-heading = Nanà'uì' nej si extensiûnt
theme-heading = Nanaà'ui' nej si temât
plugin-heading = Nanà'uì' nej sa nutà't doj
dictionary-heading = Nanà'uì' nej si diksionariôt
locale-heading = Nanà'uì' nej si nuguàn't
updates-heading = Ganikāj ñu’ūnj nej sa nagi’iaj nakàt
discover-heading = Nagi'iaj dàj garan' ruhuât si { -brand-short-name }
shortcuts-heading = Dugumîn nej akseso direkto riña nej ekstensiûn

addons-heading-search-input =
    .placeholder = Nana'uì' addons.mozilla.org

addon-page-options-button =
    .title = Rasuun gini'ñanj daran' nej komplemênto
