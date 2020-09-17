# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } ਇੱਕ ਗਲਤ ਸੁਰੱਖਿਆ ਸਰਟੀਫਿਕੇਟ ਵਰਤਦਾ ਹੈ।

cert-error-mitm-intro = ਵੈਬਸਾਈਟਾਂ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀਂ ਆਪਣੀ ਪਛਾਣ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ, ਜਿਹੜੀਆਂ ਸਰਟੀਫਿਕੇਟ ਅਥਾਰਿਟੀਜ਼ ਦੁਆਰਾ ਜਾਰੀ ਕੀਤੀਆਂ ਜਾਂਦੀਆਂ ਹਨ।

cert-error-mitm-mozilla = { -brand-short-name }, ਗ਼ੈਰ-ਮੁਨਾਫ਼ਾ Mozilla ਵਲੋਂ ਸਮਰਥਨ ਪ੍ਰਾਪਤ ਹੈ, ਜੋ ਇੱਕ ਪੂਰੀ ਤਰ੍ਹਾਂ ਖੁੱਲ੍ਹੇ ਸਰਟੀਫਿਕੇਟ ਅਥਾਰਟੀ (CA) ਸਟੋਰ ਦਾ ਸੰਚਾਲਨ ਕਰਦਾ ਹੈ। CA ਸਟੋਰ ਇਹ ਯਕੀਨੀ ਬਣਾਉਣ ਵਿਚ ਸਹਾਇਤਾ ਕਰਦਾ ਹੈ ਕਿ ਸਰਟੀਫਿਕੇਟ ਅਥਾਰਟੀ ਵਰਤੋਂਕਾਰ ਦੀ ਸੁਰੱਖਿਆ ਲਈ ਸਭ ਤੋਂ ਵਧੀਆ ਅਮਲਾਂ ਦੀ ਪਾਲਣ ਕਰ ਰਹੇ ਹਨ।

cert-error-mitm-connection = { -brand-short-name } ਇਹ ਪੜਤਾਲ ਕਰਨ ਲਈ ਕਿ ਕੁਨੈਕਸ਼ਨ ਸੁਰੱਖਿਅਤ ਹੈ, Mozilla CA ਸਟੋਰ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਨਾ ਕਿ ਵਰਤੋਂਕਾਰ ਦੇ ਓਪਰੇਟਿੰਗ ਸਿਸਟਮ ਵਲੋਂ ਦਿੱਤੇ ਗਏ ਸਰਟੀਫਿਕੇਟ ਦੀ। ਇਸ ਲਈ ਜੇ ਕੋਈ ਐਂਟੀਵਾਈਰਸ ਪ੍ਰੋਗਰਾਮ ਜਾਂ ਕੋਈ ਨੈੱਟਵਰਕ, ਕੁਨੈਕਸ਼ਨ ਨੂੰ ਰੋਕਦਾ ਹੈ ਜਿਸਦਾ ਸਰਟੀਫਿਕੇਟ ਕਿਸੇ ਐਸੇ CA ਸਟੋਰ ਤੋਂ ਜਾਰੀ ਕੀਤਾ ਗਿਆ ਹੈ, ਜੋ Mozilla CA ਸਟੋਰ ਵਿਚ ਨਹੀਂ ਹੈ ਤਾਂ ਉਸ ਕਨੈਕਸ਼ਨ ਨੂੰ ਅਸੁਰੱਖਿਅਤ ਸਮਝਿਆ ਜਾਂਦਾ ਹੈ।

cert-error-trust-unknown-issuer-intro = ਕੋਈ ਵਿਅਕਤੀ ਸਾਈਟ ਦੀ ਨਕਲ ਕਰਨ ਦੀ ਕੋਸ਼ਸ਼ ਕਰ ਸਕਦਾ ਹੈ ਅਤੇ ਤੁਹਾਨੂੰ ਜਾਰੀ ਨਹੀਂ ਰੱਖਣਾ ਚਾਹੀਦਾ ਹੈ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = ਵੈਬਸਾਈਟ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀਂ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ। { -brand-short-name }, { $hostname } ਉੱਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦਾ ਕਿਉਂਕਿ ਇਸਦਾ ਸਰਟੀਫਿਕੇਟ ਜਾਰੀਕਰਤਾ ਅਣਪਛਾਤਾ ਹੈ, ਸਰਟੀਫਿਕੇਟ ਸਵੈ-ਦਸਤਖ਼ਤ ਹੈ ਜਾਂ ਸਰਵਰ ਸਹੀ ਇੰਟਰਮੀਡੀਏਟ ਸਰਟੀਫਿਕੇਟ ਨਹੀਂ ਭੇਜ ਰਿਹਾ ਹੈ।

cert-error-trust-cert-invalid = ਸਰਟੀਫਿਕੇਟ ਭਰੋਸੇਯੋਗ ਨਹੀਂ ਹੈ, ਕਿਉਂਕਿ ਇਸ ਨੂੰ ਗਲਤ CA ਸਰਟੀਫਿਕੇਟ ਵਲੋਂ ਜਾਰੀ ਕੀਤਾ ਗਿਆ ਹੈ।

cert-error-trust-untrusted-issuer = ਸਰਟੀਫਿਕੇਟ ਭਰੋਸੇਯੋਗ ਨਹੀਂ ਹੈ, ਕਿਉਂਕਿ ਜਾਰੀ ਕਰਤਾ ਦਾ ਸਰਟੀਫਿਕੇਟ ਭਰੋਸੇਯੋਗ ਨਹੀਂ ਹੈ।

cert-error-trust-signature-algorithm-disabled = ਇਹ ਸਰਟੀਫਿਕੇਟ ਉੱਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕੀਤਾ ਜਾਂਦਾ ਹੈ, ਕਿਉਂਕਿ ਇਸ ਨੂੰ ਦਸਤਖਤੀ ਐਲੋਗਰਥਿਮ ਨਾਲ ਦਸਤਖਤ ਕੀਤਾ ਗਿਆ ਹੈ, ਜੋ ਕਿ ਸੁਰੱਖਿਅਤ ਨਾ ਹੋਣ ਕਰਕੇ ਪਾਬੰਦੀਸ਼ੁਦਾ ਹੈ।

cert-error-trust-expired-issuer = ਸਰਟੀਫਿਕੇਟ ਭਰੋਸੇਯੋਗ ਨਹੀਂ ਹੈ, ਕਿਉਂਕਿ ਜਾਰੀ ਕਰਤਾ ਸਰਟੀਫਿਕੇਟ ਦੀ ਮਿਆਦ ਪੁੱਗ ਚੁੱਕੀ ਹੈ।

cert-error-trust-self-signed = ਸਰਟੀਫਿਕੇਟ ਭਰੋਸੇਯੋਗ ਨਹੀਂ ਹੈ, ਕਿਉਂਕਿ ਇਸ ਉੱਤੇ ਖੁਦ ਦੇ ਦਸਤਖਤ ਹਨ।

cert-error-trust-symantec = GeoTrust, RapidSSL, Symantec, Thawte, ਅਤੇ VeriSign ਰਾਹੀਂ ਜਾਰੀ ਕੀਤੇ ਸਰਟੀਫਿਕੇਟ ਹੁਣ ਸੁਰੱਖਿਅਤ ਨਹੀਂ ਮੱਨੇ ਜਾਂਦੇ, ਕਿਉਂਕਿ ਇਹ ਪ੍ਰਮਾਣ ਪੱਤਰ ਅਧਿਕਾਰੀ ਅਤੀਤ ਵਿਚ ਸੁਰੱਖਿਆ ਪ੍ਰਣਾਲੀ ਦੀ ਪਾਲਣਾ ਕਰਨ ਵਿੱਚ ਅਸਫਲ ਰਹੇ।

