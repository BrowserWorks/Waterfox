# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Tilføjelser

search-header =
    .placeholder = Søg på addons.mozilla.org
    .searchbuttonlabel = Søg

search-header-shortcut =
    .key = f

list-empty-get-extensions-message = Hent udvidelser og temaer på <a data-l10n-name="get-extensions">{ $domain }</a>

list-empty-installed =
    .value = Du har ikke nogen tilføjelser af denne type installeret

list-empty-available-updates =
    .value = Ingen opdateringer fundet

list-empty-recent-updates =
    .value = Du har ikke opdateret nogen tilføjelser for nyligt

list-empty-find-updates =
    .label = Søg efter opdateringer

list-empty-button =
    .label = Lær mere om tilføjelser

help-button = Hjælp til tilføjelser
sidebar-help-button-title =
    .title = Hjælp til tilføjelser

addons-settings-button = { -brand-short-name }-indstillinger
sidebar-settings-button-title =
    .title = { -brand-short-name }-indstillinger

show-unsigned-extensions-button =
    .label = Nogle udvidelser kunne ikke bekræftes

show-all-extensions-button =
    .label = Vis alle udvidelser

detail-version =
    .label = Version

detail-last-updated =
    .label = Senest opdateret

detail-contributions-description = Udvikleren af denne tilføjelse forespøger om du vil hjælpe dens videre udvikling ved at bidrage med en lille donation.

detail-contributions-button = Bidrag
    .title = Bidrag til udviklingen af denne tilføjelse
    .accesskey = B

detail-update-type =
    .value = Automatiske opdateringer

detail-update-default =
    .label = Standard
    .tooltiptext = Installer kun opdateringer automatisk hvis det er standardindstillingen

detail-update-automatic =
    .label = Til
    .tooltiptext = Installer opdateringer automatisk

detail-update-manual =
    .label = Fra
    .tooltiptext = Installer ikke opdateringer automatisk

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Anvend i private vinduer

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Virker ikke i privat browsing
detail-private-disallowed-description2 = Denne udvidelse virker ikke under privat browsing. <a data-l10n-name="learn-more">Læs mere</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Har altid adgang til private vinduer
detail-private-required-description2 = Denne udvidelse har adgang til dine aktiviteter på nettet, når du bruger privat browsing. <a data-l10n-name="learn-more">Læs mere</a>

detail-private-browsing-on =
    .label = Tillad
    .tooltiptext = Aktivér i private vinduer

detail-private-browsing-off =
    .label = Tillad ikke
    .tooltiptext = Deaktiver i private vinduer

detail-home =
    .label = Webside

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profil af tilføjelse

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Søg efter opdateringer
    .accesskey = T
    .tooltiptext = Søg efter tilgængelige opdateringer til denne tilføjelse

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Indstillinger
           *[other] Indstillinger
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Rediger indstillinger for denne tilføjelse
           *[other] Rediger indstillinger for denne tilføjelse
        }

detail-rating =
    .value = Vurdering

addon-restart-now =
    .label = Genstart nu

disabled-unsigned-heading =
    .value = Nogle tilføjelser er blevet deaktiveret

disabled-unsigned-description =
    De følgende tilføjelser er ikke bekræftet til brug i { -brand-short-name }. Du kan 
    <label data-l10n-name="find-addons">finde alternative tilføjelser</label> eller du kan bede udvikleren om at få dem bekræftet.

disabled-unsigned-learn-more = Læs mere om vores indsats for at hjælpe dig med at være sikker på nettet.

disabled-unsigned-devinfo =
    Udviklere, som vil have deres tilføjelser bekræftet, kan starte med at læse vores 
    <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Mangler du noget? Nogle plugins er ikke længere understøttet af { -brand-short-name }. <label data-l10n-name="learn-more">Læs mere.</label>

legacy-warning-show-legacy = Vis forældede udvidelser

legacy-extensions =
    .value = Forældede udvidelser

legacy-extensions-description = Disse udvidelser møder ikke de nuværende { -brand-short-name }-standarder, så de er blevet deaktiveret. <label data-l10n-name="legacy-learn-more">Læs mere om ændringerne af tilføjelser</label>

