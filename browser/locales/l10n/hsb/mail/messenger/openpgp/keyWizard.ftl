# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Přidajće wosobinski OpenPGP-kluč za { $identity }
key-wizard-button =
    .buttonlabelaccept = Dale
    .buttonlabelhelp = Wróćo
key-wizard-warning = <b>Jeli eksistowacy wosobinski kluč za tutu e-mejlowu adresu maće</b>, wy měł jón importować. Hewak ani nimaće přistup k swojim archiwam zaklučowanych mejlkow ani njemóžeće dochadźace mejlki wot ludźi čitać, kotřiž hišće waš eksistowacy kluč wužiwaja.
key-wizard-learn-more = Dalše informacije
radio-create-key =
    .label = Nowy OpenPGP-kluč wutworić
    .accesskey = O
radio-import-key =
    .label = Eksistowacy OpenPGP-kluč importować
    .accesskey = E
radio-gnupg-key =
    .label = Wužiwajće swój eksterny kluč přez GnuPG (na př. ze smartkarty)
    .accesskey = G

## Generate key section

openpgp-generate-key-title = OpenPGP-kluč wutworić
openpgp-generate-key-info = <b>Wutworjenje kluča móže někotre mjeńšiny trać.</b> Njekónčće nałoženje, mjeztym zo so kluč wutworja. Hdyž aktiwnje přehladujeće abo operacije z intensiwnym wužiwanjom kruteje tačele wuwjedźeće, mjeztym zo so kluč wutworja, so ‚pool připadnosće‘ znowa napjelni a proces pospěši. Dóstanjeće zdźělenku, hdyž wutowrjenje kluča je dokónčene.
openpgp-keygen-expiry-title = Płaćiwosć kluča
openpgp-keygen-expiry-description = Nastajće čas płaćiwosće swojeho nowo wutworjeneho kluča. Móžeće pozdźišo čas podlěšić, jeli trjeba.
radio-keygen-expiry =
    .label = Kluč spadnje za
    .accesskey = l
radio-keygen-no-expiry =
    .label = Kluč njespadnje
    .accesskey = n
openpgp-keygen-days-label =
    .label = dnjow
openpgp-keygen-months-label =
    .label = měsacow
openpgp-keygen-years-label =
    .label = lět
openpgp-keygen-advanced-title = Rozšěrjene nastajenja
openpgp-keygen-advanced-description = Kontrolujće rozšěrjene nastajenja swojeho OpenPGP-kluča.
openpgp-keygen-keytype =
    .value = Klučowy typ:
    .accesskey = t
openpgp-keygen-keysize =
    .value = Wulkosć kluča:
    .accesskey = u
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (Elliptic Curve)
openpgp-keygen-button = Kluč wutworić
openpgp-keygen-progress-title = Waš nowy OpenPGP-kluč so wutwori…
openpgp-keygen-import-progress-title = Waše OpenPGP-kluče so importuja…
openpgp-import-success = OpenPGP-kluče wuspěšnje importowane!
openpgp-import-success-title = Importowanski proces dokónčić
openpgp-import-success-description = Zo byšće swój importowany OpenPGP-kluč za e-mejlowe zaklučowanje wužiwał, začińće tutón dialog a dźiće k swojim kontowym nastajenjam, zo byšće jón wubrał.
openpgp-keygen-confirm =
    .label = Wobkrućić
openpgp-keygen-dismiss =
    .label = Přetorhnyć
openpgp-keygen-cancel =
    .label = Proces přetorhnyć…
openpgp-keygen-import-complete =
    .label = Začinić
    .accesskey = Z
