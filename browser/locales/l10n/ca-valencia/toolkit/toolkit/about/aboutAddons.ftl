# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gestor de complements

addons-page-title = Gestor de complements

search-header =
    .placeholder = Cerca a addons.mozilla.org
    .searchbuttonlabel = Cerca

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = No teniu instal·lat cap complement d'este tipus

list-empty-available-updates =
    .value = No s'ha trobat cap actualització

list-empty-recent-updates =
    .value = No heu actualitzat recentment cap complement

list-empty-find-updates =
    .label = Cerca actualitzacions

list-empty-button =
    .label = Més informació dels complements

help-button = Assistència per als complements

sidebar-help-button-title =
    .title = Assistència per als complements

preferences =
    { PLATFORM() ->
        [windows] Opcions del { -brand-short-name }
       *[other] Preferències del { -brand-short-name }
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opcions del { -brand-short-name }
           *[other] Preferències del { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = No s'han pogut verificar algunes extensions

show-all-extensions-button =
    .label = Mostra totes les extensions

cmd-show-details =
    .label = Mostra més informació
    .accesskey = s

cmd-find-updates =
    .label = Cerca actualitzacions
    .accesskey = C

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferències
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Emprova't el tema
    .accesskey = v

cmd-disable-theme =
    .label = Deixa el tema
    .accesskey = x

cmd-install-addon =
    .label = Instal·la
    .accesskey = I

cmd-contribute =
    .label = Col·labora-hi
    .accesskey = C
    .tooltiptext = Col·labora en el desenvolupament del complement

detail-version =
    .label = Versió

detail-last-updated =
    .label = Darrera actualització

detail-contributions-description = El desenvolupador del complement vos demana que l'ajudeu a continuar amb el seu desenvolupament fent una donació.

detail-contributions-button = Col·labora-hi
    .title = Col·labora en el desenvolupament del complement
    .accesskey = C

detail-update-type =
    .value = Actualitzacions automàtiques

detail-update-default =
    .label = Per defecte
    .tooltiptext = Instal·la automàticament les actualitzacions només si és el comportament per defecte

detail-update-automatic =
    .label = Activades
    .tooltiptext = Instal·la actualitzacions automàticament

detail-update-manual =
    .label = Desactivades
    .tooltiptext = No instal·les actualitzacions automàticament

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Executa en finestres privades

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = No es permet en finestres privades

detail-private-disallowed-description2 = Esta extensió no s'executa durant la navegació privada. <a data-l10n-name="learn-more">Més informació</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Necessita accés a les finestres privades

detail-private-required-description2 = Esta extensió té accés a la vostra activitat a Internet durant la navegació privada. <a data-l10n-name="learn-more">Més informació</a>

detail-private-browsing-on =
    .label = Permet
    .tooltiptext = Activa en la navegació privada

detail-private-browsing-off =
    .label = No ho permetes
    .tooltiptext = Desactiva en la navegació privada

detail-home =
    .label = Pàgina d'inici

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil del complement

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Cerca actualitzacions
    .accesskey = t
    .tooltiptext = Cerca actualitzacions d'este complement

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferències
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Canvia les opcions del complement
           *[other] Canvia les preferències del complement
        }

detail-rating =
    .value = Puntuació

addon-restart-now =
    .label = Reinicia ara

disabled-unsigned-heading =
    .value = S'han inhabilitat alguns complements

disabled-unsigned-description = Els complements següents no s'han verificat per al seu ús al { -brand-short-name }. Podeu <label data-l10n-name="find-addons">cercar un altre complement similar</label> o demanar al desenvolupador que els verifiqui.

disabled-unsigned-learn-more = Més informació sobre els nostres esforços per garantir la vostra seguretat a Internet.

disabled-unsigned-devinfo = Els desenvolupadors interessats en la verificació dels seus complements poden llegir el nostre <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Vos falta res? Alguns complements ja no són compatibles amb el { -brand-short-name }. <label data-l10n-name="learn-more">Més informació.</label>

legacy-warning-show-legacy = Mostra les extensions antigues

legacy-extensions =
    .value = Extensions antigues

legacy-extensions-description = Estes extensions no compleixen els estàndards actuals del { -brand-short-name } i s'han desactivat. <label data-l10n-name="legacy-learn-more">Més informació sobre els canvis en els complements</label>

private-browsing-description2 =
    El { -brand-short-name } ha canviat el funcionament de les extensions en la navegació privada. Per defecte, les extensions noves que s'afegeixin al { -brand-short-name } no s'executaran en les finestres privades. Llevat que ho permeteu als paràmetres, l'extensió no funcionarà durant la navegació privada i no tindrà accés a les vostres activitats en línia. Hem fet aquest canvi per garantir la privadesa de la vostra navegació quan s'utilitzen les finestres privades.
    <label data-l10n-name="private-browsing-learn-more">Més informació sobre com gestionar els paràmetres de les extensions</label>

addon-category-discover = Recomanacions
addon-category-discover-title =
    .title = Recomanacions
addon-category-extension = Extensions
addon-category-extension-title =
    .title = Extensions
addon-category-theme = Temes
addon-category-theme-title =
    .title = Temes
addon-category-plugin = Connectors
addon-category-plugin-title =
    .title = Connectors
addon-category-dictionary = Diccionaris
addon-category-dictionary-title =
    .title = Diccionaris
addon-category-locale = Llengües
addon-category-locale-title =
    .title = Llengües
addon-category-available-updates = Actualitzacions disponibles
addon-category-available-updates-title =
    .title = Actualitzacions disponibles
addon-category-recent-updates = Actualitzacions recents
addon-category-recent-updates-title =
    .title = Actualitzacions recents

## These are global warnings

extensions-warning-safe-mode = El mode segur ha inhabilitat tots els complements.
extensions-warning-check-compatibility = La comprovació de compatibilitat dels complements no està habilitada. Pot ser que tingueu complements incompatibles.
extensions-warning-check-compatibility-button = Habilita
    .title = Habilita la comprovació de compatibilitat dels complements
extensions-warning-update-security = La comprovació de seguretat dels complements no està habilitada. Les actualitzacions podrien posar-vos en risc.
extensions-warning-update-security-button = Habilita
    .title = Habilita la comprovació de seguretat dels complements


## Strings connected to add-on updates

addon-updates-check-for-updates = Cerca actualitzacions
    .accesskey = C
addon-updates-view-updates = Visualitza les actualitzacions recents
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Actualitza els complements automàticament
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Reinicia tots els complements perquè s'actualitzen automàticament
    .accesskey = R
addon-updates-reset-updates-to-manual = Reinicia tots els complements perquè s'actualitzen manualment
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = S'estan actualitzant els complements
addon-updates-installed = S'han actualitzat els vostres complements.
addon-updates-none-found = No s'ha trobat cap actualització
addon-updates-manual-updates-found = Mostra les actualitzacions disponibles

## Add-on install/debug strings for page options menu

addon-install-from-file = Instal·la un complement des d'un fitxer…
    .accesskey = I
addon-install-from-file-dialog-title = Seleccioneu un complement per instal·lar
addon-install-from-file-filter-name = Complements
addon-open-about-debugging = Depura complements
    .accesskey = u

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gestiona les dreceres de les extensions
    .accesskey = G

shortcuts-no-addons = No teniu cap extensió activada.
shortcuts-no-commands = Les extensions següents no tenen dreceres:
shortcuts-input =
    .placeholder = Escriviu una drecera

shortcuts-pageAction = Activeu l'acció de la pàgina
shortcuts-sidebarAction = Mostra/amaga la barra lateral

shortcuts-modifier-mac = Cal incloure Ctrl, Alt o ⌘
shortcuts-modifier-other = Cal incloure Ctrl o Alt
shortcuts-invalid = La combinació no és vàlida
shortcuts-letter = Escriviu una lletra
shortcuts-system = Les dreceres del { -brand-short-name } no es poden substituir

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Drecera duplicada

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } ja s'utilitza com a drecera en més d’un cas. Les dreceres duplicades poden causar un comportament inesperat.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Ja s'utilitza en { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Mostra'n { $numberToShow } més
       *[other] Mostra'n { $numberToShow } més
    }

