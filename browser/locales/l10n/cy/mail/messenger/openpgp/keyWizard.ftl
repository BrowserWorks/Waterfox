# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Ychwanegu Allwedd OpenPGP Personol ar gyfer { $identity }

key-wizard-button =
    .buttonlabelaccept = Parhau
    .buttonlabelhelp = Nôl

key-wizard-warning = <b>Os oes gennych allwedd bersonol bresennol</b> ar gyfer y cyfeiriad e-bost hwn, dylech ei fewnforio. Fel arall ni fydd gennych fynediad i'ch archifau o e-byst wedi'u hamgryptio, nac yn gallu darllen e-byst wedi'u hamgryptio rydych yn eu derbyn gan bobl sy'n dal i ddefnyddio'ch allwedd bresennol.

key-wizard-learn-more = Dysgu rhagor

radio-create-key =
    .label = Creu Allwedd OpenPGP newydd
    .accesskey = C

radio-import-key =
    .label = Mewnforio Allwedd OpenPGP cyfredol
    .accesskey = M

radio-gnupg-key =
    .label = Defnyddio'ch allwedd allanol trwy GnuPG (e.e. o gerdyn clyfar)
    .accesskey = D

## Generate key section

openpgp-generate-key-title = Cynhyrchu Allwedd OpenPGP

openpgp-generate-key-info = <b>Gall cynhyrchu allweddol gymryd rhai munudau i'w gwblhau.</b> Peidiwch â gadael y rhaglen tra bo'r allwedd yn cael ei gynhyrchu. Bydd pori neu berfformio gweithrediadau disg-ddwys yn ystod cynhyrchu'r allwedd yn ailgyflenwi'r 'gronfa ar hap' ac yn cyflymu'r broses. Cewch eich rhybuddio pan fydd cynhyrchu'r allweddol wedi'i gwblhau.

openpgp-keygen-expiry-title = Allwedd yn dod i ben

openpgp-keygen-expiry-description = Diffiniwch amser dod i ben eich allwedd sydd newydd ei chynhyrchu. Yn ddiweddarach, gallwch reoli'r dyddiad i'w ymestyn os oes angen.

radio-keygen-expiry =
    .label = Allwedd yn dod i ben ar
    .accesskey = l

radio-keygen-no-expiry =
    .label = Nid yw'r allwedd yn dod i ben
    .accesskey = N

openpgp-keygen-days-label =
    .label = diwrnod
openpgp-keygen-months-label =
    .label = mis
openpgp-keygen-years-label =
    .label = blwyddyn

openpgp-keygen-advanced-title = Gosodiadau uwch

openpgp-keygen-advanced-description = Rheoli gosodiadau uwch eich Allwedd OpenPGP.

openpgp-keygen-keytype =
    .value = Math o allwedd:
    .accesskey = M

openpgp-keygen-keysize =
    .value = Maint yr allwedd:
    .accesskey = a

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Cromlin Elliptig)

openpgp-keygen-button = Cynhyrchu allwedd

openpgp-keygen-progress-title = Cynhyrchu eich Allwedd OpenPGP newydd ...

openpgp-keygen-import-progress-title = Mewnforio eich Allweddi OpenPGP...

openpgp-import-success = Allweddi OpenPGP wedi'u mewnforio'n llwyddiannus!

openpgp-import-success-title = Cwblhewch y broses fewnforio

openpgp-import-success-description = I ddechrau defnyddio'ch allwedd OpenPGP wedi'i fewnforio ar gyfer amgryptio e-bost, caewch y dialog hwn ac ewch i'ch Gosodiadau Cyfrif i'w ddewis.

openpgp-keygen-confirm =
    .label = Cadarnhau

openpgp-keygen-dismiss =
    .label = Diddymu

openpgp-keygen-cancel =
    .label = Diddymu'r broses ...

openpgp-keygen-import-complete =
    .label = Cau
    .accesskey = C

openpgp-keygen-missing-username = Nid oes enw wedi'i nodi ar gyfer y cyfrif cyfredol. Rhowch werth yn y maes "Eich enw" yng ngosodiadau'r cyfrif.
openpgp-keygen-long-expiry = Nid oes modd i chi greu allwedd sy'n dod i ben mewn mwy na 100 mlynedd.
openpgp-keygen-short-expiry = Rhaid i'ch allwedd fod yn ddilys am o leiaf un diwrnod.

