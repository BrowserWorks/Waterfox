# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Add-onbehearder
addons-page-title = Add-onbehearder
search-header =
    .placeholder = addons.mozilla.org trochsykje
    .searchbuttonlabel = Sykje
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Jo hawwe gjin add-ons fan dit type ynstallearre
list-empty-available-updates =
    .value = Gjin fernijingen fûn
list-empty-recent-updates =
    .value = Jo hawwe koartlyn gjin add-ons fernijd
list-empty-find-updates =
    .label = Kontrolearje op fernijingen
list-empty-button =
    .label = Mear ynfo oer add-ons
help-button = Add-on-stipe
sidebar-help-button-title =
    .title = Add-on-stipe
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name }-opsjes
       *[other] { -brand-short-name }-foarkarren
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name }-opsjes
           *[other] { -brand-short-name }-foarkarren
        }
show-unsigned-extensions-button =
    .label = Guon útwreidingen koene net ferifiearre wurde
show-all-extensions-button =
    .label = Alle útwreidingen toane
cmd-show-details =
    .label = Mear ynformaasje toane
    .accesskey = M
cmd-find-updates =
    .label = Fernijingen sykje
    .accesskey = F
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opsjes
           *[other] Foarkarren
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] F
        }
cmd-enable-theme =
    .label = Brûk tema
    .accesskey = B
cmd-disable-theme =
    .label = Brûk tema net mear
    .accesskey = B
cmd-install-addon =
    .label = Ynstallearje
    .accesskey = Y
cmd-contribute =
    .label = Bydrage
    .accesskey = B
    .tooltiptext = Bydrage oan de ûntwikkeling fan dizze add-on
detail-version =
    .label = Ferzje
detail-last-updated =
    .label = Lêst bywurke
detail-contributions-description = De ûnwikkeler fan dizze add-on freget om stipe foar de trochgeande ûntwikkeling troch it meitsjen fan in lytse bydrage.
detail-contributions-button = Bydrage
    .title = Bydrage oan de ûntwikkeling fan dizze add-on
    .accesskey = B
detail-update-type =
    .value = Automatyske fernijingen
detail-update-default =
    .label = Standert
    .tooltiptext = Automatysk fernijingen ynstallearje allinnich as dat de standert is
detail-update-automatic =
    .label = Oan
    .tooltiptext = Automatysk fernijingen ynstallearje
detail-update-manual =
    .label = Ut
    .tooltiptext = Net automatysk fernijingen ynstallearje
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Utfiere yn priveefinsters
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Net tastien yn priveefinsters
detail-private-disallowed-description2 = Dizze útwreiding wurdt wylst priveenavigaasje net útfierd. <a data-l10n-name="learn-more">Mear ynfo</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Fereaske tagong ta priveefinsters
detail-private-required-description2 = Dizze útwreiding hat wylst priveenavigaasje tagong ta jo online-aktiviteiten. <a data-l10n-name="learn-more">Mear ynfo</a>
detail-private-browsing-on =
    .label = Tastean
    .tooltiptext = Ynskeakelje yn priveenavigaasje
detail-private-browsing-off =
    .label = Net tastean
    .tooltiptext = Utskeakelje yn priveenavigaasje
detail-home =
    .label = Begjinside
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Add-onsprofyl
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Kontrolearje op fernijingen
    .accesskey = K
    .tooltiptext = Kontrolearje op fernijingen foar dizze add-on
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opsjes
           *[other] Foarkarren
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] F
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Opsjes fan dizze add-ons wizigje
           *[other] Foarkarren fan dizze add-ons wizigje
        }
detail-rating =
    .value = Wurdearring:
addon-restart-now =
    .label = No opnij starte
disabled-unsigned-heading =
    .value = Guon add-ons binne útskeakele
disabled-unsigned-description = De folgjende add-ons binne net ferifiearre foar gebrûk yn { -brand-short-name }. Jo kinne <label data-l10n-name="find-addons">nei ferfangingen sykje</label> of de ûntwikkeler freegje dizze ferifiearje te litten.
disabled-unsigned-learn-more = Mear ynfo oer ús besykjen om jo online feilich te hâlden.
disabled-unsigned-devinfo = Untwikkelers dy't ynteresse hawwe yn it ferifiearjen litten fan harren add-ons kinne fierdergean troch ús <label data-l10n-name="learn-more">hantlieding</label> te lêzen.
plugin-deprecation-description = Misse jo wat? Guon ynstekkers wurde net langer stipe troch { -brand-short-name }. <label data-l10n-name="learn-more">Mear ynfo.</label>
legacy-warning-show-legacy = Ferâldere útwreidingen toane
legacy-extensions =
    .value = Ferâldere útwreidingen
