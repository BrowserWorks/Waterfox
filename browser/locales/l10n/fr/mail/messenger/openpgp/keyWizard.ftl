# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Ajouter une clé OpenPGP personnelle pour { $identity }

key-wizard-button =
    .buttonlabelaccept = Continuer
    .buttonlabelhelp = Retour

key-wizard-warning = <b>Si vous disposez d’une clé personnelle existante</b> pour cette adresse électronique, vous devriez l’importer. Dans le cas contraire, vous n’aurez pas accès à vos archives de courriels chiffrés, ni ne pourrez lire les courriels chiffrés entrants de personnes qui utilisent encore votre clé existante.

key-wizard-learn-more = En savoir plus

radio-create-key =
    .label = Créer une nouvelle clé OpenPGP
    .accesskey = C

radio-import-key =
    .label = Importer une clé OpenPGP existante
    .accesskey = I

radio-gnupg-key =
    .label = Utiliser votre clé externe via GnuPG (par exemple à partir d’une carte à puce)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Génération d’une clé OpenPGP

openpgp-generate-key-info = <b>La génération d’une clé peut prendre plusieurs minutes.</b> Veuillez ne pas quitter l’application tant que la génération de clé est en cours. Naviguer de façon soutenue sur le Web ou exécuter des opérations qui sollicitent le disque pendant la génération de clé renforcera le caractère aléatoire du processus et l’accélérera. Vous serez averti·e lorsque la génération de clé sera terminée.

openpgp-keygen-expiry-title = Expiration de la clé

openpgp-keygen-expiry-description = Définissez la date d’expiration de la clé que vous venez de générer. Vous pourrez par la suite modifier cette date pour prolonger le délai d’expiration si nécessaire.

radio-keygen-expiry =
    .label = La clé expire dans
    .accesskey = L

radio-keygen-no-expiry =
    .label = La clé n’expire jamais
    .accesskey = c

openpgp-keygen-days-label =
    .label = jours
openpgp-keygen-months-label =
    .label = mois
openpgp-keygen-years-label =
    .label = ans

openpgp-keygen-advanced-title = Paramètres avancés

openpgp-keygen-advanced-description = Contrôlez les paramètres avancés de votre clé OpenPGP.

openpgp-keygen-keytype =
    .value = Type de clé :
    .accesskey = T

openpgp-keygen-keysize =
    .value = Taille de la clé :
    .accesskey = a

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (courbe elliptique)

openpgp-keygen-button = Générer la clé

openpgp-keygen-progress-title = Génération de votre nouvelle clé OpenPGP…

openpgp-keygen-import-progress-title = Importation de vos clés OpenPGP…

openpgp-import-success = Les clés OpenPGP ont été correctement importées.

openpgp-import-success-title = Terminez le processus d’importation

openpgp-import-success-description = Pour commencer à utiliser votre clé OpenPGP importée pour le chiffrement des courriels, fermez cette boîte de dialogue et accédez aux paramètres de votre compte pour la sélectionner.

openpgp-keygen-confirm =
    .label = Confirmer

openpgp-keygen-dismiss =
    .label = Annuler

openpgp-keygen-cancel =
    .label = Annuler le processus…

openpgp-keygen-import-complete =
    .label = Fermer
    .accesskey = F

openpgp-keygen-missing-username = Aucun nom n’est spécifié pour le compte actuel. Veuillez saisir une valeur dans le champ « Votre nom » des paramètres du compte.
openpgp-keygen-long-expiry = Vous ne pouvez pas créer de clé qui expire dans plus de 100 ans.
openpgp-keygen-short-expiry = Votre clé doit être valide pendant au moins un jour.

openpgp-keygen-ongoing = Génération de clé déjà en cours.

openpgp-keygen-error-core = Impossible d’initialiser le service principal d’OpenPGP

openpgp-keygen-error-failed = La génération de clé OpenPGP a échoué de manière inattendue

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = La clé OpenPGP a été correctement créée, mais n’a pas réussi à obtenir la révocation de la clé { $key }

openpgp-keygen-abort-title = Annuler la génération de la clé ?
openpgp-keygen-abort = La génération de clé OpenPGP est en cours, voulez-vous vraiment l’annuler ?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Générer une clé publique et une clé secrète pour { $identity } ?

## Import Key section

openpgp-import-key-title = Importer une clé OpenPGP personnelle existante

openpgp-import-key-legend = Sélectionnez un fichier précédemment sauvegardé.

openpgp-import-key-description = Vous pouvez importer des clés personnelles qui ont été créées avec d’autres logiciels OpenPGP.

openpgp-import-key-info = D’autres logiciels peuvent décrire une clé personnelle en utilisant des termes alternatifs tels que « votre propre clé », « clé secrète », « clé privée » ou « paire de clés ».

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird a trouvé une clé qui peut être importée.
       *[other] Thunderbird a trouvé { $count } clés qui peuvent être importées.
    }

openpgp-import-key-list-description = Confirmez quelles clés peuvent être considérées comme vos clés personnelles. Seules les clés que vous avez créées vous-même et qui indiquent votre propre identité doivent être utilisées comme clés personnelles. Vous pouvez modifier cette option ultérieurement depuis la boîte de dialogue Propriétés de la clé.

openpgp-import-key-list-caption = Les clés marquées comme étant des clés personnelles seront répertoriées dans la section Chiffrement de bout en bout. Les autres seront disponibles dans le gestionnaire de clés.

openpgp-passphrase-prompt-title = Phrase de passe nécessaire

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Veuillez saisir la phrase de passe pour déverrouiller la clé suivante : { $key }

openpgp-import-key-button =
    .label = Sélectionner le fichier à importer…
    .accesskey = S

import-key-file = Importer un fichier de clé OpenPGP

import-key-personal-checkbox =
    .label = Considérer cette clé comme une clé personnelle

gnupg-file = Fichiers GnuPG

import-error-file-size = <b>Erreur :</b> les fichiers de plus de 5 Mo ne sont pas pris en charge.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Erreur :</b> échec de l’importation du fichier. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Erreur :</b> échec de l’importation des clés. { $error }

openpgp-import-identity-label = Identité

openpgp-import-fingerprint-label = Empreinte

openpgp-import-created-label = Date de création

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Propriétés de la clé
    .accesskey = P

## External Key section

openpgp-external-key-title = Clé GnuPG externe

openpgp-external-key-description = Configurer une clé GnuPG externe en saisissant l’identifiant de la clé

openpgp-external-key-info = De plus, vous devez utiliser le gestionnaire de clés pour importer et accepter la clé publique correspondante.

openpgp-external-key-warning = <b>Vous ne pouvez configurer qu’une seule clé GnuPG externe.</b> Votre entrée précédente sera remplacée.

openpgp-save-external-button = Enregistrer l’identifiant de la clé

openpgp-external-key-label = Identifiant de la clé secrète :

openpgp-external-key-input =
    .placeholder = 123456789341298340
