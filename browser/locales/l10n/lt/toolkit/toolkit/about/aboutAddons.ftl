# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Priedų tvarkytuvė
addons-page-title = Priedų tvarkytuvė
search-header =
    .placeholder = Ieškoti per addons.mozilla.org
    .searchbuttonlabel = Paieška
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Gaukite priedų ir grafinių apvalkalų iš <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Nėra įdiegtų šio tipo priedų
list-empty-available-updates =
    .value = Naujinimų nerasta
list-empty-recent-updates =
    .value = Pastaruoju metu nesate atnaujinę jokių priedų
list-empty-find-updates =
    .label = Tikrinti, ar yra naujinimų
list-empty-button =
    .label = Sužinokite apie priedus daugiau
help-button = Priedų pagalba
sidebar-help-button-title =
    .title = Priedų pagalba
preferences =
    { PLATFORM() ->
        [windows] „{ -brand-short-name }“ nuostatos
       *[other] „{ -brand-short-name }“ nuostatos
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] „{ -brand-short-name }“ nuostatos
           *[other] „{ -brand-short-name }“ nuostatos
        }
addons-settings-button = „{ -brand-short-name }“ nuostatos
sidebar-settings-button-title =
    .title = „{ -brand-short-name }“ nuostatos
show-unsigned-extensions-button =
    .label = Kai kurių plėtinių patikrinti nepavyko
show-all-extensions-button =
    .label = Rodyti visus plėtinius
cmd-show-details =
    .label = Išsamiau
    .accesskey = I
cmd-find-updates =
    .label = Rasti naujinimų
    .accesskey = R
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nuostatos
           *[other] Nuostatos
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }
cmd-enable-theme =
    .label = Naudoti apvalkalą
    .accesskey = N
cmd-disable-theme =
    .label = Nebenaudoti apvalkalo
    .accesskey = N
cmd-install-addon =
    .label = Įdiegti
    .accesskey = d
cmd-contribute =
    .label = Paremti
    .accesskey = P
    .tooltiptext = Paremti šio priedo kūrimą
detail-version =
    .label = Laida
detail-last-updated =
    .label = Paskiausiai atnaujintas
detail-contributions-description = Šio priedo autorius prašo paremti tolesnį jo kūrimą nedideliu finansiniu įnašu.
detail-contributions-button = Prisidėkite
    .title = Prisidėkite prie šio priedo plėtojimo
    .accesskey = P
detail-update-type =
    .value = Naujinti automatiškai
detail-update-default =
    .label = Kaip numatyta
    .tooltiptext = Automatiškai naujinti šį priedą, jeigu taip numatyta
detail-update-automatic =
    .label = Taip
    .tooltiptext = Automatiškai naujinti šį priedą, kai jam randama naujinimų
detail-update-manual =
    .label = Ne
    .tooltiptext = Nediegti priedo naujinimų automatiškai
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Leisti privačiojo naršymo languose
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Neleidžiama privačiojo naršymo languose
detail-private-disallowed-description2 = Šis priedas neveikia privačiojo naršymo languose. <a data-l10n-name="learn-more">Sužinoti daugiau</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Reikalinga prieiga prie privačiojo naršymo langų
detail-private-required-description2 = Šis priedas turi priėjimą prie jūsų veiklos naršant privačiai. <a data-l10n-name="learn-more">Sužinoti daugiau</a>
detail-private-browsing-on =
    .label = Leisti
    .tooltiptext = Įjungti privačiajame naršyme
detail-private-browsing-off =
    .label = Neleisti
    .tooltiptext = Išjungti privačiajame naršyme
detail-home =
    .label = Svetainė
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Priedo profilis
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Ieškoti naujinimų
    .accesskey = I
    .tooltiptext = Ieškoti šio priedo naujinimų
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Nuostatos
           *[other] Nuostatos
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Keisti šio priedo parinktis
           *[other] Keisti šio priedo nuostatas
        }