private-browsing-description2 =
    { -brand-short-name } har ændret, hvordan udvidelser fungerer i private vinduer. Som standard vil alle nyinstallerede
    udvidelser være blokeret i privat browsing-tilstand, medmindre du giver dem tilladelse i indstillingerne.
    { -brand-short-name } blokerer udvidelserne for at sikre, at de kun med din tilladelse har adgang til din aktivitet
    på nettet, når du benytter privat browsing.
    <label data-l10n-name="private-browsing-learn-more">Læs her, hvordan du håndterer indstillingerne for udvidelser.

addon-category-discover = Anbefalinger
addon-category-discover-title =
    .title = Anbefalinger
addon-category-extension = Udvidelser
addon-category-extension-title =
    .title = Udvidelser
addon-category-theme = Temaer
addon-category-theme-title =
    .title = Temaer
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Ordbøger
addon-category-dictionary-title =
    .title = Ordbøger
addon-category-locale = Sprog
addon-category-locale-title =
    .title = Sprog
addon-category-available-updates = Tilgængelige opdateringer
addon-category-available-updates-title =
    .title = Tilgængelige opdateringer
addon-category-recent-updates = Seneste opdateringer
addon-category-recent-updates-title =
    .title = Seneste opdateringer

## These are global warnings

extensions-warning-safe-mode = Alle tilføjelser er blevet deaktiveret i fejlsikker tilstand.
extensions-warning-check-compatibility = Kompatibilitetstjek for tilføjelser er deaktiverert. Du kan have inkompatible tilføjelser.
extensions-warning-check-compatibility-button = Aktiver
    .title = Aktiver kompatibilitetstjek for tilføjelser
extensions-warning-update-security = Sikkerhedstjek ved opdatering af tilføjelser er deaktiveret. Du kan blive kompromiteret ved opdateringer.
extensions-warning-update-security-button = Aktiver
    .title = Aktiver sikkerhedstjek ved opdatering af tilføjelser


## Strings connected to add-on updates

addon-updates-check-for-updates = Søg efter opdateringer
    .accesskey = T
addon-updates-view-updates = Vis seneste opdateringer
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Opdater tilføjelser automatisk
    .accesskey = a

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Nulstil alle tilføjelser til automatisk opdatering
    .accesskey = N
addon-updates-reset-updates-to-manual = Nulstil alle tilføjelser til manuel opdatering
    .accesskey = N

## Status messages displayed when updating add-ons

addon-updates-updating = Opdaterer tilføjelser
addon-updates-installed = Dine tilføjelser er blevet opdateret.
addon-updates-none-found = Ingen opdateringer blev fundet
addon-updates-manual-updates-found = Vis tilgængelige opdateringer

## Add-on install/debug strings for page options menu

addon-install-from-file = Installer tilføjelse fra fil…
    .accesskey = I
addon-install-from-file-dialog-title = Vælg tilføjelser der skal installeres
addon-install-from-file-filter-name = Tilføjelser
addon-open-about-debugging = Debug udvidelser
    .accesskey = e

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Håndter genveje til udvidelser
    .accesskey = H

shortcuts-no-addons = Du har ikke aktiveret nogen udvidelser.
shortcuts-no-commands = Følgende udvidelser han ingen genveje:
shortcuts-input =
    .placeholder = Indtast en genvej.

shortcuts-browserAction2 = Aktiver knap på værktøjslinjen
shortcuts-pageAction = Aktiver sidehandling
shortcuts-sidebarAction = Vis/skjul sidepanelet

shortcuts-modifier-mac = Inkluder Ctrl, Alt eller ⌘
shortcuts-modifier-other = Inkluder Ctrl eller Alt
shortcuts-invalid = Ugyldig kombination
shortcuts-letter = Indtast et bogstav
shortcuts-system = Kan ikke tilsidesætte { -brand-short-name }-genvej

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Genvej findes allerede

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } bliver brugt som genvej i mere end ét tilfælde. Dette kan give anledning til uventet opførsel.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Bruges allerede af { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] vis { $numberToShow } til
    }

shortcuts-card-collapse-button = Vis færre

header-back-button =
    .title = Gå tilbage

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Udvidelser og temaer er som apps til din browser. Du kan bruge dem til at 
    beskytte dine adgangskoder, hente videoer, finde gode tilbud, blokere 
    irriterende reklamer, ændre din browsers udseende - og meget mere. 
    De små programmer er ofte lavet af eksterne udviklere. Her er et udvalg, 
    som { -brand-product-name } <a data-l10n-name="learn-more-trigger">anbefaler</a>.  
    De giver dig både bedre sikkerhed, ydelse og funktionalitet.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Nogle af disse anbefalinger er målrettet dig. De er baseret på andre 
    udvidelser, du har installeret, dine indstillinger og statistik for brug.