legacy-extensions-description = Dizze útwreidingen foldogge op dit stuit net oan de { -brand-short-name }-standerts binne dêrom de-aktivearre. <label data-l10n-name="legacy-learn-more">Lear mear oer de wizigingen oan add-ons</label>
private-browsing-description2 =
    { -brand-short-name } wizigt de manier wêrop útwreidingen yn priveenavigaasje wurkje. Nije útwreidingen dy't jo oan
    { -brand-short-name } tafoegje, wurkje standert net yn priveefinsters. Utsein jo dit tastean yn de ynstellingen, wurket
    de útwreiding net yn priveenavigaasje, en hat dizze dêryn gjin tagong ta jo online-aktiviteiten.
    Dizze wiziging is oanbrocht om jo priveenavigaasje privee te hâlden.
    <label data-l10n-name="private-browsing-learn-more">Mear ynfo oer it behearen fan útwreidingen-ynstellingen.</label>
addon-category-discover = Oanrekommandaasjes
addon-category-discover-title =
    .title = Oanrekommandaasjes
addon-category-extension = Utwreidingen
addon-category-extension-title =
    .title = Utwreidingen
addon-category-theme = Tema's
addon-category-theme-title =
    .title = Tema's
addon-category-plugin = Ynstekkers
addon-category-plugin-title =
    .title = Ynstekkers
addon-category-dictionary = Wurdboeken
addon-category-dictionary-title =
    .title = Wurdboeken
addon-category-locale = Talen
addon-category-locale-title =
    .title = Talen
addon-category-available-updates = Beskikbere fernijingen
addon-category-available-updates-title =
    .title = Beskikbere fernijingen
addon-category-recent-updates = Resinte fernijingen
addon-category-recent-updates-title =
    .title = Resinte fernijingen

## These are global warnings

extensions-warning-safe-mode = Alle add-ons binne útskeakele troch feilige modus.
extensions-warning-check-compatibility = Kontrole op kompatibileit foar add-ons is útskeakele. Jo kinne ynkompatibele add-ons hawwe.
extensions-warning-check-compatibility-button = Ynskeakelje
    .title = Skeakelje kontrole fan kompatibileit foar add-ons yn
extensions-warning-update-security = Feilichheidskontrole foar add-onsfernijingen is útskeakele. Jo kinne efterrinne mei fernijingen.
extensions-warning-update-security-button = Ynskeakelje
    .title = Skeakelje feilichheidskontrole foar add-onsfernijingen yn

## Strings connected to add-on updates

addon-updates-check-for-updates = Kontrolearje op fernijingen
    .accesskey = K
addon-updates-view-updates = Resinte fernijingen toane
    .accesskey = T

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Add-ons automatysk fernije
    .accesskey = a

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Stel automatysk fernije yn foar alle add-ons
    .accesskey = S
addon-updates-reset-updates-to-manual = Stel hânmjittich fernije yn foar alle add-ons
    .accesskey = S

## Status messages displayed when updating add-ons

addon-updates-updating = Add-ons oan it bywurkjen
addon-updates-installed = Jo add-ons binne bywurke.
addon-updates-none-found = Gjin fernijingen fûn
addon-updates-manual-updates-found = Beskikbere fernijingen toane

## Add-on install/debug strings for page options menu

addon-install-from-file = Ynstallearje add-on út bestân…
    .accesskey = Y
addon-install-from-file-dialog-title = Selektearje add-on om te ynstallearjen
addon-install-from-file-filter-name = Add-ons
addon-open-about-debugging = Add-ons debugge
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Utwreidingsfluchtoetsen beheare
    .accesskey = U
shortcuts-no-addons = Jo hawwe gjin útwreidingen ynskeakele.
shortcuts-no-commands = De folgjende útwreidingen hawwe gjin fluchtoetsen:
shortcuts-input =
    .placeholder = Typ in fluchtoets
shortcuts-browserAction2 = Arkbalkeknop aktivearje
shortcuts-pageAction = Side-aksje aktivearje
shortcuts-sidebarAction = De sydbalke yn-/útskeakelje
shortcuts-modifier-mac = Druk ek op Ctrl, Alt of ⌘
shortcuts-modifier-other = Druk ek op Ctrl of Alt
shortcuts-invalid = Unjildige kombinaasje
shortcuts-letter = Typ in letter
shortcuts-system = Kin gjin besteande { -brand-short-name }-fluchtoets brûke
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Dûbele fluchkeppeling
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } wurdt yn mear as ien gefal as fluchkeppeling brûkt. Dûbele fluckkeppelingen kinne unferwacht gedrach feroarsaakje.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Al yn gebrûk troch { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Noch { $numberToShow } toane
    }
