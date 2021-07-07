# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Per inviare messaggi crittati o con firma digitale, configurare una tecnologia di crittografia OpenPGP o S/MIME.
e2e-intro-description-more = Selezionare la propria chiave personale per utilizzare OpenPGP o il proprio certificato personale per utilizzare S/MIME. Per una chiave personale o un certificato si deve possedere la chiave segreta corrispondente.
openpgp-key-user-id-label = Account/ID utente
openpgp-keygen-title-label =
    .title = Genera chiave OpenPGP
openpgp-cancel-key =
    .label = Annulla
    .tooltiptext = Annulla generazione della chiave
openpgp-key-gen-expiry-title =
    .label = Scadenza chiave
openpgp-key-gen-expire-label = La chiave scade in
openpgp-key-gen-days-label =
    .label = giorni
openpgp-key-gen-months-label =
    .label = mesi
openpgp-key-gen-years-label =
    .label = anni
openpgp-key-gen-no-expiry-label =
    .label = La chiave non ha scadenza
openpgp-key-gen-key-size-label = Dimensione chiave
openpgp-key-gen-console-label = Generazione chiave
openpgp-key-gen-key-type-label = Tipo di chiave
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (curva ellittica)
openpgp-generate-key =
    .label = Genera chiave
    .tooltiptext = Genera una nuova chiave OpenPGP adatta per crittografia e/o firma
openpgp-advanced-prefs-button-label =
    .label = Avanzate…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">NOTA: il completamento del processo di generazione della chiave potrebbe richiedere alcuni minuti.</a> Non uscire dall’applicazione mentre è in corso la generazione della chiave. Navigare attivamente o eseguire operazioni a uso intensivo del disco durante la generazione delle chiavi incrementerà il livello di casualità e accelererà il processo. Quando il processo di generazione della chiave sarà completato, si riceverà un avviso.
openpgp-key-expiry-label =
    .label = Scadenza
openpgp-key-id-label =
    .label = ID chiave
openpgp-cannot-change-expiry = Questa chiave ha una struttura complessa, la modifica della data di scadenza non è supportata.
openpgp-key-man-title =
    .title = Gestore delle chiavi OpenPGP
openpgp-key-man-generate =
    .label = Nuova coppia di chiavi
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Certificato di revoca
    .accesskey = r
openpgp-key-man-ctx-gen-revoke-label =
    .label = Genera e salva il certificato di revoca
openpgp-key-man-file-menu =
    .label = File
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Modifica
    .accesskey = M
openpgp-key-man-view-menu =
    .label = Visualizza
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Genera
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Keyserver
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = Importa chiavi pubbliche da file
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importa chiavi segrete da file
openpgp-key-man-import-sig-from-file =
    .label = Importa revoche da file
openpgp-key-man-import-from-clipbrd =
    .label = Importa chiavi dagli appunti
    .accesskey = a
openpgp-key-man-import-from-url =
    .label = Importa chiavi da URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Esporta chiavi pubbliche in un file
    .accesskey = u
openpgp-key-man-send-keys =
    .label = Invia chiavi pubbliche via email
    .accesskey = m
openpgp-key-man-backup-secret-keys =
    .label = Effettua backup delle chiavi segrete su file
    .accesskey = k
openpgp-key-man-discover-cmd =
    .label = Individua chiavi online
    .accesskey = o
openpgp-key-man-discover-prompt = Per individuare le chiavi OpenPGP online sui keyserver o utilizzando il protocollo WKD, inserire un indirizzo email o un ID chiave.
openpgp-key-man-discover-progress = Ricerca in corso…
openpgp-key-copy-key =
    .label = Copia chiave pubblica
    .accesskey = h
openpgp-key-export-key =
    .label = Esporta chiave pubblica in un file
    .accesskey = u
openpgp-key-backup-key =
    .label = Effettua backup della chiave segreta su file
    .accesskey = k
openpgp-key-send-key =
    .label = Invia chiave pubblica via email
    .accesskey = m
