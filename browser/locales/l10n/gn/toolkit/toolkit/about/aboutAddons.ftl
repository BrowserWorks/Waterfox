# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Moĩmbaha ñangarekohára
addons-page-title = Moĩmbaha ñangarekohára
search-header =
    .placeholder = Eheka addons.mozilla.org
    .searchbuttonlabel = Heka
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Ndereguerekói ãichagua moĩmbaha
list-empty-available-updates =
    .value = Ndojejuhúi ñembohekopyahu
list-empty-recent-updates =
    .value = Nerembopyahúi mba’evéichagua moĩmbaha
list-empty-find-updates =
    .label = Ñembohekopyahu jeheka
list-empty-button =
    .label = Eikuaave moĩmbahakuéra rehegua
help-button = Moĩmbaha jokoha
sidebar-help-button-title =
    .title = Moĩmbaha jokoha
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } Poravopyrã
       *[other] { -brand-short-name } Jerohoryvéva
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } Poravopyrã
           *[other] { -brand-short-name } Jerohoryvéva
        }
show-unsigned-extensions-button =
    .label = Heta pukukue ndaikatúi kuri ojehechajey
show-all-extensions-button =
    .label = Opaite mba’ejoapyrã jehecha
cmd-show-details =
    .label = Maranduve jehechauka
    .accesskey = S
cmd-find-updates =
    .label = Ñembohekopyahu jeheka
    .accesskey = F
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Jeporavorã
           *[other] Jerohoryvéva
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = Mbojeguaha Puru
    .accesskey = M
cmd-disable-theme =
    .label = Anive eipuru ko Mbojeguaha
    .accesskey = W
cmd-install-addon =
    .label = Mohenda
    .accesskey = I
cmd-contribute =
    .label = Pytyvõ
    .accesskey = C
    .tooltiptext = Eipytyvõ moĩmbaha ñemboguatápe
detail-version =
    .label = Peteĩchagua
detail-last-updated =
    .label = Ñembohekopyahu ramovéva
detail-contributions-description = Ko moĩmbaha mboguatahára ojerure eipytyvõ okueve hag̃ua mboguatahápe ejapóvo peteĩ michĩmíva mba’eme’ẽ.
detail-contributions-button = Ñepytyvõ
    .title = Eipytyvõ ko moĩmbaha okakuaa hag̃ua
    .accesskey = Ñ
detail-update-type =
    .value = Ñembohekopyahu ijeheguíva
detail-update-default =
    .label = Jepokokuaa’ỹha
    .tooltiptext = Emohendarei tekopyahu oĩ jave kóva ypykuéramo
detail-update-automatic =
    .label = Hẽe
    .tooltiptext = Emohenda ñembohekopyahu ijeheguíva
detail-update-manual =
    .label = Mongepyre
    .tooltiptext = Aníke emohenda ñembohekopyahu ijeheguíva
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Eipuru ovetã ñemíme
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Noñemoneĩri ovetã ñemíme
detail-private-disallowed-description2 = Ko jepysokue ndoikói kundaha ñemíme. <a data-l10n-name="learn-more">Eikuaave</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Oikotevẽ ovetã ñemíme jeike
detail-private-required-description2 = Ko jepysokue oikekuaa ne rembiapo ñandutípe eikundaha ñeminguévo. <a data-l10n-name="learn-more">Eikuaave</a>
detail-private-browsing-on =
    .label = Moneĩ
    .tooltiptext = Embojuruja kundaha ñemíme
detail-private-browsing-off =
    .label = Ani emoneĩ
    .tooltiptext = Eipe'a kundaha ñemígui
detail-home =
    .label = Kuatiarogue ñepyrũha
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Perfil del complemento
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Ñembohekopyahu jeheka
    .accesskey = f
    .tooltiptext = Eheka ñembohekopyahu ko moĩmbaha rehegua
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Jeporavorã
           *[other] Ojererohoryvéva
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Emoambue poravopyrã ko moĩmbaha rehegua
           *[other] Emoambue jerohoryvéva ko moĩmbaha rehegua
        }
