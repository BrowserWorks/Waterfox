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
remove-address-row-button =
    .title = Удалить поле { $type }
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
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } не является корректным адресом электронной почты
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } отсутствует в вашей адресной книге
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
pill-action-expand-list =
    .label = Развернуть список
    .accesskey = в

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Панель вложений
    .accesskey = а
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Вложить
    .tooltiptext = Добавить вложение ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder =
    .label = Добавить вложение…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Файл(ы)…
    .accesskey = ы
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Вложить файл(ы)…
    .accesskey = ж
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
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
expand-attachment-pane-tooltip =
    .tooltiptext = Показать панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Скрыть панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Добавить как вложение
        [few] Добавить как вложения
       *[many] Добавить как вложения
    }
drop-file-label-inline =
    { $count ->
        [one] Вставить в содержимое
        [few] Вставить в содержимое
       *[many] Вставить в содержимое
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Переместить в начало
move-attachment-left-panel-button =
    .label = Переместить влево
move-attachment-right-panel-button =
    .label = Переместить вправо
move-attachment-last-panel-button =
    .label = Переместить в конец
button-return-receipt =
    .label = Уведомление о прочтении
    .tooltiptext = Запросить уведомление о прочтении этого сообщения
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
consider-bcc-notification = { $count } адресата(ов) в полях «Кому» и «Копия» могут видеть адреса друг друга. Вы можете избежать раскрытия адресата(ов), используя вместо этого «Скрытую копию».

# Addressing Area

to-compose-address-row-label =
    .value = Кому
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Поле { to-compose-address-row-label.value }
    .accesskey = м
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Показать поле { to-compose-address-row-label.value } ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Копия
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Поле { cc-compose-address-row-label.value }
    .accesskey = я
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Показать поле { cc-compose-address-row-label.value } ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Скрытая копия
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Поле { bcc-compose-address-row-label.value }
    .accesskey = ы
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Показать поле { bcc-compose-address-row-label.value } ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = { $count } адресата(ов) в полях «Кому» и «Копия» увидят адреса друг друга. Вы можете избежать раскрытия адресата(ов), используя вместо этого «Скрытую копию».
many-public-recipients-bcc =
    .label = Использовать «Скрытую копию»
    .accesskey = п
many-public-recipients-ignore =
    .label = Позволить адресатам видеть адреса друг друга
    .accesskey = в

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Адрес электронной почты, соответствующий адресу в поле От:, не найден. Сообщение будет отправлено с использованием текущего адреса в поле От: и настроек адреса электронной почты { $identity }.
