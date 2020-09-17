# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gehigarrien kudeatzailea

addons-page-title = Gehigarrien kudeatzailea

search-header =
    .placeholder = Bilatu addons.mozilla.org gunean
    .searchbuttonlabel = Bilaketa

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ez daukazu mota honetako gehigarririk instalatuta

list-empty-available-updates =
    .value = Ez da eguneraketarik aurkitu

list-empty-recent-updates =
    .value = Azkenaldian ez duzu gehigarririk eguneratu

list-empty-find-updates =
    .label = Bilatu eguneraketak

list-empty-button =
    .label = Gehigarriei buruzko argibide gehiago

help-button = Gehigarrien laguntza

sidebar-help-button-title =
    .title = Gehigarrien laguntza

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } aukerak
       *[other] { -brand-short-name } hobespenak
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } aukerak
           *[other] { -brand-short-name } hobespenak
        }

show-unsigned-extensions-button =
    .label = Zenbait gehigarri ezin izan dira egiaztatu

show-all-extensions-button =
    .label = Erakutsi gehigarri guztiak

cmd-show-details =
    .label = Erakutsi informazio gehiago
    .accesskey = E

cmd-find-updates =
    .label = Bilatu eguneraketak
    .accesskey = B

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Aukerak
           *[other] Hobespenak
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] H
        }

cmd-enable-theme =
    .label = Jantzi itxura
    .accesskey = J

cmd-disable-theme =
    .label = Erantzi itxura
    .accesskey = E

cmd-install-addon =
    .label = Instalatu
    .accesskey = I

cmd-contribute =
    .label = Lagundu
    .accesskey = L
    .tooltiptext = Lagundu gehigarri honen garapenean

detail-version =
    .label = Bertsioa

detail-last-updated =
    .label = Azken eguneraketa

detail-contributions-description = Ekarpen txiki bat eginda garapenerako laguntza eskatzen dizu gehigarri honen garatzaileak.

detail-contributions-button = Lagundu
    .title = Lagundu gehigarri honen garapenean
    .accesskey = L

detail-update-type =
    .value = Eguneraketa automatikoak

detail-update-default =
    .label = Lehenetsia
    .tooltiptext = Instalatu eguneraketak automatikoki lehenetsia bada soilik

detail-update-automatic =
    .label = Aktibatuta
    .tooltiptext = Instalatu eguneraketak automatikoki

detail-update-manual =
    .label = Desaktibatuta
    .tooltiptext = Ez instalatu eguneraketak automatikoki

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Exekutatu leiho pribatuetan

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Ez da leiho pribatuetan onartzen

detail-private-disallowed-description2 = Hedapen hau ez dabil nabigatze pribatuan. <a data-l10n-name="learn-more">Argibide gehiago</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Leiho pribatuetarako sarbidea behar du

detail-private-required-description2 = Hedapen honek zure online jardueretarako sarbidea du nabigatze pribatuan. <a data-l10n-name="learn-more">Argibide gehiago</a>

detail-private-browsing-on =
    .label = Baimendu
    .tooltiptext = Gaitu nabigatze pribatuan

detail-private-browsing-off =
    .label = Ez baimendu
    .tooltiptext = Desgaitu nabigatze pribatuan

detail-home =
    .label = Webgunea

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Gehigarriaren profila

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Bilatu eguneraketak
    .accesskey = B
    .tooltiptext = Bilatu gehigarri honen eguneraketak

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Aukerak
           *[other] Hobespenak
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] H
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Aldatu gehigarri honen aukerak
           *[other] Aldatu gehigarri honen hobespenak
        }

detail-rating =
    .value = Puntuazioa

addon-restart-now =
    .label = Berrabiarazi orain

disabled-unsigned-heading =
    .value = Zenbait gehigarri desgaitu egin dira

disabled-unsigned-description = Ondorengo gehigarriak ez dira egiaztatu { -brand-short-name }(r)ekin erabilgarriak diren. <label data-l10n-name="find-addons">Ordezko gehigarriak bilatu</label> edo garatzaileari egiaztapena burutzeko eska diezaiokezu.

disabled-unsigned-learn-more = Zure lineako jarduera seguru mantentzeko gure esfortzuei buruzko argibide gehiago.

disabled-unsigned-devinfo = Gehigarriak egiaztatu nahi dituzten garatzaileek gure <label data-l10n-name="learn-more">eskuliburua</label> irakurtzen jarrai dezakete.

plugin-deprecation-description = Zerbait falta da? { -brand-short-name }(e)k ez ditu dagoeneko zenbait plugin onartzen. <label data-l10n-name="learn-more">Argibide gehiago.</label>

legacy-warning-show-legacy = Erakutsi legatu-hedapenak

legacy-extensions =
    .value = Legatu-hedapenak

