# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = In persoanlike OpenPGP-kaai foar { $identity } tafoegje
key-wizard-button =
    .buttonlabelaccept = Trochgean
    .buttonlabelhelp = Tebek
key-wizard-warning = <b>As jo on besteande persoanlike kaai hawwe</b> foar dit e-mailadres, dan moatte jo dizze ymportearje. Oars hawwe jo gjin tagong ta jo argiven mei fersifere e-mailberjochten en kinne jo gjin ynkommende fersifere e-mailberjochten fan minsken dy't jo besteande kaai noch hieltyd brûke lêze.
key-wizard-learn-more = Mear ynfo
radio-create-key =
    .label = In nije OpenPGP-kaai meitsje
    .accesskey = m
radio-import-key =
    .label = In besteande OpenPGP-kaai ymportearje
    .accesskey = y
radio-gnupg-key =
    .label = Jo eksterne kaai fia GnuPG (byg. fan in smartcard ôf) brûke
    .accesskey = J

## Generate key section

openpgp-generate-key-title = OpenPGP-kaai oanmeitsje
openpgp-generate-key-info = <b>It oanmeitsjen fan in kaai kin inkelde minuten duorje.</b> Slút de tapassing net ôf wylst de kaai oanmakke wurdt. Aktyf navigearje of skiifyntensive bewurkingen útfiere wylst it oanmeitsjen fan de kaai sil de ‘samar-wat-pool’ oanfolje en it proses fersnelle. Jo wurde warskôge wannear't it oanmeitsjen fan de kaai ree is.
openpgp-keygen-expiry-title = Jildichheidsdoer kaai
openpgp-keygen-expiry-description = Definiearje de jildichheidsdoer fan jo nij oanmakke kaai. Jo kinne letter de datum oanpasse om dizze wannear nedich te ferlingen.
radio-keygen-expiry =
    .label = Kaai ferrint oer
    .accesskey = e
radio-keygen-no-expiry =
    .label = Kaai ferrint net
    .accesskey = n
openpgp-keygen-days-label =
    .label = dagen
openpgp-keygen-months-label =
    .label = moannen
openpgp-keygen-years-label =
    .label = jier
openpgp-keygen-advanced-title = Avansearre ynstellingen
openpgp-keygen-advanced-description = De avansearre ynstellingen fan jo OpenPGP-kaai beheare.
openpgp-keygen-keytype =
    .value = Kaaitype:
    .accesskey = t
openpgp-keygen-keysize =
    .value = Kaaigrutte:
    .accesskey = g
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (Elliptyske Kurve)
openpgp-keygen-button = Kaai oanmeitsje
openpgp-keygen-progress-title = Jo nije OpenPGP-kaai wurdt oanmakke…
openpgp-keygen-import-progress-title = Jo OpenPGP-kaaien ymportearje…
openpgp-import-success = OpenPGP-kaaien mei sukses ymportearre!
openpgp-import-success-title = It ymportproses foltôgje
openpgp-import-success-description = Om jo ymportearre OpenPGP-kaai foar it fersiferjen fan e-mail brûken te gean, moatte jo dit dialoochfinster slute en nei jo accountynstellingen gean om de kaai te selektearjen.
openpgp-keygen-confirm =
    .label = Befêstigje
openpgp-keygen-dismiss =
    .label = Annulearje
openpgp-keygen-cancel =
    .label = Proses annulearje…
openpgp-keygen-import-complete =
    .label = Slute
    .accesskey = S
openpgp-keygen-missing-username = Der is gjin namme foar de aktuele account opjûn. Fier yn de accountynstellingen in wearde yn yn it fjild ‘Jo namme’.
openpgp-keygen-long-expiry = Jo kinne gjin kaai oanmeitsje dy't oer mear as 100 jier ferrint.
openpgp-keygen-short-expiry = Jo kaai moat op syn minst ien dei jildich wêze.
openpgp-keygen-ongoing = Der wurdt al in kaai oanmakke!
openpgp-keygen-error-core = Kin OpenPGP Core Service net inisjalisearje
openpgp-keygen-error-failed = It oanmeitsjen fan de OpenPGP-kaai is ûnferwachts mislearre
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = De OpenPGP-kaai is mei sukses oanmakke, mar de ynlûking foar kaai { $key } koe net ferkrigen wurde
openpgp-keygen-abort-title = Oanmeitsjen kaai ôfbrekke?
openpgp-keygen-abort = Der wurdt op dit stuit in OpenPGP-kaai oanmakke, binne jo wis dat jo dit annulearje wolle?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Iepenbiere en geheime kaai foar { $identity } oanmeitsje?

## Import Key section

openpgp-import-key-title = In besteande persoanlike OpenPGP-kaai ymportearje
openpgp-import-key-legend = Selektearje in earder reservekopybestân.
openpgp-import-key-description = Jo kinne persoanlike kaaien dy't oanmakke binne mei oare OpenPGP-software ymportearje.
openpgp-import-key-info = Oare software beskriuwt in persoanlike kaai mooglik mei alternative termen, lykas jo eigen kaai, geheime kaai, priveekaai of kaaipear.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird hat in kaai fûn dy't ymportearre wurde kin.
       *[other] Thunderbird hat { $count } kaaien fûn dy't ymportearre wurde kinne.
    }
openpgp-import-key-list-description = Befêstigje hokker kaaien behannele wurde meie as persoanlike kaaien. Allinnich kaaien dy't jo sels oanmakke hawwe en jo eigen identiteit toane meie as persoanlike kaaien brûkt wurde. Jo kinne dizze opsje letter wizigje yn it dialoochfinster Kaaieigenskippen.
openpgp-import-key-list-caption = Kaaien dy't markearre wurde om as persoanlike kaaien behanelle te wurden, wurde fermeld yn de seksje End-to-end-fersifering. De oare binne beskikber yn de Kaaibehearder.
openpgp-passphrase-prompt-title = Wachtwurdsin fereaske
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Fier de wachtwurdsin yn om de folgjende kaai te ûntskoatteljen: { $key }
openpgp-import-key-button =
    .label = Selektearje te ymportearjen bestân…
    .accesskey = S
import-key-file = OpenPGP-kaaibestân ymportearje
import-key-personal-checkbox =
    .label = Dizze kaai as in persoanlike kaai behannelje
gnupg-file = GnuPG-bestannen
import-error-file-size = <b>Flater!</b> Bestannen grutter nas 5 MB wurde net stipe.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Flater!</b> Koe bestân net ymportearje. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Flater!</b> Koe kaaien net ymportearje. { $error }
openpgp-import-identity-label = Identiteit
openpgp-import-fingerprint-label = Fingerôfdruk
openpgp-import-created-label = Oanmakke
openpgp-import-bits-label = Bits
openpgp-import-key-props =
    .label = Kaaieigenskippen
    .accesskey = S

## External Key section

openpgp-external-key-title = Eksterne GnuPG-kaai
openpgp-external-key-description = Konfigurearje in eksterne GnuPG-kaai troch de kaai-ID yn te fieren
openpgp-external-key-info = Dêrneist moatte jo Kaaibehearder brûke om de byhearrende iepenbiere kaai te ymportearjen en te akseptearjen.
openpgp-external-key-warning = <b>Jo meie mar ien eksterne GnuPG-kaai konfigurearje.</b> Jo foarige ynfier wurdt ferfongen.
openpgp-save-external-button = Kaai-ID bewarje
openpgp-external-key-label = Geheime kaai-ID:
openpgp-external-key-input =
    .placeholder = 123456789341298340
