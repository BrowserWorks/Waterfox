# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Shtoni një Kyç Personal OpenPGP për { $identity }

key-wizard-button =
    .buttonlabelaccept = Vazhdo
    .buttonlabelhelp = Kthehu mbrapsht

key-wizard-warning = <b>Nëse keni një kyç personal ekzistues</b> për këtë adresë email, duhet ta importoni. Përndryshe, s’do të mund të hyni te email-et tuaj të fshehtëzuar të arkivuar, as do të jeni në gjendje të lexoni email-e të fshehtëzuar që vijnë nga persona të cilët përdorin ende kyçin tuaj ekzistues.

key-wizard-learn-more = Mësoni më tepër

radio-create-key =
    .label = Krijoni një Kyç të ri OpenPGP
    .accesskey = K

radio-import-key =
    .label = Importoni një Kyç ekzistues OpenPGP
    .accesskey = I

radio-gnupg-key =
    .label = Përdoreni kyçin tuaj të jashtëm përmes GnuPG-së (p.sh., prej një smartcard-i)
    .accesskey = P

## Generate key section

openpgp-generate-key-title = Prodho Kyç OpenPGP

openpgp-generate-key-info = <b>Prodhimi i kyçit mund të dojë deri në disa minuta që të plotësohet.</b> Mos e mbyllni aplikacionin, teksa bëhet prodhimi i kyçit. Shfletimi aktivisht ose kryerja e veprimeve që angazhojnë fort diskun, gjatë prodhimit të kyçit, do të rimbushë “randomness pool” dhe do të përshpejtojë procesin. Kur prodhimi i kyçit të jetë plotësuar, do të njoftoheni.

openpgp-keygen-expiry-title = Skadim kyçi

openpgp-keygen-expiry-description = Përcaktoni kohën e skadimit të kyçit tuaj të sapoprodhuar. Datën mund ta kontrolloni më vonë, për ta shtyrë më tej, nëse duhet.

radio-keygen-expiry =
    .label = Kyçi skadon për
    .accesskey = s

radio-keygen-no-expiry =
    .label = Kyçi nuk skadon
    .accesskey = n

openpgp-keygen-days-label =
    .label = ditë
openpgp-keygen-months-label =
    .label = muaj
openpgp-keygen-years-label =
    .label = vjet

openpgp-keygen-advanced-title = Rregullime të mëtejshme

openpgp-keygen-advanced-description = Kontrolloni rregullimet e mëtejshme të Kyçit tuaj OpenPGP.

openpgp-keygen-keytype =
    .value = Lloj kyçi:
    .accesskey = L

openpgp-keygen-keysize =
    .value = Madhësi kyçi:
    .accesskey = M

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Lakore Eliptike)

openpgp-keygen-button = Prodho kyç

openpgp-keygen-progress-title = Krijoni Kyçin tuaj të ri OpenPGP…

openpgp-keygen-import-progress-title = Po importohen Kyçet tuaj OpenPGP…

openpgp-import-success = Kyçet OpenPGP u importuan me sukses!

openpgp-import-success-title = Plotësoni procesin e importimit

openpgp-import-success-description = Që të filloni të përdorni për fshehtëzim email-esh kyçin tuaj OpenPGP, mbylleni këtë dialog dhe hyni te Rregullimet e Llogarisë tuaj që ta përzgjidhni.

openpgp-keygen-confirm =
    .label = Ripohojeni

openpgp-keygen-dismiss =
    .label = Anuloje

openpgp-keygen-cancel =
    .label = Anulojeni procesin…

openpgp-keygen-import-complete =
    .label = Mbylle
    .accesskey = M

openpgp-keygen-missing-username = Për llogarinë e tanishme s’ka emër të përcaktuar. Ju lutemi, jepni një vlerë te fusha "Emri juaj" te rregullimet e llogarisë.
openpgp-keygen-long-expiry = S’mund të krijoni një kyç që skadon për më tepër se 100 vjet.
openpgp-keygen-short-expiry = Kyçi juaj duhet të jetë i vlefshëm për të paktën një ditë.

