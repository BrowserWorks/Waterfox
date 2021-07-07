# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Handter tillegg

search-header =
    .placeholder = Søk på addons.mozilla.org
    .searchbuttonlabel = Søk

search-header-shortcut =
    .key = f

list-empty-get-extensions-message = Last ned utvidingar og tema på <<a data-l10n-name="get-extensions">{ $domain }</a>

list-empty-installed =
    .value = Du har ingen tillegg av denne typen installerte

list-empty-available-updates =
    .value = Ingen oppdateringar funne

list-empty-recent-updates =
    .value = Du har ikkje nyleg oppdatert tillegga

list-empty-find-updates =
    .label = Sjå etter oppdateringar

list-empty-button =
    .label = Les meir om tillegg

help-button = Brukarstøtte for tillegg
sidebar-help-button-title =
    .title = Brukarstøtte for tillegg

addons-settings-button = { -brand-short-name }-innstillingar
sidebar-settings-button-title =
    .title = { -brand-short-name }-innstillingar

show-unsigned-extensions-button =
    .label = Nokre utvidingar kunne ikkje stadfestast

show-all-extensions-button =
    .label = Vis alle utvidingar

detail-version =
    .label = Version

detail-last-updated =
    .label = Sist oppdatert

detail-contributions-description = Utviklaren av dette tillegget ber om at du hjelper til med å støtte vidare utvikling ved å gje eit lite bidrag.

detail-contributions-button = Bidra
    .title = Bidra til utviklinga av dette tillegget
    .accesskey = B

detail-update-type =
    .value = Automatiske oppdateringar

detail-update-default =
    .label = Standard
    .tooltiptext = Installer oppdateringar automatisk berre om det er standard

detail-update-automatic =
    .label = på
    .tooltiptext = Installer oppdateringar automatisk

detail-update-manual =
    .label = Av
    .tooltiptext = Ikkje installer oppdateringar automatisk

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Køyr i privat vindauge

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ikkje tillate i private vindauge
detail-private-disallowed-description2 = Denne utvidinga køyrer ikkje medan du brukar privat nettlesing. <a data-l10n-name="learn-more">Les meir</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Krev tilgang til private vindauge
detail-private-required-description2 = Denne utvidinga har tilgang til aktivitetane dine på nettet medan du brukar privat nettlesing. <a data-l10n-name="learn-more">Les meir</a>

detail-private-browsing-on =
    .label = Tillat
    .tooltiptext = Tillat i privat nettlesing

detail-private-browsing-off =
    .label = Ikkje tillat
    .tooltiptext = Ikkje tillat i privat nettlesing

detail-home =
    .label = Heimeside

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Tilleggsprofil

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Sjå etter oppdateringar
    .accesskey = S
    .tooltiptext = Ser etter oppdateringar for dette tillegget

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Innstillingar
           *[other] Innstillingar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Endre innstillingane for dette tillegget
           *[other] Endre innstillingane for dette tillegget
        }

detail-rating =
    .value = Vurdering

addon-restart-now =
    .label = Start på nytt no

disabled-unsigned-heading =
    .value = Nokre tillegg er slått av

disabled-unsigned-description = Desse utvidingane har ikkje blitt kontrollert for bruk i { -brand-short-name }. Du kan <label data-l10n-name="find-addons">finne erstatningar</label> eller spørje utviklaren om å få dei stadfesta.

disabled-unsigned-learn-more = Les meir om tiltaka våre for å halde deg trygg på nettet.

disabled-unsigned-devinfo = Utviklarar som er interesserte i å få utvidingane sine stadfesta kan fortsetje ved å lese <label data-l10n-name="learn-more">manualen vår</label>.

plugin-deprecation-description = Saknar du noko? Nokre programtillegg er ikkje lenger støtta av { -brand-short-name }. <label data-l10n-name="learn-more">Les meir.</label>

legacy-warning-show-legacy = Vis forelda utvidingar

legacy-extensions =
    .value = Forelda utvidingar

legacy-extensions-description = Desse utvidingane oppfyller ikkje gjeldande standardar i { -brand-short-name } og er difor slått av. <label data-l10n-name="legacy-learn-more">Les meir om endringar av tillegg</label>

