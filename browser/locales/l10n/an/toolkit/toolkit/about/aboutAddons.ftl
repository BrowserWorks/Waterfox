# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Chestor de complementos

addons-page-title = Chestor de complementos

search-header =
    .placeholder = Mirar en addons.mozilla.org
    .searchbuttonlabel = Mirar

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = No tiene instalau garra complemento d'ista mena

list-empty-available-updates =
    .value = No s'ha trobau garra actualización

list-empty-recent-updates =
    .value = No ha actualizau recientment garra complemento

list-empty-find-updates =
    .label = Mirar si i hai actualizacions

list-empty-button =
    .label = Trobe más información d'os complementos

help-button = Asistencia d'os complementos

sidebar-help-button-title =
    .title = Asistencia d'os complementos

preferences =
    { PLATFORM() ->
        [windows] Opcions de { -brand-short-name }
       *[other] Preferencias de { -brand-short-name }
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opcions de { -brand-short-name }
           *[other] Preferencias de { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = No s'ha puesto verificar bellas extensions

show-all-extensions-button =
    .label = Amostrar todas as extensions

cmd-show-details =
    .label = Amostrar mas información
    .accesskey = A

cmd-find-updates =
    .label = Mirar actualizacions
    .accesskey = M

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Emplegar o tema
    .accesskey = m

cmd-disable-theme =
    .label = Deixar d'emplegar o tema
    .accesskey = p

cmd-install-addon =
    .label = Instalar
    .accesskey = I

cmd-contribute =
    .label = Colaborar-ie
    .accesskey = C
    .tooltiptext = Colaborar en o desembolique d'iste complemento

detail-version =
    .label = Versión

detail-last-updated =
    .label = Zaguera actualización

detail-contributions-description = O desembolicador d'iste complemento solicita que le aduyes a continar con o suyo desembolique fendo una chicota donación.

detail-update-type =
    .value = Actualizacions automaticas

detail-update-default =
    .label = Por defecto
    .tooltiptext = Instalar automaticament as actualizacions nomás si ixe ye o comportamiento por defecto

detail-update-automatic =
    .label = Enchegadas
    .tooltiptext = Instalar as actualizacions automaticament

detail-update-manual =
    .label = Desenchegadas
    .tooltiptext = No instalar as actualizacions automaticament

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Executar en finestras privadas

detail-private-browsing-on =
    .label = Permitir
    .tooltiptext = Activar en navegación privada

detail-private-browsing-off =
    .label = No permitir
    .tooltiptext = Desactivar en navegación privada

detail-home =
    .label = Pachina d'inicio

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil d'o complemento

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Mirar si i hai actualizacions
    .accesskey = M
    .tooltiptext = Mirar si i hai actualizacions d'este complemento

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Cambiar as opciones d'iste complemento
           *[other] Cambiar as preferencias d'iste complemento
        }

detail-rating =
    .value = Puntuación

addon-restart-now =
    .label = Reiniciar agora

disabled-unsigned-heading =
    .value = Bells complementos s'han desactivau

disabled-unsigned-description = Os siguients complementos no s'han puesto verificar pa o suyo uso en { -brand-short-name }. Puetz <label data-l10n-name="find-addons">trobar alternativas</label> u demandar a o desenrollador que las faiga verificar.

disabled-unsigned-learn-more = Aprender mas sobre os nuestros esfuerzos ta aduyar-le a estar seguro en linia.

disabled-unsigned-devinfo = Os desenrolladors interesaus en fer verificar os suyos complementos pueden seguir leyendo o nuestro <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = Falta cosa? { -brand-short-name } ha deixau de soportar bells plugins. <label data-l10n-name="learn-more">Aprende-ne mas.</label>

legacy-warning-show-legacy = Amostrar las extensions obsoletas

legacy-extensions =
    .value = Extensions obsoletas

legacy-extensions-description = Estas extensions no respondern a las exichencias actuals de { -brand-short-name }, pero lo qual s'han desactivau. <label data-l10n-name="legacy-learn-more">Saber mas sobre los cambios en as extensions</label>

addon-category-extension = Extensions
addon-category-extension-title =
    .title = Extensions
addon-category-theme = Temas
addon-category-theme-title =
    .title = Temas
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Diccionarios
addon-category-dictionary-title =
    .title = Diccionarios
addon-category-locale = Luengas
addon-category-locale-title =
    .title = Luengas
addon-category-available-updates = Actualizacions disponibles
addon-category-available-updates-title =
    .title = Actualizacions disponibles
addon-category-recent-updates = Actualizacions recients
addon-category-recent-updates-title =
    .title = Actualizacions recients

## These are global warnings

extensions-warning-safe-mode = O modo seguro ha desactivau totz os complementos.
extensions-warning-check-compatibility = A comprebación de compatibilidad d'os complementos ye desactivada. Puestar tienga complementos incompatibles.
extensions-warning-check-compatibility-button = Activar
    .title = Activar a comprebación de compatibilidad d'os complementos
extensions-warning-update-security = A comprebación de seguranza d'os complementos ye desactivada. As actualizacions podrían meter-le en risque.
extensions-warning-update-security-button = Activar
    .title = Activar a comprebación de seguranza d'os complementos


## Strings connected to add-on updates

addon-updates-check-for-updates = Mirar si i hai actualizacions
    .accesskey = M
addon-updates-view-updates = Veyer as actualizacions recients
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Esviellar os complementos automaticament
    .accesskey = E

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Reiniciar totz os complementos ta que s'esviellen automaticament
    .accesskey = R
addon-updates-reset-updates-to-manual = Reiniciar totz os complementos ta que s'esviellen manualment
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Se son actualizando os complementos
addon-updates-installed = S'han actualizau os suyos complementos.
addon-updates-none-found = No s'ha trobau garra actualización
addon-updates-manual-updates-found = Veyer as actualizacions disponibles

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar un complemento dende un fichero…
    .accesskey = I
addon-install-from-file-dialog-title = Seleccionar un complemento ta instalar
addon-install-from-file-filter-name = Complementos
addon-open-about-debugging = Depurar complementos
    .accesskey = p

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addons-heading-search-input =
    .placeholder = Mirar en addons.mozilla.org

addon-page-options-button =
    .title = Ainas ta totz os complementos