openpgp-key-man-copy-to-clipbrd =
    .label = Copia chiavi pubbliche negli appunti
    .accesskey = v
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Copia ID chiave negli appunti
           *[other] Copia ID chiavi negli appunti
        }
    .accesskey = o
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Copia impronta digitale negli appunti
           *[other] Copia impronte digitali negli appunti
        }
    .accesskey = m
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Copia chiave pubblica negli appunti
           *[other] Copia chiavi pubbliche negli appunti
        }
    .accesskey = v
openpgp-key-man-ctx-expor-to-file-label =
    .label = Esporta chiavi su file
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Copia chiavi pubbliche negli appunti
openpgp-key-man-ctx-copy =
    .label = Copia
    .accesskey = C
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Impronta digitale
           *[other] Impronte digitali
        }
    .accesskey = d
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] ID chiave
           *[other] ID chiavi
        }
    .accesskey = c
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Chiave pubblica
           *[other] Chiavi pubbliche
        }
    .accesskey = b
openpgp-key-man-close =
    .label = Chiudi
openpgp-key-man-reload =
    .label = Ricarica cache delle chiavi
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = Modifica la data di scadenza
    .accesskey = M
openpgp-key-man-del-key =
    .label = Elimina chiavi
    .accesskey = m
openpgp-delete-key =
    .label = Elimina chiave
    .accesskey = h
openpgp-key-man-revoke-key =
    .label = Revoca chiave
    .accesskey = R
openpgp-key-man-key-props =
    .label = Proprietà chiave
    .accesskey = P
openpgp-key-man-key-more =
    .label = Altro
    .accesskey = A
openpgp-key-man-view-photo =
    .label = Foto identificativa
    .accesskey = c
openpgp-key-man-ctx-view-photo-label =
    .label = Visualizza foto identificativa
openpgp-key-man-show-invalid-keys =
    .label = Visualizza chiavi non valide
    .accesskey = V
openpgp-key-man-show-others-keys =
    .label = Visualizza chiavi di altre persone
    .accesskey = n
openpgp-key-man-user-id-label =
    .label = Nome
openpgp-key-man-fingerprint-label =
    .label = Impronta digitale
openpgp-key-man-select-all =
    .label = Seleziona tutte le chiavi
    .accesskey = u
openpgp-key-man-empty-tree-tooltip =
    .label = Inserisci i termini di ricerca nella casella qui sopra
openpgp-key-man-nothing-found-tooltip =
    .label = Nessuna chiave corrispondente ai termini di ricerca
openpgp-key-man-please-wait-tooltip =
    .label = Attendi il caricamento delle chiavi...
openpgp-key-man-filter-label =
    .placeholder = Cerca chiavi
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Proprietà chiave
openpgp-key-details-signatures-tab =
    .label = Certificazioni
openpgp-key-details-structure-tab =
    .label = Struttura
openpgp-key-details-uid-certified-col =
    .label = ID utente/Certificato da
openpgp-key-details-user-id2-label = Presunto proprietario della chiave
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Tipo
openpgp-key-details-key-part-label =
    .label = Parte della chiave
openpgp-key-details-algorithm-label =
    .label = Algoritmo
openpgp-key-details-size-label =
    .label = Dimensione
openpgp-key-details-created-label =
    .label = Data di creazione
openpgp-key-details-created-header = Data di creazione
openpgp-key-details-expiry-label =
    .label = Scadenza
openpgp-key-details-expiry-header = Scadenza
openpgp-key-details-usage-label =
    .label = Uso
openpgp-key-details-fingerprint-label = Impronta digitale
openpgp-key-details-sel-action =
    .label = Seleziona azione...
    .accesskey = z
openpgp-key-details-also-known-label = Presunte identità alternative del proprietario della chiave:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Chiudi
openpgp-acceptance-label =
    .label = Accettazione
openpgp-acceptance-rejected-label =
    .label = No, rifiuta questa chiave.
openpgp-acceptance-undecided-label =
    .label = Non ancora, forse più tardi.
