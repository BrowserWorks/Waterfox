# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Adder un clave OpenPGP personal pro { $identity }

key-wizard-button =
    .buttonlabelaccept = Continuar
    .buttonlabelhelp = Receder

key-wizard-warning = <b>Si tu ha un clave personal existente</b> pro iste adresse email, tu deberea importar lo. Alteremente tu non habera accesso a tu archivos de emails cryptate, ni potera leger emails in arrivata cryptate de illes qui usa ancora tu clave existente.

key-wizard-learn-more = Saper plus

radio-create-key =
    .label = Generar clave OpenPGP
    .accesskey = c

radio-import-key =
    .label = Importar un existente clave OpenPGP
    .accesskey = I

radio-gnupg-key =
    .label = Usa tu clave externe per GnuPG (e.g. de un smartcard)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Generar clave OpenPGP

openpgp-generate-key-info = <b>Le generation de clave pote occupar usque plure minutas pro completar.</b> Non exir del application durante que es in curso le generation del clave. Navigar activemente o exequer operationes intensive pro le disco durante le generation del clave replena le 'piscina aleatori' e accelera le procedura. Tu sera alertate quando generation del clave es completate.

openpgp-keygen-expiry-title = Expiration del clave

openpgp-keygen-expiry-description = Defini le expiration tempore de tu clave generate novemente. Tu pote plus tarde controlar le data pro extender lo si necessari.

radio-keygen-expiry =
    .label = Le clave expirara in:
    .accesskey = x

radio-keygen-no-expiry =
    .label = Le clave non expira
    .accesskey = n

openpgp-keygen-days-label =
    .label = dies
openpgp-keygen-months-label =
    .label = menses
openpgp-keygen-years-label =
    .label = annos

openpgp-keygen-advanced-title = Parametros avantiate

openpgp-keygen-advanced-description = Controlar le parametros avantiate de tu clave OpenPGP.

openpgp-keygen-keytype =
    .value = Typo de clave:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Dimension del clave:
    .accesskey = D

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (curva elliptic)

openpgp-keygen-button = Generar clave

openpgp-keygen-progress-title = Generation de tu nove clave OpenPGP…

openpgp-keygen-import-progress-title = Importation de tu claves OpenPGP…

openpgp-import-success = Claves OpenPGP importate con successo!

openpgp-import-success-title = Completar le procedura de importation

openpgp-import-success-description = Pro initiar usar tu clave OpenPGP importate pro cryptographia email, claude iste fenestra de dialogo e accede a tu parametros de conto pro eliger lo.

openpgp-keygen-confirm =
    .label = Confirmar

openpgp-keygen-dismiss =
    .label = Cancellar

openpgp-keygen-cancel =
    .label = Cancellar procedura…

openpgp-keygen-import-complete =
    .label = Clauder
    .accesskey = C

openpgp-keygen-missing-username = Il ha nulle nomine specific pro le actual conto. Insere un valor in le campo · "Tu nomine" in le parametros del conto.
openpgp-keygen-long-expiry = Tu non pote crea un clave que expira in plus de 100 annos.
openpgp-keygen-short-expiry = Tu clave debe esser valide pro al minus un die.

openpgp-keygen-ongoing = Generation del clave jam in curso!

openpgp-keygen-error-core = Impossibile initialisar le servicio nucleo de OpenPGP

openpgp-keygen-error-failed = Generation del clave OpenPGP fallite inexpectatemente

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Clave OpenPGP create con successo, ma falta a obtener le revocation pro le clave { $key }

openpgp-keygen-abort-title = Abortar le generation del clave?
openpgp-keygen-abort = Generation del clave OpenPGP actualmente in curso, desira tu vermente cancellar lo?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generar clave public e secrete pro { $identity }?

## Import Key section

openpgp-import-key-title = Importar un clave OpenPGP personal existente

openpgp-import-key-legend = Eliger un file reservate previemente.

openpgp-import-key-description = Tu pote importar claves personal que ha essite create con altere software OpenPGP.

openpgp-import-key-info = Altere software pote describer un clave personal per terminos alternative tal como tu proprie clave, secrete clave, clave private o par de claves.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird trovava un clave que pote esser importate.
       *[other] Thunderbird trovava { $count } claves que pote esser importate.
    }

openpgp-import-key-list-description = Confirmar que le claves pote esser tractate como tu claves personal. Solo claves que tu mesme ha create e que monstrar tu proprie identitate debe esser usate como claves personal. Tu pote cambiar iste option plus tarde in le fenestra de dialogo Proprietates del clave.

openpgp-import-key-list-caption = Le claves marcate pro esser tractate como claves personal sera presentate in le section Cryptographia end-to-end. Los altere sera disponibile intra le gestor del claves.

openpgp-passphrase-prompt-title = Phrase contrasigno obligatori

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Insere le phrase contrasigno pro disblocar le sequente clave: { $key }

openpgp-import-key-button =
    .label = Elige le file a importar…
    .accesskey = E

import-key-file = Importar le file clave OpenPGP

import-key-personal-checkbox =
    .label = Tractar iste clave como clave personal

gnupg-file = Files GnuPG

import-error-file-size = <b>Error!</b> Files major de 5MB non es supportate.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Error!</b> Falta a importar file. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Error!</b> Falta a importar claves. { $error }

openpgp-import-identity-label = Identitate

openpgp-import-fingerprint-label = Dactylogramma

openpgp-import-created-label = Create

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Proprietates del clave
    .accesskey = P

## External Key section

openpgp-external-key-title = Clave GnuPG externe

openpgp-external-key-description = Configurar un clave GnuPG externe per le introduction del ID clave

openpgp-external-key-info = In addition, tu debe usar le gestor del claves pro importar e acceptar le clave public correspondente.

openpgp-external-key-warning = <b>Tu pote configurar un singule clave GnuPG externe.</b> Tu previe entrata sera supplantate.

openpgp-save-external-button = Salvar ID del clave

openpgp-external-key-label = ID del clave secrete:

openpgp-external-key-input =
    .placeholder = 123456789341298340
