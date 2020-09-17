# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = ਜੇ ਤੁਸੀਂ ਟਰੈਕ ਨਹੀਂ ਕੀਤੇ ਜਾਣਾ ਚਾਹੁੰਦੇ ਹੋ ਤਾਂ ਵੈੱਬਸਾਈਟ ਨੂੰ “ਟਰੈਕ ਨਾ ਕਰੋ” ਸੰਕੇਤ ਭੇਜੋ
do-not-track-learn-more = ਹੋਰ ਸਿੱਖੋ
do-not-track-option-default-content-blocking-known =
    .label = ਸਿਰਫ਼ ਜਦੋਂ { -brand-short-name } ਨੂੰ ਜਾਣ-ਪਛਾਣੇ ਟਰੈਕਰਾਂ ਤੇ ਪਾਬੰਦੀ ਲਗਾਉਣ ਲਈ ਸੈੱਟ ਕੀਤਾ ਗਿਆ ਹੋਵੇ
do-not-track-option-always =
    .label = ਹਮੇਸ਼ਾ
pref-page-title =
    { PLATFORM() ->
        [windows] ਚੋਣਾਂ
       *[other] ਮੇਰੀ ਪਸੰਦ
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ 'ਚ ਲੱਭੋ
           *[other] ਮੇਰੀ ਪਸੰਦ 'ਚ ਲੱਭੋ
        }
managed-notice = ਤੁਹਾਡੇ ਬਰਾਊਜ਼ਰ ਦਾ ਬੰਦੋਬਸਤ ਤੁਹਾਡੀ ਸੰਸਥਾ ਵਲੋਂ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ।
pane-general-title = ਆਮ
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = ਘਰ
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = ਖੋਜ
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = ਪਰਦੇਦਾਰੀ ਤੇ ਸੁਰੱਖਿਆ
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name } ਤਜਰਬੇ
category-experimental =
    .tooltiptext = { -brand-short-name } ਤਜਰਬੇ
pane-experimental-subtitle = ਧਿਆਨ ਨਾਲ ਅੱਗੇ ਵਧੋ
pane-experimental-search-results-header = { -brand-short-name } ਤਜਰਬਾ: ਧਿਆਨ ਨਾਲ ਜਾਰੀ ਰੱਖੋ
pane-experimental-description = ਤਕਨੀਕੀ ਸੰਰਚਨਾ ਦੀਆਂ ਪਸੰਦਾਂ ਨੂੰ ਬਦਲਣ ਨਾਲ { -brand-short-name } ਦੀ ਕਾਰਗੁਜ਼ਾਰੀ ਜਾਂ ਸੁਰੱਖਿਆ ਉੱਤੇ ਅਸਰ ਪੈ ਸਕਦਾ ਹੈ।
help-button-label = { -brand-short-name } ਸਮਰਥਨ
addons-button-label = ਇਕਸਟੈਨਸ਼ਨਾਂ ਤੇ ਥੀਮ
focus-search =
    .key = f
close-button =
    .aria-label = ਬੰਦ ਕਰੋ

## Browser Restart Dialog

feature-enable-requires-restart = ਇਹ ਫੀਚਰ ਸਮਰੱਥ ਕਰਨ ਲਈ { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰਨਾ ਪਵੇਗਾ।
feature-disable-requires-restart = ਇਹ ਫੀਚਰ ਅਸਮਰੱਥ ਕਰਨ ਲਈ { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰਨਾ ਪਵੇਗਾ।
should-restart-title = { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰੋ
should-restart-ok = ਹੁਣੇ { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰੋ
cancel-no-restart-button = ਰੱਦ ਕਰੋ
restart-later = ਬਾਅਦ ‘ਚ ਮੁੜ-ਚਾਲੂ ਕਰਿਉ

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = <img data-l10n-name="icon"/> { $name } ਵਾਧਰਾ ਤੁਹਾਡੇ ਮੁੱਖ ਸਫ਼ੇ ਨੂੰ ਕਾਬੂ ਕਰ ਰਿਹਾ ਹੈ।
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = <img data-l10n-name="icon"/> { $name } ਇਕਸਟੈਨਸਨ ਤੁਹਾਡੇ ਨਵੀਂ ਟੈਬ ਸਫ਼ੇ ਨੂੰ ਕੰਟੋਰਲ ਕਰ ਰਹੀ ਹੈ।
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = ਇਕਸਟੈਨਸ਼ਨ <img data-l10n-name="icon"/> { $name } ਇਹ ਸੈਟਿੰਗ ਨੂੰ ਕੰਟਰੋਲ ਕਰ ਰਹੀ ਹੈ।
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = ਇਕਸਟੈਨਸ਼ਨ, <img data-l10n-name="icon"/> { $name } ਇਹ ਸੈਟਿੰਗ ਨੂੰ ਕੰਟਰੋਲ ਕਰ ਰਹੀ ਹੈ।
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = <img data-l10n-name="icon"/> { $name } ਇਕਸਟੈਨਸਨ ਨੇ ਤੁਹਾਡਾ ਮੂਲ ਖੋਜ ਇੰਜਣ ਤਹਿ ਕੀਤਾ ਹੈ।
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = ਇਕਟੈਨਸ਼ਨ <img data-l10n-name="icon"/> { $name } ਲਈ ਕਨਟੇਨਰ ਟੈਬਾਂ ਲਈ ਚਾਹੀਦੀ ਹੈ।
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = ਇਕਸਟੈਨਸ਼ਨ, <img data-l10n-name="icon"/> { $name } ਇਹ ਸੈਟਿੰਗ ਨੂੰ ਕੰਟਰੋਲ ਕਰ ਰਹੀ ਹੈ।
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = <img data-l10n-name="icon"/> { $name } ਇਕਸਟੈਸ਼ਨ { -brand-short-name } ਦੇ ਇੰਟਰਨੈੱਟ ਨਾਲ ਕਨੈਕਟ ਹੋਣ ਦੀ ਨਿਗਰਾਨੀ ਰੱਖਦੀ ਹੈ।
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = ਵਾਧਰੇ ਨੂੰ ਸਮਰੱਥ ਕਰਨ ਲਈ <img data-l10n-name="menu-icon"/> ਮੇਨੂ ਵਿੱਚ <img data-l10n-name="addons-icon"/> ਐਡ-ਆਨ ਉੱਤੇ ਜਾਓ।

## Preferences UI Search Results

search-results-header = ਖੋਜ ਨਤੀਜੇ
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ਅਫ਼ਸੋਸ! “<span data-l10n-name="query"></span>” ਲਈ ਚੋਣਾਂ ਵਿੱਚ ਕੋਈ ਨਤੀਜੇ ਨਹੀਂ ਹਨ।
       *[other] ਅਫ਼ਸੋਸ! “<span data-l10n-name="query"></span>” ਲਈ ਪਸੰਦਾਂ ਵਿੱਚ ਕੋਈ ਨਤੀਜੇ ਨਹੀਂ ਹਨ।
    }
search-results-help-link = ਮਦਦ ਚਾਹੀਦੀ ਹੈ? <a data-l10n-name="url">{ -brand-short-name } ਸਹਿਯੋਗ</a> ਵੇਖੋ

## General Section

startup-header = ਸ਼ੁਰੂਆਤ
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } ਤੇ ਫਾਇਰਫਾਕਸ ਨੂੰ ਇੱਕੋ ਸਮੇਂ ਚੱਲਣ ਦੀ ਇਜ਼ਾਜ਼ਤ ਦਿਉ
use-firefox-sync = ਟੋਟਕਾ: ਇਹ ਵੱਖਰੇ ਬਿਉਰੇ ਵਰਤਦੇ ਹਨ। ਉਹਨਾਂ ਵਿਚਾਲੇ ਡੇਟਾ ਸਾਂਝਾ ਕਰਨ ਲਈ { -sync-brand-short-name } ਵਰਤੋ।
get-started-not-logged-in = { -sync-brand-short-name } ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ…
get-started-configured = { -sync-brand-short-name } ਮੇਰੀ ਪਸੰਦ ਖੋਲ੍ਹੋ
always-check-default =
    .label = ਹਮੇਸ਼ਾ ਜਾਂਚ ਕਰੋ ਕਿ ਕੀ { -brand-short-name } ਤੁਹਾਡਾ ਮੂਲ ਬਰਾਊਜ਼ਰ ਹੈ
    .accesskey = w
is-default = { -brand-short-name } ਇਸ ਸਮੇਂ ਤੁਹਾਡਾ ਮੂਲ ਬਰਾਊਜ਼ਰ ਹੈ
is-not-default = { -brand-short-name } ਤੁਹਾਡਾ ਮੂਲ ਬਰਾਊਜ਼ਰ ਨਹੀਂ ਹੈ
set-as-my-default-browser =
    .label = …ਡਿਫਾਲਟ ਬਣਾਓ
    .accesskey = D
startup-restore-previous-session =
    .label = ਪਿਛਲਾ ਸ਼ੈਸ਼ਨ ਬਹਾਲ ਕਰੋ
    .accesskey = s
startup-restore-warn-on-quit =
    .label = ਜਦੋਂ ਬਰਾਊਜ਼ਰ ਨੂੰ ਬੰਦ ਕਰੋ ਤਾਂ ਸਾਵਧਾਨ ਕਰੋ
disable-extension =
    .label = ਇਕਸਟੈਨਸ਼ਨ ਨੂੰ ਅਸਮਰੱਥ ਕਰੋ
tabs-group-header = ਟੈਬਾਂ
ctrl-tab-recently-used-order =
    .label = ਤਾਜ਼ਾ ਵਰਤੋਂ ਦੇ ਕ੍ਰਮ ਵਿੱਚ ਟੈਬਾਂ ਵਿੱਚ ਗੇੜੇ ਲਈ Ctrl+Tab ਵਰਤੋ
    .accesskey = T
open-new-link-as-tabs =
    .label = ਲਿੰਕਾਂ ਨੂੰ ਨਵੀਆਂ ਵਿੰਡੋਆਂ ਦੀ ਬਜਾਏ ਟੈਬਾਂ ਵਿੱਚ ਖੋਲ੍ਹੋ
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = ਜਦੋਂ ਕਈ ਟੈਬਾਂ ਬੰਦ ਕਰਨੀਆਂ ਹੋਣ ਤਾਂ ਤੁਹਾਨੂੰ ਸਾਵਧਾਨ ਕਰਦਾ ਹੈ
    .accesskey = m
warn-on-open-many-tabs =
    .label = ਤੁਹਾਨੂੰ ਚੇਤਾਵਨੀ ਦਿਓ, ਜਦੋਂ ਕਈ ਟੈਬਾਂ ਖੋਲ੍ਹਣ ਨਾਲ { -brand-short-name } ਹੌਲੀ ਹੋ ਸਕਦਾ ਹੈ
    .accesskey = d
switch-links-to-new-tabs =
    .label = ਜਦੋਂ ਤੁਸੀਂ ਨਵੀਂ ਟੈਬ ਖੋਲ੍ਹਦੇ ਹੋ ਤਾਂ ਤੁਰੰਤ ਇਸ ਉੱਤੇ ਜਾਓ
    .accesskey = h
show-tabs-in-taskbar =
    .label = ਵਿੰਡੋ ਟਾਸਕ-ਪੱਟੀ ਵਿੱਚ ਟੈਬ ਝਲਕਾਂ ਨੂੰ ਵੇਖੋ
    .accesskey = k
browser-containers-enabled =
    .label = ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਸਮਰੱਥ ਕਰੋ
    .accesskey = n
browser-containers-learn-more = ਹੋਰ ਜਾਣੋ
browser-containers-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = i
containers-disable-alert-title = ਸਾਰੀਆਂ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰਨਾ ਹੈ?
containers-disable-alert-desc =
    { $tabCount ->
        [one] ਜੇ ਤੁਸੀਂ ਹੁਣ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਅਸਮਰੱਥ ਕਰਦੇ ਹੋ ਤਾਂ { $tabCount } ਕਨਟੇਨਰ ਟੈਬ ਨੂੰ ਬੰਦ ਕੀਤਾ ਜਾਵੇਗਾ। ਕੀ ਤੁਸੀਂ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?
       *[other] ਜੇ ਤੁਸੀਂ ਹੁਣ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਅਸਮਰੱਥ ਕਰਦੇ ਹੋ ਤਾਂ { $tabCount } ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕੀਤਾ ਜਾਵੇਗਾ। ਕੀ ਤੁਸੀਂ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } ਕਨਟੇਨਰ ਨੂੰ ਬੰਦ ਕਰੋ
       *[other] { $tabCount } ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰੋ
    }
containers-disable-alert-cancel-button = ਸਮਰੱਥ ਰੱਖੋ
containers-remove-alert-title = ਇਹ ਕਨਟੇਨਰ ਨੂੰ ਹਟਾਉਣਾ ਹੈ?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] ਜੇ ਤੁਸੀਂ ਹੁਣ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਹਟਾਉਂਦੇ ਹੋ ਤਾਂ { $count } ਕਨਟੇਨਰ ਟੈਬ ਨੂੰ ਬੰਦ ਕੀਤਾ ਜਾਵੇਗਾ। ਕੀ ਤੁਸੀਂ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਹਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?
       *[other] ਜੇ ਤੁਸੀਂ ਹੁਣ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਹਟਾਉਂਦੇ ਹੋ ਤਾਂ { $count } ਕਨਟੇਨਰਾਂ ਟੈਬ ਨੂੰ ਬੰਦ ਕੀਤਾ ਜਾਵੇਗਾ। ਕੀ ਤੁਸੀਂ ਕਨਟੇਨਰ ਟੈਬਾਂ ਨੂੰ ਹਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?
    }
containers-remove-ok-button = ਇਸ ਕਨਟੇਨਰ ਨੂੰ ਹਟਾਓ
containers-remove-cancel-button = ਇਸ ਕਨਟੇਨਰ ਨੂੰ ਨਾ ਹਟਾਓ

## General Section - Language & Appearance

language-and-appearance-header = ਬੋਲੀ ਅਤੇ ਦਿੱਖ
fonts-and-colors-header = ਫੌਂਟ ਤੇ ਰੰਗ
default-font = ਡਿਫਾਲਟ ਫੌਂਟ
    .accesskey = D
default-font-size = ਆਕਾਰ
    .accesskey = S
advanced-fonts =
    .label = …ਤਕਨੀਕੀ
    .accesskey = A
colors-settings =
    .label = …ਰੰਗ
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = ਜ਼ੂਮ
preferences-default-zoom = ਮੂਲ ਜ਼ੂਮ
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = ਸਿਰਫ਼ ਲਿਖਤ ਜ਼ੂਮ ਕਰੋ
    .accesskey = t
language-header = ਬੋਲੀ
choose-language-description = ਸਫ਼ੇ ਨੂੰ ਵੇਖਣ ਲਈ ਆਪਣੀ ਪਸੰਦੀਦਾ ਬੋਲੀ ਚੁਣੋ
choose-button =
    .label = …ਚੁਣੋ
    .accesskey = o
choose-browser-language-description = ਮੇਨੂ, ਸੁਨੇਹੇ ਅਤੇ { -brand-short-name } ਤੋਂ ਸੁਨੇਹੇ ਵੇਖਾਉਣ ਲਈ ਵਰਤਣ ਵਾਸਤੇ ਭਾਸ਼ਾ ਚੁਣੋ।
manage-browser-languages-button =
    .label = ...ਬਦਲ ਨਿਯਤ ਕਰੋ
    .accesskey = I
confirm-browser-language-change-description = ਇਹ ਸੈਟਿੰਗਾਂ ਲਾਗੂ ਕਰਨ ਲਈ { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰੋ
confirm-browser-language-change-button = ਲਾਗੂ ਕਰਕੇ ਮੁੜ ਚਾਲੂ ਕਰੋ
translate-web-pages =
    .label = ਵੈੱਬ ਸਮੱਗਰੀ ਦਾ ਉਲੱਥਾ ਕਰੋ
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ਉਲੱਥਾ ਕੀਤਾ <img data-l10n-name="logo"/>
translate-exceptions =
    .label = …ਛੋਟ
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = ਤਾਰੀਖਾਂ, ਸਮੇਂ, ਨੰਬਰਾਂ ਅਤੇ ਮਾਪ ਲਈ “{ $localeName }” ਵਾਸਤੇ ਆਪਣੇ ਓਪਰੇਟਿੰਗ ਸਿਸਟਮ ਨੂੰ ਵਰਤੋਂ।
check-user-spelling =
    .label = ਲਿਖਦੇ ਵੇਲੇ ਸ਼ਬਦ ਜੋੜਾਂ ਦੀ ਜਾਂਚ ਨਾਲ ਦੀ ਨਾਲ ਕਰਦੇ ਰਹੋ
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = ਫ਼ਾਈਲਾਂ ਅਤੇ ਐਪਲੀਕੇਸ਼ਨਾਂ
download-header = ਡਾਊਨਲੋਡ
download-save-to =
    .label = ਫ਼ਾਈਲਾਂ ਨੂੰ ਸੰਭਾਲੋ
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] …ਚੋਣ
           *[other] …ਝਲਕ
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = ਹਮੇਸ਼ਾ ਤੁਹਾਨੂੰ ਪੁੱਛੇ ਕਿ ਫਾਈਲਾਂ ਕਿੱਥੇ ਸੰਭਾਲਣੀਆਂ ਹਨ
    .accesskey = A
applications-header = ਐਪਲੀਕੇਸ਼ਨਾਂ
applications-description = ਚੁਣੋ ਕਿ ਬਰਾਊਜ਼ ਕਰਨ ਦੇ ਦੌਰਾਨ ਵੈੱਬ ਤੋਂ ਜਾਂ ਤੁਹਾਡੇ ਵਲੋਂ ਵਰਤੀਆਂ ਐਪਲੀਕੇਸ਼ਨਾਂ ਰਾਹੀਂ ਤੁਹਾਡੇ ਵਲੋਂ ਡਾਊਨਲੋਡ ਕੀਤੀਆਂ ਫ਼ਾਇਲਾਂ ਨਾਲ { -brand-short-name } ਕਿਵੇਂ ਨਿਪਟੇ।
applications-filter =
    .placeholder = ਫਾਈਲ ਕਿਸਮਾਂ ਜਾਂ ਐਪਲੀਕੇਸ਼ਨਾਂ ਲੱਭੋ
applications-type-column =
    .label = ਸਮੱਗਰੀ ਕਿਸਮ
    .accesskey = T
applications-action-column =
    .label = ਐਕਸ਼ਨ
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ਫਾਈਲ
applications-action-save =
    .label = ਫਾਈਲ ਨੂੰ ਸੰਭਾਲੋ
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } ਵਰਤੋਂ
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } ਵਰਤੋਂ (ਡਿਫਾਲਟ)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] macOS ਮੂਲ ਐਪਲੀਕੇਸ਼ਨ ਵਰਤੋਂ
            [windows] ਵਿੰਡੋਜ਼ ਮੂਲ ਐਪਲੀਕੇਸ਼ਨ ਵਰਤੋਂ
           *[other] ਸਿਸਟਮ ਮੂਲ ਐਪਲੀਕੇਸ਼ਨ ਵਰਤੋਂ
        }
applications-use-other =
    .label = …ਹੋਰ ਵਰਤੋਂ
applications-select-helper = ਮਦਦਗਾਰ ਐਪਲੀਕੇਸ਼ਨ ਚੁਣੋ
applications-manage-app =
    .label = …ਐਪਲੀਕੇਸ਼ਨ ਵੇਰਵਾ
applications-always-ask =
    .label = ਹਮੇਸ਼ਾ ਪੁੱਛੋ
