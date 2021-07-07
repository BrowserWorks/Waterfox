# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP Key Manager
    .accesskey = O
openpgp-ctx-decrypt-open =
    .label = Decrypt and Open
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = Decrypt and Save As…
    .accesskey = C
openpgp-ctx-import-key =
    .label = Import OpenPGP Key
    .accesskey = I
openpgp-ctx-verify-att =
    .label = Verify Signature
    .accesskey = V
openpgp-has-sender-key = This message claims to contain the sender's OpenPGP public key.
openpgp-be-careful-new-key = Warning: The new OpenPGP public key in this message differs from the public keys that you previously accepted for { $email }.
openpgp-import-sender-key =
    .label = Import…
openpgp-search-keys-openpgp =
    .label = Discover OpenPGP Key
openpgp-missing-signature-key = This message was signed with a key that you don't yet have.
openpgp-search-signature-key =
    .label = Discover…
# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = This is an OpenPGP message that was apparently corrupted by MS-Exchange and it can't be repaired because it was opened from a local file. Copy the message into a mail folder to try an automatic repair.
openpgp-broken-exchange-info = This is an OpenPGP message that was apparently corrupted by MS-Exchange. If the message contents isn't shown as expected, you can try an automatic repair.
openpgp-broken-exchange-repair =
    .label = Repair message
openpgp-broken-exchange-wait = Please wait…
openpgp-cannot-decrypt-because-mdc =
    This is an encrypted message that uses an old and vulnerable mechanism.
    It could have been modified while in transit, with the intention to steal its contents.
    To prevent this risk, the contents are not shown.
openpgp-cannot-decrypt-because-missing-key = The secret key that is required to decrypt this message is not available.
openpgp-partially-signed =
    Only a subset of this message was digitally signed using OpenPGP.
    If you click the verify button, the unprotected parts will be hidden, and the status of the digital signature will be shown.
openpgp-partially-encrypted =
    Only a subset of this message was encrypted using OpenPGP.
    The readable parts of the message that are already shown were not encrypted.
    If you click the decrypt button, the contents of the encrypted parts will be shown.
openpgp-reminder-partial-display = Reminder: The message shown below is only a subset of the original message.
openpgp-partial-verify-button = Verify
openpgp-partial-decrypt-button = Decrypt
