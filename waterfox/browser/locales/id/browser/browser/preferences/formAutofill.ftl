# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Alamat Tersimpan
autofill-manage-addresses-list-header = Alamat

autofill-manage-credit-cards-title = Kartu Kredit Tersimpan
autofill-manage-credit-cards-list-header = Kartu Kredit

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Hapus
autofill-manage-add-button = Tambah…
autofill-manage-edit-button = Edit…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Tambahkan Alamat Baru
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Edit Alamat

autofill-address-given-name = Nama Depan
autofill-address-additional-name = Nama Tengah
autofill-address-family-name = Nama Belakang
autofill-address-organization = Organisasi
autofill-address-street = Jalan

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Neighborhood
# Used in MY
autofill-address-village-township = Desa atau Kotamadya
autofill-address-island = Pulau
# Used in IE
autofill-address-townland = Kota kecil

## address-level-2 names

autofill-address-city = Kota
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Distrik
# Used in GB, NO, SE
autofill-address-post-town = Kode kota
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Pinggiran kota

## address-level-1 names

autofill-address-province = Provinsi
autofill-address-state = Negara Bagian
autofill-address-county = Kabupaten
# Used in BB, JM
autofill-address-parish = Paroki
# Used in JP
autofill-address-prefecture = Prefektur
# Used in HK
autofill-address-area = Wilayah
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Departemen
# Used in AE
autofill-address-emirate = Emirat
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Kode Pos
autofill-address-zip = Kode Pos
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Negara atau Wilayah
autofill-address-tel = Telepon
autofill-address-email = Email

autofill-cancel-button = Batalkan
autofill-save-button = Simpan
autofill-country-warning-message = Saat ini fitur IsiOtomatis Formulir hanya tersedia untuk negara tertentu.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Tambahkan Kartu Kredit Baru
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Edit Kartu Kredit

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] menampilkan informasi kartu kredit.
        [windows] { -brand-short-name } berusaha menampilkan informasi kartu kredit. Konfirmasikan akses ke akun Windows di bawah ini.
       *[other] { -brand-short-name } berusaha menampilkan informasi kartu kredit.
    }

autofill-card-number = Nomor Kartu
autofill-card-invalid-number = Masukkan nomor kartu yang valid
autofill-card-name-on-card = Nama pada Kartu
autofill-card-expires-month = Bulan Kedaluwarsa
autofill-card-expires-year = Tahun Kedaluwarsa
autofill-card-billing-address = Alamat Tagihan
autofill-card-network = Jenis Kartu

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
