# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = ਐਡ-ਆਨ ਮੈਨੇਜਰ
addons-page-title = ਐਡ-ਆਨ ਮੈਨੇਜਰ
search-header =
    .placeholder = addons.mozilla.org ਨੂੰ ਖੋਜੋ
    .searchbuttonlabel = ਖੋਜੋ
search-header-shortcut =
    .key = f
list-empty-installed =
    .value = ਤੁਹਾਡੇ ਕੋਲ ਇਸ ਕਿਸਮ ਦੀ ਕੋਈ ਵੀ ਐਡ-ਆਨ ਇੰਸਟਾਲ ਨਹੀਂ ਹੈ
list-empty-available-updates =
    .value = ਕੋਈ ਅੱਪਡੇਟ ਨਹੀਂ ਲੱਭਿਆ
list-empty-recent-updates =
    .value = ਤੁਸੀਂ ਹੁਣੇ ਜਿਹੇ ਕੋਈ ਵੀ ਐਡ-ਆਨ ਅੱਪਡੇਟ ਨਹੀਂ ਕੀਤੀ ਹੈ
list-empty-find-updates =
    .label = ਅੱਪਡੇਟ ਲਈ ਚੈੱਕ ਕਰੋ
list-empty-button =
    .label = ਐਡ-ਆਨ ਬਾਰੇ ਹੋਰ ਜਾਣੋ
help-button = ਐਡ-ਆਨ ਸਹਿਯੋਗ
sidebar-help-button-title =
    .title = ਐਡ-ਆਨ ਸਹਿਯੋਗ
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } ਚੋਣਾਂ
       *[other] { -brand-short-name } ਪਸੰਦਾਂ
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } ਚੋਣਾਂ
           *[other] { -brand-short-name } ਪਸੰਦਾਂ
        }
show-unsigned-extensions-button =
    .label = ਕੁਝ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦੀ ਜਾਂਚ ਨਹੀਂ ਕੀਤੀ ਜਾ ਸਕੀ
show-all-extensions-button =
    .label = ਸਭ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦਿਖਾਉ
cmd-show-details =
    .label = ਹੋਰ ਜਾਣਕਾਰੀ ਵੇਖੋ
    .accesskey = S
cmd-find-updates =
    .label = ਅੱਪਡੇਟ ਲੱਭੋ
    .accesskey = F
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ
           *[other] ਮੇਰੀ ਪਸੰਦ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = ਥੀਮ ਲਾਓ
    .accesskey = W
cmd-disable-theme =
    .label = ਥੀਮ ਲਾਉਣ ਤੋਂ ਰੋਕੋ
    .accesskey = W
cmd-install-addon =
    .label = ਇੰਸਟਾਲ
    .accesskey = I
cmd-contribute =
    .label = ਯੋਗਦਾਨ
    .accesskey = C
    .tooltiptext = ਇਹ ਐਡ-ਆਨ ਦੇ ਡਿਵੈਲਪਮੈਂਟ ਲਈ ਯੋਗਦਾਨ ਪਾਓ
detail-version =
    .label = ਵਰਜ਼ਨ
detail-last-updated =
    .label = ਆਖਰੀ ਅੱਪਡੇਟ
detail-contributions-description = ਇਹ ਐਡ-ਆਨ ਦੇ ਡਿਵੈਲਪਰ ਨੇ ਤੁਹਾਨੂੰ ਪੁੱਛਿਆ ਹੈ ਕਿ ਤੁਸੀਂ ਛੋਟਾ ਜਿਹਾ ਯੋਗਦਾਨ ਦੇ ਕੇ ਇਸ ਦੀ ਡਿਵੈਲਪਮੈਂਟ ਨੂੰ ਜਾਰੀ ਰੱਖਣ 'ਚ ਮੱਦਦ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ।
detail-contributions-button = ਯੋਗਦਾਨ ਪਾਓ
    .title = ਇਸ ਐਡ-ਆਨ ਦੇ ਵਿਕਾਸ ਵਿੱਚ ਯੋਗਦਾਨ ਪਾਓadd-on
    .accesskey = C