openpgp-acceptance-unverified-label =
    .label = Sì, ma non ho ancora verificato che sia la chiave corretta.
openpgp-acceptance-verified-label =
    .label = Sì, ho verificato personalmente la correttezza dell’impronta digitale di questa chiave.
key-accept-personal =
    Per questa chiave, si possiede sia la parte pubblica che quella segreta. È possibile utilizzarla come chiave personale.
    Se questa chiave è stata fornita da qualcun altro, non utilizzarla come chiave personale.
key-personal-warning = Hai creato questa chiave personalmente e la chiave visualizzata è di tua proprietà?
openpgp-personal-no-label =
    .label = No, non utilizzarla come chiave personale.
openpgp-personal-yes-label =
    .label = Sì, utilizza questa chiave come chiave personale.
openpgp-copy-cmd-label =
    .label = Copia

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird non dispone di una chiave personale OpenPGP per <b>{ $identity }</b>
        [one] Thunderbird ha trovato { $count } chiave personale OpenPGP associata a <b>{ $identity }</b>
       *[other] Thunderbird ha trovato { $count } chiavi personali OpenPGP associate a <b>{ $identity }</b>
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Selezionare una chiave valida per utilizzare il protocollo OpenPGP.
       *[other] La configurazione attuale utilizza la chiave con ID <b>{ $key }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = La configurazione attuale utilizza la chiave con ID <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = La configurazione attuale utilizza la chiave <b>{ $key }</b>, che è scaduta.
openpgp-add-key-button =
    .label = Aggiungi chiave...
    .accesskey = A
