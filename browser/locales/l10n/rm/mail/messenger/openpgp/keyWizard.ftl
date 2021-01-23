# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Agiuntar ina clav OpenPGP persunala per { $identity }

key-wizard-button =
    .buttonlabelaccept = Cuntinuar
    .buttonlabelhelp = Turnar

key-wizard-warning = <b>Sche ti has ina clav persunala existenta</b> per questa adressa d'e-mail, la duessas ti importar. Autramain na vegns ti ni ad avair access a tes archivs dad e-mails criptads ni a pudair leger e-mails criptads che arrivan da persunas che utiliseschan anc tia clav existenta.

key-wizard-learn-more = Ulteriuras infurmaziuns

radio-create-key =
    .label = Crear ina nova clav OpenPGP
    .accesskey = C

radio-import-key =
    .label = Importar ina clav OpenPGP existenta
    .accesskey = I

radio-gnupg-key =
    .label = Utilisar tia clav externa via GnuPG (p.ex. dad ina smartcard)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Generar ina clav OpenPGP

openpgp-generate-key-info = <b>La generaziun dad ina clav po durar pliras minutas.</b> Na terminescha betg l'applicaziun enfin che la generaziun da la clav n'è betg finida. Cun navigar activamain u exequir operaziuns exigentas per il disc dir durant la generaziun da la clav, pos ti augmentar il nivel da casualitad ed accelerar il process. Ti vegns infurmà uschespert ch'il process è terminà.

openpgp-keygen-expiry-title = Scadenza da la clav

openpgp-keygen-expiry-description = Definescha la data da scadenza da tia clav gist generada. Ti pos adattar pli tard la data da scadenza per la prolungar, sche necessari.

radio-keygen-expiry =
    .label = La clav scada en
    .accesskey = e

radio-keygen-no-expiry =
    .label = La clav na scada mai
    .accesskey = d

openpgp-keygen-days-label =
    .label = dis
openpgp-keygen-months-label =
    .label = mais
openpgp-keygen-years-label =
    .label = onns

openpgp-keygen-advanced-title = Parameters avanzads

openpgp-keygen-advanced-description = Controllescha ils parameters avanzads da tia clav OpenPGP.

openpgp-keygen-keytype =
    .value = Tip da clav:
    .accesskey = T

openpgp-keygen-keysize =
    .value = Dimensiun da la clav:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (curva elliptica)

openpgp-keygen-button = Generar la clav

openpgp-keygen-progress-title = Generar la nova clav OpenPGP…

openpgp-keygen-import-progress-title = Importar tias clavs OpenPGP…

openpgp-import-success = Importà cun success las clavs OpenPGP!

openpgp-import-success-title = Conclusiun dal process d'importaziun

openpgp-import-success-description = Per cumenzar ad utilisar tia clav OpenPGP importada per la criptaziun dad e-mails, serra quest dialog ed acceda a la configuraziun da contos per la tscherner.

openpgp-keygen-confirm =
    .label = Confermar

openpgp-keygen-dismiss =
    .label = Interrumper

openpgp-keygen-cancel =
    .label = Annullar il process…

openpgp-keygen-import-complete =
    .label = Serrar
    .accesskey = S

openpgp-keygen-missing-username = I n'è vegnì specifitgà nagin num per il conto actual. Endatescha per plaschair ina valur en il champ  «Tes num» en la configuraziun da contos.
openpgp-keygen-long-expiry = I n'è betg pussaivel da crear clavs che scadan en dapli che 100 onns.
openpgp-keygen-short-expiry = Ti clav sto esser valida per almain in di.

openpgp-keygen-ongoing = La generaziun da la clav è gia en lavur!

openpgp-keygen-error-core = Impussibel d'inizialisar il servetsch principal da OpenPGP

openpgp-keygen-error-failed = Ina errur nunspetgada ha impedì la generaziun da la clav OpenPGP

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = La clav OpenPGP è vegnida creada cun success, ma i n'è betg reussì dad obtegnair la revocaziun per la clav { $key }

openpgp-keygen-abort-title = Interrumper la generaziun da la clav?
openpgp-keygen-abort = La generaziun da la clav OpenPGP è en lavur. La vuls ti propi interrumper?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generar ina clav publica ed ina clav secreta per { $identity }?

## Import Key section

openpgp-import-key-title = Importar ina clav OpenPGP persunala existenta

openpgp-import-key-legend = Tscherna ina datoteca da backup creada pli baud.

openpgp-import-key-description = Igl è pussaivel dad importar clavs persunalas creadas cun in'autra software OpenPGP.

openpgp-import-key-info = Autra software dovra eventualmain terminologia differenta per descriver la clav persunala.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird ha chattà ina clav che po vegnir importada.
       *[other] Thunderbird ha chattà { $count } clavs che pon vegnir importadas.
    }

openpgp-import-key-list-description = Conferma tge clavs che pon vegnir consideradas sco tias clavs persunalas. Mo clavs che ti tez has creà e che mussan tia atgna identitad duessan vegnir utilisadas sco clavs persunalas. Ti pos midar questa opziun pli tard en il dialog «Caracteristicas da clavs».

openpgp-import-key-list-caption = Las clavs marcadas sco clavs persunalas vegnan enumeradas en la secziun da criptadi da fin a fin. Tschellas stattan a disposiziun en l'administraziun da clavs.

openpgp-passphrase-prompt-title = Frasa-clav obligatorica

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Endatescha per plaschair la frasa-clav per debloccar la suandanta clav: { $key }

openpgp-import-key-button =
    .label = Tscherna la datoteca che duai vegnir importada…
    .accesskey = T

import-key-file = Importar ina datoteca da clav OpenPGP

import-key-personal-checkbox =
    .label = Considerar questa clav sco clav persunala

gnupg-file = Datotecas GnuPG

import-error-file-size = <b>Errur!</b> Datotecas che surpassan 5MB na vegnan betg sustegnidas.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Errur!</b> Betg reussì dad importar la datoteca. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Errur!</b> Betg reussì dad importar las clavs. { $error }

openpgp-import-identity-label = Identitad

openpgp-import-fingerprint-label = Impronta dal det

openpgp-import-created-label = Data da creaziun

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Caracteristicas da clavs
    .accesskey = C

## External Key section

openpgp-external-key-title = Clav GnuPG externa

openpgp-external-key-description = Configurar ina clav GnuPG externa cun endatar l'ID da la clav

openpgp-external-key-info = Ultra da quai stos ti utilisar l'administraziun da clavs per importar ed acceptar la clav publica correspundenta.

openpgp-external-key-warning = <b>I n'è betg pussaivel da configurar dapli ch'ina clav GnuPG externa.</b> Tia endataziun precedenta vegn remplazzada.

openpgp-save-external-button = Memorisar l'ID da la clav

openpgp-external-key-label = ID da la clav secreta:

openpgp-external-key-input =
    .placeholder = 123456789341298340
