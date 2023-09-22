# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = 페이지 로드 중 문제 발생
certerror-page-title = 경고: 보안 위험 가능성
certerror-sts-page-title = 연결되지 않음: 잠재적인 보안 문제
neterror-blocked-by-policy-page-title = 차단된 페이지
neterror-captive-portal-page-title = 네트워크에 로그인
neterror-dns-not-found-title = 서버를 찾을 수 없음
neterror-malformed-uri-page-title = 잘못된 URL

## Error page actions

neterror-advanced-button = 고급…
neterror-copy-to-clipboard-button = 클립보드에 텍스트 복사
neterror-learn-more-link = 더 알아보기…
neterror-open-portal-login-page-button = 네트워크 로그인 페이지 열기
neterror-override-exception-button = 위험을 감수하고 계속 진행
neterror-pref-reset-button = 기본 설정으로 복원
neterror-return-to-previous-page-button = 뒤로 가기
neterror-return-to-previous-page-recommended-button = 뒤로 가기 (권장)
neterror-try-again-button = 다시 시도
neterror-add-exception-button = 이 사이트는 항상 계속 진행
neterror-settings-button = DNS 설정 변경
neterror-view-certificate-link = 인증서 보기
neterror-trr-continue-this-time = 이번만 계속
neterror-disable-native-feedback-warning = 항상 계속

##

neterror-pref-reset = 네트워크 보안 설정이 원인일 수 있습니다. 기본 설정으로 복원하시겠습니까?
neterror-error-reporting-automatic = 이러한 오류를 보고하여 { -vendor-short-name }가 악성 사이트를 식별하고 차단하는 것을 돕습니다.

## Specific error messages

neterror-generic-error = { -brand-short-name }가 어떠한 이유로 인하여 이 페이지를 읽을 수 없습니다.
neterror-load-error-try-again = 서버가 일시적으로 사용할 수 없거나 사용자가 너무 많은 상태일 수 있습니다. 잠시 후에 다시 시도해 보세요.
neterror-load-error-connection = 어떤 페이지도 열 수 없다면, 컴퓨터의 네트워크 연결을 확인해 보세요.
neterror-load-error-firewall = 사용자의 컴퓨터나 네트워크가 방화벽 또는 프록시로 보호되고 있다면, { -brand-short-name }가 웹에 접근할 수 있도록 허용되어 있는지 확인해 보세요.
neterror-captive-portal = 인터넷을 사용하기 위해서 반드시 이 네트워크에 로그인해야 합니다.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = <a data-l10n-name="website">{ $hostAndPath }</a> 사이트로 이동하시겠습니까?
neterror-dns-not-found-hint-header = <strong>올바른 주소를 입력한 경우, 다음을 수행할 수 있습니다:</strong>
neterror-dns-not-found-hint-try-again = 나중에 다시 시도하세요
neterror-dns-not-found-hint-check-network = 네트워크 연결을 확인해 보세요
neterror-dns-not-found-hint-firewall = { -brand-short-name }에 웹 액세스 권한이 있는지 확인하세요 (연결되어 있지만 방화벽 뒤에 있을 수 있음)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name }는 신뢰할 수 있는 DNS 확인자를 통해 이 사이트 주소에 대한 요청을 보호할 수 없습니다. 이유:
neterror-dns-not-found-trr-third-party-warning2 = 기본 DNS 확인자로 계속 사용할 수 있습니다. 그러나 제3자는 사용자가 방문하는 웹 사이트를 볼 수 있습니다.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name }가 { $trrDomain }에 연결할 수 없습니다.
neterror-dns-not-found-trr-only-timeout = { $trrDomain }에 대한 연결이 예상보다 오래 걸렸습니다.
neterror-dns-not-found-trr-offline = 인터넷에 연결되어 있지 않습니다.
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain }이(가) 이 웹 사이트를 찾지 못했습니다.
neterror-dns-not-found-trr-server-problem = { $trrDomain }에 문제가 있습니다.
neterror-dns-not-found-bad-trr-url = 잘못된 URL.
neterror-dns-not-found-trr-unknown-problem = 예기치 않은 문제.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name }는 신뢰할 수 있는 DNS 확인자를 통해 이 사이트 주소에 대한 요청을 보호할 수 없습니다. 이유:
neterror-dns-not-found-native-fallback-heuristic = 네트워크에서 DNS over HTTP (HTTPS를 통한 DNS)가 비활성화되었습니다.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name }가 { $trrDomain }에 연결할 수 없습니다.

