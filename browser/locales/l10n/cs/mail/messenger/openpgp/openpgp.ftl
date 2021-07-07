# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Abyste mohli odesílat zašifrované nebo elektronicky podepsané zprávy, musíte nastavit technologii šifrování, buď OpenPGP nebo S/MIME.
e2e-intro-description-more = Chcete-li používat OpenPGP, vyberte svůj osobní klíč, chcete-li používat S/MIME, vyberte svůj osobní certifikát. Pro osobní klíč nebo certifikát vlastníte odpovídající tajný klíč.
openpgp-key-user-id-label = Účet / ID uživatele
openpgp-keygen-title-label =
    .title = Vytvořit klíč OpenPGP
openpgp-cancel-key =
    .label = Zrušit
    .tooltiptext = Zrušit vytváření klíče
openpgp-key-gen-expiry-title =
    .label = Doba platnosti klíče
openpgp-key-gen-expire-label = Platnost klíče skončí za
openpgp-key-gen-days-label =
    .label = dnů
openpgp-key-gen-months-label =
    .label = měsíců
openpgp-key-gen-years-label =
    .label = roků
openpgp-key-gen-no-expiry-label =
    .label = Platnost klíče není omezená
openpgp-key-gen-key-size-label = Velikost klíče
openpgp-key-gen-console-label = Vytváření klíče
openpgp-key-gen-key-type-label = Typ klíče
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (eliptická křivka)
openpgp-generate-key =
    .label = Vytvořit klíč
    .tooltiptext = Vytvoří nový klíč OpenPGP pro šifrování a/nebo podepisování
openpgp-advanced-prefs-button-label =
    .label = Rozšířené…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">POZNÁMKA: Vytváření klíče může trvat až několik minut.</a> Po tu dobu prosím aplikaci neukončujte. Proces se urychlí, když budete aktivně pracovat s prohlížečem nebo provádět operace s častým přístupem k pevnému disku. Až bude vytváření klíče dokončeno, budete upozorněni.
openpgp-key-expiry-label =
    .label = Konec platnosti
openpgp-key-id-label =
    .label = ID klíče
openpgp-cannot-change-expiry = Toto je klíč se složitou strukturou, změna data konce jeho platnosti není podporována.
openpgp-key-man-title =
    .title = Správce klíčů OpenPGP
openpgp-key-man-generate =
    .label = Nový pár klíčů
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Revokační certifikát
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = Vytvoří a uloží revokační certifikát
openpgp-key-man-file-menu =
    .label = Soubor
    .accesskey = S
openpgp-key-man-edit-menu =
    .label = Úpravy
    .accesskey = a
openpgp-key-man-view-menu =
    .label = Zobrazit
    .accesskey = Z
openpgp-key-man-generate-menu =
    .label = Vytvořit
    .accesskey = V
openpgp-key-man-keyserver-menu =
    .label = Server klíčů
    .accesskey = k
openpgp-key-man-import-public-from-file =
    .label = Importovat veřejné klíče ze souboru
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importovat tajné klíče ze souboru
openpgp-key-man-import-sig-from-file =
    .label = Importovat revokace ze souboru
openpgp-key-man-import-from-clipbrd =
    .label = Importovat klíče ze schránky
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Importovat klíče z adresy URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Exportovat veřejné klíče do souboru
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Poslat veřejné klíče e-mailem
    .accesskey = m
openpgp-key-man-backup-secret-keys =
    .label = Zálohovat tajné klíče do souboru
    .accesskey = Z
openpgp-key-man-discover-cmd =
    .label = Najít klíče na internetu
    .accesskey = i
openpgp-key-man-discover-prompt = Pro nalezení klíčů OpenPGP na serverech klíčů nebo pomocí protokolu WKD zadejte buď e-mailovou adresu nebo ID klíče.
openpgp-key-man-discover-progress = Hledání…
openpgp-key-copy-key =
    .label = Kopírovat veřejný klíč
    .accesskey = K
openpgp-key-export-key =
    .label = Exportovat veřejný klíč do souboru
    .accesskey = E
openpgp-key-backup-key =
    .label = Zálohovat tajný klíč do souboru
    .accesskey = Z
openpgp-key-send-key =
    .label = Poslat veřejný klíč e-mailem
    .accesskey = m
