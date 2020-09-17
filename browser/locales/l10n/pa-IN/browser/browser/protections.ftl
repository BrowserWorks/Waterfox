# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } ਨੇ ਪਿਛਲੇ ਹਫ਼ਤੇ ਦੌਰਾਨ { $count } ਟਰੈਕਰ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਈ
       *[other] { -brand-short-name } ਨੇ ਪਿਛਲੇ ਹਫ਼ਤੇ ਦੌਰਾਨ { $count } ਟਰੈਕਰਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਈ
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } ਤੋਂ <b>{ $count }</b> ਟਰੈਕਰ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਈ
       *[other] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } ਤੋਂ <b>{ $count }</b> ਟਰੈਕਰਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਈ
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋਆਂ ਵਿੱਚ ਟਰੈਕਰਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਉਣਾ ਜਾਰੀ ਰੱਖਦਾ ਹੈ, ਪਰ ਕਿਸ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਈ ਹੈ, ਇਸ ਦਾ ਰਿਕਾਰਡ ਨਹੀਂ ਰੱਖਦਾ ਹੈ।
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = ਇਸ ਹਫ਼ਤੇ { -brand-short-name } ਵਲੋਂ ਪਾਬੰਦੀ ਲਾਏ ਟਰੈਕਰ

protection-report-webpage-title = ਸੁਰੱਖਿਆ ਡੈਸ਼ਬੋਰਡ
protection-report-page-content-title = ਸੁਰੱਖਿਆ ਡੈਸ਼ਬੋਰਡ
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } ਤੁਹਾਡੇ ਵਲੋਂ ਬਰਾਊਜ਼ ਕਰਨ ਦੇ ਦੌਰਾਨ ਪਰਦੇ ਪਿੱਛੇ ਤੁਹਾਡੀ ਪਰਦੇਦਾਰੀ ਨੂੰ ਸੁਰੱਖਿਅਤ ਕਰਦਾ ਹੈ। ਇਹ ਉਹਨਾਂ ਸੁਰੱਖਿਆਵਾਂ ਦੀ ਨਿੱਜੀ ਬਣਾਈ ਸੰਖੇਪ ਜਾਣਕਾਰੀ ਹੈ, ਜਿਸ ਵਿੱਚ ਤੁਹਾਡੀ ਆਨਲਾਈਨ ਸੁਰੱਖਿਆ ਨੂੰ ਕੰਟਰੋਲ ਕਰਨ ਲਈ ਟੂਲ ਸ਼ਾਮਲ ਹਨ।
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } ਤੁਹਾਡੇ ਵਲੋਂ ਬਰਾਊਜ਼ ਕਰਨ ਦੇ ਦੌਰਾਨ ਪਰਦੇ ਪਿੱਛੇ ਤੁਹਾਡੀ ਪਰਦੇਦਾਰੀ ਨੂੰ ਸੁਰੱਖਿਅਤ ਕਰ ਸਕਦਾ ਹੈ। ਇਹ ਉਹਨਾਂ ਸੁਰੱਖਿਆਵਾਂ ਦੀ ਨਿੱਜੀ ਬਣਾਈ ਸੰਖੇਪ ਜਾਣਕਾਰੀ ਹੈ, ਜਿਸ ਵਿੱਚ ਤੁਹਾਡੀ ਆਨਲਾਈਨ ਸੁਰੱਖਿਆ ਨੂੰ ਕੰਟਰੋਲ ਕਰਨ ਲਈ ਟੂਲ ਸ਼ਾਮਲ ਹਨ।

protection-report-settings-link = ਆਪਣੀ ਪਰਦੇਦਾਰੀ ਅਤੇ ਸੁਰੱਖਿਆ ਸੈਟਿੰਗਾਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ

etp-card-title-always = ਵਾਧਾ ਕੀਤੀ ਟਰੈਕਿੰਗ ਸੁਰੱਖਿਆ: ਹਮੇਸ਼ਾ ਚਾਲੂ
etp-card-title-custom-not-blocking = ਵਾਧਾ ਕੀਤੀ ਟਰੈਕਿੰਗ ਸੁਰੱਖਿਆ: ਬੰਦ
etp-card-content-description = { -brand-short-name } ਵੈੱਬ ਉੱਤੇ ਕੰਪਨੀਆਂ ਨੂੰ ਤੁਹਾਡਾ ਪਿੱਛਾ ਕਰਨ ਤੋਂ ਆਪਣੇ ਆਪ ਰੋਕਦਾ ਹੈ।
protection-report-etp-card-content-custom-not-blocking = ਸਾਰੀਆਂ ਸੁਰੱਖਿਆਵਾਂ ਨੂੰ ਇਸ ਵੇਲੇ ਬੰਦ ਕੀਤਾ ਹੈ। ਆਪਣੀਆਂ { -brand-short-name } ਸੁਰੱਖਿਆ ਸੈਟਿੰਗਾਂ ਦਾ ਇੰਤਾਜ਼ਮ ਕਰਕੇ ਪਾਬੰਦੀ ਲਾਉਣ ਵਾਲੇ ਟਰੈਕਰਾਂ ਨੂੰ ਚੁਣੋ।
protection-report-manage-protections = ਸੈਟਿੰਗਾਂ ਦਾ ਇੰਤਜ਼ਾਮ ਕਰੋ

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = ਅੱਜ

# This string is used to describe the graph for screenreader users.
graph-legend-description = ਗਰਾਫ਼ ਵਿੱਚ ਇਸ ਹਫ਼ਤੇ ਪਾਬੰਦੀ ਲਾਈ ਟਰੈਕਰ ਦੀ ਹਰ ਕਿਸਮ ਦੀ ਕੁੱਲ ਗਿਣਤੀ ਦਿੱਤੀ ਗਈ ਹੈ।

social-tab-title = ਸਮਾਜਿਕ ਮੀਡਿਆ ਟਰੈਕਰ
social-tab-contant = ਸਮਾਜਿਕ ਨੈੱਟਵਰਕ ਹੋਰ ਵੈੱਬਸਾਈਟਾਂ ਉੱਤੇ ਟਰੈਕਰ (ਸੂਹੀਏ) ਲਾ ਦਿੰਦੀਆਂ ਹਨ, ਜੋ ਕਿ ਆਨਲਾਈਨ ਤੁਸੀਂ ਕੀ ਕਰਦੇ ਹੋ, ਕੀ ਵੇਖਦੇ ਹੋ, ਦਾ ਪਿੱਛਾ ਕਰਦੇ ਹਨ। ਇਹ ਸਮਾਜਿਕ ਮੀਡੀਆ ਕੰਪਨੀਆਂ ਨੂੰ ਤੁਹਾਡੇ ਬਾਰੇ ਉਹ ਵੀ ਸਿੱਖਣ ਲਈ ਮਦਦ ਕਰਦੇ ਹਨ, ਜੋ ਕਿ ਤੁਸੀਂ ਆਪਣੇ ਸਮਾਜਿਕ ਮੀਡਿਆ ਪਰੋਫਾਈਲਾਂ ਉੱਤੇ ਸਾਂਝਾ ਨਹੀਂ ਕਰਦੇ ਹੋ। <a data-l10n-name="learn-more-link">ਹੋਰ ਸਿੱਖੋ</a>