detail-update-type =
    .value = ਆਟੋਮੈਟਿਕ ਅੱਪਡੇਟ
detail-update-default =
    .label = ਡਿਫਾਲਟ
    .tooltiptext = ਜੇ ਡਿਫਾਲਟ ਹੋਵੇ ਤਾਂ ਅੱਪਡੇਟ ਆਟੋਮੈਟਿਕ ਹੀ ਇੰਸਟਾਲ ਕਰੋ
detail-update-automatic =
    .label = ਚਾਲੂ
    .tooltiptext = ਆਟੋਮੈਟਿਕ ਅੱਪਡੇਟ ਇੰਸਟਾਲ ਕਰੋ
detail-update-manual =
    .label = ਬੰਦ
    .tooltiptext = ਅੱਪਡੇਟ ਆਟੋਮੈਟਿਕ ਇੰਸਟਾਲ ਨਾ ਕਰੋ
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ‘ਚ ਚੱਲਣਾ
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਵਿੱਚ ਇਜਾਜ਼ਤ ਨਹੀਂ ਹੈ
detail-private-disallowed-description2 = ਇਹ ਇਕਟੈਨਸ਼ਨ ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ਦੌਰਾਨ ਨਹੀਂ ਚੱਲੇਗੀ। <a data-l10n-name="learn-more">ਹੋਰ ਜਾਣੋ</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਲਈ ਪਹੁੰਚ ਦੀ ਲੋੜ ਹੈ
detail-private-required-description2 = ਇਹ ਇਕਸਟੈਨਸ਼ਨ ਨੂੰ ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ਦੌਰਾਨ ਤੁਹਾਡੀਆਂ ਆਨਲਾਈਨ ਸਰਗਰਮੀਆਂ ਲਈ ਪਹੁੰਚ ਹੈ। <a data-l10n-name="learn-more">ਹੋਰ ਜਾਣੋ</a>
detail-private-browsing-on =
    .label = ਇਜਾਜ਼ਤ ਹੈ
    .tooltiptext = ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ‘ਚ ਸਮਰੱਥ ਹੈ
detail-private-browsing-off =
    .label = ਇਜਾਜ਼ਤ ਨਾ ਦਿਓ
    .tooltiptext = ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ਰ ਵਿੱਚ ਅਸਮਰੱਥ
detail-home =
    .label = ਮੁੱਖ ਸਫ਼ਾ
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = ਐਡ-ਆਨ ਪਰੋਫਾਈਲ
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = ਅੱਪਡੇਟ ਲਈ ਚੈੱਕ ਕਰੋ
    .accesskey = F
    .tooltiptext = ਇਹ ਐਡ-ਆਨ ਲਈ ਅੱਪਡੇਟ ਚੈੱਕ ਕਰੋ
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] ਚੋਣਾਂ
           *[other] ਮੇਰੀ ਪਸੰਦ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] ਇਸ ਐਡ-ਆਨ ਦੀਆਂ ਚੋਣਾਂ ਬਦਲੋ
           *[other] ਇਸ ਐਡ-ਆਨ ਦੀ ਪਸੰਦ ਬਦਲੋ
        }
detail-rating =
    .value = ਰੇਟਿੰਗ
addon-restart-now =
    .label = ਹੁਣੇ ਮੁੜ-ਚਾਲੂ
disabled-unsigned-heading =
    .value = ਕੁਝ ਐਡ-ਆਨ ਨੂੰ ਅਸਮਰੱਥ ਕੀਤਾ ਜਾ ਚੁੱਕਾ ਹੈ।
