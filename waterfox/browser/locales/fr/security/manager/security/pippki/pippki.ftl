# This Source Code Form is subject to the terms of the Waterfox Public
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

## Reset Password dialog

pippki-failed-pw-change = Impossible de changer le mot de passe.
pippki-incorrect-pw = Vous n’avez pas saisi correctement le mot de passe actuel. Veuillez réessayer.
pippki-pw-change-ok = Le mot de passe a été changé.

pippki-pw-empty-warning = Vos mots de passe et clés privées stockés ne seront pas protégés.
pippki-pw-erased-ok = Vous avez supprimé votre mot de passe. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Attention ! Vous avez décidé de ne pas utiliser de mot de passe. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Vous êtes actuellement en mode FIPS. Ce mode nécessite un mot de passe non vide.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Effacer le mot de passe principal
    .style = width: 40em
reset-password-button-label =
    .label = Effacer

reset-primary-password-text = Si vous effacez votre mot de passe principal, tous vos mots de passe web et courrier, vos certificats personnels et vos clés privées seront oubliés. Voulez-vous vraiment supprimer le mot de passe principal ?

pippki-reset-password-confirmation-title = Effacer le mot de passe principal
pippki-reset-password-confirmation-message = Votre mot de passe principal a été effacé.

## Downloading cert dialog

download-cert-window =
    .title = Téléchargement du certificat
    .style = width: 46em
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

client-auth-window =
    .title = Requête d’identification d’utilisateur
client-auth-site-description = Ce site vous demande de vous identifier avec un certificat de sécurité :
client-auth-choose-cert = Choisir un certificat à présenter comme identification :
client-auth-cert-details = Détails du certificat sélectionné :

## Set password (p12) dialog

set-password-window =
    .title = Choisir un mot de passe de sauvegarde du certificat
set-password-message = Le mot de passe de sauvegarde du certificat que vous venez de définir protège le fichier de sauvegarde que vous allez créer. Vous devez donner le mot de passe pour commencer cette sauvegarde.
set-password-backup-pw =
    .value = Mot de passe de sauvegarde du certificat :
set-password-repeat-backup-pw =
    .value = Mot de passe de sauvegarde du certificat (encore) :
set-password-reminder = Important : si vous avez oublié votre mot de passe de sécurité, vous ne pourrez plus importer cette sauvegarde plus tard. Veuillez le conserver en un lieu sûr.

## Protected Auth dialog

protected-auth-window =
    .title = Authentification protégée par jeton
protected-auth-msg = Veuillez vous authentifier au jeton. La méthode d’authentification dépend du type de votre jeton.
protected-auth-token = Jeton :
