# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕਰਨ ਲਈ ਸੈਟਿੰਗ
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = ਤਾਜ਼ੇ ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = ਸਭ ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕਰੋ
    .style = width: 34em

clear-data-settings-label = ਜਦੋਂ ਬੰਦ ਹੁੰਦਾ ਹੈ ਤਾਂ { -brand-short-name } ਆਪਣੇ-ਆਪ ਸਭ ਸਾਫ਼ ਕਰਦਾ ਹੈ

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = ਸਾਫ਼ ਕਰਨ ਲਈ ਸਮਾਂ ਸੀਮਾ:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = ਆਖਰੀ ਘੰਟਾ

clear-time-duration-value-last-2-hours =
    .label = ਆਖਰੀ ਦੋ ਘੰਟੇ

clear-time-duration-value-last-4-hours =
    .label = ਆਖਰੀ ਚਾਰ ਘੰਟੇ

clear-time-duration-value-today =
    .label = ਅੱਜ

clear-time-duration-value-everything =
    .label = ਹਰ ਚੀਜ਼

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = ਅਤੀਤ

item-history-and-downloads =
    .label = ਬਰਾਊਜ਼ਿੰਗ ਅਤੇ ਡਾਊਨਲੋਡ ਅਤੀਤ
    .accesskey = B

item-cookies =
    .label = ਕੂਕੀਜ਼
    .accesskey = C

item-active-logins =
    .label = ਸਰਗਰਮ ਲਾਗਇਨ
    .accesskey = L

item-cache =
    .label = ਕੈਸ਼
    .accesskey = A

item-form-search-history =
    .label = ਫਾਰਮ ਅਤੇ ਖੋਜ ਅਤੀਤ
    .accesskey = F

data-section-label = ਮਿਤੀ

item-site-preferences =
    .label = ਸਾਈਟ ਪਸੰਦ
    .accesskey = S

item-offline-apps =
    .label = ਆਫਲਾਈਨ ਵੈੱਬਸਾਈਟ ਡਾਟਾ
    .accesskey = O

sanitize-everything-undo-warning = ਇਹ ਕਾਰਵਾਈ ਵਾਪਿਸ ਨਹੀਂ ਪਰਤਾਈ ਨਹੀਂ ਜਾ ਸਕਦੀ ਹੈ।

window-close =
    .key = w

sanitize-button-ok =
    .label = ਹੁਣੇ ਸਾਫ਼ ਕਰੋ

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = ਸਾਫ਼ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = ਸਭ ਅਤੀਤ ਨੂੰ ਸਾਫ਼ ਕੀਤਾ ਜਾਵੇਗਾ।

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = ਸਭ ਚੁਣੀਆਂ ਆਈਟਮਾਂ ਨੂੰ ਸਾਫ਼ ਕਰ ਦਿੱਤਾ ਜਾਵੇਗਾ।