disabled-unsigned-description = ਅੱਗੇ ਦਿੱਤੀਆਂ ਐਡ-ਆਨ ਨੂੰ { -brand-short-name } ਨਾਲ ਵਰਤਣ ਲਈ ਜਾਂਚਿਆ ਨਹੀਂ ਗਿਆ। ਤੁਸੀਂ <label data-l10n-name="find-addons">ਬਦਲ ਲਈ ਲੱਭ ਸਕਦੇ ਹੋ</label> ਜਾਂਚ ਡਿਵੈਲਪਰ ਨੂੰ ਉਹਨਾਂ ਦੀ ਜਾਂਚ ਕਰਵਾਉਣ ਲਈ ਕਹਿ ਸਕਦੇ ਹੋ।
disabled-unsigned-learn-more = ਸਾਡੇ ਵਲੋਂ ਤੁਹਾਨੂੰ ਆਨਲਾਈਨ ਸੁਰੱਖਿਆ ਰੱਖਣ ਲਈ ਕੀਤੇ ਜਾਂਦੇ ਜਤਨਾਂ ਦੇ ਬਾਰੇ ਹੋਰ ਸਮਝੋ।
disabled-unsigned-devinfo = ਡਿਵੈਲਪਰ, ਜੋ ਆਪਣੀਆਂ ਐਡ-ਆਨ ਨੂੰ ਤਸਦੀਕ ਕਰਵਾਉਣਾ ਚਾਹੁੰਦੇ ਹਨ, ਸਾਡੇ <label data-l10n-name="learn-more">ਦਸਤੀ</label> ਨੂੰ ਪੜ੍ਹਨਾ ਜਾਰੀ ਰੱਖ ਸਕਦੇ ਹਨ।
plugin-deprecation-description = ਕੁਝ ਗੁਆਚ ਗਿਆ? ਕੁਝ ਪਲੱਗਇਨਾਂ { -brand-short-name } ਵਲੋਂ ਸਹਾਇਤਾ ਪ੍ਰਾਪਤ ਨਹੀਂ ਹਨ। <label data-l10n-name="learn-more">ਹੋਰ ਜਾਣੋ।</label>
legacy-warning-show-legacy = ਪੁਰਾਣੀਆਂ ਇਕਸਟੈਸ਼ਨਾਂ ਵੇਖਾਓ
legacy-extensions =
    .value = ਪੁਰਾਣੀਆਂ ਇਕਟੈਨਸ਼ਨਾਂ
legacy-extensions-description = ਇਹ ਇਕਟੈਸ਼ਨਾਂ ਮੌਜੂਦਾ { -brand-short-name } ਸਟੈਂਡਰਡਾਂ ਨੂੰ ਪੂਰਾ ਨਹੀਂ ਕਰਦੀਆਂ ਹਨ ਇਸਕਰਕੇ ਇਹਨਾਂ ਨੂੰ ਨਾ-ਸਰਗਰਮ ਕੀਤਾ ਗਿਆ ਹੈ। <label data-l10n-name="legacy-learn-more">ਐਡ-ਆਨ 'ਚ ਤਬਦੀਲੀਆਂ ਬਾਰੇ ਜਾਣੋ</label>
private-browsing-description2 =
    { -brand-short-name } ਪਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ਵਾਲੇ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦੇ ਕੰਮ ਕਰਨ ਦੇ ਢੰਗ ਨੂੰ ਬਦਲ ਰਿਹਾ ਹੈ। ਤੁਹਾਡੇ { -brand-short-name } ਵਿੱਚ ਜੋੜੀ ਗਈ ਕੋਈ ਵੀ ਨਵੀਂ ਇਕਸਟੈਨਸ਼ਨ ਆਪਣੇ-ਆਪ ਪਰਾਈਵੇਟ ਵਿੰਡੋ ਵਿੱਚ ਨਹੀਂ ਚੱਲੇਗੀ। ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਉਸ ਨੂੰ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਇਜਾਜ਼ਤ ਨਹੀਂ ਦਿਉਂਗੇ, ਇਕਸਟੈਨਸ਼ਨ ਪਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ਦੌਰਾਨ ਕੰਮ ਨਹੀਂ ਕਰੇਗੀ ਅਤੇ ਤੁਹਾੀਡਆਂ ਆਨਲਾਈਨ ਸਰਗਰਮੀਆਂ ਲਈ ਪਹੁੰਚ ਨਹੀਂ ਕਰ ਸਕੇਗੀ। ਅਸੀਂ ਇਹ ਤਬਦੀਲੀ ਤੁਹਾਡੀ ਪਰਾਈਵੇਟ ਬਰਾਊਜ਼ਿੰਗ ਨੂੰ ਨਿੱਜੀ ਬਣਾਈ ਰੱਖਣ ਲਈ ਕੀਤੀ ਹੈ।
    <label data-l10n-name="private-browsing-learn-more">ਇਕਸਟੈਨਸ਼ਨ ਸੈਟਿੰਗਾਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰਨ ਬਾਰੇ ਹੋਰ ਜਾਣੋ</label>
