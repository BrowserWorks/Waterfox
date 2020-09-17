# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } தளம் செல்லுபடியாகாத SSL சான்றிதழைப் பாவிக்கிறது.

cert-error-trust-cert-invalid = இந்த சான்றிதழ் ஒரு செல்லுபடியாகாத CA சான்றிதழால் வழங்கப்பட்டுள்ளதால், இது நம்பகமானதல்ல.

cert-error-trust-untrusted-issuer = சான்றிதழை வழங்குபவர் நம்பகமாக இல்லாததால், சான்றிதழ் நம்பகமானதல்ல.

cert-error-trust-signature-algorithm-disabled = இந்த சான்றிதழானது பாதுகாப்பற்றது என்ற காரணத்திற்காக முடக்கப்பட்ட ஒரு கையொப்ப வழிமுறையைப் பயன்படுத்தி கையொப்பமிடப்பட்டுள்ளதால், இந்த சான்றிதழ் நம்பகமானதல்ல.

cert-error-trust-expired-issuer = சான்றிதழை வழங்கும் அமைப்பு காலாவதியானதால், சான்றிதழ் நம்பகமானதல்ல.

cert-error-trust-self-signed = சுயமாக உருவாக்கப்பட்ட சான்றிதழ் ஆதலால் நம்பகமற்றது.

cert-error-untrusted-default = சான்றிதழ் ஒரு நம்பகமான மூலத்திலிருந்து வரவில்லை.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = வலைத்தளங்கள் தங்கள் அடையாளத்தைச் சான்றிதழ்கள்மூலம் நிரூபிக்கின்றன. { -brand-short-name } இந்தத் தளத்தை நம்பவில்லை, ஏனெனில் { $hostname } செல்லுபடியாகாத சான்றிதழைப் பயன்படுத்துகிறது. இந்தச் சான்றிதழ் பின்வரும் பெயர்களுக்கு மட்டுமே செல்லுபடியாகும்: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = வலைத்தளங்கள் தங்கள் அடையாளத்தைச் சான்றிதழ்கள்மூலம் நிரூபிக்கின்றன, அவை ஒரு குறிப்பிட்ட காலத்திற்கு செல்லுபடியாகும். { $hostname } க்கான சான்றிதழ் { $not-after-local-time } அன்று காலாவதியானது.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = வலைத்தளங்கள் தங்கள் அடையாளத்தைச் சான்றிதழ்கள்மூலம் நிரூபிக்கின்றன, அவை ஒரு குறிப்பிட்ட காலத்திற்கு செல்லுபடியாகும். { $hostname } க்கான சான்றிதழ் { $not-before-local-time } வரை செல்லுபடியாகாது.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = பிழைக் குறியீடு: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = வலைத்தளங்கள் தங்கள் அடையாளத்தைச் சான்றிதழ்கள்மூலம் நிரூபிக்கின்றன, அவை சான்றிதழ் நிறுவனங்களால் வழங்கப்படுகின்றன. பெரும்பாலான உலாவிகள் GeoTrust, RapidSSL, Symantec, Thawte, மற்றும் VeriSign வழங்கிய சான்றிதழ்களை நம்புவதில்லை. { $hostname } இந்த நிறுவனங்களின் ஏதோ ஒன்றிடமிருந்து சான்றிதழைப் பெற்றுள்ளது, எனவே வலைத்தளத்தின் அடையாளத்தை நிரூபிக்க முடியாது.

cert-error-symantec-distrust-admin = இந்தச் சிக்கல்குறித்து வலைத்தள நிர்வாகிக்கு நீங்கள் அறிவிக்கலாம்.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP கண்டிப்பான போக்குவரத்து பாதுகாப்பு: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP பொது விசை பிணைப்பு: { $hasHPKP }

cert-error-details-cert-chain-label = சான்றிதழ் சங்கிலி:

## Messages used for certificate error titles

connectionFailure-title = இணைக்க முடியவில்லை
deniedPortAccess-title = இந்த முகவரி தடுக்கப்பட்டுள்ளது
fileNotFound-title = கோப்பைக் காணவில்லை
fileAccessDenied-title = கோப்பு அணுகல் மறுக்கப்பட்டது
generic-title = அச்சச்சோ.
captivePortal-title = பிணையத்தினுள் புகுபதிகை
netInterrupt-title = இணைப்பில் தடங்கல் உள்ளது
notCached-title = ஆவணம் காலாவதியாகிவிட்டது
netOffline-title = இணைப்பில்லாத முறைமை
contentEncodingError-title = உள்ளடக்க குறிமுறை பிழை
unsafeContentType-title = பாதுகாப்பில்லாத கோப்பு வகை
netReset-title = இணைப்பு மீட்டமைக்கப்பட்டது
netTimeout-title = இணைப்பு நேரம் முடிந்தது
unknownProtocolFound-title = முகவரியை புரிந்து கொள்ள முடியவில்லை
proxyConnectFailure-title = பதிலாள் சேவையகம் இணைப்பை மறுக்கிறது
proxyResolveFailure-title = பதிலி சேவையகத்தைக் கண்டறிய முடியவில்லை
redirectLoop-title = பக்கத்தை ஒழுங்காகத் திருப்பிவிடவில்லை
unknownSocketType-title = சேவையகத்திலிருந்து எதிர்பாராத பதில்
nssFailure2-title = பாதுகாப்பான இணைப்பு முறிந்தது
corruptedContentError-title = சிதைந்த உள்ளடக்கப் பிழை
remoteXUL-title = தொலைநிலை XUL
sslv3Used-title = பாதுகாப்பாக இணைக்க இயலவில்லை
inadequateSecurityError-title = உங்கள் இணைப்பு பாதுகாப்பற்றது
blockedByPolicy-title = முடக்கப்பட்ட பக்கம்