openpgp-key-man-copy-to-clipbrd =
    .label = Kopírovat veřejný klíč do schránky
    .accesskey = K
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kopírovat ID klíče do schránky
            [few] Kopírovat ID klíčů do schránky
           *[other] Kopírovat ID klíčů do schránky
        }
    .accesskey = D
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Kopírovat otisk do schránky
            [few] Kopírovat otisky do schránky
           *[other] Kopírovat otisky do schránky
        }
    .accesskey = o
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Kopírovat veřejný klíč do schránky
            [few] Kopírovat veřejné klíče do schránky
           *[other] Kopírovat veřejné klíče do schránky
        }
    .accesskey = v
openpgp-key-man-ctx-expor-to-file-label =
    .label = Exportovat klíče do souboru
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Kopírovat veřejné klíče do schránky
openpgp-key-man-ctx-copy =
    .label = Kopírovat
    .accesskey = K
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Otisk
            [few] Otisky
           *[other] Otisky
        }
    .accesskey = O
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] ID klíče
            [few] ID klíčů
           *[other] ID klíčů
        }
    .accesskey = D
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Veřejný klíč
            [few] Veřejné klíče
           *[other] Veřejné klíče
        }
    .accesskey = V
openpgp-key-man-close =
    .label = Zavřít
openpgp-key-man-reload =
    .label = Znovu načíst mezipaměť klíčů
    .accesskey = n
openpgp-key-man-change-expiry =
    .label = Změnit datum konce platnosti
    .accesskey = Z
openpgp-key-man-del-key =
    .label = Smazat klíče
    .accesskey = S
openpgp-delete-key =
    .label = Smazat klíč
    .accesskey = S
openpgp-key-man-revoke-key =
    .label = Zneplatnit klíč
    .accesskey = Z
openpgp-key-man-key-props =
    .label = Vlastnosti klíče
    .accesskey = V
openpgp-key-man-key-more =
    .label = Více
    .accesskey = c
openpgp-key-man-view-photo =
    .label = Foto ID
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Zobrazí foto ID
openpgp-key-man-show-invalid-keys =
    .label = Zobrazit neplatné klíče
    .accesskey = n
openpgp-key-man-show-others-keys =
    .label = Zobrazit klíče ostatních lidí
    .accesskey = o
openpgp-key-man-user-id-label =
    .label = Jméno
openpgp-key-man-fingerprint-label =
    .label = Otisk
openpgp-key-man-select-all =
    .label = Vybrat všechny klíče
    .accesskey = a
openpgp-key-man-empty-tree-tooltip =
    .label = Zadejte do horního pole hledaný výraz
openpgp-key-man-nothing-found-tooltip =
    .label = Hledanému výrazu neodpovídají žádné klíče
openpgp-key-man-please-wait-tooltip =
    .label = Načítaní klíčů, prosím čekejte…
openpgp-key-man-filter-label =
    .placeholder = Vyhledat klíče
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Vlastnosti klíče
openpgp-key-details-signatures-tab =
    .label = Potvrzení
openpgp-key-details-structure-tab =
    .label = Struktura
openpgp-key-details-uid-certified-col =
    .label = ID uživatele / Potvrzeno od
openpgp-key-details-user-id2-label = Údajný vlastník klíče
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Typ
openpgp-key-details-key-part-label =
    .label = Část klíče
openpgp-key-details-algorithm-label =
    .label = Algoritmus
openpgp-key-details-size-label =
    .label = Velikost
openpgp-key-details-created-label =
    .label = Vytvořeno
openpgp-key-details-created-header = Vytvořeno
openpgp-key-details-expiry-label =
    .label = Konec platnosti
openpgp-key-details-expiry-header = Konec platnosti
openpgp-key-details-usage-label =
    .label = Způsob použití
openpgp-key-details-fingerprint-label = Otisk
openpgp-key-details-sel-action =
    .label = Vybrat akci…
    .accesskey = V
openpgp-key-details-also-known-label = Údajné alternativní identity vlastníka klíče:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Zavřít
openpgp-acceptance-label =
    .label = Vaše přijetí
openpgp-acceptance-rejected-label =
    .label = Ne, odmítnout tento klíč.
openpgp-acceptance-undecided-label =
    .label = Ještě ne, možná později.
