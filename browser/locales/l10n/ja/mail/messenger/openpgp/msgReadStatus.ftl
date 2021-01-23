# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-view-signer-key =
    .label = 署名者の鍵を表示
openpgp-view-your-encryption-key =
    .label = あなたの復号鍵を表示
openpgp-openpgp = OpenPGP

openpgp-no-sig = デジタル署名がありません
openpgp-uncertain-sig = 不確実なデジタル署名です
openpgp-invalid-sig = デジタル署名が正しくありません
openpgp-good-sig = メッセージは署名されています

openpgp-sig-uncertain-no-key = このメッセージにはデジタル署名が含まれていますが、正当な署名か検証できません。署名を検証するには、送信者の公開鍵のコピーを入手する必要があります。
openpgp-sig-uncertain-uid-mismatch = このメッセージにはデジタル署名が含まれていますが、署名が一致しません。このメッセージは署名者の公開鍵とは一致しないメールアドレスから送信されています。
openpgp-sig-uncertain-not-accepted = このメッセージにはデジタル署名が含まれていますが、署名者の鍵を受け入れるかまだ決定されていません。
openpgp-sig-invalid-rejected = このメッセージにはデジタル署名が含まれていますが、署名者の鍵は既に拒絶されています。
openpgp-sig-invalid-technical-problem = このメッセージにはデジタル署名が含まれていますが、技術的エラーが検出されました。メッセージが破損しているか、第三者によってメッセージが書き換えられています。
openpgp-sig-valid-unverified = このメッセージにはあなたが受け入れた鍵による有効な署名が含まれていますが、その鍵が送信者のものであるか検証されていません。
openpgp-sig-valid-verified = このメッセージには検証済みの鍵による有効な署名が含まれています。
openpgp-sig-valid-own-key = このメッセージにはあなたの個人鍵による有効な署名が含まれています。

openpgp-sig-key-id = 署名者の鍵 ID: { $key }
openpgp-sig-key-id-with-subkey-id = 署名者の鍵 ID: { $key } (副鍵 ID: { $subkey })

openpgp-enc-key-id = あなたの復号鍵 ID: { $key }
openpgp-enc-key-with-subkey-id = あなたの復号鍵 ID: { $key } (副鍵 ID: { $subkey })

openpgp-unknown-key-id = 未知の鍵

openpgp-other-enc-additional-key-ids = また、メッセージは以下の鍵の所有者に向けて暗号化されました:
openpgp-other-enc-all-key-ids = メッセージは以下の鍵の所有者に向けて暗号化されました:
