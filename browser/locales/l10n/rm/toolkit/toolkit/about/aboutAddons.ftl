# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Administraziun dals supplements
addons-page-title = Administraziun dals supplements

search-header =
    .placeholder = Tschertgar sin addons.mozilla.org
    .searchbuttonlabel = Tschertgar

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ti n'has anc installà nagins supplements da quest tip

list-empty-available-updates =
    .value = Chattà naginas actualisaziuns

list-empty-recent-updates =
    .value = Ti n'has actualisà nagins supplements l'ultim temp

list-empty-find-updates =
    .label = Tschertgar actualisaziuns

list-empty-button =
    .label = Emprenda dapli davart supplements

help-button = Agid cun supplements
sidebar-help-button-title =
    .title = Agid cun supplements

preferences =
    { PLATFORM() ->
        [windows] Preferenzas da { -brand-short-name }
       *[other] Preferenzas da { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Preferenzas da { -brand-short-name }
           *[other] Preferenzas da { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Impussibel da verifitgar tschertas extensiuns

show-all-extensions-button =
    .label = Mussar tut las extensiuns

cmd-show-details =
    .label = Mussar ulteriuras infurmaziuns
    .accesskey = M

cmd-find-updates =
    .label = Tschertgar actualisaziuns
    .accesskey = T

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Preferenzas
           *[other] Preferenzas
        }
    .accesskey =
        { PLATFORM() ->
            [windows] P
           *[other] P
        }

cmd-enable-theme =
    .label = Montar il design
    .accesskey = M

cmd-disable-theme =
    .label = Demontar il design
    .accesskey = D

cmd-install-addon =
    .label = Installar
    .accesskey = I

cmd-contribute =
    .label = Contribuir
    .accesskey = C
    .tooltiptext = Contribuir al svilup da quest supplement

detail-version =
    .label = Versiun

detail-last-updated =
    .label = Ultima actualisaziun

detail-contributions-description = Il sviluppader da quest supplement ta dumonda da sustegnair il svilup dal supplement cun ina pitschna contribuziun finanziala.

detail-contributions-button = Contribuir
    .title = Contribuir al svilup da quest supplement
    .accesskey = C

detail-update-type =
    .value = Actualisaziuns automaticas

detail-update-default =
    .label = Standard
    .tooltiptext = Mo installar automaticamain las actualisaziun sche quai è definì tenor standard

detail-update-automatic =
    .label = Activà
    .tooltiptext = Installar automaticamain las actualisaziuns

detail-update-manual =
    .label = Deactivà
    .tooltiptext = Betg installar automaticamain las actualisaziuns

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Exequir en fanestras privatas

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Betg permess en fanestras privatas
detail-private-disallowed-description2 = Questa extensiun na vegn betg exequida en il modus privat. <a data-l10n-name="learn-more">Ulteriuras infurmaziuns</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Basegna access a fanestras privatas
detail-private-required-description2 = Questa extensiun ha access a tias activitads online en il modus privat. <a data-l10n-name="learn-more">Ulteriuras infurmaziuns</a>

detail-private-browsing-on =
    .label = Permetter
    .tooltiptext = Activar en il modus privat

detail-private-browsing-off =
    .label = Betg permetter
    .tooltiptext = Deactivar en il modus privat

detail-home =
    .label = Website

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil dal supplement

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Tschertgar actualisaziuns
    .accesskey = T
    .tooltiptext = Tschertgar actualisaziuns da quest supplement

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Preferenzas
           *[other] Preferenzas
        }
    .accesskey =
        { PLATFORM() ->
            [windows] P
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Midar las preferenzas da quest supplement
           *[other] Midar las preferenzas da quest supplement
        }

detail-rating =
    .value = Valitaziun

addon-restart-now =
    .label = Reaviar ussa

disabled-unsigned-heading =
    .value = Tscherts supplements èn vegnids deactivads

disabled-unsigned-description = Ils suandants supplements n'èn betg verifitgads per l'utilisaziun en { -brand-short-name }. Ti pos <label data-l10n-name="find-addons">tschertgar supplements equivalents</label> u dumandar il sviluppader d'als laschar verifitgar.

disabled-unsigned-learn-more = Ve a savair tut davart nossas stentas per ta porscher la segirezza online necessaria.

disabled-unsigned-devinfo = Sviluppaders che vulan laschar verifitgar lur supplements pon cuntinuar cun leger noss <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Manca insatge? Tscherts plug-ins na vegnan betg pli sustegnids da { -brand-short-name }. <label data-l10n-name="learn-more">Ulteriuras infurmaziuns.</label>

legacy-warning-show-legacy = Mussar las extensiuns obsoletas

legacy-extensions =
    .value = Extensiuns obsoletas

legacy-extensions-description = Questas extensiuns na correspundan betg als standards actuals da { -brand-short-name } ed èn perquai deactivadas. <label data-l10n-name="legacy-learn-more">Vegnir a savair dapli davart las midadas per supplements</label>

private-browsing-description2 =
    { -brand-short-name } mida il cumportament dad extensiuns en il modus privat. Tut las novas extensiuns che ti agiunteschas a
    { -brand-short-name } na vegnan tenor la configuraziun predefinida betg exequidas en fanestras privatas. Sche ti na las permettas betg en ils parameters
    na vegnan las extensiuns betg a funcziunar en il modus privat e na vegnan er betg ad avair access a tias activitads online en lez modus. 
    Questa midada succeda per che la navigaziun en il modus privat restia privata.
    <label data-l10n-name="private-browsing-learn-more">Vegnir a savair co administrar ils parameters da las extensiuns.</label>

addon-category-discover = Recumandaziuns
addon-category-discover-title =
    .title = Recumandaziuns
addon-category-extension = Extensiuns
addon-category-extension-title =
    .title = Extensiuns
addon-category-theme = Designs
addon-category-theme-title =
    .title = Designs
addon-category-plugin = Plug-ins
addon-category-plugin-title =
    .title = Plug-ins
addon-category-dictionary = Dicziunaris
addon-category-dictionary-title =
    .title = Dicziunaris
addon-category-locale = Linguas
addon-category-locale-title =
    .title = Linguas
addon-category-available-updates = Actualisaziuns disponiblas
addon-category-available-updates-title =
    .title = Actualisaziuns disponiblas
addon-category-recent-updates = Ultimas actualisaziuns
addon-category-recent-updates-title =
    .title = Ultimas actualisaziuns

## These are global warnings

extensions-warning-safe-mode = Tut ils supplements èn vegnids deactivads dal modus segirà.
extensions-warning-check-compatibility = Il test da cumpatibilitad per supplements è deactivà. I po esser che supplements incumpatibels èn installads.
extensions-warning-check-compatibility-button = Activar
    .title = Activar il test da cumpatibilitad dals supplements
extensions-warning-update-security = Il test da segirezza per l'actualisaziun da supplements è deactivà. Eventualmain pon actualisaziuns donnegiar tes computer.
extensions-warning-update-security-button = Activar
    .title = Activar il test da segirezza per l'actualisaziun da supplements


## Strings connected to add-on updates

addon-updates-check-for-updates = Tschertgar actualisaziuns
    .accesskey = T
addon-updates-view-updates = Mussar las ultimas actualisaziuns
    .accesskey = a

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Actualisar automaticamain ils supplements
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Midar tut ils supplements sin l'actualisaziun automatica
    .accesskey = R
addon-updates-reset-updates-to-manual = Midar tut ils supplements sin l'actualisaziun manuala
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Ils supplements vegnan actualisads
addon-updates-installed = Tes supplements èn vegnids actualisads.
addon-updates-none-found = Chattà naginas actualisaziuns
addon-updates-manual-updates-found = Mussar las actualisaziuns disponiblas

## Add-on install/debug strings for page options menu

addon-install-from-file = Installar in supplement a basa dad ina datoteca…
    .accesskey = I
addon-install-from-file-dialog-title = Tscherna il supplement per l'installar
addon-install-from-file-filter-name = Supplements
addon-open-about-debugging = Debugar supplements
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Administrar scursanidas dad extensiuns
    .accesskey = s

shortcuts-no-addons = Naginas extensiuns activadas.
shortcuts-no-commands = Las suandantas extensiuns n'han naginas cumbinaziuns da tastas:
shortcuts-input =
    .placeholder = Tippa ina scursanida

shortcuts-browserAction2 = Activar il buttun da la trav d'utensils
shortcuts-pageAction = Activar l'acziun da pagina
shortcuts-sidebarAction = Activar/deactivar la trav laterala

shortcuts-modifier-mac = Includer Ctrl, Alt, u ⌘
shortcuts-modifier-other = Includer Ctrl u Alt
shortcuts-invalid = Cumbinaziun nunvalida
shortcuts-letter = Tippa ina letra
shortcuts-system = Impussibel da surscriver ina scursanida da { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Cumbinaziun da tastas occupada dublamain

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } vegn utilisà sco cumbinaziun da tastas per plirs cumonds. Cumbinaziuns da tastas duplitgadas pon chaschunar cumportaments nunprevis.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Gia utilisada da { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Mussar anc { $numberToShow }
       *[other] Mussar anc { $numberToShow }
    }

shortcuts-card-collapse-button = Mussar damain

header-back-button =
    .title = Turnar

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Extensiuns e designs èn sco apps per tes navigatur e ta laschan 
    proteger pleds-clav, telechargiar videos, chattar acziuns spezialas, bloccar
    reclamas, midar l'apparientscha da tes navigatur e bler auter. Quests pitschens
    programs vegnan savens sviluppads da terzas partidas. Qua ina selecziun da
    <a data-l10n-name="learn-more-trigger">recumandaziuns</a> da { -brand-product-name } per segirezza,
    prestaziun e funcziunalitad maximala.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Tschertas da questas recumandaziuns èn persunalisadas. Ellas sa basan sin autras extensiuns installadas, preferenzas dal profil e statisticas davart l'utilisaziun.
discopane-notice-learn-more = Ulteriuras infurmaziuns

privacy-policy = Directivas per la protecziun da datas

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = da(d) <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Utilisaders: { $dailyUsers }
install-extension-button = Agiuntar a { -brand-product-name }
install-theme-button = Installar il design
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Administrar
find-more-addons = Chattar ulteriurs supplements

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Ulteriuras opziuns

## Add-on actions

report-addon-button = Rapportar
remove-addon-button = Allontanar
# The link will always be shown after the other text.
remove-addon-disabled-button = Impussibel dad allontanar <a data-l10n-name="link">Pertge?</a>
disable-addon-button = Deactivar
enable-addon-button = Activar
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activar
preferences-addon-button =
    { PLATFORM() ->
        [windows] Preferenzas
       *[other] Preferenzas
    }
details-addon-button = Detagls
release-notes-addon-button = Remartgas davart la versiun
permissions-addon-button = Autorisaziuns

extension-enabled-heading = Activà
extension-disabled-heading = Deactivà

theme-enabled-heading = Activà
theme-disabled-heading = Deactivà

plugin-enabled-heading = Activà
plugin-disabled-heading = Deactivà

dictionary-enabled-heading = Activà
dictionary-disabled-heading = Deactivà

locale-enabled-heading = Activà
locale-disabled-heading = Deactivà

ask-to-activate-button = Dumandar per activar
always-activate-button = Adina activar
never-activate-button = Mai activar

addon-detail-author-label = Autur(a)
addon-detail-version-label = Versiun
addon-detail-last-updated-label = Ultima actualisaziun
addon-detail-homepage-label = Pagina d'internet
addon-detail-rating-label = Valitaziun

# Message for add-ons with a staged pending update.
install-postponed-message = Questa extensiun vegn actualisada cura che { -brand-short-name } vegn reavià.
install-postponed-button = Actualisar ussa

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Valità cun { NUMBER($rating, maximumFractionDigits: 1) } da 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (deactivà)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } valitaziun
       *[other] { $numberOfReviews } valitaziuns
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> è vegnì allontanà.
pending-uninstall-undo-button = Revocar