detail-rating =
    .value = Įvertinimas
addon-restart-now =
    .label = Perleisti dabar
disabled-unsigned-heading =
    .value = Kai kurie priedai buvo išjungti
disabled-unsigned-description = Šių priedų nepavyko patikrinti kaip tinkamų „{ -brand-short-name }“. Jūs galite <label data-l10n-name="find-addons">ieškokite atitikmenų</label> arba paprašykite kūrėjo atlikti jų patikrinimą.
disabled-unsigned-learn-more = Sužinokite daugiau apie mūsų pastangas siekiant apsaugoti jus naršant.
disabled-unsigned-devinfo = Programuotojai, norintys atlikti savo priedų patikrinimą, gali tęsti perskaitydami mūsų <label data-l10n-name="learn-more">vadovą</label>.
plugin-deprecation-description = Kažko trūksta? Kai kurie papildiniai daugiau nepalaikomi „{ -brand-short-name }“. <label data-l10n-name="learn-more">Sužinoti daugiau.</label>
legacy-warning-show-legacy = Rodyti pasenusius plėtinius
legacy-extensions =
    .value = Pasenę plėtiniai
legacy-extensions-description = Šie plėtiniai neatitinka esamų „{ -brand-short-name }“ standartų, tad buvo išjungti. <label data-l10n-name="legacy-learn-more">Sužinokite apie priedų pokyčius</label>
private-browsing-description2 =
    „{ -brand-short-name }“ keičia priedų veikimą privačiojo naršymo languose. Visi nauji priedai, kuriuos pridėsite į
    „{ -brand-short-name }“, neveiks privačiojo naršymo languose. Nebent leisite tai per nuostatas, priedas
    neveiks naršant privačiai, ir neturės prieigos prie tokios jūsų veiklos. Šį pakeitimą atlikome
    norėdami išlaikyti jūsų privatųjį naršymą privačiu.
    <label data-l10n-name="private-browsing-learn-more">Sužinokite, kaip tvarkyti priedų nuostatas.</label>
addon-category-discover = Rekomendacijos
addon-category-discover-title =
    .title = Rekomendacijos
addon-category-extension = Plėtiniai
addon-category-extension-title =
    .title = Plėtiniai
addon-category-theme = Grafiniai apvalkalai
addon-category-theme-title =
    .title = Grafiniai apvalkalai
addon-category-plugin = Papildiniai
addon-category-plugin-title =
    .title = Papildiniai
addon-category-dictionary = Žodynai
addon-category-dictionary-title =
    .title = Žodynai
addon-category-locale = Kalbos
addon-category-locale-title =
    .title = Kalbos
addon-category-available-updates = Galimi naujinimai
addon-category-available-updates-title =
    .title = Galimi naujinimai
addon-category-recent-updates = Paskiausiai atnaujinti
addon-category-recent-updates-title =
    .title = Paskiausiai atnaujinti

## These are global warnings

extensions-warning-safe-mode = Ribotojoje veiksenoje visi priedai išjungti.
extensions-warning-check-compatibility = Priedų suderinamumas netikrinamas. Gali būti, kad turite nesuderinamų priedų.
extensions-warning-check-compatibility-button = Tikrinti
    .title = Įjungti priedų suderinamumo tikrinimą
extensions-warning-update-security = Priedų naujinimų saugumas netikrinamas. Priedų naujinimai gali pakenkti jūsų saugumui.
extensions-warning-update-security-button = Tikrinti
    .title = Įjungti priedų naujinimų saugumo tikrinimą

## Strings connected to add-on updates

addon-updates-check-for-updates = Tikrinti, ar yra naujinimų
    .accesskey = T
addon-updates-view-updates = Rodyti paskiausiai atnaujintus priedus
    .accesskey = p

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Naujinti priedus automatiškai
    .accesskey = N

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Visus priedus naujinti automatiškai
    .accesskey = V