openpgp-keygen-ongoing = Eisoes wrthi'n cynhyrchu allwedd!

openpgp-keygen-error-core = Methu cychwyn Gwasanaeth Craidd OpenPGP

openpgp-keygen-error-failed = Yn annisgwyl, methwyd cynhyrchu allwedd OpenPGP

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Crëwyd Allwedd OpenPGP yn llwyddiannus, ond methodd â chael dirymiad ar gyfer allwedd { $key }

openpgp-keygen-abort-title = Atal cynhyrchu allwedd?
openpgp-keygen-abort = Mae cynhyrchu allwedd OpenPGP ar y gweill ar hyn o bryd, a ydych chi'n siŵr eich bod am ei ddiddymu?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Cynhyrchu allwedd gyhoeddus a chyfrinachol ar gyfer { $identity }?

## Import Key section

openpgp-import-key-title = Mewnforio Allwedd OpenPGP personol sy'n bodoli eisoes

openpgp-import-key-legend = Dewis ffeil a gadwyd wrth gefn.

openpgp-import-key-description = Gallwch fewnforio allweddi personol a gafodd eu creu gyda meddalwedd OpenPGP arall.

openpgp-import-key-info = Gall meddalwedd arall ddisgrifio allwedd bersonol gan ddefnyddio termau amgen fel eich allwedd eich hun, allwedd gyfrinachol, allwedd breifat neu bar o allweddi.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [zero] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
        [one] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
        [two] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
        [few] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
        [many] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
       *[other] Daeth Thunderbird o hyd i allweddi { $count } y mae modd eu mewnforio.
    }

openpgp-import-key-list-description = Cadarnhewch pa allweddi y mae modd eu trin fel eich allweddi personol. Dim ond allweddi y gwnaethoch chi eu creu eich hun ac sy'n dangos eich hunaniaeth eich hun y dylid eu defnyddio fel allweddi personol. Gallwch newid yr dewis hwn yn nes ymlaen yn y dialog Priodweddau Allweddi.

openpgp-import-key-list-caption = Bydd allweddi sydd wedi'u marcio i'w trin fel Allweddi Personol yn cael eu rhestru yn yr adran Amgryptio Ben-i-Ben. Bydd y lleill ar gael y tu mewn i'r Rheolwr Allweddi.

openpgp-passphrase-prompt-title = Mae angen cyfrinymadrodd

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Rhowch y cyfrinymadrodd i ddatgloi'r allwedd ganlynol: { $key }

openpgp-import-key-button =
    .label = Dewis Ffeil i'w Mewnforio ...
    .accesskey = D

import-key-file = Mewnforio Ffeil Allwedd OpenPGP

import-key-personal-checkbox =
    .label = Trin yr allwedd hon fel Allwedd Bersonol

gnupg-file = Ffeiliau GnuPG

import-error-file-size = <b>Gwall!</b> Nid yw ffeiliau mwy na 5MB yn cael eu cefnogi.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Gwall!</b> Wedi methu mewnforio ffeil. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Gwall!</b> Wedi methu mewnforio allweddi. { $error }

openpgp-import-identity-label = Hunaniaeth

openpgp-import-fingerprint-label = Bysbrint

openpgp-import-created-label = Crëwyd

openpgp-import-bits-label = Didau

openpgp-import-key-props =
    .label = Priodweddau'r Allwedd
    .accesskey = P

## External Key section

openpgp-external-key-title = Allwedd GnuPG Allanol

openpgp-external-key-description = Ffurfweddu allwedd GnuPG allanol trwy nodi ID yr Allwedd

openpgp-external-key-info = Yn ogystal, rhaid i chi ddefnyddio'r Rheolwr Allweddi i fewnforio a derbyn yr Allwedd Gyhoeddus gyfatebol.

openpgp-external-key-warning = <b>Dim ond un Allwedd GnuPG allanol y gallwch chi ei ffurfweddu.</b> Bydd eich cofnod blaenorol yn cael ei ddisodli.

openpgp-save-external-button = Cadw ID yr allwedd

openpgp-external-key-label = ID Allwedd Gyfrinachol:

openpgp-external-key-input =
    .placeholder = 123456789341298340
