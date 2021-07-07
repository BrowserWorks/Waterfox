# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Transferências
downloads-panel =
    .aria-label = Transferências

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Pausar
    .accesskey = P
downloads-cmd-resume =
    .label = Retomar
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Cancelar
downloads-cmd-cancel-panel =
    .aria-label = Cancelar

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Abrir pasta de destino
    .accesskey = p

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Mostrar no Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Abrir no visualizador do sistema
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Abrir sempre no visualizador do sistema
    .accesskey = m

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mostrar no Finder
           *[other] Abrir pasta de destino
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Mostrar no Finder
           *[other] Abrir pasta de destino
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Mostrar no Finder
           *[other] Abrir pasta de destino
        }

downloads-cmd-show-downloads =
    .label = Mostrar pasta de transferências
downloads-cmd-retry =
    .tooltiptext = Voltar a tentar
downloads-cmd-retry-panel =
    .aria-label = Voltar a tentar
downloads-cmd-go-to-download-page =
    .label = Ir para a página da transferência
    .accesskey = g
downloads-cmd-copy-download-link =
    .label = Copiar ligação da transferência
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Remover do histórico
    .accesskey = e
downloads-cmd-clear-list =
    .label = Limpar o painel de pré-visualização
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Limpar transferências
    .accesskey = t

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permitir transferência
    .accesskey = m

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Remover ficheiro

downloads-cmd-remove-file-panel =
    .aria-label = Remover ficheiro

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Remover ficheiro ou permitir transferência

downloads-cmd-choose-unblock-panel =
    .aria-label = Remover ficheiro ou permitir transferência

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Abrir ou remover ficheiro

downloads-cmd-choose-open-panel =
    .aria-label = Abrir ou remover ficheiro

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Mostrar mais informação

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Abrir ficheiro

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Recomeçar transferência

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Cancelar transferência

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Mostrar todas as transferências
    .accesskey = s

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalhes da transferência

downloads-clear-downloads-button =
    .label = Limpar transferências
    .tooltiptext = Limpa as transferências concluídas, canceladas e falhadas

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Não existem transferências.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Sem transferências para esta sessão.
