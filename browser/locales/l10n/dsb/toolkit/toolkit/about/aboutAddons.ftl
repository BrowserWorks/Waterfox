# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Zastojnik dodankow
addons-page-title = Zastojnik dodankow

search-header =
    .placeholder = Na addons.mozilla.org pytaś
    .searchbuttonlabel = Pytaś

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Njejsćo dodanki toś togo typa instalěrował

list-empty-available-updates =
    .value = Žedne aktualizacije namakane

list-empty-recent-updates =
    .value = Slědny cas njejsćo dodanki aktualizěrował

list-empty-find-updates =
    .label = Za aktualizacijami pytaś

list-empty-button =
    .label = Dalšne informacije wó dodankach

help-button = Pomoc za dodanki
sidebar-help-button-title =
    .title = Pomoc za dodanki

preferences =
    { PLATFORM() ->
        [windows] Nastajenja { -brand-short-name }
       *[other] Nastajenja { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Nastajenja { -brand-short-name }
           *[other] Nastajenja { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Někotare rozšyrjenja njejsu dali se wobkšuśiś

show-all-extensions-button =
    .label = Wšykne rozšyrjenja pokazaś

cmd-show-details =
    .label = Dalšne informacije pokazaś
    .accesskey = i

cmd-find-updates =
    .label = Aktualizacije pytaś
    .accesskey = A

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }

cmd-enable-theme =
    .label = Drastwu wužywaś
    .accesskey = r

cmd-disable-theme =
    .label = Drastwu wěcej njewužywaś
    .accesskey = w

cmd-install-addon =
    .label = Instalěrowaś
    .accesskey = I

cmd-contribute =
    .label = Pśinosowaś
    .accesskey = P
    .tooltiptext = K wuwiśeju toś togo dodanka pśinosowaś

detail-version =
    .label = Wersija

detail-last-updated =
    .label = Slědny raz zaktualizěrowany

detail-contributions-description = Wuwijaŕ toś togo dodanka pšosy, aby wy pomagał, jogo stawne wuwiśe pódpěraś, z tym až pósćiwaśo mały pśinosk.

detail-contributions-button = Pśinosowaś
    .title = K wuwijanjeju toś togo dodanka pśinosowaś
    .accesskey = P

detail-update-type =
    .value = Awtomatiske aktualizacije

detail-update-default =
    .label = Standard
    .tooltiptext = Aktualizacije jano awtomatiski instalěrowaś, jolic to jo standard

detail-update-automatic =
    .label = Zašaltowany
    .tooltiptext = Aktualizacije awtomatiski instalěrowaś

detail-update-manual =
    .label = Wušaltowany
    .tooltiptext = Aktualizacije awtomatiski njeinstalěrowaś

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = W priwatnych woknach wuwjasć

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = W priwatnych woknach njedowólony
detail-private-disallowed-description2 = Toś to rozšyrjenje w priwatnem modusu njefunkcioněrujo. <a data-l10n-name="learn-more">Dalšne informacije</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Pomina se pśistup k priwatnym woknam
detail-private-required-description2 = Toś to rozšyrjenje ma pśistup k wašym aktiwitam online w priwatnem modusu. <a data-l10n-name="learn-more">Dalšne informacije</a>

detail-private-browsing-on =
    .label = Dowóliś
    .tooltiptext = W priwatnem modusu zmóžniś

detail-private-browsing-off =
    .label = Njedowóliś
    .tooltiptext = W priwatnem modusu znjemóžniś

detail-home =
    .label = Startowy bok

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Dodankowy profil

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Za aktualizacijami pytaś
    .accesskey = Z
    .tooltiptext = Aktualizacije za toś ten dodank pytaś

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Nastajenja toś togo dodanka změniś
           *[other] Nastajenja toś togo dodanka změniś
        }

detail-rating =
    .value = Pógódnośenje

addon-restart-now =
    .label = Něnto znowego startowaś

disabled-unsigned-heading =
    .value = Někotre dodanki su se znjemóžnili

disabled-unsigned-description = Slědujuce dodanki njejsu se wobkšuśili za wužywanje w { -brand-short-name }. Móžośo <label data-l10n-name="find-addons">wuměnenja namakaś</label> abo wuwijarja pšosyś, je wobkšuśiś.

disabled-unsigned-learn-more = Zgóńśo wěcej wó našych procowanjach, wam pomagaś, online wěsty wóstaś.

disabled-unsigned-devinfo = Wuwijarje, kótarež kśě, až jich dodanki se wobkšuśiju, mógu pókšacowaś, z tym až cytaju našu <label data-l10n-name="learn-more">pśirucku</label>.

plugin-deprecation-description = Felujo něco? Někotare tykace njepódpěraju se wěcej pśez { -brand-short-name }. <label data-l10n-name="learn-more">Dalšne informacije.</label>

legacy-warning-show-legacy = Zestarjone rozšyrjenja pokazaś

legacy-extensions =
    .value = Zestarjone rozšyrjenja

legacy-extensions-description = Toś te rozšyrjenja su se znjemóžnili, dokulaž standardam { -brand-short-name } njewótpowěduju. <label data-l10n-name="legacy-learn-more">Dalšne informacije wó změnach toś tych dodankow</label>

private-browsing-description2 =
    { -brand-short-name } změnja, kak rozšyrjenja w priwatnem modusu funkcioněruju. Nowe rozšyrjenja, kótarež
    { -brand-short-name } pśidawaśo, pó standarźe w priwatnych woknach njefunkcioněruju. Snaźkuli
    dowólujośo to w nastajenjach, rozšyrjenje w priwatnem modusu njefunkcioněrujo a njama pśistup k wašym
    aktiwitam online. Smy toś tu změnu cynili, aby waš priwatny modus priwatny wóstał. <label data-l10n-name="private-browsing-learn-more">Zgóńśo wěcej wó zastojanju nastajenjow rozšyrjenja.</label>

addon-category-discover = Dopórucenja
addon-category-discover-title =
    .title = Dopórucenja
addon-category-extension = Rozšyrjenja
addon-category-extension-title =
    .title = Rozšyrjenja
addon-category-theme = Drastwy
addon-category-theme-title =
    .title = Drastwy
addon-category-plugin = Tykace
addon-category-plugin-title =
    .title = Tykace
addon-category-dictionary = Słowniki
addon-category-dictionary-title =
    .title = Słowniki
addon-category-locale = Rěcy
addon-category-locale-title =
    .title = Rěcy
addon-category-available-updates = Aktualizacije
addon-category-available-updates-title =
    .title = Aktualizacije
addon-category-recent-updates = Nowe aktualizacije
addon-category-recent-updates-title =
    .title = Nowe aktualizacije

## These are global warnings

extensions-warning-safe-mode = Wšykne dodanki su se pśez wěsty modus znjemóžnili.
extensions-warning-check-compatibility = Pśespytowanje dodankoweje kompatibelnosći jo znjemóžnjone. Jo móžno, až maśo njekompatibelne dodanki.
extensions-warning-check-compatibility-button = Zmóžniś
    .title = Pśespytowanje dodankeje kompatibelnosći zmóžniś
extensions-warning-update-security = Pśespytowanje wěstoty aktualizacije jo znjemóžnjone. Jo móžno, až aktualizacije wam wobgrozuju.
extensions-warning-update-security-button = Zmóžniś
    .title = Pśespytowanje wěstoty aktualizacije zmóžniś


## Strings connected to add-on updates

addon-updates-check-for-updates = Za aktualizacijami pytaś
    .accesskey = a
addon-updates-view-updates = Nowe aktualizacije se woglědaś
    .accesskey = N

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Dodanki awtomatiski aktualizěrowaś
    .accesskey = D

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Wšykne dodanki zasej awtomatiski aktualizěrowaś
    .accesskey = z
addon-updates-reset-updates-to-manual = Wšykne dodanki manuelnje aktualizěrowaś
    .accesskey = m

## Status messages displayed when updating add-ons

addon-updates-updating = Aktualizěrowanje dodankow
addon-updates-installed = Waše dodanki su se zaktualizěrowali.
addon-updates-none-found = Žedne aktualizacije namakane
addon-updates-manual-updates-found = K dispoziciji stojece aktualizacije se woglědaś

## Add-on install/debug strings for page options menu

addon-install-from-file = Dodank z dataje instalěrowaś…
    .accesskey = D
addon-install-from-file-dialog-title = Dodank za instalaciju wubraś
addon-install-from-file-filter-name = Dodanki
addon-open-about-debugging = Dodanki za zmólkami pśepytowaś
    .accesskey = m

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Tastowe skrotconki rozšyrjenjow zastojaś
    .accesskey = T

shortcuts-no-addons = Njejśco zmóžnił žedne rozšyrjenja.
shortcuts-no-commands = Slědujuce rozšyrjenja njamaju  tastowe skrotconki:
shortcuts-input =
    .placeholder = Zapódajśo tastowu skrotconku

shortcuts-browserAction2 = Tłocašk symboloweje rědki aktiwěrowaś
shortcuts-pageAction = Akciju boka aktiwěrowaś
shortcuts-sidebarAction = Bocnicu pśešaltowaś

shortcuts-modifier-mac = Strg, Alt abo ⌘ zapśimjeś
shortcuts-modifier-other = Strg abo Alt zapśimjeś
shortcuts-invalid = Njepłaśiwa kombinacija
shortcuts-letter = Zapódajśo pismik
shortcuts-system = Tastowa skrotconka { -brand-short-name } njedajo se pśepisaś

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Dwójna tastowa skrotconka

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } se ako tastowa skrotconka wěcej raz wužywa. Dwójne tastowe skrotconki mógu njewótcakane zaźaržanje zawinowaś.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Wužywa se južo pśez { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] { $numberToShow } dalšny pokazaś
        [two] { $numberToShow } dalšnej pokazaś
        [few] { $numberToShow } dalšne pokazaś
       *[other] { $numberToShow } dalšnych pokazaś
    }

shortcuts-card-collapse-button = Mjenjej pokazaś

header-back-button =
    .title = Slědk

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Rozšyrjenja a drastwy su ako nałoženja za waš wobglědowak, a šćitaju gronidła, ześěguju wideo, namakaju wułapotki, blokěruju gramne wabjenje, změnjaju naglěd wašogo wobglědowaka a wjele wěcej. Toś te małe softwarowe programy se cesto wót tśeśich wuwijaju. How jo wuběrk { -brand-product-name }<a data-l10n-name="learn-more-trigger">dopóruconych</a> rozšyrjenjow za { -brand-product-name } za wósebnu wěstotu, wugbaśe a funkcionalnosć.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Někotare z toś tych dopórucenjow su personalizěrowane. Bazěruju na rozšyrjenjach, kótarež sćo instalěrował, profilowych nastajenjach a wužywańskej statistice.
discopane-notice-learn-more = Dalšne informacije

privacy-policy = Pšawidła priwatnosći

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = wót <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Wužywarje: { $dailyUsers }
install-extension-button = { -brand-product-name } pśidaś
install-theme-button = Drastwu instalěrowaś
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Zastojaś
find-more-addons = Woglědajśo se dalšne dodanki

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Dalšne nastajenja

## Add-on actions

report-addon-button = K wěsći daś
remove-addon-button = Wótwónoźeś
# The link will always be shown after the other text.
remove-addon-disabled-button = Njedajo se wótwónoźeś <a data-l10n-name="link">Cogodla?</a>
disable-addon-button = Znjemóžniś
enable-addon-button = Zmóžniś
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Zmóžniś
preferences-addon-button =
    { PLATFORM() ->
        [windows] Nastajenja
       *[other] Nastajenja
    }
