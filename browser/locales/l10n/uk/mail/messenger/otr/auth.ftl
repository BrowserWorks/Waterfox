# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Перевірити ідентифікатор контакту
    .buttonlabelaccept = Перевірити

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Перевірка ідентифікатора { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Ваш цифровий відбиток { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Цифровий відбиток { $own_name }:

auth-help = Перевірка ідентифікатора контакту допомагає впевнитися, що розмова дійсно приватна, значно ускладнюючи стороннім особам можливість перехоплювати або маніпулювати розмовою.
auth-helpTitle = Довідка щодо підтвердження

auth-questionReceived = Це запитання, поставлене вашим контактом:

auth-yes =
    .label = Так

auth-no =
    .label = Ні

auth-verified = Я підтверджую, що це дійсно правильний цифровий відбиток.

auth-manualVerification = Ручна перевірка цифрового відбитка
auth-questionAndAnswer = Питання та відповідь
auth-sharedSecret = Спільний ключ

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Зв’яжіться зі своїм вибраним співрозмовником іншим надійним способом, наприклад, електронним листом із підписом OpenPGP або телефоном. Ви повинні повідомити одне одному свої цифрові відбитки. (Цифровий відбиток - це контрольна сума, яка підтверджує дійсність ключа шифрування.) Якщо цифровий відбиток збігається, вкажіть в діалоговому вікні далі, що ви перевірили цифровий відбиток.

auth-how = Як ви хочете перевірити ідентифікатор контакту?

auth-qaInstruction = Придумайте питання, відповідь на яке відома лише вам та вашому контакту. Введіть питання та відповідь, а потім дочекайтеся, коли ваш контакт введе відповідь. Якщо відповіді не збігаються, можливе стороннє втручання до каналу зв’язку, яким ви користуєтеся.

auth-secretInstruction = Придумайте секретний ключ, відомий лише вам та вашому контакту. Не використовуйте для обміну ключем те саме підключення до Інтернету. Введіть ключ, а потім дочекайтеся введення його вашим контактом. Якщо секретні ключі не збігаються, можливе стороннє втручання до каналу зв’язку, яким ви користуєтеся.

auth-question = Введіть питання:

auth-answer = Введіть відповідь (чутливе до регістру):

auth-secret = Введіть секретний ключ:
