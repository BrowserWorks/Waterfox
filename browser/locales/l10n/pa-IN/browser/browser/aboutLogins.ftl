# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ਲਾਗਇਨ ਤੇ ਪਾਸਵਰਡ

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = ਆਪਣੇ ਪਾਸਵਰਡ ਹਰ ਥਾਂ ਲੈ ਜਾਓ
login-app-promo-subtitle = ਮੁਫ਼ਤ { -lockwise-brand-name } ਲਵੋ
login-app-promo-android =
    .alt = ਇਸ ਨੂੰ Google Play ਤੋਂ ਲਵੋ
login-app-promo-apple =
    .alt = ਐਪ ਸਟੋਰ ਤੋਂ ਡਾਊਨਲੋਡ ਕਰੋ

login-filter =
    .placeholder = ਲਾਗਇਨ ਖੋਜੋ

create-login-button = ਨਵਾਂ ਲਾਗਇਨ ਬਣਾਓ

fxaccounts-sign-in-text = ਆਪਣੇ ਹੋਰ ਡਿਵਾਈਸਾਂ ਉੱਤੇ ਆਪਣੇ ਪਾਸਵਰਡ ਲਵੋ
fxaccounts-sign-in-button = { -sync-brand-short-name } ਵਿੱਚ ਸਾਇਨ ਇਨ ਕਰੋ
fxaccounts-avatar-button =
    .title = ਖਾਤਾ ਦਾ ਇੰਤਜ਼ਾਮ

## The ⋯ menu that is in the top corner of the page

menu =
    .title = ਮੇਨੂ ਖੋਲ੍ਹੋ
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = …ਹੋਰ ਬਰਾਊਜ਼ਰ ਤੋਂ ਬਰਾਮਦ ਕਰੋ
about-logins-menu-menuitem-import-from-a-file = …ਤੋਂ ਫ਼ਾਈਲ ਇੰਪੋਰਟ ਕਰੋ
about-logins-menu-menuitem-export-logins = …ਲਾਗਇਨ ਐਕਸਪੋਰਟ ਕਰੋ
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] ਚੋਣਾਂ
       *[other] ਪਸੰਦਾਂ
    }
about-logins-menu-menuitem-help = ਮਦਦ
menu-menuitem-android-app = ਐਡਰਾਈਡ ਲਈ { -lockwise-brand-short-name }
menu-menuitem-iphone-app = iPhone ਅਤੇ iPad ਲਈ { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = ਲਾਗਇਨ ਨਾਲ ਮਿਲਦੀ ਖੋਜ ਕਿਊਰੀ
login-list-count =
    { $count ->
        [one] { $count } ਲਾਗਇਨ
       *[other] { $count } ਲਾਗਇਨ
    }
login-list-sort-label-text = ਲੜੀਬੱਧ:
login-list-name-option = ਨਾਂ (A-Z)
login-list-name-reverse-option = ਨਾਂ (Z-A)
about-logins-login-list-alerts-option = ਚੇਤਾਵਨੀ
login-list-last-changed-option = ਆਖਰੀ ਵਾਰ ਸੋਧੇ
login-list-last-used-option = ਆਖਰੀ ਵਾਰ ਵਰਤੇ
login-list-intro-title = ਕੋਈ ਲਾਗਇਨ ਨਹੀਂ ਲੱਭਿਆ
login-list-intro-description = ਜਦੋਂ ਤੁਸੀਂ { -brand-product-name } ‘ਚ ਪਾਸਵਰਡ ਸੰਭਾਲਦੇ ਹੋ ਤਾਂ ਇਸ ਨੂੰ ਇੱਥੇ ਦਿਖਾਇਆ ਜਾਂਦਾ ਹੈ।
about-logins-login-list-empty-search-title = ਕੋਈ ਲਾਗਇਨ ਨਹੀਂ ਲੱਭਿਆ
about-logins-login-list-empty-search-description = ਤੁਹਾਡੀ ਖੋਜ ਨਾਲ ਮਿਲਦਾ ਕੋਈ ਨਤੀਜਾ ਨਹੀਂ ਹੈ।
login-list-item-title-new-login = ਨਵਾਂ ਲਾਗਇਨ
login-list-item-subtitle-new-login = ਆਪਣੀ ਲਾਗਇਨ ਸਨਦ ਦਿਓ
login-list-item-subtitle-missing-username = (ਕੋਈ ਵਰਤੋਂਕਾਰ ਨਾਂ ਨਹੀਂ ਹੈ)
about-logins-list-item-breach-icon =
    .title = ਉਲੰਘਣ ਕਰਨ ਵਾਲੀ ਵੈੱਬਸਾਈਟ
about-logins-list-item-vulnerable-password-icon =
    .title = ਕਮਜ਼ੋਰ ਪਾਸਵਰਡ

## Introduction screen

login-intro-heading = ਆਪਣੇ ਸੰਭਾਲੇ ਹੋਏ ਲਾਗਇਨ ਨੂੰ ਲੱਭ ਰਹੇ ਹੋ? { -sync-brand-short-name } ਸੈੱਟ ਅੱਪ ਕਰੋ।

about-logins-login-intro-heading-logged-out = ਆਪਣੇ ਸੰਭਾਲੇ ਹੋਏ ਲਾਗਇਨ ਨੂੰ ਲੱਭ ਰਹੇ ਹੋ? { -sync-brand-short-name } ਸੈੱਟ ਅੱਪ ਕਰੋ ਜਾਂ ਇੰਪੋਰਟ ਕਰੋ।
about-logins-login-intro-heading-logged-in = ਕੋਈ ਸਿੰਕ ਕੀਤਾ ਲਾਗਇਨ ਨਹੀਂ ਮਿਲਿਆ ।
login-intro-description = ਜੇ ਤੁਸੀਂ ਵੱਖਰੇ ਡਿਵਾਈਸ ‘ਤੇ { -brand-product-name } ‘ਚ ਆਪਣੇ ਲਾਗਇਨ ਸੰਭਾਲੇ ਸਨ ਤਾਂ ਉਹਨਾਂ ਨੂੰ ਇੰਞ ਪ੍ਰਾਪਤ ਕਰੋ:
login-intro-instruction-fxa = ਡਿਵਾਈਸ, ਜਿੱਥੇ ਤੁਹਾਡੇ ਲਾਗਇਨ ਸੰਭਾਲੇ ਹੋਏ ਹਨ, ਉੱਤੇ ਆਪਣਾ { -fxaccount-brand-name } ਬਣਾਓ ਜਾਂ ਸਾਈਨ ਇਨ ਕਰੋ
login-intro-instruction-fxa-settings = ਪੱਕਾ ਕਰੋ ਕਿ ਤੁਸੀਂ { -sync-brand-short-name } ਸੈਟਿੰਗਾਂ ‘ਚ ਲਾਗਇਨ ਚੋਣ-ਬਕਸੇ ਨੂੰ ਚੁਣਿਆ ਹੈ
about-logins-intro-instruction-help = ਹੋਰ ਮਦਦ ਲਈ <a data-l10n-name="help-link">{ -lockwise-brand-short-name } ਸਹਿਯੋਗ</a> ਨੂੰ ਵੇਖੋ
about-logins-intro-import = ਜੇ ਤੁਸੀਂ ਹੋਰ ਬਰਾਊਜ਼ਰ 'ਚ ਲਾਗਇਨ ਸੰਭਾਲੇ ਹਨ ਤਾਂ ਤੁਸੀਂ { -lockwise-brand-short-name } ਵਿੱਚ ਉਹਨਾਂ ਨੂੰ <a data-l10n-name="import-link">ਇੰਪੋਰਟ ਕਰ</a> ਕਰ ਸਕਦੇ ਹੋ।

about-logins-intro-import2 = ਜੇ ਤੁਹਾਡੇ ਲਾਗ-ਇਨ { -brand-product-name } ਤੋਂ ਅਲੱਗ ਸੰਭਾਲੇ ਗਏ ਹਨ ਤਾਂ ਤੁਸੀਂ <a data-l10n-name="import-browser-link">ਹੋਰ ਬਰਾਊਜ਼ਰ</a> ਜਾਂ a data-l10n-name="import-file-link">ਫ਼ਾਈਲ</a> ਤੋਂ ਇੰਪੋਰਟ ਕਰ ਸਕਦੇ ਹੋ।

## Login

login-item-new-login-title = ਨਵਾਂ ਲਾਗਇਨ ਬਣਾਓ
login-item-edit-button = ਸੋਧੋ
about-logins-login-item-remove-button = ਹਟਾਓ
login-item-origin-label = ਵੈੱਬਸਾਈਟ ਸਿਰਨਾਵਾਂ
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = ਵਰਤੋਂਕਾਰ ਨਾਂ
about-logins-login-item-username =
    .placeholder = (ਕੋਈ ਵਰਤੋਂਕਾਰ ਨਾਂ ਨਹੀਂ ਹੈ)
login-item-copy-username-button-text = ਕਾਪੀ ਕਰੋ
login-item-copied-username-button-text = ਕਾਪੀ ਕੀਤਾ!
login-item-password-label = ਪਾਸਵਰਡ
login-item-password-reveal-checkbox =
    .aria-label = ਪਾਸਵਰਡ ਵੇਖਾਓ
login-item-copy-password-button-text = ਕਾਪੀ ਕਰੋ
login-item-copied-password-button-text = ਕਾਪੀ ਕੀਤਾ!
login-item-save-changes-button = ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ
login-item-save-new-button = ਸੰਭਾਲੋ
login-item-cancel-button = ਰੱਦ ਕਰੋ
login-item-time-changed = ਆਖਰੀ ਵਾਰ ਕੀਤੀ ਸੋਧ: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = ਬਣਾਇਆ: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = ਆਖਰੀ ਵਰਤੋਂ: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = ਆਪਣੇ ਲਾਗਇਨ ਨੂੰ ਸੋਧਣ ਲਈ ਆਪਣੇ ਵਿੰਡੋਜ਼ ਸਨਦ ਦਿਓ। ਇਹ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = ਸੰਭਾਲੇ ਲਾਗਇਨ ਨੂੰ ਸੋਧੋ

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = ਆਪਣੇ ਪਾਸਵਰਡ ਵੇਖਣ ਲਈ ਆਪਣੇ ਵਿੰਡੋਜ਼ ਸਨਦ ਦਿਓ। ਇਹ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = ਸੰਭਾਲੇ ਪਾਸਵਰਡ ਉਘਾੜੋ

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = ਆਪਣੇ ਪਾਸਵਰਡ ਕਾਪੀ ਕਰਨ ਲਈ ਆਪਣੇ ਵਿੰਡੋਜ਼ ਸਨਦ ਦਿਓ। ਇਹ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = ਸੰਭਾਲੇ ਪਾਸਵਰਡ ਨੂੰ ਕਾਪੀ ਕਰੋ

## Master Password notification

master-password-notification-message = ਸੰਭਾਲੇ ਹੋਏ ਲਾਗਇਨ ਤੇ ਪਾਸਵਰਡ ਵੇਖਣ ਲਈ ਆਪਣਾ ਮਾਸਟਰ ਪਾਸਵਰਡ ਦਿਓ

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = ਆਪਣੇ ਲਾਗਇਨ ਨੂੰ ਐਕਸਪੋਰਟ ਕਰਨ ਲਈ ਆਪਣੇ ਵਿੰਡੋਜ਼ ਸਨਦ ਦਿਓ। ਇਹ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = ਸੰਭਾਲੇ ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ ਨੂੰ ਐਕਸਪੋਰਟ ਕਰੋ

## Primary Password notification

about-logins-primary-password-notification-message = ਸੰਭਾਲੇ ਹੋਏ ਲਾਗਇਨ ਤੇ ਪਾਸਵਰਡ ਵੇਖਣ ਲਈ ਆਪਣਾ ਮੁੱਖ ਪਾਸਵਰਡ ਦਿਓ
master-password-reload-button =
    .label = ਲਾਗ ਇਨ
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] ਆਪਣੇ ਲਾਗਇਨ ਹਰ ਥਾਂ ਚਾਹੁੰਦੇ ਹੋ, ਜਿੱਥੇ ਵੀ ਤੁਸੀਂ { -brand-product-name } ਨੂੰ ਵਰਤੋਂ? ਆਪਣੀਆਂ { -sync-brand-short-name } ਚੋਣਾਂ ‘ਚ ਜਾਓ ਅਤੇ ਲਾਗਇਨ ਚੋਣ-ਬਕਸੇ ਨੂੰ ਚੁਣੋ।
       *[other] ਆਪਣੇ ਲਾਗਇਨ ਹਰ ਥਾਂ ਚਾਹੁੰਦੇ ਹੋ, ਜਿੱਥੇ ਵੀ ਤੁਸੀਂ { -brand-product-name } ਨੂੰ ਵਰਤੋਂ? ਆਪਣੀਆਂ  { -sync-brand-short-name }  ਪਸੰਦਾਂ ‘ਤਾਂ ਜਾਓ ਅਤੇ ਲਾਗਇਨ ਚੋਣ-ਬਕਸੇ ਨੂੰ ਚੁਣੋ।
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } ਚੋਣਾਂ ਨੂੰ ਵੇਖੋ
           *[other] { -sync-brand-short-name } ਪਸੰਦਾਂ ਨੂੰ ਵੇਖੋ
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = ਮੈਨੂੰ ਮੁੜ ਨਾ ਪੁੱਛੋ
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = ਰੱਦ ਕਰੋ
confirmation-dialog-dismiss-button =
    .title = ਰੱਦ ਕਰੋ

about-logins-confirm-remove-dialog-title = ਇਹ ਲਾਗਇਨ ਹਟਾਉਣਾ ਹੈ?
confirm-delete-dialog-message = ਇਹ ਕਾਰਵਾਈ ਵਾਪਸ ਨਹੀਂ ਲਈ ਜਾ ਸਕਦੀ ਹੈ।
about-logins-confirm-remove-dialog-confirm-button = ਹਟਾਓ

about-logins-confirm-export-dialog-title = ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ ਐਕਸਪੋਰਟ ਕਰੋ
about-logins-confirm-export-dialog-message = ਤੁਹਾਡੇ ਪਾਸਵਰਡਾਂ ਨੂੰ ਪੜ੍ਹਨਯੋਗ ਲਿਖਤ ਵਜੋਂ ਸੰਭਾਲਿਆ ਜਾਵੇਗਾ (ਜਿਵੇਂ, BadP@ssw0rd), ਤਾਂ ਕਰਕੇ ਐਕਸਪੋਰਟ ਕੀਤੀ ਫਾਇਲ ਖੋਲ੍ਹ ਸਕਣ ਵਾਲਾ ਕੋਈ ਵੀ ਉਨ੍ਹਾਂ ਨੂੰ ਵੇਖ ਸਕਦਾ ਹੈ।
about-logins-confirm-export-dialog-confirm-button = …ਐਕਸਪੋਰਟ ਕਰੋ