detail-rating =
    .value = Ñehepyme’ẽ
addon-restart-now =
    .label = Emoñepyrũjey ko’ág̃a
disabled-unsigned-heading =
    .value = Heta moĩmbaha ojepe’aitéma
disabled-unsigned-description = Ko’ã moĩmbaha ndojehechajeýi ojepuru hag̃uáicha { -brand-short-name }-pe. Ikatu<label data-l10n-name="find-addons">Myengoviarã juhu</label> térã ejerure mboguatahárape ojehechajey hag̃ua.
disabled-unsigned-learn-more = Eikuaave oreñeha’ã rehegua ikatu hag̃uáicha roipytyvõ peime hag̃ua jeikekatúpe.
disabled-unsigned-devinfo = Umi mboguatahára oipotáva moĩmbaha jehechapyréva ikatu omoñe’ẽve ohóvo ko <label data-l10n-name="learn-more">popeguáva</label>.
plugin-deprecation-description = ¿Oĩ nderejuhúiva? Sapy’ánte oĩ mba’ejoajurã ndaikatuvéima ojepuru { -brand-short-name } ndive. <label data-l10n-name="learn-more">Jeikuaave.</label>
legacy-warning-show-legacy = Opaite mba’ejoapyrã jehecha
legacy-extensions =
    .value = Opaite mba’ejoapyrã
legacy-extensions-description = Ko’ã jepysokue ndoguerekói { -brand-short-name } tekoguatarã oñembogue hag̃ua. <label data-l10n-name="legacy-learn-more">Maranduve moĩmbaha moambue rehegua</label>
private-browsing-description2 =
    { -brand-short-name } iñambuehína mba’éichapa omba’apo jepysokue kundaha ñemíme. Oimeraẽva jepysokue pyahu embojuajúva
    { -brand-short-name } rupi nomba’apomo’ãi ijypykue rupi kundaha ñemíme. Neremoneĩrirõ Moĩporãhápe, pe jepysokue ndoikomo’ãi kundaha ñemíme, ha ndoikemo’ãi nerembiapo ñanduti
    peguápe. Romoambue roguereko hag̃ua ñemiháme ne kundaha ñemigua.
    <label data-l10n-name="private-browsing-learn-more">Eikuaa mba’éichapa eñangarekóta ko’ã jepysokue ñemboheko rehe </label>
addon-category-discover = Je’eporã
addon-category-discover-title =
    .title = Je’eporã
addon-category-extension = Mba’ejoapyrã
addon-category-extension-title =
    .title = Mba’ejoapyrã
addon-category-theme = Téma
addon-category-theme-title =
    .title = Téma
addon-category-plugin = Mba’ejoajurã
addon-category-plugin-title =
    .title = Mba’ejoajurã
addon-category-dictionary = Ñe’ẽryru
addon-category-dictionary-title =
    .title = Ñe’ẽryru
addon-category-locale = Ñe’ẽita
addon-category-locale-title =
    .title = Ñe’ẽita
addon-category-available-updates = Ñembohekopyahu eipurukuaáva
addon-category-available-updates-title =
    .title = Ñembohekopyahu eipurukuaáva
addon-category-recent-updates = Ñembohekopyahu ramovéva
addon-category-recent-updates-title =
    .title = Ñembohekopyahu ramovéva

## These are global warnings

extensions-warning-safe-mode = Opaite moĩmbaha oñemongepáma teko jerovia rupi.
extensions-warning-check-compatibility = Ojueheguáva jehechajey moĩmbaha reheguáva oñemongéma. Ikatu oguereko heta juehegua’ỹva.
extensions-warning-check-compatibility-button = Myandy
    .title = Ojueheguáva jehechajey moĩmbaha reheguáva myandy.
extensions-warning-update-security = Tekorosãrã jehechajey moĩmbaha rehegua oñemongéma. Ikatu ehecha nde rekorosãrã oñembyaikuaáva embohekopyahu aja.
extensions-warning-update-security-button = Myandy
    .title = Emyandy jehechajey moĩmbaha rekorosãrã reheguáva

