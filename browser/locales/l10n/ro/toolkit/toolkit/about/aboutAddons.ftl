# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Manager de suplimente
addons-page-title = Manager de suplimente

search-header =
    .placeholder = Caută pe addons.mozilla.org
    .searchbuttonlabel = Căutare

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Nu ai vreun supliment de acest tip instalat

list-empty-available-updates =
    .value = Nicio actualizare găsită

list-empty-recent-updates =
    .value = Nu ai actualizat recent niciun supliment

list-empty-find-updates =
    .label = Caută actualizări

list-empty-button =
    .label = Află mai multe despre suplimente

help-button = Suport pentru suplimente
sidebar-help-button-title =
    .title = Suport pentru suplimente

preferences =
    { PLATFORM() ->
        [windows] Opțiuni { -brand-short-name }
       *[other] Preferințe { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opțiuni { -brand-short-name }
           *[other] Preferințe { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Unele extensii nu au putut fi verificate

show-all-extensions-button =
    .label = Afișează toate extensiile

cmd-show-details =
    .label = Afișează mai multe informații
    .accesskey = A

cmd-find-updates =
    .label = Caută actualizări
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opțiuni
           *[other] Preferințe
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Poartă tema
    .accesskey = P

cmd-disable-theme =
    .label = Nu mai purta tema
    .accesskey = N

cmd-install-addon =
    .label = Instalează
    .accesskey = I

cmd-contribute =
    .label = Contribuie
    .accesskey = C
    .tooltiptext = Contribuie la dezvoltarea acestui supliment

detail-version =
    .label = Versiune

detail-last-updated =
    .label = Ultima actualizare

detail-contributions-description = Dezvoltatorul acestei extensii îți cere sprijinul pentru continuarea perfecționării acesteia printr-o mică donație.

detail-contributions-button = Contribuie
    .title = Contrbuie la dezvoltarea acestui supliment
    .accesskey = C

detail-update-type =
    .value = Actualizări automate

detail-update-default =
    .label = Implicit
    .tooltiptext = Instalează automat actualizări doar dacă aceasta e setarea implicită

detail-update-automatic =
    .label = Activate
    .tooltiptext = Instalează actualizări automat

detail-update-manual =
    .label = Dezactivate
    .tooltiptext = Nu instala actualizările automat

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Rulează în ferestre private

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Nepermis în ferestre private
detail-private-disallowed-description2 = Această extensie nu rulează în navigare privată. <a data-l10n-name="learn-more">Află mai multe</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Necesită acces la ferestre private
detail-private-required-description2 = Această extensie are acces la activitățile tale online în navigarea privată. <a data-l10n-name="learn-more">Află mai multe</a>

detail-private-browsing-on =
    .label = Permite
    .tooltiptext = Activează în navigarea privată

detail-private-browsing-off =
    .label = Nu permite
    .tooltiptext = Dezactivează în navigarea privată

detail-home =
    .label = Pagină de start

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profilul suplimentului

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Caută actualizări
    .accesskey = f
    .tooltiptext = Caută actualizări pentru acest supliment

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opțiuni
           *[other] Preferințe
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Schimbă opțiunile acestui supliment
           *[other] Schimbă preferințele acestui supliment
        }

detail-rating =
    .value = Evaluare

addon-restart-now =
    .label = Repornește acum

disabled-unsigned-heading =
    .value = Unele suplimente au fost dezactivate

disabled-unsigned-description = Următoarele suplimente nu au fost verificate pentru a fi folosite în { -brand-short-name }. Poți <label data-l10n-name="find-addons">să găsești înlocuitoare</label> sau să întrebi dezvoltatorii pentru a fi verificate.

disabled-unsigned-learn-more = Află mai multe despre eforturile noastre de a te ține în siguranță online.

disabled-unsigned-devinfo = Dezvoltatorii interesați în verificarea suplimentelor pot continua cu citirea <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Lipsește ceva? Unele pluginuri nu mai sunt suportate de { -brand-short-name }. <label data-l10n-name="learn-more">Află mai multe</label>

legacy-warning-show-legacy = Afișează extensiile obsolete

legacy-extensions =
    .value = Extensii obsolete

legacy-extensions-description = Aceste extensii nu îndeplinesc standardele actuale ale { -brand-short-name } astfel încât au fost dezactivate. <label data-l10n-name="legacy-learn-more">Află despre schimbările aduse suplimentelor</label>

private-browsing-description2 =
    { -brand-short-name } schimbă felul în care extensiile funcționează în navigarea privată. Orice extensie nouă pe care o adaugi în { -brand-short-name } nu va rula în mod implicit în cadrul ferestrelor private. Dacă nu permiți asta din setări, extensia nu va funcționa în timpul navigării private și nu va avea acces la activitățile tale online. Am făcut această modificare pentru ca navigarea privată să rămână privată.
    <label data-l10n-name="private-browsing-learn-more">Află cum să gestionezi setările pentru extensii</label>.

addon-category-discover = Recomandări
addon-category-discover-title =
    .title = Recomandări
addon-category-extension = Extensii
addon-category-extension-title =
    .title = Extensii
addon-category-theme = Teme
addon-category-theme-title =
    .title = Teme
addon-category-plugin = Pluginuri
addon-category-plugin-title =
    .title = Pluginuri
addon-category-dictionary = Dicționare
addon-category-dictionary-title =
    .title = Dicționare
addon-category-locale = Limbi
addon-category-locale-title =
    .title = Limbi
addon-category-available-updates = Actualizări disponibile
addon-category-available-updates-title =
    .title = Actualizări disponibile
addon-category-recent-updates = Actualizări recente
addon-category-recent-updates-title =
    .title = Actualizări recente

## These are global warnings

extensions-warning-safe-mode = Toate suplimentele sunt dezactivate în modul Sigur.
extensions-warning-check-compatibility = Verificarea compatibilității suplimentelor este dezactivată. Ai putea avea suplimente incompatibile.
extensions-warning-check-compatibility-button = Activează
    .title = Activează verificarea compatibilității suplimentelor
extensions-warning-update-security = Verificarea securității actualizărilor de suplimente este dezactivată. Ai putea primi actualizări compromise.
extensions-warning-update-security-button = Activează
    .title = Activează verificarea securității actualizărilor suplimentelor


## Strings connected to add-on updates

addon-updates-check-for-updates = Caută actualizări
    .accesskey = C
addon-updates-view-updates = Vezi actualizările recente
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Actualizează automat suplimentele
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Resetează toate suplimentele să se actualizeze automat
    .accesskey = R
addon-updates-reset-updates-to-manual = Resetează toate suplimentele să se actualizeze manual
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Se actualizează suplimentele
addon-updates-installed = Suplimentele tale au fost actualizate.
addon-updates-none-found = Nicio actualizare găsită
addon-updates-manual-updates-found = Vezi actualizările disponibile

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalează un supliment dintr-un fișier…
    .accesskey = I
addon-install-from-file-dialog-title = Selectează suplimentul pentru instalare
addon-install-from-file-filter-name = Suplimente
addon-open-about-debugging = Depanează suplimente
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gestionează comenzile rapide ale extensiilor
    .accesskey = S

shortcuts-no-addons = Nu ai activat nicio extensie.
shortcuts-no-commands = Următoarele extensii nu au comenzi rapide:
shortcuts-input =
    .placeholder = Tastează o comandă rapidă

shortcuts-browserAction2 = Activează butonul pentru bara de unelte
shortcuts-pageAction = Activează acțiunea pe pagină
shortcuts-sidebarAction = Comută bara laterală

shortcuts-modifier-mac = Include Ctrl, Alt sau ⌘
shortcuts-modifier-other = Include Ctrl sau Alt
shortcuts-invalid = Combinație nevalidă
shortcuts-letter = Tastează o literă
shortcuts-system = Scurtăturile { -brand-short-name } nu pot fi înlocuite

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Comandă rapidă duplicat

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } este folosită drept comandă rapidă în mai mult de un caz. Comenzile rapide duplicat pot produce comportamente neașteptate.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Deja utilizat de { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Afișează încă { $numberToShow }
        [few] Afișează încă { $numberToShow }
       *[other] Afișează încă { $numberToShow }
    }

shortcuts-card-collapse-button = Afișează mai puțin

header-back-button =
    .title = Înapoi

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Extensiile și temele sunt ca un fel de aplicații pentru browser și îți permit să îți protejezi parolele, să descarci videoclipuri, să descoperi oferte, să blochezi reclame enervante, să schimbi aspectul browserului și multe altele. Aceste programe software mici sunt adesea dezvoltate de părți terțe. Iată o selecție pe care { -brand-product-name } <a data-l10n-name="learn-more-trigger">o recomandă</a> pentru securitate, performanță și funcționalitate de excepție.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Unele dintre aceste recomandări sunt personalizate. Această selecție se bazează pe alte extensii pe care le-ai instalat, pe preferințele de profil și pe statisticile de utilizare.
discopane-notice-learn-more = Află mai multe

privacy-policy = Politică de confidențialitate

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = de <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Utilizatori: { $dailyUsers }
install-extension-button = Adaugă în { -brand-product-name }
install-theme-button = Instalează tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gestionează
find-more-addons = Caută mai multe suplimente

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Mai multe opțiuni

## Add-on actions

report-addon-button = Raportează
remove-addon-button = Elimină
# The link will always be shown after the other text.
remove-addon-disabled-button = Nu se poate elimina <a data-l10n-name="link">De ce?</a>
disable-addon-button = Dezactivează
enable-addon-button = Activează
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activează
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opțiuni
       *[other] Preferințe
    }
