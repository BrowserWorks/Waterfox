# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] PIN コードが正しくありません。この端末の資格情報へのアクセスが永久に失われるまでの試行回数は残り { $retriesLeft } 回です。
       *[other] PIN コードが正しくありません。この端末の資格情報へのアクセスが永久に失われるまでの試行回数は残り { $retriesLeft } 回です。
    }
webauthn-pin-invalid-short-prompt = PIN コードが正しくありません。再度入力してください。
webauthn-pin-required-prompt = 端末の PIN コードを入力してください。
# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] ユーザー確認に失敗しました。残り { $retriesLeft } 回まで試すことができます。
       *[other] ユーザー確認に失敗しました。残り { $retriesLeft } 回まで試すことができます。
    }
webauthn-uv-invalid-short-prompt = ユーザー確認に失敗しました。もう一度試してください。
