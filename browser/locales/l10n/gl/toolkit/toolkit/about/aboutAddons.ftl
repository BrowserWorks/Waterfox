# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Xestor de complementos
addons-page-title = Xestor de complementos
search-header =
    .placeholder = Buscar en addons.mozilla.org
    .searchbuttonlabel = Buscar
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = Non ten instalado ningún complemento deste tipo
list-empty-available-updates =
    .value = Non se atoparon actualizacións
list-empty-recent-updates =
    .value = Recentemente non actualizou ningún complemento
list-empty-find-updates =
    .label = Buscar actualizacións
list-empty-button =
    .label = Saber máis sobre os complementos
help-button = Asistencia dos módulos
sidebar-help-button-title =
    .title = Asistencia dos módulos
preferences =
    { PLATFORM() ->
        [windows] Opcións de { -brand-short-name }
       *[other] Preferencias de { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Opcións de { -brand-short-name }
           *[other] Preferencias de { -brand-short-name }
        }
show-unsigned-extensions-button =
    .label = Non foi posíbel comprobar algunhas extensións
show-all-extensions-button =
    .label = Amosar todas as extensións
cmd-show-details =
    .label = Amosar máis información
    .accesskey = s
cmd-find-updates =
    .label = Buscar actualizacións
    .accesskey = B
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcións
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = Pór o tema
    .accesskey = P
cmd-disable-theme =
    .label = Quitar o tema
    .accesskey = Q
cmd-install-addon =
    .label = Instalar
    .accesskey = I
cmd-contribute =
    .label = Colabore
    .accesskey = C
    .tooltiptext = Colabore co desenvolvemento deste complemento
detail-version =
    .label = Versión
detail-last-updated =
    .label = Última actualización
detail-contributions-description = O desenvolvedor solicítalle unha pequena doazón para axudar a continuar o desenvolvemento deste complemento.
detail-contributions-button = Colabore
    .title = Colabore no desenvolvemento deste complemento
    .accesskey = C
detail-update-type =
    .value = Actualizacións automáticas
detail-update-default =
    .label = Predeterminado
    .tooltiptext = Instalar actualizacións automaticamente só se isto é o valor predeterminado
detail-update-automatic =
    .label = Si
    .tooltiptext = Instalar actualizacións automaticamente
detail-update-manual =
    .label = Desactivado
    .tooltiptext = Non instalar actualizacións automaticamente
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Executar en xanelas privadas
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Non se admite en xanelas privadas
detail-private-disallowed-description2 = Esta extensión non se executa durante a navegación privada. <a data-l10n-name="learn-more">Saiba máis</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Require acceso a xanelas privadas
detail-private-required-description2 = Esta extensión ten acceso ás súas actividades en liña mentres navega de xeito privado. <a data-l10n-name="learn-more">Saiba máis</a>
detail-private-browsing-on =
    .label = Permitir
    .tooltiptext = Permitir durante a navegación privada
detail-private-browsing-off =
    .label = Non permitir
    .tooltiptext = Desactivar durante a navegación en privado
detail-home =
    .label = Páxina de inicio
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Perfil do complemento
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Buscar actualizacións
    .accesskey = B
    .tooltiptext = Buscar actualizacións para este complemento
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcións
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Cambiar as opcións deste complemento
           *[other] Modificar as preferencias deste complemento
        }
detail-rating =
    .value = Puntuación
addon-restart-now =
    .label = Reiniciar agora
disabled-unsigned-heading =
    .value = Desactiváronse algúns complementos
disabled-unsigned-description = Os seguintes complementos non se comprobaron para o seu uso en { -brand-short-name }. Pode <label data-l10n-name="find-addons">atopar substitutos</label> ou pedirlle ao desenvolvedor que consiga que sexan verificados.
disabled-unsigned-learn-more = Obteña máis información sobre os nosos esforzos para axudalo a manterse seguro en liña.
disabled-unsigned-devinfo = Os desenvolvedores interesados en conseguir que os seus complementos sexa verificados poden continuar lendo o noso <label data-l10n-name="learn-more">manual</label>.
plugin-deprecation-description = Bota en falta algo? Algúns engadidos xa non son compatíbeis co { -brand-short-name }. <label data-l10n-name="learn-more">Máis información.</label>
legacy-warning-show-legacy = Amosar as extensións herdadas
legacy-extensions =
    .value = Extensións herdadas