private-browsing-description2 =
    { -brand-short-name } endrar korleis utvidingar fungerer i privat nettlesingsmodus. Eventuelle nye utvidingar du legg til i
    { -brand-short-name } vert ikkje køyrt som standard i private vindauge, med mindre du tillèt det i innstillingane.
    Utvidinga vil ikkje fungere under privat nettlesing, og vil ikkje ha tilgang til aktivitetane dine på nettet.
    Vi har gjort denne endringa for å halde privat nettlesing privat.
    <label data-l10n-name="private-browsing-learn-more">Les om korleis du administrerer utvidingsinnstillingar.</label>

addon-category-discover = Tilrådingar
addon-category-discover-title =
    .title = Tilrådingar
addon-category-extension = Utvidingar
addon-category-extension-title =
    .title = Utvidingar
addon-category-theme = Tema
addon-category-theme-title =
    .title = Tema
addon-category-plugin = Programtillegg
addon-category-plugin-title =
    .title = Programtillegg
addon-category-dictionary = Ordbøker
addon-category-dictionary-title =
    .title = Ordbøker
addon-category-locale = Språk
addon-category-locale-title =
    .title = Språk
addon-category-available-updates = Tilgjengelege oppdateringar
addon-category-available-updates-title =
    .title = Tilgjengelege oppdateringar
addon-category-recent-updates = Nyleg oppdatert
addon-category-recent-updates-title =
    .title = Nyleg oppdatert

## These are global warnings

extensions-warning-safe-mode = Alle tillegg er avslegne av trygg-modus.
extensions-warning-check-compatibility = Kompatiblitetskonroll er avslegen. Du har kanskje ikkje-kompatible tillegg.
extensions-warning-check-compatibility-button = Slå på
    .title = Slå på kompatibilitetskontroll
extensions-warning-update-security = Tryggingskontroll av tilleggsoppdateringar er slått av. Du er sårbar for skadelege oppdateringar.
extensions-warning-update-security-button = Slå på
    .title = Slå på tryggingskontroll av tilleggsoppdateringar


## Strings connected to add-on updates

addon-updates-check-for-updates = Sjå etter oppdateringar
    .accesskey = S
addon-updates-view-updates = Vis nyleg oppdaterte
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Oppdater tillegga automatisk
    .accesskey = O

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Tilbakestill alle tillegga til å oppdatere automatisk
    .accesskey = T
addon-updates-reset-updates-to-manual = Tilbakestill alle tillegga til å oppdatere manuelt
    .accesskey = T

## Status messages displayed when updating add-ons

addon-updates-updating = Oppdaterer tillegga
addon-updates-installed = Tillegga dine er oppdaterte.
addon-updates-none-found = Fann ingen oppdateringar
addon-updates-manual-updates-found = Vis tilgjengelege oppdateringar

## Add-on install/debug strings for page options menu

addon-install-from-file = Installer tillegg frå ei fil…
    .accesskey = I
addon-install-from-file-dialog-title = Vel eit tillegg å installere å installera
addon-install-from-file-filter-name = Tillegg
addon-open-about-debugging = Feilsøk tillegg
    .accesskey = F

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Handter snarvegar for tillegg
    .accesskey = H

shortcuts-no-addons = Du har ingen utvidinga aktiverte.
shortcuts-no-commands = Følgjande utvidingar har ikkje snarvegar:
shortcuts-input =
    .placeholder = Skriv inn ein snarveg

shortcuts-browserAction2 = Aktiver verktøylinjeknapp
shortcuts-pageAction = Aktiver sidehandling
shortcuts-sidebarAction = Vis/gøym sidepanelet

shortcuts-modifier-mac = Inkluder Ctrl, Alt eller ⌘
shortcuts-modifier-other = Inkluder Ctrl eller Alt
shortcuts-invalid = Ugyldig kombinasjon
shortcuts-letter = Skriv ein bokstav
shortcuts-system = Kan ikkje overskrive ein { -brand-short-name }-snarveg

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Duplisert hurtigtast

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } blir brukt som ein hurtigtast i meir enn eitt tilfelle. Dublerte hurtigtastar kan vere årsak til uventa oppførsel.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Allereie i bruk av { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Vis { $numberToShow } fleire
    }

shortcuts-card-collapse-button = Vis mindre

