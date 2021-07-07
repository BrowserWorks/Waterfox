# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = 제공 업체 사용
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (기본값)
    .tooltiptext = HTTPS를 통한 DNS 처리에 기본 URL 사용

connection-dns-over-https-url-custom =
    .label = 사용자 정의
    .accesskey = C
    .tooltiptext = HTTPS를 통한 DNS를 해결하는 선호하는 URL을 입력

connection-dns-over-https-custom-label = 사용자 정의

connection-dialog-window =
    .title = 인터넷 연결 설정
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = 프록시 설정

proxy-type-no =
    .label = 프록시 사용 안함
    .accesskey = y

proxy-type-wpad =
    .label = 자동 설정
    .accesskey = w

proxy-type-system =
    .label = 시스템 프록시 설정 사용
    .accesskey = u

proxy-type-manual =
    .label = 수동 설정
    .accesskey = m

proxy-http-label =
    .value = HTTP 프록시:
    .accesskey = h

http-port-label =
    .value = 포트:
    .accesskey = p

proxy-http-sharing =
    .label = HTTPS에도 이 프록시를 사용
    .accesskey = x

proxy-https-label =
    .value = HTTPS 프록시:
    .accesskey = S

ssl-port-label =
    .value = 포트:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS 호스트:
    .accesskey = c

socks-port-label =
    .value = 포트:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = 자동 프록시 설정 URL:
    .accesskey = A

proxy-reload-label =
    .label = 새로 고침
    .accesskey = l

no-proxy-label =
    .value = 프록시 사용 안 함:
    .accesskey = n

no-proxy-example = 예: .mozilla.or.kr, .net.nz 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Localhost나 127.0.0.1, ::1로의 연결은 프록시 되지 않습니다.

proxy-password-prompt =
    .label = 비밀번호가 저장되어 있으면 인증시 묻지 않기
    .accesskey = i
    .tooltiptext = 저장한 자격 증명이 있으면 조용히 인증합니다. 인증이 되지 않으면 물어볼 것입니다.

proxy-remote-dns =
    .label = SOCKS v5를 사용할 때 프록시 DNS
    .accesskey = d

proxy-enable-doh =
    .label = HTTPS를 통한 DNS 활성화
    .accesskey = b