legacy-extensions-description = Estas extensións non cumpren os estándares actuais de { -brand-short-name }, así que foron desactivadas. <label data-l10n-name="legacy-learn-more">Máis información sobre os cambios nos complementos</label>
private-browsing-description2 =
    { -brand-short-name } está a cambiar o funcionamento das extensións na navegación privada. Ningunha das extensións que engada
    { -brand-short-name } se executará por omisión nas xanelas privadas. A menos que o permita nos axustes, a
    extensión non funcionará durante a navegación privada e non terá acceso ás súas actividades na rede
    alí. Fixemos este cambio para manter a navegación privada privada.
    <label data-l10n-name = "private-browsing-learn-more"> Aprenda a xestionar a configuración de extensións </label>
addon-category-discover = Recomendacións
addon-category-discover-title =
    .title = Recomendacións
addon-category-extension = Extensións
addon-category-extension-title =
    .title = Extensións
addon-category-theme = Temas
addon-category-theme-title =
    .title = Temas
addon-category-plugin = Engadidos
addon-category-plugin-title =
    .title = Engadidos
addon-category-dictionary = Dicionarios
addon-category-dictionary-title =
    .title = Dicionarios
addon-category-locale = Idiomas
addon-category-locale-title =
    .title = Idiomas
addon-category-available-updates = Actualizacións dispoñíbeis
addon-category-available-updates-title =
    .title = Actualizacións dispoñíbeis
addon-category-recent-updates = Actualizacións recentes
addon-category-recent-updates-title =
    .title = Actualizacións recentes

## These are global warnings

extensions-warning-safe-mode = O modo seguro desactivou todos os complementos.
extensions-warning-check-compatibility = A verificación de compatibilidade de complementos está desactivada. Pode ter complementos incompatíbeis.
extensions-warning-check-compatibility-button = Activar
    .title = Activar a verificación de compatibilidade de complementos
extensions-warning-update-security = A verificación da seguranza das actualizacións dos complementos está desactivada. Pode estar en risco coas actualizacións.
extensions-warning-update-security-button = Activar
    .title = Activar a verificación da seguranza das actualizacións dos complementos

## Strings connected to add-on updates

addon-updates-check-for-updates = Buscar actualizacións
    .accesskey = c
addon-updates-view-updates = Ver actualizacións recentes
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Actualizar os complementos automaticamente
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Restabelecer todos os complementos para actualizalos automaticamente
    .accesskey = R
addon-updates-reset-updates-to-manual = Restabelecer todos os complementos para actualizalos manualmente
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Actualizando os complementos
addon-updates-installed = Actualizáronse os seus complementos.
addon-updates-none-found = Non se atoparon actualizacións
addon-updates-manual-updates-found = Ver actualizacións dispoñíbeis

## Add-on install/debug strings for page options menu

addon-install-from-file = Instalar complemento desde o ficheiro…
    .accesskey = I
addon-install-from-file-dialog-title = Seleccionar o complemento para instalar
addon-install-from-file-filter-name = Complementos
addon-open-about-debugging = Depurar complementos
    .accesskey = d

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Xestionar atallos de extensións
    .accesskey = X
shortcuts-no-addons = Non ten habilitada ningunha extensión.
shortcuts-no-commands = As seguintes extensións non teñen atallos:
shortcuts-input =
    .placeholder = Escriba un atallo
shortcuts-browserAction2 = Activar o botón da barra de ferramentas
shortcuts-pageAction = Activar a acción da páxina
shortcuts-sidebarAction = Alternar a barra lateral
shortcuts-modifier-mac = Incluír Ctrl, Alt ou ⌘
shortcuts-modifier-other = Incluír Ctrl ou Alt
shortcuts-invalid = A combinación non é válida
shortcuts-letter = Escriba unha letra
shortcuts-system = Non é posíbel anular un atallo de { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Atallo duplicado
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } utilízase como atallo en máis dun caso. Os atallos duplicados poden causar comportamentos inesperados.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Xa está en uso por { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Amosar { $numberToShow } máis
       *[other] Amosar { $numberToShow } máis
    }
