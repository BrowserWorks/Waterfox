# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Mesure de la qualité du mot de passe :

## Change Password dialog

change-device-password-window =
    .title = Changer le mot de passe
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Périphérique de sécurité: { $tokenName }
change-password-old = Ancien mot de passe
change-password-new = Saisissez le nouveau mot de passe
change-password-reenter = Saisissez-le à nouveau
pippki-failed-pw-change = Impossible de changer le mot de passe.
pippki-incorrect-pw = Vous n’avez pas saisi correctement le mot de passe actuel. Veuillez réessayer.
pippki-pw-change-ok = Le mot de passe a été changé.
pippki-pw-empty-warning = Vos mots de passe et clés privées stockés ne seront pas protégés.
pippki-pw-erased-ok = Vous avez supprimé votre mot de passe. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Attention ! Vous avez décidé de ne pas utiliser de mot de passe. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Vous êtes actuellement en mode FIPS. Ce mode nécessite un mot de passe non vide.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Effacer le mot de passe principal
    .style = min-width: 40em
reset-password-button-label =
    .label = Effacer
reset-primary-password-text = Si vous effacez votre mot de passe principal, tous vos mots de passe web et courrier, vos certificats personnels et vos clés privées seront oubliés. Voulez-vous vraiment supprimer le mot de passe principal ?
pippki-reset-password-confirmation-title = Effacer le mot de passe principal
pippki-reset-password-confirmation-message = Votre mot de passe principal a été effacé.

## Downloading cert dialog

download-cert-window2 =
    .title = Téléchargement du certificat
    .style = min-width: 46em
download-cert-message = On vous a demandé de confirmer une nouvelle autorité de certification (AC).
download-cert-trust-ssl =
    .label = Confirmer cette AC pour identifier des sites web.
download-cert-trust-email =
    .label = Confirmer cette AC pour identifier les utilisateurs de courrier.
download-cert-message-desc = Avant de confirmer cette AC pour quelque raison que ce soit, vous devriez l’examiner elle, ses méthodes et ses procédures (si possible).
download-cert-view-cert =
    .label = Voir
download-cert-view-text = Examiner le certificat d’AC

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Requête d’identification d’utilisateur
client-auth-site-description = Ce site vous demande de vous identifier avec un certificat de sécurité :
client-auth-choose-cert = Choisir un certificat à présenter comme identification :
client-auth-send-no-certificate =
    .label = Ne pas envoyer de certificat
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = « { $hostname } » vous demande de vous identifier avec un certificat de sécurité :
client-auth-cert-details = Détails du certificat sélectionné :
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Émis pour : { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Numéro de série : { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Valide du { $notBefore } au { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Utilisations de la clé : { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Adresses e-mail : { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Émis par : { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Stocké sur : { $storedOn }
client-auth-cert-remember-box =
    .label = Se souvenir de cette décision

## Set password (p12) dialog

set-password-window =
    .title = Choisir un mot de passe de sauvegarde du certificat
set-password-message = Le mot de passe de sauvegarde du certificat que vous venez de définir protège le fichier de sauvegarde que vous allez créer. Vous devez donner le mot de passe pour commencer cette sauvegarde.
set-password-backup-pw =
    .value = Mot de passe de sauvegarde du certificat :
set-password-repeat-backup-pw =
    .value = Mot de passe de sauvegarde du certificat (encore) :
set-password-reminder = Important : si vous avez oublié votre mot de passe de sécurité, vous ne pourrez plus importer cette sauvegarde plus tard. Veuillez le conserver en un lieu sûr.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Veuillez vous authentifier auprès du token « { $tokenName } ». La manière de procéder dépend du jeton (par exemple, en utilisant un lecteur d’empreintes digitales ou en saisissant un code avec un clavier).
