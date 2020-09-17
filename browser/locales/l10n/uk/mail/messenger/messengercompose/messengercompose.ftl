# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = Вилучити поле { $type }

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = Вилучити поле { $type }

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } з однією адресою. Використовуйте кнопку стрілки вліво для фокусування.
        [few] { $type } з { $count } адресами. Використовуйте кнопку стрілки вліво для фокусування.
       *[many] { $type } з { $count } адресами. Використовуйте кнопку стрілки вліво для фокусування.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: натисніть Enter для редагування, Delete для вилучення.
        [few] { $email }, 1 з { $count }: натисніть Enter для редагування, Delete для вилучення.
       *[many] { $email }, 1 з { $count }: натисніть Enter для редагування, Delete для вилучення.
    }

pill-action-edit =
    .label = Змінити адресу
    .accesskey = м

pill-action-move-to =
    .label = Перемістити в поле Кому
    .accesskey = П

pill-action-move-cc =
    .label = Перемістити в поле Копія
    .accesskey = е

pill-action-move-bcc =
    .label = Перемістити в поле Прихована копія
    .accesskey = х

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } вкладення
            [one] { $count } вкладення
            [few] { $count } вкладення
           *[many] { $count } вкладень
        }
    .accesskey = в

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } вкладення
            [one] { $count } вкладення
            [few] { $count } вкладення
           *[many] { $count } вкладень
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = Підтвердження отримання
    .tooltiptext = Надсилати запит про підтвердження отримання цього повідомлення
