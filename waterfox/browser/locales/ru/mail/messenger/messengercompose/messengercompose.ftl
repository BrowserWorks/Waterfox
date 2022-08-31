# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Формат исходящей почты
    .accesskey = Ф
compose-send-auto-menu-item =
    .label = Автоматический
    .accesskey = А
compose-send-both-menu-item =
    .label = HTML и обычный текст
    .accesskey = и
compose-send-html-menu-item =
    .label = Только HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Только обычный текст
    .accesskey = о

## Addressing widget

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
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Выбрать все адреса в { $type }
    .accesskey = ы
pill-action-select-all-pills =
    .label = Выбрать все адреса
    .accesskey = е
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

## Attachment widget

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
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Моя vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = Мой открытый ключ OpenPGP
    .accesskey = к
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [one] { $count } вложение
        [few] { $count } вложения
       *[many] { $count } вложений
    }
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

## Reorder Attachment Panel

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

## Encryption

encryption-menu =
    .label = Безопасность
    .accesskey = з
encryption-toggle =
    .label = Шифровать
    .tooltiptext = Использовать сквозное шифрование для этого сообщения
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Просмотреть или изменить настройки шифрования OpenPGP
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Просмотреть или изменить настройки шифрования S/MIME
signing-toggle =
    .label = Подписать
    .tooltiptext = Подписать это сообщение цифровой подписью
menu-openpgp =
    .label = OpenPGP
    .accesskey = G
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Шифровать
    .accesskey = Ш
menu-encrypt-subject =
    .label = Шифровать тему
    .accesskey = т
menu-sign =
    .label = Подписать цифровой подписью
    .accesskey = П
menu-manage-keys =
    .label = Управление ключами
    .accesskey = ю
menu-view-certificates =
    .label = Просмотреть сертификаты получателей
    .accesskey = с
menu-open-key-manager =
    .label = Менеджер ключей
    .accesskey = ж
openpgp-key-issue-notification-one = Для сквозного шифрования нужно решить проблему с ключом для { $addr }
openpgp-key-issue-notification-many = Для сквозного шифрования нужно решить проблемы с ключами для { $count } получателей.
smime-cert-issue-notification-one = Для сквозного шифрования нужно решить проблему с сертификатом для { $addr }.
smime-cert-issue-notification-many = Для сквозного шифрования нужно решить проблемы с сертификатами для { $count } получателей.
key-notification-disable-encryption =
    .label = Не шифровать
    .accesskey = е
    .tooltiptext = Отключить сквозное шифрование
key-notification-resolve =
    .label = Решить…
    .accesskey = е
    .tooltiptext = Открыть управление ключами OpenPGP
can-encrypt-smime-notification = Возможно сквозное шифрование S/MIME.
can-encrypt-openpgp-notification = Возможно сквозное шифрование OpenPGP.
can-e2e-encrypt-button =
    .label = Шифровать
    .accesskey = ф

## Addressing Area

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

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Выгружено в неизвестную учётную запись Filelink.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } - вложение на Filelink
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = Файл { $filename } был прикреплён в виде ссылки на Filelink. Его можно загрузить по указанной ниже ссылке.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] Я связал с этим сообщением { $count } файл:
        [few] Я связал с этим сообщением { $count } файла:
       *[many] Я связал с этим сообщением { $count } файлов:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Узнать больше о { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Узнать больше о { $firstLinks } и { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Ссылка защищена паролем
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Служба Filelink:
cloud-file-template-size = Размер:
cloud-file-template-link = Ссылка:
cloud-file-template-password-protected-link = Ссылка, защищённая паролем:
cloud-file-template-expiry-date = Срок действия:
cloud-file-template-download-limit = Лимит на загрузку:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Ошибка соединения
cloud-file-connection-error = { -brand-short-name } не в сети. Не удалось подключиться к { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Выгрузка { $filename } на { $provider } не удалась
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = При переименовании произошла ошибка
cloud-file-rename-error = При переименовании { $filename } на { $provider } возникла проблема.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Переименование { $filename } на { $provider } не удалось
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } не поддерживает переименование уже выгруженных файлов.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Ошибка вложения Filelink
cloud-file-attachment-error = Не удалось обновить вложение Filelink { $filename }, так как его локальный файл был перемещён или удалён.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Ошибка учётной записи Filelink
cloud-file-account-error = Не удалось обновить вложение Filelink { $filename }, так как его учётная запись Filelink была удалена.

## Link Preview

link-preview-title = Предпросмотр ссылки
link-preview-description = { -brand-short-name } может добавлять встроенный предпросмотр при вставке ссылок.
link-preview-autoadd = По возможности автоматически добавлять предпросмотр ссылок
link-preview-replace-now = Добавить предпросмотр ссылки для этой ссылки?
link-preview-yes-replace = Да

## Dictionary selection popup

spell-add-dictionaries =
    .label = Добавить словари…
    .accesskey = л