confirm-discard-changes-dialog-title = ਨਾ-ਸੰਭਾਲੀਆਂ ਤਬਦੀਲੀਆਂ ਖ਼ਾਰਜ ਕਰਨੀਆਂ ਹਨ?
confirm-discard-changes-dialog-message = ਸਾਰੀਆਂ ਨਾ-ਸੰਭਾਲੀਆਂ ਤਬਦੀਲੀਆਂ ਗੁਆਚ ਜਾਣਗੀਆਂ।
confirm-discard-changes-dialog-confirm-button = ਖ਼ਾਰਜ ਕਰੋ

## Breach Alert notification

about-logins-breach-alert-title = ਵੈੱਬਸਾਈਟ ਦੀ ਉਲੰਘਣਾ
breach-alert-text = ਤੁਹਾਡੇ ਵਲੋਂ ਆਪਣੇ ਲਾਗਇਨ ਵੇਰਵਿਆਂ ਨੂੰ ਆਖਰੀ ਵਾਰ ਅੱਪਡੇਟ ਕਰਨ ਦੇ ਬਾਅਦ ਇਸ ਵੈੱਬਸਾਈਟ ਤੋਂ ਪਾਸਵਰਡ ਲੀਕ ਹੋ ਗਏ ਜਾਂ ਚੋਰੀ ਕੀਤੇ ਗਏ ਸਨ। ਆਪਣੇ ਖਾਤੇ ਨੂੰ ਸੁਰੱਖਿਅਤ ਕਰਨ ਲਈ ਆਪਣੇ ਪਾਸਵਰਡ ਨੂੰ ਬਦਲੋ।
about-logins-breach-alert-date = ਇਹ ਸੰਨ੍ਹ { DATETIME($date, day: "numeric", month: "long", year: "numeric") } ਨੂੰ ਲੱਗੀ ਸੀ
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } ਤੇ ਜਾਓ
about-logins-breach-alert-learn-more-link = ਹੋਰ ਜਾਣੋ

