# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Avvia una conversazione crittata
refresh-label = Aggiorna la conversazione crittata
auth-label = Verifica l’identità del tuo contatto
reauth-label = Verifica nuovamente l’identità del tuo contatto

auth-cancel = Annulla
auth-cancel-access-key = A

auth-error = Si è verificato un errore durante la verifica dell’identità del tuo contatto.
auth-success = Verifica dell’identità del contatto completata correttamente.
auth-success-them = Il tuo contatto ha verificato correttamente la tua identità. Si consiglia di verificare anche la sua identità ponendo la tua domanda.
auth-fail = Verifica dell’identità del contatto non riuscita.
auth-waiting = In attesa che il contatto completi la verifica…

finger-verify = Verifica
finger-verify-access-key = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Aggiungi fingerprint OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Tentativo di avviare una conversazione crittata con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Tentativo di aggiornare la conversazione crittata con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = La conversazione crittata con { $name } è terminata.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = L’identità di { $name } non è stata ancora verificata. Non è possibile intercettare la conversazione casualmente, ma con qualche sforzo è comunque possibile farlo. Per prevenire qualunque tentativo di intercettazione, verificare l’identità di questo contatto.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } ti sta contattando da un computer non riconosciuto. Non è possibile intercettare la conversazione casualmente, ma con qualche sforzo è comunque possibile farlo. Per prevenire qualunque tentativo di intercettazione, verificare l’identità di questo contatto.

state-not-private = La conversazione corrente non è privata.

state-generic-not-private = La conversazione corrente non è privata.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = La conversazione corrente è crittata ma non privata, poiché l’identità di { $name } non è stata ancora verificata.

state-generic-unverified = La conversazione corrente è crittata ma non privata, poiché alcune identità non sono ancora state verificate.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = L’identità di { $name } è stata verificata. La conversazione corrente è crittata e privata.

state-generic-private = La conversazione corrente è crittata e privata.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } ha terminato la sua conversazione crittata con te; dovresti farlo anche tu.

state-not-private-label = Non sicura
state-unverified-label = Non verificata
state-private-label = Privata
state-finished-label = Terminata

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } ha richiesto la verifica della tua identità.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Hai verificato l’identità di { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = L’identità di { $name } non è stata verificata.

verify-title = Verifica l’identità del tuo contatto
error-title = Errore
success-title = Crittografia end-to-end
success-them-title = Verifica l’identità del tuo contatto
fail-title = Impossibile verificare
waiting-title = Richiesta di verifica inviata

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Generazione chiave privata OTR non riuscita: { $error }
