
# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = To send encrypted or digitally signed messages, you need to configure an encryption technology, either OpenPGP or S/MIME.

e2e-intro-description-more = Select your personal key to enable the use of OpenPGP, or your personal certificate to enable the use of S/MIME. For a personal key or certificate you own the corresponding secret key.

e2e-advanced-section = Advanced settings
e2e-attach-key =
    .label = Attach my public key when adding an OpenPGP digital signature
    .accesskey = p
e2e-encrypt-subject =
    .label = Encrypt the subject of OpenPGP messages
    .accesskey = b
e2e-encrypt-drafts =
    .label = Store draft messages in encrypted format
    .accesskey = r

openpgp-key-user-id-label = Account / User ID
openpgp-keygen-title-label =
    .title = Generate OpenPGP Key
openpgp-cancel-key =
    .label = Cancel
    .tooltiptext = Cancel Key Generation
openpgp-key-gen-expiry-title =
    .label = Key expiry
openpgp-key-gen-expire-label = Key expires in
openpgp-key-gen-days-label =
    .label = days
openpgp-key-gen-months-label =
    .label = months
openpgp-key-gen-years-label =
    .label = years
openpgp-key-gen-no-expiry-label =
    .label = Key does not expire
openpgp-key-gen-key-size-label = Key size
openpgp-key-gen-console-label = Key Generation
openpgp-key-gen-key-type-label = Key type
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptic Curve)
openpgp-generate-key =
    .label = Generate key
    .tooltiptext = Generates a new OpenPGP compliant key for encryption and/or signing
openpgp-advanced-prefs-button-label =
    .label = Advanced…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">NOTE: Key generation may take up to several minutes to complete.</a> Do not exit the application while key generation is in progress. Actively browsing or performing disk-intensive operations during key generation will replenish the 'randomness pool' and speed-up the process. You will be alerted when key generation is completed.

openpgp-key-expiry-label =
    .label = Expiry

openpgp-key-id-label =
    .label = Key ID

openpgp-cannot-change-expiry = This is a key with a complex structure, changing its expiry date isn't supported.

openpgp-key-man-title =
    .title = OpenPGP Key Manager
openpgp-key-man-generate =
    .label = New Key Pair
    .accesskey = K
openpgp-key-man-gen-revoke =
    .label = Revocation Certificate
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = Generate & Save Revocation Certificate

openpgp-key-man-file-menu =
    .label = File
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Edit
    .accesskey = E
openpgp-key-man-view-menu =
    .label = View
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Generate
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Keyserver
    .accesskey = K

openpgp-key-man-import-public-from-file =
    .label = Import Public Key(s) From File
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Import Secret Key(s) From File
openpgp-key-man-import-sig-from-file =
    .label = Import Revocation(s) From File
openpgp-key-man-import-from-clipbrd =
    .label = Import Key(s) From Clipboard
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Import Key(s) From URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Export Public Key(s) To File
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Send Public Key(s) By Email
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Backup Secret Key(s) To File
    .accesskey = B

openpgp-key-man-discover-cmd =
    .label = Discover Keys Online
    .accesskey = D
openpgp-key-man-discover-prompt = To discover OpenPGP keys online, on keyservers or using the WKD protocol, enter either an email address or a key ID.
openpgp-key-man-discover-progress = Searching…

openpgp-key-copy-key =
    .label = Copy Public Key
    .accesskey = C

openpgp-key-export-key =
    .label = Export Public Key To File
    .accesskey = E

openpgp-key-backup-key =
    .label = Backup Secret Key To File
    .accesskey = B

openpgp-key-send-key =
    .label = Send Public Key Via Email
    .accesskey = S

openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Copy Key ID To Clipboard
           *[other] Copy Key IDs To Clipboard
        }
    .accesskey = K

openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Copy Fingerprint To Clipboard
           *[other] Copy Fingerprints To Clipboard
        }
    .accesskey = F

openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Copy Public Key To Clipboard
           *[other] Copy Public Keys To Clipboard
        }
    .accesskey = P

openpgp-key-man-ctx-expor-to-file-label =
    .label = Export Keys To File

openpgp-key-man-ctx-copy =
    .label = Copy
    .accesskey = C

openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] Fingerprint
           *[other] Fingerprints
        }
    .accesskey = F

openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Key ID
           *[other] Key IDs
        }
    .accesskey = K

openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Public Key
           *[other] Public Keys
        }
    .accesskey = P

openpgp-key-man-close =
    .label = Close
openpgp-key-man-reload =
    .label = Reload Key Cache
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = Change Expiration Date
    .accesskey = E
openpgp-key-man-del-key =
    .label = Delete Key(s)
    .accesskey = D
openpgp-delete-key =
    .label = Delete Key
    .accesskey = D
openpgp-key-man-revoke-key =
    .label = Revoke Key
    .accesskey = R
openpgp-key-man-key-props =
    .label = Key Properties
    .accesskey = K
openpgp-key-man-key-more =
    .label = More
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Photo ID
    .accesskey = P
openpgp-key-man-ctx-view-photo-label =
    .label = View Photo ID
openpgp-key-man-show-invalid-keys =
    .label = Display invalid keys
    .accesskey = D
openpgp-key-man-show-others-keys =
    .label = Display Keys From Other People
    .accesskey = O
openpgp-key-man-user-id-label =
    .label = Name
openpgp-key-man-fingerprint-label =
    .label = Fingerprint
openpgp-key-man-select-all =
    .label = Select All Keys
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = Enter search terms in the box above
openpgp-key-man-nothing-found-tooltip =
    .label = No keys match your search terms
openpgp-key-man-please-wait-tooltip =
    .label = Please wait while keys are being loaded…

openpgp-key-man-filter-label =
    .placeholder = Search for keys

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Key Properties
openpgp-key-details-signatures-tab =
    .label = Certifications
openpgp-key-details-structure-tab =
    .label = Structure
openpgp-key-details-uid-certified-col =
    .label = User ID / Certified by
openpgp-key-details-user-id2-label = Alleged Key Owner
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Type
openpgp-key-details-key-part-label =
    .label = Key Part
openpgp-key-details-algorithm-label =
    .label = Algorithm
openpgp-key-details-size-label =
    .label = Size
openpgp-key-details-created-label =
    .label = Created
openpgp-key-details-created-header = Created
openpgp-key-details-expiry-label =
    .label = Expiry
openpgp-key-details-expiry-header = Expiry
openpgp-key-details-usage-label =
    .label = Usage
openpgp-key-details-fingerprint-label = Fingerprint
openpgp-key-details-sel-action =
    .label = Select action…
    .accesskey = S
openpgp-key-details-also-known-label = Alleged Alternative Identities of the Key Owner:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Close
openpgp-acceptance-label =
    .label = Your Acceptance
openpgp-acceptance-rejected-label =
    .label = No, reject this key.
openpgp-acceptance-undecided-label =
    .label = Not yet, maybe later.
openpgp-acceptance-unverified-label =
    .label = Yes, but I have not verified that it is the correct key.
openpgp-acceptance-verified-label =
    .label = Yes, I've verified in person this key has the correct fingerprint.
key-accept-personal =
    For this key, you have both the public and the secret part. You may use it as a personal key.
    If this key was given to you by someone else, then don't use it as a personal key.
key-personal-warning = Did you create this key yourself, and the displayed key ownership refers to yourself?
openpgp-personal-no-label =
    .label = No, don't use it as my personal key.
openpgp-personal-yes-label =
    .label = Yes, treat this key as a personal key.

openpgp-copy-cmd-label =
    .label = Copy

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird doesn't have a personal OpenPGP key for <b>{ $identity }</b>
        [one] Thunderbird found { $count } personal OpenPGP key associated with <b>{ $identity }</b>
       *[other] Thunderbird found { $count } personal OpenPGP keys associated with <b>{ $identity }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Your current configuration uses key ID <b>{ $key }</b>

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Your current configuration uses the key <b>{ $key }</b>, which has expired.

openpgp-add-key-button =
    .label = Add Key…
    .accesskey = A

e2e-learn-more = Learn more

openpgp-keygen-success = OpenPGP Key created successfully!

openpgp-keygen-import-success = OpenPGP Keys imported successfully!

openpgp-keygen-external-success = External GnuPG Key ID saved!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = None

openpgp-radio-none-desc = Do not use OpenPGP for this identity.