openpgp-acceptance-unverified-label =
    .label = Ano, ale neověřil(a) jsem, že se jedná o správný klíč.
openpgp-acceptance-verified-label =
    .label = Ano, osobně jsem ověřil(a), že má tento klíč správný otisk.
key-accept-personal =
    U tohoto klíče máte veřejnou i tajnou část. Můžete ho používat jako osobní klíč.
    Pokud vám tento klíč dal někdo jiný, nepoužívejte ho jako osobní klíč.
key-personal-warning = Vytvořili jste tento klíč vy a odkazuje zobrazené vlastnictví klíče na vás?
openpgp-personal-no-label =
    .label = Ne, nepoužívat ho jako můj osobní klíč.
openpgp-personal-yes-label =
    .label = Ano, považovat tento klíč za osobní klíč.
openpgp-copy-cmd-label =
    .label = Kopírovat

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird nemá žádný osobní klíč OpenPGP
        [one] Thunderbird našel { $count } osobní klíč OpenPGP
        [few] Thunderbird našel { $count } osobní klíče OpenPGP
       *[other] Thunderbird našel { $count } osobních klíčů OpenPGP
    } pro <b>{ $identity }</b>
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Pro povolení protokolu OpenPGP vyberte platný klíč.
       *[other] Vaše současná konfigurace používá klíč s ID <b>{ $key }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Vaše současná konfigurace používá klíč s ID <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Vaše současná konfigurace používá klíč <b>{ $key }</b>, jehož platnost skončila.
openpgp-add-key-button =
    .label = Přidat klíč…
    .accesskey = a
e2e-learn-more = Zjistit více
openpgp-keygen-success = Klíč OpenPGP byl úspěšně vytvořen!
openpgp-keygen-import-success = Klíče OpenPGP byly úspěšně naimportovány!
openpgp-keygen-external-success = ID externího klíče v GnuPG bylo uloženo!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Žádný
openpgp-radio-none-desc = Pro tuto identitu OpenPGP nepoužívat.
openpgp-radio-key-not-usable = Tento klíč nelze použít jako osobní, protože chybí tajný klíč.
openpgp-radio-key-not-accepted = Pro použití tohoto klíče ho nejprve musíte schválit jako osobní.
openpgp-radio-key-not-found =
    Tento klíč se nepodařilo najít. Pokud ho chcete použít, nejdříve ho do { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } naimportujte.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Datum konce platnosti: { $date }
openpgp-key-expires-image =
    .tooltiptext = Platnost klíče skončí za méně než 6 měsíců
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Platnost skončila dne { $date }
openpgp-key-expired-image =
    .tooltiptext = Platnost klíče skončila
openpgp-key-expires-within-6-months-icon =
    .title = Platnost klíče skončí za méně než 6 měsíců
openpgp-key-has-expired-icon =
    .title = Platnost klíče vypršela
openpgp-key-expand-section =
    .tooltiptext = Více informací
openpgp-key-revoke-title = Zneplatnit klíč
openpgp-key-edit-title = Změnit klíč OpenPGP
openpgp-key-edit-date-title = Prodloužit dobu platnosti
openpgp-manager-description = Pomocí správce klíčů OpenPGP si můžete zobrazit a spravovat veřejné klíče svých korespondentů a všechny další klíče, které nejsou uvedeny výše.
openpgp-manager-button =
    .label = Správce klíčů OpenPGP
    .accesskey = k
openpgp-key-remove-external =
    .label = Odebrat ID externího klíče
    .accesskey = e
