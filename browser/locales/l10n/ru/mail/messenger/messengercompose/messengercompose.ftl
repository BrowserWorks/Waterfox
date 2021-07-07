# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

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
add-attachment-notification-reminder2 =
    .label = Добавить вложение…
    .accesskey = л
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
expand-attachment-pane-tooltip =
    .tooltiptext = Показать панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Скрыть панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-show =
    .title = Показать панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Скрыть панель вложений ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
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

# Encryption

message-to-be-signed-icon =
    .alt = Подписать сообщение
message-to-be-encrypted-icon =
    .alt = Зашифровать сообщение

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
to-address-row-label =
    .value = Кому
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Поле «Кому»
    .accesskey = м
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Кому
    .accesskey = м
#   $key (String) - the shortcut key for this field
show-to-row-button = Кому
    .title = Показать поле «Кому» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Копия
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Поле «Копия»
    .accesskey = п
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Копия
    .accesskey = п
#   $key (String) - the shortcut key for this field
show-cc-row-button = Копия
    .title = Показать поле «Копия» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Скрытая копия
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Поле «Скрытая копия»
    .accesskey = ы
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Скрытая копия
    .accesskey = ы
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Скрытая копия
    .title = Показать поле «Скрытая копия» ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Другие отображаемые поля для адреса
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] В вашем сообщении есть публичный адресат. Вы можете избежать раскрытия адресата, используя вместо этого «Скрытую копию».
        [few] { $count } адресата в полях «Кому» и «Копия» увидят адреса друг друга. Вы можете избежать раскрытия адресатов, используя вместо этого «Скрытую копию».
       *[many] { $count } адресатов в полях «Кому» и «Копия» увидят адреса друг друга. Вы можете избежать раскрытия адресатов, используя вместо этого «Скрытую копию».
    }
many-public-recipients-bcc =
    .label = Использовать «Скрытую копию»
    .accesskey = п
many-public-recipients-ignore =
    .label = Позволить адресатам видеть адреса друг друга
    .accesskey = в
many-public-recipients-prompt-title = Слишком много публичных адресатов
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] У вашего сообщения есть публичный адресат. Это может вызвать проблему с приватностью. Вы можете избежать раскрытия адресата, переместив его из «Кому»/«Копия» в «Скрытую копию».
        [few] У вашего сообщения есть { $count } публичных адресата, которые смогут видеть адреса друг друга. Это может вызвать проблему с приватностью. Вы можете избежать раскрытия адресатов, переместив их из «Кому»/«Копия» в «Скрытую копию».
       *[many] У вашего сообщения есть { $count } публичных адресатов, которые смогут видеть адреса друг друга. Это может вызвать проблему с приватностью. Вы можете избежать раскрытия адресатов, переместив их из «Кому»/«Копия» в «Скрытую копию».
    }
many-public-recipients-prompt-cancel = Отменить отправку
many-public-recipients-prompt-send = Всё равно отправить

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Адрес электронной почты, соответствующий адресу в поле От:, не найден. Сообщение будет отправлено с использованием текущего адреса в поле От: и настроек адреса электронной почты { $identity }.
encrypted-bcc-warning = При отправке зашифрованного сообщения получатели в поле «Скрытая копия» скрыты не полностью. Их могут идентифицировать все получатели.
encrypted-bcc-ignore-button = Понятно

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Удалить стиль текста