openpgp-radio-key-not-usable = This key is not usable as a personal key, because the secret key is missing!
openpgp-radio-key-not-accepted = To use this key you must approve it as a personal key!
openpgp-radio-key-not-found = This key could not be found! If you want to use it you must import it to { -brand-short-name }.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Expires on: { $date }

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Expired on: { $date }

openpgp-key-expires-within-6-months-icon =
    .title = Key is expiring in less than 6 months

openpgp-key-has-expired-icon =
    .title = Key expired

openpgp-key-expand-section =
    .tooltiptext = More information

openpgp-key-revoke-title = Revoke Key

openpgp-key-edit-title = Change OpenPGP Key

openpgp-key-edit-date-title = Extend Expiration Date

openpgp-manager-description = Use the OpenPGP Key Manager to view and manage public keys of your correspondents and all other keys not listed above.

openpgp-manager-button =
    .label = OpenPGP Key Manager
    .accesskey = K

openpgp-key-remove-external =
    .label = Remove External Key ID
    .accesskey = E

key-external-label = External GnuPG Key

# Strings in keyDetailsDlg.xhtml
key-type-public = public key
key-type-primary = primary key
key-type-subkey = subkey
key-type-pair = key pair (secret key and public key)
key-expiry-never = never
key-usage-encrypt = Encrypt
key-usage-sign = Sign
key-usage-certify = Certify
key-usage-authentication = Authentication
key-does-not-expire = The key does not expire
key-expired-date = The key expired on { $keyExpiry }
key-expired-simple = The key has expired
key-revoked-simple = The key was revoked
key-do-you-accept = Do you accept this key for verifying digital signatures and for encrypting messages?
key-accept-warning = Avoid accepting a rogue key. Use a communication channel other than email to verify the fingerprint of your correspondent's key.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Unable to send the message, because there is a problem with your personal key. { $problem }
cannot-encrypt-because-missing = Unable to send this message with end-to-end encryption, because there are problems with the keys of the following recipients: { $problem }
window-locked = Compose window is locked; send cancelled

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Encrypted message part
mime-decrypt-encrypted-part-concealed-data = This is an encrypted message part. You need to open it in a separate window by clicking on the attachment.

# Strings in keyserver.jsm
keyserver-error-aborted = Aborted
keyserver-error-unknown = An unknown error occurred
keyserver-error-server-error = The keyserver reported an error.
keyserver-error-import-error = Failed to import the downloaded key.
keyserver-error-unavailable = The keyserver is not available.
keyserver-error-security-error = The keyserver does not support encrypted access.
keyserver-error-certificate-error = The keyserver’s certificate is not valid.
keyserver-error-unsupported = The keyserver is not supported.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Your email provider processed your request to upload your public key to the OpenPGP Web Key Directory.
    Please confirm to complete the publishing of your public key.
wkd-message-body-process =
    This is an email related to the automatic processing to upload your public key to the OpenPGP Web Key Directory.
    You do not need to take any manual action at this point.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Could not decrypt message with subject
    { $subject }.
    Do you want to retry with a different passphrase or do you want to skip the message?

# Strings in gpg.jsm
unknown-signing-alg = Unknown signing algorithm (ID: { $id })
unknown-hash-alg = Unknown cryptographic hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Your key { $desc } will expire in less than { $days } days.
    We recommend that you create a new key pair and configure the corresponding accounts to use it.
expiry-keys-expire-soon =
    Your following keys will expire in less than { $days } days:{ $desc }.
    We recommend that you create new keys and configure the corresponding accounts to use them.
expiry-key-missing-owner-trust =
    Your secret key { $desc } has missing trust.
    We recommend that you set "You rely on certifications" to "ultimate" in key properties.
expiry-keys-missing-owner-trust =
    The following of your secret keys have missing trust.
    { $desc }.
    We recommend that you set "You rely on certifications" to "ultimate" in key properties.
expiry-open-key-manager = Open OpenPGP Key Manager
expiry-open-key-properties = Open Key Properties

# Strings filters.jsm
filter-folder-required = You must select a target folder.
filter-decrypt-move-warn-experimental =
    Warning - the filter action "Decrypt permanently" may lead to destroyed messages.
    We strongly recommend that you first try the "Create decrypted Copy" filter, test the result carefully, and only start using this filter once you are satisfied with the result.