details-addon-button = Drobnostki
release-notes-addon-button = Wersijowe informacije
permissions-addon-button = Pšawa

extension-enabled-heading = Zmóžnjony
extension-disabled-heading = Znjemóžnjony

theme-enabled-heading = Zmóžnjony
theme-disabled-heading = Znjemóžnjony

plugin-enabled-heading = Zmóžnjony
plugin-disabled-heading = Znjemóžnjony

dictionary-enabled-heading = Zmóžnjony
dictionary-disabled-heading = Znjemóžnjony

locale-enabled-heading = Zmóžnjony
locale-disabled-heading = Znjemóžnjony

ask-to-activate-button = Za aktiwěrowanje se pšašaś
always-activate-button = Pśecej aktiwěrowaś
never-activate-button = Nigda njeaktiwěrowaś

addon-detail-author-label = Awtor
addon-detail-version-label = Wersija
addon-detail-last-updated-label = Slědny raz zaktualizěrowany
addon-detail-homepage-label = Startowy bok
addon-detail-rating-label = Pógódnośenje

# Message for add-ons with a staged pending update.
install-postponed-message = Toś to rozšyrjenje buźo se aktualizěrowaś, gaž se { -brand-short-name } znowego startujo.
install-postponed-button = Něnto aktualizěrowaś

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Pógódnośony z { NUMBER($rating, maximumFractionDigits: 1) } z 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (znjemóžnjony)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } pógódnośenje
        [two] { $numberOfReviews } pógódnośeni
        [few] { $numberOfReviews } pógódnośenja
       *[other] { $numberOfReviews } pógódnośenjow
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> jo se wótwónoźił.
pending-uninstall-undo-button = Anulěrowaś