legacy-extensions-description = Hedapen hauek ez dira { -brand-short-name }(r)en gutxieneko kalitatera heltzen eta desaktibatu egin dira. <label data-l10n-name="legacy-learn-more">Gehigarrien aldaketei buruzko argibide gehiago</label>

private-browsing-description2 = { -brand-short-name } aldatzen ari da hedapenak nola dabiltzan nabigatze pribatuan. { -brand-short-name }(e)ra gehitutako hedapen berriak lehenespenez ez dira leiho pribatuetan ibiliko. Ezarpenetan baimendu ezean, hedapena ez da ibiliko modu pribatuan nabigatu ahala eta bertan ez du zure lineako jardueretarako sarbiderik izango. Zure nabigatze pribatua benetan pribatu mantentzeko egin dugu aldaketa hau. <label data-l10n-name="private-browsing-learn-more">Hedapenen ezarpenak kudeatzeko argibide gehiago.</label>

addon-category-discover = Gomendioak
addon-category-discover-title =
    .title = Gomendioak
addon-category-extension = Hedapenak
addon-category-extension-title =
    .title = Hedapenak
addon-category-theme = Itxurak
addon-category-theme-title =
    .title = Itxurak
addon-category-plugin = Pluginak
addon-category-plugin-title =
    .title = Pluginak
addon-category-dictionary = Hiztegiak
addon-category-dictionary-title =
    .title = Hiztegiak
addon-category-locale = Hizkuntzak
addon-category-locale-title =
    .title = Hizkuntzak
addon-category-available-updates = Eguneraketak eskura
addon-category-available-updates-title =
    .title = Eguneraketak eskura
addon-category-recent-updates = Azken eguneraketak
addon-category-recent-updates-title =
    .title = Azken eguneraketak

## These are global warnings

extensions-warning-safe-mode = Modu seguruak gehigarri guztiak desgaitu ditu.
extensions-warning-check-compatibility = Gehigarrien bateragarritasuna egiaztatzea desgaituta dago. Gehigarri bateraezinak izan ditzakezu.
extensions-warning-check-compatibility-button = Gaitu
    .title = Gaitu gehigarrien bateragarritasuna egiaztatzea
extensions-warning-update-security = Gehigarrien eguneraketa-segurtasuna egiaztatzea desgaituta dago. Eguneraketek arriskuan jar zaitzakete.
extensions-warning-update-security-button = Gaitu
    .title = Gaitu gehigarrien eguneraketa-segurtasuna egiaztatzea


## Strings connected to add-on updates

addon-updates-check-for-updates = Bilatu eguneraketak
    .accesskey = B
addon-updates-view-updates = Ikusi azken eguneraketak
    .accesskey = I

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Eguneratu gehigarriak automatikoki
    .accesskey = g

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Berrezarri gehigarri guztiak automatikoki egunera daitezen
    .accesskey = B
addon-updates-reset-updates-to-manual = Berrezarri gehigarri guztiak eskuz egunera daitezen
    .accesskey = B

## Status messages displayed when updating add-ons

addon-updates-updating = Gehigarriak eguneratzen
addon-updates-installed = Gehigarriak eguneratu egin dira.
addon-updates-none-found = Ez da eguneraketarik aurkitu
addon-updates-manual-updates-found = Ikusi eskura dauden eguneraketak

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalatu gehigarria fitxategitik…
    .accesskey = I
addon-install-from-file-dialog-title = Hautatu instalatzeko gehigarria
addon-install-from-file-filter-name = Gehigarriak
addon-open-about-debugging = Araztu gehigarriak
    .accesskey = z

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Kudeatu hedapenen lasterbideak
    .accesskey = K

shortcuts-no-addons = Ez daukazu hedapenik gaituta.
shortcuts-no-commands = Ondorengo hedapenek ez dute lasterbiderik:
shortcuts-input =
    .placeholder = Idatzi lasterbidea

shortcuts-browserAction2 = Aktibatu tresna-barrako botoia
shortcuts-pageAction = Gaitu orri-ekintza
shortcuts-sidebarAction = Txandakatu alboko barra

shortcuts-modifier-mac = Kontuan hartu Ktrl, Alt edo ⌘
shortcuts-modifier-other = Kontuan hartu Ktrl edo Alt
shortcuts-invalid = Konbinazio baliogabea
shortcuts-letter = Idatzi letra bat
shortcuts-system = Ezin da { -brand-short-name }(r)en lasterbidea gainidatzi

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Bikoiztutako lasterbidea

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } behin baino gehiagotan ari da erabiltzen lasterbide gisa. Bikoiztutako lasterbideek espero gabeko portaera eragin lezakete.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Dagoeneko honek erabilia: { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Erakutsi bat gehiago
       *[other] Erakutsi { $numberToShow } gehiago
    }

shortcuts-card-collapse-button = Erakutsi gutxiago