openpgp-keygen-ongoing = Prodhim kyçi tashmë në kryerje e sipër!

openpgp-keygen-error-core = S’arrihet të niset Shërbimi Bazë OpenPGP

openpgp-keygen-error-failed = Prodhimi i Kyçit OpenPGP dështoi papritmas

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Kyçi OpenPGP u krijua me sukses, por s’u arrit të merrej shfuqizim për kyçin { $key }

openpgp-keygen-abort-title = Të ndërpritet prodhimi i kyçit?
openpgp-keygen-abort = Prodhim Kyçi OpenPGP aktualisht në kryerje e sipër, jeni i sigurt se doni të anulohet?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Të prodhohen kyç publik dhe i fshehtë për { $identity }?

## Import Key section

openpgp-import-key-title = Importoni një Kyç personal ekzistues OpenPGP

openpgp-import-key-legend = Përzgjidhni një kartelë të kopjeruajtur më parë.

openpgp-import-key-description = Mund të importoni kyçe personale që qenë krijuar me tjetër program OpenPGP.

openpgp-import-key-info = Tjetër program mund të përshkruajë një kyç personal duke përdorur terma alternativë, bie fjala, kyçi juaj, kyç i fshehtë, kyç privat ose çift kyçesh.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird-i gjeti një kyç që mund të importohet.
       *[other] Thunderbird-i gjeti { $count } kyçe që mund të importohen.
    }

openpgp-import-key-list-description = Ripohoni cilët kyçe mund të trajtohen si kyçet tuaj personalë. Si kyçe personalë duhen përdorur vetëm kyçe që krijuat ju vetë dhe që shfaqin identitetin tuaj. Këtë mundësi mund ta ndryshoni më vonë që nga dialogu Veti Kyçi.

openpgp-import-key-list-caption = Kyçet e shënuar për t’u trajtuar si Kyçe Personalë do të radhiten te ndarja Fshehtëzim Skaj-Më-Skaj. Të tjerët do të jenë të passhëm brenda Përgjegjësit të Kyçeve.

openpgp-passphrase-prompt-title = Lypset frazëkalim

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Ju lutemi, jepni frazëkalimin që të shkyçet kyçi vijues: { $key }

openpgp-import-key-button =
    .label = Përzgjidhni Kartelë për Importim…
    .accesskey = P

import-key-file = Importo Kartelë Kyçi OpenPGP

import-key-personal-checkbox =
    .label = Trajtoje këtë si një Kyç Personal

gnupg-file = Kartela GnuPG

import-error-file-size = <b>Gabim!</b> Nuk mbulohen kartela më të mëdha se 5MB.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Gabim!</b> S’u arrit të importohej kartelë. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Gabim!</b> S’u arrit të importohen kyçe. { $error }

openpgp-import-identity-label = Identitet

openpgp-import-fingerprint-label = Shenja gishtash

openpgp-import-created-label = U krijua

openpgp-import-bits-label = Bite

openpgp-import-key-props =
    .label = Veti Kyçi
    .accesskey = V

## External Key section

openpgp-external-key-title = Kyç GnuPG i Jashtëm

openpgp-external-key-description = Formësoni një kyç të jashtëm duke dhënë ID-në e Kyçit

openpgp-external-key-info = Veç kësaj, duhet të përdorni Përgjegjës Kyçesh për të importuar dhe pranuar Kyçin Publik përkatës.

openpgp-external-key-warning = <b>Mund të formësoni vetëm një Kyç të jashtëm GnuPG.</b> Zëri juaj i mëparshëm do të zëvendësohet.

openpgp-save-external-button = Ruaj ID kyçi

openpgp-external-key-label = ID Kyçi të Fshehtë:

openpgp-external-key-input =
    .placeholder = 123456789341298340
