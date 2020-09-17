# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Шифрленген хабарламаны { $name } үшін жіберуді талабын жасадыңыз. Саясат бойынша, шифрленбеген хабарламалар рұқсат етілмейді.

msgevent-encryption_required_part2 = Жеке сөйлесуді бастау талабы жасалуда. Жеке сөйлесу басталған кезде, сіздің хабарламаңыз қайта жіберілетін болады.
msgevent-encryption_error = Хабарламаңызды шифрлеу кезінде қате орын алды. Хабарлама жіберілмеді.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } контакті сізбен ашылған шифрленген байланысты жапқан, Сіздің байқаусыздан шифрленбеген хабарламаны жіберуге жол бермеу үшін, хабарлама жіберілмеді. Шифрленген сөйлесуді аяқтаңыз, немесе оны қайта бастаңыз.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = { $name } контактімен жеке сөйлесуді баптау кезінде қате орын алды.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Сіз өзіңіздің OTR хабарлармаларыңызды алып отырсыз. Сіз өз-өзіңізбен сөйлесуге тырысып жатырсыз немесе біреу сіздің хабарламаларыңызды сізге қайтарып жатыр.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = { $name } үшін соңғы хабарлама қайта жіберілді.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = { $name } контактінен алынған шифрленген хабарламаны оқу мүмкін емес, өйткені сіз қазір қауіпсіз түрде байланысқан жоқсыз.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Сіз { $name } контактінен оқылмайтын шифрленген хабарламаны алдыңыз.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Сіз { $name } контактінен деректер пішімі қате болып тұрған хабарламаны алдыңыз.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = { $name } контактінен синхрондау (Heartbeat) хабарламасы алынды.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = { $name } контактіне синхрондау (Heartbeat) хабарламасы жіберілді.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Сөйлесуіңізді OTR көмегімен қорғау талабын жасау кезінде күтпеген қате орын алды.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = { $name } контактінен алынған келесі хабарлама шифрленбеген: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Сіз { $name } контактінен танылмайтын OTR хабарламасын алдыңыз.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } контакті басқа сессияға арналған хабарламаны жіберген. Сіз бірнеше жерден кірсеңіз, хабарламаны басқа сессия алғаны мүмкін.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = { $name } контактімен жеке сөйлесу басталды.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = { $name } контактімен шифрленген, бірақ расталмаған сөйлесу басталды.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = { $name } контактімен шифрленген сөйлесу сәтті жаңартылды.

error-enc = Хабарламаны шифрлеу кезінде қате кетті.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Сіз { $name } контактіне шифрленген деректерді жібердіңіз, бірақ, ол оны күтпеген.

error-unreadable = Сіз оқылмайтын шифрленген хабарламаны жібердіңіз.
error-malformed = Сіз пішімі жарамсыз хабарламаны жібердіңіз.

resent = [қайта жіберілген]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } сізбен шифрленген сөйлесуді аяқтады; сіз де солай істеуіңіз керек.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } контакті Жазбадан тыс (OTR) шифрленген сөйлесуін сұрады. Алайда, сізде оны қолдайтын плагин жоқ. Көбірек білу үшін, https://en.wikipedia.org/wiki/Off-the-Record_Messaging қараңыз.
