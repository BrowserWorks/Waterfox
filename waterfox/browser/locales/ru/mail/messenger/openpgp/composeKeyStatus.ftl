# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Чтобы отправить сообщение, зашифрованное сквозным методом, вы должны получить и принять открытый ключ для каждого получателя.
openpgp-compose-key-status-keys-heading = Наличие ключей OpenPGP:
openpgp-compose-key-status-title =
    .title = Безопасность сообщений OpenPGP
openpgp-compose-key-status-recipient =
    .label = Получатель
openpgp-compose-key-status-status =
    .label = Статус
openpgp-compose-key-status-open-details = Управление ключами для выбранного получателя…
openpgp-recip-good = в порядке
openpgp-recip-missing = ключ недоступен
openpgp-recip-none-accepted = нет принятого ключа
openpgp-compose-general-info-alias = { -brand-short-name } обычно требует, чтобы открытый ключ получателя содержал идентификатор пользователя с соответствующим адресом электронной почты. Это можно изменить, используя правила псевдонима получателя OpenPGP.
openpgp-compose-general-info-alias-learn-more = Подробнее
openpgp-compose-alias-status-direct =
    { $count ->
        [one] сопоставлены с { $count } ключом псевдонима
        [few] сопоставлены с { $count } ключами псевдонима
       *[many] сопоставлены с { $count } ключами псевдонима
    }
openpgp-compose-alias-status-error = непригодный/недоступный ключ псевдонима