details-addon-button = Detalii
release-notes-addon-button = Note privind versiunea
permissions-addon-button = Permisiuni

extension-enabled-heading = Activate
extension-disabled-heading = Dezactivate

theme-enabled-heading = Activate
theme-disabled-heading = Dezactivate

plugin-enabled-heading = Activate
plugin-disabled-heading = Dezactivate

dictionary-enabled-heading = Activate
dictionary-disabled-heading = Dezactivate

locale-enabled-heading = Activate
locale-disabled-heading = Dezactivate

ask-to-activate-button = Întreabă pentru activare
always-activate-button = Activează întotdeauna
never-activate-button = Nu activa niciodată

addon-detail-author-label = Autor
addon-detail-version-label = Versiune
addon-detail-last-updated-label = Ultima actualizare
addon-detail-homepage-label = Pagină de start
addon-detail-rating-label = Evaluare

# Message for add-ons with a staged pending update.
install-postponed-message = Această extensie va fi actualizată la repornirea { -brand-short-name }.
install-postponed-button = Actualizează acum

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Evaluat la { NUMBER($rating, maximumFractionDigits: 1) } din 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (dezactivat)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recenzie
        [few] { $numberOfReviews } recenzii
       *[other] { $numberOfReviews } de recenzii
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> a fost eliminat.
pending-uninstall-undo-button = Anulează

