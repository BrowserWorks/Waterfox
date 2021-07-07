# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Account Setup

## Header

account-setup-title = Set Up Your Existing Email Address
account-setup-description =
    To use your current email address fill in your credentials.<br/>
    { -brand-product-name } will automatically search for a working and recommended server configuration.
account-setup-secondary-description = { -brand-product-name } will automatically search for a working and recommended server configuration.
account-setup-success-title = Account successfully created
account-setup-success-description = You can now use this account with { -brand-short-name }.
account-setup-success-secondary-description = You can improve the experience by connecting related services and configuring advanced account settings.

## Form fields

account-setup-name-label = Your full name
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe
account-setup-name-info-icon =
    .title = Your name, as shown to others
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = Email address
    .accesskey = E
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-email-info-icon =
    .title = Your existing email address
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Password
    .accesskey = P
    .title = Optional, will only be used to validate the username
account-provisioner-button = Get a new email address
    .accesskey = G
account-setup-password-toggle =
    .title = Show/hide password
account-setup-password-toggle-show =
    .title = Show password in clear text
account-setup-password-toggle-hide =
    .title = Hide password
account-setup-remember-password = Remember password
    .accesskey = m
account-setup-exchange-label = Your login
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = YOURDOMAIN\yourusername
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Domain login

## Action buttons

account-setup-button-cancel = Cancel
    .accesskey = a
account-setup-button-manual-config = Configure manually
    .accesskey = m
account-setup-button-stop = Stop
    .accesskey = S
account-setup-button-retest = Re-test
    .accesskey = t
account-setup-button-continue = Continue
    .accesskey = C
account-setup-button-done = Done
    .accesskey = D

## Notifications

account-setup-looking-up-settings = Looking up configuration…
account-setup-looking-up-settings-guess = Looking up configuration: Trying common server names…
account-setup-looking-up-settings-half-manual = Looking up configuration: Probing server…
account-setup-looking-up-disk = Looking up configuration: { -brand-short-name } installation…
account-setup-looking-up-isp = Looking up configuration: Email provider…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Looking up configuration: Waterfox ISP database…
account-setup-looking-up-mx = Looking up configuration: Incoming mail domain…
account-setup-looking-up-exchange = Looking up configuration: Exchange server…
account-setup-checking-password = Checking password…
account-setup-installing-addon = Downloading and installing add-on…
account-setup-success-half-manual = The following settings were found by probing the given server:
account-setup-success-guess = Configuration found by trying common server names.
account-setup-success-guess-offline = You are offline. We guessed some settings but you will need to enter the right settings.
account-setup-success-password = Password OK
account-setup-success-addon = Successfully installed the add-on
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Configuration found in Waterfox ISP database.
account-setup-success-settings-disk = Configuration found on { -brand-short-name } installation.
account-setup-success-settings-isp = Configuration found at email provider.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Configuration found for a Microsoft Exchange server.

## Illustrations

account-setup-step1-image =
    .title = Initial setup
account-setup-step2-image =
    .title = Loading…
account-setup-step3-image =
    .title = Configuration found
account-setup-step4-image =
    .title = Connection error
account-setup-step5-image =
    .title = Account created
account-setup-privacy-footnote2 = Your credentials will only be stored locally on your computer.
account-setup-selection-help = Not sure what to select?
account-setup-selection-error = Need help?
account-setup-success-help = Not sure about your next steps?
account-setup-documentation-help = Setup documentation
account-setup-forum-help = Support forum
account-setup-privacy-help = Privacy policy
account-setup-getting-started = Getting started

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Available configuration
       *[other] Available configurations
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Keep your folders and emails synchronised on your server
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Keep your folders and emails on your computer
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Use the Microsoft Exchange server or Office365 cloud services
account-setup-incoming-title = Incoming
account-setup-outgoing-title = Outgoing
account-setup-username-title = Username
account-setup-exchange-title = Server
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = No Encryption
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Use existing outgoing SMTP server
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Incoming: { $incoming }, Outgoing: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Authentication failed. Either the entered credentials are incorrect or a separate username is required for logging in. This username is usually your Windows domain login with or without the domain (for example, janedoe or AD\\janedoe)
account-setup-credentials-wrong = Authentication failed. Please check the username and password
account-setup-find-settings-failed = { -brand-short-name } failed to find the settings for your email account
account-setup-exchange-config-unverifiable = Configuration could not be verified. If your username and password are correct, it’s likely that the server administrator has disabled the selected configuration for your account. Try selecting another protocol.
account-setup-provisioner-error = An error occurred while setting up your new account in { -brand-short-name }. Please, try to manually set up your account with your credentials.

## Manual configuration area

account-setup-manual-config-title = Server settings
account-setup-incoming-server-legend = Incoming server
account-setup-protocol-label = Protocol:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Hostname:
account-setup-port-label = Port:
    .title = Set the port number to 0 for autodetection
