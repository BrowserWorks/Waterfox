# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Add-onbeheerder
search-header =
    .placeholder = addons.mozilla.org doorzoeken
    .searchbuttonlabel = Zoeken
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Download extensies en thema’s op <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = U hebt geen add-ons van dit type geïnstalleerd
list-empty-available-updates =
    .value = Geen updates gevonden
list-empty-recent-updates =
    .value = U hebt onlangs geen add-ons bijgewerkt
list-empty-find-updates =
    .label = Controleren op updates
list-empty-button =
    .label = Meer info over add-ons
help-button = Add-on-ondersteuning
sidebar-help-button-title =
    .title = Add-on-ondersteuning
addons-settings-button = { -brand-short-name }-instellingen
sidebar-settings-button-title =
    .title = { -brand-short-name }-instellingen
show-unsigned-extensions-button =
    .label = Sommige extensies konden niet worden geverifieerd
show-all-extensions-button =
    .label = Alle extensies tonen
detail-version =
    .label = Versie
detail-last-updated =
    .label = Laatst bijgewerkt
detail-contributions-description = De ontwikkelaar van deze add-on vraagt uw steun voor verdere ontwikkeling door middel van een kleine bijdrage.
detail-contributions-button = Bijdragen
    .title = Bijdragen aan de ontwikkeling van deze add-on
    .accesskey = B
detail-update-type =
    .value = Automatische updates
detail-update-default =
    .label = Standaard
    .tooltiptext = Updates alleen automatisch installeren als dat standaardinstelling is
detail-update-automatic =
    .label = Aan
    .tooltiptext = Updates automatisch installeren
detail-update-manual =
    .label = Uit
    .tooltiptext = Updates niet automatisch installeren
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Uitvoeren in privévensters
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Niet toegestaan in privévensters
detail-private-disallowed-description2 = Deze extensie wordt tijdens privénavigatie niet uitgevoerd. <a data-l10n-name="learn-more">Meer info</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Vereist toegang tot privévensters
detail-private-required-description2 = Deze extensie heeft tijdens privénavigatie toegang tot uw online-activiteiten. <a data-l10n-name="learn-more">Meer info</a>
detail-private-browsing-on =
    .label = Toestaan
    .tooltiptext = Inschakelen in privénavigatie
detail-private-browsing-off =
    .label = Niet toestaan
    .tooltiptext = Uitschakelen in privénavigatie
detail-home =
    .label = Startpagina
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Add-onprofiel
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Controleren op updates
    .accesskey = C
    .tooltiptext = Controleren op updates voor deze add-on
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opties
           *[other] Voorkeuren
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] V
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Opties van deze add-on wijzigen
           *[other] Voorkeuren van deze add-on wijzigen
        }
detail-rating =
    .value = Waardering
addon-restart-now =
    .label = Nu herstarten
disabled-unsigned-heading =
    .value = Sommige add-ons zijn uitgeschakeld
disabled-unsigned-description =
    De volgende add-ons zijn niet geverifieerd voor gebruik in { -brand-short-name }. U kunt
    <label data-l10n-name="find-addons">naar vervangingen zoeken</label> of de ontwikkelaar vragen deze te laten verifiëren.
disabled-unsigned-learn-more = Lees meer over onze pogingen om u online veilig te houden.
disabled-unsigned-devinfo =
    Ontwikkelaars die interesse hebben in het laten verifiëren van hun add-ons, kunnen verdergaan door onze
    <label data-l10n-name="learn-more">handleiding</label> te lezen.
plugin-deprecation-description = Mist u iets? Sommige plug-ins worden niet meer door { -brand-short-name } ondersteund. <label data-l10n-name="learn-more">Meer info.</label>
legacy-warning-show-legacy = Verouderde extensies tonen
legacy-extensions =
    .value = Verouderde extensies
legacy-extensions-description = Deze extensies voldoen niet aan huidige { -brand-short-name }-standaarden en zijn daarom gedeactiveerd. <label data-l10n-name="legacy-learn-more">Meer info over de wijzigingen omtrent add-ons</label>
private-browsing-description2 =
    { -brand-short-name } verandert de manier waarop extensies in privénavigatie werken. Nieuwe extensies die u aan
    { -brand-short-name } toevoegt, werken standaard niet in privévensters. Tenzij u dit toestaat in de instellingen, werkt
    de extensie niet tijdens privénavigatie, en heeft deze daarin geen toegang tot uw online-activiteiten.
    Deze wijziging is aangebracht om uw privénavigatie privé te houden.
    <label data-l10n-name="private-browsing-learn-more">Meer info over het beheren van extensie-instellingen</label>
