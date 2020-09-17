# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gestionari de moduls complementaris
addons-page-title = Gestionari de moduls complementaris

search-header =
    .placeholder = Cercar sus addons.mozilla.org
    .searchbuttonlabel = Cercar

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Avètz pas cap de modul d'aqueste tipe d'installat

list-empty-available-updates =
    .value = Cap de mesa a jorn pas trobada

list-empty-recent-updates =
    .value = Avètz pas mes a jorn vòstres moduls complementaris dempuèi un certan temps

list-empty-find-updates =
    .label = Recèrca las mesas a jorn

list-empty-button =
    .label = N'aprene mai suls moduls complementaris

help-button = Assisténcia dels moduls
sidebar-help-button-title =
    .title = Assisténcia dels moduls

preferences =
    { PLATFORM() ->
        [windows] Opcions { -brand-short-name }
       *[other] Preferéncias { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opcions { -brand-short-name }
           *[other] Preferéncias { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Unas extensions an pas pogut èsser verificadas

show-all-extensions-button =
    .label = Afichar totas las transicions

cmd-show-details =
    .label = Afichar mai d'entresenhas
    .accesskey = f

cmd-find-updates =
    .label = Recercar de mesas a jorn
    .accesskey = R

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferéncias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] r
        }

cmd-enable-theme =
    .label = Aplicar lo tèma
    .accesskey = A

cmd-disable-theme =
    .label = Levar lo tèma
    .accesskey = e

cmd-install-addon =
    .label = Installar
    .accesskey = I

cmd-contribute =
    .label = Contribuir
    .accesskey = C
    .tooltiptext = Contribuir al desvolopament d'aqueste modul complementari

detail-version =
    .label = Version

detail-last-updated =
    .label = Darrièra mesa a jorn

detail-contributions-description = Lo desvolopaire d'aqueste modul demanda que l'ajudetz a assegurar lo contunhament de son desvolopament en li pagant una pichona contribucion.

detail-contributions-button = Contribuir
    .title = Contribuir al desvolopament d’aqueste modul
    .accesskey = C

detail-update-type =
    .value = Mesas a jorn automaticas

detail-update-default =
    .label = Per defaut
    .tooltiptext = Installar pas las mesas a jorn automaticament que se s'agís del reglatge per defaut

detail-update-automatic =
    .label = Activadas
    .tooltiptext = Installar automaticament las mesas a jorn

detail-update-manual =
    .label = Desactivadas
    .tooltiptext = Installa pas automaticament las mesas a jorn

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Executar en fenèstras privadas

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Pas autorizat en fenèstras privadas
detail-private-disallowed-description2 = Aquesta extension fonciona pas pendent la navegacion privada. <a data-l10n-name="learn-more">Ne saber mai</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Requerís l'accès a las fenèstras privadas
detail-private-required-description2 = Aquesta extension a accès a vòstras activitats en linha pendent la navegacion privada. <a data-l10n-name="learn-more">Ne saber mai</a>

detail-private-browsing-on =
    .label = Autorizar
    .tooltiptext = Activar en navegacion privada

detail-private-browsing-off =
    .label = Autorizar pas
    .tooltiptext = Desactivar en navegacion privada

detail-home =
    .label = Pagina d'acuèlh

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil del modul

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Recèrca de mesas a jorn
    .accesskey = R
    .tooltiptext = Verificar se de mesas a jorn son disponiblas per aqueste modul

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferéncias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] r
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Modificar las opcions d'aqueste modul complementari
           *[other] Modificar las preferéncias d'aqueste modul complementari
        }

detail-rating =
    .value = Apreciacion

addon-restart-now =
    .label = Reaviar ara

disabled-unsigned-heading =
    .value = De moduls son estats desactivats

disabled-unsigned-description = Los moduls seguents podèron pas èsser verificats per lor utilizacion dins { -brand-short-name }. Podètz <label data-l10n-name="find-addons">cercar de moduls equivalents</label> o demandar a l'autor que los verifique.

disabled-unsigned-learn-more = Ne saber mai sus nòstres esfòrces per garantir vòstra seguretat en linha.

disabled-unsigned-devinfo = Los desvelopaires interesats per far verificar los moduls complementaris pòdon tenir de legir nòstre <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Quicòm manca ? De moduls extèrnes son pas mai preses en caraga per { -brand-short-name }. <label data-l10n-name="learn-more">Ne saber mai.</label>

legacy-warning-show-legacy = Afichar las extensions obsolètas

legacy-extensions =
    .value = Extensions obsolètas