account-setup-auto-description = { -brand-short-name } will attempt to auto-detect fields that are left blank.
account-setup-ssl-label = Connection security:
account-setup-outgoing-server-legend = Outgoing server

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Autodetect
ssl-no-authentication-option = No authentication
ssl-cleartext-password-option = Normal password
ssl-encrypted-password-option = Encrypted password

## Incoming/Outgoing SSL options

ssl-noencryption-option = None
account-setup-auth-label = Authentication method:
account-setup-username-label = Username:
account-setup-advanced-setup-button = Advanced config
    .accesskey = A

## Warning insecure server dialog

account-setup-insecure-title = Warning!
account-setup-insecure-incoming-title = Incoming settings:
account-setup-insecure-outgoing-title = Outgoing settings:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> does not use encryption.
account-setup-warning-cleartext-details = Insecure mail servers do not use encrypted connections to protect your passwords and private information. By connecting to this server you could expose your password and private information.
account-setup-insecure-server-checkbox = I understand the risks
    .accesskey = u
account-setup-insecure-description = { -brand-short-name } can allow you to get to your mail using the provided configurations. However, you should contact your administrator or email provider regarding these improper connections. See the <a data-l10n-name="thunderbird-faq-link">Thunderbird FAQ</a> for more information.
insecure-dialog-cancel-button = Change Settings
    .accesskey = S
insecure-dialog-confirm-button = Confirm
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } found your account setup information on { $domain }. Do you want to proceed and submit your credentials?
exchange-dialog-confirm-button = Login
exchange-dialog-cancel-button = Cancel

## Dismiss account creation dialog

exit-dialog-title = No Email Account Configured
exit-dialog-description = Are you sure you want to cancel the setup process? { -brand-short-name } can still be used without an email account, but many features will not be available.
account-setup-no-account-checkbox = Use { -brand-short-name } without an email account
    .accesskey = U
exit-dialog-cancel-button = Continue Setup
    .accesskey = C
exit-dialog-confirm-button = Exit Setup
    .accesskey = E

## Alert dialogs

account-setup-creation-error-title = Error Creating Account
account-setup-error-server-exists = Incoming server already exists.
account-setup-confirm-advanced-title = Confirm Advanced Configuration
account-setup-confirm-advanced-description = This dialog will be closed and an account with the current settings will be created, even if the configuration is incorrect. Do you want to proceed?

## Addon installation section

account-setup-addon-install-title = Install
account-setup-addon-install-intro = A third-party add-on can allow you to access your email account on this server:
account-setup-addon-no-protocol = This email server unfortunately does not support open protocols. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Account settings
account-setup-encryption-button = End-to-end encryption
account-setup-signature-button = Add a signature
account-setup-dictionaries-button = Download dictionaries
account-setup-address-book-carddav-button = Connect to a CardDAV address book
account-setup-address-book-ldap-button = Connect to an LDAP address book
account-setup-calendar-button = Connect to a remote calendar
account-setup-linked-services-title = Connect your linked services
account-setup-linked-services-description = { -brand-short-name } detected other services linked to your email account.
account-setup-no-linked-description = Setup other services to get the most out of your { -brand-short-name } experience.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } found one address book linked to your email account.
       *[other] { -brand-short-name } found { $count } address books linked to your email account.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } found one calendar linked to your email account.
       *[other] { -brand-short-name } found { $count } calendars linked to your email account.
    }
account-setup-button-finish = Finish
    .accesskey = F
account-setup-looking-up-address-books = Looking up address books…
account-setup-looking-up-calendars = Looking up calendars…
account-setup-address-books-button = Address Books
account-setup-calendars-button = Calendars
account-setup-connect-link = Connect
account-setup-existing-address-book = Connected
    .title = Address book already connected
account-setup-existing-calendar = Connected
    .title = Calendar already connected
account-setup-connect-all-calendars = Connect all calendars
account-setup-connect-all-address-books = Connect all address books

## Calendar synchronization dialog

calendar-dialog-title = Connect calendar
calendar-dialog-cancel-button = Cancel
    .accesskey = C
calendar-dialog-confirm-button = Connect
    .accesskey = n
account-setup-calendar-name-label = Name
account-setup-calendar-name-input =
    .placeholder = My calendar
account-setup-calendar-color-label = Colour
account-setup-calendar-refresh-label = Refresh
account-setup-calendar-refresh-manual = Manually
account-setup-calendar-refresh-interval =
    { $count ->
        [one] Every minute
       *[other] Every { $count } minutes
    }
account-setup-calendar-read-only = Read only
    .accesskey = R
account-setup-calendar-show-reminders = Show reminders
    .accesskey = S
account-setup-calendar-offline-support = Offline support
    .accesskey = O
