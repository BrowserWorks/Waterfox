# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } किसी अवैध सुरक्षा प्रमाणपत्र का प्रयोग करता है.
cert-error-mitm-intro = वेबसाइटें प्रमाण पत्र द्वारा अपनी पहचान साबित करती हैं, जो प्रमाणपत्र अधिकारियों द्वारा जारी की जाती हैं।
cert-error-mitm-mozilla = { -brand-short-name } गैर-लाभकारी Mozilla द्वारा समर्थित है, जो पूरी तरह से खुले प्रमाणपत्र प्राधिकारी (CA) स्टोर का प्रबंधन करता है। CA स्टोर यह सुनिश्चित करने में मदद करता है कि प्रमाणपत्र अधिकारी उपयोगकर्ता सुरक्षा के लिए सर्वोत्तम प्रथाओं का पालन कर रहे हैं।
cert-error-mitm-connection = { -brand-short-name } उपयोगकर्ता के ऑपरेटिंग सिस्टम द्वारा आपूर्ति किए गए प्रमाणपत्रों के बजाय यह सत्यापित करने के लिए कि कोई कनेक्शन सुरक्षित है, Mozilla CA स्टोर का उपयोग करता है। इसलिए, यदि कोई एंटीवायरस प्रोग्राम या नेटवर्क किसी CA द्वारा जारी किए गए सुरक्षा प्रमाणपत्र के साथ कनेक्शन को रोक रहा है जो Mozilla CA स्टोर में नहीं है, तो कनेक्शन असुरक्षित माना जाता है।
cert-error-trust-unknown-issuer-intro = कोई व्यक्ति साइट का प्रतिरूप बनाने की कोशिश कर रहा हो सकता है और आपको जारी नहीं रखना चाहिए।
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान सुनिश्चित करती हैं। { -brand-short-name } { $hostname } पर निर्भर नहीं करता है क्योंकि इसका प्रमाण पत्र जारीकर्ता अज्ञात है, प्रमाण पत्र स्व-हस्ताक्षरित है, या फिर सर्वर सही मध्यवर्ती प्रमाण पत्र नहीं भेज रहा है।
cert-error-trust-cert-invalid = प्रमाणपत्र भरोसेमंद नहीं है क्योंकि इसे किसी अवैध CA प्रमाणपत्र के द्वारा निर्गत किया गया था.
cert-error-trust-untrusted-issuer = प्रमाणपत्र भरोसेमंद नहीं है क्योंकि निर्गतकर्ता प्रमाणपत्र भरोसेमंद नहीं है.
cert-error-trust-signature-algorithm-disabled = यह प्रमाणपत्र भरोसेमंद नहीं है क्योंकि यह हस्ताक्षर अलगोरिथम के उपयोग से हस्ताक्षरित किया गया है जो निष्क्रिय किया गया क्योंकि अलगोरिथम सुरक्षित नहीं है.
cert-error-trust-expired-issuer = प्रमाणपत्र भरोसेमंद नहीं है क्योंकि निर्गतकर्ता प्रमाणपत्र खत्म हो गया है.
cert-error-trust-self-signed = प्रमाणपत्र भरोसेमंद नहीं है क्योंकि यह स्वहस्ताक्षरित है.
cert-error-trust-symantec = GeoTrust, RapidSSL, Symantec, Thawte और VeriSign द्वारा जारी किए गए प्रमाण पत्र अब सुरक्षित नहीं माने जाते हैं क्योंकि ये प्रमाण पत्र प्राधिकारी अतीत में सुरक्षा कार्यप्रणाली का पालन करने में असफल रहे थे।
cert-error-untrusted-default = प्रमाणपत्र किसी भरोसेमद स्रोत से नहीं आया है.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं। { -brand-short-name } इस साइट पर भरोसा नहीं करता है क्योंकि यह एक प्रमाणपत्र का इस्तेमाल करता है जो { $hostname } के लिए अमान्य हैं।
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं। { -brand-short-name } इस साइट पर भरोसा नहीं करता है क्योंकि यह एक प्रमाणपत्र का इस्तेमाल करता है जो { $hostname } के लिए अमान्य हैं। प्रमाणपत्र केवल <a data-l10n-name="domain-mismatch-link"> { $alt-name } </a> के लिए मान्य है।
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं। { -brand-short-name } इस साइट पर भरोसा नहीं करता है क्योंकि यह एक प्रमाणपत्र का इस्तेमाल करता है जो { $hostname } के लिए अमान्य हैं। प्रमाणपत्र केवल { $alt-name } के लिए मान्य है।
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं। { -brand-short-name } इस साइट पर भरोसा नहीं करता है क्योंकि यह एक प्रमाणपत्र का इस्तेमाल करता है जो { $hostname } के लिए अमान्य हैं। प्रमाणपत्र केवल निम्नलिखित नामों के लिए मान्य है: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं, जो एक निश्चित समय के लिए मान्य हैं।{ $hostname } का प्रमाणपत्र { $not-after-local-time } पर समाप्त हो गया।
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं, जो एक निश्चित समय के लिए मान्य हैं। { $hostname } का प्रमाणपत्र { $not-before-local-time } तक मान्य नहीं होगा।
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = त्रुटि कोड: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = वेबसाइटें प्रमाण पत्र के द्वारा अपनी पहचान साबित करती हैं, जो प्रमाणपत्र अधिकारियों द्वारा जारी की जाती हैं। ज्यादातर ब्राउज़र अब GeoTrust, RapidSSL, Symantec, Thawte और VeriSign द्वारा जारी किए गए प्रमाणपत्रों पर भरोसा नहीं करते हैं। { $hostname } इन प्राधिकरणों में से एक से एक प्रमाण पत्र का उपयोग करता है और इसलिए वेबसाइट की पहचान को साबित नहीं किया जा सकता है।
cert-error-symantec-distrust-admin = आप इस समस्या के बारे में वेबसाइट के व्यवस्थापक को सूचित कर सकते हैं।
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP स्ट्रिक्ट परिवहन सुरक्षा: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP सार्वजनिक कुंजी पिनिंग: { $hasHPKP }
cert-error-details-cert-chain-label = प्रमाणपत्र विवरण:
open-in-new-window-for-csp-or-xfo-error = नए विंडो पर साइट खोलें