filter-term-pgpencrypted-label = OpenPGP Encrypted
filter-key-required = You must select a recipient key.
filter-key-not-found = Could not find an encryption key for '{ $desc }'.
filter-warn-key-not-secret =
    Warning - the filter action "Encrypt to key" replaces the recipients.
    If you do not have the secret key for '{ $desc }' you will no longer be able to read the emails.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Decrypt permanently (OpenPGP)
filter-decrypt-copy-label = Create decrypted Copy (OpenPGP)
filter-encrypt-label = Encrypt to key (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Success! Keys imported
import-info-bits = Bits
import-info-created = Created
import-info-fpr = Fingerprint
import-info-details = View Details and manage key acceptance
import-info-no-keys = No keys imported.

# Strings in enigmailKeyManager.js
import-from-clip = Do you want to import some key(s) from clipboard?
import-from-url = Download public key from this URL:
copy-to-clipbrd-failed = Could not copy the selected key(s) to the clipboard.
copy-to-clipbrd-ok = Key(s) copied to clipboard
delete-secret-key =
    WARNING: You are about to delete a secret key!
    
    If you delete your secret key, you will no longer be able to decrypt any messages encrypted for that key, nor will you be able to revoke it.
    
    Do you really want to delete BOTH, the secret key and the public key
    '{ $userId }'?
delete-mix =
    WARNING: You are about to delete secret keys!
    If you delete your secret key, you will no longer be able to decrypt any messages encrypted for that key.
    Do you really want to delete BOTH, the selected secret and public keys?
delete-pub-key =
    Do you want to delete the public key
    '{ $userId }'?
delete-selected-pub-key = Do you want to delete the public keys?
refresh-all-question = You did not select any key. Would you like to refresh ALL keys?
key-man-button-export-sec-key = Export &Secret Keys
key-man-button-export-pub-key = Export &Public Keys Only
key-man-button-refresh-all = &Refresh All Keys
key-man-loading-keys = Loading keys, please wait…
ascii-armor-file = ASCII Armored Files (*.asc)
no-key-selected = You should select at least one key in order to perform the selected operation
export-to-file = Export Public Key To File
export-keypair-to-file = Export Secret and Public Key To File
export-secret-key = Do you want to include the secret key in the saved OpenPGP key file?
save-keys-ok = The keys were successfully saved
save-keys-failed = Saving the keys failed
default-pub-key-filename = Exported-public-keys
default-pub-sec-key-filename = Backup-of-secret-keys
refresh-key-warn = Warning: depending on the number of keys and the connection speed, refreshing all keys could be quite a lengthy process!
preview-failed = Can't read public key file.
general-error = Error: { $reason }
dlg-button-delete = &Delete

## Account settings export output

openpgp-export-public-success = <b>Public Key successfully exported!</b>
openpgp-export-public-fail = <b>Unable to export the selected public key!</b>

openpgp-export-secret-success = <b>Secret Key successfully exported!</b>
openpgp-export-secret-fail = <b>Unable to export the selected secret key!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = The key { $userId } (key ID { $keyId }) is revoked.
key-ring-pub-key-expired = The key { $userId } (key ID { $keyId }) has expired.
key-ring-no-secret-key = You do not seem to have the secret key for { $userId } (key ID { $keyId }) on your keyring; you cannot use the key for signing.
key-ring-pub-key-not-for-signing = The key { $userId } (key ID { $keyId }) cannot be used for signing.
key-ring-pub-key-not-for-encryption = The key { $userId } (key ID { $keyId }) cannot be used for encryption.
key-ring-sign-sub-keys-revoked = All signing-subkeys of key { $userId } (key ID { $keyId }) are revoked.
key-ring-sign-sub-keys-expired = All signing-subkeys of key { $userId } (key ID { $keyId }) have expired.
key-ring-enc-sub-keys-revoked = All encryption subkeys of key { $userId } (key ID { $keyId }) are revoked.
key-ring-enc-sub-keys-expired = All encryption subkeys of key { $userId } (key ID { $keyId }) have expired.

# Strings in gnupg-keylist.jsm
keyring-photo = Photo
user-att-photo = User attribute (JPEG image)

# Strings in key.jsm
already-revoked = This key has already been revoked.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    You are about to revoke the key '{ $identity }'.
    You will no longer be able to sign with this key, and once distributed, others will no longer be able to encrypt with that key. You can still use the key to decrypt old messages.
    Do you want to proceed?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    You have no key (0x{ $keyId }) which matches this revocation certificate!
    If you have lost your key, you must import it (e.g. from a keyserver) before importing the revocation certificate!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = The key 0x{ $keyId } has already been revoked.

key-man-button-revoke-key = &Revoke Key

openpgp-key-revoke-success = Key successfully revoked.

after-revoke-info =
    The key has been revoked.
    Share this public key again, by sending it by email, or by uploading it to keyservers, to let others know that you revoked your key.
    As soon as the software used by other people learns about the revocation, it will stop using your old key.
    If you are using a new key for the same email address, and you attach the new public key to emails you send, then information about your revoked old key will be automatically included.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Import

delete-key-title = Delete OpenPGP Key

delete-external-key-title = Remove the External GnuPG Key

delete-external-key-description = Do you want to remove this External GnuPG key ID?

key-in-use-title = OpenPGP Key currently in use

delete-key-in-use-description = Unable to proceed! The Key you selected for deletion is currently being used by this identity. Select a different key, or select none, and try again.

revoke-key-in-use-description = Unable to proceed! The Key you selected for revocation is currently being used by this identity. Select a different key, or select none, and try again.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = The email address '{ $keySpec }' cannot be matched to a key on your keyring.
key-error-key-id-not-found = The configured key ID '{ $keySpec }' cannot be found on your keyring.
key-error-not-accepted-as-personal = You have not confirmed that the key with ID '{ $keySpec }' is your personal key.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = The function you have selected is not available in offline mode. Please go online and try again.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = We could not find any key matching the specified search criteria.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Error - key extraction command failed

# Strings used in keyRing.jsm
fail-cancel = Error - Key receive cancelled by user
not-first-block = Error - First OpenPGP block not public key block
import-key-confirm = Import public key(s) embedded in message?
fail-key-import = Error - key importing failed
file-write-failed = Failed to write to file { $output }
no-pgp-block = Error - No valid armored OpenPGP data block found
confirm-permissive-import = Import failed. The key you are trying to import might be corrupt or use unknown attributes. Would you like to attempt to import the parts that are correct? This might result in the import of incomplete and unusable keys.

# Strings used in trust.jsm
key-valid-unknown = unknown
key-valid-invalid = invalid
key-valid-disabled = disabled
key-valid-revoked = revoked
key-valid-expired = expired
key-trust-untrusted = untrusted
key-trust-marginal = marginal
key-trust-full = trusted
key-trust-ultimate = ultimate
key-trust-group = (group)

# Strings used in commonWorkflows.js
import-key-file = Import OpenPGP Key File
import-rev-file = Import OpenPGP Revocation File
gnupg-file = GnuPG Files
import-keys-failed = Importing the keys failed
passphrase-prompt = Please enter the passphrase that unlocks the following key: { $key }
file-to-big-to-import = This file is too big. Please don't import a large set of keys at once.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Create & Save Revocation Certificate
revoke-cert-ok = The revocation certificate has been successfully created. You can use it to invalidate your public key, e.g. in case you would lose your secret key.
revoke-cert-failed = The revocation certificate could not be created.
gen-going = Key generation already in progress!
keygen-missing-user-name = There is no name specified for the selected account/identity. Please enter a value in the field  "Your name" in the account settings.
expiry-too-short = Your key must be valid for at least one day.
expiry-too-long = You cannot create a key that expires in more than 100 years.
key-confirm = Generate public and secret key for '{ $id }'?
key-man-button-generate-key = &Generate Key
key-abort = Abort key generation?
key-man-button-generate-key-abort = &Abort Key Generation
key-man-button-generate-key-continue = &Continue Key Generation

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Error - decryption failed
fix-broken-exchange-msg-failed = Did not succeed to repair message.

attachment-no-match-from-signature = Could not match signature file '{ $attachment }' to an attachment
attachment-no-match-to-signature = Could not match attachment '{ $attachment }' to a signature file
signature-verified-ok = The signature for attachment { $attachment } was successfully verified
signature-verify-failed = The signature for attachment { $attachment } could not be verified
decrypt-ok-no-sig =
    Warning
    Decryption was successful, but the signature could not be verified correctly
msg-ovl-button-cont-anyway = &Continue Anyway
enig-content-note = *Attachments to this message have not been signed nor encrypted*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Send Message
msg-compose-details-button-label = Details…
msg-compose-details-button-access-key = D
send-aborted = Send operation aborted.
key-not-trusted = Not enough trust for key '{ $key }'
key-not-found = Key '{ $key }' not found
key-revoked = Key '{ $key }' revoked
key-expired = Key '{ $key }' expired
msg-compose-internal-error = An internal error has occurred.
keys-to-export = Select OpenPGP Keys to Insert
msg-compose-partially-encrypted-inlinePGP =
    The message you are replying to contained both unencrypted and encrypted parts. If the sender was not able to decrypt some message parts originally, you may be leaking confidential information that the sender was not able to originally decrypt themselves.
    Please consider removing all quoted text from your reply to this sender.
msg-compose-cannot-save-draft = Error while saving draft
msg-compose-partially-encrypted-short = Beware of leaking sensitive information - partially encrypted email.
quoted-printable-warn =
    You have enabled 'quoted-printable' encoding for sending messages. This may result in incorrect decryption and/or verification of your message.
    Do you wish to turn off sending 'quoted-printable' messages now?
minimal-line-wrapping =
    You have set line wrapping to { $width } characters. For correct encryption and/or signing, this value needs to be at least 68.
    Do you wish to change line wrapping to 68 characters now?
sending-news =
    Encrypted send operation aborted.
    This message cannot be encrypted because there are newsgroup recipients. Please re-send the message without encryption.
send-to-news-warning =
    Warning: you are about to send an encrypted email to a newsgroup.
    This is discouraged because it only makes sense if all members of the group can decrypt the message, i.e. the message needs to be encrypted with the keys of all group participants. Please send this message only if you know exactly what you are doing.
    Continue?
save-attachment-header = Save decrypted attachment
no-temp-dir =
    Could not find a temporary directory to write to
    Please set the TEMP environment variable
possibly-pgp-mime = Possibly PGP/MIME encrypted or signed message; use 'Decrypt/Verify' function to verify
cannot-send-sig-because-no-own-key = Cannot digitally sign this message, because you haven't yet configured end-to-end encryption for <{ $key }>
cannot-send-enc-because-no-own-key = Cannot send this message encrypted, because you haven't yet configured end-to-end encryption for <{ $key }>

compose-menu-attach-key =
    .label = Attach My Public Key
    .accesskey = A
compose-menu-encrypt-subject =
    .label = Subject Encryption
    .accesskey = b

# Strings used in decryption.jsm
do-import-multiple =
    Import the following keys?
    { $key }
do-import-one = Import { $name } ({ $id })?
cant-import = Error importing public key
unverified-reply = Indented message part (reply) was probably modified
key-in-message-body = A key was found in the message body. Click 'Import Key' to import the key
sig-mismatch = Error - Signature mismatch
invalid-email = Error - invalid email address(es)
attachment-pgp-key =
    The attachment '{ $name }' you are opening appears to be an OpenPGP key file.
    Click 'Import' to import the keys contained or 'View' to view the file contents in a browser window
dlg-button-view = &View

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Decrypted message (restored broken PGP email format probably caused by an old Exchange server, so that the result might not be perfect to read)

# Strings used in encryption.jsm
not-required = Error - no encryption required

# Strings used in windows.jsm
no-photo-available = No Photo available
error-photo-path-not-readable = Photo path '{ $photo }' is not readable
debug-log-title = OpenPGP Debug Log

# Strings used in dialog.jsm
repeat-prefix = This alert will repeat { $count }
repeat-suffix-singular = more time.
repeat-suffix-plural = more times.
no-repeat = This alert will not be shown again.
dlg-keep-setting = Remember my answer and do not ask me again
dlg-button-ok = &OK
dlg-button-close = &Close
dlg-button-cancel = &Cancel
dlg-no-prompt = Do not show me this dialogue again
enig-prompt = OpenPGP Prompt
enig-confirm = OpenPGP Confirmation
enig-alert = OpenPGP Alert
enig-info = OpenPGP Information

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Retry
dlg-button-skip = &Skip

# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = OpenPGP Alert
