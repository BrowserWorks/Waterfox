# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = ที่อยู่ที่บันทึกไว้
autofill-manage-addresses-list-header = ที่อยู่

autofill-manage-credit-cards-title = บัตรเครดิตที่บันทึกไว้
autofill-manage-credit-cards-list-header = บัตรเครดิต

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = เอาออก
autofill-manage-add-button = เพิ่ม…
autofill-manage-edit-button = แก้ไข…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = เพิ่มที่อยู่ใหม่
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = แก้ไขที่อยู่

autofill-address-given-name = ชื่อจริง
autofill-address-additional-name = ชื่อกลาง
autofill-address-family-name = นามสกุล
autofill-address-organization = องค์กร
autofill-address-street = ที่อยู่

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = ชุมชน
# Used in MY
autofill-address-village-township = หมู่บ้านหรือเขตการปกครอง
autofill-address-island = เกาะ
# Used in IE
autofill-address-townland = เขต

## address-level-2 names

autofill-address-city = เมือง
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = เขต
# Used in GB, NO, SE
autofill-address-post-town = เมือง
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = ชานเมือง

## address-level-1 names

autofill-address-province = จังหวัด
autofill-address-state = รัฐ
autofill-address-county = เคาน์ตี
# Used in BB, JM
autofill-address-parish = ตำบล
# Used in JP
autofill-address-prefecture = อำเภอ
# Used in HK
autofill-address-area = เขต
# Used in KR
autofill-address-do-si = จังหวัด
# Used in NI, CO
autofill-address-department = จังหวัด
# Used in AE
autofill-address-emirate = เอมิเรต
# Used in RU and UA
autofill-address-oblast = แคว้น

## Postal code name types

# Used in IN
autofill-address-pin = พิน
autofill-address-postal-code = รหัสไปรษณีย์
autofill-address-zip = รหัสไปรษณีย์
# Used in IE
autofill-address-eircode = เอียร์โค้ด

##

autofill-address-country = ประเทศหรือภูมิภาค
autofill-address-tel = โทรศัพท์
autofill-address-email = อีเมล

autofill-cancel-button = ยกเลิก
autofill-save-button = บันทึก
autofill-country-warning-message = ขณะนี้การกรอกแบบฟอร์มมีให้บริการเฉพาะบางประเทศเท่านั้น

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = เพิ่มบัตรเครดิตใหม่
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = แก้ไขบัตรเครดิต

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] แสดงข้อมูลบัตรเครดิต
        [windows] { -brand-short-name } กำลังพยายามจะแสดงข้อมูลบัตรเครดิต ยืนยันการเข้าถึงบัญชี Windows นี้ด้านล่าง
       *[other] { -brand-short-name } กำลังพยายามจะแสดงข้อมูลบัตรเครดิต
    }

autofill-card-number = หมายเลขบัตร
autofill-card-invalid-number = โปรดป้อนหมายเลขบัตรที่ถูกต้อง
autofill-card-name-on-card = ชื่อบนบัตร
autofill-card-expires-month = เดือนที่หมดอายุ
autofill-card-expires-year = ปีที่หมดอายุ
autofill-card-billing-address = ที่อยู่สำหรับเรียกเก็บเงิน
autofill-card-network = ชนิดบัตร

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