applications-type-pdf = ਪੋਰਟੇਬਲ ਡੌਕੂਮੈਂਟ ਫਾਰਮੈਟ (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } ਵਰਤੋਂ ({ -brand-short-name } ਵਿੱਚ)
applications-open-inapp =
    .label = { -brand-short-name } ਵਿੱਚ ਖੋਲ੍ਹੋ

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = ਡਿਜ਼ਿਟਲ ਰਾਈਟਸ ਮੈਨਜੇਮੈਂਟ (DRM) ਸਮੱਗਰੀ
play-drm-content =
    .label = DRM-ਕੰਟਰੋਲ ਕੀਤੀ ਸਮੱਗਰੀ ਚਲਾਓ
    .accesskey = P
play-drm-content-learn-more = ਹੋਰ ਜਾਣੋ
update-application-title = { -brand-short-name } ਅੱਪਡੇਟ
update-application-description = ਵਧੀਆ ਕਾਰਗੁਜ਼ਾਰੀ, ਸਥਿਰਤਾ ਅਤੇ ਸੁਰੱਖਿਆ ਲਈ { -brand-short-name } ਨੂੰ ਅੱਪ-ਟੂ-ਡੇਟ ਕਰਕੇ ਰੱਖੋ।
update-application-version = ਵਰਜ਼ਨ { $version } <a data-l10n-name="learn-more">ਨਵਾਂ ਕੀ ਹੈ</a>
update-history =
    .label = …ਅੱਪਡੇਟ ਅਤੀਤ ਵੇਖੋ
    .accesskey = p
update-application-allow-description = { -brand-short-name } ਨੂੰ ਇਜਾਜ਼ਤ ਦਿਓ
update-application-auto =
    .label = ਅੱਪਡੇਟ ਆਪਣੇ-ਆਪ ਇੰਸਟਾਲ ਕਰੋ (ਸਿਫਾਰਸ਼ੀ)
    .accesskey = A
update-application-check-choose =
    .label = ਅੱਪਡੇਟ ਦੀ ਜਾਂਚ ਤਾਂ ਕਰੋ, ਪਰ ਉਹਨਾਂ ਨੂੰ ਇੰਸਟਾਲ ਕਰਨ ਲਈ ਤੁਹਾਨੂੰ ਚੁਣਨ ਦਿਓ
    .accesskey = C
update-application-manual =
    .label = ਅੱਪਡੇਟ ਲਈ ਕਦੇ ਵੀ ਜਾਂਚ ਨਾ ਕਰੋ (ਸਿਫਾਰਸ਼ੀ ਨਹੀਂ)
    .accesskey = N
update-application-warning-cross-user-setting = ਇਹ ਸੈਟਿੰਗ { -brand-short-name } ਦੀ ਇੰਸਟਾਲੇਸ਼ਨ ਦੀ ਵਰਤੋਂ ਕਰਨ ਵਾਲੇ ਸਾਰੇ ਵਿੰਡੋਜ਼ ਖਾਤਿਆਂ ਅਤੇ { -brand-short-name } ਪਰੋਫਾਈਲਾਂ ਉੱਤੇ ਲਾਗੂ ਹੋਵੇਗੀ।
update-application-use-service =
    .label = ਅੱਪਡੇਟ ਇੰਸਟਾਲ ਕਰਨ ਲਈ ਬੈਕਗਰਾਊਂਡ ਸਰਵਿਸ ਵਰਤੋਂ
    .accesskey = b
update-setting-write-failure-title = ਅਪਡੇਟ ਤਰਜੀਹਾਂ ਨੂੰ ਸੰਭਾਲਣ ਲਈ ਗਲਤੀ
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } ਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ ਅਤੇ ਉਸਨੇ ਇਸ ਤਬਦੀਲੀ ਨੂੰ ਸੁਰੱਖਿਅਤ ਨਹੀਂ ਕੀਤਾ। ਯਾਦ ਰੱਖੋ ਕਿ ਇਸ ਅਪਡੇਟ ਦੀ ਪਸੰਦ ਨੂੰ ਸੈੱਟ ਕਰਨ ਲਈ ਹੇਠਾਂ ਦਿੱਤੀ ਫਾਈਲ ਤੇ ਲਿਖਣ ਲਈ ਮਨਜ਼ੂਰੀ ਦੀ ਲੋੜ ਹੈ। ਤੁਸੀਂ ਜਾਂ ਸਿਸਟਮ ਪ੍ਰਬੰਧਕ ਇਸ ਫਾਈਲ ਲਈ ਵਰਤੋਂਕਾਰ ਗਰੁੱਪ ਨੂੰ ਪੂਰਾ ਅਧਿਕਾਰ ਦੇ ਕੇ ਗਲਤੀ ਨੂੰ ਹੱਲ ਕਰ ਸਕਦੇ ਹਨ।
    
    ਫਾਈਲ ਉੱਤੇ ਲਿਖਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ: { $path }
update-in-progress-title = ਅੱਪਡੇਟ ਜਾਰੀ ਹੈ
update-in-progress-message = ਕੀ ਤੁਸੀਂ { -brand-short-name } ਨੂੰ ਇਸ ਅੱਪਡੇਟ ਨਾਲ ਜਾਰੀ ਰੱਖਣ ਦੇਣਾ ਚਾਹੁੰਦੇ ਹੋ?
update-in-progress-ok-button = ਖਾਰਜ ਕਰੋ(&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = ਜਾਰੀ ਰੱਖੋ(&C)

## General Section - Performance

performance-title = ਕਾਰਗੁਜ਼ਾਰੀ
performance-use-recommended-settings-checkbox =
    .label = ਸਿਫਾਰਸ਼ੀ ਕਾਰਗੁਜਾਰੀ ਸੈਟਿੰਗਾਂ ਨੂੰ ਵਰਤੋਂ
    .accesskey = U
performance-use-recommended-settings-desc = ਇਹ ਸੈਟਿੰਗਾਂ ਨੂੰ ਤੁਹਾਡੇ ਕੰਪਿਊਟਰ ਦੇ ਹਾਰਡਵੇਅਰ ਅਤੇ ਓਪਰੇਟਿੰਗ ਸਿਸਤਮ ਦੇ ਮੁਤਾਬਕ ਬਣਾਇਆ ਗਿਆ ਹੈ।
performance-settings-learn-more = ਹੋਰ ਜਾਣੋ
performance-allow-hw-accel =
    .label = ਜਦੋਂ ਵੀ ਉਪਲੱਬਧ ਹੋਵੇ ਹਾਰਡਵੇਅਰ ਐਕਸਰਲੇਸ਼ਨ ਵਰਤੋਂ
    .accesskey = h
performance-limit-content-process-option = ਸਮੱਗਰੀ ਕਾਰਵਾਈ ਹੱਦ
    .accesskey = L
performance-limit-content-process-enabled-desc = ਵੱਖ-ਵੱਖ ਟੈਬਾਂ ਵਰਤਣ ਦੇ ਦੌਰਾਨ ਵਧੀਕ ਸਮੱਗਰੀ ਕਾਰਵਾਈ ਨਾਲ ਕਾਰਗੁਜ਼ਾਰੀ ਸੁਧਰ ਸਕਦੀ ਹੈ, ਪਰ ਇਸ ਨਾਲ ਵੱਧ ਮੈਮੋਰੀ ਵੀ ਵਰਤੀ ਜਾਵੇਗੀ।
performance-limit-content-process-blocked-desc = ਸਮੱਗਰੀ ਪਰੋਸੈਸਾਂ ਦੀ ਸੰਖਿਆ ਨੂੰ ਬਦਲਣਾ ਮਲਟੀ-ਪਰੋਸੈਸ { -brand-short-name } ਨਾਲ ਹੀ ਸੰਭਵ ਹੈ। <a data-l10n-name="learn-more">ਸਿੱਖੋ ਕਿ ਕਿਵੇਂ ਪਤਾ ਕਰੀਏ ਕਿ ਮਲਟੀ-ਪਰੋਸੈਸ ਸਮਰੱਥ ਹੈ</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (ਡਿਫਾਲਟ)

## General Section - Browsing

browsing-title = ਬਰਾਊਜ਼ਿੰਗ
browsing-use-autoscroll =
    .label = ਆਟੋ-ਸਕਰੋਲਿੰਗ ਨੂੰ ਵਰਤੋਂ
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = ਸਮੂਥ ਸਕਰੋਲਿੰਗ ਨੂੰ ਵਰਤੋਂ
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = ਜਦੋਂ ਲੋੜ ਹੋਵੇ ਤਾਂ ਟੱਚ ਕੀਬੋਰਡ ਨੂੰ ਵੇਖਾਓ
    .accesskey = k
browsing-use-cursor-navigation =
    .label = ਸਫ਼ੇ ਵਿੱਚ ਨੇਵੀਗੇਸ਼ਨ ਦੌਰਾਨ ਹਮੇਸ਼ਾਂ ਕਰਸਰ ਸਵਿੱਚਾਂ ਵੇਖੋ
    .accesskey = c
browsing-search-on-start-typing =
    .label = ਜਿਵੇਂ ਤੁਸੀਂ ਲਿਖਣਾ ਸ਼ੁਰੂ ਕਰਦੇ ਹੋ ਤਾਂ ਨਾਲ ਨਾਲ ਖੋਜੋ
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = ਤਸਵੀਰ-ਚ-ਤਸਵੀਰ ਵਿਡੀਓ ਕੰਟਰੋਲ ਸਮਰੱਲ ਕਰੋ
    .accesskey = E
browsing-picture-in-picture-learn-more = ਹੋਰ ਜਾਣੋ
browsing-cfr-recommendations =
    .label = ਬਰਾਊਜ਼ ਕਰਨ ਲਈ ਸਿਫਾਰਸ਼ੀ ਇਕਟੈਨਸ਼ਨਾਂ
    .accesskey = R
browsing-cfr-features =
    .label = ਬਰਾਊਜ਼ ਕਰਨ ਦੌਰਾਨ ਤੁਹਾਡੇ ਲਈ ਸਿਫਾਰਸ਼ੀ ਫੀਚਰ
    .accesskey = f
browsing-cfr-recommendations-learn-more = ਹੋਰ ਜਾਣੋ

## General Section - Proxy

network-settings-title = ਨੈੱਟਵਰਕ ਸੈਟਿੰਗਾਂ
network-proxy-connection-description = ਸੰਰਚਨਾ ਕਰੋ ਕਿ { -brand-short-name } ਇੰਟਰਨੈੱਟ ਨਾਲ ਕਿਵੇਂ ਕਨੈਕਟ ਹੋਵੇ।
network-proxy-connection-learn-more = ਹੋਰ ਜਾਣੋ
network-proxy-connection-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = e

## Home Section

home-new-windows-tabs-header = ਨਵੀਆਂ ਵਿੰਡੋਆਂ ਅਤੇ ਟੈਬਾਂ
home-new-windows-tabs-description2 = ਚੁਣੋ ਕਿ ਤੁਸੀਂ ਕੀ ਵੇਖਣਾ ਚਾਹੁੰਦੇ ਹੋ, ਜਦੋਂ ਤੁਸੀਂ ਆਪਣੇ ਮੁੱਖ ਸਫ਼ੇ, ਨਵੀਆਂ ਵਿੰਡੋਆਂ ਅਤੇ ਨਵੀਆਂ ਟੈਬਾਂ ਖੋਲ੍ਹਦੇ ਹੋ।

## Home Section - Home Page Customization

home-homepage-mode-label = ਮੁੱਖ-ਸਫ਼ਾ ਅਤੇ ਨਵੀਆਂ ਵਿੰਡੋਆਂ
home-newtabs-mode-label = ਨਵੀਆਂ ਟੈਬਾਂ
home-restore-defaults =
    .label = ਮੂਲ ਬਹਾਲ ਕਰੋ
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = ਫਾਇਰਫਾਕਸ ਮੁੱਖ ਸਫ਼ਾ (ਮੂਲ)
home-mode-choice-custom =
    .label = …ਚੁਣਿੰਦਾ URL
home-mode-choice-blank =
    .label = ਖ਼ਾਲੀ ਸਫ਼ਾ
home-homepage-custom-url =
    .placeholder = …URL ਨੂੰ ਚੇਪੋ
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] ਮੌਜੂਦਾ ਸਫ਼ੇ ਨੂੰ ਵਰਤੋ
           *[other] ਮੌਜੂਦਾ ਸਫ਼ਿਆਂ ਨੂੰ ਵਰਤੋ
        }
    .accesskey = C