addon-updates-reset-updates-to-manual = Visus priedus naujinti rankiniu būdu
    .accesskey = V

## Status messages displayed when updating add-ons

addon-updates-updating = Priedai naujinami
addon-updates-installed = Turimi priedai atnaujinti.
addon-updates-none-found = Naujinimų nerasta
addon-updates-manual-updates-found = Rodyti galimus atnaujinti priedus

## Add-on install/debug strings for page options menu

addon-install-from-file = Įdiegti priedą iš failo…
    .accesskey = d
addon-install-from-file-dialog-title = Parinkite norimą įdiegti priedą
addon-install-from-file-filter-name = Add-ons
addon-open-about-debugging = Derinti priedus
    .accesskey = r

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Tvarkyti sparčiuosius klavišus priedams
    .accesskey = s
shortcuts-no-addons = Neturite jokių įjungtų priedų.
shortcuts-no-commands = Šie priedai neturi sparčiųjų klavišų komandų:
shortcuts-input =
    .placeholder = Surinkite klavišų kombinaciją
shortcuts-browserAction2 = Aktyvuoti priemonių juostos mygtuką
shortcuts-pageAction = Įjungti veiksmą tinklalapyje
shortcuts-sidebarAction = Rodyti / slėpti šoninį polangį
shortcuts-modifier-mac = Įtraukti Ctrl, Alt arba ⌘
shortcuts-modifier-other = Įtraukti Ctrl arba Alt
shortcuts-invalid = Netinkama kombinacija
shortcuts-letter = Surinkite raidę
shortcuts-system = Negalima naudoti „{ -brand-short-name }“ sparčiųjų klavišų
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Pasikartojantis spartusis klavišas
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } jau naudojamas kaip spartusis klavišas. Pasikartojantys spartieji klavišai gali sukelti nepageidaujamų pasekmių.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Jau naudoja priedas „{ $addon }“
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Rodyti dar { $numberToShow }
        [few] Rodyti dar { $numberToShow }
       *[other] Rodyti dar { $numberToShow }
    }
shortcuts-card-collapse-button = Rodyti mažiau
header-back-button =
    .title = Eiti atgal

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Priedai ir grafiniai apvalkalai yra tarsi programos jūsų naršyklei, ir jie leidžia
    jums apsaugoti slaptažodžius, siųstis vaizdo įrašus, rasti akcijas, blokuoti
    erzinančias reklamas, keisti naršyklės išvaizdą, ir dar daugiau. Šias nedideles
    programas dažniausiai kuria trečiosios šalys. Čia pateikiame rinkinį, kurį
    „{ -brand-product-name }“ <a data-l10n-name="learn-more-trigger">rekomenduoja</a>
    išskirtiniam saugumui, našumui ir funkcionalumui.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Kai kurios iš šių rekomendacijų yra pritaikytos būtent jums. Yra atsižvelgiama į kitus
    jūsų įdiegtus priedus, profilio pasirinkimus, ir naudojimo statistikas.
discopane-notice-learn-more = Sužinoti daugiau
privacy-policy = Privatumo nuostatai
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = sukūrė <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Naudotojų: { $dailyUsers }
install-extension-button = Pridėti į „{ -brand-product-name }“
install-theme-button = Įdiegti grafinį apvalkalą
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Tvarkyti
find-more-addons = Rasti daugiau priedų
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Daugiau veiksmų

## Add-on actions

report-addon-button = Pranešti
remove-addon-button = Pašalinti
# The link will always be shown after the other text.
remove-addon-disabled-button = Negalima pašalinti. <a data-l10n-name="link">Kodėl?</a>
disable-addon-button = Išjungti
enable-addon-button = Įjungti
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Įjungti
preferences-addon-button =
    { PLATFORM() ->
        [windows] Nuostatos
       *[other] Nuostatos
    }