addon-detail-updates-label = Permetter actualisaziuns automaticas
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = Activà
addon-detail-updates-radio-off = Deactivà
addon-detail-update-check-label = Tschertgar actualisaziuns
install-update-button = Actualisar

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permess en fanestras privatas
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Sche permess ha questa extensiun access a tias activitads online en il modus privat. <a data-l10n-name="learn-more">Ulteriuras infurmaziuns</a>
addon-detail-private-browsing-allow = Permetter
addon-detail-private-browsing-disallow = Betg permetter

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } recumonda mo extensiuns che correspundan a noss standards da segirezza e prestaziun
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Actualisaziuns disponiblas
recent-updates-heading = Ultimas actualisaziuns

release-notes-loading = Chargiar…
release-notes-error = Perstgisa, ma cun chargiar las remartgas davart la versiun è succedida ina errur.

addon-permissions-empty = Questa extensiun na pretenda naginas autorisaziuns

recommended-extensions-heading = Extensiuns recumandadas
recommended-themes-heading = Designs recumandads

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Inspirà? <a data-l10n-name="link">Creescha tes agen design cun Firefox Color.</a>

## Page headings

extension-heading = Administrar tias extensiuns
theme-heading = Administrar tes designs
plugin-heading = Administrar tes plug-ins
dictionary-heading = Administrar tes dicziunaris
locale-heading = Administrar tias linguas
updates-heading = Administrar las actualisaziuns
discover-heading = Persunalisescha tes { -brand-short-name }
shortcuts-heading = Administrar scursanidas dad extensiuns

default-heading-search-label = Chattar ulteriurs supplements
addons-heading-search-input =
    .placeholder = Tschertgar sin addons.mozilla.org

addon-page-options-button =
    .title = Utensils per tut ils supplements