choose-bookmark =
    .label = …ਬੁੱਕਮਾਰਕ ਵਰਤੋ
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = ਫਾਇਰਫਾਕਸ ਮੁੱਖ ਪੰਨਾ
home-prefs-content-description = ਉਹ ਸਮੱਗਰੀ ਚੁਣੋ ਜੋ ਤੁਸੀਂ ਆਪਣੇ ਫਾਇਰਫਾਕਸ ਮੁੱਖ ਪੰਨੇ 'ਤੇ ਚਾਹੁੰਦੇ ਹੋ।
home-prefs-search-header =
    .label = ਵੈੱਬ ਖੋਜ
home-prefs-topsites-header =
    .label = ਸਿਖਰਲੀਆਂ ਸਾਈਟਾਂ
home-prefs-topsites-description = ਤੁਹਾਡੇ ਵੱਲੋਂ ਸਭ ਤੋਂ ਵੱਧ ਵੇਖੀਆਂ ਸਾਈਟਾਂ

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } ਵਲੋਂ ਸਿਫਾਰਸ਼ੀ
home-prefs-recommended-by-description-update = { $provider } ਦੀ ਮੇਹਰ ਸਕਦਾ ਵੈੱਬ ਭਰ ਤੋਂ ਖ਼ਾਸ ਸਮੱਗਰੀ

##

home-prefs-recommended-by-learn-more = ਇਹ ਕਿਵੇਂ ਕੰਮ ਕਰਦੀ ਹੈ
home-prefs-recommended-by-option-sponsored-stories =
    .label = ਸਪਾਂਸਰ ਕੀਤੀਆਂ ਕਹਾਣੀਆਂ
home-prefs-highlights-header =
    .label = ਹਾਈਲਾਈਟ
home-prefs-highlights-description = ਉਹਨਾਂ ਸਾਈਟਾਂ ਦੀ ਚੋਣ ਕਰੋ ਜੋ ਤੁਸੀਂ ਸੁਰੱਖਿਅਤ ਜਾਂ ਵਿਜ਼ਿਟ ਕੀਤੀ ਹੈ
home-prefs-highlights-option-visited-pages =
    .label = ਵੇਖੇ ਗਏ ਸਫੇ
home-prefs-highlights-options-bookmarks =
    .label = ਬੁੱਕਮਾਰਕ
home-prefs-highlights-option-most-recent-download =
    .label = ਸਭ ਤੋਂ ਤਾਜ਼ਾ ਕੀਤੇ ਡਾਊਨਲੋਡ
home-prefs-highlights-option-saved-to-pocket =
    .label = ਪੰਨਿਆਂ ਨੂੰ { -pocket-brand-name } ਵਿੱਚ ਸੁਰੱਖਿਅਤ ਕੀਤਾ ਗਿਆ ਹੈ
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = ਛੋਟੇ ਟੋਟੇ
home-prefs-snippets-description = { -vendor-short-name } ਅਤੇ { -brand-product-name } ਤੋਂ ਅੱਪਡੇਟ
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ਕਤਾਰ
           *[other] { $num } ਕਤਾਰਾਂ
        }

## Search Section

search-bar-header = ਖੋਜ ਪੱਟੀ
search-bar-hidden =
    .label = ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਨੂੰ ਖੋਜ ਅਤੇ ਨੇਵੀਗੇਸ਼ਨ ਲਈ ਵਰਤੋਂ
search-bar-shown =
    .label = ਸੰਦ-ਪੱਟੀ 'ਚ ਖੋਜ ਪੱਟੀ ਜੋੜੋ
search-engine-default-header = ਮੂਲ ਖੋਜ ਇੰਜਣ
search-engine-default-desc-2 = ਇਹ ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਅਤੇ ਖੋਜ ਪੱਟੀ ਵਿੱਚ ਤੁਹਾਡਾ ਮੂਲ ਖੋਜ ਇੰਜਣ ਹੈ। ਤੁਸੀਂ ਇਸ ਨੂੰ ਕਿਸੇ ਵੀ ਸਮੇਂ ਬਦਲ ਸਕਦੇ ਹੋ।
search-engine-default-private-desc-2 = ਸਿਰਫ਼ ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਲਈ ਵੱਖਰਾ ਮੂਲ ਖੋਜ ਇੰਜਣ ਚੁਣੋ
search-separate-default-engine =
    .label = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਵਿੱੱਚ ਇਹ ਖੋਜ ਇੰਜਣ ਵਰਤੋਂ
    .accesskey = U
search-suggestions-header = ਖੋਜ ਸੁਝਾਅ
search-suggestions-desc = ਖੋਜ ਇੰਜਣ ਤੋਂ ਸੁਝਾਅ ਕਿਵੇਂ ਦੇਣ, ਉਸ ਦੀ ਚੋਣ ਕਰੋ।
search-suggestions-option =
    .label = ਖੋਜ ਸੁਝਾਅ ਦਿੰਦਾ ਹੈ
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਨਤੀਜਿਆਂ 'ਚ ਖੋਜ ਸੁਝਾਅ ਵੇਖਾਓ
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਨਤੀਜਿਆਂ ਵਿੱਚ ਬਰਾਊਜ਼ ਕਰਨ ਦੇ ਅਤੀਤ ਤੋਂ ਪਹਿਲਾਂ ਹੀ ਖੋਜ ਸੁਝਾਅ ਵੇਖਾਓ
search-show-suggestions-private-windows =
    .label = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਵਿੱਚ ਖੋਜ ਸੁਝਾਅ ਵੇਖਾਓ
suggestions-addressbar-settings-generic = ਹੋਰ ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਸੁਝਾਆਵਾਂ ਲਈ ਪਸੰਦਾਂ ਨੂੰ ਬਦਲੋ
search-suggestions-cant-show = ਟਿਕਾਣਾ ਖੋਜ ਨਤੀਜਿਆਂ ਵਿੱਚ ਖੋਜ ਸੁਝਾਅ ਨਹੀਂ ਵੇਖਾਏ ਜਾਣਗੇ, ਕਿਉਂਕਿ ਤੁਸੀਂ { -brand-short-name } ਨੂੰ ਕਦੇ ਵੀ ਅਤੀਤ ਯਾਦ ਨਾ ਰੱਖਣ ਲਈ ਸੰਰਚਿਤ ਕੀਤਾ ਹੈ।
search-one-click-header = ਇੱਕ-ਕਲਿੱਕ ਖੋਜ ਇੰਜਣ
search-one-click-desc = ਬਦਲਵੇਂ ਖੋਜ ਇੰਜਣਾਂ ਨੂੰ ਚੁਣੋ, ਜੋ ਕਿ ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਅਤੇ ਖੋਜ ਪੱਟੀ 'ਚ ਦਿਖਾਈ ਦਿੰਦੇ ਹਨ, ਜਦੋਂ ਕਿ ਤੁਸੀਂ ਕੋਈ ਸ਼ਬਦ ਲਿਖਦੇ ਹੋ।
search-choose-engine-column =
    .label = ਖੋਜ ਇੰਜਣ
search-choose-keyword-column =
    .label = ਸ਼ਬਦ
search-restore-default =
    .label = ਮੂਲ ਖੋਜ ਇੰਜਣ ਨੂੰ ਮੁੜ-ਸਟੋਰ ਕਰੋ
    .accesskey = d
search-remove-engine =
    .label = ਹਟਾਓ
    .accesskey = r