## Vulnerable Password notification

about-logins-vulnerable-alert-title = ਕਮਜ਼ੋਰ ਪਾਸਵਰਡ
about-logins-vulnerable-alert-text2 = ਇਹ ਪਾਸਵਰਡ ਨੂੰ ਹੋਰ ਖਾਤੇ ਲਈ ਵਰਤਿਆ ਗਿਆ ਹੈ, ਜਿਸ ਵਾਸਤੇ ਡਾਟਾ ਸੰਨ੍ਹ ਲੱਗੀ ਹੋਣ ਦੀ ਸੰਭਾਵਨਾ ਸੀ। ਉਹੀ ਪਾਸਵਰਡ ਵਰਤਣ ਨਾਲ ਤੁਹਾਡੇ ਸਾਰੇ ਖਾਤਿਆਂ ਨੂੰ ਖਤਰਾ ਹੋ ਸਕਦਾ ਹੈ। ਇਹ ਪਾਸਵਰਡ ਬਦਲੋ।
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } ਤੇ ਜਾਓ
about-logins-vulnerable-alert-learn-more-link = ਹੋਰ ਜਾਣੋ

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = ਉਸ ਵਰਤੋਂਕਾਰ-ਨਾਂ ਨਾਲ { $loginTitle } ਲਈ ਐਂਟਰੀ ਪਹਿਲਾਂ ਹੀ ਮੌਜੂਦ ਹੈ। <a data-l10n-name="duplicate-link">ਮੌਜੂਦਾ ਐਂਟਰੀ ਉਤੇ ਜਾਣਾ ਹੈ?</a>

# This is a generic error message.
about-logins-error-message-default = ਇਸ ਪਾਸਵਰਡ ਨੂੰ ਸੰਭਾਲਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਦੌਰਾਨ ਗਲਤੀ ਵਾਪਰੀ ਹੈ।


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = ਲਾਗਇਨ ਵਾਲੀ ਫਾਇਲ ਐਕਸਪੋਰਟ ਕਰੋ
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = ਐਕਸਪੋਰਟ ਕਰੋ
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV ਡੌਕੂਮੈਂਟ
       *[other] CSV ਫਾਇਲ
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = ਲਾਗਇਨਾਂ ਵਾਲੀ ਫਾਇਲ ਇੰਪੋਰਟ ਕਰੋ
about-logins-import-file-picker-import-button = ਇੰਪੋਰਟ ਕਰੋ
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV ਦਸਤਾਵੇਜ਼
       *[other] CSV ਫ਼ਾਈਲ
    }
