# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Tilläggshanterare
addons-page-title = Tilläggshanterare
search-header =
    .placeholder = Sök på addons.mozilla.org
    .searchbuttonlabel = Sök
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Hämta tillägg och teman på <<a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Du har inga tillägg av den här typen installerade
list-empty-available-updates =
    .value = Inga uppdateringar hittades
list-empty-recent-updates =
    .value = Du har inte uppdaterat några tillägg nyligen
list-empty-find-updates =
    .label = Sök efter uppdateringar
list-empty-button =
    .label = Läs mer om tillägg
help-button = Support för tillägg
sidebar-help-button-title =
    .title = Support för tillägg
preferences =
    { PLATFORM() ->
        [windows] Inställningar för { -brand-short-name }
       *[other] Inställningar för { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Inställningar för { -brand-short-name }
           *[other] Inställningar för { -brand-short-name }
        }
addons-settings-button = { -brand-short-name }-inställningar
sidebar-settings-button-title =
    .title = { -brand-short-name }-inställningar
show-unsigned-extensions-button =
    .label = Vissa utökningar kunde inte verifieras
show-all-extensions-button =
    .label = Visa alla utökningar
cmd-show-details =
    .label = Visa mer information
    .accesskey = V
cmd-find-updates =
    .label = Sök efter uppdateringar
    .accesskey = S
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inställningar
           *[other] Inställningar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] n
           *[other] n
        }
cmd-enable-theme =
    .label = Använd tema
    .accesskey = ä
cmd-disable-theme =
    .label = Sluta använd tema
    .accesskey = ä
cmd-install-addon =
    .label = Installera
    .accesskey = I
cmd-contribute =
    .label = Bidra
    .accesskey = B
    .tooltiptext = Ge ett bidrag till utvecklingen av detta tillägg
detail-version =
    .label = Version
detail-last-updated =
    .label = Senast uppdaterad
detail-contributions-description = Skaparen av det här tillägget ber dig om ett litet bidrag för att stödja den fortsatta utvecklingen.
detail-contributions-button = Bidra
    .title = Bidra till utvecklingen av detta tillägg
    .accesskey = B
detail-update-type =
    .value = Automatiska uppdateringar
detail-update-default =
    .label = Standard
    .tooltiptext = Installera uppdateringar automatiskt endast om det är standard
detail-update-automatic =
    .label = På
    .tooltiptext = Installerar uppdateringar automatiskt
detail-update-manual =
    .label = Av
    .tooltiptext = Installera inte uppdateringar automatiskt
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Kör i privata fönster
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ej tillåtet i privata fönster
detail-private-disallowed-description2 = Tillägget körs inte när du surfar privat. <<a data-l10n-name="learn-more">Läs mer</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Kräver åtkomst till privata fönster
detail-private-required-description2 = Detta tillägg har tillgång till dina onlineaktiviteter när du surfar privat. <a data-l10n-name="learn-more">Läs mer</a>
detail-private-browsing-on =
    .label = Tillåt
    .tooltiptext = Aktivera i privat surfning
detail-private-browsing-off =
    .label = Tillåt inte
    .tooltiptext = Aktivera inte i privat surfning
detail-home =
    .label = Webbplats
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Tilläggets profil
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Sök efter uppdateringar
    .accesskey = ö
    .tooltiptext = Söker efter uppdateringar till tillägget
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inställningar
           *[other] Inställningar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ä
           *[other] ä
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Ändra tilläggets inställningar
           *[other] Ändra tilläggets inställningar
        }
detail-rating =
    .value = Betyg
addon-restart-now =
    .label = Starta om nu
disabled-unsigned-heading =
    .value = Vissa tillägg har inaktiverats
disabled-unsigned-description = Följande tillägg har inte verifierats för användning i { -brand-short-name }. Du kan <label data-l10n-name="find-addons">hitta ersättare</label> eller fråga utvecklaren för att få dem verifierade.
disabled-unsigned-learn-more = Läs mer om vår strävan för att hjälpa till att hålla dig säker på nätet.
disabled-unsigned-devinfo = Utvecklare som är intresserade av att få sina tillägg verifierade kan fortsätta genom att läsa vår <label data-l10n-name="learn-more">handbok</label>.
plugin-deprecation-description = Saknar du något? Vissa insticksmoduler stöds inte längre av { -brand-short-name }. <label data-l10n-name="learn-more">Läs mer.</label>
legacy-warning-show-legacy = Visa äldre tillägg
legacy-extensions =
    .value = Äldre tillägg