shortcuts-card-collapse-button = Minder toane
header-back-button =
    .title = Tebekgean

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Utwreidingen en tema's binne as apps foar jo browser en sy litte jo wachtwurden
    beskermje, fideo’s downloade, oanbiedingen fine, ferfelende advertinsjes blokkearje, wizigje
    hoe't jo browser derút sjocht, en noch folle mear. Dizze lytse softwareprogramma's binne
    faaks ûntwikkele troch in tredde partij. Hjir is in seleksje dy't { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">oanrekommandearret</a> foar bjusterbaarlike
    befeiliging, prestaasjes en funksjonaliteit.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Inkelde fan dizze oanrekommandaasjes binne personalisearre. Se binne basearre op oare
    troch jo ynstallearre útwreidingen, profylfoarkarren en brûksstatistiken.
discopane-notice-learn-more = Mear ynfo
privacy-policy = Privacybelied
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = troch <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Brûkers: { $dailyUsers }
install-extension-button = Tafoegje oan { -brand-product-name }
install-theme-button = Tema ynstallearje
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Beheare
find-more-addons = Mear add-ons sykje
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Mear opsjes

## Add-on actions

report-addon-button = Rapportearje
remove-addon-button = Fuortsmite
# The link will always be shown after the other text.
remove-addon-disabled-button = Kin net fuortsmiten wurde <a data-l10n-name="link">Wêrom?</a>
disable-addon-button = Utskeakelje
enable-addon-button = Ynskeakelje
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Ynskeakelje
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opsjes
       *[other] Foarkarren
    }
details-addon-button = Details
release-notes-addon-button = Utjefteopmerkingen
permissions-addon-button = Tastimmingen
extension-enabled-heading = Ynskeakele
extension-disabled-heading = Utskeakele
theme-enabled-heading = Ynskeakele
theme-disabled-heading = Utskeakele
plugin-enabled-heading = Ynskeakele
plugin-disabled-heading = Utskeakele
dictionary-enabled-heading = Ynskeakele
dictionary-disabled-heading = Utskeakele
locale-enabled-heading = Ynskeakele
locale-disabled-heading = Utskeakele
ask-to-activate-button = Freegje om te aktivearjen
always-activate-button = Altyd aktivearje
never-activate-button = Nea aktivearje
addon-detail-author-label = Skriuwer
addon-detail-version-label = Ferzje
addon-detail-last-updated-label = Lêst bywurke
addon-detail-homepage-label = Startside
addon-detail-rating-label = Wurdearring
# Message for add-ons with a staged pending update.
install-postponed-message = Dizze útwreiding wurdt bywurke wannear { -brand-short-name } opnij start.
install-postponed-button = No bywurkje
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Beoardiele mei { NUMBER($rating, maximumFractionDigits: 1) } fan de 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (útskeakele)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } beoardieling
       *[other] { $numberOfReviews } beoardielingen
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> is fuortsmiten.
pending-uninstall-undo-button = Ungedien meitsje
addon-detail-updates-label = Automatyske fernijingen tastean
addon-detail-updates-radio-default = Standert
addon-detail-updates-radio-on = Oan
addon-detail-updates-radio-off = Ut
addon-detail-update-check-label = Kontrolearje op fernijingen
install-update-button = Bywurkje
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Tastien yn priveefinsters
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Wannear tastien, hat de útwreiding tagong ta jo online-aktiviteiten yn priveenavigaasje. <a data-l10n-name="learn-more">Mear ynfo</a>
addon-detail-private-browsing-allow = Tastean
addon-detail-private-browsing-disallow = Net tastean
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } rekommandearret allinnich útwreidingen oan dy't foldogge oan ús noarms foar feilichheid en prestaasjes.
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Beskikbere fernijingen
recent-updates-heading = Resinte fernijingen
release-notes-loading = Lade…
release-notes-error = Sorry, mar der wie in flater mei it laden fan de útjefteopmerkingen.
addon-permissions-empty = Foar dizze útwreiding binne gjin tastimmingen fereaske
recommended-extensions-heading = Oanrekommandearre útwreidingen
recommended-themes-heading = Oanrekommandearre tema's
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Fiele jo jo kreätyf? <a data-l10n-name="link"> Bou jo eigen tema mei Firefox Color.</a>

## Page headings

extension-heading = Jo útwreidingen beheare
theme-heading = Jo tema’s beheare
plugin-heading = Jo ynstekkers beheare
dictionary-heading = Jo wurdboeken beheare
locale-heading = Jo talen beheare
updates-heading = Jo fernijingen beheare
discover-heading = Personalisearje jo { -brand-short-name }
shortcuts-heading = Utwreidingsfluchtoetsen beheare
default-heading-search-label = Mear add-ons sykje
addons-heading-search-input =
    .placeholder = addons.mozilla.org trochsykje
addon-page-options-button =
    .title = Ark foar alle add-ons