search-find-more-link = ਹੋਰ ਖੋਜ ਇੰਜਣ ਲੱਭੋ
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = ਡੁਪਲੀਕੇਟ ਸ਼ਬਦ
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = ਤੁਸੀਂ ਸ਼ਬਦ ਨੂੰ ਚੁਣਿਆ ਹੈ, ਜੋ ਕਿ ਇਸ ਸਮੇਂ "{ $name }" ਵਰਤੋਂ ਵਰਤਿਆ ਜਾ ਰਿਹਾ ਹੈ। ਹੋਰ ਨੂੰ ਚੁਣੋ ਜੀ।
search-keyword-warning-bookmark = ਤੁਸੀਂ ਸ਼ਬਦ ਨੂੰ ਚੁਣਿਆ ਹੈ, ਜੋ ਕਿ ਇਸ ਸਮੇਂ ਬੁੱਕਮਾਰਕ ਵਰਤੋਂ ਲਈ ਵਰਤਿਆ ਜਾ ਰਿਹਾ ਹੈ। ਹੋਰ ਨੂੰ ਚੁਣੋ ਜੀ।

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ ਤੇ ਵਾਪਸ ਜਾਓ
           *[other] ਮੇਰੀ ਪਸੰਦ ਤੇ ਵਾਪਸ ਜਾਓ
        }
containers-header = ਕਨਟਰੇਨਰ ਟੈਬਾਂ
containers-add-button =
    .label = ਨਵਾਂ ਕਨਟੇਨਰ ਜੋੜੋ
    .accesskey = A
containers-new-tab-check =
    .label = ਹਰੇਕ ਨਵੀਂ ਟੈਬ ਲਈ ਕਨਟੇਨਰ ਚੁਣੋ
    .accesskey = S
containers-preferences-button =
    .label = ਤਰਜੀਹਾਂ
containers-remove-button =
    .label = ਹਟਾਓ

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = ਆਪਣੇ ਵੈੱਬ ਨੂੰ ਆਪਣੇ ਨਾਲ ਲੈ ਜਾਓ
sync-signedout-description = ਆਪਣੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ਉੱਤੇ ਆਪਣੇ ਬੁੱਕਮਾਰਕਾਂ, ਅਤੀਤ, ਟੈਬਾਂ, ਪਾਸਵਰਡਾਂ, ਐਡ-ਆਨ ਅਤੇ ਪਸੰਦਾਂ ਨੂੰ ਸੈਕਰੋਨਾਈਜ਼ ਕਰੋ।
sync-signedout-account-signin2 =
    .label = { -sync-brand-short-name } ਵਿੱਚ ਸਾਇਨ ਇਨ ਕਰੋ…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = ਆਪਣੇ ਮੋਬਾਈਲ ਡਿਵਾਈਸ ਨਾਲ ਸਿੰਕ ਕਰਨ ਲਈ <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">ਐਂਡਰਾਈਡ</a> ਜਾਂ <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> ਲਈ ਫਾਇਰਫਾਕਸ ਨੂੰ ਡਾਊਨਲੋਡ ਕਰੋ।

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = ਬਿਉਰਾ ਤਸਵੀਰ ਨੂੰ ਬਦਲੋ
sync-sign-out =
    .label = ਸਾਈਨ ਆਉਟ…
    .accesskey = g
sync-manage-account = ਖਾਤੇ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .accesskey = o
sync-signedin-unverified = { $email } ਜਾਂਚਿਆ ਨਹੀਂ ਹੈ।
sync-signedin-login-failure = ਮੁੜ-ਕੁਨੈਕਟ ਕਰਨ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ ਜੀ { $email }
sync-resend-verification =
    .label = ਤਸਦੀਕ ਮੁੜ-ਭੇਜੋ
    .accesskey = d
sync-remove-account =
    .label = ਖਾਤੇ ਨੂੰ ਹਟਾਓ
    .accesskey = R
sync-sign-in =
    .label = ਸਾਇਨ ਇਨ
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = ਸਿੰਕ ਕਰਨਾ: ਚਾਲੂ ਹੈ
prefs-syncing-off = ਸਿੰਕ ਕਰਨਾ: ਬੰਦ ਹੈ
prefs-sync-setup =
    .label = { -sync-brand-short-name } ਸੈਟਅੱਪ ਕਰੋ…
    .accesskey = S
prefs-sync-offer-setup-label = ਆਪਣੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ਉੱਤੇ ਆਪਣੇ ਬੁੱਕਮਾਰਕਾਂ, ਅਤੀਤ, ਟੈਬਾਂ, ਪਾਸਵਰਡਾਂ, ਐਡ-ਆਨ ਅਤੇ ਪਸੰਦਾਂ ਨੂੰ ਸਿੰਕਰੋਨਾਈਜ਼ ਕਰੋ।
prefs-sync-now =
    .labelnotsyncing = ਹੁਣੇ ਸਿੰਕ ਕਰੋ
    .accesskeynotsyncing = N
    .labelsyncing = ਸਿੰਕ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ…

## The list of things currently syncing.

sync-currently-syncing-heading = ਤੁਸੀਂ ਇਸ ਵੇਲੇ ਇਹ ਚੀਜ਼ਾਂ ਸਿੰਕ ਕਰ ਰਹੇ ਹੋ:
sync-currently-syncing-bookmarks = ਬੁੱਕਮਾਰਕ
sync-currently-syncing-history = ਅਤੀਤ
sync-currently-syncing-tabs = ਟੈਬਾਂ ਖੋਲ੍ਹੋ
sync-currently-syncing-logins-passwords = ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ
sync-currently-syncing-addresses = ਸਿਰਨਾਵੇਂ
sync-currently-syncing-creditcards = ਕਰੈਡਿਟ ਕਾਰਡ
sync-currently-syncing-addons = ਐਡ-ਆਨ
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] ਚੋਣਾਂ
       *[other] ਮੇਰੀ ਪਸੰਦ
    }
sync-change-options =
    .label = ਬਦਲੋ…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = ਚੁਣੋ ਕਿ ਕੀ ਸਿੰਕ ਕਰਨਾ ਹੈ
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = …ਡਿਸਕਨੈਕਟ ਕਰੋ
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = ਬੁੱਕਮਾਰਕ
    .accesskey = m
sync-engine-history =
    .label = ਅਤੀਤ
    .accesskey = r
sync-engine-tabs =
    .label = ਟੈਬਾਂ ਖੋਲ੍ਹੋ
    .tooltiptext = ਸਾਰੇ ਸਿੰਕ ਕੀਤੇ ਡਿਵਾਈਸਾਂ ਉੱਪਰ ਕੀ ਕੀ ਖੁੱਲ੍ਹਿਆ ਹੈ, ਉਸਦੀ ਸੂਚੀ
    .accesskey = T
sync-engine-logins-passwords =
    .label = ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ
    .tooltiptext = ਵਰਤੋਂਕਾਰ-ਨਾਂ ਅਤੇ ਪਾਸਵਰਡ, ਜੋ ਕਿ ਤੁਸੀਂ ਸੰਭਾਲੇ ਹਨ
    .accesskey = L
sync-engine-addresses =
    .label = ਸਿਰਨਾਵੇਂ
    .tooltiptext = ਤੁਹਾਡੇ ਵਲੋਂ ਸੰਭਾਲਿਆ ਡਾਕ ਸਿਰਨਾਵੇਂ (ਕੇਵਲ ਡੈਸਕਟਾਪ ਹੀ)
    .accesskey = e
sync-engine-creditcards =
    .label = ਕਰੈਡਿਟ ਕਾਰਡ
    .tooltiptext = ਨਵਾਂ, ਨੰਬਰ ਅਤੇ ਮਿਆਦ ਪੁੱਗਣ ਦੀਆਂ ਮਿਤੀਆਂ (ਕੇਵਲ ਡੈਸਕਟਾਪ)
    .accesskey = C
sync-engine-addons =
    .label = ਐਡ-ਆਨ
    .tooltiptext = ਫ਼ਾਇਰਫਾਕਸ ਡੈਸਕਟਾਪ ਲਈ ਇਕਸਟੈਨਸ਼ਨਾਂ ਅਤੇ ਥੀਮ
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ
           *[other] ਮੇਰੀਆਂ ਪਸੰਦਾਂ
        }
    .tooltiptext = ਤੁਹਾਡੇ ਵਲੋਂ ਬਦਲੀਆਂ ਗਈਆਂ ਆਮ, ਪਰਦੇਦਾਰੀ ਅਤੇ ਸੁਰੱਖਿਆ ਸੈਟਿੰਗਾਂ
    .accesskey = S

## The device name controls.

sync-device-name-header = ਡਿਵਾਈਸ ਨਾਂ
sync-device-name-change =
    .label = …ਡਿਵਾਈਸ ਦਾ ਨਾਂ ਚੁਣੋ
    .accesskey = h
sync-device-name-cancel =
    .label = ਰੱਦ ਕਰੋ
    .accesskey = n
sync-device-name-save =
    .label = ਸੰਭਾਲੋ
    .accesskey = v
sync-connect-another-device = ਹੋਰ ਡਿਵਾਈਸ ਨਾਲ ਕਨੈਕਟ ਕਰੋ

## Privacy Section

privacy-header = ਬਰਾਊਜ਼ਰ ਪਰਦੇਦਾਰੀ

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = ਲਾਗਇਨ ਤੇ ਪਾਸਵਰਡ
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = ਵੈੱਬਸਾਈਟਾਂ ਲਈ ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ ਸੰਭਾਲਣ ਲਈ ਪੁੱਛੋ
    .accesskey = r
forms-exceptions =
    .label = …ਛੋਟਾਂ
    .accesskey = x
forms-generate-passwords =
    .label = ਮਜ਼ਬੂਤ ਪਾਸਵਰਡ ਸੁਝਾਓ ਅਤੇ ਬਣਾਓ
    .accesskey = u
forms-breach-alerts =
    .label = ਸੰਨ੍ਹ ਲੱਗੀਆਂ ਵੈੱਬਸਾਈਟਾਂ ਲਈ ਪਾਸਵਰਡਾਂ ਬਾਰੇ ਚੇਤਾਵਨੀ ਵੇਖਾਓ
    .accesskey = b
forms-breach-alerts-learn-more-link = ਹੋਰ ਜਾਣੋ
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = ਆਪਣੇ-ਆਪ ਭਰਨ ਲਈ ਲਾਗਇਨ ਅਤੇ ਪਾਸਵਰਡ
    .accesskey = i
forms-saved-logins =
    .label = …ਸੰਭਾਲੇ ਹੋਏ ਲਾਗਇਨ
    .accesskey = L
forms-master-pw-use =
    .label = ਮਾਸਟਰ ਪਾਸਵਰਡ ਨੂੰ ਵਰਤੋਂ
    .accesskey = U
forms-primary-pw-use =
    .label = ਮੁੱਖ ਪਾਸਵਰਡ ਵਰਤੋਂ
    .accesskey = U
forms-primary-pw-learn-more-link = ਹੋਰ ਜਾਣੋ
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = …ਮਾਸਟਰ ਪਾਸਵਰਡ ਨੂੰ ਵਰਤੋਂ
    .accesskey = M
forms-master-pw-fips-title = ਇਸ ਸਮੇਂ ਤੁਸੀਂ FIPS ਮੋਡ ਵਿੱਚ ਹੋ। FIPS ਨੂੰ ਇੱਕ ਨਾ-ਖਾਲੀ ਮਾਸਟਰ ਪਾਸਵਰਡ ਲੋੜੀਦਾ ਹੈ
forms-primary-pw-change =
    .label = …ਮੁੱਖ ਪਾਸਵਰਡ ਬਦਲੋ
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = ਪਹਿਲਾਂ ਮਾਸਟਰ ਪਾਸਵਰਡ ਵਜੋਂ ਜਾਣਿਆ ਜਾਂਦਾ ਹੈ
forms-primary-pw-fips-title = ਤੁਸੀਂ ਇਸ ਵੇਲੇ FIPS ਮੋਡ ਵਿੱਚ ਹੋ। FIPS ਨੂੰ ਨਾ ਖਾਲੀ ਪਾਸਵਰਡ ਚਾਹੀਦਾ ਹੈ।
forms-master-pw-fips-desc = ਪਾਸਵਰਡ ਨੂੰ ਬਦਲਣਾ ਫੇਲ੍ਹ ਹੋਇਆ

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = ਮਾਸਟਰ ਪਾਸਵਰਡ ਬਣਾਉਣ ਲਈ ਆਪਣੀਆਂ Windows ਲਾਗਇਨ ਪਾਸਵਰਡ ਦਿਓ। ਇਸ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = ਮਾਸਟਰ ਪਾਸਵਰਡ ਬਣਾਓ
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = ਮੁੱਖ ਪਾਸਵਰਡ ਬਣਾਉਣ ਲਈ ਆਪਣੀਆਂ Windows ਲਾਗਇਨ ਪਾਸਵਰਡ ਦਿਓ। ਇਸ ਤੁਹਾਡੇ ਖਾਤਿਆਂ ਦੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ।
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = ਮੁੱਖ ਪਾਸਵਰਡ ਬਣਾਓ
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = ਅਤੀਤ
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = w
history-remember-option-all =
    .label = ਅਤੀਤ ਯਾਦ ਰੱਖੋ
history-remember-option-never =
    .label = ਅਤੀਤ ਕਦੇ ਵੀ ਯਾਦ ਨਾ ਰੱਖੋ
history-remember-option-custom =
    .label = ਅਤੀਤ ਲਈ ਚੁਣਿੰਦਾ ਸੈਟਿੰਗ ਵਰਤੋਂ
history-remember-description = { -brand-short-name } ਤੁਹਾਡੇ ਬਰਾਊਜ਼ ਕਰਨ, ਡਾਊਨਲੋਡ, ਫਾਰਮਾਂ ਅਤੇ ਖੋਜ ਅਤੀਤ ਨੂੰ ਯਾਦ ਰੱਖੇਗਾ।
history-dontremember-description = { -brand-short-name } ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ਿੰਗ ਵਾਲੀਆਂ ਸੈਟਿੰਗਾਂ ਵਰਤੇਗਾ ਅਤੇ ਤੁਹਾਡੇ ਵਲੋਂ ਵੈੱਬ ਬਰਾਊਜ਼ ਕਰਨ ਦਾ ਕੋਈ ਵੀ ਅਤੀਤ ਯਾਦ ਨਹੀਂ ਰੱਖੇਗਾ।
history-private-browsing-permanent =
    .label = ਹਮੇਸ਼ਾ ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ਿੰਗ ਮੋਡ ਹੀ ਵਰਤੋਂ
    .accesskey = p
history-remember-browser-option =
    .label = ਬਰਾਊਜ਼ ਕਰਨਾ ਅਤੇ ਡਾਊਨਲੋਡ ਅਤੀਤ ਨੂੰ ਯਾਦ ਰੱਖੋ
    .accesskey = b
history-remember-search-option =
    .label = ਖੋਜ ਅਤੇ ਫਾਰਮ ਅਤੀਤ ਨੂੰ ਯਾਦ ਰੱਖੋ
    .accesskey = f
history-clear-on-close-option =
    .label = ਜਦੋਂ { -brand-short-name } ਬੰਦ ਹੋਵੇ ਤਾਂ ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .accesskey = w
history-clear-on-close-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
history-clear-button =
    .label = …ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡਾਟਾ
sitedata-total-size-calculating = ਸਾਈਟ ਡਾਟੇ ਅਤੇ ਕੈਸ਼ ਆਕਾਰ ਦੀ ਗਿਣਤੀ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = ਤੁਹਾਡੇ ਸੰਭਾਲੇ ਹੋਏ ਕੂਕੀਜ਼, ਸਾਈਟ ਡਾਟਾ ਅਤੇ ਕੈਸ਼ ਇਸ ਵੇਲੇ { $value } { $unit } ਡਿਸਕ ਥਾਂ ਦੀ ਵਰਤੋਂ ਕਰ ਰਹੀ ਹੈ।
sitedata-learn-more = ਹੋਰ ਜਾਣੋ
sitedata-delete-on-close =
    .label = ਜਦੋਂ { -brand-short-name } ਬੰਦ ਹੋਵੇ ਤਾਂ ਕੂਕੀਜ਼ ਤੇ ਸਾਈਟ ਡਾਟੇ ਨੂੰ ਹਟਾਓ
    .accesskey = c
sitedata-delete-on-close-private-browsing = ਪੱਕੇ ਤੌਰ ਉੱਤੇ ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ਿੰਗ ਢੰਗ ਵਿੱਚ, { -brand-short-name } ਨੂੰ ਬੰਦ ਕਰਨ ਉੱਤੇ ਕੂਕੀਜ਼ ਤੇ ਸਾਈਟ ਡਾਟੇ ਨੂੰ ਹਮੇਸ਼ਾਂ ਹੀ ਸਾਫ਼ ਕੀਤਾ ਜਾਵੇਗਾ।
sitedata-allow-cookies-option =
    .label = ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡਾਟੇ ਨੂੰ ਮਨਜ਼ੂਰ ਕਰੋ
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = ਕੂਕੀਜ਼ ਤੇ ਸਾਈਟ ਡਾਟੇ ਤੇ ਪਾਬੰਦੀ ਲਗਾਓ
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = ਪਾਬੰਦੀ ਲਗਾਈ ਕਿਸਮ
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕਰ
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = ਅੰਤਰ-ਸਾਈਟ ਅਤੇ ਸਾਮਿਜਕ ਮੀਡਿਆ ਟਰੈਕਰ
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = ਅੰਤਰ-ਸਾਈਟ ਤੇ ਸਮਾਜਿਕ ਮੀਡੀਆ ਟਰੈਕਰ ਅਤੇ ਬਾਕੀ ਕੂਕੀਜ਼ ਵੱਖ ਕਰੋ
sitedata-option-block-unvisited =
    .label = ਅਣਪਛਾਤੀਆਂ ਵੈਬਸਾਈਟਾਂ ਤੋਂ ਕੂਕੀਜ਼
sitedata-option-block-all-third-party =
    .label = ਸਾਰੇ ਤੀਜੀ-ਧਿਰ ਕੂਕੀਜ਼ (ਸ਼ਾਇਦ ਵੈੱਬਸਾਈਟਾਂ ਠੀਕ ਤਰ੍ਹਾਂ ਕੰਮ ਨਾ ਕਰਨ)
sitedata-option-block-all =
    .label = ਸਾਰੇ ਕੂਕੀਜ਼ (ਵੈੱਬਸਾਈਟਾਂ ਦੇ ਕੰਮ ਨਾ ਕਰਨ ਦਾ ਕਾਰਨ ਹੋਵੇਗਾ)
sitedata-clear =
    .label = …ਡਾਟੇ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .accesskey = l
sitedata-settings =
    .label = …ਡਾਟੇ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ
    .accesskey = M
sitedata-cookies-permissions =
    .label = …ਇਜਾਜ਼ਤਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .accesskey = P
sitedata-cookies-exceptions =
    .label = ...ਛੋਟਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = ਸਿਰਨਾਵਾਂ ਪੱਟੀ
addressbar-suggest = ਜਦੋਂ ਸਿਰਨਾਵਾਂ ਪੱਟੀ ਵਰਤੀ ਜਾਂਦੀ ਹੋਵੇ ਤਾਂ ਸੁਝਾਓ
addressbar-locbar-history-option =
    .label = ਬਰਾਊਜ਼ਿੰਗ ਅਤੀਤ
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = ਬੁੱਕਮਾਰਕ
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = ਟੈਬਾਂ ਨੂੰ ਖੋਲ੍ਹੋ
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = ਚੋਟੀ ਦੀਆਂ ਸਾਈਟਾਂ
    .accesskey = T
addressbar-suggestions-settings = ਖੋਜ ਇੰਜਣ ਸੁਝਾਵਾਂ ਲਈ ਪਸੰਦਾਂ ਨੂੰ ਬਦਲੋ

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = ਵਧੇਰੇ ਟਰੈਕਿੰਗ ਸੁਰੱਖਿਆ
content-blocking-section-top-level-description = ਟਰੈਕਰ ਤੁਹਾਡੀਆਂ ਬਰਾਊਜ਼ ਕਰਨ ਦੀਆਂ ਆਦਤਾਂ ਅਤੇ ਦਿਲਚਸਪੀਆਂ ਬਾਰੇ ਜਾਣਕਾਰੀ ਇਕੱਤਰ ਕਰਨ ਲਈ ਆਨਲਾਈਨ ਤੁਹਾਡਾ ਪਿੱਛਾ ਕਰਦੇ ਹਨ। { -brand-short-name } ਇਹਨਾਂ ਟਰੈਕਰਾਂ ਅਤੇ ਹੋਰ ਖੁਣਸੀ ਸਕ੍ਰਿਪਟਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਉਂਦਾ ਹੈ।
content-blocking-learn-more = ਹੋਰ ਜਾਣੋ

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = ਮਿਆਰੀ
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = ਸਖ਼ਤ
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = ਚੁਣਿੰਦਾ
    .accesskey = c

##

content-blocking-etp-standard-desc = ਸੁਰੱਖਿਆ ਅਤੇ ਕਾਰਗੁਜ਼ਾਰੀ ਵਿਚਾਲੇ ਸੰਤੁਲਨ ਹੈ, ਸਫ਼ੇ ਆਮ ਨਾਲੋਂ ਵੱਧ ਤੇਜ਼ੀ ਨਾਲ ਲੋਡ ਹੁੰਦੇ ਹਨ।
content-blocking-etp-strict-desc = ਵਧੇਰੇ ਸੁਰੱਖਿਆ, ਪਰ ਕੁਝ ਸਾਈਟਾਂ ਜਾਂ ਸਮੱਗਰੀ ਦੇ ਨਾ ਕੰਮ ਕਰਨ ਦਾ ਕਾਰਨ ਹੋ ਸਕਦਾ ਹੈ।
content-blocking-etp-custom-desc = ਚੁਣੋ ਕਿ ਕਿਹੜੇ ਟਰੈਕਰਾਂ ਅਤੇ ਸਕ੍ਰਿਪਟਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਗਾਉਣੀ ਹੈ।
content-blocking-private-windows = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ‘ਚ ਸਮੱਗਰੀ ਟਰੈਕਿੰਗ
content-blocking-cross-site-tracking-cookies = ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕਿੰਗ ਕੂਕੀਜ਼
content-blocking-cross-site-tracking-cookies-plus-isolate = ਅੰਤਰ-ਸਾਈਟ  ਟਰੈਕ ਕਰਨ ਵਾਲੇ ਕੂਕੀਜ਼ ਅਤੇ ਬਾਕੀ ਕੂਕੀਜ਼ ਵੱਖ ਕਰੋ
content-blocking-social-media-trackers = ਸਮਾਜਿਕ ਮੀਡਿਆ ਟਰੈਕਰ
content-blocking-all-cookies = ਸਾਰੇ ਕੂਕੀਜ਼
content-blocking-unvisited-cookies = ਨਾ-ਖੋਲ੍ਹੀਆਂ ਸਾਈਟਾਂ ਤੋਂ ਕੂਕੀਜ਼
content-blocking-all-windows-tracking-content = ਸਾਰੀਆਂ ਵਿੰਡੋਆਂ ‘ਚ ਸਮੱਗਰੀ ਟਰੈਕਿੰਗ
content-blocking-all-third-party-cookies = ਸਾਰੇ ਤੀਜੀ-ਧਿਰ ਕੂਕੀਜ਼
content-blocking-cryptominers = ਕ੍ਰਿਪਟੋ-ਮਾਈਨਰ
content-blocking-fingerprinters = ਫਿੰਗਰਪਰਿੰਟਰ
content-blocking-warning-title = ਧਿਆਨ ਰੱਖੋ!
content-blocking-and-isolating-etp-warning-description = ਟਰੈਕਰਾਂ ਅਤੇ ਨਿਖੇੜਨ ਵਾਲੇ ਕੂਕੀਜ਼ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਉਣ ਨਾਲ ਕੁਝ ਸਾਈਟਾਂ ਦੇ ਕੰਮ ਕਰਨ ਉੱਤੇ ਅਸਰ ਪੈ ਸਕਦਾ ਹੈ। ਸਾਰੀ ਸਮੱਗਰੀ ਲੋਡ ਕਰਨ ਲਈ ਟਰੈਕਰਾਂ ਨਾਲ ਸਫ਼ੇ ਨੂੰ ਮੁੜ-ਲੋਡ ਕਰੋ।
content-blocking-warning-learn-how = ਹੋਰ ਸਿੱਖੋ
content-blocking-reload-description = ਇਹ ਤਬਦੀਲੀਆਂ ਲਾਗੂ ਕਰਨ ਲਈ ਤੁਹਾਨੂੰ ਆਪਣੀਆਂ ਟੈਬਾਂ ਨੂੰ ਮੁੜ ਲੋਡ ਕਰਨ ਦੀ ਲੋੜ ਹੋਵੇਗੀ।
content-blocking-reload-tabs-button =
    .label = ਸਾਰੀਆਂ ਟੈਬਾਂ ਮੁੜ-ਲੋਡ ਕਰੋ
    .accesskey = R
content-blocking-tracking-content-label =
    .label = ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = ਸਾਰੀਆਂ ਵਿੰਡੋਆਂ ‘ਚ
    .accesskey = A
content-blocking-option-private =
    .label = ਕੇਵਲ ਨਿੱਜੀ ਵਿੰਡੋਆਂ ‘ਚ
    .accesskey = p
content-blocking-tracking-protection-change-block-list = ਪਾਬੰਦੀ ਸੂਚੀ ਬਦਲੋ
content-blocking-cookies-label =
    .label = ਕੂਕੀਜ਼
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = ਹੋਰ ਜਾਣਕਾਰੀ
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = ਕ੍ਰਿਪਟੋ-ਮਾਈਨਰ
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = ਫਿੰਗਰਪਰਿੰਟਰ
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = ...ਛੋਟਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .accesskey = x

## Privacy Section - Permissions

permissions-header = ਇਜਾਜ਼ਤਾਂ
permissions-location = ਟਿਕਾਣਾ
permissions-location-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
permissions-xr = ਮਸ਼ੀਨੀ ਅਸਲੀਅਤ
permissions-xr-settings =
    .label = ਸੈਟਿੰਗਾਂ…
    .accesskey = t
permissions-camera = ਕੈਮਰਾ
permissions-camera-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
permissions-microphone = ਮਾਈਕਰੋਫ਼ੋਨ
permissions-microphone-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
permissions-notification = ਨੋਟੀਫਿਕੇਸ਼ਨ
permissions-notification-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
permissions-notification-link = ਹੋਰ ਜਾਣੋ
permissions-notification-pause =
    .label = { -brand-short-name } ਮੁੜ-ਚਾਲੂ ਹੋਣ ਤੱਕ ਸੂਚਨਾਵਾਂ ਨੂੰ ਰੋਕੋ
    .accesskey = n
permissions-autoplay = ਆਪੇ-ਚਲਾਓ
permissions-autoplay-settings =
    .label = …ਸੈਟਿੰਗਾਂ
    .accesskey = t
permissions-block-popups =
    .label = ਪੋਪਅੱਪ ਵਿੰਡੋ 'ਤੇ ਪਾਬੰਦੀ ਲਗਾਓ
    .accesskey = B
permissions-block-popups-exceptions =
    .label = …ਛੋਟਾਂ
    .accesskey = E
permissions-addon-install-warning =
    .label = ਜਦੋਂ ਵੈੱਬਸਾਈਟਾਂ ਐਡ-ਆਨ ਇੰਸਟਾਲ ਕਰਨ ਦੀ ਕੋਸ਼ਿਸ਼ਾਂ ਕਰਨ ਤਾਂ ਤੁਹਾਨੂੰ ਸਾਵਧਾਨ ਕਰੋ
    .accesskey = W
permissions-addon-exceptions =
    .label = …ਛੋਟਾਂ
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = ਅਸੈਸਬਿਲਟੀ ਸੇਵਾਵਾਂ ਨੂੰ ਆਪਣੇ ਬਰਾਊਜ਼ਰ ਲਈ ਪਹੁੰਚ ਤੋਂ ਰੋਕ ਲਗਾਓ
    .accesskey = a
permissions-a11y-privacy-link = ਹੋਰ ਜਾਣੋ

## Privacy Section - Data Collection

collection-header = { -brand-short-name } ਡਾਟਾ ਇਕੱਤਰ ਕਰਨਾ ਅਤੇ ਵਰਤੋ
collection-description = ਅਸੀਂ ਤੁਹਾਨੂੰ ਚੋਣ ਕਰਨ ਦਾ ਮੌਕਾ ਲਈ ਤਰਸਦੇ ਹਾਂ ਅਤੇ ਸਿਰਫ਼ ਉਹੀ ਇਕੱਤਰ ਕਰਦੇ ਹਾਂ, ਜੋ ਕਿ ਹਰੇਕ ਲਈ { -brand-short-name } ਦੇਣ ਅਤੇ ਸੁਧਾਰਨ ਲਈ ਚਾਹੀਦਾ ਹੈ। ਨਿੱਜੀ ਜਾਣਕਾਰੀ ਪ੍ਰਾਪਤ ਕਰਨ ਤੋਂ ਪਹਿਲਾਂ ਅਸੀਂ ਹਮੇਸ਼ਾਂ ਇਜਾਜ਼ਤ ਲੈਂਦੇ ਹਾਂ
collection-privacy-notice = ਪਰਦੇਦਾਰੀ ਸੂਚਨਾ
collection-health-report-telemetry-disabled = ਤੁਸੀਂ ਹੁਣ { -vendor-short-name } ਨੂੰ ਤਕਨੀਕੀ ਅਤੇ ਤਾਲਮੇਲ ਡਾਟਾ ਫੜਨ ਲਈ ਸਹਿਮਤੀ ਹਟਾ ਦਿੱਤੀ ਹੈ। ਸਾਰੇ ਪਿਛਲੇ ਡਾਟੇ ਨੂੰ 30 ਦਿਨਾਂ ਵਿੱਚ ਹਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ।
collection-health-report-telemetry-disabled-link = ਹੋਰ ਜਾਣੋ
collection-health-report =
    .label = { -brand-short-name } ਨੂੰ { -vendor-short-name } ਨੂੰ ਤਕਨੀਕੀ ਅਤੇ ਤਾਲਮੇਲ ਡਾਟਾ ਭੇਜਣ ਦੀ ਇਜ਼ਾਜ਼ਤ ਦਿਓ
    .accesskey = r
