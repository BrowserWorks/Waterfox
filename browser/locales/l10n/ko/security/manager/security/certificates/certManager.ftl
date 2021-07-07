# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = 인증서 관리자
certmgr-tab-mine =
    .label = 개인 인증서
certmgr-tab-remembered =
    .label = 인증 결정
certmgr-tab-people =
    .label = 다른 사람
certmgr-tab-servers =
    .label = 서버
certmgr-tab-ca =
    .label = 인증 기관
certmgr-mine = 사용자를 확인하는 이 기관의 인증서를 가지고 있습니다
certmgr-remembered = 이 인증서는 웹 사이트에서 사용자를 식별하는 데 사용됩니다.
certmgr-people = 다음 사람들을 확인하는 파일의 인증서를 가지고 있습니다
certmgr-servers = 다음 서버들을 확인하는 파일의 인증서를 가지고 있습니다
certmgr-server = 이 항목은 서버 인증서 오류 예외를 식별합니다.
certmgr-ca = 다음 인증 권한을 확인하는 파일의 인증서를 가지고 있습니다
certmgr-detail-general-tab-title =
    .label = 일반
    .accesskey = G
certmgr-detail-pretty-print-tab-title =
    .label = 상세 정보
    .accesskey = D
certmgr-pending-label =
    .value = 현재 인증서 확인 중…
certmgr-subject-label = 발급 대상
certmgr-issuer-label = 발급자
certmgr-period-of-validity = 유효 기간
certmgr-fingerprints = 지문
certmgr-cert-detail =
    .title = 인증서 상세 설명
    .buttonlabelaccept = 닫기
    .buttonaccesskeyaccept = C
certmgr-cert-detail-commonname = 일반 이름 (CN)
certmgr-cert-detail-org = 조직 (O)
certmgr-cert-detail-orgunit = 조직 단위 (OU)
certmgr-cert-detail-serial-number = 일련 번호
certmgr-cert-detail-sha-256-fingerprint = SHA-256 지문
certmgr-cert-detail-sha-1-fingerprint = SHA1 지문
certmgr-edit-ca-cert =
    .title = CA 인증서 신뢰도 설정 편집
    .style = width: 48em;
certmgr-edit-cert-edit-trust = 신뢰도 설정 편집:
certmgr-edit-cert-trust-ssl =
    .label = 아래 인증서는 웹 사이트를 인증합니다.
certmgr-edit-cert-trust-email =
    .label = 아래 인증서는 메일 사용자를 인증합니다.
certmgr-delete-cert =
    .title = 인증서 삭제
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = 호스트
certmgr-cert-name =
    .label = 인증서 이름
certmgr-cert-server =
    .label = 서버
certmgr-override-lifetime =
    .label = 수명
certmgr-token-name =
    .label = 보안 장치
certmgr-begins-on = 시작일
certmgr-begins-label =
    .label = 시작일
certmgr-expires-on = 만료일
certmgr-expires-label =
    .label = 만료일
certmgr-email =
    .label = 메일 주소
certmgr-serial =
    .label = 일련 번호
certmgr-view =
    .label = 보기…
    .accesskey = V
certmgr-edit =
    .label = 신뢰 편집…
    .accesskey = E
certmgr-export =
    .label = 내보내기…
    .accesskey = x
certmgr-delete =
    .label = 삭제…
    .accesskey = D
certmgr-delete-builtin =
    .label = 삭제 또는 신뢰 안 함…
    .accesskey = D
certmgr-backup =
    .label = 백업…
    .accesskey = B
certmgr-backup-all =
    .label = 전체 백업…
    .accesskey = k
certmgr-restore =
    .label = 가져오기…
    .accesskey = m
certmgr-details =
    .value = 인증서 항목
    .accesskey = F
certmgr-fields =
    .value = 항목값
    .accesskey = V
certmgr-hierarchy =
    .value = 인증서 계층 구조
    .accesskey = H