discopane-notice-learn-more = Læs mere

privacy-policy = Privatlivs-politik

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = af <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Brugere: { $dailyUsers }
install-extension-button = Føj til { -brand-product-name }
install-theme-button = Installer tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Håndter
find-more-addons = Find flere tilføjelser

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Flere indstillinger

## Add-on actions

report-addon-button = Rapportér
remove-addon-button = Fjern
# The link will always be shown after the other text.
remove-addon-disabled-button = Kan ikke fjernes <a data-l10n-name="link">Læs hvorfor</a>
disable-addon-button = Deaktiver
enable-addon-button = Aktiver
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktiver
preferences-addon-button =
    { PLATFORM() ->
        [windows] Indstillinger
       *[other] Indstillinger
    }
details-addon-button = Detaljer
release-notes-addon-button = Udgivelsesnoter
permissions-addon-button = Tilladelser

extension-enabled-heading = Aktiveret
extension-disabled-heading = Deaktiveret

theme-enabled-heading = Aktiveret
theme-disabled-heading = Deaktiveret

plugin-enabled-heading = Aktiveret
plugin-disabled-heading = Deaktiveret

dictionary-enabled-heading = Aktiveret
dictionary-disabled-heading = Deaktiveret

locale-enabled-heading = Aktiveret
locale-disabled-heading = Deaktiveret

always-activate-button = Aktiver altid
never-activate-button = Aktiver aldrig

addon-detail-author-label = Udvikler
addon-detail-version-label = Version
addon-detail-last-updated-label = Senest opdateret
addon-detail-homepage-label = Websted
addon-detail-rating-label = Bedømmelse

# Message for add-ons with a staged pending update.
install-postponed-message = Denne udvidelse opdateres når { -brand-short-name } genstarter.
install-postponed-button = Opdater nu

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Bedømt { NUMBER($rating, maximumFractionDigits: 1) } ud af 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (deaktiveret)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } anmeldelse
       *[other] { $numberOfReviews } anmeldelser
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> er blevet fjernet.
pending-uninstall-undo-button = Fortryd

addon-detail-updates-label = Tillad automatiske opdateringer
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = Til
addon-detail-updates-radio-off = Fra
addon-detail-update-check-label = Søg efter opdateringer
install-update-button = Opdater

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Tilladt i private vinduer
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Udvidelsen har adgang til dine aktiviteter i privat browsing-tilstand, hvis du giver den tilladelse til det. <a data-l10n-name="learn-more">Læs mere</a>
addon-detail-private-browsing-allow = Tillad
addon-detail-private-browsing-disallow = Tillad ikke

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } anbefaler kun udvidelser, der overholder vores krav til sikkerhed og ydelse.
    .aria-label = { addon-badge-recommended2.title }

# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Officiel udvidelse udviklet af Waterfox. Overholder standarder for sikkerhed og ydelse
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Denne udvidelse er blevet tjekket for, om den overholder vores standarder for sikkerhed og ydelse
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Tilgængelige opdateringer
recent-updates-heading = Seneste opdateringer

release-notes-loading = Indlæser…
release-notes-error = Der opstod en fejl under indlæsning af udgivelsesnoterne.

addon-permissions-empty = Denne udvidelse kræver ingen tilladelser

addon-permissions-required = Påkrævede tilladelser for kerne-funktionalitet:
addon-permissions-optional = Valgfrie tilladelser for yderligere funktionalitet:
addon-permissions-learnmore = Læs mere om tilladelser

recommended-extensions-heading = Anbefalede udvidelser
recommended-themes-heading = Anbefalede temaer

# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Er du i det kreative hjørne? <a data-l10n-name="link">Byg dit eget tema med Waterfox Color.</a>

## Page headings

extension-heading = Håndter dine udvidelser
theme-heading = Håndter dine temaer
plugin-heading = Håndter dine plugins
dictionary-heading = Håndter dine ordbøger
locale-heading = Håndter dine sprog
updates-heading = Håndter dine opdateringer
discover-heading = Tilpas { -brand-short-name }
shortcuts-heading = Håndter genveje til dine udvidelser

default-heading-search-label = Find flere udvidelser
addons-heading-search-input =
    .placeholder = Søg på addons.mozilla.org

addon-page-options-button =
    .title = Indstillinger for alle tilføjelser
