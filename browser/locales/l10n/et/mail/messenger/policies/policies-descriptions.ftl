# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Set policies that WebExtensions can access via chrome.storage.managed.

policy-AppUpdateURL = Set custom app update URL.

policy-Authentication = Configure integrated authentication for websites that support it.

policy-BlockAboutAddons = Block access to the Add-ons Manager (about:addons).

policy-BlockAboutConfig = Block access to the about:config page.

policy-BlockAboutProfiles = Block access to the about:profiles page.

policy-BlockAboutSupport = Block access to the about:support page.

policy-CaptivePortal = Enable or disable captive portal support.

policy-CertificatesDescription = Add certificates or use built-in certificates.

policy-Cookies = Allow or deny websites to set cookies.

policy-DefaultDownloadDirectory = Set the default download directory.

policy-DisableAppUpdate = Prevent { -brand-short-name } from updating.

policy-DisableDeveloperTools = Block access to the developer tools.

policy-DisableFeedbackCommands = Disable commands to send feedback from the Help menu (Submit Feedback and Report Deceptive Site).

policy-DisableForgetButton = Prevent access to the Forget button.

policy-DisableMasterPasswordCreation = If true, a master password can’t be created.

policy-DisableProfileImport = Disable the menu command to Import data from another application.

policy-DisableSafeMode = Disable the feature to restart in Safe Mode. Note: the Shift key to enter Safe Mode can only be disabled on Windows using Group Policy.

policy-DisableSecurityBypass = Prevent the user from bypassing certain security warnings.

policy-DisableSystemAddonUpdate = Prevent { -brand-short-name } from installing and updating system add-ons.

policy-DisableTelemetry = Turn off Telemetry.

policy-DisplayMenuBar = Display the Menu Bar by default.

policy-DNSOverHTTPS = Configure DNS over HTTPS.

policy-DontCheckDefaultClient = Disable check for default client on startup.

policy-DownloadDirectory = Set and lock the download directory.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Enable or disable Content Blocking and optionally lock it.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Install, uninstall or lock extensions. The Install option takes URLs or paths as parameters. The Uninstall and Locked options take extension IDs.

policy-ExtensionSettings = Manage all aspects of extension installation.

policy-ExtensionUpdate = Enable or disable automatic extension updates.

policy-HardwareAcceleration = If false, turn off hardware acceleration.

policy-InstallAddonsPermission = Allow certain websites to install add-ons.

## Do not translate "SameSite", it's the name of a cookie attribute.

##

policy-LocalFileLinks = Allow specific websites to link to local files.

policy-NetworkPrediction = Enable or disable network prediction (DNS prefetching).

policy-OfferToSaveLogins = Enforce the setting to allow { -brand-short-name } to offer to remember saved logins and passwords. Both true and false values are accepted.

policy-OverrideFirstRunPage = Override the first run page. Set this policy to blank if you want to disable the first run page.

policy-OverridePostUpdatePage = Override the post-update “What’s New” page. Set this policy to blank if you want to disable the post-update page.

policy-Preferences = Set and lock the value for a subset of preferences.

policy-PromptForDownloadLocation = Ask where to save files when downloading.

policy-Proxy = Configure proxy settings.

policy-RequestedLocales = Set the list of requested locales for the application in order of preference.

policy-SanitizeOnShutdown2 = Clear navigation data on shutdown.

policy-SearchEngines = Configure search engine settings. This policy is only available on the Extended Support Release (ESR) version.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Install PKCS #11 modules.

policy-SSLVersionMax = Set the maximum SSL version.

policy-SSLVersionMin = Set the minimum SSL version.

policy-SupportMenu = Add a custom support menu item to the help menu.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Block websites from being visited. See documentation for more details on the format.