cookie-tab-title = ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕਿੰਗ ਕੂਕੀਜ਼
cookie-tab-content = ਇਹ ਕੂਕੀਜ਼ ਤੁਹਾਡੇ ਆਨਲਾਈਨ ਕੀਤੇ ਜਾਣ ਵਾਲੇ ਕੰਮ ਬਾਰੇ ਡਾਟਾ ਇਕੱਤਰ ਕਰਨ ਲਈ ਇੱਕ ਤੋਂ ਦੂਜੀ ਸਾਈਟ ਉੱਤੇ ਤੁਹਾਡਾ ਪਿੱਛਾ ਕਰਦੇ ਹਨ। ਇਹ ਸੁਤੰਤਰ ਧਿਰਾਂ ਜਿਵੇਂ ਇਸ਼ਤਿਹਾਰ ਬਣਾਉਣ ਵਾਲੀਆਂ ਅਤੇ ਅੰਕੜੇ ਇਕੱਤਰ ਵਾਲੀਆਂ ਕੰਪਨੀਆਂ ਵਲੋਂ ਬਣਾਏ ਜਾਂਦੇ ਹਨ। ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕਿੰਗ ਕੂਕੀਜ਼ ਉੱਤੇ ਪਾਬੰਦੀ ਲਗਾਉਣ ਨਾਲ ਤੁਹਾਡਾ ਪਿੱਛੇ ਕਰਨ ਵਾਲੇ ਇਸ਼ਤਿਹਾਰਾਂ ਦੀ ਗਿਣਤੀ ਘੱਟਦੀ ਹੈ। <a data-l10n-name="learn-more-link">ਹੋਰ ਜਾਣੋ</a>

tracker-tab-title = ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ
tracker-tab-description = ਵੈੱਬਸਾਈਟਾਂ ਟਰੈਕਿੰਗ ਕੋਡ ਨਾਲ ਬਾਹਰੀ ਇਸ਼ਤਿਹਾਰਾਂ, ਵੀਡਿਓ ਅਤੇ ਹੋਰ ਭਾਗਾਂ ਨੂੰ ਲੋਡ ਕਰ ਸਕਦੀਆਂ ਹਨ। ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ ਉੱਤੇ ਪਾਬੰਦੀ ਲਗਾਉਣਾ ਸਾਈਟਾਂ ਨੂੰ ਤੇਜ਼ੀ ਨਾਲ ਲੋਡ ਕਰਨ ਮਦਦ ਸਕਦਾ ਹੈ, ਪਰ ਕੁਝ ਬਟਨ, ਫਾਰਮ ਅਤੇ ਲਾਗਇਨ ਖੇਤਰ ਠੀਕ ਤਰ੍ਹਾਂ ਕੰਮ ਨਹੀਂ ਸਕਦੇ ਹਨ। <a data-l10n-name="learn-more-link">ਹੋਰ ਜਾਣੋ</a>

fingerprinter-tab-title = ਫਿੰਗਰਪਰਿੰਟਰ
fingerprinter-tab-content = ਫਿੰਗਰਪਰਿੰਟਰ ਤੁਹਾਡੇ ਬਾਰੇ ਪਰੋਫਾਈਲ ਬਣਾਉਣ ਲਈ ਤੁਹਾਡੇ ਬਰਾਊਜ਼ਰ ਅਤੇ ਕੰਪਿਊਟਰ ਤੋਂ ਸੈਟਿੰਗਾਂ ਇਕੱਤਰ ਕਰਦੇ ਹਨ। ਇਹ ਡਿਜ਼ਿਟਲ ਫਿੰਗਰਪਰਿੰਟ ਵਰਤ ਕੇ ਉਹ ਤੁਹਾਨੂੰ ਵੱਖੋ-ਵੱਖ ਵੈੱਬਸਾਈਟਾਂ ਦੁਆਲੇ ਟਰੈਕ ਕਰ ਸਕਦੇ ਹਨ। <a data-l10n-name="learn-more-link">ਹੋਰ ਸਿੱਖੋ</a>