header-back-button =
    .title = Gå tilbake

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Utvidingar og tema er som appar for nettlesaren din, og dei lèt deg
    beskytte passorda dine, laste ned videoar, finne tilbod, blokkere irriterande reklame, endre
    korleis nettlesaren din ser ut, og mykje meir. Desse små programma er
    ofte utvikla av ein tredjepart. Her er eit utval { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">tilrår</a> for eksepsjonell
    sikkerheit, yting og funksjonalitet.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Nokre av desse tilrådingane er målretta deg. Dei er baserte på andre
    utvidingar du har installert, profilinnstillingar og statistikk for bruk.
discopane-notice-learn-more = Les meir

privacy-policy = Personvernpraksis

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = av <a data-l10n-name="author"> { $author } </a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Brukarar: { $dailyUsers }
install-extension-button = Legg til i { -brand-product-name }
install-theme-button = Installer tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Handter
find-more-addons = Finn fleire tillegg

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Fleire innstillingar

## Add-on actions

report-addon-button = Rapporter
remove-addon-button = Fjern
# The link will always be shown after the other text.
remove-addon-disabled-button = Kan ikkje fjernast <a data-l10n-name="link">Kvifor?</a>
disable-addon-button = Slå av
enable-addon-button = Slå på
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Aktiver
preferences-addon-button =
    { PLATFORM() ->
        [windows] Innstillingar
       *[other] Innstillingar
    }
details-addon-button = Detaljar
release-notes-addon-button = Versjonsnotat
permissions-addon-button = Løyve

extension-enabled-heading = Slått på
extension-disabled-heading = Slått av

theme-enabled-heading = Slått på
theme-disabled-heading = Slått av

plugin-enabled-heading = Slått på
plugin-disabled-heading = Slått av

dictionary-enabled-heading = Slått på
dictionary-disabled-heading = Slått av

locale-enabled-heading = Slått på
locale-disabled-heading = Slått av

always-activate-button = Alttid aktiver
never-activate-button = Aldri aktiver

addon-detail-author-label = Utviklar
addon-detail-version-label = Versjon
addon-detail-last-updated-label = Sist oppdatert
addon-detail-homepage-label = Heimeside
addon-detail-rating-label = Vurdering

# Message for add-ons with a staged pending update.
install-postponed-message = Denne utvidinga vert oppdatert når { -brand-short-name } startar på nytt.
install-postponed-button = Oppdater no

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Vurdert til { NUMBER($rating, maximumFractionDigits: 1) } av 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (avslått)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } vurdering
       *[other] { $numberOfReviews } vurderingar
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> er fjerna.
pending-uninstall-undo-button = Angre

addon-detail-updates-label = Tillat automatiske oppdateringar
addon-detail-updates-radio-default = Standard
addon-detail-updates-radio-on = På
addon-detail-updates-radio-off = Av
addon-detail-update-check-label = Sjå etter oppdateringar
install-update-button = Oppdater

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Tillatt i private vindauge
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Når det er tillate, vil utvidinga få tilgang til aktivitetane dine på nettet medan du brukar privat nettlesing. <a data-l10n-name="learn-more">Les meir</a>
addon-detail-private-browsing-allow = Tillat
addon-detail-private-browsing-disallow = Ikkje tillat

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } tilrår berre utvidingar som oppfyller standardane våre for sikkerheit og yting
    .aria-label = { addon-badge-recommended2.title }

# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Offisiell utviding utvikla av Waterfox. Oppfyller sikkerheits- og ytingsstandardar.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Denne utvidinga er gjennomgått for å oppfylle standardane våre for sikkerheit og yting.
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Tilgjengelege oppdateringar
recent-updates-heading = Nylege oppdateringar

release-notes-loading = Lastar…
release-notes-error = Beklagar, men ein feil oppstod under lasting av versjonsnotatet.

addon-permissions-empty = Denne utvidinga krev inkje løyve

addon-permissions-required = Påkravde løyve for kjernefunksjonalitet:
addon-permissions-optional = Valfrie løyve for ekstra funksjonalitet:
addon-permissions-learnmore = Les meir om løyve

recommended-extensions-heading = Tilrådde utvidingar
recommended-themes-heading = Tilrådde tema

# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Er du i det kreative hjørnet? <a data-l10n-name="link">Bygg ditt eige tema med Waterfox Color.</a>

## Page headings

extension-heading = Handter utvidingane dine
theme-heading = Handter temaa dine
plugin-heading = Handter programtillegga dine
dictionary-heading = Handter ordbøkene dine
locale-heading = Handter språka dine
updates-heading = Handter oppdateringar
discover-heading = Tilpass { -brand-short-name }
shortcuts-heading = Handter snarvegar for utvidingar

default-heading-search-label = Finn fleire tillegg
addons-heading-search-input =
    .placeholder = Søk på addons.mozilla.org

addon-page-options-button =
    .title = Verktøy for alle tillegg