addon-detail-updates-label = Awtomatiske aktualizacije dowóliś
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = Zašaltowany
addon-detail-updates-radio-off = Wušaltowany
addon-detail-update-check-label = Za aktualizacijami pytaś
install-update-button = Aktualizěrowaś

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = W priwatnych woknach dowólony
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Jolic maśo pšawo, ma rozšyrjenje pśistup na waše aktiwity online w priwatnem modusu. <a data-l10n-name="learn-more">Dalšne informacije</a>
addon-detail-private-browsing-allow = Dowóliś
addon-detail-private-browsing-disallow = Njedowóliś

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } jano rozšyrjenja dopórucujo, kótarež našym standardam za wěstotu a wugbaśe wótpowěduju.
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = K dispoziciji stojece aktualizacije
recent-updates-heading = Nejnowše aktualizacije

release-notes-loading = Zacytujo se…
release-notes-error = Pśi zacytowanju wersijowych informacijow jo bóžko zmólka nastała.

addon-permissions-empty = Toś to rozšyrjenje se pšawa njepomina

recommended-extensions-heading = Dopórucone rozšyrjenja
recommended-themes-heading = Dopórucone drastwy

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Cujośo se kreatiwny? <a data-l10n-name="link">Napórajśo swójsku drastwu z Firefox Color.</a>

## Page headings

extension-heading = Waše rozšyrjenja zastojaś
theme-heading = Waše drastwy zastojaś
plugin-heading = Waše tykace zastojaś
dictionary-heading = Waše słowniki zastojaś
locale-heading = Waše rěcy zastojaś
updates-heading = Waše aktualizacije zastojaś
discover-heading = Personalizěrujśo swój { -brand-short-name }
shortcuts-heading = Tastowe skrotconki rozšyrjenjow zastojaś

default-heading-search-label = Woglědajśo se dalšne dodanki
addons-heading-search-input =
    .placeholder = Na addons.mozilla.org pytaś

addon-page-options-button =
    .title = Rědy za wšykne dodanki
