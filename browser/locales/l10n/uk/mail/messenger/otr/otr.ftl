# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Ви намагалися надіслати незахищене повідомлення до { $name }. Поточні налаштування, забороняють надсилати незахищені повідомлення.

msgevent-encryption_required_part2 = Спроба розпочати приватну розмову. Ваше повідомлення буде повторно надіслано, коли розпочнеться приватна розмова.
msgevent-encryption_error = Сталася помилка під час шифрування вашого повідомлення. Повідомлення не надіслано.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = Захищене з'єднання між вами та { $name } вже завершено. Щоб уникнути випадкового надсилання незахищеного повідомлення, його не надіслано. Завершіть свою захищену розмову або розпочніть її знову.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Сталася помилка під час налаштування приватної розмови з { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Ви отримуєте власні повідомлення OTR. Або ви намагаєтеся звʼязатися з самим собою, або хтось віддзеркалює ваші повідомлення назад до вас.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Останнє повідомлення до { $name } було повторно надіслано.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Захищене повідомлення, отримане від { $name }, неможливо прочитати, оскільки зараз ви не в приватній розмові.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Ви отримали захищене повідомлення від { $name }, яке неможливо прочитати.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Ви отримали хибні дані повідомлення від { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Ви отримали технічне повідомлення для продовження встановленого зʼєднання від { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Надіслано технічне повідомлення для продовження встановленого зʼєднання з { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Сталася неочікувана помилка під час спроби захистити вашу розмову за допомогою OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Вказане повідомлення, отримане від { $name }, не було зашифровано: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Ви отримали нерозпізнане повідомлення OTR від { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = Повідомлення, надіслане { $name }, призначене для іншого сеансу. Якщо ви входили до системи кілька разів, повідомлення може бути отримане в іншому сеансі.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Почато приватну розмову з { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Почато зашифровану, але непідтверджену розмову з { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Зашифровану розмову з { $name } успішно оновлено.

error-enc = Сталася помилка під час шифрування повідомлення.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Ви надіслали зашифровані дані користувачу { $name }, який їх не очікував.

error-unreadable = Ви надіслали захищене повідомлення, яке неможливо прочитати.
error-malformed = Ви передали хибне повідомлення з даними.

resent = [надіслати ще раз]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = Зашифровану розмову з вами завершено користувачем { $name }; ви повинні зробити те саме.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } запитує зашифровану розмову, яка не записується (OTR). Однак, у вас немає плагіна для підтримки OTR. Для отримання додаткової інформації читайте https://en.wikipedia.org/wiki/Off-the-Record_Messaging.