cert-error-untrusted-default = ਸਰਟੀਫਿਕੇਟ ਇੱਕ ਭਰੋਸੇਯੋਗ ਸਰੋਤ ਨਹੀਂ ਆਇਆ ਹੈ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ। { -brand-short-name } ਇਸ ਸਾਈਟ ਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦਾ, ਕਿਉਂਕਿ ਇਹ ਉੁਹ ਸਰਟੀਫਿਕੇਟ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਜੋ { $hostname } ਲਈ ਦਰੁਸਤ ਨਹੀਂ ਹੈ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ। { -brand-short-name } ਇਸ ਸਾਈਟ ਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦਾ ਕਿਉਂਕਿ ਇਹ ਉੁਹ ਸਰਟੀਫਿਕੇਟ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਜੋ { $hostname } ਲਈ ਦਰੁਸਤ ਨਹੀਂ ਹੈ। ਸਰਟੀਫਿਕੇਟ ਕੇਵਲ <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> ਲਈ ਦਰੁਸਤ ਹੈ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ। { -brand-short-name } ਇਸ ਸਾਈਟ ਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦਾ ਕਿਉਂਕਿ ਇਹ ਉੁਹ ਸਰਟੀਫਿਕੇਟ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਜੋ { $hostname } ਲਈ ਦਰੁਸਤ ਨਹੀਂ ਹੈ। ਸਰਟੀਫਿਕੇਟ ਕੇਵਲ { $alt-name } ਲਈ ਦਰੁਸਤ ਹੈ।

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ। { -brand-short-name } ਇਸ ਸਾਈਟ ਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦਾ, ਕਿਉਂਕਿ ਇਹ ਉੁਹ ਸਰਟੀਫਿਕੇਟ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਜੋ { $hostname } ਲਈ ਦਰੁਸਤ ਨਹੀਂ ਹੈ। ਸਰਟੀਫਿਕੇਟ ਕੇਵਲ ਹੇਠਲੇ ਨਾਵਾਂ ਲਈ ਦਰੁਸਤ ਹੈ: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ, ਜੋ ਕਿ ਇਕ ਨਿਰਧਾਰਤ ਸਮੇਂ ਲਈ ਦਰੁਸਤ ਹਨ। { $hostname } ਦੇ ਸਰਟੀਫਿਕੇਟ ਦੀ ਮਿਆਦ { $not-after-local-time } ਨੂੰ ਪੁੱਗ ਗਈ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ, ਜੋ ਕਿ ਇਕ ਨਿਰਧਾਰਤ ਸਮੇਂ ਲਈ ਦਰੁਸਤ ਹਨ। { $hostname } ਲਈ ਸਰਟੀਫਿਕੇਟ { $not-before-local-time } ਤਕ ਦਰੁਸਤ ਨਹੀਂ ਰਹੇਗਾ।

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = ਗਲਤੀ ਕੋਡ: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = ਵੈਬ ਸਾਈਟਾਂ ਆਪਣੀ ਪਛਾਣ ਸਰਟੀਫਿਕੇਟ ਰਾਹੀ ਸਾਬਤ ਕਰਦੀਆਂ ਹਨ, ਜੋ ਸਰਟੀਫਿਕੇਟ ਅਥਾਰਟੀਆਂ ਵਲੋਂ ਜਾਰੀ ਕੀਤਾ ਜਾਂਦਾ ਹੈ। ਜ਼ਿਆਦਾਤਰ ਬਰਾਊਜ਼ਰ ਹੁਣ GeoTrust, RapidSSL, Symantec, Thawte, ਅਤੇ VeriSign ਵਲੋਂ ਜਾਰੀ ਕੀਤੇ ਸਰਟੀਫਿਕੇਟ ਉੱਤੇ ਭਰੋਸਾ ਨਹੀਂ ਕਰਦੇ। { $hostname } ਇਨ੍ਹਾਂ ਵਿਚੋਂ ਇੱਕ ਵਲੋਂ ਜਾਰੀ ਕੀਤੇ ਸਰਟੀਫਿਕੇਟ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ ਅਤੇ ਤਾਂ ਕਰ ਕੇ ਵੈਬ ਸਾਈਟ ਦੀ ਪਛਾਣ ਸਾਬਤ ਨਹੀਂ ਕੀਤੀ ਜਾ ਸਕਦੀ।

cert-error-symantec-distrust-admin = ਤੁਸੀਂ ਇਸ ਸਮੱਸਿਆ ਬਾਰੇ ਵੈੱਬਸਾਈਟ ਦੇ ਪਰਸ਼ਾਸ਼ਕ ਨੂੰ ਸੂ ਚਿਤ ਕਰ ਸਕਦੇ ਹੋ।

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP ਸਟਿਕ ਟਰਾਂਸਪੋਰਟ ਸੁਰੱਖਿਆ: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP ਪਬਲਿਕ ਕੁੰਜੀ ਪਿੰਨਿੰਗ: { $hasHPKP }

cert-error-details-cert-chain-label = ਸਰਟੀਫਿਕੇਟ ਚੇਨ:

open-in-new-window-for-csp-or-xfo-error = ਸਾਈਟ ਨੂੰ ਨਵੀਂ ਵਿੰਡੋ 'ਚ ਖੋਲ੍ਹੋ

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = ਤੁਹਾਡੀ ਸੁਰੱਖਿਆ ਨੂੰ ਬਚਾਉਣ ਲਈ { $hostname } { -brand-short-name } ਨੂੰ ਸਫ਼ਾ ਦਿਖਾਉਣ ਨਹੀਂ ਦੇਵੇਗਾ, ਜੇ ਹੋਰ ਸਾਈਟ ਨੇ ਇਸ ਨੂੰ ਵਿੱਚ ਜੋੜਿਆ ਤਾਂ। ਇਹ ਸਫ਼ਾ ਵੇਖ ਲਈ ਤੁਹਾਨੂੰ ਇਸ ਨੂੰ ਨਵੀਂ ਵਿੰਡੋ 'ਚ ਖੋਲ੍ਹਣਾ ਪਵੇਗਾ।

## Messages used for certificate error titles

