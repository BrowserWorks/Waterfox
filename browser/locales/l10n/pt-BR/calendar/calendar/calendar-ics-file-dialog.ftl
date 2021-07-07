# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

calendar-ics-file-window-2 =
    .title = Importar eventos e tarefas da agenda
calendar-ics-file-dialog-import-event-button-label = Importar eventos
calendar-ics-file-dialog-import-task-button-label = Importar tarefas
calendar-ics-file-dialog-2 =
    .buttonlabelaccept = Importar tudo
calendar-ics-file-accept-button-ok-label = OK
calendar-ics-file-cancel-button-close-label = Fechar
calendar-ics-file-dialog-message-2 = Importar de arquivo:
calendar-ics-file-dialog-calendar-menu-label = Importar para a agenda:
calendar-ics-file-dialog-items-loading-message =
    .value = Carregando itens…
calendar-ics-file-dialog-search-input =
    .placeholder = Filtrar itens…
calendar-ics-file-dialog-sort-start-ascending =
    .label = Ordenar por data de início (primeira para última)
calendar-ics-file-dialog-sort-start-descending =
    .label = Ordenar por data de início (última para primeira)
# "A > Z" is used as a concise way to say "alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-ascending =
    .label = Ordenar por título (A > Z)
# "Z > A" is used as a concise way to say "reverse alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-descending =
    .label = Ordenar por título (Z > A)
calendar-ics-file-dialog-progress-message = Importando…
calendar-ics-file-import-success = Importado com sucesso!
calendar-ics-file-import-error = Houve um erro e a importação falhou.
calendar-ics-file-import-complete = Importação concluída.
calendar-ics-file-import-duplicates =
    { $duplicatesCount ->
        [one] Um item foi ignorado porque já existe na agenda de destino.
       *[other] { $duplicatesCount } itens foram ignorados porque já existem na agenda de destino.
    }
calendar-ics-file-import-errors =
    { $errorsCount ->
        [one] Falhou a importação de um item. Veja detalhes no console de erros.
       *[other] Falhou a importação de { $errorsCount } itens. Veja detalhes no console de erros.
    }
calendar-ics-file-dialog-no-calendars = Não há agendas que possam importar eventos ou tarefas.