legacy-extensions-description = Aquestas extensions respèctan pas los estandards actuals de { -brand-short-name } e son estadas desactivadas. <label data-l10n-name="legacy-learn-more">Ne saber mai suls cambiaments dels moduls</label>

private-browsing-description2 =
    { -brand-short-name } modifica lo foncionament de las extensions dins la navegacion privada. Cap de las novèlas extensions qu'apondètz a
    { -brand-short-name } serà pas executada per defaut dins una fenèstra privada. Levat se l'autorisatz dins los paramètres,
    l'extension foncionarà pas pendent la navegacion privada e aurà pas accès a vòstras activitats en linha
    Avèm aportat aquesta modificacion per gardar vòstra navigacion privada privada.
    <label data-l10n-name="private-browsing-learn-more">Aprenètz a gerir los paramètres d'extension</label>

addon-category-discover = Recomandacions
addon-category-discover-title =
    .title = Recomandacions
addon-category-extension = Extensions
addon-category-extension-title =
    .title = Extensions
addon-category-theme = Tèmas
addon-category-theme-title =
    .title = Tèmas
addon-category-plugin = Empeutons (Plugins)
addon-category-plugin-title =
    .title = Empeutons (Plugins)
addon-category-dictionary = Diccionaris
addon-category-dictionary-title =
    .title = Diccionaris
addon-category-locale = Lengas
addon-category-locale-title =
    .title = Lengas
addon-category-available-updates = De metre a jorn
addon-category-available-updates-title =
    .title = De metre a jorn
addon-category-recent-updates = Mes a jorn
addon-category-recent-updates-title =
    .title = Mes a jorn

## These are global warnings

extensions-warning-safe-mode = Totes los moduls complementaris son estats desactivats pel mòde sens fracàs.
extensions-warning-check-compatibility = La verificacion de compatibilitat pels moduls complementaris es desactivada. Es possible que d'unes moduls sián incompatibles.
extensions-warning-check-compatibility-button = Activar
    .title = Activar la verificacion de compatibilitat
extensions-warning-update-security = La verificacion de compatibilitat pels moduls complementaris es desactivada. Es possible que d'unas mesas a jorn sián problematicas.
extensions-warning-update-security-button = Activar
    .title = Activar la verificacion de mesas a jorn de seguretat pels moduls complementaris


## Strings connected to add-on updates

addon-updates-check-for-updates = Recercar de mesas a jorn
    .accesskey = R
addon-updates-view-updates = Afichar las mesas a jorn recentas
    .accesskey = A

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Metre a jorn los moduls automaticament
    .accesskey = M

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Activar la mesa a jorn automatica per totes los moduls
    .accesskey = c
addon-updates-reset-updates-to-manual = Desactivar la mesa a jorn automatica per totes los moduls
    .accesskey = D

## Status messages displayed when updating add-ons

addon-updates-updating = Mesa a jorn dels moduls
addon-updates-installed = Vòstres moduls son estats meses a jorn.
addon-updates-none-found = Cap de mesa a jorn pas trobada
addon-updates-manual-updates-found = Afichar las mesas a jorn disponiblas

## Add-on install/debug strings for page options menu

addon-install-from-file = Installar un modul dins d’un fichièr…
    .accesskey = I
addon-install-from-file-dialog-title = Causissètz un modul d'installar
addon-install-from-file-filter-name = Moduls complementaris
addon-open-about-debugging = Desbugar los moduls
    .accesskey = D

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gerir los acorchis d’extensions
    .accesskey = G

shortcuts-no-addons = Avètz pas cap d'extension activada.
shortcuts-no-commands = Las extensions seguentas an pas d’acorchi :
shortcuts-input =
    .placeholder = Picatz un acorchi

shortcuts-browserAction2 = Activar lo boton de la barra d’aisinas
shortcuts-pageAction = Activar l'accion de la pagina
shortcuts-sidebarAction = Mostrar/Amagar la barra laterala

shortcuts-modifier-mac = Inclure Ctrl, Alt o ⌘
shortcuts-modifier-other = Inclure Ctrl o Alt
shortcuts-invalid = Combinason invalida
shortcuts-letter = Picatz una letra
shortcuts-system = Impossible de remplaçar un acorchi clavièr de { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Acorchi en doble

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } es utilizat coma acorchi dins mai d'un cas. De acorchis en doble pòdon provocar un compòrtament inesperat.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Ja utilizat per { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Ne veire { $numberToShow } mai
       *[other] Ne veire { $numberToShow } mai
    }

shortcuts-card-collapse-button = Ne veire mens

