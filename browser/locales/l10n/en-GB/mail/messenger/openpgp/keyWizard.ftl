# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Add a Personal OpenPGP Key for { $identity }

key-wizard-button =
    .buttonlabelaccept = Continue
    .buttonlabelhelp = Go back

key-wizard-warning = <b>If you have an existing personal key</b> for this email address, you should import it. Otherwise you will not have access to your archives of encrypted emails, nor be able to read incoming encrypted emails from people who are still using your existing key.

key-wizard-learn-more = Learn more

radio-create-key =
    .label = Create a new OpenPGP Key
    .accesskey = C

radio-import-key =
    .label = Import an existing OpenPGP Key
    .accesskey = I

radio-gnupg-key =
    .label = Use your external key through GnuPG (e.g. from a smartcard)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Generate OpenPGP Key

openpgp-generate-key-info = <b>Key generation may take up to several minutes to complete.</b> Do not exit the application while key generation is in progress. Actively browsing or performing disk-intensive operations during key generation will replenish the 'randomness pool' and speed-up the process. You will be alerted when key generation is completed.

openpgp-keygen-expiry-title = Key expiry

openpgp-keygen-expiry-description = Define the expiration time of your newly generated key. You can later control the date to extend it if necessary.

radio-keygen-expiry =
    .label = Key expires in
    .accesskey = e

radio-keygen-no-expiry =
    .label = Key does not expire
    .accesskey = d

openpgp-keygen-days-label =
    .label = days
openpgp-keygen-months-label =
    .label = months
openpgp-keygen-years-label =
    .label = years

openpgp-keygen-advanced-title = Advanced settings

openpgp-keygen-advanced-description = Control the advanced settings of your OpenPGP Key.

openpgp-keygen-keytype =
    .value = Key type:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Key size:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptic Curve)

openpgp-keygen-button = Generate key

openpgp-keygen-progress-title = Generating your new OpenPGP Key…

openpgp-keygen-import-progress-title = Importing your OpenPGP Keys…

openpgp-import-success = OpenPGP Keys successfully imported!

openpgp-import-success-title = Complete the import process

openpgp-import-success-description = To start using your imported OpenPGP key for email encryption, close this dialogue and access your Account Settings to select it.

openpgp-keygen-confirm =
    .label = Confirm

openpgp-keygen-dismiss =
    .label = Cancel

openpgp-keygen-cancel =
    .label = Cancel process…

openpgp-keygen-import-complete =
    .label = Close
    .accesskey = C

openpgp-keygen-missing-username = There is no name specified for the current account. Please enter a value in the field  "Your name" in the account settings.
openpgp-keygen-long-expiry = You cannot create a key that expires in more than 100 years.
openpgp-keygen-short-expiry = Your key must be valid for at least one day.

openpgp-keygen-ongoing = Key generation already in progress!

openpgp-keygen-error-core = Unable to initialise OpenPGP Core Service

openpgp-keygen-error-failed = OpenPGP Key generation unexpectedly failed

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP Key created successfully, but failed to obtain revocation for key { $key }

openpgp-keygen-abort-title = Abort key generation?
openpgp-keygen-abort = OpenPGP Key generation currently in progress, are you sure you want to cancel it?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Generate public and secret key for { $identity }?

## Import Key section

openpgp-import-key-title = Import an existing personal OpenPGP Key

openpgp-import-key-legend = Select a previously backed up file.

openpgp-import-key-description = You may import personal keys that were created with other OpenPGP software.

openpgp-import-key-info = Other software might describe a personal key using alternative terms such as your own key, secret key, private key or key pair.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird found one key that can be imported.
       *[other] Thunderbird found { $count } keys that can be imported.
    }

openpgp-import-key-list-description = Confirm which keys may be treated as your personal keys. Only keys that you created yourself and that show your own identity should be used as personal keys. You can change this option later in the Key Properties dialogue.

openpgp-import-key-list-caption = Keys marked to be treated as Personal Keys will be listed in the End-To-End Encryption section. The others will be available inside the Key Manager.

openpgp-passphrase-prompt-title = Passphrase required

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Please enter the passphrase to unlock the following key: { $key }

openpgp-import-key-button =
    .label = Select File to Import…
    .accesskey = S

import-key-file = Import OpenPGP Key File

import-key-personal-checkbox =
    .label = Treat this key as a Personal Key

gnupg-file = GnuPG Files

import-error-file-size = <b>Error!</b> Files larger than 5MB are not supported.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Error!</b> Failed to import file. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Error!</b> Failed to import keys. { $error }

openpgp-import-identity-label = Identity

openpgp-import-fingerprint-label = Fingerprint

openpgp-import-created-label = Created

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Key Properties
    .accesskey = K

## External Key section

openpgp-external-key-title = External GnuPG Key

openpgp-external-key-description = Configure an external GnuPG key by entering the Key ID

openpgp-external-key-info = In addition, you must use Key Manager to import and accept the corresponding Public Key.

openpgp-external-key-warning = <b>You may configure only one external GnuPG Key.</b> Your previous entry will be replaced.

openpgp-save-external-button = Save key ID

openpgp-external-key-label = Secret Key ID:

openpgp-external-key-input =
    .placeholder = 123456789341298340