addon-detail-updates-label = Permite actualizările automate
addon-detail-updates-radio-default = Implicit
addon-detail-updates-radio-on = Activate
addon-detail-updates-radio-off = Dezactivate
addon-detail-update-check-label = Caută actualizări
install-update-button = Actualizare

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permis în ferestre private
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Când are accesul permis, extensia va avea acces la activitățile tale online în navigarea privată. <a data-l10n-name="learn-more">Află mai multe</a>
addon-detail-private-browsing-allow = Permite
addon-detail-private-browsing-disallow = Nu permite

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } recomandă numai extensiile care ne întrunesc standardele de securitate și performanță
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Actualizări disponibile
recent-updates-heading = Actualizări recente

release-notes-loading = Se încarcă...
release-notes-error = Ne pare rău, dar a intervenit o eroare la încărcarea notelor privind versiunea.

addon-permissions-empty = Această extensie nu necesită nicio permisiune

recommended-extensions-heading = Extensii recomandate
recommended-themes-heading = Teme recomandate

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Te simți creativ? <a data-l10n-name="link">Construiește-ți propria temă cu Firefox Color.</a>

## Page headings

extension-heading = Gestionează extensiile
theme-heading = Gestionează temele
plugin-heading = Gestionează pluginurile
dictionary-heading = Gestionează dicționarele
locale-heading = Gestionează limbile
updates-heading = Gestionează-ți actualizările
discover-heading = Personalizează { -brand-short-name }
shortcuts-heading = Gestionează comenzile rapide ale extensiilor

default-heading-search-label = Caută mai multe suplimente
addons-heading-search-input =
    .placeholder = Caută pe addons.mozilla.org

addon-page-options-button =
    .title = Instrumente pentru toate suplimentele
