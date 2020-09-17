# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Վկայագիր

## Error messages

certificate-viewer-error-message = Մենք չկարողացանք գտնել վկայագրի տեղեկությունները, կամ վկայականը վնասված է։ Խնդրում եմ կրկին փորձեք։
certificate-viewer-error-title = Ինչ-որ բան այն չէ։

## Certificate information labels

certificate-viewer-algorithm = Հաշվեկարգ
certificate-viewer-certificate-authority = Վկայագրման կենտրոնը
certificate-viewer-cipher-suite = Ծածկագրի հավաքակազմ
certificate-viewer-common-name = Սովորական անուն
certificate-viewer-email-address = էլ․փոստի հասցեն
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Վկայական { $firstCertName }-ի համար
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Երկրի գրանցում
certificate-viewer-country = Երկիր
certificate-viewer-curve = Կոր
certificate-viewer-distribution-point = Բաշխման կետ
certificate-viewer-dns-name = DNS Անուն
certificate-viewer-ip-address = IP հասցե
certificate-viewer-other-name = Այլ անուն
certificate-viewer-exponent = Աստիճանացույց
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Ստեղնի փոխանակման խումբ
certificate-viewer-key-id = Ստեղնի ID
certificate-viewer-key-size = Ստեղնի չափը
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. տեղադրությունը
certificate-viewer-locality = Տեղադրություն
certificate-viewer-location = Տեղադրություն
certificate-viewer-logid = Գրանցման ID
certificate-viewer-method = Եղանակ
certificate-viewer-modulus = Մոդուլներ
certificate-viewer-name = Անուն
certificate-viewer-not-after = Ոչ Հետո
certificate-viewer-not-before = Ոչ Նախքան
certificate-viewer-organization = Կազմակերպություն
certificate-viewer-organizational-unit = Կազմակերպչական միավոր
certificate-viewer-policy = Քաղաքականութիւն
certificate-viewer-protocol = Հաղորդակարգ
certificate-viewer-public-value = Հանրային արժեք
certificate-viewer-purposes = Նպատակներ
certificate-viewer-qualifier = Որակավորիչ
certificate-viewer-qualifiers = Որակավորիչներ
certificate-viewer-required = Պահանջված
certificate-viewer-unsupported = &lt;չաջակցվող&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Նահանգի/գավառի գրանցում
certificate-viewer-state-province = Նահանգ/գավառ
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Հերթական Համարը
certificate-viewer-signature-algorithm = Ստորագրության հաշվեկարգ
certificate-viewer-signature-scheme = Ստորագրության համակարգ
certificate-viewer-timestamp = Ժամադրոշմ
certificate-viewer-value = Արժեք
certificate-viewer-version = Տարբերակ
certificate-viewer-business-category = Ձեռնարկության անվանակարգ
certificate-viewer-subject-name = Առարկայի անուն
certificate-viewer-issuer-name = Թողարկողի անուն
certificate-viewer-validity = Վավերականություն
certificate-viewer-subject-alt-names = Առարկայի Alt անուններ
certificate-viewer-public-key-info = Հանրային բանալու տեղեկություն
certificate-viewer-miscellaneous = Խառնաբնույթ
certificate-viewer-fingerprints = Մատնահետքեր
certificate-viewer-basic-constraints = Հիմնական սահմանափակումներ
certificate-viewer-key-usages = Բանալու կիրառումներ
certificate-viewer-extended-key-usages = Ընդլայնած բանալու կիրառումներ
certificate-viewer-ocsp-stapling = OCSP Ամրակրում
certificate-viewer-subject-key-id = Առարկայի բանալու ID
certificate-viewer-authority-key-id = Հեղինակային իրավունքի բանալին ID
certificate-viewer-authority-info-aia = Հեղինակային տեղեկատվության (AIA)
certificate-viewer-certificate-policies = Վկայագրի դրույթները
certificate-viewer-embedded-scts = Ներկառուցված SCTs
certificate-viewer-crl-endpoints = CRL֊ի վերջնակետերը

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Ներբեռնել
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Այո
       *[false] Ոչ
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem =
    PEM (cert)
    PEM (cert)
    PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Այս ընդլայնումը նշվել է որպես կրիտիկական, ինչը նշանակում է, որ հաճախորդները պետք է մերժեն վկայագիրը, եթե նրանք չեն հասկանում դա:
certificate-viewer-export = Արտահանել
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ձեր վկայագրերը
certificate-viewer-tab-people = Մարդիկ
certificate-viewer-tab-servers = Սպասարկիչներ
certificate-viewer-tab-ca = Հեղինակություններ
certificate-viewer-tab-unkonwn = Անհայտ
