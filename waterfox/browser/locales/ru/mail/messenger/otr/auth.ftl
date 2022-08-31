# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Подтверждение личности контакта
    .buttonlabelaccept = Подтверждение

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Подтверждение личности { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Отпечаток для вас, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Отпечаток для { $their_name }:

auth-help = Подтверждение личности контакта позволяет гарантировать, что разговор действительно является конфиденциальным, что значительно усложняет третьей стороне прослушивание или манипулирование разговором.

auth-help-title = Помощь в подтверждении

auth-question-received = Вот вопрос, заданный вашим контактом:

auth-yes =
    .label = Да

auth-no =
    .label = Нет

auth-verified = Я подтверждаю, что это на самом деле правильный отпечаток.

auth-manual-verification = Ручная проверка отпечатков
auth-question-and-answer = Вопрос и ответ
auth-shared-secret = Общий секрет

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Свяжитесь с вашим предполагаемым собеседником по какому-либо другому каналу, позволяющему удостоверить личность, например, по электронной почте с использованием OpenPGP или по телефону. Вы должны сообщить друг другу свои отпечатки (Отпечаток — это контрольная сумма, которая идентифицирует ключ шифрования). Если отпечаток совпадает, вы должны указать в диалоговом окне ниже, что вы подтвердили отпечаток.

auth-how = Как бы вы хотели проверить личность вашего контакта?

auth-qa-instruction = Придумайте вопрос, ответ на который известен только вам и вашему контакту. Введите вопрос и ответ, затем дождитесь, пока ваш контакт введёт ответ. Если ответы не совпадают, используемый вами канал связи может находиться под наблюдением.

auth-secret-instruction = Придумайте секретный ключ, известный только вам и вашему контакту. Не используйте для обмена ключом одно и то же соединение с Интернетом. Введите ключ, а затем дождитесь введения его вашим контактом. Если ключи не совпадают, используемый вами канал связи может находиться под наблюдением.

auth-question = Введите вопрос:

auth-answer = Введите ответ (с учётом регистра):

auth-secret = Введите секрет:
