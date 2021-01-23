# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Удалить поле { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Удалить поле { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } с { $count } адресом, используйте клавишу «Стрелка влево», чтобы сфокусироваться на них.
        [few] { $type } с { $count } адресами, используйте клавишу «Стрелка влево», чтобы сфокусироваться на них.
       *[many] { $type } с { $count } адресами, используйте клавишу «Стрелка влево», чтобы сфокусироваться на них.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }, 1 из { $count }: нажмите Enter, чтобы изменить; Delete, чтобы удалить.
        [few] { $email }, 1 из { $count }: нажмите Enter, чтобы изменить; Delete, чтобы удалить.
       *[many] { $email }, 1 из { $count }: нажмите Enter, чтобы изменить; Delete, чтобы удалить.
    }

pill-action-edit =
    .label = Изменить адрес
    .accesskey = м

pill-action-move-to =
    .label = Переместить в Кому
    .accesskey = о

pill-action-move-cc =
    .label = Переместить в Копию
    .accesskey = ю

pill-action-move-bcc =
    .label = Переместить в Скрытую копию
    .accesskey = ы

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } вложение
            [one] { $count } вложение
            [few] { $count } вложения
           *[many] { $count } вложений
        }
    .accesskey = в

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } вложение
            [one] { $count } вложение
            [few] { $count } вложения
           *[many] { $count } вложений
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Уведомление о прочтении
    .tooltiptext = Запросить уведомление о прочтении этого сообщения