openpgp-keygen-missing-username = Njeje žane mjeno za aktualne konto podate. Prošu zapodajće hódnotu do pola   „Waše mjeno“ w kontowych nastajenjach.
openpgp-keygen-long-expiry = Njemóžeće kluč wutworić, kotryž za wjace hač 100 lět spadnje.
openpgp-keygen-short-expiry = Waš kluč dyrbi znajmjeńša jedyn dźeń płaćiwy być.
openpgp-keygen-ongoing = Wutworjenje kluča hižo běži!
openpgp-keygen-error-core = OpenPGP Core Service njeda so inicializować
openpgp-keygen-error-failed = Wutworjenje OpenPGP-kluča je so njenadźicy nimokuliło
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-kluč je so wuspěšnje wutworił, ale njeje so poradźiło, wotwołanje za kluč { $key } dóstać.
openpgp-keygen-abort-title = Wutworjenje kluča přetorhnyć?
openpgp-keygen-abort = Wutworjenje OpenPGP-kluča tuchwilu běži, chceće jo woprawdźe přetorhnyć?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Zjawny a tajny kluč za { $identity } wutworić?

## Import Key section

openpgp-import-key-title = Eksistowacy wosobinski OpenPGP-kluč importować
openpgp-import-key-legend = Wubjerće do toho zawěsćenu dataju.
openpgp-import-key-description = Móžeće wosobinske kluče importować, kotrež su so z druhej OpenPGP-softwaru wutworili.
openpgp-import-key-info = Druha softwara móhła wosobinski kluč z alternatiwnymi zapřijećemi wopisać, na přikład swójski kluč, tajny kluč abo klučowy por.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird je { $count } kluč namakał, kotryž da so importować.
        [two] Thunderbird je { $count } klučej namakał, kotrejž datej so importować.
        [few] Thunderbird je { $count } kluče namakał, kotrež dadźa so importować.
       *[other] Thunderbird je { $count } klučow namakał, kotrež da so importować.
    }
openpgp-import-key-list-description = Wobkrućće, kotre kluče maja waše wosobinske kluče być. Jenož kluče, kotrež sće sam wutworił a kotrež wašu identitu pokazuja, měli jako wosobinske kluče wužiwać. Móžeće tute nastajenje pozdźišo w dialogu klučowych kajkosćow změnić.
openpgp-import-key-list-caption = Kluče, kotrež su jako wosobinske kluče wobkrućene, so we wotrězku kluč do kluča nalistuja. Druhe su w zrjadowaku klučow k dispoziciji.
openpgp-passphrase-prompt-title = Hesłowa fraza trěbna
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Prošu zapodajće hesłowu frazu, zo byšće slědowacy kluč přewostajił: { $key }
openpgp-import-key-button =
    .label = Wubjerće dataju, kotraž ma so importować…
    .accesskey = u
import-key-file = Dataju OpenPGP-kluča importować
import-key-personal-checkbox =
    .label = Z tutym klučom kaž z wosobinskim klučom wobchadźeć
gnupg-file = GnuPG-dataje
import-error-file-size = <b>Zmylk!</b> Dataje, kotrež su wjetše hač 5 MB, so njepodpěruja.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Zmylk!</b> Dataja njeda so importować. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Zmylk!</b>Kluče njedachu so importować. { $error }
openpgp-import-identity-label = Identita
openpgp-import-fingerprint-label = Porstowy wotćišć
openpgp-import-created-label = Wutworjeny
openpgp-import-bits-label = Bity
openpgp-import-key-props =
    .label = Klučowe kajkosće
    .accesskey = K

## External Key section

openpgp-external-key-title = Eksterny GnuPG-kluč
openpgp-external-key-description = Zapodajće klučowy ID, zo byšće eksterny GnuPG-kluč konfigurował
openpgp-external-key-info = Nimo toho dyrbiće zrjadowak klučow wužiwać, zo byšće wotpowědny zjawny kluč importował a akceptował.
openpgp-external-key-warning = <b>Móžeće snano jenož jedyn eksterny GnuPG-kluč konfigurować.</b> Waš předchadny zapisk so wuměni.
openpgp-save-external-button = Klučowy ID składować
openpgp-external-key-label = Tajny klučowy ID:
openpgp-external-key-input =
    .placeholder = 123456789341298340
