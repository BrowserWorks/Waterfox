# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Rheolwr Ychwanegion
addons-page-title = Rheolwr Ychwanegion

search-header =
    .placeholder = Search addons.mozilla.org
    .searchbuttonlabel = Chwilio

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Nid oes gennych ychwanegion o'r math yma wedi eu gosod

list-empty-available-updates =
    .value = Heb ganfod diweddariadau

list-empty-recent-updates =
    .value = Nid ydych wedi diweddaru eich ychwanegion yn ddiweddar

list-empty-find-updates =
    .label = Gwirio am Ddiweddariadau

list-empty-button =
    .label = Dysgu rhagor am ychwanegion

help-button = Cefnogaeth Ychwanegion
sidebar-help-button-title =
    .title = Cefnogaeth Ychwanegion

preferences =
    { PLATFORM() ->
        [windows] Dewisiadau { -brand-short-name }
       *[other] Dewisiadau { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Dewisiadau { -brand-short-name }
           *[other] Dewisiadau { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Nid oedd modd dilysu rhai estyniadau

show-all-extensions-button =
    .label = Dangos pob estyniad

cmd-show-details =
    .label = Dangos Rhagor o Wybodaeth
    .accesskey = D

cmd-find-updates =
    .label = Canfod Diweddariadau
    .accesskey = C

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Dewisiadau
           *[other] Dewisiadau
        }
    .accesskey =
        { PLATFORM() ->
            [windows] D
           *[other] e
        }

cmd-enable-theme =
    .label = Gwisgo Thema
    .accesskey = w

cmd-disable-theme =
    .label = Peidio Gwisgo Thema
    .accesskey = P

cmd-install-addon =
    .label = Gosod
    .accesskey = G

cmd-contribute =
    .label = Cyfrannu
    .accesskey = C
    .tooltiptext = Cyfrannu i ddatblygiad yr ychwanegyn

detail-version =
    .label = Fersiwn

detail-last-updated =
    .label = Diweddarwyd Diwethaf

detail-contributions-description = Mae datblygwr yr ychwanegyn yn gofyn eich bod yn cynorthwyo i gefnogi datblygiad drwy wneud cyfraniad bychan.

detail-contributions-button = Cyfrannu
    .title = Cyfrannwch i ddatblygiad yr ategyn hwn
    .accesskey = C

detail-update-type =
    .value = Diweddariadau Awtomatig

detail-update-default =
    .label = Rhagosodedig
    .tooltiptext = Gosod diweddariadau'n awtomatig os mai dyna yw'r rhagosodedig

detail-update-automatic =
    .label = Ymlaen
    .tooltiptext = Gosod diweddariadau'n awtomatig

detail-update-manual =
    .label = Diffodd
    .tooltiptext = Peidio gosod diweddariadau'n awtomatig

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Rhedeg mewn Ffenestri Preifat

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Heb ei ganiatáu mewn Ffenestri Preifat
detail-private-disallowed-description2 = Nid yw'r estyniad hwn yn rhedeg tra'n pori'n preifat. <a data-l10n-name="learn-more">Dysgu rhagor</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Angen Mynediad i Ffenestri Preifat
detail-private-required-description2 = Mae gan yr estyniad hwn fynediad i'ch gweithgareddau ar-lein wrth bori'n breifat. <a data-l10n-name="learn-more">Dysgu mwy</a>

detail-private-browsing-on =
    .label = Caniatáu
    .tooltiptext = Caniatáu wrth Bori Preifat

detail-private-browsing-off =
    .label = Peidio Caniatáu
    .tooltiptext = Analluogi mewn Pori Preifat

detail-home =
    .label = Tudalen Cartref

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Proffil Ychwanegyn

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Gwirio am Ddiweddariadau
    .accesskey = G
    .tooltiptext = Gwirio am ddiweddariad i'r ychwanegyn

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Dewisiadau
           *[other] Dewisiadau
        }
    .accesskey =
        { PLATFORM() ->
            [windows] D
           *[other] e
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Newid dewisiadau'r ychwanegyn
           *[other] Newid dewisiadau'r ychwanegyn
        }

detail-rating =
    .value = Graddio

addon-restart-now =
    .label = Ailgychwyn nawr

disabled-unsigned-heading =
    .value = Mae rhai ychwanegion wedi eu hanalluogi

disabled-unsigned-description = Mae'r ychwanegion canlynol wedi eu dilysu i'w defnyddio yn { -brand-short-name }. Gallwch <label data-l10n-name="find-addons">canfod newidiadau</label> neu ofyn i'r datblygwr iddynt gael eu dilysu.

disabled-unsigned-learn-more = Dysgu rhagor am ein hymdrechion i'ch cadw'n ddiogel ar-lein.

disabled-unsigned-devinfo = Gall ddatblygwyr sydd â diddordeb mewn dilysu eu hychwanegion barhau drwy ddarllen ein <label data-l10n-name="learn-more">canllawiau</label>.

plugin-deprecation-description = Rhywbeth ar goll? Nid yw rhai ategion yn cael eu cynnal bellach gan { -brand-short-name }. <label data-l10n-name="learn-more">Dysgu Rhagor.</label>

legacy-warning-show-legacy = Dangos hen estyniadau

legacy-extensions =
    .value = Hen Estyniadau

legacy-extensions-description = Nid yw'r estyniadau hyn yn cyrraedd safonau cyfredol { -brand-short-name } ac mae nhw wedi cael eu diffodd. <label data-l10n-name="legacy-learn-more">Dysgu am y newidiadau i ychwanegion</label>

private-browsing-description2 =
    Mae { -brand-short-name } yn newid sut mae estyniadau'n gweithio o fewn pori preifat. Ni fydd unrhyw estyniadau newydd y byddwch chi'n eu hychwanegu at { -brand-short-name } yn rhedeg yn ragosodedig o fewn Ffenestri Prefat. Oni bai eich bod yn ei ganiatáu yn y gosodiadau, ni fydd estyniad yn gweithio wrth bori'n preifat, ac ni chaiff fynediad at eich gweithgareddau ar-lein yno. Rydym wedi gwneud y newid hwn i gadw eich pori preifat yn breifat.
    <label data-l10n-name="private-browsing-learn-more">Dysgu sut i reoli gosodiadau estyniad.</label>

addon-category-discover = Argymhellion
addon-category-discover-title =
    .title = Argymhellion
addon-category-extension = Estyniadau
addon-category-extension-title =
    .title = Estyniadau
addon-category-theme = Themâu
addon-category-theme-title =
    .title = Themâu
addon-category-plugin = Ategion
addon-category-plugin-title =
    .title = Ategion
addon-category-dictionary = Geiriaduron
addon-category-dictionary-title =
    .title = Geiriaduron
addon-category-locale = Iaith
addon-category-locale-title =
    .title = Iaith
addon-category-available-updates = Diweddariadau ar Gael
addon-category-available-updates-title =
    .title = Diweddariadau ar Gael
addon-category-recent-updates = Diweddariadau Diweddar
addon-category-recent-updates-title =
    .title = Diweddariadau Diweddar

## These are global warnings

extensions-warning-safe-mode = Mae pob ychwanegyn wedi eu hanalluogi gan y modd diogel.
extensions-warning-check-compatibility = Mae gwirio cydnawsedd ychwanegion wedi ei analluogi. Efallai fod gennych ychwanegion anghydnaws.
extensions-warning-check-compatibility-button = Galluogi
    .title = Galluogi gwirio cydnawsedd ychwanegion
extensions-warning-update-security = Mae gwirio diogelwch diweddariad wedi ei analluogi. Efallai eich bod o dan fygythiad gan ddiweddariad.
extensions-warning-update-security-button = Galluogi
    .title = Galluogi gwirio diogelwch diweddariad ychwanegyn


## Strings connected to add-on updates

addon-updates-check-for-updates = Gwirio am Ddiweddariadau
    .accesskey = G
addon-updates-view-updates = Gweld Diweddariadau Diweddar
    .accesskey = D

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Diweddaru Ychwanegion yn Awtomatig
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Ailosod Pob Ychwanegyn i'w Diweddaru'n Awtomatig
    .accesskey = P
addon-updates-reset-updates-to-manual = Ailosod Pob Ychwanegyn i Ddiweddaru gyda Llaw
    .accesskey = L

## Status messages displayed when updating add-ons

addon-updates-updating = Diweddaru ychwanegion
addon-updates-installed = Mae eich ychwanegion wedi eu diweddaru.
addon-updates-none-found = Heb ganfod diweddariadau
addon-updates-manual-updates-found = Gweld Diweddariadau ar Gael

## Add-on install/debug strings for page options menu

addon-install-from-file = Gosod Ychwanegyn o Ffeil…
    .accesskey = G
addon-install-from-file-dialog-title = Dewis ategyn i'w osod
addon-install-from-file-filter-name = Ychwanegion
addon-open-about-debugging = Dadfygio Ychwanegion
    .accesskey = Y

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Rheoli Estyniad Llwybrau Byr
    .accesskey = R

shortcuts-no-addons = Nid oes gennych unrhyw estyniadau wedi'u galluogi.
shortcuts-no-commands = Nid oes gan yr estyniadau canlynol lwybrau byr:
shortcuts-input =
    .placeholder = Teipiwch llwybr byr

shortcuts-browserAction2 = Cychwyn botwm bar offer
shortcuts-pageAction = Cychwyn gweithred tudalen
shortcuts-sidebarAction = Toglo'r bar ochr

shortcuts-modifier-mac = Cynnwys Ctrl, Alt, neu ⌘
shortcuts-modifier-other = Cynnwys Ctrl neu Alt
shortcuts-invalid = Cyfuniad annilys
shortcuts-letter = Teipiwch lythyr
shortcuts-system = Methu anwybyddu llwybr byr { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Llwybr byr dyblyg

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = Mae { $shortcut } yn cael ei ddefnyddio fel llwybr byr mewn mwy nag un achos. Gall llwybrau byr dyblyg achosi ymddygiad annisgwyl.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Ar waith eisoes gan { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [zero] Dangos { $numberToShow } yn Rhagor
        [one] Dangos { $numberToShow } yn Rhagor
        [two] Dangos { $numberToShow } yn Rhagor
        [few] Dangos { $numberToShow } yn Rhagor
        [many] Dangos { $numberToShow } yn Rhagor
       *[other] Dangos { $numberToShow } yn Rhagor
    }

shortcuts-card-collapse-button = Dangos Llai

header-back-button =
    .title = Mynd nôl

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Mae estyniadau a themâu yn debyg i apiau ar gyfer eich porwr, ac maen nhw'n gadael i chi
    diogelu cyfrineiriau, llwytho fideos i lawr, dod o hyd i gytundebau, rhwystro hysbysebion blin, newid
    golwg eich porwr a llawer mwy. Mae'r rhaglenni meddalwedd bach hyn fel arfer yn cael eu datblygu gan drydydd parti. Dyma detholiad y mae { -brand-product-name }<a data-l10n-name="learn-more-trigger">
    yn eu hargymell </a> am ddiogelwch, perfformiad, a swyddogaethau gwell.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Mae rhai o'r argymhellion hyn wedi'u dewis yn benodol ar eich cyfer chi. Maen nhw'n seiliedig ar 
    estyniadau eraill rydych chi wedi'u gosod, eich proffil dewisiadau, a'ch ystadegau defnydd.
discopane-notice-learn-more = Dysgu rhagor

privacy-policy = Polisi Preifatrwydd

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = gan <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Defnyddwyr: { $dailyUsers }
install-extension-button = Ychwanegu at { -brand-product-name }
install-theme-button = Gosod Thema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Rheoli
find-more-addons = Canfod rhagor o ychwanegion

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Rhagor o Ddewisiadau

## Add-on actions

report-addon-button = Adrodd
remove-addon-button = Tynnu
# The link will always be shown after the other text.
remove-addon-disabled-button = Methu ei Dynnu <a data-l10n-name="link"> Pam? </a>
disable-addon-button = Analluogu
enable-addon-button = Galluogi
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Galluogi
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opsiynau
       *[other] Dewisiadau
    }
details-addon-button = Manylion
release-notes-addon-button = Nodiadau Rhyddhau
permissions-addon-button = Caniatâd

extension-enabled-heading = Galluogwyd
extension-disabled-heading = Analluogwyd

theme-enabled-heading = Galluogwyd
theme-disabled-heading = Analluogwyd

plugin-enabled-heading = Galluogwyd
plugin-disabled-heading = Analluogwyd

dictionary-enabled-heading = Galluogwyd
dictionary-disabled-heading = Analluogwyd

locale-enabled-heading = Galluogwyd
locale-disabled-heading = Analluogwyd

ask-to-activate-button = Gofyn i'w Weithredu
always-activate-button = Gweithredu Bob Tro
never-activate-button = Byth Gweithredu

addon-detail-author-label = Awdur
addon-detail-version-label = Fersiwn
addon-detail-last-updated-label = Diweddarwyd Diwethaf
addon-detail-homepage-label = Tudalen Cartref
addon-detail-rating-label = Graddio

# Message for add-ons with a staged pending update.
install-postponed-message = Bydd yr estyniad hwn yn cael ei ddiweddaru pan fydd { -brand-short-name } yn ailgychwyn.
install-postponed-button = Diweddaru Nawr

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Graddiwyd { NUMBER($rating, maximumFractionDigits: 1) } allan o 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (analluogwyd)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [zero] { $numberOfReviews } adolygiad
        [one] { $numberOfReviews } adolygiad
        [two] { $numberOfReviews } adolygiad
        [few] { $numberOfReviews } adolygiad
        [many] { $numberOfReviews } adolygiad
       *[other] { $numberOfReviews } adolygiad
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Mae <span data-l10n-name="addon-name">{ $addon }</span> wedi ei dynnu.
pending-uninstall-undo-button = Dadwneud

addon-detail-updates-label = Caniatáu diweddariadau awtomatig
addon-detail-updates-radio-default = Rhagosodedig
addon-detail-updates-radio-on = Ymlaen
addon-detail-updates-radio-off = Diffodd
addon-detail-update-check-label = Gwirio am Ddiweddariadau
install-update-button = Diweddaru

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Caniatáu mewn ffenestri preifat
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Pan mae'n cael ei ganiatáu, bydd yr estyniad ar gael i'ch gweithgareddau ar-lein tra byddwch yn pori'n breifat. <a data-l10n-name="learn-more"> Gwybod rhagor</a>
addon-detail-private-browsing-allow = Caniatáu
addon-detail-private-browsing-disallow = Peidio Caniatáu

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = Dim ond estyniadau sy'n cwrdd â'n safonau ar gyfer diogelwch a pherfformiad y mae { -brand-product-name } yn eu hargymell
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Diweddariadau ar Gael
recent-updates-heading = Diweddariadau Diweddar

release-notes-loading = Llwytho…
release-notes-error = Ymddiheuriadau ond bu gwall llwytho'r nodiadau ryddhau.

addon-permissions-empty = Nid oes angen unrhyw ganiatâd ar yr estyniad hwn

recommended-extensions-heading = Estyniadau Cymeradwy
recommended-themes-heading = Themâu Cymeradwy

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Teimlo'n greadigol? <a data-l10n-name="link">Adeiladwch eich thema eich hun gyda Firefox Color. </a>

## Page headings

extension-heading = Rheoli eich estyniadau
theme-heading = Rheoli eich themâu
plugin-heading = Rheoli eich ategion
dictionary-heading = Rheoli eich geiriaduron
locale-heading = Rheoli eich ieithoedd
updates-heading = Rheoli Eich Diweddariadau
discover-heading = Personoli Eich { -brand-short-name }
shortcuts-heading = Rheoli Estyniad Llwybrau Byr

default-heading-search-label = Canfod rhagor o ychwanegion
addons-heading-search-input =
    .placeholder = Search addons.mozilla.org

addon-page-options-button =
    .title = Offer ar gyfer pob ychwanegyn
