# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Các địa chỉ đã lưu
autofill-manage-addresses-list-header = Địa chỉ

autofill-manage-credit-cards-title = Thẻ tín dụng đã lưu
autofill-manage-credit-cards-list-header = Thẻ tín dụng

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Xóa
autofill-manage-add-button = Thêm…
autofill-manage-edit-button = Sửa…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Thêm địa chỉ mới
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Sửa địa chỉ

autofill-address-given-name = Họ
autofill-address-additional-name = Tên đệm
autofill-address-family-name = Tên
autofill-address-organization = Tổ chức
autofill-address-street = Địa chỉ đường phố

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Khu vực lân cận
# Used in MY
autofill-address-village-township = Làng hoặc thị trấn
autofill-address-island = Đảo
# Used in IE
autofill-address-townland = Thị trấn

## address-level-2 names

autofill-address-city = Thành phố
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Quận
# Used in GB, NO, SE
autofill-address-post-town = Bưu điện thị trấn
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Ngoại thành

## address-level-1 names

autofill-address-province = Tỉnh
autofill-address-state = Bang
autofill-address-county = Quận
# Used in BB, JM
autofill-address-parish = Giáo xứ
# Used in JP
autofill-address-prefecture = Tỉnh
# Used in HK
autofill-address-area = Vùng
# Used in KR
autofill-address-do-si = Tỉnh/Thành phố
# Used in NI, CO
autofill-address-department = Sở
# Used in AE
autofill-address-emirate = Tiểu Vương quốc
# Used in RU and UA
autofill-address-oblast = Tỉnh

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Mã bưu chính
autofill-address-zip = Mã bưu chính
# Used in IE
autofill-address-eircode = Mã bưu chính

##

autofill-address-country = Quốc gia hoặc vùng
autofill-address-tel = Điện thoại
autofill-address-email = Thư điện tử

autofill-cancel-button = Hủy bỏ
autofill-save-button = Lưu
autofill-country-warning-message = Tự động điền biểu mẫu hiện chỉ có sẵn cho một số quốc gia nhất định.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Thêm thẻ tín dụng mới
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Sửa thẻ tín dụng

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] hiển thị thông tin thẻ tín dụng
        [windows] { -brand-short-name } đang cố gắng hiển thị thông tin thẻ tín dụng. Xác nhận quyền truy cập vào tài khoản Windows bên dưới.
       *[other] { -brand-short-name } đang cố gắng hiển thị thông tin thẻ tín dụng.
    }

autofill-card-number = Số thẻ
autofill-card-invalid-number = Vui lòng nhập số thẻ hợp lệ
autofill-card-name-on-card = Tên trên thẻ
autofill-card-expires-month = Hết hạn tháng
autofill-card-expires-year = Hết hạn năm
autofill-card-billing-address = Địa chỉ thanh toán
autofill-card-network = Loại thẻ

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