legacy-extensions-description = Dessa tillägg uppfyller inte nuvarande standarder i { -brand-short-name } så de har inaktiverats. <label data-l10n-name="legacy-learn-more">Läs mer om ändringar av tillägg</label>
private-browsing-description2 = { -brand-short-name } ändrar hur tillägg fungerar i privat surfläge. Alla nya tillägg du lägger till i { -brand-short-name } kommer inte att köras som standard i privata fönster. Om du inte tillåter detta i inställningarna, kommer tillägget inte fungera när du är i privat surfläge, och kommer inte ha åtkomst till dina onlineaktiviteter där. Vi har gjort denna ändring för att hålla privat surfning privat. <label data-l10n-name="private-browsing-learn-more">Läs hur du hanterar tilläggsinställningar.</label>
addon-category-discover = Rekommendationer
addon-category-discover-title =
    .title = Rekommendationer
addon-category-extension = Tillägg
addon-category-extension-title =
    .title = Tillägg
addon-category-theme = Teman
addon-category-theme-title =
    .title = Teman
addon-category-plugin = Insticksmoduler
addon-category-plugin-title =
    .title = Insticksmoduler
addon-category-dictionary = Ordlistor
addon-category-dictionary-title =
    .title = Ordlistor
addon-category-locale = Språk
addon-category-locale-title =
    .title = Språk
addon-category-available-updates = Tillgängliga uppdateringar
addon-category-available-updates-title =
    .title = Tillgängliga uppdateringar
addon-category-recent-updates = Senaste uppdateringar
addon-category-recent-updates-title =
    .title = Senaste uppdateringar

## These are global warnings

extensions-warning-safe-mode = Alla tillägg är inaktiverade i felsäkert läge.
extensions-warning-check-compatibility = Kompatibilitetskontroll av tillägg är inaktiverat. Du kan ha inkompatibla tillägg.
extensions-warning-check-compatibility-button = Aktivera
    .title = Aktiverar kompatibilitetskontroll av tillägg
extensions-warning-update-security = Säkerhetskontroll av tilläggsuppdateringar är inaktiverad. Du är sårbar för skadliga uppdateringar.
extensions-warning-update-security-button = Aktivera
    .title = Aktiverar säkerhetskontroll av tilläggsuppdateringar

## Strings connected to add-on updates

addon-updates-check-for-updates = Sök efter uppdateringar
    .accesskey = u
addon-updates-view-updates = Visa nyligen uppdaterade
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Installera uppdateringar automatiskt
    .accesskey = t

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Återställ alla tillägg till automatisk uppdatering
    .accesskey = t
addon-updates-reset-updates-to-manual = Återställ alla tillägg till manuell uppdatering
    .accesskey = t

## Status messages displayed when updating add-ons

addon-updates-updating = Uppdaterar tillägg
addon-updates-installed = Dina tillägg har uppdaterats.
addon-updates-none-found = Inga uppdateringar hittades
addon-updates-manual-updates-found = Se tillgängliga uppdateringar

## Add-on install/debug strings for page options menu

addon-install-from-file = Installera tillägg från fil…
    .accesskey = n
addon-install-from-file-dialog-title = Välj ett tillägg att installera
addon-install-from-file-filter-name = Tillägg
addon-open-about-debugging = Felsök tillägg
    .accesskey = F

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Hantera genvägar för tillägg
    .accesskey = g
shortcuts-no-addons = Du har inga tillägg aktiverade.
shortcuts-no-commands = Följande tillägg har inte genvägar:
shortcuts-input =
    .placeholder = Skapa en genväg
shortcuts-browserAction2 = Aktivera verktygsfältets knapp
shortcuts-pageAction = Aktivera sidans åtgärd
shortcuts-sidebarAction = Visa sidofält
shortcuts-modifier-mac = Inkludera Ctrl, Alt eller ⌘
shortcuts-modifier-other = Inkludera Ctrl eller Alt
shortcuts-invalid = Ogiltig kombination
shortcuts-letter = Skriv en bokstav
shortcuts-system = Kan inte skriva över en { -brand-short-name } genväg
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Dubblett av genväg
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } används som genväg i mer än ett fall. Dubbletter av genvägar kan ge oväntade effekter.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Används redan av { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Visa { $numberToShow } mer
       *[other] Visa { $numberToShow } mera
    }
shortcuts-card-collapse-button = Visa mindre
header-back-button =
    .title = Gå tillbaka

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Tillägg och teman är som appar för din webbläsare, och de låter dig
    skydda lösenord, ladda ner videor, hitta erbjudanden, blockera irriterande annonser, ändra
    hur din webbläsare ser ut, och mycket mer. Dessa små program är
    ofta utvecklad av en tredje part. Här är ett urval { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">rekommenderar</a> för exceptionell
    säkerhet, prestanda och funktionalitet.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Några av dessa rekommendationer är personliga. De är baserade på andra
    tillägg som du har installerat, profilinställningar och användarstatistik.
discopane-notice-learn-more = Lär dig mer
privacy-policy = Sekretesspolicy
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = av <a data-l10n-name="author"> { $author } </a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Användare: { $dailyUsers }
install-extension-button = Lägg till i { -brand-product-name }
install-theme-button = Installera tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Hantera
find-more-addons = Hitta fler tillägg
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Fler alternativ

## Add-on actions

report-addon-button = Rapportera
remove-addon-button = Ta bort
# The link will always be shown after the other text.
remove-addon-disabled-button = Kan inte tas bort <a data-l10n-name="link">Varför?</a>
disable-addon-button = Inaktivera
enable-addon-button = Aktivera
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktivera
preferences-addon-button =
    { PLATFORM() ->
        [windows] Inställningar
       *[other] Inställningar
    }
details-addon-button = Detaljer
release-notes-addon-button = Versionsfakta
permissions-addon-button = Behörigheter
extension-enabled-heading = Aktiverad
extension-disabled-heading = Inaktiverad
theme-enabled-heading = Aktiverad
theme-disabled-heading = Inaktiverad
plugin-enabled-heading = Aktiverad
plugin-disabled-heading = Inaktiverad
dictionary-enabled-heading = Aktiverad
dictionary-disabled-heading = Inaktiverad
locale-enabled-heading = Aktiverad
locale-disabled-heading = Inaktiverad
ask-to-activate-button = Fråga om aktivering
always-activate-button = Aktivera alltid
never-activate-button = Aktivera aldrig
addon-detail-author-label = Utvecklare
addon-detail-version-label = Version
addon-detail-last-updated-label = Senast uppdaterad
addon-detail-homepage-label = Hemsida
addon-detail-rating-label = Betyg
# Message for add-ons with a staged pending update.
install-postponed-message = Detta tillägg kommer att uppdateras när { -brand-short-name } startar om.
install-postponed-button = Uppdatera nu
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Betyg { NUMBER($rating, maximumFractionDigits: 1) } av 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (inaktiverad)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recension
       *[other] { $numberOfReviews } recensioner
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> har tagits bort.
pending-uninstall-undo-button = Ångra
addon-detail-updates-label = Tillåt automatiska uppdateringar
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = På
addon-detail-updates-radio-off = Av
addon-detail-update-check-label = Sök efter uppdateringar
install-update-button = Uppdatera
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Tillåtet i privata fönster
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = När det är tillåtet kommer tillägget att ha tillgång till dina onlineaktiviteter under privat surfning. <a data-l10n-name="learn-more">Läs mer</a>
addon-detail-private-browsing-allow = Tillåt
addon-detail-private-browsing-disallow = Tillåt inte

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } rekommenderar endast tillägg som uppfyller våra standarder för säkerhet och prestanda
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Officiellt tillägg byggt av Mozilla Firefox. Uppfyller säkerhets- och prestandastandarder
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Denna tillägg har granskats för att uppfylla våra standarder för säkerhet och prestanda
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Tillgängliga uppdateringar
recent-updates-heading = Senaste uppdateringar
release-notes-loading = Laddar…
release-notes-error = Tyvärr, men det gick inte att läsa in versionsfakta.
addon-permissions-empty = Detta tillägg kräver inga behörigheter
addon-permissions-required = Nödvändiga behörigheter för kärnfunktionalitet:
addon-permissions-optional = Valfria behörigheter för extra funktionalitet:
addon-permissions-learnmore = Läs mer om behörigheter
recommended-extensions-heading = Rekommenderade tillägg
recommended-themes-heading = Rekommenderade teman
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Känner du dig kreativ? <a data-l10n-name="link">Skapa ditt egna tema med Firefox Color.</a>

## Page headings

extension-heading = Hantera dina tillägg
theme-heading = Hantera dina teman
plugin-heading = Hantera dina insticksmoduler
dictionary-heading = Hantera dina ordlistor
locale-heading = Hantera dina språk
updates-heading = Hantera dina uppdateringar
discover-heading = Anpassa { -brand-short-name }
shortcuts-heading = Hantera genvägar för tillägg
default-heading-search-label = Hitta fler tillägg
addons-heading-search-input =
    .placeholder = Sök på addons.mozilla.org
addon-page-options-button =
    .title = Verktyg för alla tillägg