addon-category-discover = ਸਿਫਾਰਸ਼
addon-category-discover-title =
    .title = ਸਿਫਾਰਸ਼
addon-category-extension = ਇਕਸਟੈਨਸ਼ਨ
addon-category-extension-title =
    .title = ਇਕਸਟੈਨਸ਼ਨ
addon-category-theme = ਥੀਮ
addon-category-theme-title =
    .title = ਥੀਮ
addon-category-plugin = ਪਲੱਗਇਨ
addon-category-plugin-title =
    .title = ਪਲੱਗਇਨ
addon-category-dictionary = ਡਿਕਸ਼ਨਰੀਆਂ
addon-category-dictionary-title =
    .title = ਡਿਕਸ਼ਨਰੀਆਂ
addon-category-locale = ਭਾਸ਼ਾਵਾਂ
addon-category-locale-title =
    .title = ਭਾਸ਼ਾਵਾਂ
addon-category-available-updates = ਅੱਪਡੇਟ ਮੌਜੂਦ ਹਨ
addon-category-available-updates-title =
    .title = ਅੱਪਡੇਟ ਮੌਜੂਦ ਹਨ
addon-category-recent-updates = ਤਾਜ਼ਾ ਅੱਪਡੇਟ
addon-category-recent-updates-title =
    .title = ਤਾਜ਼ਾ ਅੱਪਡੇਟ

## These are global warnings

extensions-warning-safe-mode = ਸੁਰੱਖਿਅਤ ਮੋਡ 'ਚ ਸਭ ਐਡ-ਆਨ ਬੰਦ ਕਰ ਦਿੱਤੀਆਂ ਗਈਆਂ ਹਨ।
extensions-warning-check-compatibility = ਐਡ-ਆਨ ਅਨੁਕੂਲਤਾ ਚੈੱਕ ਕਰਨਾ ਬੰਦ ਕੀਤਾ ਹੋਇਆ ਹੈ। ਤੁਹਾਡੇ ਕੋਲ ਗ਼ੈਰ-ਅਨੁਕੂਲ ਐਡ-ਆਨ ਹੋ ਸਕਦੀਆਂ ਹਨ।
extensions-warning-check-compatibility-button = ਸਮਰੱਥ
    .title = ਐਡ-ਆਨ ਦੇ ਢੁੱਕਵੇਂਪਣ ਦੀ ਜਾਂਚ ਕਰਨ ਨੂੰ ਸਮਰੱਥ ਕਰੋ
extensions-warning-update-security = ਐਡ-ਆਨ ਅੱਪਡੇਟ ਸੁਰੱਖਿਆ ਚੈੱਕ ਕਰਨਾ ਬੰਦ ਹੈ। ਤੁਹਾਨੂੰ ਅੱਪਡੇਟ ਰਾਹੀਂ ਖਤਰਾ ਹੋ ਸਕਦਾ ਹੈ।
extensions-warning-update-security-button = ਚਾਲੂ
    .title = ਐਡ-ਆਨ ਉੱਤੇ ਸੁਰੱਖਿਆ ਚੈੱਕ ਕੀਤਾ ਜਾਂਦਾ ਹੈ

## Strings connected to add-on updates

addon-updates-check-for-updates = ਅੱਪਡੇਟ ਲਈ ਚੈੱਕ ਕਰੋ
    .accesskey = C
addon-updates-view-updates = ਤਾਜ਼ਾ ਅੱਪਡੇਟ ਵੇਖੋ
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = ਐਡ-ਆਨ ਆਟੋਮੈਟਿਕ ਹੀ ਅੱਪਡੇਟ ਕਰੋ
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = ਸਭ ਐਡ-ਆਨ ਆਟੋਮੈਟਿਕ ਅੱਪਡੇਟ ਲਈ ਮੁੜ-ਸੈੱਟ ਕਰੋ
    .accesskey = R
addon-updates-reset-updates-to-manual = ਸਭ ਐਡ-ਆਨ ਖੁਦ ਅੱਪਡੇਟ ਕਰਨ ਕਰਨ ਲਈ ਮੁੜ-ਸੈੱਟ ਕਰੋ
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = ਐਡ-ਆਨ ਅੱਪਡੇਟ ਕੀਤੇ ਜਾ ਰਹੇ ਹਨ
addon-updates-installed = ਤੁਹਾਡੀ ਐਡ-ਆਨ ਅੱਪਡੇਟ ਕੀਤੀ ਜਾ ਚੁੱਕੀ ਹੈ।
addon-updates-none-found = ਕੋਈ ਅੱਪਡੇਟ ਨਹੀਂ ਮਿਲਿਆ
addon-updates-manual-updates-found = ਉਪਲੱਬਧ ਅੱਪਡੇਟ ਵੇਖੋ

## Add-on install/debug strings for page options menu

addon-install-from-file = …ਐਡ-ਆਨ ਫਾਈਲ ਤੋਂ ਇੰਸਟਾਲ ਕਰੋ
    .accesskey = I
addon-install-from-file-dialog-title = ਇੰਸਟਾਲ ਕਰਨ ਲਈ ਐਡ-ਆਨ ਚੁਣੋ
addon-install-from-file-filter-name = ਐਡ-ਆਨ
addon-open-about-debugging = ਐਡ-ਆਨ ਨੂੰ ਡੀਬੱਗ ਕਰੋ
    .accesskey = B

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = ਇਕਸਟੈਨਸ਼ਨ ਸ਼ਾਰਟਕੱਟ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .accesskey = S
shortcuts-no-addons = ਤੁਹਾਡੇ ਕੋਲ ਕੋਈ ਵੀ ਸਮਰੱਥ ਕੀਤੀ ਇਕਸਟੈਨਸ਼ਨ ਨਹੀਂ ਹੈ।
shortcuts-no-commands = ਅੱਗੇ ਦਿੱਤੀਆਂ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦੇ ਸ਼ਾਰਟਕੱਟ ਨਹੀਂ ਹਨ:
shortcuts-input =
    .placeholder = ਸ਼ਾਰਟਕੱਟ ਲਿਖੋ
shortcuts-browserAction2 = ਟੂਲਬਾਰ ਬਟਨ ਸਰਗਰਮ ਕਰੋ
shortcuts-pageAction = ਸਫ਼ਾ ਕਾਰਵਾਈ ਸਰਗਰਮ ਕਰੋ
shortcuts-sidebarAction = ਬਾਹੀ ਬਦਲੋ
shortcuts-modifier-mac = Ctrl, Alt, ਜਾਂ ⌘ ਸਮੇਤ
shortcuts-modifier-other = Ctrl ਜਾਂ Alt ਸਮੇਤ
shortcuts-invalid = ਗ਼ੈਰ-ਵਾਜਬ ਮਿਸ਼ਰਨ
shortcuts-letter = ਅੱਖਰ ਲਿਖੋ
shortcuts-system = { -brand-short-name } ਸ਼ਾਰਟਕੱਟ ਨੂੰ ਅਣਡਿੱਠਾ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = ਡੁਪਲੀਕੇਟ ਸ਼ਾਰਟਕੱਟ
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } ਨੂੰ ਇੱਕ ਤੋਂ ਵੱਧ ਹਾਲਤਾਂ ਵਿੱਚ ਸ਼ਾਰਟਕੱਟ ਵਜੋਂ ਵਰਤਿਆ ਜਾ ਰਿਹਾ ਹੈ। ਡੁਪਲੀਕੇਟ ਸ਼ਾਰਟਕੱਟ ਬੇਉਮੀਦ ਰਵੱਈਏ ਦਾ ਕਾਰਨ ਹੋ ਸਕਦੇ ਹਨ।
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } ਵਲੋਂ ਪਹਿਲਾਂ ਹੀ ਵਰਤਿਆ
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] { $numberToShow } ਹੋਰ ਵੇਖੋ
    }
shortcuts-card-collapse-button = ਘੱਟ ਵੇਖਾਓ
header-back-button =
    .title = ਪਿੱਛੇ ਜਾਓ

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    ਇਕਸਟੈਨਸ਼ਨਾਂ ਤੇ ਥੀਮ ਤੁਹਾਡੇ ਬਰਾਊਜ਼ਰ ਲਈ ਐਪਾਂ ਵਾਂਗ ਹਨ ਅਤੇ ਉਹ ਤੁਹਾਨੂੰ ਪਾਸਵਰਡ ਸੁਰੱਖਿਅਤ ਕਰਨ, ਵਿਡੀਓ ਡਾਊਨਲੋਡ ਕਰਨ,
    ਡੀਲਾਂ ਲੱਭਣ, ਤੰਗ ਕਰਨ ਵਾਲੇ ਇਸ਼ਤਿਹਾਰਾਂ ਤੇ ਪਾਬੰਦੀ ਲਗਾਉਣ, ਤੁਹਾਡੇ ਬਰਾਊਜ਼ਰ ਦੀ ਦਿੱਖ ਬਦਲਣ ਤੇ ਹੋਰ ਕਈ ਕੁ
    ਕਰਨ ਲਈ ਸਹਾਇ ਹਨ। ਇਹ ਛੋਟੇ ਛੋਟੇ ਸਾਫਟਵੇਅਰ ਪਰੋਗਰਾਮ ਅਕਸਰ ਹੋਰ ਧਿਰਾਂ ਵਲੋਂ ਤਿਆਰ ਕੀਤੇ ਜਾਂਦੇ ਹਨ। 
    ਖਾਸ ਸੁਰੱਖਿਆ, ਕਾਰਗੁਜ਼ਾਰੀ ਤੇ ਫੰਕਸ਼ਨਾਂ ਲਈ { -brand-product-name } ਵਲੋਂ <a data-l10n-name="learn-more-trigger">ਸਿਫਾਰਸ਼ਾਂ</a>
     ਇਹ ਹਨ।
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    ਇਹਨਾਂ ਸਿਫਾਰਸ਼ਾਂ ਵਿੱਚੋਂ ਕੁਝ ਨਿੱਜੀ ਬਣਾਈਆਂ ਹਨ। ਇਹ ਤੁਹਾਡੇ ਵਲੋਂ ਇੰਸਟਾਲ ਇਕਸਟੈਨਸ਼ਨਾਂ, ਪਰੋਫਾਈਲ ਪਸੰਦਾਂ
     ਅਤੇ ਵਰਤੋਂ ਅੰਕੜਿਆਂ ਦੇ ਉੱਤੇ ਅਧਾਰਿਤ ਹਨ।
discopane-notice-learn-more = ਹੋਰ ਸਿੱਖੋ
privacy-policy = ਪਰਦੇਦਾਰੀ ਸੂਚਨਾ
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = <a data-l10n-name="author">{ $author }</a> ਵਲੋਂ
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = ਵਰਤੋਂਕਾਰ: { $dailyUsers }
install-extension-button = { -brand-product-name } ‘ਚ ਜੋੜੋ
install-theme-button = ਥੀਮ ਇੰਸਟਾਲ ਕਰੋ
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = ਬੰਦੋਬਸਤ
find-more-addons = ਹੋਰ ਐਡ-ਆਨ ਲੱਭੋ
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = ਹੋਰ ਚੋਣਾਂ