cryptominer-tab-title = ਕ੍ਰਿਪਟੋਮਾਈਨਰ
cryptominer-tab-content = ਕ੍ਰਿਪਟੋਮਾਈਨਰ ਡਿਜ਼ਿਟਲ ਧਨ ਦੀ ਟਕਸਾਲ ਦੇ ਰੂਪ ਵਿੱਚ ਤੁਹਾਡੇ ਕੰਪਿਊਟਰ ਦੀ ਊਰਜਾ ਨੂੰ ਗੁਪਤ ਰੂਪ ਵਿੱਚ ਵਰਤਦੇ ਹਨ। ਕ੍ਰਿਪਟੋਮਾਈਨਰ ਸਕ੍ਰਿਪਟ ਤੁਹਾਡੀ ਬੈਟਰੀ ਖਪਾਉਂਦੀਆਂ ਹਨ, ਤੁਹਾਡੇ ਕੰਪਿਊਟਰ ਨੂੰ ਹੌਲੀ ਕਰਦੀਆਂ ਹਨ ਅਤੇ ਤੁਹਾਡੇ ਬਿਜਲੀ ਦੇ ਬਿੱਲ ‘ਚ ਵੀ ਵਾਧਾ ਕਰ ਸਕਦੀਆਂ ਹਨ। <a data-l10n-name="learn-more-link">ਹੋਰ ਜਾਣੋ</a>

protections-close-button2 =
    .aria-label = ਬੰਦ ਕਰੋ
    .title = ਬੰਦ ਕਰੋ
  
mobile-app-title = ਹੋਰ ਡਿਵਾਈਸਾਂ ਵਿੱਚ ਇਸ਼ਤਿਹਾਰ ਟਰੈਕਰਾਂ ਉੱਤੇ ਪਾਬੰਦੀ ਲਾਓ
mobile-app-card-content = ਇਸ਼ਤਿਹਾਰੀ ਟਰੈਕਰਾਂ ਦੇ ਵਿਰੁਧ ਸੁਰੱਖਿਆ ਦੇ ਸਮੇਤ ਮੋਬਾਈਲ ਬਰਾਊਜ਼ਰ ਵਰਤੋਂ।
mobile-app-links = <a data-l10n-name="android-mobile-inline-link">ਐਂਡਰਾਈਡ</a> ਅਤੇ <a data-l10n-name="ios-mobile-inline-link">iOS</a> ਲਈ { -brand-product-name } ਬਰਾਊਜ਼ਰ

lockwise-title = ਮੁੜ ਕੇ ਪਾਸਵਰਡ ਕਦੇ ਵੀ ਨਾ ਭੁੱਲੋ
lockwise-title-logged-in2 = ਪਾਸਵਰਡ ਇੰਤਜ਼ਾਮ
lockwise-header-content = { -lockwise-brand-name } ਤੁਹਾਡੇ ਬਰਾਊਜ਼ਰ ‘ਚ ਤੁਹਾਡੇ ਪਾਸਵਰਡਾਂ ਨੂੰ ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਸੰਭਾਲਦਾ ਹੈ।
lockwise-header-content-logged-in = ਆਪਣੇ ਸਾਰੇ ਡਿਵਾਈਸਾਂ ‘ਚ ਆਪਣੇ ਪਾਸਵਰਡਾਂ ਨੂੰ ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਸੰਭਾਲੋ ਅਤੇ ਸਿੰਕ ਕਰੋ।
protection-report-save-passwords-button = ਪਾਸਵਰਡ ਸੰਭਾਲੋ
    .title = { -lockwise-brand-short-name } ਵਿੱਚ ਪਾਸਵਰਡ ਸੰਭਾਲੋ
protection-report-manage-passwords-button = ਪਾਸਵਰਡਾਂ ਦਾ ਇੰਤਜ਼ਾਮ
    .title = { -lockwise-brand-short-name } ਵਿੱਚ ਪਾਸਵਰਡਾਂ ਦਾ ਇੰਤਜ਼ਾਮ
lockwise-mobile-app-title = ਆਪਣੇ ਪਾਸਵਰਡ ਹਰ ਥਾਂ ਲੈ ਜਾਓ
lockwise-no-logins-card-content = { -brand-short-name } ਵਿੱਚ ਸੰਭਾਲੇ ਪਾਸਵਰਡ ਕਿਸੇ ਵੀ ਡਿਵਾਈਸ ਉੱਤੇ ਵਰਤੋਂ।
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">ਐਂਡਰਾਈਂਡ</a> ਅਤੇ <a data-l10n-name="lockwise-ios-inline-link">iOS</a> ਲਈ { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 ਪਾਸਵਰਡ ਡਾਟਾ ਸੰਨ੍ਹ ਵਿੱਚ ਜ਼ਾਹਰ ਹੋ ਸਕਦਾ ਹੈ।
       *[other] { $count } ਪਾਸਵਰਡ ਡਾਟਾ ਸੰਨ੍ਹ ਵਿੱਚ ਜ਼ਾਹਰ ਹੋ ਸਕਦੇ ਹਨ।
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 ਪਾਸਵਰਡ ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਸੰਭਾਲਿਆ।
       *[other] ਤੁਹਾਡੇ ਪਾਸਵਰਡ ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਸੰਭਾਲੇ ਜਾ ਰਹੇ ਹਨ।
    }
lockwise-how-it-works-link = ਇਹ ਕਿਵੇਂ ਕੰਮ ਕਰਦਾ ਹੈ

turn-on-sync = { -sync-brand-short-name } ਚਾਲੂ ਕਰੋ…
    .title = ਸਿੰਕ ਪਸੰਦਾਂ ‘ਤੇ ਜਾਓ

monitor-title = ਡਾਟੇ ‘ਚ ਸੰਨ੍ਹ ਲੱਗਣ ਦੀ ਖੋਜ ਕਰੋ
monitor-link = ਇਹ ਕਿਵੇਂ ਕੰਮ ਕਰਦਾ ਹੈ
monitor-header-content-no-account = { -monitor-brand-name } ਨਾਲ ਪਤਾ ਕਰੋ ਕਿ ਕੀ ਤੁਸੀਂ ਕਿਸੇ ਜਾਣੇ-ਪਛਾਣੇ ਡਾਟਾ ਸੰਨ੍ਹ ਦਾ ਹਿੱਸਾ ਹੋ ਅਤੇ ਨਵੇਂ ਲੱਗੇ ਸੰਨ੍ਹਾਂ ਬਾਰੇ ਖ਼ਬਰਦਾਰ ਵੀ ਰਹੋ।
monitor-header-content-signed-in = { -monitor-brand-name } ਤੁਹਾਨੂੰ ਸਾਵਧਾਨ ਕਰੇਗਾ, ਜੇ ਤੁਹਾਡੀ ਜਾਣਕਾਰੀ ਕਿਸੇ ਪਤਾ ਲੱਗੀ ਡਾਟਾ ਸੰਨ੍ਹ ‘ਚ ਲੱਭਿਆ ਗਿਆ।
monitor-sign-up-link = ਸੰਨ੍ਹ ਲੱਗਣ ਚੇਤਾਵਨੀਆਂ ਲਈ ਸਾਈਨ ਅੱਪ ਕਰੋ
    .title = { -monitor-brand-name } ਨਾਲ ਸੰਨ੍ਹ ਲੱਗਣ ਚੇਤਾਵਨੀਆਂ ਲਈ ਸਾਈਨ ਅੱਪ ਕਰੋ
auto-scan = ਅੱਜ ਆਪਣੇ-ਆਪ ਸਕੈਨ ਕੀਤਾ

monitor-emails-tooltip =
    .title = { -monitor-brand-short-name } ਨਾਲ ਨਿਗਰਾਨੀ ਕੀਤੇ ਈਮੇਲ ਵੇਖੋ
monitor-breaches-tooltip =
    .title = { -monitor-brand-short-name } ਰਾਹੀਂ ਪਤਾ ਲਾਈਆਂ ਡਾਟਾ ਸੰਨ੍ਹਾਂ ਨੂੰ ਵੇਖੋ
monitor-passwords-tooltip =
    .title = { -monitor-brand-short-name } ਰਾਹੀਂ ਜ਼ਾਹਰ ਗਏ ਪਾਸਵਰਡ ਵੇਖੋ

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] ਈਮੇਲ ਸਿਰਨਾਵੇਂ ਦੀ ਨਿਗਰਾਨੀ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ
       *[other] ਈਮੇਲ ਸਿਰਨਾਵਿਆਂ ਦੀ ਨਿਗਰਾਨੀ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] ਪਤਾ ਲੱਗੀ ਡਾਟਾ ਸੰਨ੍ਹ ‘ਚ ਤੁਹਾਡੀ ਜਾਣਕਾਰੀ ਨਸ਼ਰ ਹੈ
       *[other] ਪਤਾ ਲੱਗੀਆਂ ਡਾਟਾ ਸੰਨ੍ਹ ‘ਚ ਤੁਹਾਡੀ ਜਾਣਕਾਰੀ ਨਸ਼ਰ ਹੈ
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] ਜਾਣੀ-ਪਛਾਣੀ ਡਾਟਾ ਸੰਨ੍ਹ ਨੂੰ ਹੱਲ ਕੀਤੀ ਨਿਸ਼ਾਨੀ ਲਾਓ
       *[other] ਜਾਣੀਆਂ-ਪਛਾਣੀਆਂ ਡਾਟਾ ਸੰਨ੍ਹਾਂ ਨੂੰ ਹੱਲ ਕੀਤੀ ਨਿਸ਼ਾਨੀ ਲਾਓ
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] ਪਾਸਵਰਡ ਸਾਰੀਆਂ ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ‘ਚ ਨਸ਼ਰ ਹੈ
       *[other] ਪਾਸਵਰਡ ਸਾਰੀਆਂ ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ‘ਚ ਨਸ਼ਰ ਹਨ
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] ਨਾ ਹੱਲ ਕੀਤੀਆਂ ਸੰਨ੍ਹਾਂ ਵਿੱਚ ਨਸ਼ਰ ਹੋਇਆ ਪਾਸਵਰਡ
       *[other] ਨਾ ਹੱਲ ਕੀਤੀਆਂ ਸੰਨ੍ਹਾਂ ਵਿੱਚ ਨਸ਼ਰ ਹੋਏ ਪਾਸਵਰਡ
    }

monitor-no-breaches-title = ਚੰਗੀ ਖ਼ਬਰ ਹੈ!
monitor-no-breaches-description = ਤੁਹਾਡੇ ਲਈ ਕੋਈ ਸੰਨ੍ਹ ਨਹੀਂ ਲੱਗੀ ਹੈ। ਜੇ ਕੋਈ ਲੱਗੀ ਤਾਂ ਅਸੀਂ ਤੁਹਾਨੂੰ ਦੱਸਾਂਗੇ।
monitor-view-report-link = ਰਿਪੋਰਟ ਵੇਖੋ
    .title = { -monitor-brand-short-name } ਰਾਹੀਂ ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ਬੰਦ ਕਰੋ
monitor-breaches-unresolved-title = ਆਪਣੀਆਂ ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ਨੂੰ ਹੱਲ ਕਰੋ
monitor-breaches-unresolved-description = ਲੱਗੀ ਸੰਨ੍ਹ ਦੇ ਵੇਰਵੇਖਣ ਅਤੇ ਆਪਣੀ ਜਾਣਕਾਰੀ ਨੂੰ ਸੁਰੱਖਿਅਤ ਕਰਨ ਲਈ ਕਦਮ ਚੁੱਖਣ ਦੇ ਬਾਅਦ ਤੁਸੀਂ ਸੰਨ੍ਹ ਨੂੰ ਹੱਲ ਹੋਣ ਦਾ ਨਿਸ਼ਾਨ ਲਾ ਸਕਦੇ ਹੋ।
monitor-manage-breaches-link = ਸੰਨ੍ਹਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
    .title = { -monitor-brand-short-name } ਰਾਹੀਂ ਸੰਨ੍ਹਾਂ ਦਾ ਬੰਦੋਬਸਤ ਕਰੋ
