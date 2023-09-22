# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = A extensão não pode ler ou alterar dados
origin-controls-quarantined =
    .label = Extensão sem permissão para ler e alterar dados
origin-controls-quarantined-status =
    .label = Extensão não permitida em sites restritos
origin-controls-quarantined-allow =
    .label = Permitir em sites restritos
origin-controls-options =
    .label = A extensão pode ler e alterar dados
origin-controls-option-all-domains =
    .label = Em todos os sites
origin-controls-option-when-clicked =
    .label = Somente quando clicado
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Sempre permitir em { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Não pode ler ou alterar dados neste site
origin-controls-state-quarantined = Não permitido pela { -vendor-short-name } neste site
origin-controls-state-always-on = Sempre pode ler e alterar dados neste site
origin-controls-state-when-clicked = Permissão necessária para ler e alterar dados
origin-controls-state-hover-run-visit-only = Executar apenas nesta visita
origin-controls-state-runnable-hover-open = Abrir extensão
origin-controls-state-runnable-hover-run = Executar extensão
origin-controls-state-temporary-access = Pode ler e alterar dados desta visita

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Permissão necessária
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Não permitido pela { -vendor-short-name } neste site