details-addon-button = Išsamiau
release-notes-addon-button = Laidos apžvalga
permissions-addon-button = Leidimai
extension-enabled-heading = Įjungtas
extension-disabled-heading = Išjungtas
theme-enabled-heading = Įjungtas
theme-disabled-heading = Išjungtas
plugin-enabled-heading = Įjungtas
plugin-disabled-heading = Išjungtas
dictionary-enabled-heading = Įjungtas
dictionary-disabled-heading = Išjungtas
locale-enabled-heading = Įjungta
locale-disabled-heading = Išjungta
ask-to-activate-button = Klausti prieš aktyvinant
always-activate-button = Visada aktyvinti
never-activate-button = Niekada neaktyvinti
addon-detail-author-label = Autorius
addon-detail-version-label = Laida
addon-detail-last-updated-label = Paskiausiai atnaujintas
addon-detail-homepage-label = Svetainė
addon-detail-rating-label = Įvertinimas
# Message for add-ons with a staged pending update.
install-postponed-message = Šis priedas atsinaujins, kai „{ -brand-short-name }“ bus paleista iš naujo.
install-postponed-button = Atnaujinti dabar
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Įvertinta { NUMBER($rating, maximumFractionDigits: 1) } iš 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (išjungtas)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } atsiliepimas
        [few] { $numberOfReviews } atsiliepimai
       *[other] { $numberOfReviews } atsiliepimų
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">„{ $addon }“</span> buvo pašalintas.
pending-uninstall-undo-button = Atšaukti
addon-detail-updates-label = Leisti automatinius naujinimus
addon-detail-updates-radio-default = Numatytasis
addon-detail-updates-radio-on = Taip
addon-detail-updates-radio-off = Ne
addon-detail-update-check-label = Tikrinti, ar yra naujinimų
install-update-button = Atnaujinti
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Leidžiama privačiojo naršymo languose
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Leidus, priedas turės priėjimą prie jūsų veiklos internete naršant privačiai. <a data-l10n-name="learn-more">Sužinokite daugiau</a>
addon-detail-private-browsing-allow = Leisti
addon-detail-private-browsing-disallow = Neleisti

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = „{ -brand-product-name }“ rekomenduoja tik mūsų saugumo ir našumo reikalavimus atitinkančius priedus
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Oficialus „Mozilla“ sukurtas priedas. Atitinka saugumo ir našumo standartus
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Šis priedas buvo peržiūrėtas ir atitinka mūsų saugumo bei našumo standartus
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Galimi naujinimai
recent-updates-heading = Paskiausiai atnaujinti
release-notes-loading = Įkeliama…
release-notes-error = Atsiprašome, bet įkeliant laidos apžvalgą įvyko klaida.
addon-permissions-empty = Šis priedas nereikalauja jokių leidimų
addon-permissions-required = Pagrindiniam funkcionalumui reikalingi leidimai:
addon-permissions-optional = Papildomam funkcionalumui reikalingi leidimai:
addon-permissions-learnmore = Sužinokite apie leidimus daugiau
recommended-extensions-heading = Rekomenduojami priedai
recommended-themes-heading = Rekomenduojami grafiniai apvalkalai
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Jaučiatės kūrybiškai? <a data-l10n-name="link">Sukurkite savo grafinį apvalkalą su „Firefox Color“.</a>

## Page headings

extension-heading = Tvarkykite savo priedus
theme-heading = Tvarkykite savo apvalkalus
plugin-heading = Tvarkykite savo papildinius
dictionary-heading = Tvarkykite savo žodynus
locale-heading = Tvarkykite savo kalbas
updates-heading = Tvarkykite savo naujinimus
discover-heading = Individualizuokite savo „{ -brand-short-name }“
shortcuts-heading = Tvarkyti sparčiuosius klavišus priedams
default-heading-search-label = Rasti daugiau priedų
addons-heading-search-input =
    .placeholder = Ieškoti per addons.mozilla.org
addon-page-options-button =
    .title = Visiems priedams taikomos priemonės
