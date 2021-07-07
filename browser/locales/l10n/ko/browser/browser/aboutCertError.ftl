# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname }는 유효하지 않은 보안 인증서를 사용합니다.

cert-error-mitm-intro = 웹 사이트는 인증 기관에 의해 발급된 인증서를 통해 신원을 증명합니다.

cert-error-mitm-mozilla = { -brand-short-name }는 완전히 개방 된 CA(Certificate Authority) 저장소를 관리하는 비영리 재단 Waterfox의 지원을받습니다. CA 저장소는 인증 기관이 사용자 보안을 위한 모범 사례를 따르도록 합니다.

cert-error-mitm-connection = { -brand-short-name }는 사용자의 운영 체제가 제공하는 인증서가 아닌 Waterfox CA 저장소를 사용하여 연결이 안전한지 확인합니다. 따라서 바이러스 백신 프로그램이나 네트워크가 Waterfox CA 저장소에 없는 CA에서 발급한 보안 인증서로 연결을 가로채는 경우 연결이 안전하지 않은 것으로 간주됩니다.

cert-error-trust-unknown-issuer-intro = 누군가 사이트를 위장할 수 있기 때문에 더 이상 진행하면 안됩니다.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = 웹 사이트는 인증서를 통해 신원을 증명합니다. { -brand-short-name }는 인증서 발급자를 알 수 없거나, 인증서가 자체 서명되었거나 서버가 올바른 중간 인증서를 보내지 않고 있기 때문에 { $hostname } 사이트를 신뢰할 수 없습니다.

cert-error-trust-cert-invalid = 유효하지 않은 인증 기관 (CA) 인증서로 발급된 인증서이므로 신뢰할 수 없습니다.

cert-error-trust-untrusted-issuer = 발급자 인증서를 신뢰할 수 없기 때문에 인증서를 신뢰할 수 없습니다.

cert-error-trust-signature-algorithm-disabled = 비활성화된 안전하지 않은 알고리즘을 사용하여 서명되었기 때문에 인증서를 신뢰할 수 없습니다.

cert-error-trust-expired-issuer = 발급자 인증서가 만료되었기 때문에 인증서를 신뢰할 수 없습니다.

cert-error-trust-self-signed = 자기 스스로 서명하였으므로 인증서를 신뢰할 수 없습니다.

cert-error-trust-symantec = GeoTrust나 RapidSSL, Symantec, Thawte, VeriSign이 발급한 인증서는 이전에 보안 관행을 따르지 않았기 때문에 더 이상 안전한 것으로 간주되지 않습니다.

cert-error-untrusted-default = 신뢰할 수 있는 출처의 인증서가 아닙니다.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = 웹 사이트는 인증서로 신원을 증명합니다. { -brand-short-name }는 이 사이트가 { $hostname }에 대해 유효하지 않은 인증서를 사용하고 있기 때문에 신뢰하지 않습니다.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = 웹 사이트는 인증서로 신원을 증명합니다. { -brand-short-name }는 이 사이트가 { $hostname }에 대해 유효하지 않은 인증서를 사용하고 있기 때문에 신뢰하지 않습니다. 인증서가 <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>에 대해서만 유효합니다.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = 웹 사이트는 인증서로 신원을 증명합니다. { -brand-short-name }는 이 사이트가 { $hostname }에 대해 유효하지 않은 인증서를 사용하고 있기 때문에 신뢰하지 않습니다. 인증서가 { $alt-name }에 대해서만 유효합니다.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = 웹 사이트는 인증서로 신원을 증명합니다. { -brand-short-name }는 이 사이트가 { $hostname }에 대해 유효하지 않은 인증서를 사용하고 있기 때문에 신뢰하지 않습니다. 인증서는 다음의 이름에 대해서만 유효합니다: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = 웹 사이트는 지정된 기간동안 유효한 인증서를 통해 신원을 증명합니다. { $hostname }의 인증서가 { $not-after-local-time }에 만료되었습니다.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = 웹 사이트는 지정된 기간동안 유효한 인증서를 통해 신원을 증명합니다. { $hostname }의 인증서가 { $not-before-local-time }까지 유효하지 않습니다.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = 오류 코드: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = 웹 사이트는 인증 기관에서 발급한 인증서를 통해 신원을 증명합니다. 대부분의 브라우저는 더 이상 GeoTrust나 RapidSSL, Symantec, Thawte, VeriSign에서 발급 한 인증서를 신뢰하지 않습니다. { $hostname }은 이러한 인증 중 하나를 사용하므로 웹 사이트 자신을 증명할 수 없습니다.

cert-error-symantec-distrust-admin = 웹 사이트의 관리자에게 이 문제에 대해 알려주실 수 있습니다.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP 보안 강화 프로토콜: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP 공개 키 고정: { $hasHPKP }

cert-error-details-cert-chain-label = 인증 체인:

open-in-new-window-for-csp-or-xfo-error = 사이트를 새 창에 열기

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = 보안을 위해 { $hostname } 사이트는 다른 사이트에서 해당 페이지를 포함하면 { -brand-short-name }가 페이지를 표시하지 못하게 합니다. 이 페이지를 보려면 새 창에 열어야 합니다.

## Messages used for certificate error titles

connectionFailure-title = 연결할 수 없음
deniedPortAccess-title = 이 주소는 제한되어 있음
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = 해당 사이트를 찾는데 문제가 발생하였습니다.
fileNotFound-title = 파일을 찾을 수 없음
fileAccessDenied-title = 파일 접근이 거부됨
generic-title = 이런.
captivePortal-title = 네트워크에 로그인
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = 주소가 올바르지 않습니다.
netInterrupt-title = 연결이 중단되었습니다
notCached-title = 문서 만료
netOffline-title = 오프라인 모드
contentEncodingError-title = 콘텐츠 인코딩 오류
unsafeContentType-title = 안전하지 않은 파일 형식
netReset-title = 연결 초기화
netTimeout-title = 연결 시간 초과
unknownProtocolFound-title = 인식할 수 없는 주소
proxyConnectFailure-title = 프록시 서버가 연결을 거부함
proxyResolveFailure-title = 프록시 서버를 찾을 수 없음
redirectLoop-title = 페이지가 제대로 리디렉션되지 않음
unknownSocketType-title = 서버에서 예기치 않은 응답
nssFailure2-title = 보안 연결 실패
csp-xfo-error-title = { -brand-short-name }가 이 페이지를 열 수 없음
corruptedContentError-title = 손상된 콘텐츠 오류
remoteXUL-title = 원격 XUL
sslv3Used-title = 보안 연결을 할 수 없음
inadequateSecurityError-title = 연결이 안전하지 않음
blockedByPolicy-title = 차단된 페이지
clockSkewError-title = 컴퓨터의 시각이 올바르지 않음
networkProtocolError-title = 네트워크 프로토콜 오류
nssBadCert-title = 경고: 보안 위험 가능성
nssBadCert-sts-title = 연결되지 않음: 잠재적인 보안 문제
certerror-mitm-title = { -brand-short-name }가 이 사이트에 안전하게 연결하는 것을 소프트웨어가 막고 있습니다.
