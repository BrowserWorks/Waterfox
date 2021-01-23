# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# DO NOT ADD THINGS OTHER THAN ERROR MESSAGES HERE.
# This file gets parsed into a JS dictionary of all known error message ids in
# gen_aboutneterror_codes.py . If we end up needing fluent attributes or
# refactoring them in some way, the script will need updating.

psmerr-ssl-disabled = सुरक्षित रूपमा जडान गर्न सकिँदैन किनकि SSL प्रोटोकल अक्षम गरिएको छ ।
psmerr-ssl2-disabled = सुरक्षित रूपमा जडान गर्न सकिँदैन किनकि साइटले SSL प्रोटोकलको पुरानो, असुरक्षित संस्करण प्रयोग गर्दछ ।

# This is a multi-line message.
psmerr-hostreusedissuerandserial =
    तपाईँले अमान्य प्रमाणपत्र प्राप्त गर्नुभएको छ।  कृपया सर्भर व्यवस्थापक वा इमेल सम्पर्ककर्तासँग सम्पर्क गरेर यो जानकारी दिनुहोस्:
    
    तपाईँसँग प्रमाणपत्र अधिकारीले जारी गरेको जस्तो अनुक्रमाङ्क छ।  कृपया अद्वितीय अनुक्रमाङ्क भएको एउटा नयाँ प्रमाणपत्र प्राप्त गर्नुहोस्।

ssl-error-export-only-server = सुरक्षित सम्पर्क गर्न असमर्थ। समकक्षताले उच्च-ग्रेड गुप्तिकरण समर्थन गर्दैन ।
ssl-error-us-only-server = सुरक्षित सम्पर्क गर्न असमर्थ। समकक्षतामा उच्च-कोटीको गुप्तिकरण आवश्यक छ जुन् असमर्थित छ ।
ssl-error-no-cypher-overlap = सुरक्षित तरिकाबाट पियरसँग सञ्चार गर्न सकिएनः साधारण गुप्तिकरण अलगोरिदम(हरू) छैन ।
ssl-error-no-certificate = प्रमाणीकरणको लागि आवश्यक प्रमाणपत्र अथवा कुञ्जी भेटिएन ।
ssl-error-bad-certificate = पियर संग सुरक्षित संवाद गर्न असक्षम : पियरको प्रमाणपत्र अस्वीकृत ।
ssl-error-bad-client = एउटा सेर्वेरमा क्लिएन्त दुअरा खराब दाता आकस्मिक भेट भएको छ ।
ssl-error-bad-server = एउटा सेर्वेरमा क्लिएन्त दुअरा खराब दाता आकस्मिक भेट भएको छ ।
ssl-error-unsupported-certificate-type = असमर्थित प्रकारको प्रमाणपत्र ।
ssl-error-unsupported-version = सुरक्षा प्रोटोकॉल को समर्थित संस्करण को उपयोगी सहकर्मी ।
ssl-error-wrong-certificate = क्लाइंट प्रमाणीकरण असफल: दताबसे मा भएको  निजी  साँचो सार्बजनिक साँचो संग मेल खादैन ।
ssl-error-post-warning = अपरिचित SSL त्रुटि कोड ।
ssl-error-ssl2-disabled = पियरले SSL संस्करण 2 लाई मात्र समर्थन गर्दछ, जुन स्थानीय स्तरमा अक्षम गरिएको छ ।
ssl-error-bad-mac-read = SSL ले गलत संदेश प्रमाणीकरण कोड युक्त रेकर्ड प्राप्त गरेको छ ।
ssl-error-bad-mac-alert = SSL ले गलत संदेश युक्त कोड मापन गरेको छ ।
ssl-error-bad-cert-alert = SSL पियर तपाईँको प्रमाणपत्र पुष्टी गर्न सक्दैन ।
ssl-error-ssl-disabled = स्थापना हुन सक्दैन: SSL निस्क्रिय गरिएको छ ।
ssl-error-fortezza-pqg = कनेक्ट गर्न् सकिएन: एसएसएल सहकर्मी एउटा र Fortezza डोमेन मा छ ।
ssl-error-unknown-cipher-suite = एउटा अज्ञात एसएसएल साइफर सूट अनुरोध गरिएको छ ।
ssl-error-no-ciphers-supported = कुनै साइफर सूट मौजूद छ र यस कार्यक्रम मा सक्षम छ ।
ssl-error-bad-block-padding = SSL ले नराम्रो ब्लक को साथ एउटा रेकर्ड प्राप्त गर्यो।
ssl-error-tx-record-too-long = SSL ले एक रेकर्ड पठाउन प्रयास गर्यो जसले अधिकतम अनुमति योग्य लम्बाइ पार गारेको छ ।
ssl-error-close-notify-alert = यस यस यल पियरले स्थापना बन्द गरयो ।
ssl-error-sign-hashes-failure = तपाईँको प्रमाणपत्र प्रमाणित गर्न आवश्यक डाटामा डिजिटल हस्ताक्षर गर्न असमर्थ ।
ssl-error-no-compression-overlap = सुरक्षित तरिकाबाट पियरसँग सञ्चार गर्न सकिएनःसामान्य गुप्तिकरण अलगोरिदम(हरू) छैन।
ssl-error-incorrect-signature-algorithm = डिजिटल-हस्ताक्षर भएको तत्वमा गलत हस्ताक्षर अलगोरिदम निर्दिष्ट गरिएको छ ।
sec-error-invalid-time = अनियमित तरिकाले ढाँचाबद्ध भएको समय स्ट्रिङ।
sec-error-bad-password = प्रविष्टित सुरक्षा गोप्यशब्द गलत छ।
sec-error-retry-password = नयाँ गोप्यशब्द गलत तरिकाले प्रविष्ट भयो। कृपया पुनः प्रयास गर्नुहोस्।
sec-error-cert-valid = यो प्रमाणपत्र वैद्य छ।
sec-error-cert-not-valid = यो प्रमाणपत्र वैद्य छैन।
sec-error-expired-issuer-certificate = प्रमाणपत्र जारीकर्ताको प्रमाणपत्र समाप्त भएको छ। आफ्नो प्रणालीको मिति र समय जाँच गर्नुहोस्।
sec-error-crl-invalid = नयाँ CRLमा अमान्य ढाँचा छ।
sec-error-ca-cert-invalid = वितरक प्रमाणपत्र अमान्य छ।
sec-error-old-crl = नयाँ सीआरएल हालको भन्दा पुरानो छ।
xp-sec-fortezza-bad-pin = अवैध पिन
sec-error-krl-invalid = नयाँ केआरएलमा अमान्य ढाँचा छ।
sec-error-pkcs12-decoding-pfx = आयात गर्न असमर्थ । असङ्केतन त्रुटि । फाइल वैध छैन ।
sec-error-pkcs12-invalid-mac = आयात गर्न असमर्थ । अमान्य MAC । गलत गोप्यशब्द वा बिग्रिएको फाइल ।
sec-error-pkcs12-unsupported-mac-algorithm = आयात गर्न असमर्थ । MAC अलगोरिदम समर्थित छैन ।
sec-error-pkcs12-unsupported-transport-mode = आयात गर्न असमर्थ । केवल गोप्यशब्द समग्रता र गोपनीयता मोडहरू समर्थित छन् ।
sec-error-pkcs12-corrupt-pfx-structure = आयात गर्न असमर्थ । फाइल ढाँचा बिग्रिएको छ ।
sec-error-pkcs12-unsupported-pbe-algorithm = आयात गर्न असमर्थ । गुप्तिकरण अलगोरिदम समर्थित छैन ।
sec-error-pkcs12-unsupported-version = आयात गर्न असमर्थ । फाइल संस्करण समर्थित छैन ।
sec-error-pkcs12-privacy-password-incorrect = आयात गर्न असमर्थ । गलत गोपनीयता गोप्यशब्द ।
sec-error-pkcs12-cert-collision = आयात गर्न असमर्थ । उहि उपनाम डाटाबेसमा पहिल्यै अवस्थित छ ।
sec-error-inadequate-cert-type = अनुप्रयोगको लागि प्रमाणपत्रको प्रकार स्वीकृत छैन।
sec-error-pkcs12-unable-to-import-key = आयात गर्न असमर्थ । निजी कुञ्जी आयात गर्न प्रयास गर्दा त्रुटि ।
sec-error-pkcs12-importing-cert-chain = आयात गर्न असमर्थ । प्रमाणपत्र शृंखला आयात गर्न प्रयास गर्दा त्रुटि ।
sec-error-pkcs12-unable-to-locate-object-by-name = निर्यात गर्न असमर्थ । प्रमाणपत्र वा कुञ्जी उपनाम द्वारा पत्ता लगाउन असमर्थ ।
sec-error-pkcs12-unable-to-export-key = निर्यात गर्न असमर्थ । निजी कुञ्जी पत्ता लगाउन र निर्यात गर्न सकिएन ।
sec-error-pkcs12-unable-to-write = निर्यात गर्न असमर्थ। निर्यात फाइल लेख्न असमर्थ।
sec-error-pkcs12-unable-to-read = आयात गर्न असमर्थ। आयात फाइल पढ्न असमर्थ।
sec-error-pkcs12-key-database-not-initialized = निर्यात गर्न असमर्थ। कुञ्जी डाटाबेस बिग्रिएको वा मेटाइएको ।
sec-error-keygen-fail = सार्वजनिक/निजी कुञ्जी जोडि उत्पन्न गर्न असमर्थ ।
sec-error-invalid-password = प्रबिष्ट गर्नुभएको पासवर्ड अमान्य छ। कृपया फरक रोज्नुहोस्।
sec-error-retry-old-password = पुरानो पासवर्ड गलत तरिकाले प्रविष्ट भयो। कृपया फेरि प्रयास गर्नुहोस।
sec-error-js-invalid-module-name = अमान्य मोड्युल नाम।
sec-error-js-add-mod-failure = मोड्युल थप्न असमर्थ
sec-error-js-del-mod-failure = मोड्युल मेट्न असमर्थ
sec-error-old-krl = नयाँ  केआरएल हालको भन्दा पुरानो छ।
sec-error-unknown-cert = अनुरोध गरिएको प्रमाणपत्र भेट्टाउन सकिएन।
sec-error-unknown-signer = हस्ताक्षरकर्ताको प्रमाणपत्र फेला पार्न सकेन।
sec-error-crl-already-exists = CRL पहिल्यै अवस्थित छ ।
sec-error-expired-password = पासवर्डको समयाबधि सकियो।
sec-error-locked-password = पासवर्डमा ताल्चा लागेको छ।