certmgr-add-exception =
    .label = 예외 추가…
    .accesskey = x
exception-mgr =
    .title = 보안 예외 추가
exception-mgr-extra-button =
    .label = 보안 예외 확인
    .accesskey = C
exception-mgr-supplemental-warning = 합법적인 은행, 상점 및 기타 공공 사이트에서는 이를 요구하지 않습니다.
exception-mgr-cert-location-url =
    .value = 주소:
exception-mgr-cert-location-download =
    .label = 인증서 받기
    .accesskey = G
exception-mgr-cert-status-view-cert =
    .label = 보기…
    .accesskey = V
exception-mgr-permanent =
    .label = 예외 영구 저장
    .accesskey = P
pk11-bad-password = 입력한 비밀번호가 맞지 않습니다.
pkcs12-decode-err = 파일 복호화가 실패했습니다. PKCS #12 형식이 아니거나, 손상되었거나, 입력하신 비밀번호가 잘못되었습니다.
pkcs12-unknown-err-restore = 알 수 없는 이유로 PKCS #12 파일 복원을 실패했습니다.
pkcs12-unknown-err-backup = 알 수 없는 이유로 PKCS #12 백업 파일 생성을 실패했습니다.
pkcs12-unknown-err = 알 수 없는 이유로 PKCS #12 작업을 실패했습니다.
pkcs12-info-no-smartcard-backup = 스마트카드와 같은 하드웨어 보안 장치로부터의 인증서 백업은 불가능합니다.
pkcs12-dup-data = 인증서와 개인키가 이미 보안 장치에 있습니다.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = 백업할 파일 이름
file-browse-pkcs12-spec = PKCS12 파일
choose-p12-restore-file-dialog = 가져올 인증서 파일

## Import certificate(s) file dialog

file-browse-certificate-spec = 인증서 파일
import-ca-certs-prompt = 가져올 CA 인증서를 포함하는 파일 선택
import-email-cert-prompt = 가져올 메일 인증서를 포함하는 파일 선택

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = { $certName } 인증서는 인증 기관을 의미합니다.

## For Deleting Certificates

delete-user-cert-title =
    .title = 개인 인증서 삭제
delete-user-cert-confirm = 정말로 이 인증서를 삭제하시겠습니까?
delete-user-cert-impact = 개인 인증서를 삭제하면 더 이상 사용할 수 없습니다.
delete-ssl-cert-title =
    .title = 서버 인증서 예외 삭제
delete-ssl-cert-confirm = 다음 서버 예외를 삭제하시겠습니까?
delete-ssl-cert-impact = 만약 서버 예외를 삭제하면, 해당 서버에 대한 일반적인 보안 확인을 복원하고 유효한 인증서 사용을 요구하게 됩니다.
delete-ssl-override-title =
    .title = 서버 인증서 예외 삭제
delete-ssl-override-confirm = 다음 서버 예외를 삭제하시겠습니까?
delete-ssl-override-impact = 만약 서버 예외를 삭제하면, 해당 서버에 대한 일반적인 보안 확인을 복원하고 유효한 인증서 사용을 요구하게 됩니다.
delete-ca-cert-title =
    .title = CA 인증서 삭제 또는 신뢰 안 함
delete-ca-cert-confirm = CA 인증서 삭제를 요청하셨습니다. 기본 제공 인증서의 경우 모든 신뢰가 제거되며 동일한 효과가 있습니다. 삭제 또는 신뢰 안 함으로 하시겠습니까?
delete-ca-cert-impact = 만약 인증 기관 (CA) 인증서를 삭제하거나 신뢰 안 함으로 하면, 이 애플리케이션은 해당 CA에서 발급한 인증서를 더 이상 신뢰하지 않습니다.
delete-email-cert-title =
    .title = 전자 메일 인증서 삭제
