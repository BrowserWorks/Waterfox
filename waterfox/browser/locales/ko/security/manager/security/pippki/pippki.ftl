# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = 비밀번호 수준 측정

## Change Password dialog

change-device-password-window =
    .title = 비밀번호 변경
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = 보안 장치: { $tokenName }
change-password-old = 현재 비밀번호:
change-password-new = 새 비밀번호:
change-password-reenter = 새 비밀번호(재입력):
pippki-failed-pw-change = 비밀번호를 변경할 수 없습니다.
pippki-incorrect-pw = 현재 비밀번호를 올바르게 입력하지 않았습니다. 다시 시도하세요.
pippki-pw-change-ok = 비밀번호가 성공적으로 변경되었습니다.
pippki-pw-empty-warning = 저장된 비밀번호와 개인 키는 보호되지 않습니다.
pippki-pw-erased-ok = 비밀번호가 제거되었습니다. { pippki-pw-empty-warning }
pippki-pw-not-wanted = 경고! 비밀번호를 사용하지 않기로 설정했습니다. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = 현재 FIPS 모드입니다. FIPS는 비밀번호가 설정되어야 합니다.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = 기본 비밀번호 재설정
    .style = min-width: 40em
reset-password-button-label =
    .label = 재설정
reset-primary-password-text = 기본 비밀번호를 재설정하면, 저장된 모든 웹, 이메일 비밀번호, 양식 데이터, 개인 인증서 및 개인 키에 접근하지 못하게 됩니다. 정말로 기본 비밀번호를 재설정하시겠습니까?
pippki-reset-password-confirmation-title = 기본 비밀번호 재설정
pippki-reset-password-confirmation-message = 기본 비밀번호가 재설정되었습니다.

## Downloading cert dialog

download-cert-window2 =
    .title = 인증서 다운로드 중
    .style = min-width: 46em
download-cert-message = 새 인증 기관 (CA)을 신뢰하라는 요청을 받았습니다.
download-cert-trust-ssl =
    .label = 신뢰된 인증 기관 (웹 사이트)
download-cert-trust-email =
    .label = 신뢰된 인증 기관 (메일)
download-cert-message-desc = 인증 기관을 신뢰하기 전에 인증 기관의 정책과 발급 절차를 확인하세요.
download-cert-view-cert =
    .label = 보기
download-cert-view-text = 인증 기관 인증서 조사

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = 개인 인증서 요청
client-auth-site-description = 이 사이트에서 인증서로 본인을 식별하도록 요청:
client-auth-choose-cert = 제공할 인증서 선택:
client-auth-send-no-certificate =
    .label = 인증서를 보내지 않음
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = “{ $hostname }” 사이트에서 인증서로 본인을 식별하도록 요청:
client-auth-cert-details = 선택한 인증서 상세 정보
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = 발급 대상: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = 일련 번호: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = { $notBefore }에서 { $notAfter }까지 유효
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = 키 사용처: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = 이메일 주소: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = 발급자: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = 저장소: { $storedOn }
client-auth-cert-remember-box =
    .label = 이 선택 기억하기

## Set password (p12) dialog

set-password-window =
    .title = 인증서 백업 비밀번호 입력
set-password-message = 입력하신 인증서 백업 비밀번호는 곧 생성할 인증서 백업 파일을 보호합니다.  백업을 계속하려면 반드시 비밀번호를 설정해야 합니다.
set-password-backup-pw =
    .value = 인증서 백업 비밀번호:
set-password-repeat-backup-pw =
    .value = 인증서 백업 비밀번호 (재입력):
set-password-reminder = 중요: 만약 인증서 백업 비밀번호를 분실하면 백업한 인증서를 다시 가져올 수 없습니다.  안전한 곳에 기록해 두세요.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = “{ $tokenName }” 토큰으로 인증하세요. 이를 수행하는 방법은 토큰에 따라 다릅니다 (예: 지문 판독기 사용 또는 키패드로 코드 입력).
