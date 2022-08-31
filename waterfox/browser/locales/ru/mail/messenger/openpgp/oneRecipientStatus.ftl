# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Безопасность сообщений OpenPGP
openpgp-one-recipient-status-status =
    .label = Статус
openpgp-one-recipient-status-key-id =
    .label = Идентификатор ключа
openpgp-one-recipient-status-created-date =
    .label = Создан
openpgp-one-recipient-status-expires-date =
    .label = Истекает
openpgp-one-recipient-status-open-details =
    .label = Открыть подробности и отредактировать принятие…
openpgp-one-recipient-status-discover =
    .label = Поискать новый или обновлённый ключ

openpgp-one-recipient-status-instruction1 = Чтобы отправить получателю сообщение, зашифрованное методом сквозного шифрования, вам необходимо получить его открытый ключ OpenPGP и пометить его как принятый.
openpgp-one-recipient-status-instruction2 = Чтобы получить его открытый ключ, импортируйте его из письма, которое он вам отправил, и где он содержится. Кроме того, вы можете попробовать найти открытый ключ в каталоге.

openpgp-key-own = Принят (личный ключ)
openpgp-key-secret-not-personal = Не может использоваться
openpgp-key-verified = Принят (подтверждён)
openpgp-key-unverified = Принят (не подтверждён)
openpgp-key-undecided = Не принят (не определено)
openpgp-key-rejected = Не принят (отклонён)
openpgp-key-expired = Истёк срок действия

openpgp-intro = Доступные открытые ключи для { $key }

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Отпечаток: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
        [one] Файл содержит { $num } открытый ключ, как показано ниже:
        [few] Файл содержит { $num } открытых ключа, как показано ниже:
       *[many] Файл содержит { $num } открытых ключей, как показано ниже:
    }

openpgp-pubkey-import-accept =
    { $num ->
        [one] Принимаете ли вы эти ключи для проверки цифровых подписей и шифрования сообщений для всех отображённых адресов электронной почты?
        [few] Принимаете ли вы эти ключи для проверки цифровых подписей и шифрования сообщений для всех отображённых адресов электронной почты?
       *[many] Принимаете ли вы эти ключи для проверки цифровых подписей и шифрования сообщений для всех отображённых адресов электронной почты?
    }

pubkey-import-button =
    .buttonlabelaccept = Импортировать
    .buttonaccesskeyaccept = м