shortcuts-card-collapse-button = Mostra'n menys

header-back-button =
    .title = Vés arrere

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Les extensions i els temes són com les aplicacions per al navegador i vos permeten protegir les contrasenyes, baixar vídeos, trobar ofertes, blocar anuncis molestos, canviar com es veu el vostre navegador i molt més. Estos petits programes sovint són desenvolupats per tercers. Ací teniu una selecció <a data-l10n-name="learn-more-trigger">recomanada</a> pel { -brand-product-name } per aconseguir un nivell excepcional de seguretat, rendiment i funcionalitat.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Algunes d’aquestes recomanacions són personalitzades. Es basen en altres
    extensions que heu instal·lat, preferències del perfil i estadístiques d’ús.
discopane-notice-learn-more = Més informació

privacy-policy = Política de privadesa

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = per <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Usuaris: { $dailyUsers }
install-extension-button = Afig al { -brand-product-name }
install-theme-button = Instal·la el tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gestiona
find-more-addons = Cerqueu més complements

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Més opcions

## Add-on actions

report-addon-button = Informa
remove-addon-button = Elimina
# The link will always be shown after the other text.
remove-addon-disabled-button = No s'ha pogut eliminar. <a data-l10n-name="link">Per què?</a>
disable-addon-button = Desactiva
enable-addon-button = Activa
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activa
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferències
    }