e2e-learn-more = Ulteriori informazioni
openpgp-keygen-success = Chiave OpenPGP creata correttamente.
openpgp-keygen-import-success = Le chiavi OpenPGP sono state importate correttamente.
openpgp-keygen-external-success = ID chiave esterna GnuPG salvato.

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Nessuna
openpgp-radio-none-desc = Non utilizzare OpenPGP per questa identità.
openpgp-radio-key-not-usable = Questa chiave non è utilizzabile come chiave personale, in quanto manca la chiave segreta.
openpgp-radio-key-not-accepted = Per utilizzare questa chiave è necessario prima approvarla come chiave personale.
openpgp-radio-key-not-found = Non è stato possibile trovare questa chiave. Per utilizzarla è necessario importarla in { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Scade il: { $date }
openpgp-key-expires-image =
    .tooltiptext = La chiave scadrà tra meno di 6 mesi
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Scaduta il: { $date }
openpgp-key-expired-image =
    .tooltiptext = Chiave scaduta
openpgp-key-expires-within-6-months-icon =
    .title = La chiave scadrà tra meno di 6 mesi
openpgp-key-has-expired-icon =
    .title = Chiave scaduta
openpgp-key-expand-section =
    .tooltiptext = Ulteriori informazioni
openpgp-key-revoke-title = Revoca chiave
openpgp-key-edit-title = Modifica chiave OpenPGP
openpgp-key-edit-date-title = Estendi la data di scadenza
openpgp-manager-description = Utilizzare il gestore delle chiavi OpenPGP per visualizzare e gestire le chiavi pubbliche dei corrispondenti e tutte le altre chiavi non elencate sopra.
openpgp-manager-button =
    .label = Gestore delle chiavi OpenPGP
    .accesskey = G
openpgp-key-remove-external =
    .label = Rimuovi ID chiave esterna
    .accesskey = m
key-external-label = Chiave GnuPG esterna
# Strings in keyDetailsDlg.xhtml
key-type-public = chiave pubblica
key-type-primary = chiave primaria
key-type-subkey = sottochiave
key-type-pair = coppia di chiavi (chiave segreta e chiave pubblica)
key-expiry-never = mai
key-usage-encrypt = Critta
key-usage-sign = Firma
key-usage-certify = Certifica
key-usage-authentication = Autenticazione
key-does-not-expire = La chiave non ha scadenza
key-expired-date = La chiave è scaduta il { $keyExpiry }
key-expired-simple = La chiave è scaduta
key-revoked-simple = La chiave è stata revocata
key-do-you-accept = Accettare questa chiave per la verifica delle firme digitali e per la crittatura dei messaggi?
key-accept-warning = Evitare di accettare una chiave sconosciuta. Utilizzare un canale di comunicazione diverso dalle email per verificare l’impronta digitale della chiave del corrispondente.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Impossibile inviare il messaggio perché si è verificato un problema con la chiave personale. { $problem }
cannot-encrypt-because-missing = Impossibile inviare questo messaggio con la crittografia end-to-end poiché ci sono problemi con le chiavi dei seguenti destinatari: { $problem }
window-locked = La finestra di composizione è bloccata; invio annullato
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Parte crittata del messaggio
mime-decrypt-encrypted-part-concealed-data = Questa è una parte crittata del messaggio. È necessario aprirlo in una finestra separata facendo clic sull’allegato.
# Strings in keyserver.jsm
keyserver-error-aborted = Interrotto
keyserver-error-unknown = Si è verificato un errore sconosciuto
keyserver-error-server-error = Il keyserver ha segnalato un errore.
keyserver-error-import-error = Impossibile importare la chiave scaricata.
keyserver-error-unavailable = Il keyserver non è disponibile.
keyserver-error-security-error = Il keyserver non supporta l’accesso crittato.
keyserver-error-certificate-error = Il certificato del keyserver non è valido.
keyserver-error-unsupported = Il keyserver non è supportato.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Il proprio provider di posta elettronica ha elaborato la richiesta di caricare la chiave pubblica nella directory delle chiavi web di OpenPGP.
    Confermare per completare la pubblicazione della chiave pubblica.
wkd-message-body-process =
    Questa è un’email relativa al processo automatico di caricamento della propria chiave pubblica nella directory delle chiavi web di OpenPGP.
    Non sono necessari interventi manuali a questo punto.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Impossibile decrittare il messaggio con l’oggetto
    { $subject }.
    Riprovare con una passphrase diversa o saltare il messaggio?
# Strings in gpg.jsm
unknown-signing-alg = Algoritmo di firma sconosciuto (ID: { $id })
unknown-hash-alg = Hash crittografico sconosciuto (ID: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    La propria chiave { $desc } scadrà tra meno di { $days } giorni.
    Si consiglia di creare una nuova coppia di chiavi e configurare gli account corrispondenti per utilizzarla.
expiry-keys-expire-soon =
    Le seguenti chiavi scadranno tra meno di { $days } giorni: { $desc }.
    Si consiglia di creare nuove chiavi e configurare gli account corrispondenti per utilizzarle.
expiry-key-missing-owner-trust =
    L’affidabilità non è specificata per la chiave privata { $desc }.
    Impostare “assoluta” nelle proprietà della chiave alla voce “Affidabilità certificati”.
expiry-keys-missing-owner-trust =
    L’affidabilità non è specificata per le seguenti chiavi segrete.
    { $desc }.
    Impostare “assoluta” nelle proprietà della chiave alla voce “Affidabilità certificati”.
expiry-open-key-manager = Apri il gestore delle chiavi OpenPGP
expiry-open-key-properties = Apri le proprietà della chiave
# Strings filters.jsm
filter-folder-required = Selezionare la cartella di destinazione.
filter-decrypt-move-warn-experimental =
    Attenzione: l’azione del filtro “Decritta in modo permanente” può comportare il danneggiamento dei messaggi.
    Si consiglia di provare prima il filtro “Crea copia decrittata”, verificando il risultato accuratamente, e solo dopo utilizzare questo filtro se il risultato corrisponde alle aspettative.
filter-term-pgpencrypted-label = Crittato con OpenPGP
filter-key-required = È necessario selezionare una chiave del destinatario.
filter-key-not-found = Impossibile trovare una chiave di crittatura per “{ $desc }”.
filter-warn-key-not-secret =
    Attenzione: l’azione del filtro “Critta su chiave“ sostituisce i destinatari.
    Se non si possiede la chiave segreta per “{ $desc }“ non sarà più possibile leggere le email.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Decritta in modo permanente (OpenPGP)
filter-decrypt-copy-label = Crea copia decrittata (OpenPGP)
filter-encrypt-label = Critta su chiave (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Chiavi importate correttamente.
import-info-bits = Bit
import-info-created = Data di creazione
import-info-fpr = Impronta digitale
import-info-details = Visualizza i dettagli e gestisci l’accettazione delle chiavi
import-info-no-keys = Nessuna chiave importata.
# Strings in enigmailKeyManager.js
import-from-clip = Importare alcune chiavi dagli appunti?
import-from-url = Scarica la chiave pubblica da questo indirizzo:
copy-to-clipbrd-failed = Impossibile copiare le chiavi selezionate negli appunti.
copy-to-clipbrd-ok = Chiavi copiate negli appunti
delete-secret-key =
    ATTENZIONE: si sta cercando di eliminare una chiave segreta.
    
    Se si elimina la propria chiave segreta, non sarà più possibile decrittare i messaggi crittati con quella chiave, né si potrà revocarla.
    
    Si vuole veramente eliminare ENTRAMBE le chiavi (segreta e pubblica) per “{ $userId }”?
delete-mix =
    ATTENZIONE: si sta cercando di eliminare delle chiavi segrete.
    Se si elimina la propria chiave segreta, non sarà più possibile decrittare i messaggi crittati con quella chiave.
    Si vuole veramente eliminare ENTRAMBE le chiavi (segreta e pubblica) per gli elementi selezionati?
delete-pub-key =
    Eliminare la chiave pubblica
    “{ $userId }”?
delete-selected-pub-key = Eliminare le chiavi pubbliche?
refresh-all-question = Non è stata selezionata alcuna chiave. Aggiornare TUTTE le chiavi?
key-man-button-export-sec-key = Esporta chiavi &segrete
key-man-button-export-pub-key = Esporta solo chiavi &pubbliche
key-man-button-refresh-all = &Aggiorna tutte le chiavi
key-man-loading-keys = Caricamento chiavi in corso, attendere...
ascii-armor-file = File ASCII Armored (*.asc)
no-key-selected = È necessario selezionare almeno una chiave per eseguire l’operazione scelta
export-to-file = Esporta chiave pubblica in un file
export-keypair-to-file = Esporta chiave segreta e pubblica in un file
export-secret-key = Includere la chiave segreta nel file della chiave OpenPGP salvato?
save-keys-ok = Le chiavi sono state salvate correttamente
save-keys-failed = Salvataggio chiavi non riuscito
default-pub-key-filename = chiavi-pubbliche-esportate
default-pub-sec-key-filename = backup-chiavi-segrete
refresh-key-warn = Attenzione: a seconda del numero di chiavi e della velocità di connessione, l’aggiornamento di tutte le chiavi potrebbe richiedere molto tempo.
preview-failed = Impossibile leggere il file della chiave pubblica.
general-error = Errore: { $reason }
dlg-button-delete = &Elimina

## Account settings export output

openpgp-export-public-success = <b>Chiave pubblica esportata correttamente.</b>
openpgp-export-public-fail = <b>Impossibile esportare la chiave pubblica selezionata.</b>
openpgp-export-secret-success = <b>Chiave segreta esportata correttamente.</b>
openpgp-export-secret-fail = <b>Impossibile esportare la chiave segreta selezionata.</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = La chiave { $userId } (ID chiave { $keyId }) è stata revocata.
key-ring-pub-key-expired = La chiave { $userId } (ID chiave { $keyId }) è scaduta.
key-ring-no-secret-key = Sembra che non si disponga della chiave segreta per { $userId } (ID chiave { $keyId }) nel proprio portachiavi; non è possibile utilizzare la chiave per firmare.
key-ring-pub-key-not-for-signing = La chiave { $userId } (ID chiave { $keyId }) non può essere utilizzata per firmare.
key-ring-pub-key-not-for-encryption = La chiave { $userId } (ID chiave { $keyId }) non può essere utilizzata per la crittografia.
key-ring-sign-sub-keys-revoked = Tutte le sottochiavi per la firma della chiave { $userId } (ID chiave { $keyId }) sono state revocate.
key-ring-sign-sub-keys-expired = Tutte le sottochiavi per la firma della chiave { $userId } (ID chiave { $keyId }) sono scadute.
key-ring-enc-sub-keys-revoked = Tutte le sottochiavi di crittografia della chiave { $userId } (ID chiave { $keyId }) sono state revocate.
key-ring-enc-sub-keys-expired = Tutte le sottochiavi di crittografia della chiave { $userId } (ID chiave { $keyId }) sono scadute.
# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Attributo utente (immagine JPEG)
# Strings in key.jsm
already-revoked = Questa chiave è già stata revocata.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Si sta per revocare la chiave “{ $identity }”.
    Non sarà più possibile firmare con questa chiave e, una volta distribuita, altre persone non potranno più utilizzarla per crittare i messaggi. È comunque possibile continuare a utilizzarla per decrittare i vecchi messaggi.
    Procedere con l’operazione?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Non si dispone di alcuna chiave (0x{ $keyId }) che corrisponde a questo certificato di revoca.
    Se si è persa la propria chiave, è necessario importarla (ad es. da un keyserver) prima di importare il certificato di revoca.
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = La chiave 0x{ $keyId } è già stata revocata.
key-man-button-revoke-key = &Revoca chiave
openpgp-key-revoke-success = Chiave revocata correttamente.
after-revoke-info =
    La chiave è stata revocata.
    Condividere di nuovo questa chiave pubblica inviandola tramite email o caricandola sui keyserver per far sapere agli altri che la propria chiave è stata revocata.
    Non appena il software utilizzato dalle altre persone verrà a conoscenza della revoca, smetterà di usare la vecchia chiave.
    Se si utilizza una nuova chiave per lo stesso indirizzo email e si allega la nuova chiave pubblica alle email inviate, le informazioni sulla vecchia chiave revocata verranno incluse automaticamente.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importa
delete-key-title = Elimina chiave OpenPGP
delete-external-key-title = Rimozione chiave esterna GnuPG
delete-external-key-description = Rimuovere questo ID chiave esterna GnuPG?
key-in-use-title = Chiave OpenPGP attualmente in uso
delete-key-in-use-description = Impossibile procedere. La chiave selezionata per l’eliminazione è attualmente utilizzata da questa identità. Selezionare una chiave diversa o non selezionarne alcuna e riprovare.
revoke-key-in-use-description = Impossibile procedere. La chiave selezionata per la revoca è attualmente utilizzata da questa identità. Selezionare una chiave diversa o non selezionarne alcuna e riprovare.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = L’indirizzo email “{ $keySpec }” non può essere associato a una chiave del proprio portachiavi.
key-error-key-id-not-found = L’ID chiave configurato “{ $keySpec }” non è stato trovato nel proprio portachiavi.
key-error-not-accepted-as-personal = Non si è confermato che la chiave con ID “{ $keySpec }” è la propria chiave personale.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = La funzione selezionata non è disponibile in modalità non in linea. Connettersi a Internet e riprovare.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Impossibile trovare chiavi corrispondenti ai criteri di ricerca specificati.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Errore: comando di estrazione chiave non riuscito
# Strings used in keyRing.jsm
fail-cancel = Errore: ricezione chiave annullata dall’utente
not-first-block = Errore: il primo blocco OpenPGP non è il blocco della chiave pubblica
import-key-confirm = Importare le chiavi pubbliche incluse nel messaggio?
fail-key-import = Errore: importazione chiave non riuscita
file-write-failed = Impossibile scrivere nel file { $output }
no-pgp-block = Errore: non è stato trovato alcun blocco blindato di dati OpenPGP
confirm-permissive-import = Importazione non riuscita. La chiave che si sta tentando di importare potrebbe essere danneggiata o utilizza degli attributi sconosciuti. Tentare l’importazione delle parti corrette? Ciò potrebbe comportare l’importazione di chiavi incomplete e inutilizzabili.
# Strings used in trust.jsm
key-valid-unknown = sconosciuta
key-valid-invalid = non valida
key-valid-disabled = disattivata
key-valid-revoked = revocata
key-valid-expired = scaduta
key-trust-untrusted = non attendibile
key-trust-marginal = marginale
key-trust-full = attendibile
key-trust-ultimate = assoluta
key-trust-group = (gruppo)
# Strings used in commonWorkflows.js
import-key-file = Importa file chiave OpenPGP
import-rev-file = Importa file di revoca OpenPGP
gnupg-file = File GnuPG
import-keys-failed = Importazione delle chiavi non riuscita
passphrase-prompt = Inserire la passphrase per sbloccare la seguente chiave: { $key }
file-to-big-to-import = Questo file è troppo grande. Non importare un numero eccessivo di chiavi.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Crea e salva il certificato di revoca
revoke-cert-ok = Il certificato di revoca è stato creato correttamente. È possibile utilizzarlo per invalidare la propria chiave pubblica, ad esempio nel caso in cui si perdesse la chiave segreta.
revoke-cert-failed = Impossibile creare il certificato di revoca.
gen-going = Generazione della chiave già in corso.
keygen-missing-user-name = Non è stato specificato alcun nome per l’account corrente. Inserire un valore nel campo “Il tuo nome” nelle impostazioni dell’account.
expiry-too-short = La chiave deve essere valida per almeno un giorno.
expiry-too-long = Non è possibile creare una chiave che scade tra più di 100 anni.
key-confirm = Generare chiave pubblica e segreta per “{ $id }”?
key-man-button-generate-key = &Genera chiave
key-abort = Interrompere la generazione della chiave?
key-man-button-generate-key-abort = &Interrompi generazione chiave
key-man-button-generate-key-continue = &Continua generazione chiave

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Errore: decrittazione non riuscita
fix-broken-exchange-msg-failed = Impossibile riparare il messaggio.
attachment-no-match-from-signature = Impossibile associare il file della firma “{ $attachment }” a un allegato
attachment-no-match-to-signature = Impossibile associare l’allegato “{ $attachment }” a un file della firma
signature-verified-ok = La firma per l’allegato { $attachment } è stata verificata correttamente
signature-verify-failed = La firma per l’allegato { $attachment } non può essere verificata
decrypt-ok-no-sig =
    Attenzione
    La decrittazione ha avuto esito positivo, ma non è stato possibile verificare correttamente la firma
msg-ovl-button-cont-anyway = &Continua comunque
enig-content-note = *Gli allegati a questo messaggio non sono stati firmati né crittati*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Invia messaggio
msg-compose-details-button-label = Dettagli…
msg-compose-details-button-access-key = D
send-aborted = Operazione di invio interrotta.
key-not-trusted = Affidabilità non sufficiente per la chiave “{ $key }”
key-not-found = Chiave “{ $key }” non trovata
key-revoked = Chiave “{ $key }” revocata
key-expired = Chiave “{ $key }” scaduta
msg-compose-internal-error = Si è verificato un errore interno.
keys-to-export = Seleziona chiavi OpenPGP da inserire
msg-compose-partially-encrypted-inlinePGP =
    Il messaggio a cui si sta rispondendo contiene sia parti crittate che non crittate. Se il mittente non è stato in grado di decrittare alcune parti del messaggio originale, si potrebbe esporre alcune informazioni riservate che il mittente non è stato in grado di decrittare.
    Si consiglia di rimuovere tutto il testo citato dalla risposta a questo mittente.
msg-compose-cannot-save-draft = Errore durante il salvataggio della bozza
msg-compose-partially-encrypted-short = Attenzione alla fuga di informazioni sensibili: l’email è solo parzialmente crittata.
quoted-printable-warn =
    È stata attivata la codifica “quoted-printable” per l'invio dei messaggi. Questo potrebbe causare errori durante la decrittazione o la verifica del messaggio.
    Disattivare l’invio di messaggi “quoted-printable”?
minimal-line-wrapping =
    Il ritorno a capo è impostato a { $width } caratteri. Per crittare o firmare correttamente, questo valore deve essere di almeno 68 caratteri.
    Impostare il ritorno a capo a 68 caratteri?
sending-hidden-rcpt = Quando si invia un messaggio crittato non è possibile utilizzare destinatari in Ccn (Copia conoscenza nascosta). Per inviare questo messaggio crittato, rimuovere i destinatari Ccn o spostarli nel campo Cc.
sending-news =
    Operazione di invio crittato interrotta.
    Questo messaggio non può essere crittato perché sono presenti destinatari di un newsgroup. Si prega di inviare nuovamente il messaggio senza crittografia.
send-to-news-warning =
    Attenzione: si sta per inviare un’email crittata a un newsgroup.
    Questo operazione è sconsigliata perché ha senso solo se tutti i membri del gruppo possono decrittare il messaggio, ovvero il messaggio deve essere crittato con le chiavi di tutti i partecipanti al gruppo. Inviare questo messaggio solo se si sa esattamente che cosa si sta facendo.
    Continuare?
save-attachment-header = Salva allegato decrittato
no-temp-dir =
    Impossibile trovare una directory temporanea in cui scrivere
    Impostare la variabile di ambiente TEMP
possibly-pgp-mime = Probabilmente il messaggio è crittato o firmato con PGP/MIME: utilizzare la funzione “Decritta/Verifica“
cannot-send-sig-because-no-own-key = Impossibile firmare digitalmente questo messaggio perché non è stata ancora configurata la crittografia end-to-end per <{ $key }>
cannot-send-enc-because-no-own-key = Impossibile inviare questo messaggio crittato perché non è stata ancora configurata la crittografia end-to-end per <{ $key }>
# Strings used in decryption.jsm
do-import-multiple =
    Importare le seguenti chiavi?
    { $key }
do-import-one = Importare { $name } ({ $id })?
cant-import = Errore durante l’importazione della chiave pubblica
unverified-reply = La parte del messaggio soggetta a indentazione (risposta) è stata probabilmente modificata
key-in-message-body = È stata trovata una chiave nel corpo del messaggio. Fare clic su “Importa chiave” per importare la chiave
sig-mismatch = Errore: mancata corrispondenza della firma
invalid-email = Errore: indirizzo email non valido
attachment-pgp-key =
    L'allegato “{ $name }” che si sta aprendo sembra essere un file della chiave OpenPGP.
    Fare clic su “Importa” per importare le chiavi contenute o su “Visualizza” per visualizzare il contenuto del file in una finestra del browser
dlg-button-view = &Visualizza
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Messaggio decrittato (ripristinato formato di posta PGP danneggiato, probabilmente a causa di un server Exchange obsoleto, per questo motivo il risultato potrebbe non essere completamente leggibile)
# Strings used in encryption.jsm
not-required = Errore: crittografia non richiesta
# Strings used in windows.jsm
no-photo-available = Nessuna foto disponibile
error-photo-path-not-readable = Il percorso della foto “{ $photo }” non è leggibile
debug-log-title = Log di debug OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Questo avviso verrà ripetuto { $count }
repeat-suffix-singular = altra volta.
repeat-suffix-plural = altre volte.
no-repeat = Questo avviso non verrà più visualizzato.
dlg-keep-setting = Ricorda la risposta e non chiedere nuovamente
dlg-button-ok = &OK
dlg-button-close = &Chiudi
dlg-button-cancel = &Annulla
dlg-no-prompt = Non mostrare questa richiesta in futuro
enig-prompt = Richiesta OpenPGP
enig-confirm = Conferma OpenPGP
enig-alert = Avviso OpenPGP
enig-info = Informazioni OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Riprova
dlg-button-skip = &Ignora
# Strings used in enigmailCommon.js
enig-error = Errore OpenPGP
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Avviso OpenPGP
