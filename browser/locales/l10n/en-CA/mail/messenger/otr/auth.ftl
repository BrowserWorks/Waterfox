# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verify contact's identity
    .buttonlabelaccept = Verify

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verify the identity of { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Fingerprint for you, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Fingerprint for { $their_name }:

auth-help = Verifying a contact’s identity helps ensure that the conversation is truly private, making it very difficult for a third party to eavesdrop or manipulate the conversation.
auth-helpTitle = Verification help

auth-questionReceived = This is the question asked by your contact:

auth-yes =
    .label = Yes

auth-no =
    .label = No

auth-verified = I have verified that this is in fact the correct fingerprint.

auth-manualVerification = Manual fingerprint verification
auth-questionAndAnswer = Question and answer
auth-sharedSecret = Shared secret

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Contact your intended conversation partner via some other authenticated channel, such as OpenPGP-signed email or over the phone. You should tell each other your fingerprints. (A fingerprint is a checksum that identifies an encryption key.) If the fingerprint matches, you should indicate in the dialog below that you have verified the fingerprint.

auth-how = How would you like to verify your contact’s identity?

auth-qaInstruction = Think of a question to which the answer is known only to you and your contact. Enter the question and answer, then wait for your contact to enter the answer. If the answers do not match, the communication channel you are using may be under surveillance.

auth-secretInstruction = Think of a secret known only to you and your contact. Do not use the same Internet connection to exchange the secret. Enter the secret, then wait for your contact to enter it. If the secrets do not match, the communication channel you are using may be under surveillance.

auth-question = Enter a question:

auth-answer = Enter the answer (case sensitive):

auth-secret = Enter the secret:
