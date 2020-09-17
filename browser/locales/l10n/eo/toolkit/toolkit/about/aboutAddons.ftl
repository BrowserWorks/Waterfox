# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Administrilo de aldonaĵoj
addons-page-title = Administrilo de aldonaĵoj

search-header =
    .placeholder = Serĉi en addons.mozilla.org
    .searchbuttonlabel = Serĉi

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Vi havas neniun aldonaĵon de tiu tipo instalita

list-empty-available-updates =
    .value = Neniu ĝisdatigo trovita

list-empty-recent-updates =
    .value = Vi ne ĝisdatigis viajn aldonaĵojn lastatempe

list-empty-find-updates =
    .label = Kontroli ĉu estas ĝisdatigoj

list-empty-button =
    .label = Pli da informo pri aldonaĵoj

help-button = Helpo pri aldonaĵoj
sidebar-help-button-title =
    .title = Helpo pri aldonaĵoj

preferences =
    { PLATFORM() ->
        [windows] Preferoj de { -brand-short-name }
       *[other] Preferoj de { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Preferoj de { -brand-short-name }
           *[other] Preferoj de { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Montri etendaĵojn kiuj ne povis esti kontrolitaj

show-all-extensions-button =
    .label = Montri ĉiujn etendaĵojn

cmd-show-details =
    .label = Montri pli da informo
    .accesskey = M

cmd-find-updates =
    .label = Serĉi ĝisdatigojn
    .accesskey = S

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Preferoj
           *[other] Preferoj
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Surmeti etoson
    .accesskey = E

cmd-disable-theme =
    .label = Demeti etoson
    .accesskey = E

cmd-install-addon =
    .label = Instali
    .accesskey = I

cmd-contribute =
    .label = Kontribui
    .accesskey = K
    .tooltiptext = Kontribui al la disvolvo de tiu ĉi aldonaĵo

detail-version =
    .label = Versio

detail-last-updated =
    .label = Laste modifita

detail-contributions-description = La programisto de tiu ĉi aldonaĵo petas al vi subteni la daŭran disvolvon per eta kontribuo.

detail-contributions-button = Kontribui
    .title = Kontribui al la evoluigado de tiu ĉi aldonaĵo
    .accesskey = K

detail-update-type =
    .value = Aŭtomataj ĝisdatigoj

detail-update-default =
    .label = Ĉefa
    .tooltiptext = Aŭtomate instali ĝisdatigojn nur se tiu estas la normo

detail-update-automatic =
    .label = Ŝaltita
    .tooltiptext = Aŭtomate instali ĝisdatigojn

detail-update-manual =
    .label = Malŝaltita
    .tooltiptext = Ne instali ĝisdatigojn aŭtomate

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Lanĉi en privataj fenestroj

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ne permesita en privataj fenestroj
detail-private-disallowed-description2 = Tiu ĉi etendaĵo ne funkcias dum privata retumo. <a data-l10n-name="learn-more">Pli da informo</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Ĝi postulas aliron al privataj fenestroj
detail-private-required-description2 = Tiu ĉi etendaĵo havas aliron al viaj agoj dum privata retumo. <a data-l10n-name="learn-more">Pli da informo</a>

detail-private-browsing-on =
    .label = Permesi
    .tooltiptext = Aktivigi en privata retumo

detail-private-browsing-off =
    .label = Malpermesi
    .tooltiptext = Ne aktivigi en privata retumo

detail-home =
    .label = Ĉefpaĝo

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profilo de aldonaĵo

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Kontroli ĉu estas ĝisdatigoj
    .accesskey = K
    .tooltiptext = Kontroli ĉu estas ĝisdatigoj por tiu ĉi aldonaĵo

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Preferoj
           *[other] Preferoj
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Ŝanĝi la elekteblojn de tiu ĉi aldonaĵo
           *[other] Ŝanĝi la preferojn de tiu ĉi aldonaĵo
        }

detail-rating =
    .value = Taksado

addon-restart-now =
    .label = Restartigi nun

disabled-unsigned-heading =
    .value = Kelkaj aldonaĵoj estis malaktivigitaj

disabled-unsigned-description = La jenaj aldonaĵoj ne estis kontrolitaj por uzo en { -brand-short-name }. Vi povas <label data-l10n-name="find-addons">trovi anstataŭojn</label> aŭ peti al la programisto kontroli ilin.

disabled-unsigned-learn-more = Pli da informo pri niaj penoj helpi vin plu esti sekura en la reto.

disabled-unsigned-devinfo = Programistoj, kiuj volas ke iliaj aldonaĵoj estu kontrolitaj povas komenci per legado de nia <label data-l10n-name="learn-more">manlibro</label>.

plugin-deprecation-description = Ĉu io mankas? Kelkaj kromprogramoj ne plu estas subtenataj de { -brand-short-name }. <label data-l10n-name="learn-more">Pli da informo.</label>

legacy-warning-show-legacy = Montri kadukajn etendaĵojn

legacy-extensions =
    .value = Kadukaj etendaĵoj

legacy-extensions-description = Tiuj ĉi etendaĵoj ne kongruas kun la nunaj normoj de { -brand-short-name }, tial ili estis malaktivigitaj. <label data-l10n-name="legacy-learn-more">Pli da informo pri la ŝanĝoj en aldonaĵoj</label>

private-browsing-description2 = { -brand-short-name } modifis la funkciadon de etendaĵoj en privata retumo. Norme, neniu nova etendaĵo aldonita al { -brand-short-name } funkcios en privataj fenestroj. Krom se vi permesos tion en agordoj, la etendaĵo ne funkcios en privata retumo kaj ne havos aliron al viaj agoj en la interreto. Ni ŝanĝis tion por certigi, ke via privata retumo restu privata. <label data-l10n-name="private-browsing-learn-more">Pli da informo pri administro de agordoj de etendaĵoj.</label>

addon-category-discover = Rekomendoj
addon-category-discover-title =
    .title = Rekomendoj
addon-category-extension = Etendaĵoj
addon-category-extension-title =
    .title = Etendaĵoj
addon-category-theme = Etosoj
addon-category-theme-title =
    .title = Etosoj
addon-category-plugin = Kromprogramoj
addon-category-plugin-title =
    .title = Kromprogramoj
addon-category-dictionary = Vortaroj
addon-category-dictionary-title =
    .title = Vortaroj
addon-category-locale = Lingvoj
addon-category-locale-title =
    .title = Lingvoj
addon-category-available-updates = Haveblaj ĝisdatigoj
addon-category-available-updates-title =
    .title = Haveblaj ĝisdatigoj
addon-category-recent-updates = Ĵusaj ĝisdatigoj
addon-category-recent-updates-title =
    .title = Ĵusaj ĝisdatigoj

## These are global warnings

extensions-warning-safe-mode = Ĉiuj aldonaĵoj estis malaktivigitaj de la sekura reĝimo.
extensions-warning-check-compatibility = La kontrolado de kongrueco de aldonaĵoj estas malaktiva.  Vi povus havi nekongruajn aldonaĵojn.
extensions-warning-check-compatibility-button = Aktivigi
    .title = Aktivigi la kontroladon de kongrueco de aldonaĵoj
extensions-warning-update-security = La kontrolado de sekurecaj ĝisdatigoj de aldonaĵoj ne estas aktiva.  Vi povus esti kompromitita de ĝisdatigoj.
extensions-warning-update-security-button = Aktivigi
    .title = Aktivigi la kontroladon de sekurecaj ĝisdatigoj de aldonaĵoj


## Strings connected to add-on updates

addon-updates-check-for-updates = Kontroli ĉu estas ĝisdatigoj
    .accesskey = K
addon-updates-view-updates = Vidi ĵusajn ĝisdatigojn
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Aŭtomate ĝisdatigi aldonaĵojn
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Igi ĉiujn aldonaĵojn ĝisdatiĝi aŭtomate
    .accesskey = I
addon-updates-reset-updates-to-manual = Igi ĉiujn aldonaĵojn ĝisdatiĝi malaŭtomate
    .accesskey = I

## Status messages displayed when updating add-ons

addon-updates-updating = Ĝisdatigado de aldonaĵoj
addon-updates-installed = Viaj aldonaĵoj estis ĝisdatigitaj.
addon-updates-none-found = Neniu ĝisdatigo trovita
addon-updates-manual-updates-found = Vidi haveblajn ĝisdatigojn

## Add-on install/debug strings for page options menu

addon-install-from-file = Instali aldonaĵon el dosiero…
    .accesskey = I
addon-install-from-file-dialog-title = Elekti aldonaĵon por instali
addon-install-from-file-filter-name = Aldonaĵoj
addon-open-about-debugging = Senerarigi aldonaĵojn
    .accesskey = S

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Administri alirklavojn de etendaĵoj
    .accesskey = A

shortcuts-no-addons = Vi havas neniun aktivan etendaĵon.
shortcuts-no-commands = La jenaj etendaĵoj ne havas alirklavojn:
shortcuts-input =
    .placeholder = Tajpu alirklavon

shortcuts-browserAction2 = Aktivigi ilaran butonon
shortcuts-pageAction = Aktivigi paĝan agon
shortcuts-sidebarAction = Montri/kaŝi flankan strion

shortcuts-modifier-mac = Inkluzivi Stir, Alt aŭ ⌘
shortcuts-modifier-other = Inkluzivi Stir aŭ Alt
shortcuts-invalid = Nevalida kombino
shortcuts-letter = Tajpu literon
shortcuts-system = Ne eblas anstataŭigi alirklavon de { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Ripetita alirklavo

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } estas uzata kiel alirklavon en pli ol unu okazo. Ripetitaj alirklavoj povas kaŭzi neatenditan konduton.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Jam uzata de { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Montri { $numberToShow } pli
       *[other] Montri { $numberToShow } pli
    }

shortcuts-card-collapse-button = Montri malpli

header-back-button =
    .title = Iri reen

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Etendaĵoj kaj etosoj estas kiel programoj por via retumilo, kiuj permesas al vi protekti pasvortojn, elŝuti filmetojn, serĉi ofertojn, bloki ĝenajn reklamojn, ŝanĝi la aspekton de via retumilo kaj fari multe pli da aferoj. Tiuj etaj programoj estas ofte ne programitaj de ni. Jen <a data-l10n-name="learn-more-trigger">kelkaj rekomendoj</a> de { -brand-product-name } por eksterordinaraj sekureco, efikeco kaj funkcioj.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Kelkaj el tiuj ĉi rekomendoj estas personecigitaj. Ili baziĝas sur la listo de viaj nunaj etendaĵoj, preferoj de profilo kaj statistikoj de uzo.
discopane-notice-learn-more = Pli da informo

privacy-policy = Politiko pri privateco

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = de <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Uzantoj: { $dailyUsers }
install-extension-button = Aldoni al { -brand-product-name }
install-theme-button = Instali etoson
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Administri
find-more-addons = Serĉi pli da aldonaĵoj

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Pli da ebloj

## Add-on actions

report-addon-button = Denunci
remove-addon-button = Forigi
# The link will always be shown after the other text.
remove-addon-disabled-button = Ne eblas forigi ĝin. <a data-l10n-name="link">Kial?</a>
disable-addon-button = Malaktivigi
enable-addon-button = Aktivigi
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktivigi
preferences-addon-button =
    { PLATFORM() ->
        [windows] Preferoj
       *[other] Preferoj
    }
details-addon-button = Detaloj
release-notes-addon-button = Notoj pri liverado
permissions-addon-button = Permesoj

extension-enabled-heading = Aktiva
extension-disabled-heading = Malaktiva

theme-enabled-heading = Aktiva
theme-disabled-heading = Malaktiva

plugin-enabled-heading = Aktiva
plugin-disabled-heading = Malaktiva

dictionary-enabled-heading = Aktiva
dictionary-disabled-heading = Malaktiva

locale-enabled-heading = Aktiva
locale-disabled-heading = Malaktiva

ask-to-activate-button = Demandi antaŭ ol aktivigi
always-activate-button = Ĉiam aktivigi
never-activate-button = Neniam aktivigi

addon-detail-author-label = Aŭtoro
addon-detail-version-label = Versio
addon-detail-last-updated-label = Laste ĝisdatigita
addon-detail-homepage-label = Ĉefpaĝo
addon-detail-rating-label = Taksado

# Message for add-ons with a staged pending update.
install-postponed-message = Tiu ĉi etendaĵo estos ĝisdatigita dum restarto de { -brand-short-name }.
install-postponed-button = Ĝisdatigi nun

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Taksado { NUMBER($rating, maximumFractionDigits: 1) } el 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (malaktiva)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } revizio
       *[other] { $numberOfReviews } revizioj
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> estis forigita.
pending-uninstall-undo-button = Malfari

addon-detail-updates-label = Permesi aŭtomatajn ĝisdatigojn
addon-detail-updates-radio-default = Norma
addon-detail-updates-radio-on = Ŝaltita
addon-detail-updates-radio-off = Malŝaltita
addon-detail-update-check-label = Kontroli ĉu estas ĝisdatigoj
install-update-button = Ĝisdatigi

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permesita en privataj fenestroj
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Se tio estas permesita, la etendaĵo havos aliron al viaj retumaj agoj dum vi private retumas. <a data-l10n-name="learn-more">Pli da informo</a>
addon-detail-private-browsing-allow = Permesi
addon-detail-private-browsing-disallow = Ne permesi

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } nur rekomendas etendaĵojn, kiuj konformas al niaj normoj pri sekureco kaj efikeco
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Haveblaj ĝisdatigoj
recent-updates-heading = Ĵusaj ĝisdatigoj

release-notes-loading = Ŝargado…
release-notes-error = Bedaŭrinde okazis eraro dum la ŝargado de la notoj pri liverado.

addon-permissions-empty = Tiu ĉi etendaĵo postulas neniun permeson

recommended-extensions-heading = Rekomenditaj etendaĵoj
recommended-themes-heading = Rekomenditaj etosoj

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Ĉu vi kreemas? <a data-l10n-name="link">Kreu vian propran etoson per Firefox Color.</a>

## Page headings

extension-heading = Administri viajn etendaĵojn
theme-heading = Administri viajn etosojn
plugin-heading = Administri viajn kromprogramojn
dictionary-heading = Administri viajn vortarojn
locale-heading = Administri lingvojn
updates-heading = Administri viajn ĝisdatigojn
discover-heading = Personecigu vian { -brand-short-name }
shortcuts-heading = Administri alirklavojn de etendaĵoj

default-heading-search-label = Serĉi pli da aldonaĵoj
addons-heading-search-input =
    .placeholder = Serĉi en addons.mozilla.org

addon-page-options-button =
    .title = Iloj por ĉiuj aldonaĵoj