addon-category-discover = Aanbevelingen
addon-category-discover-title =
    .title = Aanbevelingen
addon-category-extension = Extensies
addon-category-extension-title =
    .title = Extensies
addon-category-theme = Thema’s
addon-category-theme-title =
    .title = Thema’s
addon-category-plugin = Plug-ins
addon-category-plugin-title =
    .title = Plug-ins
addon-category-dictionary = Woordenboeken
addon-category-dictionary-title =
    .title = Woordenboeken
addon-category-locale = Talen
addon-category-locale-title =
    .title = Talen
addon-category-available-updates = Beschikbare updates
addon-category-available-updates-title =
    .title = Beschikbare updates
addon-category-recent-updates = Recente updates
addon-category-recent-updates-title =
    .title = Recente updates

## These are global warnings

extensions-warning-safe-mode = Alle add-ons zijn uitgeschakeld door de veilige modus.
extensions-warning-check-compatibility = Compatibiliteitscontrole voor add-ons is uitgeschakeld. Mogelijk hebt u incompatibele add-ons.
extensions-warning-check-compatibility-button = Inschakelen
    .title = Add-on-compatibiliteitscontrole inschakelen
extensions-warning-update-security = Beveiligingscontrole voor add-on-updates is uitgeschakeld. Mogelijk loopt u een beveiligingsrisico door updates.
extensions-warning-update-security-button = Inschakelen
    .title = Beveiligingscontrole voor add-on-updates inschakelen

## Strings connected to add-on updates

addon-updates-check-for-updates = Controleren op updates
    .accesskey = C
addon-updates-view-updates = Recente updates bekijken
    .accesskey = R

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Add-ons automatisch bijwerken
    .accesskey = a

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Alle add-ons terugzetten naar automatisch bijwerken
    .accesskey = t
addon-updates-reset-updates-to-manual = Alle add-ons terugzetten naar handmatig bijwerken
    .accesskey = t

## Status messages displayed when updating add-ons

addon-updates-updating = Add-ons worden bijgewerkt
addon-updates-installed = Uw add-ons zijn bijgewerkt.
addon-updates-none-found = Geen updates gevonden
addon-updates-manual-updates-found = Beschikbare updates bekijken

## Add-on install/debug strings for page options menu

addon-install-from-file = Add-on installeren via bestand…
    .accesskey = s
addon-install-from-file-dialog-title = Add-on voor installatie selecteren
addon-install-from-file-filter-name = Add-ons
addon-open-about-debugging = Add-ons debuggen
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Extensiesneltoetsen beheren
    .accesskey = E
shortcuts-no-addons = U hebt geen extensies ingeschakeld.
shortcuts-no-commands = De volgende extensies hebben geen sneltoetsen:
shortcuts-input =
    .placeholder = Typ een sneltoets
shortcuts-browserAction2 = Werkbalkknop activeren
shortcuts-pageAction = Pagina-actie activeren
shortcuts-sidebarAction = De zijbalk in-/uitschakelen
shortcuts-modifier-mac = Druk ook op Ctrl, Alt of ⌘
shortcuts-modifier-other = Druk ook op Ctrl of Alt
shortcuts-invalid = Ongeldige combinatie
shortcuts-letter = Typ een letter
shortcuts-system = Kan geen bestaande { -brand-short-name }-sneltoets gebruiken
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Dubbele snelkoppeling
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } wordt in meer dan een geval als snelkoppeling gebruikt. Dubbele snelkoppelingen kunnen onverwacht gedrag veroorzaken.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Al in gebruik door { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Nog { $numberToShow } tonen
    }
shortcuts-card-collapse-button = Minder tonen
header-back-button =
    .title = Terug

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Extensies en thema's zijn als apps voor uw browser en zij laten u wachtwoorden
    beschermen, video’s downloaden, koopjes vinden, vervelende advertenties blokkeren, wijzigen
    hoe uw browser eruit ziet, en nog veel meer. Deze kleine softwareprogramma's zijn
    vaak ontwikkeld door een derde partij. Hier is een selectie die { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">aanbeveelt</a> voor uitstekende
    beveiliging, prestaties en functionaliteit.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Enkele van deze aanbevelingen zijn gepersonaliseerd. Ze zijn gebaseerd op andere
    door u geïnstalleerde extensies, profielvoorkeuren en gebruiksstatistieken.
discopane-notice-learn-more = Meer info
privacy-policy = Privacybeleid
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = door <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Gebruikers: { $dailyUsers }
install-extension-button = Toevoegen aan { -brand-product-name }
install-theme-button = Thema installeren
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Beheren
find-more-addons = Meer add-ons zoeken
find-more-themes = Meer thema’s zoeken
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Meer opties

## Add-on actions

report-addon-button = Rapporteren
remove-addon-button = Verwijderen
# The link will always be shown after the other text.
remove-addon-disabled-button = Kan niet worden verwijderd <a data-l10n-name="link">Waarom?</a>
disable-addon-button = Uitschakelen
enable-addon-button = Inschakelen
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Inschakelen
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opties
       *[other] Voorkeuren
    }
