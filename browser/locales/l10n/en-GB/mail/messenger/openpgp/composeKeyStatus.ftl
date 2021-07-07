# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = To send an end-to-end encrypted message, you must obtain and accept a public key for each recipient.
openpgp-compose-key-status-keys-heading = Availability of OpenPGP keys:
openpgp-compose-key-status-title =
    .title = OpenPGP Message Security
openpgp-compose-key-status-recipient =
    .label = Recipient
openpgp-compose-key-status-status =
    .label = Status
openpgp-compose-key-status-open-details = Manage keys for selected recipient…
openpgp-recip-good = ok
openpgp-recip-missing = no key available
openpgp-recip-none-accepted = no accepted key
openpgp-compose-general-info-alias = { -brand-short-name } normally requires that the recipient’s public key contains a user ID with a matching email address. This can be overridden by using OpenPGP recipient alias rules.
openpgp-compose-general-info-alias-learn-more = Learn more
openpgp-compose-alias-status-direct =
    { $count ->
        [one] mapped to an alias key
       *[other] mapped to { $count } alias keys
    }
openpgp-compose-alias-status-error = unusable/unavailable alias key