header-back-button =
    .title = Joan atzera

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Aplikazioen antzerako zerak dira hedapenak eta itxurak eta besteak beste ahalbidetzen dute pasahitzak babestea, bideoak deskargatzea, eskaintzak aurkitzea, publizitatea blokeatzea edo nabigatzailearen itxura aldatzea. Software programa txiki hauek hirugarrenek garatuak izan ohi dira. Aparteko segurtasun, errendimendu eta eginbideetarako, hona hemen { -brand-product-name }(e)k <a data-l10n-name="learn-more-trigger">gomendatzen duen</a> hautapen bat.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Gomendio hauetako batzuk pertsonalizatuak dira. Instalatuta dituzun hedapenetan, zure hobespenetan eta erabilpen-estatistiketan oinarrituta daude.
discopane-notice-learn-more = Argibide gehiago

privacy-policy = Pribatutasun-politika

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = egilea: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Erabiltzaile kopurua: { $dailyUsers }
install-extension-button = Gehitu { -brand-product-name }(e)ra
install-theme-button = Instalatu itxura
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Kudeatu
find-more-addons = Bilatu gehigarri gehiago

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Aukera gehiago

## Add-on actions

report-addon-button = Salatu
remove-addon-button = Kendu
# The link will always be shown after the other text.
remove-addon-disabled-button = Ezin da kendu <a data-l10n-name="link">Zergatik?</a>
disable-addon-button = Desgaitu
enable-addon-button = Gaitu
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Gaitu
preferences-addon-button =
    { PLATFORM() ->
        [windows] Aukerak
       *[other] Hobespenak
    }
details-addon-button = Xehetasunak
release-notes-addon-button = Bertsio-oharrak
permissions-addon-button = Baimenak

extension-enabled-heading = Gaituta
extension-disabled-heading = Desgaituta

theme-enabled-heading = Gaituta
theme-disabled-heading = Desgaituta

plugin-enabled-heading = Gaituta
plugin-disabled-heading = Desgaituta

dictionary-enabled-heading = Gaituta
dictionary-disabled-heading = Desgaituta

locale-enabled-heading = Gaituta
locale-disabled-heading = Desgaituta

ask-to-activate-button = Galdetu aktibatzea
always-activate-button = Aktibatu beti
never-activate-button = Ez aktibatu inoiz

addon-detail-author-label = Egilea
addon-detail-version-label = Bertsioa
addon-detail-last-updated-label = Azken eguneraketa
addon-detail-homepage-label = Hasiera-orria
addon-detail-rating-label = Balorazioa

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Puntuazioa: 5/{ NUMBER($rating, maximumFractionDigits: 1) }

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desgaituta)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] Berrikuspen bat
       *[other] { $numberOfReviews } berrikuspen
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> kendu egin da.
pending-uninstall-undo-button = Desegin

addon-detail-updates-label = Baimendu eguneraketa automatikoak
addon-detail-updates-radio-default = Lehenetsia
addon-detail-updates-radio-on = Aktibatuta
addon-detail-updates-radio-off = Desaktibatuta
addon-detail-update-check-label = Bilatu eguneraketak
install-update-button = Eguneratu

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Leiho pribatuetan baimenduta
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Baimenduta dagoenean, hedapenak zure lineako jardueretarako sarbidea izango du nabigatze pribatuko moduan. <a data-l10n-name="learn-more">Argibide gehiago</a>
addon-detail-private-browsing-allow = Baimendu
addon-detail-private-browsing-disallow = Ez baimendu

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = Segurtasun eta errendimendurako gure estandarrak betetzen dituzten hedapenak gomendatzen ditu { -brand-product-name }(e)k
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Eguneraketa erabilgarriak
recent-updates-heading = Azken eguneraketak

release-notes-loading = Kargatzen…
release-notes-error = Errorea gertatu da bertsio-oharrak kargatzean.

addon-permissions-empty = Hedapen honek ez du baimenik behar

recommended-extensions-heading = Gomendatutako hedapenak
recommended-themes-heading = Gomendatutako itxurak

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Sortzaile izan nahi? <a data-l10n-name="link">Egizu zure itxura propioa Firefox Color erabiliz.</a>

## Page headings

extension-heading = Kudeatu zure hedapenak
theme-heading = Kudeatu zure itxurak
plugin-heading = Kudeatu zure pluginak
dictionary-heading = Kudeatu zure hiztegiak
locale-heading = Kudeatu zure hizkuntzak
updates-heading = Kudeatu zure eguneraketak
discover-heading = Pertsonalizatu zure { -brand-short-name }
shortcuts-heading = Kudeatu hedapenen lasterbideak

default-heading-search-label = Bilatu gehigarri gehiago
addons-heading-search-input =
    .placeholder = Bilatu addons.mozilla.org gunean

addon-page-options-button =
    .title = Tresnak gehigarri guztientzat