connectionFailure-title = ਕੁਨੈਕਟ ਕਰਨ ਲਈ ਅਸਮਰੱਥ
deniedPortAccess-title = ਇਹ ਐਡਰੈੱਸ ਪਾਬੰਦੀਸ਼ੁਦਾ ਹੈ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = ਓਹ ਹੋ। ਸਾਨੂੰ ਉਹ ਸਾਈਟ ਲੱਭਣ ਲਈ ਸਮੱਸਿਆਵਾਂ ਆ ਰਹੀਆਂ ਹਨ।
fileNotFound-title = ਫਾਈਲ ਨਹੀਂ ਲੱਭੀ
fileAccessDenied-title = ਫਾਈਲ ਲਈ ਪਹੁੰਚ ਦੀ ਪਾਬੰਦੀ ਸੀ
generic-title = ਓਹ ਹੋ!
captivePortal-title = ਨੈੱਟਵਰਕ ਲਈ ਲਾਗਇਨ ਕਰੋ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = ਓਹ ਹੋ। ਉਹ ਸਿਰਨਾਵਾਂ ਠੀਕ ਨਹੀਂ ਜਾਪਦਾ ਹੈ।
netInterrupt-title = ਕੁਨੈਕਸ਼ਨ ਰੋਕਿਆ ਗਿਆ
notCached-title = ਡੌਕੂਮੈਂਟ ਦੀ ਮਿਆਦ ਪੁੱਗੀ
netOffline-title = ਆਫ਼-ਲਾਈਨ ਮੋਡ
contentEncodingError-title = ਸਮਗੱਰੀ ਇੰਕੋਡਿੰਗ ਗਲਤੀ
unsafeContentType-title = ਅਸੁਰੱਖਿਅਤ ਫਾਈਲ ਟਾਈਪ
netReset-title = ਕੁਨੈਕਸ਼ਨ ਰੀ-ਸੈੱਟ ਕੀਤਾ ਗਿਆ
netTimeout-title = ਕੁਨੈਕਸ਼ਨ ਟਾਈਮ-ਆਉਟ ਹੋ ਗਿਆ
unknownProtocolFound-title = ਐਡਰੈਸ ਦੀ ਸਮਝ ਨਹੀਂ ਆਈ
proxyConnectFailure-title = ਪਰਾਕਸੀ ਸਰਵਰ ਨੇ ਕੁਨੈਕਸ਼ਨ ਤੋਂ ਇਨਕਾਰ ਕਰ ਦਿੱਤਾ ਹੈ।
proxyResolveFailure-title = ਪਰਾਕਸੀ ਸਰਵਰ ਲੱਭਣ ਲਈ ਅਸਮਰੱਥ ਹੈ
redirectLoop-title = ਸਫ਼ਾ ਢੁੱਕਵੇਂ ਰੂਪ ਵਿੱਚ ਰੀ-ਡਾਇਰੈਕਟ ਨਹੀਂ ਹੁੰਦਾ ਹੈ
unknownSocketType-title = ਸਰਵਰ ਤੋਂ ਗ਼ੈਰ-ਲੋੜੀਦਾ ਜਵਾਬ
nssFailure2-title = ਸੁਰੱਖਿਅਤ ਕੁਨੈਕਸ਼ਨ ਫੇਲ੍ਹ ਹੋਇਆ
csp-xfo-error-title = { -brand-short-name } ਇਸ ਸਫ਼ੇ ਨੂੰ ਖੋਲ੍ਹ ਨਹੀਂ ਸਕਦਾ ਹੈ
corruptedContentError-title = ਨਿਕਾਰਾ ਹੋਈ ਸਮੱਗਰੀ ਗਲਤੀ
remoteXUL-title = ਰਿਮੋਟ XUL
sslv3Used-title = ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਕਨੈਕਟ ਕਰਨ ਲਈ ਅਸਮਰੱਥ
inadequateSecurityError-title = ਤੁਹਾਡਾ ਕਨੈਕਸ਼ਨ ਸੁਰੱਖਿਅਤ ਨਹੀਂ ਹੈ
blockedByPolicy-title = ਪਾਬੰਦੀ ਲਗਾਇਆ ਸਫ਼ਾ
clockSkewError-title = ਤੁਹਾਡੇ ਕੰਪਿਊਟਰ ਦੀ ਘੜੀ ਗਲਤ ਹੈ
networkProtocolError-title = ਨੈੱਟਵਰਕ ਪਰੋਟੋਕਾਲ ਗ਼ਲਤੀ
nssBadCert-title = ਚੇਤਾਵਨੀ: ਅੱਗੇ ਸੰਭਾਵਿਤ ਸੁਰੱਖਿਆ ਖ਼ਤਰਾ ਹੈ
nssBadCert-sts-title = ਕਨੈਕਟ ਨਹੀਂ ਹੈ: ਸੰਭਾਵਿਤ ਸੁਰੱਖਿਆ ਮਸਲਾ
certerror-mitm-title = ਸਾਫਟਵੇਅਰ { -brand-short-name } ਨੂੰ ਇਸ ਸਾਈਟ ਨਾਲ ਸੁਰੱਖਿਅਤ ਢੰਗ ਨਾਲ ਕਨੈਕਟ ਕਰਨ ਤੋਂ ਰੋਕਦਾ ਹੈ