##

neterror-file-not-found-filename = 파일 이름에 대문자 또는 기타 입력 오류가 있는지 확인해 보세요.
neterror-file-not-found-moved = 파일이 이동, 이름 변경 또는 삭제되었는지 확인해 보세요.
neterror-access-denied = 삭제, 이동 또는 권한이 없어서 접근할 수 없습니다.
neterror-unknown-protocol = 이 주소를 열기 위해서는 다른 소프트웨어를 설치할 필요가 있습니다.
neterror-redirect-loop = 이 문제는 드물게 해당 사이트에서 요구하는 쿠키를 차단하여 발생할 수 있습니다.
neterror-unknown-socket-type-psm-installed = 시스템에 개인 보안 관리자가 설치 되어 있는지 확인해 보세요.
neterror-unknown-socket-type-server-config = 서버의 정상적이지 않은 설정 때문일 수도 있습니다.
neterror-not-cached-intro = 요청하신 문서는 { -brand-short-name } 캐시에서 사용할 수 없습니다.
neterror-not-cached-sensitive = 보안 예방책으로 { -brand-short-name }는 자동으로 민감한 문서를 다시 요청하지 않습니다.
neterror-not-cached-try-again = 웹 사이트에서 문서를 다시 요청하려면 다시 시도를 누르세요.
neterror-net-offline = 온라인 모드로 전환하고 페이지를 다시 로드하려면 “다시 시도"를 누르세요.
neterror-proxy-resolve-failure-settings = 프록시 설정이 올바로 되어있는지 확인해 보세요.
neterror-proxy-resolve-failure-connection = 사용자 컴퓨터가 활성화된 네트워크 연결을 사용하는지 확인해 보세요.
neterror-proxy-resolve-failure-firewall = 사용자의 컴퓨터나 네트워크가 방화벽 또는 프록시로 보호되고 있다면, { -brand-short-name }가 웹에 접근할 수 있도록 허용되어 있는지 확인해 보세요.
neterror-proxy-connect-failure-settings = 프록시 설정이 올바로 되어있는지 확인해 보세요.
neterror-proxy-connect-failure-contact-admin = 프록시 서버가 확실히 작동 중인지 네트워크 관리자에게 문의하세요.
neterror-content-encoding-error = 웹 사이트 관리자에게 연락하여 이 문제를 알려주실 수 있습니다.
neterror-unsafe-content-type = 웹 사이트 관리자에게 연락하여 이 문제를 알려주실 수 있습니다.
neterror-nss-failure-not-verified = 받은 데이터의 신뢰성을 확인할 수 없으므로 보시려는 페이지를 표시할 수 없습니다.
neterror-nss-failure-contact-website = 웹 사이트 관리자에게 연락하여 이 문제를 알려주실 수 있습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name }가 잠재적인 보안 위협을 감지하고 <b>{ $hostname }</b> 사이트로 진행하지 않았습니다. 사이트를 방문하면 공격자가 비밀번호나 이메일, 신용카드와 같은 정보를 탈취할 수 있습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = 이 웹 사이트는 보안 연결을 필요로 하므로 { -brand-short-name }가 잠재적인 보안 위협을 감지하고 <b>{ $hostname }</b> 사이트로 진행하지 않았습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name }가 문제를 감지하여 <b>{ $hostname }</b> 사이트로 진행하지 않았습니다. 웹 사이트가 잘못 구성되었거나 사용자의 컴퓨터 시계가 잘못된 시간으로 설정되어 있습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b>은 안전한 사이트로 보이지만 보안 연결을 설정할 수 없습니다. 이 문제는 소프트웨어나 네트워크 문제인 <b>{ $mitm }</b>로 인해 발생합니다.
neterror-corrupted-content-intro = 데이터 전송에 오류가 감지되어 페이지를 표시할 수 없습니다.
neterror-corrupted-content-contact-website = 웹 사이트 관리자에게 연락하여 이 문제를 알려주실 수 있습니다.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = 고급 정보: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b>이 오래되어서 공격에 안전하지 않은 보안 기술을 사용하고 있습니다. 사용자가 안전하다고 여길 수 있는 정보를 공격자가 쉽게 탈취할 수 있습니다. 사용자가 사이트에 방문하기 위해서는 웹 사이트 관리자가 서버를 고쳐야 합니다.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = 오류 코드: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = 컴퓨터의 시계가 { DATETIME($now, dateStyle: "medium") }으로 설정되어 있어서 { -brand-short-name }가 안전하게 연결을 할 수 없습니다. <b>{ $hostname }</b> 방문을 위해서는 컴퓨터의 시계를 올바른 날짜, 시간 및 시간대로 설정하시고 난 후, <b>{ $hostname }</b>를 다시 로드하세요.
neterror-network-protocol-error-intro = 네트워크 프로토콜에 오류가 감지되어 페이지를 표시할 수 없습니다.
neterror-network-protocol-error-contact-website = 웹 사이트 관리자에게 연락하여 이 문제를 알려주실 수 있습니다.
certerror-expired-cert-second-para = 웹 사이트의 인증서가 만료되어 { -brand-short-name }가 안전하게 연결할 수 없습니다. 사이트를 방문하면 공격자가 비밀번호나 이메일, 신용카드와 같은 정보를 탈취할 수 있습니다.
certerror-expired-cert-sts-second-para = 웹 사이트의 인증서가 만료되어 { -brand-short-name }가 안전하게 연결할 수 없습니다.
certerror-what-can-you-do-about-it-title = 사용자가 무엇을 할 수 있습니까?
certerror-unknown-issuer-what-can-you-do-about-it-website = 이러한 문제는 대부분 웹 사이트와 관련이 있고 사용자가 할 수 있는 일은 없습니다.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = 회사 네트워크를 사용하고 있고 바이러스 백신 소프트웨어를 사용하고 있다면 지원부서에 지원을 요청할 수 있습니다. 웹 사이트의 관리자에게 문제에 대해 알려주실 수 있습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = 컴퓨터의 시계가 { DATETIME($now, dateStyle: "medium") }로 설정되어 있습니다. 컴퓨터가 시스템 설정에서 올바른 날짜, 시간 및 시간대로 설정되어 있는지 확인하시고 <b>{ $hostname }</b>를 다시 로드하세요.
certerror-expired-cert-what-can-you-do-about-it-contact-website = 시계가 이미 올바른 시간으로 설정되어 있으면, 웹 사이트가 잘못 구성되었을 수 있으며 문제를 해결하기 위해 사용자가 할 수 있는 일은 없습니다. 웹 사이트의 관리자에게 문제에 대해 알려주실 수 있습니다.
certerror-bad-cert-domain-what-can-you-do-about-it = 이러한 문제는 대부분 웹 사이트와 관련이 있고 사용자가 할 수 있는 일은 없습니다. 웹 사이트의 관리자에게 문제에 대해 알려주실 수 있습니다.
certerror-mitm-what-can-you-do-about-it-antivirus = 사용하고 있는 바이러스 백신 소프트웨어가 암호화된 연결을 스캔하는 기능(“웹 스캔”이나 “https 스캔”)을 가지고 있다면 이 기능을 꺼볼 수 있습니다. 그래도 동작하지 않으면 바이러스 백신 소프트웨어를 삭제하고 재설치해 볼 수 있습니다.
certerror-mitm-what-can-you-do-about-it-corporate = 회사 망을 사용하고 있다면 IT 부서에 문의하세요.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = <b>{ $mitm }</b>에 익숙하지 않다면 이것은 공격일 수 있으므로 사이트로 진행해서는 안됩니다.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = <b>{ $mitm }</b>에 익숙하지 않다면 이것은 공격일 수 있고 사이트에 접근할 수 있는 방법이 없습니다.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> 사이트는 HTTP Strict Transport Security (HSTS)라는 보안 정책을 가지고 있어서 { -brand-short-name }가 보안 연결만 할 수 있습니다. 이 사이트를 방문하기 위해 예외를 추가 할 수 없습니다.