shortcuts-card-collapse-button = Amosar menos
header-back-button =
    .title = Retroceder

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    As extensións e os temas son como aplicativos para o seu navegador e permítenlle
    protexer contrasinais, descargar vídeos, atopar ofertas, bloquear anuncios molestos, cambiar
    como semella o seu navegador e moito máis. Estes pequenos programas son
    a miúdo desenvolvidos por un terceiro. Aquí ten unha selección { -brand-product-name }
    <a data-l10n-name="learn-more-trigger"> recomendada </a> para excepcionais
    seguridade, rendemento e funcionalidade.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Algunhas destas recomendacións son personalizadas. Baséanse noutros
    extensións que instalou, preferencias do perfil e estatísticas de uso.
discopane-notice-learn-more = Máis información
privacy-policy = Política de privacidade
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = por <a data-l10n-name="author"> { $author } </a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Usuarios: { $dailyUsers }
install-extension-button = Engadir a { -brand-product-name }
install-theme-button = Instalar o tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Xestionar
find-more-addons = Atopar máis complementos
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Máis opcións

## Add-on actions

report-addon-button = Informar
remove-addon-button = Eliminar
# The link will always be shown after the other text.
remove-addon-disabled-button = Non é posíbel eliminar <a data-l10n-name="link">Por que?</a>
disable-addon-button = Desactivar
enable-addon-button = Activar
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activar
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opcións
       *[other] Preferencias
    }
details-addon-button = Detalles
release-notes-addon-button = Notas da versión
permissions-addon-button = Permisos
extension-enabled-heading = Activado
extension-disabled-heading = Desactivado
theme-enabled-heading = Activado
theme-disabled-heading = Desactivado
plugin-enabled-heading = Activado
plugin-disabled-heading = Desactivado
dictionary-enabled-heading = Activado
dictionary-disabled-heading = Desactivado
locale-enabled-heading = Activado
locale-disabled-heading = Desactivado
ask-to-activate-button = Preguntar para activar
always-activate-button = Activar sempre
never-activate-button = Non activar nunca
addon-detail-author-label = Autor
addon-detail-version-label = Versión
addon-detail-last-updated-label = Última actualización
addon-detail-homepage-label = Páxina de inicio
addon-detail-rating-label = Puntuación
# Message for add-ons with a staged pending update.
install-postponed-message = Esta extensión actualizarase ao reiniciar o { -brand-short-name }.
install-postponed-button = Actualizar agora
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Puntuación { NUMBER($rating, maximumFractionDigits: 1) } sobre 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (desactivado)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] Comentario de { $numberOfReviews }
       *[other] Comentarios de { $numberOfReviews }
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Eliminouse <span data-l10n-name = "addon-name"> { $addon } </span>.
pending-uninstall-undo-button = Desfacer
addon-detail-updates-label = Permitir actualizacións automáticas
addon-detail-updates-radio-default = Predeterminado
addon-detail-updates-radio-on = Activado
addon-detail-updates-radio-off = Desactivado
addon-detail-update-check-label = Buscar actualizacións
install-update-button = Actualizar
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Permitido nas xanelas privadas
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Se o permiten, a extensión terá acceso ás súas actividades en liña mentres navega privadamente. <a data-l10n-name="learn-more"> Máis información </a>
addon-detail-private-browsing-allow = Permitir
addon-detail-private-browsing-disallow = Non permitir
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } só recomenda extensións que cumpran os nosos estándares de seguridade e rendemento
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = Actualizacións dispoñíbeis
recent-updates-heading = Actualizacións recentes
release-notes-loading = Cargando…
release-notes-error = Sentímolo, pero produciuse un erro ao cargar as notas do lanzamento.
addon-permissions-empty = Esta extensión non require ningún permiso
recommended-extensions-heading = Extensións recomendadas
recommended-themes-heading = Temas recomendados
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Séntese creativo? <a data-l10n-name="link">Cree o seu propio tema con Firefox Color.</a>

## Page headings

extension-heading = Xestione as súas extensións
theme-heading = Xestione os seus temas
plugin-heading = Xestione os seus engadidos
dictionary-heading = Xestione os seus dicionarios
locale-heading = Xestione os seus idiomas
updates-heading = Xestione as súas actualizacións
discover-heading = Personalice o seu { -brand-short-name }
shortcuts-heading = Xestionar atallos de extensións
default-heading-search-label = Atopar máis complementos
addons-heading-search-input =
    .placeholder = Buscar en addons.mozilla.org
addon-page-options-button =
    .title = Ferramentas para todos os complementos