key-external-label = Externí klíč v GnuPG
# Strings in keyDetailsDlg.xhtml
key-type-public = veřejný klíč
key-type-primary = primární klíč
key-type-subkey = podklíč
key-type-pair = pár klíčů (tajný klíč a veřejný klíč)
key-expiry-never = nikdy
key-usage-encrypt = Šifrování
key-usage-sign = Podepisování
key-usage-certify = Certifikace
key-usage-authentication = Ověřování
key-does-not-expire = Platnost klíče není omezená
key-expired-date = Platnost klíče vypršela dne { $keyExpiry }
key-expired-simple = Platnost klíče vypršela
key-revoked-simple = Klíč byl zneplatněn
key-do-you-accept = Přijímáte tento klíč k účelům ověřování digitálních podpisů a šifrování zpráv?
key-accept-warning = Dejte pozor na přijetí podvodného klíče. Otisk klíče svého korespondenta ověřte prostřednictvím jiného komunikačního kanálu, než je elektronická pošta.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Zprávu nelze odeslat, protože se u vašeho osobního klíče vyskytl problém. { $problem }
cannot-encrypt-because-missing = Tuto zprávu nelze odeslat za použití koncového šifrování, protože u klíčů následujících příjemců se vyskytly problémy: { $problem }
window-locked = Okno psaní zprávy je uzamčeno; odesílání bylo zrušeno
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Zašifrovaná část zprávy
mime-decrypt-encrypted-part-concealed-data = Toto je zašifrovaná část zprávy. Otevřít ji musíte v samostatném okně klepnutím na přílohu.
# Strings in keyserver.jsm
keyserver-error-aborted = Přerušeno
keyserver-error-unknown = Došlo k neznámé chybě
keyserver-error-server-error = Server klíčů ohlásil chybu.
keyserver-error-import-error = Import staženého klíče se nezdařil.
keyserver-error-unavailable = Server klíčů není dostupný.
keyserver-error-security-error = Server klíčů nepodporuje šifrovaný přístup.
keyserver-error-certificate-error = Server klíčů používá neplatný certifikát.
keyserver-error-unsupported = Tento server klíčů není podporován.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Váš poskytovatel e-mailu zpracoval váš požadavek na nahrání vašeho veřejného klíče do webového adresáře klíčů OpenPGP.
    Potvrďte prosím publikování svého veřejného klíče.
wkd-message-body-process =
    Toto je e-mail zaslaný v souvislosti s automatickým zpracováním požadavku na nahrání vašeho veřejného klíče do webového adresáře klíčů OpenPGP.
    V tuto chvíli není z vaší strany nutná žádná akce.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Zprávu s předmětem „{ $subject }“ se nepodařilo dešifrovat.
    Chcete to zkusit s jinou přístupovou frází nebo chcete zprávu přeskočit?
