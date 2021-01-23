# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = ਪਰੋਫਾਈਲ ਨਿਰਮਾਣ ਸਹਾਇਕ
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] ਜਾਣ-ਪਛਾਣ
       *[other] { create-profile-window.title } ਵਲੋਂ ਜੀ ਆਇਆਂ ਨੂੰ
    }

profile-creation-explanation-1 = { -brand-short-name } ਤੁਹਾਡੀ ਸੈਟਿੰਗ ਅਤੇ ਪਸੰਦ ਨੂੰ ਤੁਹਾਡੇ ਨਿੱਜੀ ਪਰੋਫਾਈਲ ਵਿੱਚ ਸੰਭਾਲ ਕੇ ਰੱਖਦਾ ਹੈ

profile-creation-explanation-2 = ਜੇਕਰ ਤੁਸੀਂ { -brand-short-name } ਦੀ ਇਸ ਕਾਪੀ ਨੂੰ ਹੋਰ ਯੂਜ਼ਰਾਂ ਨਾਲ ਸਾਂਝਾ ਕਰਦੇ ਹੋ ਤਾਂ ਤੁਸੀਂ ਹਰ ਵਰਤੋਂਕਾਰ ਦੀ ਜਾਣਕਾਰੀ ਇੱਕ ਵੱਖਰੇ ਪਰੋਫਾਈਲ ਵਿੱਚ ਰੱਖ ਸਕਦੇ ਹੋ। ਇਸ ਤਰਾਂ ਕਰਨ ਲਈ  ਹਰ ਵਰਤੋਂਕਾਰ ਨੂੰ  ਆਪਣਾ ਵੱਖਰਾ ਪਰੋਫਾਈਲ ਬਣਾਉਣਾ ਚਾਹੀਦਾ ਹੈ।

profile-creation-explanation-3 = ਜੇਕਰ ਤੁਸੀਂ ਇੱਕਲੇ ਹੀ { -brand-short-name } ਦਾ ਇਸਤੇਮਾਲ ਕਰ ਰਹੇ ਹੋ, ਤਾਂ ਤੁਹਾਨੂੰ ਘੱਟੋ-ਘੱਟ ਇੱਕ ਪਰੋਫਾਈਲ ਚਾਹੀਦਾ ਹੈ। ਜੇਕਰ ਤੁਹਾਨੂੰ ਪਸੰਦ ਹੋਵੇ ਤਾਂ ਤੁਸੀਂ ਆਪਣੇ ਲਈ ਵੱਖਰੀ ਵੱਖਰੀ ਸੈਟਿੰਗ ਤੇ ਪਸੰਦ ਸੰਭਾਲਣ ਲਈ ਕਈ ਪਰੋਫਾਈਲ ਬਣਾ ਸਕਦੇ ਹੋ। ਉਦਾਹਰਨ ਲਈ, ਵਪਾਰ ਲਈ ਅਤੇ ਨਿੱਜੀ ਇਸਤੇਮਾਲ ਲਈ ਵੱਖਰੇ ਪਰੋਫਾਈਲ ਬਣਾ ਸਕਦੇ ਹੋ।

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] ਆਪਣਾ ਪਰੋਫਾਈਲ ਬਣਾਉਣ ਲਈ, ਜਾਰੀ ਰੱਖੋ ਦੱਬੋ।
       *[other] ਪਰੋਫਾਈਲ ਬਣਾਉਣ ਲਈ ਅੱਗੇ ਨੂੰ ਦੱਬੋ
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] ਹੱਲ
       *[other] { create-profile-window.title } ਮੁਕੰਮਲ
    }

profile-creation-intro = ਜੇਕਰ ਤੁਸੀਂ ਕਈ ਪਰੋਫਾਈਲ ਬਣਾਏ ਤਾਂ ਤੁਸੀਂ ਉਹਨਾਂ ਨੂੰ ਪਰੋਫਾਈਲ ਨਾਂ ਨਾਲ ਸੰਬੋਧਨ ਕਰ ਸਕਦੇ ਹੋ। ਤੁਸੀਂ ਇੱਥੇ ਦਿੱਤਾ ਨਾਂ ਇਸਤੇਮਾਲ ਕਰ ਸਕਦੇ ਹੋ ਜਾਂ ਆਪਣਾ ਵੱਖਰਾ ਵੀ ਇਸਤੇਮਾਲ ਕਰ ਸਕਦੇ ਹੋ।

profile-prompt = ਪਰੋਫਾਈਲ ਨਾਂ ਦਿਓ:
    .accesskey = E

profile-default-name =
    .value = ਡਿਫਾਲਟ ਵਰਤੋਂਕਾਰ

profile-directory-explanation = ਤੁਹਾਡੀ ਵਰਤੋਂਕਾਰ ਸੈਟਿੰਗ, ਪਸੰਦ ਅਤੇ ਹੋਰ ਵਰਤੋਂਕਾਰ-ਨਾਲ ਸਬੰਧਿਤ ਡਾਟਾ ਇਸ ਵਿੱਚ ਸਟੋਰ ਕੀਤਾ ਜਾਵੇਗਾ:

create-profile-choose-folder =
    .label = …ਫੋਲਡਰ ਚੁਣੋ
    .accesskey = C

create-profile-use-default =
    .label = ਡਿਫਾਲਟ ਫੋਲਡਰ ਵਰਤੋਂ
    .accesskey = U