details-addon-button = Details
release-notes-addon-button = Uitgaveopmerkingen
permissions-addon-button = Toestemmingen
extension-enabled-heading = Ingeschakeld
extension-disabled-heading = Uitgeschakeld
theme-enabled-heading = Ingeschakeld
theme-disabled-heading = Uitgeschakeld
theme-monochromatic-heading = Kleurstellingen
theme-monochromatic-subheading = Levendige nieuwe kleurstellingen van { -brand-product-name }. Beschikbaar gedurende een beperkte tijd.
plugin-enabled-heading = Ingeschakeld
plugin-disabled-heading = Uitgeschakeld
dictionary-enabled-heading = Ingeschakeld
dictionary-disabled-heading = Uitgeschakeld
locale-enabled-heading = Ingeschakeld
locale-disabled-heading = Uitgeschakeld
always-activate-button = Altijd activeren
never-activate-button = Nooit activeren
addon-detail-author-label = Schrijver
addon-detail-version-label = Versie
addon-detail-last-updated-label = Laatst bijgewerkt
addon-detail-homepage-label = Startpagina
addon-detail-rating-label = Waardering
# Message for add-ons with a staged pending update.
install-postponed-message = Deze extensie wordt bijgewerkt wanneer { -brand-short-name } herstart.
install-postponed-button = Nu bijwerken
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Beoordeeld met { NUMBER($rating, maximumFractionDigits: 1) } van de 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (uitgeschakeld)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } beoordeling
       *[other] { $numberOfReviews } beoordelingen
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> is verwijderd.
pending-uninstall-undo-button = Ongedaan maken
addon-detail-updates-label = Automatische updates toestaan
addon-detail-updates-radio-default = Standaard
addon-detail-updates-radio-on = Aan
addon-detail-updates-radio-off = Uit
addon-detail-update-check-label = Controleren op updates
install-update-button = Bijwerken
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Toegestaan in privévensters
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Wanneer toegestaan, heeft de extensie toegang tot uw online-activiteiten tijdens privénavigatie. <a data-l10n-name="learn-more">Meer info</a>
addon-detail-private-browsing-allow = Toestaan
addon-detail-private-browsing-disallow = Niet toestaan

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } beveelt alleen extensies aan die voldoen aan onze normen voor beveiliging en prestaties
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Officiële door Waterfox Waterfox gebouwde extensie. Voldoet aan beveiligings- en prestatienormen.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Deze extensie is beoordeeld en voldoet aan onze normen voor beveiliging en prestaties
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Beschikbare updates
recent-updates-heading = Recente updates
release-notes-loading = Laden…
release-notes-error = Sorry, maar er is een fout opgetreden bij het laden van de uitgaveopmerkingen.
addon-permissions-empty = Voor deze extensie zijn geen toestemmingen vereist
addon-permissions-required = Vereiste toestemmingen voor kernfunctionaliteit:
addon-permissions-optional = Optionele toestemmingen voor extra functionaliteit:
addon-permissions-learnmore = Meer info over toestemmingen
recommended-extensions-heading = Aanbevolen extensies
recommended-themes-heading = Aanbevolen thema’s
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Voelt u zich creatief? <a data-l10n-name="link"> Bouw uw eigen thema met Waterfox Color.</a>

## Page headings

extension-heading = Uw extensies beheren
theme-heading = Uw thema’s beheren
plugin-heading = Uw plug-ins beheren
dictionary-heading = Uw woordenboeken beheren
locale-heading = Uw talen beheren
updates-heading = Uw updates beheren
discover-heading = Uw { -brand-short-name } personaliseren
shortcuts-heading = Extensiesneltoetsen beheren
default-heading-search-label = Meer add-ons zoeken
addons-heading-search-input =
    .placeholder = addons.mozilla.org doorzoeken
addon-page-options-button =
    .title = Hulpmiddelen voor alle add-ons
