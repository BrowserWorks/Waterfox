# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = 保存された住所
autofill-manage-addresses-list-header = 住所
autofill-manage-credit-cards-title = 保存されたクレジットカード情報
autofill-manage-credit-cards-list-header = クレジットカード情報
autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = 削除
autofill-manage-add-button = 追加...
autofill-manage-edit-button = 編集...

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = 新しい住所の追加
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = 住所の編集
autofill-address-given-name = 名
autofill-address-additional-name = ミドルネーム
autofill-address-family-name = 氏
autofill-address-organization = 組織名
autofill-address-street = 番地・通り名

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = 地域
# Used in MY
autofill-address-village-township = 村または郡区
autofill-address-island = 島
# Used in IE
autofill-address-townland = タウンランド

## address-level-2 names

autofill-address-city = 市
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = 区
# Used in GB, NO, SE
autofill-address-post-town = ポストタウン
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = 地区

## address-level-1 names

autofill-address-province = 県
autofill-address-state = 州
autofill-address-county = 国
# Used in BB, JM
autofill-address-parish = 郡
# Used in JP
autofill-address-prefecture = 都道府県
# Used in HK
autofill-address-area = 地区
# Used in KR
autofill-address-do-si = 道/市
# Used in NI, CO
autofill-address-department = 管区
# Used in AE
autofill-address-emirate = 管轄区
# Used in RU and UA
autofill-address-oblast = 州

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = 郵便番号
autofill-address-zip = ZIP Code
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = 国または地域
autofill-address-tel = 電話番号
autofill-address-email = メールアドレス
autofill-cancel-button = キャンセル
autofill-save-button = 保存
autofill-country-warning-message = 現在、フォーム自動入力機能は特定の国の住所のみ利用可能です。
# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = 新しいクレジットカード情報を追加
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = クレジットカード情報を編集
# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] クレジットカード情報を表示
        [windows] { -brand-short-name } がクレジットカード情報を表示しようとしています。以下の Windows アカウントへのアクセスを確認してください。
       *[other] { -brand-short-name } がクレジットカード情報を表示しようとしています。
    }
autofill-card-number = カード番号
autofill-card-invalid-number = 正しいカード番号を入力してください
autofill-card-name-on-card = お名前
autofill-card-expires-month = 有効期限 (月)
autofill-card-expires-year = 有効期限 (年)
autofill-card-billing-address = 請求先住所
autofill-card-network = カードの種類

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = American Express
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = Discover
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = MasterCard
autofill-card-network-mir = MIR
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = Visa
