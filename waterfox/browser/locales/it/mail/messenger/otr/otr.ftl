# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Hai tentato di inviare un messaggio non crittato a { $name }. Di norma, i messaggi non crittati non sono consentiti.

msgevent-encryption-required-part2 = Tentativo di avviare una conversazione privata. Il tuo messaggio verrà ritrasmesso quando inizierà la conversazione privata.
msgevent-encryption-error = Si è verificato un errore durante la crittatura del messaggio. Il messaggio non è stato inviato.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } ha già chiuso la sua connessione crittata con te. Per evitare l’invio accidentale di un messaggio non crittato, il messaggio non è stato inviato. Termina la conversazione crittata o riavviala.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Si è verificato un errore durante l’impostazione di una conversazione privata con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Stai ricevendo i tuoi stessi messaggi OTR. Stai provando a parlare con te stesso o qualcuno ti sta rispedendo i tuoi messaggi.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = L’ultimo messaggio a { $name } è stato ritrasmesso.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Impossibile leggere il messaggio crittato ricevuto da { $name }, poiché al momento non state comunicando privatamente.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Hai ricevuto un messaggio crittato illeggibile da { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Hai ricevuto da { $name } un messaggio dati non valido.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Heartbeat ricevuto da { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Heartbeat inviato a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Si è verificato un errore imprevisto durante il tentativo di proteggere la conversazione tramite OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Il messaggio seguente ricevuto da { $name } non è stato crittato: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Hai ricevuto da { $name } un messaggio OTR non riconosciuto.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } ha inviato un messaggio destinato a una sessione diversa. Se hai effettuato l’accesso più volte, è possibile che il messaggio sia stato ricevuto in un’altra sessione.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Avviata conversazione privata con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Avviata conversazione crittata ma non verificata con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Conversazione crittata con { $name } aggiornata correttamente.

error-enc = Si è verificato un errore durante la crittatura del messaggio.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Hai inviato dati crittografati non attesi a { $name }.

error-unreadable = Hai trasmesso un messaggio crittato illeggibile.
error-malformed = Hai trasmesso un messaggio dati malformato.

resent = [ritrasmesso]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } ha terminato la sua conversazione crittata con te; dovresti farlo anche tu.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ha richiesto una conversazione crittata OTR (Off-the-Record), ma non disponi di un plugin per supportarla. Per ulteriori informazioni, leggi https://it.wikipedia.org/wiki/Off-the-Record_Messaging
