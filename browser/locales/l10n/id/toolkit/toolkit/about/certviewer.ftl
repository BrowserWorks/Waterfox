# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Sertifikat

## Error messages

certificate-viewer-error-message = Kami tidak dapat menemukan informasi sertifikat, atau sertifikat rusak. Silakan coba lagi.
certificate-viewer-error-title = Ada masalah.

## Certificate information labels

certificate-viewer-algorithm = Algoritme
certificate-viewer-certificate-authority = Otoritas Sertifikat
certificate-viewer-cipher-suite = Cipher Suite
certificate-viewer-common-name = Nama Umum
certificate-viewer-email-address = Alamat Email
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Sertifikat untuk { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Negara Perusahaan
certificate-viewer-country = Negara
certificate-viewer-curve = Kurva
certificate-viewer-distribution-point = Titik Distribusi
certificate-viewer-dns-name = Nama DNS
certificate-viewer-ip-address = Alamat IP
certificate-viewer-other-name = Nama Lain
certificate-viewer-exponent = Eksponen
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grup Pertukaran Kunci
certificate-viewer-key-id = ID Kunci
certificate-viewer-key-size = Ukuran Kunci
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Lokalitas Perusahaan
certificate-viewer-locality = Daerah
certificate-viewer-location = Lokasi
certificate-viewer-logid = ID Log
certificate-viewer-method = Metode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Nama
certificate-viewer-not-after = Tidak Sesudah
certificate-viewer-not-before = Tidak Sebelum
certificate-viewer-organization = Organisasi
certificate-viewer-organizational-unit = Unit Organisasi
certificate-viewer-policy = Kebijakan
certificate-viewer-protocol = Protokol
certificate-viewer-public-value = Nilai Publik
certificate-viewer-purposes = Penggunaan
certificate-viewer-qualifier = Kualifikasi
certificate-viewer-qualifiers = Kualifikasi
certificate-viewer-required = Diwajibkan
certificate-viewer-unsupported = &lt;tidak didukung&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Perusahaan Negara Bagian/Provinsi
certificate-viewer-state-province = Negara Bagian/Provinsi
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Nomor Seri
certificate-viewer-signature-algorithm = Algoritme Tanda Tangan
certificate-viewer-signature-scheme = Skema Tanda Tangan
certificate-viewer-timestamp = Stempel Waktu
certificate-viewer-value = Nilai
certificate-viewer-version = Versi
certificate-viewer-business-category = Kategori Bisnis
certificate-viewer-subject-name = Nama Subjek
certificate-viewer-issuer-name = Nama Penerbit
certificate-viewer-validity = Keabsahan
certificate-viewer-subject-alt-names = Nama Subjek Alternatif
certificate-viewer-public-key-info = Info Kunci Publik
certificate-viewer-miscellaneous = Lain-lain
certificate-viewer-fingerprints = Sidik Jari
certificate-viewer-basic-constraints = Kendala Dasar
certificate-viewer-key-usages = Penggunaan Kunci
certificate-viewer-extended-key-usages = Penggunaan Kunci Lanjutan
certificate-viewer-ocsp-stapling = Stapel OCSP
certificate-viewer-subject-key-id = ID Kunci Subjek
certificate-viewer-authority-key-id = ID Kunci Otoritas
certificate-viewer-authority-info-aia = Info Otoritas (AIA)
certificate-viewer-certificate-policies = Kebijakan Sertifikat
certificate-viewer-embedded-scts = SCT Tersemat
certificate-viewer-crl-endpoints = Titik Akhir CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Unduh
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ya
       *[false] Tidak
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Ekstensi ini telah ditandai sebagai kritis, artinya klien harus menolak sertifikat jika mereka tidak memahaminya.
certificate-viewer-export = Ekspor
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (tidak diketahui)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Sertifikat Anda
certificate-viewer-tab-people = Perseorangan
certificate-viewer-tab-servers = Server
certificate-viewer-tab-ca = Otoritas
certificate-viewer-tab-unkonwn = Tidak dikenal