delete-email-cert-confirm = 다른 사람의 전자 메일 인증서를 삭제하시겠습니까?
delete-email-cert-impact = 개인 전자 메일 인증서를 삭제하면 더 이상 암호화된 메일을 보낼 수 없게 됩니다.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = 일련 번호 인증서: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = 인증서 뷰어: “{ $certName }”
not-present =
    .value = <인증서 형식 아님>
# Cert verification
cert-verified = 아래 용도를 위한 인증서로 확인됨:
# Add usage
verify-ssl-client =
    .value = SSL 클라이언트 인증서
verify-ssl-server =
    .value = SSL 서버 인증서
verify-ssl-ca =
    .value = SSL 인증 기관
verify-email-signer =
    .value = 메일 서명자 인증서
verify-email-recip =
    .value = 메일 수신자 인증서
# Cert verification
cert-not-verified-cert-revoked = 인증서가 폐기되어 인증서를 확인할 수 없습니다.
cert-not-verified-cert-expired = 인증서가 만료되어 확인할 수 없습니다.
cert-not-verified-cert-not-trusted = 신뢰되지 않아 인증서를 확인할 수 없습니다.
cert-not-verified-issuer-not-trusted = 발급자가 신뢰되지 않아 인증서를 확인할 수 없습니다.
cert-not-verified-issuer-unknown = 발급자를 알 수 없어 인증서를 확인할 수 없습니다.
cert-not-verified-ca-invalid = CA 인증서가 유효하지 않아 인증서를 확인할 수 없습니다.
cert-not-verified_algorithm-disabled = 비활성화된 안전하지 않은 알고리즘을 사용하여 서명되었기 때문에 이 인증서를 확인할 수 없습니다.
cert-not-verified-unknown = 알 수 없는 이유로 인증서를 확인할 수 없습니다.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = 클라이언트 인증서를 보내지 않음
# Used when no cert is stored for an override
no-cert-stored-for-override = (저장 안 됨)

## Used to show whether an override is temporary or permanent

permanent-override = 영구
temporary-override = 임시

## Add Security Exception dialog

add-exception-branded-warning = { -brand-short-name }가 사이트를 식별하는 방법을 사용자가 다시 설정하려고 합니다.
add-exception-invalid-header = 이 사이트는 유효하지 않은 정보로 인증을 시도하고 있습니다.
add-exception-domain-mismatch-short = 잘못된 사이트
add-exception-domain-mismatch-long = 이 인증서는 다른 웹 사이트의 인증서로서 누군가 이 사이트를 사칭하고 있을 수 있습니다.
add-exception-expired-short = 만료 정보
add-exception-expired-long = 인증서가 현재 유효하지 않습니다. 인증서가 도난, 또는 분실되었을 수 있고 누군가 이 사이트를 사칭하고 있을 수 있습니다.
add-exception-unverified-or-bad-signature-short = 확인되지 않음
add-exception-unverified-or-bad-signature-long = 안전한 서명을 사용한 믿을 수 있는 권한에 의해 발급된 것으로 확인되지 않기 때문에 이 인증은 신뢰할 수 없습니다.
add-exception-valid-short = 유효한 인증서
add-exception-valid-long = 이 사이트는 유효하고 확인된 신원 정보를 제공합니다. 예외에 추가할 필요가 없습니다.
add-exception-checking-short = 정보 확인 중
add-exception-checking-long = 사이트 인증 시도 중…
add-exception-no-cert-short = 정보가 없음
add-exception-no-cert-long = 사이트에 대한 인증 정보를 얻을 수 없습니다.

## Certificate export "Save as" and error dialogs

save-cert-as = 인증서를 파일로 저장
cert-format-base64 = X.509 인증서 (PEM)
cert-format-base64-chain = X.509 체인 인증서 (PEM)
cert-format-der = X.509 인증서 (DER)
cert-format-pkcs7 = X.509 인증서 (PKCS #7)
cert-format-pkcs7-chain = X.509 체인 인증서 (PKCS #7)
write-file-failure = 파일 오류
