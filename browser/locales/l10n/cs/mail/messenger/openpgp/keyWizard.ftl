# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Přidat osobní klíč OpenPGP pro { $identity }

key-wizard-button =
    .buttonlabelaccept = Pokračovat
    .buttonlabelhelp = Zpět

key-wizard-warning = <b>Pokud už máte</b> pro tuto e-mailovou adresu vytvořený osobní klíč, měli byste ho naimportovat. Jinak nebudete mít přístup do svých archivů šifrovaných e-maily, ani nebudete moci číst příchozí šifrované e-maily od lidí, kteří stále používají tento váš vytvořený klíč.

key-wizard-learn-more = Zjistit více

radio-create-key =
    .label = Vytvořit nový klíč OpenPGP
    .accesskey = V

radio-import-key =
    .label = Importovat již vytvořený klíč OpenPGP
    .accesskey = I

radio-gnupg-key =
    .label = Použít svůj externí klíč prostřednictvím GnuPG (např. z čipové karty)
    .accesskey = P

## Generate key section

openpgp-generate-key-title = Vytvořit klíč OpenPGP

openpgp-generate-key-info = <b>Vytváření klíče může trvat až několik minut.</b> Po tu dobu prosím aplikaci neukončujte. Proces se urychlí, když budete aktivně pracovat s prohlížečem nebo provádět operace s častým přístupem k pevnému disku. Až bude vytváření klíče dokončeno, budete upozorněni.

openpgp-keygen-expiry-title = Doba platnosti klíče

openpgp-keygen-expiry-description = Určete dobu platnosti svého nově vytvořeného klíče. Dobu platnosti můžete později změnit a v případě potřeby ji prodloužit.

radio-keygen-expiry =
    .label = Platnost klíče skončí za
    .accesskey = s

radio-keygen-no-expiry =
    .label = Platnost klíče není omezená
    .accesskey = n

openpgp-keygen-days-label =
    .label = dnů
openpgp-keygen-months-label =
    .label = měsíců
openpgp-keygen-years-label =
    .label = roků

openpgp-keygen-advanced-title = Pokročilé nastavení

openpgp-keygen-advanced-description = Určete pokročilá nastavení vašeho klíče OpenPGP.

openpgp-keygen-keytype =
    .value = Typ klíče:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Velikost klíče:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (eliptická křivka)

openpgp-keygen-button = Vytvořit klíč

openpgp-keygen-progress-title = Vytváření nového klíče OpenPGP…

openpgp-keygen-import-progress-title = Importování klíčů OpenPGP…

openpgp-import-success = Klíče OpenPGP byly úspěšně naimportovány!

openpgp-import-success-title = Dokončit proces importu

openpgp-import-success-description = Abyste svůj naimportovaný klíč OpenPGP mohli začít používat k šifrování e-mailů, zavřete toto dialogové okno a vyberte ho v nastavení účtu.

openpgp-keygen-confirm =
    .label = Potvrdit

openpgp-keygen-dismiss =
    .label = Zrušit

openpgp-keygen-cancel =
    .label = Zrušit proces…

openpgp-keygen-import-complete =
    .label = Zavřít
    .accesskey = Z

openpgp-keygen-missing-username = Pro aktuální účet není udáno žádné jméno. Zadejte prosím v nastavení účtu nějakou hodnotu do pole „Vaše jméno“.
openpgp-keygen-long-expiry = Nemůžete vytvořit klíč s platností delší než 100 let.
openpgp-keygen-short-expiry = Váš klíč musí být platný minimálně jeden den.

openpgp-keygen-ongoing = Vytváření klíče už probíhá!

openpgp-keygen-error-core = Nelze inicializovat službu OpenPGP

openpgp-keygen-error-failed = Vytváření klíče OpenPGP neočekávaně selhalo

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Klíč OpenPGP byl úspěšně vytvořen, ale nepodařilo se získat zneplatnění pro klíč { $key }

openpgp-keygen-abort-title = Přerušit vytváření klíče?
openpgp-keygen-abort = Právě probíhá vytváření klíče OpenPGP, opravdu to chcete zrušit?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Chcete vytvořit veřejný a tajný klíč pro identitu { $identity }?

## Import Key section

openpgp-import-key-title = Importovat už vytvořený osobní klíč OpenPGP

openpgp-import-key-legend = Výběr dříve zálohovaného souboru

openpgp-import-key-description = Můžete naimportovat osobní klíče, které byly vytvořeny pomocí jiného softwaru OpenPGP.

openpgp-import-key-info = Jiný software může pro osobní klíč používat jiné názvy, např. „váš vlastní klíč“, „tajný klíč“, „soukromý klíč“ nebo „pár klíčů“.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird našel jeden klíč, který lze importovat.
        [few] Thunderbird našel { $count } klíče, které lze importovat.
       *[other] Thunderbird našel { $count } klíčů, které lze importovat.
    }

openpgp-import-key-list-description = Potvrďte, které klíče mohou být považovány za vaše osobní klíče. Jako vaše osobní klíče by měly být použity pouze klíče, které jste si sami vytvořili a které zobrazují vaši vlastní identitu. Tuto volbu můžete později změnit v dialogu Vlastnosti klíče.

openpgp-import-key-list-caption = Klíče označené jako osobní klíče budou uvedeny v sekci Koncové šifrování. Ostatní budou k dispozici ve správci klíčů.

openpgp-passphrase-prompt-title = Vyžadována přístupová fráze

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Zadejte prosím přístupovou frázi pro odemknutí následujícího klíče: { $key }

openpgp-import-key-button =
    .label = Vybrat soubor k importu…
    .accesskey = s

import-key-file = Import souboru s klíčem OpenPGP

import-key-personal-checkbox =
    .label = Považovat tento klíč za osobní klíč

gnupg-file = Soubory GnuPG

import-error-file-size = <b>Chyba!</b> Soubory větší než 5 MB nejsou podporovány.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Chyba!</b> Soubor se nepodařilo naimportovat. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Chyba!</b> Import klíčů se nezdařil. { $error }

openpgp-import-identity-label = Identita

openpgp-import-fingerprint-label = Otisk

openpgp-import-created-label = Vytvořeno

openpgp-import-bits-label = Bitů

openpgp-import-key-props =
    .label = Vlastnosti klíče
    .accesskey = V

## External Key section

openpgp-external-key-title = Externí klíč v GnuPG

openpgp-external-key-description = Nastavte externí klíč v GnuPG zadáním ID klíče

openpgp-external-key-info = Kromě toho musíte pomocí správce klíčů naimportovat a přijmout odpovídající veřejný klíč.

openpgp-external-key-warning = <b>Nastavit můžete pouze jeden externí klíč z GnuPG.</b> Vaše předchozí položka bude nahrazena.

openpgp-save-external-button = Uložit ID klíče

openpgp-external-key-label = ID tajného klíče:

openpgp-external-key-input =
    .placeholder = 123456789341298340
