# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = 연결 설정
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = 확장 기능 사용 안 함
connection-proxy-configure = 인터넷 프록시 접근 설정
connection-proxy-option-no =
    .label = 프록시 사용 안 함
    .accesskey = y
connection-proxy-option-system =
    .label = 시스템 프록시 설정 사용
    .accesskey = u
connection-proxy-option-auto =
    .label = 프록시 설정 자동 감지
    .accesskey = w
connection-proxy-option-manual =
    .label = 수동 프록시 설정
    .accesskey = m
connection-proxy-http = HTTP 프록시
    .accesskey = x
connection-proxy-http-port = 포트
    .accesskey = P
connection-proxy-https-sharing =
    .label = HTTPS에도 이 프록시를 사용
    .accesskey = s
connection-proxy-https = HTTPS 프록시
    .accesskey = H
connection-proxy-ssl-port = 포트
    .accesskey = o
connection-proxy-socks = SOCKS 호스트
    .accesskey = C
connection-proxy-socks-port = 포트
    .accesskey = t
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = 프록시 사용 안 함:
    .accesskey = n
connection-proxy-noproxy-desc = 예: .mozilla.org, .net.nz, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = localhost, 127.0.0.1/8 및 ::1에 대한 연결은 프록시가 사용되지 않습니다.
connection-proxy-autotype =
    .label = 자동 프록시 설정 URL
    .accesskey = A
connection-proxy-reload =
    .label = 새로 고침
    .accesskey = e
connection-proxy-autologin =
    .label = 비밀번호가 저장되어 있으면 인증시 묻지 않기
    .accesskey = i
    .tooltip = 저장한 자격 증명이 있으면 조용히 인증합니다. 인증이 되지 않으면 물어볼 것입니다.
connection-proxy-socks-remote-dns =
    .label = SOCKS v5를 사용할 때 DNS 프록시
    .accesskey = d
connection-dns-over-https =
    .label = DNS over HTTPS (HTTPS를 통한 DNS) 사용
    .accesskey = b
connection-dns-over-https-url-resolver = 공급자 사용
    .accesskey = P
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (기본값)
    .tooltiptext = HTTPS를 통한 DNS 확인에 기본 URL 사용
connection-dns-over-https-url-custom =
    .label = 사용자 지정
    .accesskey = C
    .tooltiptext = HTTPS를 통한 DNS 해석을 위한 선호하는 URL 입력
connection-dns-over-https-custom-label = 사용자 지정