## Add-on actions

report-addon-button = ਰਿਪੋਰਟ
remove-addon-button = ਹਟਾਓ
# The link will always be shown after the other text.
remove-addon-disabled-button = ਹਟਾਇਆ ਨਹੀਂ ਜਾ ਸਕਦਾ <a data-l10n-name="link">ਕਿਓ?</a>
disable-addon-button = ਅਸਮਰੱਥ ਕਰੋ
enable-addon-button = ਸਮਰੱਥ ਕਰੋ
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = ਸਮਰੱਥ ਕਰੋ
preferences-addon-button =
    { PLATFORM() ->
        [windows] ਚੋਣਾਂ
       *[other] ਪਸੰਦਾਂ
    }
details-addon-button = ਵੇਰਵੇ
release-notes-addon-button = ਰੀਲਿਜ਼ ਨੋਟਿਸ
permissions-addon-button = ਇਜਾਜ਼ਤਾਂ
extension-enabled-heading = ਸਮਰੱਥ ਹੈ
extension-disabled-heading = ਅਸਮਰੱਥ ਹੈ
theme-enabled-heading = ਸਮਰੱਥ ਹੈ
theme-disabled-heading = ਅਸਮਰੱਥ ਹੈ
plugin-enabled-heading = ਸਮਰੱਥ ਹੈ
plugin-disabled-heading = ਅਸਮਰੱਥ ਹੈ
dictionary-enabled-heading = ਸਮਰੱਥ ਹੈ
dictionary-disabled-heading = ਅਸਮਰੱਥ ਹੈ
locale-enabled-heading = ਸਮਰੱਥ ਹੈ
locale-disabled-heading = ਅਸਮਰੱਥ ਹੈ
ask-to-activate-button = ਸਰਗਰਮ ਕਰਨ ਲਈ ਪੁੱਛੋ
always-activate-button = ਹਮੇਸ਼ਾ ਸਰਗਰਮ ਕਰੋ
never-activate-button = ਕਦੇ ਸਰਗਰਮ ਨਾ ਕਰੋ
addon-detail-author-label = ਲੇਖਕ
addon-detail-version-label = ਵਰਜ਼ਨ
addon-detail-last-updated-label = ਆਖਰੀ ਅੱਪਡੇਟ
addon-detail-homepage-label = ਮੁੱਖ ਸਫ਼ਾ
addon-detail-rating-label = ਦਰਜਾ
# Message for add-ons with a staged pending update.
install-postponed-message = { -brand-short-name } ਮੁੜ-ਚਾਲੂ ਕਰਨ ਦੌਰਾਨ ਇਸ ਇਕਟੈਨਸ਼ਨ ਨੂੰ ਅੱਪਡੇਟ ਕੀਤਾ ਜਾਵੇਗਾ।
install-postponed-button = ਹੁਣੇ ਅੱਪਡੇਟ ਕਰੋ
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = 5 ‘ਚੋਂ { NUMBER($rating, maximumFractionDigits: 1) } ਦਰਜਾ
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (ਅਸਮਰੱਥ ਹੈ)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } ਪੜਤਾਲ
       *[other] { $numberOfReviews } ਪੜਤਾਲਾਂ
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> ਨੂੰ ਹਟਾਇਆ ਗਿਆ।
pending-uninstall-undo-button = ਵਾਪਸ
addon-detail-updates-label = ਆਪਣੇ-ਆਪ ਅੱਪਡੇਟ ਦੀ ਇਜਾਜ਼ਤ ਹੈ
addon-detail-updates-radio-default = ਮੂਲ
addon-detail-updates-radio-on = ਚਾਲੂ
addon-detail-updates-radio-off = ਬੰਦ
addon-detail-update-check-label = ਅੱਪਡੇਟ ਲਈ ਚੈੱਕ ਕਰੋ
install-update-button = ਅੱਪਡੇਟ ਕਰੋ
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋ ਵਿੱਚ ਇਜਾਜ਼ਤ ਦਿਓ
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = ਜਦੋਂ ਮਨਜ਼ੂਰੀ ਦਿੱਤੀ ਤਾਂ ਇਕਸਟੈਨਸ਼ਨ ਨੂੰ ਪ੍ਰਾਈਵੇਟ ਬਰਾਊਜ਼ ਕਰਨ ਦੌਰਾਨ ਵੀ ਤੁਹਾਡੀਆਂ ਆਨਲਾਈਨ ਸਰਗਰਮੀਆਂ ਲਈ ਪਹੁੰਚ ਹੋਵੇਗੀ। <a data-l10n-name="learn-more">ਹੋਰ ਜਾਣੋ</a>
addon-detail-private-browsing-allow = ਮਨਜ਼ੂਰ
addon-detail-private-browsing-disallow = ਮਨਜ਼ੂਰ ਨਾ ਕਰੋ
# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } ਉਹ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦੀ ਸਿਫਾਰਸ਼ ਕਰਦਾ ਹੈ, ਜੋ ਸੁਰੱਖਿਆ ਅਤੇ ਕਾਰਗੁਜ਼ਾਰੀ ਲਈ ਸਾਡੇ ਮਿਆਰ ਪੂਰੇ ਕਰਦੇ ਹਨ।
    .aria-label = { addon-badge-recommended2.title }
