# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Passwort-Qualitätsmessung

## Change Password dialog

change-device-password-window =
    .title = Passwort ändern

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Kryptographie-Modul: { $tokenName }
change-password-old = Aktuelles Passwort:
change-password-new = Neues Passwort:
change-password-reenter = Neues Passwort (nochmals):

## Reset Password dialog

pippki-failed-pw-change = Passwort konnte nicht geändert werden.
pippki-incorrect-pw = Sie haben nicht das richtige aktuelle Passwort eingegeben. Bitte versuchen Sie es erneut.
pippki-pw-change-ok = Passwort erfolgreich geändert.

pippki-pw-empty-warning = Ihre gespeicherten Passwörter und privaten Schlüssel werden nicht geschützt.
pippki-pw-erased-ok = Sie haben Ihr Passwort gelöscht. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Warnung! Sie haben sich entschieden, kein Passwort zu verwenden. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Sie sind derzeit im FIPS-Modus. FIPS benötigt ein nicht leeres Passwort.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Hauptpasswort zurücksetzen
    .style = width: 40em
reset-password-button-label =
    .label = Zurücksetzen

reset-primary-password-text = Wenn Sie Ihr Hauptpasswort zurücksetzen, gehen all Ihre gespeicherten Web- und E-Mail-Passwörter, Formulardaten, persönlichen Zertifikate und privaten Schlüssel verloren. Soll Ihr Hauptpasswort trotzdem zurückgesetzt werden?

pippki-reset-password-confirmation-title = Hauptpasswort zurücksetzen
pippki-reset-password-confirmation-message = Ihr Hauptpasswort wurde zurückgesetzt.

## Downloading cert dialog

download-cert-window =
    .title = Herunterladen des Zertifikats
    .style = width: 46em
download-cert-message = Sie wurden gebeten, einer neuen Zertifizierungsstelle (CA) zu vertrauen.
download-cert-trust-ssl =
    .label = Dieser CA vertrauen, um Websites zu identifizieren.
download-cert-trust-email =
    .label = Dieser CA vertrauen, um E-Mail-Nutzer zu identifizieren.
download-cert-message-desc = Bevor Sie dieser CA für jeglichen Zweck vertrauen, sollten Sie das Zertifikat sowie seine Richtlinien und Prozeduren (wenn vorhanden) überprüfen.
download-cert-view-cert =
    .label = Ansicht
download-cert-view-text = CA-Zertifikat überprüfen

## Client Authorization Ask dialog

client-auth-window =
    .title = Benutzer-Identifikationsanfrage
client-auth-site-description = Diese Website verlangt, dass Sie sich mit einem Zertifikat identifizieren:
client-auth-choose-cert = Wählen Sie ein Zertifikat, das als Identifikation vorgezeigt wird:
client-auth-cert-details = Details des gewählten Zertifikats:

## Set password (p12) dialog

set-password-window =
    .title = Wählen Sie ein Zertifikats-Backup-Passwort
set-password-message = Das Zertifikats-Backup-Passwort, das Sie hier festlegen, schützt die Backup-Datei, die Sie im Moment erstellen. Sie müssen dieses Passwort festlegen, um mit dem Backup fortzufahren.
set-password-backup-pw =
    .value = Zertifikats-Backup-Passwort:
set-password-repeat-backup-pw =
    .value = Zertifikats-Backup-Passwort (nochmals):
set-password-reminder = Wichtig: Wenn Sie Ihr Zertifikats-Backup-Passwort vergessen, können Sie dieses Backup später nicht wiederherstellen. Bitte schreiben Sie es an einem sicheren Platz nieder.

## Protected Auth dialog

protected-auth-window =
    .title = Geschützte Token-Authentifikation
protected-auth-msg = Bitte authentifizieren Sie sich beim Token. Die Authentifikationsmethode hängt vom Typ Ihres Tokens ab.
protected-auth-token = Token:
