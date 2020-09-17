# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gestô di conponenti azonti

addons-page-title = Gestô di conponenti azonti

search-header =
    .placeholder = Çerca in addons.mozilla.org
    .searchbuttonlabel = Çerca

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Ti no gh'æ di conponenti azonti de sto tipo instalæ

list-empty-available-updates =
    .value = Nisciun agiornamento trovou

list-empty-recent-updates =
    .value = Urtimamente ti no t'æ agiornou nisciun conponente azonto

list-empty-find-updates =
    .label = Çerca agiornamenti

list-empty-button =
    .label = Ciù informaçioin in sci conponenti azonti

help-button = Sopòrto conponenti azonti

sidebar-help-button-title =
    .title = Sopòrto conponenti azonti

show-unsigned-extensions-button =
    .label = No ò posciuo verificâ quarche estenscion

show-all-extensions-button =
    .label = Amia tutte e estenscioin

cmd-show-details =
    .label = Fanni vedde ciù informaçioin
    .accesskey = F

cmd-find-updates =
    .label = Treuva agiornamento
    .accesskey = T

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inpostaçioin
           *[other] Preferense
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] P
        }

cmd-enable-theme =
    .label = Metti o Tema
    .accesskey = M

cmd-disable-theme =
    .label = Leva o Tema
    .accesskey = L

cmd-install-addon =
    .label = Installa
    .accesskey = I

cmd-contribute =
    .label = Agiutta
    .accesskey = A
    .tooltiptext = Agiutta a svilupâ sto conponente azonto

detail-version =
    .label = Verscion

detail-last-updated =
    .label = Agiornou

detail-contributions-description = O svilupatô de sto conponente azonto te domanda se t'eu contriboî con quarche palanca.

detail-update-type =
    .value = Agiornamenti aotomatichi

detail-update-default =
    .label = Predefinio
    .tooltiptext = Installa i agiornamenti in aotomatico solo se o l'é predefinio coscî

detail-update-automatic =
    .label = Açendi
    .tooltiptext = Installa i agiornamenti in aotomatico

detail-update-manual =
    .label = Asmòrtou
    .tooltiptext = No instalâ agiornamenti in aotomatico

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Ezegoçion inti barcoin privæ

detail-private-browsing-on =
    .label = Permetti
    .tooltiptext = Permetti inta Navegaçion privâ

detail-private-browsing-off =
    .label = No permette
    .tooltiptext = Dizabilita inta Navegaçion privâ

detail-home =
    .label = Pagina Prinçipâ

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profî do conponente azonto

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Çerca agiornamenti
    .accesskey = a
    .tooltiptext = Çerca agiornamenti pe sto conponente azonto

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inpostaçioin
           *[other] Preferense
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Cangia e preferense de sto conponente azonto
           *[other] Cangia e preferense de sto conponente azonto
        }

detail-rating =
    .value = Clasifica

addon-restart-now =
    .label = Arvi torna òua

disabled-unsigned-heading =
    .value = Quarche conponente azonto o l'é dizativou

disabled-unsigned-description = Sti conponenti no en verificæ pe deuviali in { -brand-short-name }. L'é poscibile <label data-l10n-name="find-addons">çercâ de alternative</label> ò domandâ a-o svilupatô de fali verificâ.

disabled-unsigned-learn-more = Descovri atre informaçoin in sciô nòstro inpegno pe garantî a seguessa di utenti in linia.

disabled-unsigned-devinfo = I svilupatoî interesæ a-o processo de verifica di conponenti azonti peuan amiâ o segoente <label data-l10n-name="learn-more">manuâ</label>.

plugin-deprecation-description = Te manca quarcösa? Quarche plugin o no l'é ciù soportou da { -brand-short-name }. <label data-l10n-name="learn-more">Ciù informaçioin.</label>

legacy-warning-show-legacy = Amia estenscioin legacy

legacy-extensions =
    .value = Estenscioin Legacy

legacy-extensions-description = Ste estenscioin no va ben co-i corenti standard de { -brand-short-name } coscì en stæti dizativæ. <label data-l10n-name="legacy-learn-more">Pe saveine de ciù in sci conponenti azonti</label>