details-addon-button = Detalls
release-notes-addon-button = Notes de la versió
permissions-addon-button = Permisos

extension-enabled-heading = Activades
extension-disabled-heading = Desactivades

theme-enabled-heading = Activat
theme-disabled-heading = Desactivats

plugin-enabled-heading = Activats
plugin-disabled-heading = Desactivats

dictionary-enabled-heading = Activats
dictionary-disabled-heading = Desactivats

locale-enabled-heading = Activat
locale-disabled-heading = Desactivats

ask-to-activate-button = Demana si vull activar-lo
always-activate-button = Activa'l sempre
never-activate-button = No l'activis mai

addon-detail-author-label = Autor
addon-detail-version-label = Versió
addon-detail-last-updated-label = Darrera actualització
addon-detail-homepage-label = Pàgina d'inici
addon-detail-rating-label = Valoració

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Valorat amb { NUMBER($rating, maximumFractionDigits: 1) } de 5 estrelles

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desactivat)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } valoració
       *[other] { $numberOfReviews } valoracions
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> s'ha eliminat.
pending-uninstall-undo-button = Desfés

addon-detail-updates-label = Permet actualitzacions automàtiques
addon-detail-updates-radio-default = Per defecte
addon-detail-updates-radio-on = Sí
addon-detail-updates-radio-off = No
addon-detail-update-check-label = Cerca actualitzacions
install-update-button = Actualitza

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Es permet en finestres privades
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Si ho permeteu, l'extensió tindrà accés a la vostra activitat a Internet encara que utilitzeu la navegació privada. <a data-l10n-name="learn-more">Més informació</a>
addon-detail-private-browsing-allow = Permet
addon-detail-private-browsing-disallow = No ho permetes

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = El { -brand-product-name } només recomana extensions que compleixen els nostres estàndards de seguretat i de rendiment
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Actualitzacions disponibles
recent-updates-heading = Actualitzacions recents

release-notes-loading = S'està carregant…
release-notes-error = S'ha produït un error en carregar les notes de la versió.

addon-permissions-empty = Esta extensió no necessita cap permís

recommended-extensions-heading = Extensions recomanades
recommended-themes-heading = Temes recomanats

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Vos sentiu creatiu? <a data-l10n-name="link">Creeu el vostre propi tema amb el Firefox Color.</a>

## Page headings

extension-heading = Gestioneu les extensions
theme-heading = Gestioneu els temes
plugin-heading = Gestioneu els connectors
dictionary-heading = Gestioneu els diccionaris
locale-heading = Gestioneu les llengües
updates-heading = Gestioneu les actualitzacions
discover-heading = Personalitzeu el { -brand-short-name }
shortcuts-heading = Gestioneu les dreceres de les extensions

default-heading-search-label = Cerqueu més complements
addons-heading-search-input =
    .placeholder = Cerca a addons.mozilla.org

addon-page-options-button =
    .title = Eines per a tots els complements