## Messages used for certificate error titles

connectionFailure-title = कनेक्ट करने में असमर्थ
deniedPortAccess-title = यह पता प्रतिबंधित है
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = हम्म. हमें वह साइट को खोजने में परेशानी हो रही है.
fileNotFound-title = फाइल नहीं मिला
fileAccessDenied-title = फ़ाइल तक पहुँच रद्द की गयी
generic-title = ओफ्फ.
captivePortal-title = नेटवर्क के लिए लॉग इन करें
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = हम्म. वह पता सही नहीं लगता.
netInterrupt-title = कनेक्शन बाधित किया गया था
notCached-title = दस्तावेज़ का समय समाप्त
netOffline-title = Offline mode
contentEncodingError-title = अंतर्वस्तु ऐन्कोडिंग त्रुटि
unsafeContentType-title = असुरक्षित फाइल प्रकार
netReset-title = कनेक्शन रिसेट किया गया था
netTimeout-title = कनेक्शन का समय समाप्त हो गया
unknownProtocolFound-title = पता समझा नहीं गया था
proxyConnectFailure-title = प्रॉक्सी सर्वर कनेक्शन अस्वीकार कर रहा है
proxyResolveFailure-title = प्राक्सी सर्वर ढ़ूढ़ने में असमर्थ
redirectLoop-title = पृष्ठ ठीक से पुनर्निर्देशित नहीं कर रहा है
unknownSocketType-title = सर्वर से अप्रत्याशित अनुक्रिया
nssFailure2-title = सुरक्षित कनेक्शन विफल
csp-xfo-error-title = { -brand-short-name } इस पृष्ठ को नहीं खोल सकता
corruptedContentError-title = खराब अंतर्वस्तु त्रुटि
remoteXUL-title = दूरस्थ XUL
sslv3Used-title = सुरक्षित रूप से कनेक्ट करने में असमर्थ
inadequateSecurityError-title = आपका कनेक्शन सुरक्षित नही हैं
blockedByPolicy-title = ब्लॉक किया हुआ पृष्ट
clockSkewError-title = आपकी कंप्यूटर की घडी गलत है
networkProtocolError-title = नेटवर्क प्रोटोकॉल त्रुटि
nssBadCert-title = खतरा: आगे संभावित सुरक्षा जोखिम है
nssBadCert-sts-title = कनेक्ट नहीं हुआ: संभावित सुरक्षा समस्या
certerror-mitm-title = सॉफ़्टवेयर { -brand-short-name } को इस साइट से सुरक्षित रूप से कनेक्ट होने से रोक रहा है
