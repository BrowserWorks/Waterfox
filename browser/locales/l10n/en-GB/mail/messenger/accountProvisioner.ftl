# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Get a new email address from a service provider
provisioner-searching-icon =
    .alt = Searching…
account-provisioner-title = Create a new email address
account-provisioner-description = Use our trusted partners to get a new private and secure email address.
account-provisioner-start-help = The search terms used are sent to { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Privacy Policy</a>) and 3rd party email providers <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">Privacy Policy</a>, <a data-l10n-name="mailfence-tou-link">Terms of Use</a>) and <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Privacy Policy</a>, <a data-l10n-name="gandi-tou-link">Terms of Use</a>) to find available email addresses.
account-provisioner-mail-account-title = Buy a new email address
account-provisioner-mail-account-description = Thunderbird partnered with <a data-l10n-name="mailfence-home-link">Mailfence</a> to offer you a new private and secure email. We believe everyone should have a secure email.
account-provisioner-domain-title = Buy an email and domain of your own
account-provisioner-domain-description = Thunderbird partnered with <a data-l10n-name="gandi-home-link">Gandi</a> to offer you a custom domain. This lets you use any address on that domain.

## Forms

account-provisioner-mail-input =
    .placeholder = Your name, nickname or other search term
account-provisioner-domain-input =
    .placeholder = Your name, nickname or other search term
account-provisioner-search-button = Search
account-provisioner-button-cancel = Cancel
account-provisioner-button-existing = Use an existing email account
account-provisioner-button-back = Go back

## Notifications

account-provisioner-fetching-provisioners = Retrivieng provisioners…
account-provisioner-connection-issues = Unable to communicate with our sign-up servers. Please check your connection.
account-provisioner-searching-email = Searching for available email accounts…
account-provisioner-searching-domain = Searching for available domains…
account-provisioner-searching-error = Could not find any addresses to suggest. Try changing the search terms.

## Illustrations

account-provisioner-step1-image =
    .title = Choose which account to create

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] One available address found for:
       *[other] { $count } available addresses found for:
    }
account-provisioner-mail-results-caption = You can try to search for nicknames or any other term to find more emails.
account-provisioner-domain-results-caption = You can try to search for nicknames or any other term to find more domains.
account-provisioner-free-account = Free
account-provision-price-per-year = { $price } a year
account-provisioner-all-results-button = Show all results
