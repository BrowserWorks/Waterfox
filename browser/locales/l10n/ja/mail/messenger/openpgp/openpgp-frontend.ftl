# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP 鍵マネージャー
    .accesskey = O

openpgp-ctx-decrypt-open =
    .label = 復号して開く
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = 復号して名前を付けて保存...
    .accesskey = C
openpgp-ctx-import-key =
    .label = OpenPGP 鍵のインポート
    .accesskey = I
openpgp-ctx-verify-att =
    .label = 署名を検証
    .accesskey = V

openpgp-has-sender-key = このメッセージには送信者の OpenPGP 公開鍵が含まれています。
openpgp-be-careful-new-key =
    警告: このメッセージに含まれる新しい OpenPGP 公開鍵は、{ $email } のものとしてあなたが以前に受け入れた公開鍵と異なります。

openpgp-import-sender-key =
    .label = インポート...

openpgp-search-keys-openpgp =
    .label = OpenPGP 鍵を検索

openpgp-missing-signature-key = このメッセージはあなたが所有していない鍵で署名されています。

openpgp-search-signature-key =
    .label = 検索...

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = このメッセージは、おそらく MS-Exchange によって破損した OpenPGP メッセージです。このメッセージはローカルファイルから開かれたため修復できません。メッセージをメールフォルダーにコピーして自動修復を試みてください。
openpgp-broken-exchange-info = このメッセージは、おそらく MS-Exchange によって破損した OpenPGP メッセージです。メッセージの内容が意図したものでない場合、自動修復を試みることができます。
openpgp-broken-exchange-repair =
    .label = メッセージを修復
openpgp-broken-exchange-wait = しばらくお待ちください...

openpgp-cannot-decrypt-because-mdc =
    これは、古く脆弱性のあるメカニズムによって暗号化されたメッセージです。
    そのため、メッセージの内容を傍受するために通信途中で書き換えられているおそれがあります。
    この危険性を回避するため、メッセージの内容は表示されません。

openpgp-cannot-decrypt-because-missing-key =
    このメッセージの復号のために必要な鍵は利用できません。

openpgp-partially-signed =
    このメッセージの一部のみが OpenPGP によってデジタル署名されています。
    検証ボタンをクリックすると、保護されていない部分が隠され、デジタル署名の状態が表示されます。

openpgp-partially-encrypted =
    このメッセージの一部のみが OpenPGP によって暗号化されています。
    既に表示されているメッセージの可読部分は暗号化されていません。
    復号ボタンをクリックすると、暗号化された部分の内容が表示されます。

openpgp-reminder-partial-display = 注意: 以下に表示されているメッセージは元のメッセージの一部のみです。

openpgp-partial-verify-button = 検証
openpgp-partial-decrypt-button = 復号

