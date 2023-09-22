# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = 已保存的地址
autofill-manage-addresses-list-header = 地址

autofill-manage-credit-cards-title = 已保存的信用卡
autofill-manage-credit-cards-list-header = 信用卡

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = 移除
autofill-manage-add-button = 添加…
autofill-manage-edit-button = 编辑…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = 添加新地址
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = 编辑地址

autofill-address-given-name = 名
autofill-address-additional-name = 中间名
autofill-address-family-name = 姓
autofill-address-organization = 组织
autofill-address-street = 街道地址

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = 街区
# Used in MY
autofill-address-village-township = 村或乡镇
autofill-address-island = 岛
# Used in IE
autofill-address-townland = 镇

## address-level-2 names

autofill-address-city = 市
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = 区
# Used in GB, NO, SE
autofill-address-post-town = 邮镇
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = 市郊

## address-level-1 names

autofill-address-province = 省
autofill-address-state = 州
autofill-address-county = 县
# Used in BB, JM
autofill-address-parish = 教区
# Used in JP
autofill-address-prefecture = 都道府县
# Used in HK
autofill-address-area = 区域
# Used in KR
autofill-address-do-si = 道/市
# Used in NI, CO
autofill-address-department = 省
# Used in AE
autofill-address-emirate = 酋长国
# Used in RU and UA
autofill-address-oblast = 州

## Postal code name types

# Used in IN
autofill-address-pin = 邮政编码
autofill-address-postal-code = 邮政编码
autofill-address-zip = Zip 编码
# Used in IE
autofill-address-eircode = Eircode 邮政编码

##

autofill-address-country = 国家/地区
autofill-address-tel = 电话号码
autofill-address-email = 电子邮箱

autofill-cancel-button = 取消
autofill-save-button = 保存
autofill-country-warning-message = 表单自动填写目前仅适用于部分地区。

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = 添加新信用卡
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = 编辑信用卡

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] 显示信用卡信息
        [windows] { -brand-short-name } 正尝试显示信用卡信息。请在下方登录此 Windows 账户确认。
       *[other] { -brand-short-name } 正尝试显示信用卡信息。
    }

autofill-card-number = 卡号
autofill-card-invalid-number = 请输入有效的卡号
autofill-card-name-on-card = 持卡人姓名
autofill-card-expires-month = 到期月
autofill-card-expires-year = 到期年
autofill-card-billing-address = 账单地址
autofill-card-network = 卡片类型

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = 美国运通（American Express）
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = 大来卡（Diners Club）
autofill-card-network-discover = 发现卡（Discover）
autofill-card-network-jcb = 吉士美（JCB）
autofill-card-network-mastercard = 万事达（MasterCard）
autofill-card-network-mir = MIR
autofill-card-network-unionpay = 银联（Union Pay）
autofill-card-network-visa = Visa
