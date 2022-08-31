# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Pokusili jste se odeslat nešifrovanou zprávu uživateli { $name }. Aktuální nastavení odesílání nešifrovaných zpráv zakazuje.

msgevent-encryption-required-part2 = Probíhá pokus o zahájení soukromé konverzace. Vaše zpráva bude odeslána, jakmile bude konverzace zahájena.
msgevent-encryption-error = Při šifrování zprávy došlo k chybě. Zpráva nebyla odeslána.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = Uživatel { $name } již s vámi ukončil šifrované spojení. Aby se předešlo nechtěnému odeslání vaší zprávy nešifrováně, nebyla odeslána vůbec. Ukončete prosím vaši šifrovanou konverzaci a případně zahajte novou.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Při zahajování soukromé konverzace s uživatelem { $name } došlo k chybě.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Přijímáte své vlastní zprávy. Buďto se pokoušíte hovořit sami se sebou, nebo vám někdo posílá zpět vaše vlastní zprávy.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Poslední zpráva uživateli { $name } byla znovu odeslána.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Šifrovaná zpráva přijatá od uživatele { $name } není čitelná, protože momentálně nekomunikujete soukromě.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Obdrželi jste nečitelnou šifrovanou zprávu od uživatele { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Obdrželi jste poškozenou datovou zprávu od uživatele { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Byl obdržen prezenční signál od uživatele { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Byl odeslán prezenční signál uživateli { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Při pokusu o ochranu konverzace pomocí OTR došlo k neočekávané chybě.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Tato zpráva přijatá od uživatele { $name } nebyla šifrovaná: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Obdrželi jste nerozpoznanou zprávu OTR od uživatele { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = Uživatel { $name } poslal zprávu, která byla určena jiné relaci. Pokud jste přihlášeni vícekrát, možná tuto zprávu obdržela jiná relace.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Byla zahájena soukromá konverzace s uživatelem { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Byla zahájena neověřená šifrovaná konverzace s uživatelem { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Šifrovaná konverzace s uživatelem { $name } byla úspěšně obnovena.

error-enc = Při šifrování zprávy došlo k chybě.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Odeslali jste šifrovaná data uživateli { $name }, který je ale neočekával.

error-unreadable = Odeslali jste nečitelnou šifrovanou zprávu.
error-malformed = Odeslali jste poškozenou datovou zprávu.

resent = [znovu odesláno]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = Uživatel { $name } s vámi ukončil šifrovanou konverzaci, měli byste udělat totéž.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = Uživatel { $name } požádal o šifrovanou konverzaci protokolem OTR. Nemáte však zásuvný modul, který by to podporoval. Další informace najdete na stránce https://cs.wikipedia.org/wiki/Off-the-Record_Messaging.