# Strings in gpg.jsm
unknown-signing-alg = Neznámý podpisový algoritmus (ID: { $id })
unknown-hash-alg = Neznámý kryptografický hashovací algoritmus (ID: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Platnost vašeho klíče { $desc } skončí za méně než { $days ->
        [one] jeden den
        [few] { $days } dny
       *[other] { $days } dní
    }.
    Doporučujeme vytvořit nový pár klíčů a nastavit příslušné účty tak, aby ho mohly používat.
expiry-keys-expire-soon =
    Platnost těchto vašich klíčů skončí za méně než { $days ->
        [one] jeden den
        [few] { $days } dny
       *[other] { $days } dní
    }: { $desc }.
    Doporučujeme vytvořit nové klíče a nastavit příslušné účty tak, aby je mohly používat.
expiry-key-missing-owner-trust =
    Váš tajný klíč { $desc } postrádá důvěryhodnost.
    Doporučujeme ve vlastnostech klíče nastavit volbu „You rely on certifications“ na „Absolutně důvěřuji“.
expiry-keys-missing-owner-trust =
    Tyto vaše tajné klíče postrádají důvěryhodnost.
    { $desc }.
    Doporučujeme ve vlastnostech klíče nastavit volbu „You rely on certifications“ na „Absolutně důvěřuji“.
expiry-open-key-manager = Otevřít správce klíčů OpenPGP
expiry-open-key-properties = Otevřít vlastnosti klíče
# Strings filters.jsm
filter-folder-required = Musíte vybrat cílovou složku.
filter-decrypt-move-warn-experimental =
    VAROVÁNÍ: Akce filtru „Dešifrovat nastálo“ může vést ke zničení zpráv.
    Důrazně doporučujeme nejprve vyzkoušet filtr „Vytvořit dešifrovanou kopii“, výsledek pečlivě překontrolovat, a tento filtr začít používat až poté, co budete s výsledkem spokojeni.
filter-term-pgpencrypted-label = Zašifrováno pomocí OpenPGP
filter-key-required = Musíte vybrat klíč příjemce.
filter-key-not-found = Nepodařilo se najít šifrovací klíč pro '{ $desc }'.
filter-warn-key-not-secret =
    VAROVÁNÍ: Akce filtru „Šifrovat do klíče“ nahradí příjemce.
    Pokud nemáte tajný klíč pro '{ $desc }', nebudete už moci e-maily číst.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dešifrovat nastálo (OpenPGP)
filter-decrypt-copy-label = Vytvořit dešifrovanou kopii (OpenPGP)
filter-encrypt-label = Šifrovat do klíče (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Import klíčů proběhl úspěšně!
import-info-bits = Bitů
import-info-created = Vytvořen
import-info-fpr = Otisk
import-info-details = Zobrazit podrobnosti a spravovat přijetí klíče
import-info-no-keys = Nebyly naimportovány žádné klíče.
# Strings in enigmailKeyManager.js
import-from-clip = Přejete si naimportovat nějaké klíče ze schránky?
import-from-url = Stáhnout veřejný klíč z této URL adresy:
copy-to-clipbrd-failed = Vybrané klíče nelze zkopírovat do schránky.
copy-to-clipbrd-ok = Klíče byly zkopírovány do schránky
delete-secret-key =
    VAROVÁNÍ: Chystáte se odstranit tajný klíč!
    
    Pokud odstraníte svůj tajný klíč, nebudete už moci dešifrovat žádné zprávy zašifrované pro tento klíč, ani ho nebudete moci zneplatnit.
    
    Opravdu chcete odstranit OBA, jak tajný klíč tak i veřejný klíč, '{ $userId }'?
delete-mix =
    VAROVÁNÍ: Chystáte se odstranit tajné klíče!
    Pokud odstraníte svůj tajný klíč, nebudete už moci dešifrovat žádné zprávy zašifrované pro tento klíč.
    Opravdu chcete u vybraných klíčů odstranit OBA, jak tajný klíč tak i veřejný klíč?
delete-pub-key =
    Přejete si odstranit tento veřejný klíč
    '{ $userId }'?
delete-selected-pub-key = Přejete si odstranit tyto veřejné klíče?
refresh-all-question = Nevybrali jste žádný klíč. Přejete si obnovit VŠECHNY klíče?
key-man-button-export-sec-key = Exportovat &tajné klíče
key-man-button-export-pub-key = Exportovat pouze &veřejné klíče
key-man-button-refresh-all = &Obnovit všechny klíče
key-man-loading-keys = Načítání klíčů, čekejte prosím…
ascii-armor-file = Soubory ve formátu ASCII (*.asc)
no-key-selected = K provedení operace byste měli vybrat alespoň jeden klíč
export-to-file = Exportovat veřejný klíč do souboru
export-keypair-to-file = Exportovat tajný a veřejný klíč do souboru
export-secret-key = Přejete si do uloženého souboru s klíčem OpenPGP zahrnout i tajný klíč?
save-keys-ok = Klíče byly úspěšně uloženy
save-keys-failed = Uložení klíčů selhalo
default-pub-key-filename = Exportovane-verejne-klice
default-pub-sec-key-filename = Zaloha-tajnych-klicu
refresh-key-warn = VAROVÁNÍ: V závislosti na počtu klíčů a rychlosti připojení k internetu může trvat obnovení seznamu všech klíčů delší dobu!
preview-failed = Soubor s veřejným klíčem nelze přečíst.
general-error = Chyba: { $reason }
dlg-button-delete = S&mazat

## Account settings export output

openpgp-export-public-success = <b>Veřejný klíč byl úspěšně vyexportován!</b>
openpgp-export-public-fail = <b>Vybraný veřejný klíč nelze vyexportovat!</b>
openpgp-export-secret-success = <b>Tajný klíč byl úspěšně vyexportován!</b>
openpgp-export-secret-fail = <b>Vybraný tajný klíč nelze vyexportovat!</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Klíč { $userId } (ID klíče { $keyId }) je zneplatněn.
key-ring-pub-key-expired = Platnost klíče { $userId } (ID klíče { $keyId }) vypršela.
key-ring-no-secret-key = Zdá se, že pro { $userId } (ID klíče { $keyId }) nemáte v klíčence tajný klíč, a nemůžete ho tedy používat k podepisování.
key-ring-pub-key-not-for-signing = Klíč { $userId } (ID klíče { $keyId }) nelze používat k podepisování.
key-ring-pub-key-not-for-encryption = Klíč { $userId } (ID klíče { $keyId }) nelze používat k šifrování.
key-ring-sign-sub-keys-revoked = Všechny podpisové podklíče klíče { $userId } (ID klíče { $keyId }) jsou zneplatněny.
key-ring-sign-sub-keys-expired = Platnost všech podpisových podklíčů klíče { $userId } (ID klíče { $keyId }) vypršela.
key-ring-enc-sub-keys-revoked = Všechny šifrovací podklíče klíče { $userId } (ID klíče { $keyId }) jsou zneplatněny.
key-ring-enc-sub-keys-expired = Platnost všech šifrovacích podklíčů klíče { $userId } (ID klíče { $keyId }) vypršela.
# Strings in gnupg-keylist.jsm
keyring-photo = Fotografie
user-att-photo = Atribut uživatele (obrázek JPEG)
# Strings in key.jsm
already-revoked = Tento klíč už byl zneplatněn.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Chystáte se zneplatnit klíč '{ $identity }'.
    Tímto klíčem už nebudete moci podepisovat a po jeho rozeslání již ostatní nebudou moci pomocí tohoto klíče šifrovat. Stále jím však budete moci dešifrovat staré zprávy.
    Přejete si pokračovat?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Nemáte žádný klíč (0x{ $keyId }), který odpovídá tomuto revokačnímu certifikátu.
    Pokud jste svůj klíč ztratili, musíte ho před importem revokačního certifikátu naimportovat (např. ze serveru klíčů).
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Klíč 0x{ $keyId } už byl zneplatněn.
key-man-button-revoke-key = &Zneplatnit klíč
openpgp-key-revoke-success = Klíč byl úspěšně zneplatněn.
after-revoke-info =
    Klíč byl zneplatněn.
    Aby se ostatní dozvěděli o jeho zneplatnění, znovu tento veřejný klíč sdílejte e-mailem nebo nahráním na servery klíčů.
    Jakmile se software používaný ostatními o zneplatnění dozví, přestane váš starý klíč používat.
    Pokud pro stejnou e-mailovou adresu používáte nový klíč a tento nový veřejný klíč přiložíte ke svým odesílaným e-mailům, automaticky v nich budou zahrnuty i informace o vašem starém zneplatněném klíči.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importovat
delete-key-title = Odstranit klíč OpenPGP
delete-external-key-title = Odebrat externí klíč GnuPG
delete-external-key-description = Chcete odebrat ID tohoto externího klíče GnuPG?
key-in-use-title = Klíč OpenPGP se aktuálně používá
delete-key-in-use-description = Nelze pokračovat, protože klíč vybraný k odstranění je aktuálně používán touto identitou. Vyberte jiný nebo žádný klíč a zkuste to znovu.
revoke-key-in-use-description = Nelze pokračovat, protože klíč vybraný k zneplatnění je aktuálně používán touto identitou. Vyberte jiný nebo žádný klíč a zkuste to znovu.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = E-mailovou adresu '{ $keySpec }' nelze přiřadit k žádnému klíči ve vaší klíčence.
key-error-key-id-not-found = Nastavený klíč s ID '{ $keySpec }' nelze v klíčence najít.
key-error-not-accepted-as-personal = Nepotvrdili jste, že je klíč s ID '{ $keySpec }' vaším osobním klíčem.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Vybraná funkce není dostupná v režimu offline. Přejděte prosím do režimu online a zkuste to znovu.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Nenašli jsme žádný klíč odpovídající zadaným kritériím.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Chyba: Extrahování klíče selhalo
# Strings used in keyRing.jsm
fail-cancel = Chyba: Příjem klíče zrušen uživatelem
not-first-block = Chyba: První blok OpenPGP není blokem veřejného klíče
import-key-confirm = Importovat veřejné klíče vložené do zprávy?
fail-key-import = Chyba: Importování klíče selhalo
file-write-failed = Zápis do souboru { $output } selhal
no-pgp-block = Chyba: Nenalezen platný blok dat OpenPGP
confirm-permissive-import = Import se nezdařil. Klíč, který se pokoušíte naimportovat, může být poškozený, nebo používá neznámé atributy. Chcete se pokusit naimportovat jeho korektní části? To může mít za následek import neúplných a nepoužitelných klíčů.
# Strings used in trust.jsm
key-valid-unknown = není známo
key-valid-invalid = vadný
key-valid-disabled = zakázaný
key-valid-revoked = zneplatněný
key-valid-expired = platnost vypršela
key-trust-untrusted = nedůvěryhodný
key-trust-marginal = částečně
key-trust-full = důvěryhodný
key-trust-ultimate = absolutně důvěryhodný
key-trust-group = (skupina)
# Strings used in commonWorkflows.js
import-key-file = Importovat soubor s klíčem OpenPGP
import-rev-file = Importovat soubor se zneplatněním OpenPGP
gnupg-file = Soubory GnuPG
import-keys-failed = Importování klíčů selhalo
passphrase-prompt = Zadejte prosím heslo, které odemkne následující klíč: { $key }
file-to-big-to-import = Tento soubor je příliš velký. Neimportujte velké množství klíčů najednou.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Vytvořit a uložit revokační certifikát
revoke-cert-ok = Revokační certifikát byl úspěšně vytvořen. Můžete ho použít ke zneplatnění svého veřejného klíče, např. v případě ztráty svého tajného klíče.
revoke-cert-failed = Revokační certifikát nemohl být vytvořen.
gen-going = Vytváření klíče již probíhá!
keygen-missing-user-name = Pro vybraný účet či identitu není zadáno žádné jméno. Zadejte prosím v nastavení účtu nějakou hodnotu do pole „Vaše jméno“.
expiry-too-short = Váš klíč musí být platný minimálně jeden den.
expiry-too-long = Nemůžete vytvořit klíč s platností delší než 100 let.
key-confirm = Chcete vytvořit veřejný a tajný klíč pro '{ $id }'?
key-man-button-generate-key = &Vytvořit klíč
key-abort = Přerušit vytváření klíče?
key-man-button-generate-key-abort = &Přerušit vytváření klíče
key-man-button-generate-key-continue = &Pokračovat ve vytváření klíče

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Chyba: Dešifrování se nezdařilo
fix-broken-exchange-msg-failed = Zprávu se nepodařilo opravit.
attachment-no-match-from-signature = Soubor s podpisem '{ $attachment }' nelze přiřadit k žádné příloze
attachment-no-match-to-signature = Přílohu '{ $attachment }' nelze přiřadit k žádnému souboru s podpisem
signature-verified-ok = Podpis přílohy { $attachment } byl úspěšně ověřen
signature-verify-failed = Podpis přílohy { $attachment } nelze ověřit
decrypt-ok-no-sig =
    VAROVÁNÍ
    Dešifrování bylo úspěšné, ale podpis nebylo možné správně ověřit
msg-ovl-button-cont-anyway = &Přesto pokračovat
enig-content-note = *Přílohy v této zprávě nebyly podepsány ani zašifrovány*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Odeslat zprávu
msg-compose-details-button-label = Podrobnosti…
msg-compose-details-button-access-key = P
send-aborted = Odesílání zprávy bylo přerušeno.
key-not-trusted = Klíč '{ $key }' nemá dostatečnou důvěryhodnost
key-not-found = Klíč '{ $key }' nebyl nalezen
key-revoked = Klíč '{ $key }' byl zneplatněn
key-expired = Platnost klíče '{ $key }' vypršela
msg-compose-internal-error = Došlo k vnitřní chybě.
keys-to-export = Vyberte klíče OpenPGP, které chcete vložit
msg-compose-partially-encrypted-inlinePGP =
    Zpráva, na kterou odpovídáte, obsahovala nezašifrované i zašifrované části. Pokud odesílatel nemohl původně dešifrovat některé části zprávy, může docházet k úniku důvěrných informací, které odesílatel nemohl původně dešifrovat. 
    Zvažte odstranění veškerého citovaného textu z vaší odpovědi tomuto odesílateli.
msg-compose-cannot-save-draft = Chyba při ukládání konceptu
msg-compose-partially-encrypted-short = Pozor na únik citlivých informací, e-mail je zašifrovaný jen částečně.
quoted-printable-warn =
    Pro odesílání zpráv jste povolili kódování 'quoted-printable', což může mít za následek nesprávné dešifrování nebo ověření vaší zprávy.
    Přejete si nyní odesílání zpráv v kódování 'quoted-printable' vypnout?
minimal-line-wrapping =
    Nastavili jste zalamování řádků na { $width } znaků. Pro správné šifrování a podepisování musí být tato hodnota nejméně 68.
    Přejete si nyní změnit zalamování řádků na 68 znaků?
sending-hidden-rcpt = Při odesílání zašifrované zprávy nelze použít adresáty pro skrytou kopii. Aby mohla být tato zpráva odeslána šifrovaně, buď adresáty pro skrytou kopii odeberte, nebo je přesuňte do pole pro běžnou kopii.
sending-news =
    Odesílání zašifrované zprávy bylo přerušeno.
    Tato zpráva nemůže být šifrována, protože obsahuje adresáty z diskuzní skupiny. Odešlete prosím zprávu bez šifrování.
send-to-news-warning =
    VAROVÁNÍ: Chystáte se odeslat zašifrovaný e-mail do diskusní skupiny.
    To se nedoporučuje, protože to má smysl pouze tehdy, když mohou zprávu dešifrovat všichni členové skupiny, tj. zpráva musí být zašifrována pomocí klíčů všech účastníků skupiny. Odešlete prosím tuto zprávu pouze pokud přesně víte, co děláte.
    Opravdu chcete pokračovat?
save-attachment-header = Uložit dešifrovanou přílohu
no-temp-dir =
    Nelze najít dočasnou složku pro zápis
    Nastavte prosím proměnnou prostředí TEMP
possibly-pgp-mime = Tato zpráva je možná zašifrovaná nebo podepsaná pomocí PGP/MIME. Ověřit si to můžete pomocí funkce „Dešifrovat“ nebo „Ověřit“.
cannot-send-sig-because-no-own-key = Tuto zprávu nelze digitálně podepsat, protože jste pro <{ $key }> dosud nenastavili koncové šifrování
cannot-send-enc-because-no-own-key = Tuto zprávu nelze odeslat zašifrovaně, protože jste dosud pro <{ $key }> nenastavili koncové šifrování
# Strings used in decryption.jsm
do-import-multiple =
    Chcete naimportovat následující klíče?
    { $key }
do-import-one = Chcete importovat klíč { $name } ({ $id })?
cant-import = Při importu veřejného klíče došlo k chybě
unverified-reply = Odsazená část zprávy (odpověď) byla pravděpodobně pozměněna
key-in-message-body = V těle zprávy byl nalezen klíč. Pro jeho naimportování klikněte na „Importovat klíč“
sig-mismatch = Chyba: Podpis nesouhlasí
invalid-email = Chyba: Neplatná e-mailová adresa
attachment-pgp-key =
    Zdá se, že otevíraná příloha „{ $name }“ je soubor s klíčem OpenPGP.
    Pokud chcete obsažené klíče importovat, klepněte na „Importovat“. Pro zobrazení v okně prohlížeče klepněte na „Zobrazit.“.
dlg-button-view = &Zobrazit
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Dešifrovaná zpráva (obnovený poškozený formát e-mailu v PGP, což pravděpodobně zapříčinil starý server Exchange, takže výsledek nemusí být dokonalý)
# Strings used in encryption.jsm
not-required = Chyba: Šifrování není vyžadováno
# Strings used in windows.jsm
no-photo-available = Fotografie není k dispozici
error-photo-path-not-readable = Cesta k fotografii '{ $photo }' není čitelná
debug-log-title = Protokol ladění OpenPGP
# Strings used in dialog.jsm
repeat-prefix =
    Toto upozornění se zobrazí ještě { $count ->
        [one] jednou
        [few] { $count }krát
       *[other] { $count }krát
    }.
repeat-suffix-singular = { "" }
repeat-suffix-plural = { "" }
no-repeat = Toto upozornění se už nezobrazí.
dlg-keep-setting = Pamatovat si odpověď a už se neptat
dlg-button-ok = &OK
dlg-button-close = &Zavřít
dlg-button-cancel = &Zrušit
dlg-no-prompt = Tento dialog příště nezobrazovat
enig-prompt = Výzva - OpenPGP
enig-confirm = Potvrzení - OpenPGP
enig-alert = Upozornění - OpenPGP
enig-info = Informace - OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Opakovat
dlg-button-skip = &Přeskočit
# Strings used in enigmailCommon.js
enig-error = Chyba OpenPGP
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Upozornění - OpenPGP