collection-health-report-link = ਹੋਰ ਜਾਣੋ
collection-studies =
    .label = { -brand-short-name } ਨੂੰ ਅਧਿਐਨ ਇੰਸਟਾਲ ਅਤੇ ਚਲਾਉਣ ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ
collection-studies-link = { -brand-short-name } ਅਧਿਐਨ ਵੇਖੋ
addon-recommendations =
    .label = { -brand-short-name } ਨੂੰ ਤੁਹਾਡੇ ਲਈ ਖਾਸ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦੀਆਂ ਸਿਫਾਰਸ਼ਾਂ ਕਰਨ ਲਈ ਸਹਿਮਤੀ ਦਿਓ
addon-recommendations-link = ਹੋਰ ਜਾਣੋ
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = ਇਸ ਬਿਲਡ ਸੰਰਚਨਾ ਲਈ ਡਾਟਾ ਰਿਪੋਰਟ ਕਰਨਾ ਅਸਮਰੱਥ ਹੈ
collection-backlogged-crash-reports =
    .label = { -brand-short-name } ਨੂੰ ਤੁਹਾਡੇ ਤੌਰ 'ਤੇ ਬੈਕ-ਲਾਗ ਕਰੈਸ਼ ਰਿਪੋਰਟਾਂ ਭੇਜਣ ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ
    .accesskey = c
collection-backlogged-crash-reports-link = ਹੋਰ ਜਾਣੋ

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = ਸੁਰੱਖਿਆ
security-browsing-protection = ਭਰਮਪੂਰਨ ਸਮੱਗਰੀ ਅਤੇ ਖ਼ਤਰਨਾਕ ਸਾਫਟਵੇਅਰ ਸੁਰੱਖਿਆ
security-enable-safe-browsing =
    .label = ਖ਼ਤਰਨਾਕ ਅਤੇ ਭਰਮਪੂਰਕ ਸਮੱਗਰੀ ਉੱਤੇ ਪਾਬੰਦੀ ਲਗਾਓ
    .accesskey = B
security-enable-safe-browsing-link = ਹੋਰ ਜਾਣੋ
security-block-downloads =
    .label = ਖ਼ਤਰਨਾਕ ਡਾਊਨਲੋਡਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਗਾਓ
    .accesskey = D
security-block-uncommon-software =
    .label = ਤੁਹਾਨੂੰ ਅਣਚਾਹੇ ਅਤੇ ਬੇਲੋੜੇ ਸਾਫਟਵੇਅਰਾਂ ਬਾਰੇ ਚੇਤਾਵਨੀ ਦਿੰਦਾ ਹੈ
    .accesskey = C

## Privacy Section - Certificates

certs-header = ਸਰਟੀਫਿਕੇਟ
certs-personal-label = ਜਦ ਸਰਵਰ ਤੁਹਾਡੇ ਪਰਸਨਲ ਸਰਟੀਫਿਕੇਟ ਦੀ ਮੰਗ ਕਰੇ
certs-select-auto-option =
    .label = ਕਿਸੇ ਦੀ ਆਪਣੇ-ਆਪ ਚੋਣ ਕਰੋ
    .accesskey = S
certs-select-ask-option =
    .label = ਹਰ ਵਾਰ ਤੁਹਾਨੂੰ ਪੁੱਛੋ
    .accesskey = A
certs-enable-ocsp =
    .label = ਕਿਊਰੀ OCSP ਜਵਾਬ-ਦੇਣ ਵਾਲੇ ਸਰਵਰਾਂ ਨੂੰ ਸਰਟੀਫਿਕੇਟਾਂ ਦੀ ਮੌਜੂਦਾ ਵੈਧਤਾ ਦੀ ਪਸ਼ਟੀ ਕਰਨ
    .accesskey = Q
certs-view =
    .label = …ਸਰਟੀਫਿਕੇਟ ਵੇਖੋ
    .accesskey = C
certs-devices =
    .label = …ਸੁਰੱਖਿਆ ਡਿਵਾਈਸ
    .accesskey = D
space-alert-learn-more-button =
    .label = ਹੋਰ ਜਾਣੋ
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ ਨੂੰ ਖੋਲ੍ਹੋ
           *[other] ਮੇਰੀਆਂ ਪਸੰਦਾਂ ਨੂੰ ਖੋਲ੍ਹੋ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } ਲਈ ਡਿਸਕ ਥਾਂ ਖਤਮ ਹੋ ਗਈ ਹੈ। ਵੈਬਸਾਈਟ ਸਮੱਗਰੀ ਸ਼ਾਇਦ ਠੀਕ ਤਰ੍ਹਾਂ ਦਿਖਾਈ ਨਾ ਜਾ ਸਕੇ। ਤੁਸੀਂ ਚੋਣਾਂ > ਪਰਦੇਦਾਰੀ ਅਤੇ ਸੁਰੱਖਿਆ > ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡਾਟਾ, ਵਿੱਚ ਸਟੋਰ ਕੀਤਾ ਡਾਟਾ ਮਿਟਾ ਸਕਦੇ ਹੋ।
       *[other] { -brand-short-name } ਲਈ ਡਿਸਕ ਥਾਂ ਖਤਮ ਹੋ ਗਈ ਹੈ। ਵੈਬਸਾਈਟ ਸਮੱਗਰੀ ਸ਼ਾਇਦ ਠੀਕ ਤਰ੍ਹਾਂ ਦਿਖਾਈ ਨਾ ਜਾ ਸਕੇ। ਤੁਸੀਂ ਪਸੰਦਾਂ > ਪਰਦੇਦਾਰੀ ਅਤੇ ਸੁਰੱਖਿਆ > ਕੂਕੀਜ਼ ਅਤੇ ਸਾਈਟ ਡਾਟਾ, ਵਿੱਚ ਸਟੋਰ ਕੀਤਾ ਡਾਟਾ ਮਿਟਾ ਸਕਦੇ ਹੋ।
    }
space-alert-under-5gb-ok-button =
    .label = ਠੀਕ ਹੈ, ਸਮਝ ਗਏ
    .accesskey = K
space-alert-under-5gb-message = { -brand-short-name } ਲਈ ਡਿਸਕ ਥਾਂ ਖਤਮ ਹੋ ਗਈ ਹੈ। ਵੈਬਸਾਈਟ ਸਮੱਗਰੀ ਸ਼ਾਇਦ ਠੀਕ ਤਰ੍ਹਾਂ ਦਿਖਾਈ ਨਾ ਜਾ ਸਕੇ। ਬਰਾਊਜ਼ ਕਰਨ ਦੇ ਬਿਹਤਰ ਤਜਰਬੇ ਲਈ ਆਪਣੀ ਡਿਸਕ ਦੀ ਵਰਤੋਂ ਨੂੰ ਅਨੁਕੂਲ ਬਣਾਉਣ ਲਈ “ਹੋਰ ਜਾਣੋ” ‘ਤੇ ਜਾਓ।

## Privacy Section - HTTPS-Only

httpsonly-header = ਸਿਰਫ਼-HTTPS ਮੋਡ
httpsonly-description = HTTPS { -brand-short-name } ਅਤੇ ਤੁਹਾਡੇ ਵਲੋਂ ਖੋਲ੍ਹੀਆਂ ਵੈਬਸਾਈਟਾਂ ਵਿਚਾਲੇ ਇੱਕ ਸੁਰੱਖਿਅਤ, ਇੰਕ੍ਰਿਪਟ ਕੀਤਾ ਕਨੈਕਸ਼ਨ ਦਿੰਦਾ ਹੈ। ਬਹੁਤੀਆਂ ਵੈਬਸਾਈਟਾਂ HTTPS ਦਾ ਸਮਰਥਨ ਕਰਦੀਆਂ ਹਨ, ਅਤੇ ਜੇ ਸਿਰਫ-HTTPS ਮੋਡ ਸਮਰੱਥ ਹੈ ਤਾਂ { -brand-short-name } ਸਾਰੇ ਕਨੈਕਸ਼ਨਾਂ ਨੂੰ HTTPS ਵਿੱਚ ਅਪਗਰੇਡ ਕਰੇਗਾ।
httpsonly-learn-more = ਹੋਰ ਜਾਣੋ
httpsonly-radio-enabled =
    .label = ਸਾਰੀਆੰ ਵਿੰਡੋ ਵਿੱਚ ਸਿਰਫ਼-HTTPS ਮੋਡ ਸਮਰੱਥ ਕਰੋ
httpsonly-radio-enabled-pbm =
    .label = ਸਿਰਫ਼ ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋ ਵਿੱਚ ਸਿਰਫ਼-HTTPS ਮੋਡ ਸਮਰੱਥ ਕਰੋ
httpsonly-radio-disabled =
    .label = ਸਿਰਫ਼-HTTPS ਮੋਡ ਸਮਰੱਥ ਨਾ ਕਰੋ

## The following strings are used in the Download section of settings

desktop-folder-name = ਡੈਸਕਟਾਪ
downloads-folder-name = ਡਾਊਨਲੋਡ
choose-download-folder-title = ਡਾਊਨਲੋਡ ਫੋਲਡਰ ਚੁਣੋ:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = ਫ਼ਾਈਲਾਂ { $service-name } 'ਤੇ ਸੰਭਾਲੋ