available-updates-heading = ਉਪਲੱਬਧ ਅੱਪਡੇਟ
recent-updates-heading = ਤਾਜ਼ਾ ਅੱਪਡੇਟ
release-notes-loading = …ਲੋਡ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ
release-notes-error = ਅਫਸੋਸ, ਪਰ ਰੀਲਿਜ਼ ਨੋਟਿਸ ਡਾਊਨਲੋਡ ਕਰਨ ਦੌਰਾਨ ਸਮੱਸਿਆ ਆਈ ਹੈ।
addon-permissions-empty = ਇਸ ਇਕਸਟੈਨਸ਼ਨ ਲਈ ਕਿਸੇ ਇਜਾਜ਼ਤ ਦੀ ਲੋੜ ਨਹੀਂ ਹੈ
recommended-extensions-heading = ਸਿਫਾਰਸ਼ੀ ਇਕਟੈਨਸ਼ਨਾਂ
recommended-themes-heading = ਸਿਫਾਰਸ਼ੀ ਥੀਮ
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = ਕਲਾ ਜਾਗਦੀ ਹੈ?<a data-l10n-name="link">ਫਾਇਰਫਾਕਸ ਰੰਗ ਨਾਲ ਆਪਣਾ ਖੁਦ ਦਾ ਥੀਮ ਬਣਾਓ।</a>

## Page headings

extension-heading = ਆਪਣੀਆਂ ਇਕਸਟੈਨਸ਼ਨਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
theme-heading = ਆਪਣੇ ਥੀਮਾਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ
plugin-heading = ਆਪਣੀਆਂ ਪਲੱਗਇਨ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ
dictionary-heading = ਆਪਣੀਆਂ ਡਿਕਸ਼ਨਰੀਆਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ
locale-heading = ਆਪਣੀਆਂ ਭਾਸ਼ਾਵਾਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ
updates-heading = ਆਪਣੇ ਅੱਪਡੇਟਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
discover-heading = ਆਪਣੇ { -brand-short-name } ਨੂੰ ਆਪਣਾ ਬਣਾਓ
shortcuts-heading = ਇਕਸਟੈਨਸ਼ਨ ਸ਼ਾਰਟਕੱਟਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
default-heading-search-label = ਹੋਰ ਐਡ-ਆਨ ਲੱਭੋ
addons-heading-search-input =
    .placeholder = addons.mozilla.org ਨੂੰ ਖੋਜੋ
addon-page-options-button =
    .title = ਸਭ ਐਡ-ਆਨ ਲਈ ਟੂਲ
