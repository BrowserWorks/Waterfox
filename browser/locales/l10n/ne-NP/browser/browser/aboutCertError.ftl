# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } अवैध सुरक्षा प्रमाणपत्र प्रयोग गर्दछ।

cert-error-trust-cert-invalid = यो प्रमाणपत्र विश्वसनीय छैन किनभने यो एक अमान्य CA प्रमाणपत्र द्वारा जारीगरिएको छ।

cert-error-trust-untrusted-issuer = यो प्रमाणपत्र विश्वसनीय छैन किनभने किनभने जारीकर्ता प्रमाणपत्र विश्वसनीय छैन।

cert-error-trust-signature-algorithm-disabled = यो प्रमाणपत्र विश्वसनीय छैन किनभने किनभने यो प्रयोग गर्ने तर्क सुरक्षित छैन किनभने अक्षम थियो कि एक हस्ताक्षर अल्गोरिदम हस्ताक्षर भएको

cert-error-trust-expired-issuer = यो प्रमाणपत्र विश्वसनीय छैन किनभने किनभने जारीकर्तालाई प्रमाणपत्र समाप्त भएको छ।

cert-error-trust-self-signed = यो प्रमाणपत्र विश्वसनीय छैन किनभने यो आत्म-हस्ताक्षरित छ।

cert-error-untrusted-default = प्रमाणपत्र विश्वसनीय स्रोतबाट आएको छैन।

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = प्रमाणपत्र चेन:

## Messages used for certificate error titles

connectionFailure-title = जडान गर्न असमर्थ
deniedPortAccess-title = यो ठेगाना प्रतिबन्धित छ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = उम्म । त्यो साइट फेला पार्न हामीलाई समस्या भइरहेको छ ।
fileNotFound-title = फाइल फेला परेन
fileAccessDenied-title = फाइलमा पहुँच अस्वीकृत भयो
generic-title = ओहो।
captivePortal-title = सञ्जालमा लगइन गर्नुहोस्
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = उम्म । त्यो ठेगाना सही देखिँदैन ।
netInterrupt-title = यो जडानमा अवरोध भएको छ
notCached-title = कागजातको समयावधी समाप्त भयो
netOffline-title = अफलाइन मोड
contentEncodingError-title = सामग्री संकेतीकरण त्रुटी
unsafeContentType-title = असुरक्षित फाइल प्रकार
netReset-title = यो जडान रिसेट भएको थियो
netTimeout-title = यो जडानको समय समाप्त भएको छ
unknownProtocolFound-title = यो ठेगाना बुझिएन
proxyConnectFailure-title = प्रोक्सी सर्भरले जडान हुन मानेको छैन
proxyResolveFailure-title = प्रोक्सी सर्भरको खोजी गर्न असमर्थ भयो
redirectLoop-title = पृष्ठ राम्रोसँग पुनः निर्देशित हुन सकिरहेको छैन
unknownSocketType-title = सर्भरबाट अनपेक्षित प्रतिक्रिया
nssFailure2-title = सुरक्षित जडान असफल भयो
corruptedContentError-title = दूषित सामग्री त्रुटि
remoteXUL-title = Remote XUL
sslv3Used-title = सुरक्षित जडान गर्न असमर्थ
inadequateSecurityError-title = तपाईँको जडान सुरक्षित छैन