## Strings connected to add-on updates

addon-updates-check-for-updates = Ñembohekopyahu jeheka
    .accesskey = C
addon-updates-view-updates = Ñembohekopyahu ramovéva jehecha
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Moĩmbaha ijeheguietéva mbohekopyahu
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Emboheko opaite umi moĩmbaha oñembohekopyahu hag̃ua ijeheguiete
    .accesskey = R
addon-updates-reset-updates-to-manual = Emboheko opaite moĩmbaha oñembohekopyahu hag̃uáicha pópe
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Moĩmbaha hekopyahuhína
addon-updates-installed = Oñembohekopyahúma nemoĩmbaha.
addon-updates-none-found = Ndojejuhúi ñembohekopyahu
addon-updates-manual-updates-found = Ehecha ñembohekopyahu eipurukuaáva

## Add-on install/debug strings for page options menu

addon-install-from-file = Emohenda moĩmbaha marandurenda guive…
    .accesskey = I
addon-install-from-file-dialog-title = Eiporavo moĩmbaha emohenda hag̃ua
addon-install-from-file-filter-name = Moĩmbahakuéra
addon-open-about-debugging = Emopotĩ Moĩmbahakuéra
    .accesskey = p

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Eñangareko jepysokue jeike pya’eha rehe
    .accesskey = S
shortcuts-no-addons = Ndoguerekói jepysokue ijurujáva.
shortcuts-no-commands = Ko’ã jepysokue ndoguerekói jeike pya’eha:
shortcuts-input =
    .placeholder = Ehai mbopya’eha
shortcuts-browserAction2 = Emyandy votõ tembipuru renda
shortcuts-pageAction = Emyandy kuatiarogue ñemongu’e
shortcuts-sidebarAction = Embojopyru tenda yke
shortcuts-modifier-mac = Emoinge Ctrl, Alt o ⌘
shortcuts-modifier-other = Emoinge Ctrl or Alt
shortcuts-invalid = Ñembojopyru ndoikóiva
shortcuts-letter = Ehai peteĩ tai
shortcuts-system = Ndaikatúi eipe’a peteĩ mbopya’eha { -brand-short-name } mba’éva
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Jeike pya’eha imokõiva
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = Pe { $shortcut } ojepuruhína mbopya’eháramo heta jey. Pe jeike pya’eha ikõiva ikatu ojapo mba’e eha’arõ’ỹva.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Oipurúma { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Ehechave { $numberToShow }
       *[other] Ehechave { $numberToShow }
    }
shortcuts-card-collapse-button = Ehechauka’ive
header-back-button =
    .title = Guevijey

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Umi jepysokue ha téma ha’e tembipuru’i kundahápe g̃uarã ha omo’ã ñe’ẽñemi, ta’ãngamýi ñemboguejy, joguarã jejuhu, maranduñemurã jejoko, kundahára rova ñemoambue ha hetave mba’e. Mbohapyhaguáva hetave jey umi omoheñóiva software. Rome’ẽ jeporavorã { -brand-product-name } <a data-l10n-name="learn-more-trigger">je’eporãpy</a> tekorosãme, apopyre ha tembiaporape ijojaha’ỹva.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Heta ko’ã ñe’ẽporã ha’e ñemomba’epyre. Ojehecha ambue jepysokue ñemohendapyre, ne mba’ete erohoryvéva ha ijepurukue.
discopane-notice-learn-more = Kuaave
privacy-policy = Temiñemi purureko
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = <a data-l10n-name="author">{ $author }</a> rupi
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Puruhára: { $dailyUsers }
install-extension-button = Embojuaju { -brand-product-name }
install-theme-button = Emohenda téma
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Ñangareko
find-more-addons = Ehekave moĩmbaha
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Jeporavorãve

## Add-on actions

report-addon-button = Momarandu
remove-addon-button = Mboguete
# The link will always be shown after the other text.
remove-addon-disabled-button = Ndaikatúi emboguete <a data-l10n-name="link">¿Mba’ére?</a>
disable-addon-button = Pe’a
enable-addon-button = Mbojuruja
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Mbojuruja
preferences-addon-button =
    { PLATFORM() ->
        [windows] Jerohoryvéva
       *[other] Jeporavorã
    }
details-addon-button = Mba’emimi
release-notes-addon-button = Jehaipy rehegua
permissions-addon-button = Moneĩ
extension-enabled-heading = Myandypyre
extension-disabled-heading = Ojepuruve’ỹva
theme-enabled-heading = Myandypyre
theme-disabled-heading = Ojepuruve’ỹva
plugin-enabled-heading = Myandypyre
plugin-disabled-heading = Ojepuruve’ỹva
dictionary-enabled-heading = Myandypyre
dictionary-disabled-heading = Ojepuruve’ỹva
locale-enabled-heading = Myandypyre
locale-disabled-heading = Ojepuruve’ỹva
ask-to-activate-button = Eporandu emyandy hag̃ua
always-activate-button = Emyandy tapia
never-activate-button = Ani emyandy araka’eve
addon-detail-author-label = Apohára
addon-detail-version-label = Peteĩchagua
addon-detail-last-updated-label = Mbohekopyahu paha
addon-detail-homepage-label = Kuatiarogue ñepyrũha
addon-detail-rating-label = Jeporavopy
# Message for add-ons with a staged pending update.
install-postponed-message = Ko jepysokue hekopyahúta emoñepyrũjeývo { -brand-short-name }.
install-postponed-button = Embohekopyahu ko’ág̃a
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Mbopapapyre { NUMBER($rating, maximumFractionDigits: 1) } 5 peve
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (jepe’apyre)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } jehechajey
       *[other] { $numberOfReviews } jehechajey
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Oñemboguete <span data-l10n-name="addon-name">{ $addon }</span>.
pending-uninstall-undo-button = Mboguevi
addon-detail-updates-label = Emoneĩ mbohekopyahu ijeheguíva
addon-detail-updates-radio-default = Ijypykue
addon-detail-updates-radio-on = Hendypyre
addon-detail-updates-radio-off = Mbogue
addon-detail-update-check-label = Eheka mohekopyahu
install-update-button = Mohekopyahu
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Ovetã ñemíme moneĩmbyre
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Hendy jave, pe jepysokue ikatu oike ejapóva guivépe eikundaha ñemi aja. <a data-l10n-name="learn-more">Eikuaave</a>
addon-detail-private-browsing-allow = Moneĩ
addon-detail-private-browsing-disallow = Ani emoneĩ
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } omoneĩ jepysokue oguerekóva tekorosã ha tembiapokue
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Ñembohekopyahu eipurukuaáva
recent-updates-heading = Mohekopyahu ramoveguáva
release-notes-loading = Henyhẽhína…
release-notes-error = Rombyasy, hákatu oiko jejavy henyhẽnguévo jehaipy rehegua.
addon-permissions-empty = Ko jepysokue noikotevẽi ñemoneĩ
recommended-extensions-heading = Jepysokue je’eporãpyre
recommended-themes-heading = Téma je’eporãpyre
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = ¿Emoheñoisépa? <a data-l10n-name="link">Emoheñoi ne temarã Firefox Color ndive.</a>

## Page headings

extension-heading = Emongu’e nde jepysokue
theme-heading = Emongu’e nde téma
plugin-heading = Emongu’e nde mboguejyrã’i
dictionary-heading = Emongu’e ne ñe’ẽryrukuéra
locale-heading = Emongu’e ne ñe’ẽnguéra
updates-heading = Eñangareko ne ñembohekopyahúre
discover-heading = Emomba’e nde { -brand-short-name }
shortcuts-heading = Eñangareko jepysokue jeike pya’eháre
default-heading-search-label = Ehekave moĩmbaha
addons-heading-search-input =
    .placeholder = Eheka addons.mozilla.org
addon-page-options-button =
    .title = Tembipuru opaite moimbahápe g̃uarã
