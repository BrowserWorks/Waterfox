# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Показать защиту сообщения (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Показать защиту сообщения (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Просмотр ключа подписавшего
openpgp-view-your-encryption-key =
    .label = Просмотр вашего ключа дешифрования
openpgp-openpgp = OpenPGP
openpgp-no-sig = Нет цифровой подписи
openpgp-uncertain-sig = Неопределённая цифровая подпись
openpgp-invalid-sig = Неверная цифровая подпись
openpgp-good-sig = Хорошая цифровая подпись
openpgp-sig-uncertain-no-key = Это сообщение содержит цифровую подпись, но неясно, корректна ли она. Для проверки подписи необходимо получить копию открытого ключа отправителя.
openpgp-sig-uncertain-uid-mismatch = Это сообщение содержит цифровую подпись, но обнаружено несоответствие. Сообщение было отправлено с адреса электронной почты, который не соответствует открытому ключу подписавшего.
openpgp-sig-uncertain-not-accepted = Это сообщение содержит цифровую подпись, но вы ещё не решили, принимать ли ключ подписавшего.
openpgp-sig-invalid-rejected = Это сообщение содержит цифровую подпись, но вы ранее решили отклонить ключ подписавшего.
openpgp-sig-invalid-technical-problem = Это сообщение содержит цифровую подпись, но была обнаружена техническая ошибка. Либо сообщение было повреждено, либо было изменено кем-то другим.
openpgp-sig-valid-unverified = Это сообщение содержит действительную цифровую подпись, соответствующую ключу, который вы уже приняли. Однако вы ещё не убедились, что ключ действительно принадлежит отправителю.
openpgp-sig-valid-verified = Это сообщение включает в себя действительную цифровую подпись, соответствующую проверенному ключу.
openpgp-sig-valid-own-key = Это сообщение включает в себя действительную цифровую подпись, соответствующую вашему личному ключу.
openpgp-sig-key-id = Идентификатор ключа подписавшего: { $key }
openpgp-sig-key-id-with-subkey-id = Идентификатор ключа подписавшего: { $key } (Идентификатор подчинённого ключа: { $subkey })
openpgp-enc-key-id = Идентификатор вашего ключа дешифрования: { $key }
openpgp-enc-key-with-subkey-id = Идентификатор вашего ключа дешифрования: { $key } (Идентификатор подчинённого ключа: { $subkey })
openpgp-unknown-key-id = Неизвестный ключ
openpgp-other-enc-additional-key-ids = Кроме того, сообщение было зашифровано для владельцев следующих ключей:
openpgp-other-enc-all-key-ids = Сообщение было зашифровано для владельцев следующих ключей:
openpgp-message-header-encrypted-ok-icon =
    .alt = Расшифровка прошла успешно
openpgp-message-header-encrypted-notok-icon =
    .alt = Расшифровка не удалась
openpgp-message-header-signed-ok-icon =
    .alt = Хорошая подпись
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Плохая подпись
openpgp-message-header-signed-unknown-icon =
    .alt = Статус подписи неизвестен
openpgp-message-header-signed-verified-icon =
    .alt = Подтвержденная подпись
openpgp-message-header-signed-unverified-icon =
    .alt = Неподтвержденная подпись