addon-category-extension = Estenscioin
addon-category-extension-title =
    .title = Estenscioin
addon-category-theme = Temi
addon-category-theme-title =
    .title = Temi
addon-category-plugin = Plugin
addon-category-plugin-title =
    .title = Plugin
addon-category-dictionary = Diçionai
addon-category-dictionary-title =
    .title = Diçionai
addon-category-locale = Lengoe
addon-category-locale-title =
    .title = Lengoe
addon-category-available-updates = Agiornamenti disponibili
addon-category-available-updates-title =
    .title = Agiornamenti disponibili
addon-category-recent-updates = Urtimi agiornamenti
addon-category-recent-updates-title =
    .title = Urtimi agiornamenti

## These are global warnings

extensions-warning-safe-mode = Tutti i conponenti azonti son stæti dizabilitæ da o moddo seguo.
extensions-warning-check-compatibility = O contròllo de conpatibilitæ di conponenti azonti l'é dizabilita. Ti peu avei di conponenti azonti no conpatibili.
extensions-warning-check-compatibility-button = Abilita
    .title = Abilita o contròllo a conpatibilitæ di conponenti azonti
extensions-warning-update-security = O contròllo de seguessa in sci agiornamenti di conponenti azonti o l'é dizabilitou. Te peu capitâ de ese aroinou da i agiornamenti.
extensions-warning-update-security-button = Abilita
    .title = Abilita o contròllo de seguessa in sci agiornamenti di conponenti azonti


## Strings connected to add-on updates

addon-updates-check-for-updates = Çerca agiornamenti
    .accesskey = c
addon-updates-view-updates = Fanni vedde i urtimi agiornamenti
    .accesskey = v

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Agiorna i conponenti azonti in aotomatico
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Reinpòsta tutti i conponenti azonti pe agiornali in aotomatico
    .accesskey = R
addon-updates-reset-updates-to-manual = Reinpòsta tutti i conponenti azonti pe agiornali a man
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Agiorno i conponenti azonti
addon-updates-installed = I teu conponenti azonti son stæti agiornæ.
addon-updates-none-found = Nisciun agiornamento trovou
addon-updates-manual-updates-found = Fanni vedde i agiornamenti disponibili

## Add-on install/debug strings for page options menu

addon-install-from-file = Installa i conponenti azonti da 'n schedaio…
    .accesskey = I
addon-install-from-file-dialog-title = Seleçionn-a i conponenti da instalâ
addon-install-from-file-filter-name = Conponenti azonti
addon-open-about-debugging = Debug di conponenti azonti
    .accesskey = B

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gestisci scorsaeiu de estenscioin
    .accesskey = G

shortcuts-input =
    .placeholder = Inserisci 'n scorsaieu

shortcuts-pageAction = Ativa açion da pagina
shortcuts-sidebarAction = Ativa/dizativa bara de scianco

shortcuts-modifier-mac = Includde Ctrl, Alt, ò ⌘
shortcuts-modifier-other = Includde Ctrl ò Alt
shortcuts-invalid = Conbinaçion no bonn-a
shortcuts-letter = Scrivi 'na letia

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Fanni vedde l'atro
       *[other] Fanni vedde atri { $numberToShow }
    }

shortcuts-card-collapse-button = Mostra meno

header-back-button =
    .title = Vanni inderê

## Recommended add-ons page


## Add-on actions

remove-addon-button = Scancella
disable-addon-button = Dizabilita
enable-addon-button = Abilita
permissions-addon-button = Permissi

## Pending uninstall message bar


## Page headings

extension-heading = Gestisci estenscioin
theme-heading = Gestisci i Temi
plugin-heading = Gestisci i plugin
dictionary-heading = Gestisci i diçionai
locale-heading = Gestisci e lengoe
shortcuts-heading = Gestisci scorsaeiu de estenscioin

addons-heading-search-input =
    .placeholder = Çerca in addons.mozilla.org

addon-page-options-button =
    .title = Angæsi pe tutti i conponenti azonti