monitor-breaches-resolved-title = ਵਧੀਆ! ਤੁਸੀਂ ਸਾਰੇ ਜਾਣੀਆਂ-ਪਛਾਣੀਆਂ ਸੰਨ੍ਹਾਂ ਨੂੰ ਹੱਲ ਕਰ ਚੁੱਕੇ ਹੋ।
monitor-breaches-resolved-description = ਜੇ ਤੁਹਾਡਾ ਈਮੇਲ ਕਿਸੇ ਨਵੀਂ ਲੱਗੀ ਸੰਨ੍ਹ ਵਿੱਚ ਦਿਖਾਈ ਦਿੱਤੀ ਤਾਂ ਅਸੀਂ ਤੁਹਾਨੂੰ ਦੱਸਾਂਗੇ।

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreaches } ਸੰਨ੍ਹਾਂ ਵਿੱਚੋਂ { $numBreachesResolved } ਨੂੰ ਹੱਲ਼ ਨਿਸ਼ਾਨ ਲਾਓ
       *[other] { $numBreaches } ਸੰਨ੍ਹਾਂ ਵਿੱਚੋਂ { $numBreachesResolved } ਨੂੰ ਹੱਲ਼ ਨਿਸ਼ਾਨ ਲਾਓ
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% ਪੂਰਾ

monitor-partial-breaches-motivation-title-start = ਬਹੁਤ ਵਧੀਆ ਸ਼ੁਰੂਆਤ!
monitor-partial-breaches-motivation-title-middle = ਇੰਝ ਹੀ ਰੱਖੋ!
monitor-partial-breaches-motivation-title-end = ਲਗਭਗ ਹੋ ਗਿਆ! ਇੰਝ ਹੀ ਰੱਖੋ।
monitor-partial-breaches-motivation-description = ਆਪਣੇ ਬਾਕੀ ਰਹਿੰਦੀਆਂ ਸੰਨ੍ਹਾਂ ਨੂੰ { -monitor-brand-short-name } ਰਾਹੀਂ ਹੱਲ ਕਰੋ।
monitor-resolve-breaches-link = ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ਨੂੰ ਹੱਲ ਕਰੋ
    .title = { -monitor-brand-short-name } ਰਾਹੀਂ ਲੱਗੀਆਂ ਸੰਨ੍ਹਾਂ ਨੂੰ ਹੱਲ ਕਰੋ

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = ਸਮਾਜਿਕ ਮੀਡਿਆ ਟਰੈਕਰ
    .aria-label =
        { $count ->
            [one] { $count } ਸਮਾਜਿਕ ਮੀਡਿਆ ਟਰੈਕਰ ({ $percentage }%)
           *[other] { $count } ਸਮਾਜਿਕ ਮੀਡਿਆ ਟਰੈਕਰ ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕ ਕਰਨ ਵਾਲੇ ਕੂਕੀਜ਼
    .aria-label =
        { $count ->
            [one] { $count } ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕ ਕਰਨ ਵਾਲਾ ਕੂਕੀਜ਼ ({ $percentage }%)
           *[other] { $count } ਅੰਤਰ-ਸਾਈਟ ਟਰੈਕ ਕਰਨ ਵਾਲੇ ਕੂਕੀਜ਼ ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ
    .aria-label =
        { $count ->
            [one] { $count } ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ ({ $percentage }%)
           *[other] { $count } ਟਰੈਕਿੰਗ ਸਮੱਗਰੀ ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = ਫਿੰਗਰਪਰਿੰਟਰ
    .aria-label =
        { $count ->
            [one] { $count } ਫਿੰਗਰਪਰਿੰਟਰ ({ $percentage }%)
           *[other] { $count } ਫਿੰਗਰਪਰਿੰਟਰ ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = ਕ੍ਰਿਪਟੋ-ਮਾਈਨਰ
    .aria-label =
        { $count ->
            [one] { $count } ਕ੍ਰਿਪਟੋ-ਮਾਈਨਰ ({ $percentage }%)
           *[other] { $count } ਕ੍ਰਿਪਟੋ-ਮਾਈਨਰ ({ $percentage }%)
        }