header-back-button =
    .title = Tornar

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Las extensions e los tèmas son coma d'aplicacions per vòstre navegador, e vos permeton de
    protegir los senhals, telecargar de vidèos, trobar d'ofèrtas, blocar las publicitats tediosas,
    cambiar l'aparéncia de vòstre navegador, e plan mai encara. Aquestes pichons logicials
    son sovent desvolopats per un tèrç. Vaquí una seleccion que { -brand-product-name } 
    
    <a data-l10n-name="learn-more-trigger"> vos recomanda</a> per de  foncionalitats
    de securitat e performanças excepcionalas.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Unas d'aquestas recomandacions son personalizadas. Son basadas sus d'autras
    extensions qu'avètz installadas, las preferéncias del perfil e las estatisticas d'utilizacion.
discopane-notice-learn-more = Ne saber mai

privacy-policy = Politica de confidencialitat

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = per <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Utilizaires : { $dailyUsers }
install-extension-button = Apondre a { -brand-product-name }
install-theme-button = Installar lo tèma
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gerir
find-more-addons = Trobar mai de moduls

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Mai d’opcions

## Add-on actions

report-addon-button = Rapòrt
remove-addon-button = Levar
# The link will always be shown after the other text.
remove-addon-disabled-button = Impossible de suprimir <a data-l10n-name="link"> Perqué ?</a>
disable-addon-button = Desactivar
enable-addon-button = Activar
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activar
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferéncias
    }
details-addon-button = Detalhs
release-notes-addon-button = Nòtas de version
permissions-addon-button = Permissions

extension-enabled-heading = Activadas
extension-disabled-heading = Desactivadas

theme-enabled-heading = Activat
theme-disabled-heading = Desactivats

plugin-enabled-heading = Activats
plugin-disabled-heading = Desactivats

dictionary-enabled-heading = Activats
dictionary-disabled-heading = Desactivats

locale-enabled-heading = Activadas
locale-disabled-heading = Desactivadas

ask-to-activate-button = Demandar per activar
always-activate-button = Totjorn activar
never-activate-button = Activar pas jamai

addon-detail-author-label = Autor
addon-detail-version-label = Version
addon-detail-last-updated-label = Darrièra mesa a jorn
addon-detail-homepage-label = Pagina d’acuèlh
addon-detail-rating-label = Apreciacion

# Message for add-ons with a staged pending update.
install-postponed-message = Aquesta extension serà mesa a jorn quand { -brand-short-name } reavirà.
install-postponed-button = Metre a jorn ara

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Notat { NUMBER($rating, maximumFractionDigits: 1) } sus 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desactivat)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } revista
       *[other] { $numberOfReviews } revistas
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> es estat suprimit.
pending-uninstall-undo-button = Anullar

addon-detail-updates-label = Permetre las mesas a jorn automaticas
addon-detail-updates-radio-default = Defaut
addon-detail-updates-radio-on = Activadas
addon-detail-updates-radio-off = Desactivadas
addon-detail-update-check-label = Recercar de mesas a jorn
install-update-button = Metre a jorn

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Autorizat en navegacion privada
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Quand es autorizada, l'extension a accès a vòstras activitats en linha pendent la navegacion privada. <a data-l10n-name="learn-more">Ne saber mai</a>
addon-detail-private-browsing-allow = Autorizar
addon-detail-private-browsing-disallow = Autorizar pas

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } recomanda pas que las extensions que respèctan nòstres estandards de seguretat e performança
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Mesas a jorn disponiblas
recent-updates-heading = Mesas a jorn recentas

release-notes-loading = Cargament…
release-notes-error = Una error s'es producha en cargant las nòtas de version.

addon-permissions-empty = Aquesta extension demanda pas cap d'autorizacion

recommended-extensions-heading = Extensions recomandadas
recommended-themes-heading = Tèmas recomandats

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Vos sentissètz creatiu ? <a data-l10n-name="link">Creatz vòstre pròpri tèma amb Firefox Color.</a>

## Page headings

extension-heading = Gestion de las extensions
theme-heading = Gestion dels tèmas
plugin-heading = Gestion dels plugins
dictionary-heading = Gestion dels diccionaris
locale-heading = Gestion de las lengas
updates-heading = Gestion de las mesas a jorn
discover-heading = Personalizatz { -brand-short-name }
shortcuts-heading = Gestion dels acorchis d’extensions

default-heading-search-label = Trobar mai de moduls
addons-heading-search-input =
    .placeholder = Cercar sus addons.mozilla.org

addon-page-options-button =
    .title = Aisinas per totes los moduls
