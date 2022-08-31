# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Сжатие папок
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Сжать сейчас
    .buttonaccesskeyaccept = а
    .buttonlabelcancel = Напомнить позже
    .buttonaccesskeycancel = п
    .buttonlabelextra1 = Подробнее…
    .buttonaccesskeyextra1 = о

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } необходимо регулярно обслуживать файлы, чтобы повысить скорость работы с вашими почтовыми папками. Это позволит восстановить { $data } на диске и не изменит ваши сообщения. Чтобы { -brand-short-name } делал это в будущем автоматически, не выдавая запрос, установите флажок ниже, прежде чем выбрать «{ compact-dialog.buttonlabelaccept }».

compact-dialog-never-ask-checkbox =
    .label = В будущем автоматически сжимать папки
    .accesskey = б

