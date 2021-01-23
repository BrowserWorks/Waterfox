# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Adaugă o cheie personală OpenPGP pentru { $identity }

key-wizard-button =
    .buttonlabelaccept = Continuare
    .buttonlabelhelp = Înapoi

key-wizard-warning = <b>Dacă ai o cheie personală</b> pentru această adresă de e-mail, trebuie să o imporți. Altminteri, nu vei avea acces la arhivele mesajelor de e-mail criptate și nu vei mai putea nici să citești mesajele de e-mail criptate primite de la persoane care încă îți mai folosesc cheia existentă.

key-wizard-learn-more = Află mai multe

radio-create-key =
    .label = Creează o cheie OpenPGP nouă
    .accesskey = C

radio-import-key =
    .label = Importă o cheie OpenPGP existentă
    .accesskey = I

radio-gnupg-key =
    .label = Folosește cheia externă prin GnuPG (de ex., de pe o cartelă inteligentă)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Generează o cheie OpenPGP

openpgp-generate-key-info = <b>Generarea unei chei poate dura câteva minute.</b> Nu ieși din aplicație cât timp se generează o cheie. Navigarea activă pe Internet sau efectuarea de operații cu solicitarea intensivă a calculatorului în timpul generării cheilor va mări nivelul de randomizare și va accelera procesul. Va fi afișat un mesaj la finalizarea generării cheii.

openpgp-keygen-expiry-title = Data de expirare a cheii

openpgp-keygen-expiry-description = Definește data de expirare a cheii noi generate. O poți ajusta mai târziu, pentru prelungire, dacă este necesar.

radio-keygen-expiry =
    .label = Cheia expiră în
    .accesskey = e

radio-keygen-no-expiry =
    .label = Cheia nu expiră
    .accesskey = d

openpgp-keygen-days-label =
    .label = zile
openpgp-keygen-months-label =
    .label = luni
openpgp-keygen-years-label =
    .label = ani

openpgp-keygen-advanced-title = Setări avansate

openpgp-keygen-advanced-description = Configurează setările avansate ale cheii OpenPGP.

openpgp-keygen-keytype =
    .value = Tip cheie:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Mărime cheie:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Curbă eliptică)

openpgp-keygen-button = Generează cheia

openpgp-keygen-progress-title = Se generează cheia nouă OpenPGP…

openpgp-keygen-import-progress-title = Se importă cheile OpenPGP…

openpgp-import-success = Cheile OpenPGP au fost importate cu succes!

openpgp-import-success-title = Finalizează procedura de import

openpgp-import-success-description = Ca să începi utilizarea cheii OpenPGP importate pentru criptarea mesajelor de e-mail, închide această fereastră de dialog, intră în Setările contului și selectează cheia.

openpgp-keygen-confirm =
    .label = Confirmă

openpgp-keygen-dismiss =
    .label = Anulează

openpgp-keygen-cancel =
    .label = Anulează procesul…

openpgp-keygen-import-complete =
    .label = Închide
    .accesskey = C

openpgp-keygen-missing-username = Nu există niciun nume specificat pentru contul curent. Introdu o valoare în câmpul   „Numele tău” din setările contului.
openpgp-keygen-long-expiry = Nu poți crea o cheie care să expire în mai mult de 100 de ani.
openpgp-keygen-short-expiry = Cheia trebuie să fie valabilă pentru cel puțin o zi.

openpgp-keygen-ongoing = Generarea cheii este deja în curs!

openpgp-keygen-error-core = Serviciul OpenPGP Core nu poate fi inițializat

openpgp-keygen-error-failed = Generarea cheii OpenPGP a eșuat în mod neașteptat

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Cheia OpenPGP a fost creată cu succes, dar nu s-a reușit obținerea revocării pentru cheia { $key }

openpgp-keygen-abort-title = Renunți la generarea cheii?
openpgp-keygen-abort = Generare cheie OpenPGP în curs. Sigur vrei să o anulezi?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generezi o cheie publică și secretă pentru { $identity }?

## Import Key section

openpgp-import-key-title = Importă o cheie personală OpenPGP existentă

openpgp-import-key-legend = Selectează un fișier de rezervă salvat anterior.

openpgp-import-key-description = Poți importa chei personale create cu alte softuri OpenPGP.

openpgp-import-key-info = Alte softuri pot descrie o cheie personală folosind termeni alternativi, precum cheie proprie, cheie secretă, cheie privată sau pereche de chei.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird a găsit o cheie pentru import.
        [few] Thunderbird a găsit { $count } chei pentru import.
       *[other] Thunderbird a găsit { $count } de chei pentru import.
    }

openpgp-import-key-list-description = Confirmă ce chei pot fi tratate drept cheile tale personale. Trebuie să folosești drept chei personale numai chei pe care le-ai creat chiar tu și care îți indică identitatea. Poți modifica această opțiune mai târziu, în fereastra de dialog Proprietăți cheie.

openpgp-import-key-list-caption = Cheile marcate să fie tratate drept chei personale vor fi enumerate în secțiunea Criptare end-to-end. Celelalte vor fi disponibile în Managerul de chei.

openpgp-passphrase-prompt-title = Necesită parolă

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Introdu parola pentru deblocarea cheii: { $key }

openpgp-import-key-button =
    .label = Selectează fișierul de importat…
    .accesskey = S

import-key-file = Importă fișierul de cheie OpenPGP

import-key-personal-checkbox =
    .label = Tratează această cheie drept cheie personală

gnupg-file = Fișiere GnuPG

import-error-file-size = <b>Eroare!</b> Nu se acceptă fișiere mai mari de 5MB.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Eroare!</b> Importul fișierului a eșuat. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Eroare!</b> Importul cheilor a eșuat. { $error }

openpgp-import-identity-label = Identitate

openpgp-import-fingerprint-label = Amprentă

openpgp-import-created-label = Create

openpgp-import-bits-label = Biți

openpgp-import-key-props =
    .label = Proprietăți cheie
    .accesskey = K

## External Key section

openpgp-external-key-title = Cheie GnuPG externă

openpgp-external-key-description = Configurează o cheie GnuPG externă prin introducerea ID-ului cheii

openpgp-external-key-info = În plus, trebuie să folosești managerul de chei ca să imporți și să accepți cheia publică aferentă.

openpgp-external-key-warning = <b>Poți configura numai o cheie GnuPG externă.</b> Datele introduse anterior vor fi înlocuite.

openpgp-save-external-button = Salvează ID cheie

openpgp-external-key-label = ID cheie secretă:

openpgp-external-key-input =
    .placeholder = 123456789341298340
