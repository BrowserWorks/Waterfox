# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Learn More
onboarding-button-label-get-started = Get Started

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Welcome to { -brand-short-name }
onboarding-welcome-body = You’ve got the browser.<br/>Meet the rest of { -brand-product-name }.
onboarding-welcome-learn-more = Learn more about the benefits.
onboarding-welcome-modal-get-body = You’ve got the browser.<br/>Now get the most out of { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Supercharge your privacy protection.
onboarding-welcome-modal-privacy-body = You’ve got the browser. Let’s add more privacy protection.
onboarding-welcome-modal-family-learn-more = Learn about the { -brand-product-name } family of products.
onboarding-welcome-form-header = Start Here
onboarding-join-form-body = Enter your email address to get started.
onboarding-join-form-email =
    .placeholder = Enter email
onboarding-join-form-email-error = Valid email required
onboarding-join-form-legal = By proceeding, you agree to the <a data-l10n-name="terms">Terms of Service</a> and <a data-l10n-name="privacy">Privacy Notice</a>.
onboarding-join-form-continue = Continue
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Already have an account?
# Text for link to submit the sign in form
onboarding-join-form-signin = Sign In
onboarding-start-browsing-button-label = Start Browsing
onboarding-cards-dismiss =
    .title = Dismiss
    .aria-label = Dismiss

## Welcome full page string

onboarding-fullpage-welcome-subheader = Let’s start exploring everything you can do.
onboarding-fullpage-form-email =
    .placeholder = Your email address…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Take { -brand-product-name } with You
onboarding-sync-welcome-content = Get your bookmarks, history, passwords and other settings on all your devices.
onboarding-sync-welcome-learn-more-link = Learn more about Firefox Accounts
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Continue
onboarding-sync-form-skip-login-button = Skip this step

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Enter your email
onboarding-sync-form-sub-header = to continue to { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Get things done with a family of tools that respects your privacy across your devices.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Everything we do honours our Personal Data Promise: Take less. Keep it safe. No secrets.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Take your bookmarks, passwords, history, and more everywhere you use { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Get notified when your personal info is in a known data breach.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Manage passwords that are protected and portable.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protection From Tracking
onboarding-tracking-protection-text2 = { -brand-short-name } helps stop web sites from tracking you online, making it harder for ads to follow you around the web.
onboarding-tracking-protection-button2 = How it Works
onboarding-data-sync-title = Take Your Settings with You
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Synchronise your bookmarks, passwords, and more everywhere you use { -brand-product-name }.
onboarding-data-sync-button2 = Sign in to { -sync-brand-short-name }
onboarding-firefox-monitor-title = Stay Alert to Data Breaches
onboarding-firefox-monitor-text2 = { -monitor-brand-name } monitors if your email has appeared in a known data breach and alerts you if it appears in a new breach.
onboarding-firefox-monitor-button = Sign Up for Alerts
onboarding-browse-privately-title = Browse Privately
onboarding-browse-privately-text = Private Browsing clears your search and browsing history to keep it secret from anyone who uses your computer.
onboarding-browse-privately-button = Open a Private Window
onboarding-firefox-send-title = Keep Your Shared Files Private
onboarding-firefox-send-text2 = Upload your files to { -send-brand-name } to share them with end-to-end encryption and a link that automatically expires.
onboarding-firefox-send-button = Try { -send-brand-name }
onboarding-mobile-phone-title = Get { -brand-product-name } on Your Phone
onboarding-mobile-phone-text = Download { -brand-product-name } for iOS or Android and synchronise your data across devices.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Download Mobile Browser
onboarding-send-tabs-title = Instantly Send Yourself Tabs
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Easily share pages between your devices without having to copy links or leave the browser.
onboarding-send-tabs-button = Start Using Send Tabs
onboarding-pocket-anywhere-title = Read and Listen Anywhere
onboarding-pocket-anywhere-text2 = Save your favourite content offline with the { -pocket-brand-name } App and read, listen, and watch whenever it’s convenient for you.
onboarding-pocket-anywhere-button = Try { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Create and Store Strong Passwords
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } creates strong passwords on the spot and saves all of them in one place.
onboarding-lockwise-strong-passwords-button = Manage Your Logins
onboarding-facebook-container-title = Set Boundaries with Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } keeps your profile separate from everything else, making it harder for Facebook to target you with ads.
onboarding-facebook-container-button = Add the Extension
onboarding-import-browser-settings-title = Import Your Bookmarks, Passwords, and More
onboarding-import-browser-settings-text = Dive right in—easily bring your Chrome sites and settings with you.
onboarding-import-browser-settings-button = Import Chrome Data
onboarding-personal-data-promise-title = Private by Design
onboarding-personal-data-promise-text = { -brand-product-name } treats your data with respect by taking less of it, protecting it, and being clear about how we use it.
onboarding-personal-data-promise-button = Read our Promise

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Great, you’ve got { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Now let’s get you <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Add the Extension
return-to-amo-get-started-button = Get Started with { -brand-short-name }
onboarding-not-now-button-label = Not now

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Great, you’ve got { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Now let’s get you <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Add the Extension

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Welcome to <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = The fast, safe, and private browser that’s backed by a non-profit.
onboarding-multistage-welcome-primary-button-label = Start Setup
onboarding-multistage-welcome-secondary-button-label = Sign in
onboarding-multistage-welcome-secondary-button-text = Have an account?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Make { -brand-short-name } your <span data-l10n-name="zap">default</span>
onboarding-multistage-set-default-subtitle = Speed, safety, and privacy every time you browse.
onboarding-multistage-set-default-primary-button-label = Make Default
onboarding-multistage-set-default-secondary-button-label = Not now
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Start by making <span data-l10n-name="zap">{ -brand-short-name }</span> a click away
onboarding-multistage-pin-default-subtitle = Fast, safe, and private browsing every time you use the web.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Choose { -brand-short-name } under Web browser when your settings open
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = This will pin { -brand-short-name } to taskbar and open settings
onboarding-multistage-pin-default-primary-button-label = Make { -brand-short-name } My Primary Browser
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Import your passwords, <br/>bookmarks, and <span data-l10n-name="zap">more</span>
onboarding-multistage-import-subtitle = Coming from another browser? It’s easy to bring everything to { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Start Import
onboarding-multistage-import-secondary-button-label = Not now
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = The sites listed here were found on this device. { -brand-short-name } does not save or synchronisation data from another browser unless you choose to import it.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Getting started: screen { $current } of { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Choose a <span data-l10n-name="zap">look</span>
onboarding-multistage-theme-subtitle = Personalise { -brand-short-name } with a theme.
onboarding-multistage-theme-primary-button-label2 = Done
onboarding-multistage-theme-secondary-button-label = Not now
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatic
onboarding-multistage-theme-label-light = Light
onboarding-multistage-theme-label-dark = Dark
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Inherit the appearance of your operating
        system for buttons, menus, and windows.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Inherit the appearance of your operating
        system for buttons, menus, and windows.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Use a light appearance for buttons,
        menus, and windows.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Use a light appearance for buttons,
        menus, and windows.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Use a dark appearance for buttons,
        menus, and windows.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Use a dark appearance for buttons,
        menus, and windows.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Use a colourful appearance for buttons,
        menus, and windows.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Use a colourful appearance for buttons,
        menus, and windows.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    Fire starts
    here
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Furniture designer, Firefox fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Turn off animations

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Keep { -brand-short-name } in your Dock for easy access
       *[other] Pin { -brand-short-name } to your taskbar for easy access
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Keep in Dock
       *[other] Pin to taskbar
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Get started
mr1-onboarding-welcome-header = Welcome to { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Make { -brand-short-name } my primary browser
    .title = Sets { -brand-short-name } as default browser and pins to taskbar
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Make { -brand-short-name } my default browser
mr1-onboarding-set-default-secondary-button-label = Not now
mr1-onboarding-sign-in-button-label = Sign in

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Make { -brand-short-name } your default
mr1-onboarding-default-subtitle = Put speed, safety, and privacy on autopilot.
mr1-onboarding-default-primary-button-label = Make default browser

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Bring it all with you
mr1-onboarding-import-subtitle = Import your passwords, <br/>bookmarks, and more.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Import from { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Import from previous browser
mr1-onboarding-import-secondary-button-label = Not now
mr1-onboarding-theme-header = Make it your own
mr1-onboarding-theme-subtitle = Personalise { -brand-short-name } with a theme.
mr1-onboarding-theme-primary-button-label = Save theme
mr1-onboarding-theme-secondary-button-label = Not now
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = System theme
mr1-onboarding-theme-label-light = Light
mr1-onboarding-theme-label-dark = Dark
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Follow the operating system theme
        for buttons, menus, and windows.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Follow the operating system theme
        for buttons, menus, and windows.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Use a light theme for buttons,
        menus, and windows.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Use a light theme for buttons,
        menus, and windows.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Use a dark theme for buttons,
        menus, and windows.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Use a dark theme for buttons,
        menus, and windows.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Use a dynamic, colourful theme for buttons,
        menus, and windows.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Use a dynamic, colourful theme for buttons,
        menus, and windows.
