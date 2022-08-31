# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = 인증서

## Error messages

certificate-viewer-error-message = 인증서 정보를 찾을 수 없거나 인증서가 손상되었습니다. 다시 시도하세요.
certificate-viewer-error-title = 뭔가 잘못되었습니다.

## Certificate information labels

certificate-viewer-algorithm = 알고리즘
certificate-viewer-certificate-authority = 인증 기관
certificate-viewer-cipher-suite = 암호 그룹
certificate-viewer-common-name = 일반 이름
certificate-viewer-email-address = 이메일 주소
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName }에 대한 인증서
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = 법인 국가
certificate-viewer-country = 국가
certificate-viewer-curve = 곡선
certificate-viewer-distribution-point = 배포 지점
certificate-viewer-dns-name = DNS 이름
certificate-viewer-ip-address = IP 주소
certificate-viewer-other-name = 다른 이름
certificate-viewer-exponent = 지수
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = 키 교환 그룹
certificate-viewer-key-id = 키 ID
certificate-viewer-key-size = 키 크기
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = 법인 구/군/시
certificate-viewer-locality = 구/군/시
certificate-viewer-location = 위치
certificate-viewer-logid = 로그 ID
certificate-viewer-method = 메소드
certificate-viewer-modulus = 계수
certificate-viewer-name = 이름
certificate-viewer-not-after = 이 시각 이후에는 없음
certificate-viewer-not-before = 이 시각 이전에는 없음
certificate-viewer-organization = 조직
certificate-viewer-organizational-unit = 조직 단위
certificate-viewer-policy = 정책
certificate-viewer-protocol = 프로토콜
certificate-viewer-public-value = 공개 값
certificate-viewer-purposes = 용도
certificate-viewer-qualifier = 한정자
certificate-viewer-qualifiers = 한정자
certificate-viewer-required = 필수
certificate-viewer-unsupported = &lt;지원되지 않음&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = 법인 시/도
certificate-viewer-state-province = 시/도
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = 일련 번호
certificate-viewer-signature-algorithm = 서명 알고리즘
certificate-viewer-signature-scheme = 서명 체계
certificate-viewer-timestamp = 타임스탬프
certificate-viewer-value = 값
certificate-viewer-version = 버전
certificate-viewer-business-category = 사업 분야
certificate-viewer-subject-name = 주체 이름
certificate-viewer-issuer-name = 발급자 이름
certificate-viewer-validity = 유효성
certificate-viewer-subject-alt-names = 주체 대체 이름
certificate-viewer-public-key-info = 공개 키 정보
certificate-viewer-miscellaneous = 기타
certificate-viewer-fingerprints = 지문
certificate-viewer-basic-constraints = 기본 제한
certificate-viewer-key-usages = 키 사용
certificate-viewer-extended-key-usages = 확장된 키 사용
certificate-viewer-ocsp-stapling = OCSP 스테이플링
certificate-viewer-subject-key-id = 주체 키 ID
certificate-viewer-authority-key-id = 기관 키 ID
certificate-viewer-authority-info-aia = 기관 정보 (AIA)
certificate-viewer-certificate-policies = 인증서 정책
certificate-viewer-embedded-scts = 포함된 SCT
certificate-viewer-crl-endpoints = CRL 엔드포인트

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = 다운로드
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] 예
       *[false] 아니오
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (인증서)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (체인)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = 이 확장 기능은 클라이언트가 인증서를 이해하지 못할 경우 반드시 인증서를 거부해야 함을 의미하는 위험한 것으로 표시되었습니다.
certificate-viewer-export = 내보내기
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (알 수 없음)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = 개인 인증서
certificate-viewer-tab-people = 다른 사람
certificate-viewer-tab-servers = 서버
certificate-viewer-tab-ca = 인증 기관
certificate-viewer-tab-unkonwn = 알 수 없음
