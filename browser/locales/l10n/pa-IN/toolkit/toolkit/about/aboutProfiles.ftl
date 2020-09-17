# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = ਪਰੋਫਾਈਲਾਂ ਬਾਰੇ
profiles-subtitle = ਇਹ ਸਫ਼ਾ ਤੁਹਾਨੂੰ ਆਪਣੇ ਪਰੋਫਾਈਲਾਂ ਦੇ ਪਰਬੰਧ ਕਰਨ ਲਈ ਮਦਦ ਕਰਦਾ ਹੈ। ਹਰ ਪਰੋਫਾਈਲ ਪੂਰੀ ਤਰ੍ਹਾਂ ਵੱਖਰਾ ਹੁੰਦਾ ਹੈ, ਜਿਸ ਵਿੱਚ ਵੱਖਰਾ ਅਤੀਤ, ਬੁੱਕਮਰਾਕ, ਸੈਟਿੰਗਾਂ ਅਤੇ ਐਡ-ਆਨ ਹੁੰਦੇ ਹਨ।
profiles-create = ਨਵਾਂ ਪਰੋਫਾਈਲ ਬਣਾਓ
profiles-restart-title = ਮੁੜ-ਸ਼ੁਰੂ ਕਰੋ
profiles-restart-in-safe-mode = …ਐਡ-ਆਨ ਅਸਮਰੱਥ ਕਰਕੇ ਮੁੜ-ਸ਼ੁਰੂ ਕਰੋ
profiles-restart-normal = …ਆਮ ਵਾਂਗ ਮੁੜ-ਸ਼ੁਰੂ ਕਰੋ
profiles-flush-fail-title = ਤਬਦੀਲੀਆਂ ਨਹੀਂ ਸੰਭਾਲੀਆਂ
profiles-flush-conflict = { profiles-conflict }
profiles-flush-restart-button = { -brand-short-name } ਨੂੰ ਮੁੜ-ਚਾਲੂ ਕਰੋ

# Variables:
#   $name (String) - Name of the profile
profiles-name = ਪਰੋਫਾਈਲ: { $name }
profiles-is-default = ਮੂਲ ਪਰੋਫਾਈਲ
profiles-rootdir = ਰੂਟ ਡਾਇਰੈਕਟਰੀ

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = ਲੋਕਲ ਡਾਇਰੈਕਟਰੀ
profiles-current-profile = ਇਹ ਪਰੋਫਾਈਲ ਵਰਤੋਂ ਅਧੀਨ ਹੈ ਅਤੇ ਹਟਾਇਆ ਨਹੀਂ ਜਾ ਸਕਦਾ ਹੈ।

profiles-rename = ਨਾਂ-ਬਦਲੋ
profiles-remove = ਹਟਾਓ
profiles-set-as-default = ਮੂਲ ਪਰੋਫਾਈਲ ਵਜੋਂ ਸੈੱਟ ਕਰੋ
profiles-launch-profile = ਨਵੇਂ ਬਰਾਊਜ਼ਰ ਵਿੱਚ ਪਰੋਫਾਈਲ ਨੂੰ ਚਲਾਓ

profiles-cannot-set-as-default-title = ਡਿਫਾਲਟ ਬਣਾਉਣ ਲਈ ਅਸਮਰੱਥ
profiles-cannot-set-as-default-message = { -brand-short-name } ਲਈ ਡਿਫਾਲਟ ਪਰੋਫਾਈਲ ਬਦਲਿਆ ਨਹੀਂ ਜਾ ਸਕਦਾ ਹੈ।

profiles-yes = ਹਾਂ
profiles-no = ਨਾਂਹ

profiles-rename-profile-title = ਪਰੋਫਾਈਲ ਦਾ ਨਾਂ ਬਦਲੋ
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } ਪਰੋਫਾਈਲ ਦਾ ਨਾਂ ਬਦਲੋ

profiles-invalid-profile-name-title = ਅਢੁੱਕਵਾਂ ਪਰੋਫਾਈਲ ਨਾਂ
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = ਪਰੋਫਾਈਲ ਨਾਂ "{ $name }" ਦੀ ਇਜਾਜ਼ਤ ਨਹੀਂ ਹੈ।

profiles-delete-profile-title = ਪਰੋਫਾਈਲ ਨੂੰ ਹਟਾਓ
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    ਪਰੋਫਾਈਲ ਨੂੰ ਹਟਾਉਣ ਨਾਲ ਇਸ ਨੂੰ ਮੌਜੂਦਾ ਪਰੋਫਾਈਲ ਦੀ ਸੂਚੀ ਵਿੱਚ ਹਟਾਇਆ ਜਾਵੇਗਾ ਅਤੇ ਕਾਰਵਾਈ ਵਾਪਸ ਨਹੀਂ ਕੀਤੀ ਜਾ ਸਕਦੀ ਹੈ।
    ਤੁਸੀਂ ਪਰੋਫਾਈਲ ਡਾਟਾ ਫਾਇਲਾਂ ਨੂੰ ਹਟਾਉਣ ਦੀ ਵੀ ਚੋਣ ਕਰ ਸਕਦੇ ਹੋ, ਜਿਸ ਵਿੱਚ ਤੁਹਾਡੀਆਂ ਸੈਟਿੰਗਾਂ, ਸਰਟੀਫਿਕੇਟ ਅਤੇ ਵਰਤੋਂਕਾਰ ਨਾਲ ਸੰਬੰਧਿਤ ਡਾਟਾ ਸ਼ਾਮਲ ਹੈ। ਇਹ ਚੋਣ "{ $dir }" ਫੋਲਡਰ ਨੂੰ ਹਟਾਏਗੀ ਅਤੇ ਵਾਪਸ ਨਹੀਂ ਕੀਤੀ ਜਾ ਸਕਦੀ ਹੈ।
    ਕੀ ਤੁਸੀਂ ਪਰੋਫਾਈਲ ਡਾਟਾ ਫਾਇਲਾਂ ਨੂੰ ਹਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?
profiles-delete-files = ਫਾਇਲਾਂ ਨੂੰ ਹਟਾਓ
profiles-dont-delete-files = ਫਾਇਲਾਂ ਨੂੰ ਨਾ ਹਟਾਓ

profiles-delete-profile-failed-title = ਗਲਤੀ
profiles-delete-profile-failed-message = ਇਹ ਪਰੋਫਾਈਲ ਹਟਾਉਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਦੌਰਾਨ ਗਲਤੀ ਸੀ।


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder ਵਿੱਚ ਵੇਖੋ
        [windows] ਫੋਲਡਰ ਨੂੰ ਖੋਲ੍ਹੋ
       *[other] ਡਾਇਰੈਕਟਰੀ ਨੂੰ ਖੋਲ੍ਹੋ
    }
