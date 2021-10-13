# This Source Code Form is subject to the terms of the Waterfox Public
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

auth-help = Verifying a contact's identity helps ensure that the conversation is truly private, making it very difficult for a third party to eavesdrop or manipulate the conversation.

auth-help-title = Verification help

auth-question-received = This is the question asked by your contact:

auth-yes =
    .label = Yes

auth-no =
    .label = No

auth-verified = I have verified that this is in fact the correct fingerprint.

auth-manual-verification = Manual fingerprint verification
auth-question-and-answer = Question and answer
auth-shared-secret = Shared secret

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Contact your intended conversation partner via some other authenticated channel, such as OpenPGP-signed email or over the phone. You should tell each other your fingerprints. (A fingerprint is a checksum that identifies an encryption key.) If the fingerprint matches, you should indicate in the dialogue below that you have verified the fingerprint.

auth-how = How would you like to verify your contact's identity?

auth-qa-instruction = Think of a question to which the answer is known only to you and your contact. Enter the question and answer, then wait for your contact to enter the answer. If the answers do not match, the communication channel you are using may be under surveillance.

auth-secret-instruction = Think of a secret known only to you and your contact. Do not use the same Internet connection to exchange the secret. Enter the secret, then wait for your contact to enter it. If the secrets do not match, the communication channel you are using may be under surveillance.

auth-question = Enter a question:

auth-answer = Enter the answer (case sensitive):

auth-secret = Enter the secret:
