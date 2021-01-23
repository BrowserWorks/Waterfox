# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Xestor de complementos

addons-page-title = Xestor de complementos

list-empty-installed =
    .value = Nun tienes instaláu dengún complementu d'esta triba

list-empty-available-updates =
    .value = Nun s'alcontraron anovamientos

list-empty-recent-updates =
    .value = Apocayá nun anovesti dengún complementu

list-empty-find-updates =
    .label = Comprobar anovamientos

list-empty-button =
    .label = Deprendi más tocante a los complementos

show-unsigned-extensions-button =
    .label = Nun pudieron verificase delles estensiones

show-all-extensions-button =
    .label = Amosar toles estensiones

cmd-show-details =
    .label = Amosar más información
    .accesskey = A

cmd-find-updates =
    .label = Alcontrar anovamientos
    .accesskey = l

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencies
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = Usar tema
    .accesskey = U

cmd-disable-theme =
    .label = Dexar d'usar tema
    .accesskey = x

cmd-install-addon =
    .label = Instalar
    .accesskey = I

cmd-contribute =
    .label = Collaborar
    .accesskey = C
    .tooltiptext = Collaborar col desendolcu d'esti complementu

detail-version =
    .label = Versión

detail-last-updated =
    .label = Anovamientu caberu

detail-contributions-description = El desendolcador d'esti complementu pide qu'ayudes a sofitar el so desendolcu continuáu faciendo una contribución pequeña.

detail-update-type =
    .value = Anovamientos automáticos

detail-update-default =
    .label = Por defeutu
    .tooltiptext = Instalar anovamientos automáticamente namái si eso ye lo predeterminao

detail-update-automatic =
    .label = Sí
    .tooltiptext = Instalar anovamientos automáticamente

detail-update-manual =
    .label = Non
    .tooltiptext = Nun instalar automáticamente los anovamientos

detail-home =
    .label = Páxina d'aniciu

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Perfil del complementu

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Comprobar anovamientos
    .accesskey = C
    .tooltiptext = Comprobar anovamientos d'esti complementu

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencies
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Camudar les opciones d'esti complementu
           *[other] Camudar les preferencies d'esti complementu
        }

detail-rating =
    .value = Valoración

addon-restart-now =
    .label = Reaniciar agora

disabled-unsigned-heading =
    .value = Desactiváronse dellos complementos

disabled-unsigned-description = Nun se verificaron los complementos de darréu pa usase en { -brand-short-name }. Pues <label data-l10n-name="find-addons">alcontrar troqueos</label> o entrugar al desendolcador pa que los verifique.

disabled-unsigned-learn-more = Deprendi más tocante a los nuesos esfuercios p'ayudar a caltenete seguru en llinia.

disabled-unsigned-devinfo = Los desendolcadores interesaos en tener los complementos verificaos puen siguir lleendo'l nuesu <label data-l10n-name="learn-more">manual</label>.

plugin-deprecation-description = ¿Fáltate daqué? Dalgunos complementos yá nun tienen sofitu de { -brand-short-name }. <label data-l10n-name="learn-more">Deprendi más</label>

legacy-warning-show-legacy = Amosar estensiones heredaes

legacy-extensions =
    .value = Estensiones heredaes

legacy-extensions-description = Estes estensiones nun cumplen colos estándares actuales de { -brand-short-name } polo que tán desactivaes. <label data-l10n-name="legacy-learn-more">Deprendi tocante al cambéu nos complementos</label>

addon-category-discover = Aconséyase
addon-category-discover-title =
    .title = Aconséyase
addon-category-extension = Estensiones
addon-category-extension-title =
    .title = Estensiones
addon-category-theme = Temes
addon-category-theme-title =
    .title = Temes
addon-category-plugin = Complementos
addon-category-plugin-title =
    .title = Complementos
addon-category-dictionary = Diccionarios
addon-category-dictionary-title =
    .title = Diccionarios
addon-category-locale = Llingües
addon-category-locale-title =
    .title = Llingües
addon-category-available-updates = Anovamientos disponibles
addon-category-available-updates-title =
    .title = Anovamientos disponibles
addon-category-recent-updates = Anovamientos recientes
addon-category-recent-updates-title =
    .title = Anovamientos recientes

## These are global warnings

extensions-warning-safe-mode = El mou seguru desactivó tolos complementos.
extensions-warning-check-compatibility = La comprobación de compatibilidá de complementos ta desactivada. Pue que tengas complementos incompatibles.
extensions-warning-check-compatibility-button = Activar
    .title = Activar comprobación de compatibilidá de complementos
extensions-warning-update-security = La comprobación de seguranza de complementos ta desactivada. Los anovamientos podríen ser un riesgu.
extensions-warning-update-security-button = Activar
    .title = Activar comprobación de seguranza de complementos


## Strings connected to add-on updates

addon-updates-check-for-updates = Comprobar anovamientos
    .accesskey = C
addon-updates-view-updates = Ver anovamientos recientes
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Anovar complementos automáticamente
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Reafitar tolos complementos p'anovalos automáticamente
    .accesskey = R
addon-updates-reset-updates-to-manual = Reafitar tolos complementos p'anovalos a mano
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Anovando complementos
addon-updates-installed = Anováronse los complementos.
addon-updates-none-found = Nun s'alcontraron anovamientos
addon-updates-manual-updates-found = Ver anovamientos disponibles

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar complementu dende ficheru…
    .accesskey = I
addon-install-from-file-dialog-title = Esbilla'l compltementu pa instalar
addon-install-from-file-filter-name = Complementos
addon-open-about-debugging = Depurar complementos
    .accesskey = D

## Extension shortcut management


## Recommended add-ons page


## Add-on actions

extension-enabled-heading = Activóse

theme-enabled-heading = Activóse

plugin-enabled-heading = Activóse

dictionary-enabled-heading = Activóse

locale-enabled-heading = Activóse

## Pending uninstall message bar

recommended-extensions-heading = Estensiones aconseyaes
recommended-themes-heading = Estilos aconseyaos

## Page headings

extension-heading = Xestión d'estensiones
theme-heading = Xestión d'estilos
plugin-heading = Xestión de plugins
dictionary-heading = Xestión de diccionarios
locale-heading = Xestión de llingües

addon-page-options-button =
    .title = Ferramientes pa tolos complementos
