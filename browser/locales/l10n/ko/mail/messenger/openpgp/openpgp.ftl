# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = 암호화되거나 디지털 서명 된 메시지를 보내려면 OpenPGP 또는 S/MIME과 같은 암호화 기술을 구성해야 합니다.
e2e-intro-description-more = OpenPGP 사용을 활성화하려면 개인 키를 선택하고 S/MIME 사용을 활성화하려면 개인 인증서를 선택합니다. 개인 키 또는 인증서의 경우 해당 비밀 키를 소유합니다.
openpgp-key-user-id-label = 계정 / 사용자 ID
openpgp-keygen-title-label =
    .title = OpenPGP 키 생성
openpgp-cancel-key =
    .label = 취소
    .tooltiptext = 키 생성 취소
openpgp-key-gen-expiry-title =
    .label = 키 만료
openpgp-key-gen-expire-label = 키 만료일:
openpgp-key-gen-days-label =
    .label = 일
openpgp-key-gen-months-label =
    .label = 월
openpgp-key-gen-years-label =
    .label = 년
openpgp-key-gen-no-expiry-label =
    .label = 키 만료되지 않음
openpgp-key-gen-key-size-label = 키 크기
openpgp-key-gen-console-label = 키 생성
openpgp-key-gen-key-type-label = 키 유형
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (타원 곡선)
openpgp-generate-key =
    .label = 키 생성
    .tooltiptext = 암호화 및 서명을 위한 신규 Open PGP 키 생성
openpgp-advanced-prefs-button-label =
    .label = 고급 설정…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">참고 : 키 생성을 완료하는 데 최대 몇 분이 걸릴 수 있습니다.</a> 키 생성이 진행되는 동안 애플리케이션을 종료하지 마십시오. 키 생성 중에 적극적으로 검색하거나 디스크 집약적인 작업을 수행하면 '무작위 풀'이 보충되고 프로세스 속도가 빨라집니다. 키 생성이 완료되면 경고가 표시됩니다.
openpgp-key-expiry-label =
    .label = 만료
openpgp-key-id-label =
    .label = 키 ID
openpgp-cannot-change-expiry = 구조가 복잡한 키이므로 만료일 변경은 지원되지 않습니다.
openpgp-key-man-title =
    .title = OpenPGP 키 관리자
openpgp-key-man-generate =
    .label = 새로운 키 페어
    .accesskey = K
openpgp-key-man-gen-revoke =
    .label = 인증서 폐기
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = 폐기 인증서 생성 및 저장
openpgp-key-man-file-menu =
    .label = 파일
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = 편집
    .accesskey = E
openpgp-key-man-view-menu =
    .label = 보기
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = 생성
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = 키 서버
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = 파일에서 공개 키 가져 오기
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = 파일에서 비밀 키 가져 오기
openpgp-key-man-import-sig-from-file =
    .label = 파일에서 폐기 항목 가져 오기
openpgp-key-man-import-from-clipbrd =
    .label = 클립 보드에서 키 가져 오기
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = URL에서 키 가져 오기
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = 공개 키를 파일로 내보내기
    .accesskey = E
openpgp-key-man-send-keys =
    .label = 이메일로 공개 키 보내기
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = 비밀 키를 파일로 백업
    .accesskey = B
openpgp-key-man-discover-cmd =
    .label = 온라인에서 키 찾기
    .accesskey = D
openpgp-key-man-discover-prompt = 온라인, 키 서버 또는 WKD 프로토콜을 사용하여 OpenPGP 키를 검색하려면 이메일 주소 또는 키 ID를 입력합니다.
openpgp-key-man-discover-progress = 검색 중…
openpgp-key-copy-key =
    .label = 공개 키 복사
    .accesskey = C
openpgp-key-export-key =
    .label = 공개 키를 파일로 내보내기
    .accesskey = E
openpgp-key-backup-key =
    .label = 비밀 키를 파일로 백업
    .accesskey = B
openpgp-key-send-key =
    .label = 이메일을 통해 공개 키 보내기
    .accesskey = S
openpgp-key-man-copy-to-clipbrd =
    .label = 공개 키를 클립 보드로 복사
    .accesskey = C
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
           *[other] 키 ID를 클립 보드로 복사
        }
    .accesskey = K
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
           *[other] 지문을 클립 보드로 복사
        }
    .accesskey = F
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
           *[other] 공개키를 클립 보드로 복사
        }
    .accesskey = P
openpgp-key-man-ctx-expor-to-file-label =
    .label = 파일로 키 내보내기
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = 공개 키를 클립 보드로 복사
openpgp-key-man-ctx-copy =
    .label = 복사
    .accesskey = C
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
           *[other] 지문
        }
    .accesskey = F
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
           *[other] 키 ID
        }
    .accesskey = K
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
           *[other] 공개키
        }
    .accesskey = P
openpgp-key-man-close =
    .label = 닫기
openpgp-key-man-reload =
    .label = 키 캐시 새로고침
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = 만료일 변경
    .accesskey = E
openpgp-key-man-del-key =
    .label = 키 삭제
    .accesskey = D
openpgp-delete-key =
    .label = 키 삭제
    .accesskey = D
openpgp-key-man-revoke-key =
    .label = 키 폐기
    .accesskey = R
openpgp-key-man-key-props =
    .label = 키 속성
    .accesskey = K
openpgp-key-man-key-more =
    .label = 더보기
    .accesskey = M
openpgp-key-man-view-photo =
    .label = 사진 신분증
    .accesskey = P
openpgp-key-man-ctx-view-photo-label =
    .label = 사진 신분증 보기
openpgp-key-man-show-invalid-keys =
    .label = 잘못된 키 표시
    .accesskey = D
openpgp-key-man-show-others-keys =
    .label = 다른 사람의 키 표시
    .accesskey = O
openpgp-key-man-user-id-label =
    .label = 이름
openpgp-key-man-fingerprint-label =
    .label = 지문
openpgp-key-man-select-all =
    .label = 모든 키 선택
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = 위의 상자에 검색어 입력
openpgp-key-man-nothing-found-tooltip =
    .label = 검색어와 일치하는 키 없음
openpgp-key-man-please-wait-tooltip =
    .label = 키를 읽는 동안 잠시 기다려주세요…
openpgp-key-man-filter-label =
    .placeholder = 키 검색
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = 키 속성
openpgp-key-details-signatures-tab =
    .label = 인증
openpgp-key-details-structure-tab =
    .label = 구조
openpgp-key-details-uid-certified-col =
    .label = 사용자 ID / 인증 기관
openpgp-key-details-user-id2-label = 주장하는 키 소유자
openpgp-key-details-id-label =
    .label = 아이디
openpgp-key-details-key-type-label = 형식
openpgp-key-details-key-part-label =
    .label = 키 부분
openpgp-key-details-algorithm-label =
    .label = 알고리즘
openpgp-key-details-size-label =
    .label = 크기
openpgp-key-details-created-label =
    .label = 생성일
openpgp-key-details-created-header = 생성일
openpgp-key-details-expiry-label =
    .label = 만료
openpgp-key-details-expiry-header = 만료
openpgp-key-details-usage-label =
    .label = 사용처
openpgp-key-details-fingerprint-label = 지문
openpgp-key-details-sel-action =
    .label = 작업 선택…
    .accesskey = S
openpgp-key-details-also-known-label = 주요 소유자의 주장 된 대체 신분 :
openpgp-card-details-close-window-label =
    .buttonlabelaccept = 닫기
openpgp-acceptance-label =
    .label = 수락 내용
openpgp-acceptance-rejected-label =
    .label = 아니요,이 키를 거부합니다.
openpgp-acceptance-undecided-label =
    .label = 아니오. 나중에 살펴봅니다.
openpgp-acceptance-unverified-label =
    .label = 예, 하지만 올바른 키인지 확인하지 않았습니다.
openpgp-acceptance-verified-label =
    .label = 예, 이 키에 올바른 지문이 있는지 직접 확인했습니다.
key-accept-personal =
    이 키에는 공개 부분과 비밀 부분이 모두 있습니다. 개인 키로 사용할 수 있습니다.
    이 키를 다른 사람이 제공 한 경우 개인 키로 사용하지 마세요.
key-personal-warning = 이 키를 직접 만들었습니까? 표시된 키 소유권은 자신을 나타 냅니까?
openpgp-personal-no-label =
    .label = 아니요, 개인 키로 사용하지 마세요.
openpgp-personal-yes-label =
    .label = 예, 이 키를 개인 키로 사용하세요.
openpgp-copy-cmd-label =
    .label = 복사

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird가 <b>{ $identity }</ b>와 연결된 OpenPGP 키를 찾지 못했습니다.
       *[other] Thunderbird가 <b>{ $identity }</ b>와 연결된 OpenPGP 키 { $count }개를 찾았습니다.
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] OpenPGP 프로토콜을 사용할 수 있는 유효한 키 선택
       *[other] 키 ID <b>{ $key }</b> 현재 구성 사용
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = 현재 구성은 만료 된 <b>{ $key }</b> 키를 사용합니다.
openpgp-add-key-button =
    .label = 키 추가…
    .accesskey = A
e2e-learn-more = 더 알아보기
openpgp-keygen-success = OpenPGP 키가 성공적으로 생성되었습니다!
openpgp-keygen-import-success = OpenPGP 키를 성공적으로 가져 왔습니다!
openpgp-keygen-external-success = 외부 GnuPG 키 ID가 저장되었습니다!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = 없음
openpgp-radio-none-desc = 이 ID에 OpenPGP를 사용하지 마세요.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = 만료일: { $date }
openpgp-key-expires-image =
    .tooltiptext = 키가 6 개월 이내에 만료됨
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = 만료일: { $date }
openpgp-key-expired-image =
    .tooltiptext = 키 만료
openpgp-key-expand-section =
    .tooltiptext = 자세한 정보
openpgp-key-revoke-title = 키 폐기
openpgp-key-edit-title = OpenPGP 키 변경
openpgp-key-edit-date-title = 만료일 연장
openpgp-manager-description = OpenPGP 키 관리자를 사용하여 상대방의 공개 키와 위에 나열되지 않은 다른 모든 키를 살펴보고 관리 할 수 있습니다.
openpgp-manager-button =
    .label = OpenPGP 키 관리자
    .accesskey = K
openpgp-key-remove-external =
    .label = 외부 키 ID 제거
    .accesskey = E
key-external-label = 외부 GnuPG 키
# Strings in keyDetailsDlg.xhtml
key-type-public = 공개 키
key-type-primary = 기본 키
key-type-subkey = 하위 키
key-type-pair = 키 페어 (비밀 키 및 공개 키)
key-expiry-never = 사용 안 함
key-usage-encrypt = 암호화
key-usage-sign = 서명
key-usage-certify = 확인
key-usage-authentication = 인증
key-does-not-expire = 키 만료되지 않음
key-expired-date = 키가 { $keyExpiry }에 만료됨
key-expired-simple = 키가 만료됨
key-revoked-simple = 키 폐기됨
key-do-you-accept = 디지털 서명 확인 및 메시지 암호화를 위해 이 키를 수락합니까?
key-accept-warning = 문제 있는 키를 받아들이지 마세요. 이메일 이외의 통신 채널을 사용하여 상대방 키의 지문을 확인하시기 바랍니다.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = 개인 키에 문제가 있어 메시지를 보낼 수 없습니다. { $problem }
cannot-encrypt-because-missing = 다음 수신자의 키에 문제가 있어 종단 간 암호화로 이 메시지를 보낼 수 없습니다. { $problem }
window-locked = 작성 창이 잠겨 있습니다. 전송 취소
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = 암호화 된 메시지 부분
mime-decrypt-encrypted-part-concealed-data = 이것은 암호화 된 메시지 부분입니다. 첨부 파일을 클릭하여 별도의 창에서 열어야합니다.
# Strings in keyserver.jsm
keyserver-error-aborted = 중단됨
keyserver-error-unknown = 알 수 없는 오류 발생
keyserver-error-server-error = 키 서버가 오류를 보고했습니다.
keyserver-error-import-error = 다운로드 한 키를 가져 오지 못했습니다.
keyserver-error-unavailable = 키 서버를 사용할 수 없습니다.
keyserver-error-security-error = 키 서버는 암호화 된 액세스를 지원하지 않습니다.
keyserver-error-certificate-error = 키 서버의 인증서가 유효하지 않습니다.
keyserver-error-unsupported = 키 서버가 지원되지 않습니다.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    여러분의 이메일 제공 업체가 귀하의 공개 키를 OpenPGP 웹 키 디렉토리에 업로드하기 위한 요청을 처리했습니다.
    공개 키 게시를 완료하려면 확인하세요.
wkd-message-body-process =
    OpenPGP 웹 키 디렉토리에 공개 키를 업로드하기 위한 자동 처리와 관련된 이메일입니다.
    이 시점에서 수동 조치를 취할 필요가 없습니다.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    제목이 있는 메시지를 복호화할 수 없습니다.
    { $subject }.
    다른 암호로 다시 시도 하시겠습니까, 아니면 메시지를 건너 뛰시겠습니까?
# Strings in gpg.jsm
unknown-signing-alg = 알 수 없는 서명 알고리즘 (ID : { $id })
unknown-hash-alg = 알 수 없는 암호화 해시 (ID : { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    { $desc } 키가 { $days } 일 이내에 만료됩니다.
    새 키 페어를 생성하고 이를 사용하도록 해당 계정을 구성하는 것이 좋습니다.
expiry-keys-expire-soon =
    다음 키는 { $days } 일 이내에 만료됩니다. { $desc }.
    새 키를 생성하고 이를 사용하도록 해당 계정을 구성하는 것이 좋습니다.
expiry-key-missing-owner-trust =
    비밀 키 { $desc }에 신뢰가 없습니다.
    주요 속성에서 "인증 의존함"을 "완전히 신뢰함"으로 설정하는 것이 좋습니다.
expiry-keys-missing-owner-trust =
    다음 비밀 키에 신뢰가 없습니다.
    { $desc }.
    주요 속성에서 "인증 의존함"을 "완전히 신뢰함"으로 설정하는 것이 좋습니다.
expiry-open-key-manager = OpenPGP 키 관리자 열기
expiry-open-key-properties = 키 속성 열기
# Strings filters.jsm
filter-folder-required = 대상 폴더를 선택해야 합니다.
filter-decrypt-move-warn-experimental =
    경고- "영구적으로 암호 해독"필터 동작으로 인해 메시지가 손상 될 수 있습니다.
    먼저 "복호화 된 복사본 만들기"필터를 시도하고 결과를 신중하게 테스트 한 다음, 결과에 만족할 때만 이 필터를 사용하는 것이 좋습니다.
filter-term-pgpencrypted-label = OpenPGP 암호화
filter-key-required = 수신자 키를 선택해야 합니다.
filter-key-not-found = '{ $desc }'에 대한 암호화 키를 찾을 수 없습니다.
filter-warn-key-not-secret =
    경고- "키로 암호화"필터 동작이 수신자를 대체합니다.
    '{ $desc }'에 대한 비밀 키가 없으면 더 이상 이메일을 읽을 수 없습니다.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = 영구 복호화 (OpenPGP)
filter-decrypt-copy-label = 복호화 된 복사본 생성 (OpenPGP)
filter-encrypt-label = 키로 암호화 (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = 성공! 키 가져오기 완료
import-info-bits = 비트
import-info-created = 생성일
import-info-fpr = 지문
import-info-details = 세부 정보보기 및 키 수락 관리
import-info-no-keys = 가져온 키 없음
# Strings in enigmailKeyManager.js
import-from-clip = 클립 보드에서 일부 키를 가져 오시겠습니까?
import-from-url = 이 URL에서 공개 키를 다운로드하십시오:
copy-to-clipbrd-failed = 선택한 키를 클립 보드에 복사 할 수 없습니다.
copy-to-clipbrd-ok = 키를 클립 보드 복사
delete-secret-key =
    경고 : 비밀 키를 삭제하려고 합니다!
    
    비밀 키를 삭제하면 해당 키에 대해 암호화 된 메시지를 더 이상 해독 할 수 없으며 취소 할 수도 없습니다.
    
    정말로 비밀 키와 공개 키를 모두 삭제 하시겠습니까?
    '{ $userId }'?
delete-mix =
    경고 : 비밀 키를 삭제하려고 합니다!
    비밀 키를 삭제하면 해당 키에 대해 암호화 된 메시지를 더 이상 복호화 할 수 없습니다.
    선택한 비밀 키와 공개 키를 모두 삭제 하시겠습니까?
delete-pub-key =
    공개 키를 삭제 하시겠습니까
    '{ $userId }'?
delete-selected-pub-key = 공개 키를 삭제 하시겠습니까?
refresh-all-question = 키를 선택하지 않았습니다. 모든 키를 새로 고치시겠습니까?
key-man-button-export-sec-key = 비밀 키 내보내기
key-man-button-export-pub-key = 공개 키만 내보내기
key-man-button-refresh-all = 모든 키 새로 고침
key-man-loading-keys = 키를 가져오는 중. 잠시 기다려주세요…
ascii-armor-file = ASCII Armored 파일 (* .asc)
no-key-selected = 선택한 작업을 수행하려면 하나 이상의 키를 선택해야 합니다.
export-to-file = 공개 키를 파일로 내보내기
export-keypair-to-file = 비밀 및 공개 키를 파일로 내보내기
export-secret-key = 저장된 OpenPGP 키 파일에 비밀 키를 포함 하시겠습니까?
save-keys-ok = 키를 성공적으로 저장 완료
save-keys-failed = 키 저장 실패
default-pub-key-filename = 내보낸 공개 키
default-pub-sec-key-filename = 비밀 키 백업
refresh-key-warn = 경고 : 키의 수와 연결 속도에 따라 모든 키를 새로 고치는 작업은 상당히 오래 걸릴 수 있습니다!
preview-failed = 공개 키 파일을 읽을 수 없습니다.
general-error = 오류 : { $reason }
dlg-button-delete = 삭제

## Account settings export output

openpgp-export-public-success = <b> 공개 키를 성공적으로 내보냈습니다! </ b>
openpgp-export-public-fail = <b> 선택한 공개 키를 내보낼 수 없습니다! </ b>
openpgp-export-secret-success = <b> 비밀 키를 성공적으로 내보냈습니다! </ b>
openpgp-export-secret-fail = <b> 선택한 비밀 키를 내보낼 수 없습니다! </ b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = { $userId } 키 (키 ID { $keyId })가 폐기되었습니다.
key-ring-pub-key-expired = { $userId } 키 (키 ID { $keyId })가 만료되었습니다.
key-ring-key-disabled = { $userId } 키 (키 ID { $keyId })가 비활성화되었습니다. 사용할 수 없습니다.
key-ring-key-invalid = { $userId } 키 (키 ID { $keyId })가 유효하지 않습니다. 올바르게 확인하십시오.
key-ring-key-not-trusted = { $userId } 키 (키 ID { $keyId })는 충분히 신뢰할 수 없습니다. 서명에 사용하려면 키의 신뢰 수준을 "완전히 신뢰함"으로 설정하십시오.
key-ring-no-secret-key = 키링에 { $userId } (키 ID { $keyId })에 대한 비밀 키가 없는 것 같습니다. 서명에 키를 사용할 수 없습니다.
key-ring-pub-key-not-for-signing = { $userId } 키 (키 ID { $keyId })는 서명에 사용할 수 없습니다.
key-ring-pub-key-not-for-encryption = { $userId } 키 (키 ID { $keyId })는 암호화에 사용할 수 없습니다.
key-ring-sign-sub-keys-revoked = { $userId } 키 (키 ID { $keyId })의 모든 서명 하위 키가 취소됩니다.
key-ring-sign-sub-keys-expired = { $userId } 키 (키 ID { $keyId })의 모든 서명 하위 키가 만료되었습니다.
key-ring-sign-sub-keys-unusable = { $userId } 키 (키 ID { $keyId })의 모든 서명-하위 키가 취소되거나 만료되거나 사용할 수 없습니다.
key-ring-enc-sub-keys-revoked = { $userId } 키 (키 ID { $keyId })의 모든 암호화 하위 키가 취소됩니다.
key-ring-enc-sub-keys-expired = { $userId } 키 (키 ID { $keyId })의 모든 암호화 하위 키가 만료되었습니다.
key-ring-enc-sub-keys-unusable = { $userId } 키 (키 ID { $keyId })의 모든 암호화 하위 키가 폐기되거나 만료되었거나 사용할 수 없습니다.
# Strings in gnupg-keylist.jsm
keyring-photo = 사진
user-att-photo = 사용자 속성 (JPEG 이미지)
# Strings in key.jsm
already-revoked = 이 키는 이미 폐기되었습니다.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    '{ $identity }'키를 폑기하려고합니다.
    더 이상이 키로 서명 할 수 없으며 일단 배포되면 다른 사용자가 더 이상 해당 키로 암호화 할 수 없습니다. 여전히 키를 사용하여 이전 메시지를 복호화할 수 있습니다.
    진행 하시겠습니까?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    이 폐기 인증서와 일치하는 키 (0x { $keyId })가 없습니다!
    키를 분실 한 경우, 폐기 인증서를 가져 오기 전에 (예 : 키 서버에서) 키를 가져와야 합니다.
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = 0x { $keyId } 키가 이미 폐기되었습니다.
key-man-button-revoke-key = 키 폐기
openpgp-key-revoke-success = 키가 폐기되었습니다.
after-revoke-info =
    키가 폐기되었습니다.
    이 공개 키를 이메일로 보내거나 키 서버에 업로드하여 다시 공유하여 다른 사람에게 키를 폐기했음을 알립니다.
    다른 사람이 사용하는 소프트웨어가 폐기 사실을 알게 되는 즉시 이전 키 사용이 중지됩니다.
    동일한 이메일 주소에 새 키를 사용하고 보내는 이메일에 새 공개 키를 첨부하면 폐기된 이전 키에 대한 정보가 자동으로 포함됩니다.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = 가져오기
delete-key-title = OpenPGP 키 삭제
delete-external-key-title = 외부 GnuPG 키 제거
delete-external-key-description = 이 외부 GnuPG 키 ID를 제거 하시겠습니까?
key-in-use-title = 현재 사용중인 OpenPGP 키
delete-key-in-use-description = 계속할 수 없습니다! 삭제하려고 선택한 키는 현재 ID에서 사용 중입니다. 다른 키를 선택하거나 없음을 선택하고 다시 시도하십시오.
revoke-key-in-use-description = 계속할 수 없습니다! 취소를 위해 선택한 키는 현재 ID에서 사용 중입니다. 다른 키를 선택하거나 없음을 선택하고 다시 시도하십시오.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = 이메일 주소 '{ $keySpec }'은 키링의 키와 일치 할 수 없습니다.
key-error-key-id-not-found = 구성된 키 ID '{ $keySpec }'을 키링에서 찾을 수 없습니다.
key-error-not-accepted-as-personal = ID가 '{ $keySpec }'인 키가 개인 키인지 확인하지 않았습니다.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = 선택한 기능은 오프라인 모드에서 사용할 수 없습니다. 온라인에 접속하여 다시 시도하십시오.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = 지정된 검색 기준과 일치하는 키를 찾을 수 없습니다.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = 오류 - 키 추출 명령 실패
# Strings used in keyRing.jsm
fail-cancel = 오류 - 사용자가 키 수신 취소
not-first-block = 오류 - 첫 번째 OpenPGP 블록이 공개 키 블록이 아님
import-key-confirm = 메시지에 포함 된 공개 키를 가져 오시겠습니까?
fail-key-import = 오류 - 키 가져 오기 실패
file-write-failed = { $output } 파일 쓰기 실패
no-pgp-block = 오류 - 유효한 Armored OpenPGP 데이터 블록 없음
confirm-permissive-import = 가져 오지 못했습니다. 가져 오려는 키가 손상되었거나 알 수 없는 속성을 사용할 수 있습니다. 올바른 부분을 가져 오시겠습니까? 이로 인해 불완전하고 사용할 수 없는 키를 가져올 수도 있습니다.
# Strings used in trust.jsm
key-valid-unknown = 알 수 없음
key-valid-invalid = 유효하지 않음
key-valid-disabled = 비활성화
key-valid-revoked = 폐기됨
key-valid-expired = 만료됨
key-trust-untrusted = 신뢰할 수 없음
key-trust-marginal = 일부
key-trust-full = 신뢰할 수 있음
key-trust-ultimate = 완전히 신뢰함
key-trust-group = (그룹)
# Strings used in commonWorkflows.js
import-key-file = OpenPGP 키 파일 가져 오기
import-rev-file = OpenPGP 폐기 파일 가져 오기
gnupg-file = GnuPG 파일
import-keys-failed = 키 가져 오기 실패
passphrase-prompt = 다음 키를 잠금 해제하는 비밀번호를 입력하십시오. { $key }
file-to-big-to-import = 이 파일이 너무 큽니다. 한 번에 많은 키를 가져 오지 마십시오.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = 폐기 인증서 생성 및 저장
revoke-cert-ok = 폐기 인증서가 성공적으로 생성되었습니다. 이를 사용하여 공개 키를 무효화 할 수 있습니다. 예: 비밀 키를 잃어 버릴 경우
revoke-cert-failed = 폐기 인증서를 만들 수 없습니다.
gen-going = 키 생성이 이미 진행 중입니다!
keygen-missing-user-name = 선택한 계정 / ID에 대해 지정된 이름이 없습니다. 계정 설정의 "사용자 이름" 필드에 값을 입력하십시오.
expiry-too-short = 키는 최소 하루 동안 유효해야 합니다.
expiry-too-long = 100년 이상 만료 키는 만들 수 없습니다.
key-confirm = '{ $id }'에 대한 공개 및 비밀 키를 생성 하시겠습니까?
key-man-button-generate-key = 키 생성
key-abort = 키 생성을 중단 하시겠습니까?
key-man-button-generate-key-abort = 키 생성 중단
key-man-button-generate-key-continue = 키 생성 계속

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = 오류- 복호화 실패
fix-broken-exchange-msg-failed = 메시지를 복구하지 못했습니다.
attachment-no-match-from-signature = 서명 파일 '{ $attachment }'를 첨부 파일과 일치시킬 수 없음
attachment-no-match-to-signature = '{ $attachment }'첨부 파일을 서명 파일과 일치시킬 수 없음
signature-verified-ok = { $attachment } 첨부 파일의 서명이 성공적으로 확인 완료
signature-verify-failed = { $attachment } 첨부 파일의 서명을 확인할 수 없음
decrypt-ok-no-sig =
    경고
    암호 복호화에 성공했지만 서명을 올바르게 확인할 수 없습니다.
msg-ovl-button-cont-anyway = 계속 진행하기
enig-content-note = *이 메시지의 첨부 파일은 서명되거나 암호화되지 않았습니다 *
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = 메시지 전송
msg-compose-details-button-label = 상세 보기…
msg-compose-details-button-access-key = D
send-aborted = 보내기 작업이 중단되었습니다.
key-not-trusted = '{ $key }'키에 대한 신뢰가 충분하지 않음
key-not-found = '{ $key }'키를 찾을 수 없음
key-revoked = '{ $key }'키 폐기됨
key-expired = '{ $key }'키 만료됨
msg-compose-internal-error = 내부 오류가 발생했습니다.
keys-to-export = 삽입 할 OpenPGP 키 선택
msg-compose-partially-encrypted-inlinePGP =
    회신하는 메시지에는 암호화되지 않은 부분과 암호화 된 부분이 모두 포함되어 있습니다. 보낸 사람이 원래 일부 메시지 부분을 해독 할 수 없는 경우 보낸 사람이 원래 스스로 복호화할 수 없었던 기밀 정보가 유출되었을 수 있습니다.
    이 발신자에게 보내는 답장에서 인용 된 모든 텍스트를 삭제 해보세요.
msg-compose-cannot-save-draft = 초안 저장 중 오류 발생
msg-compose-partially-encrypted-short = 부분적으로 암호화 된 이메일로서 민감한 정보 유출에 주의하십시오.
quoted-printable-warn =
    메시지를 보내기 위해 '인용 부분 인쇄 가능' 인코딩을 활성화했습니다. 이로 인해 잘못된 암호 복호화 및 / 또는 메시지 확인이 발생할 수 있습니다.
    지금 '인용 부분 인쇄 가능' 메시지 보내기를 끄시겠습니까?
minimal-line-wrapping =
    줄 바꿈을 { $width } 자로 설정했습니다. 올바른 암호화 또는 서명을 위해 이 값은 68 이상이어야 합니다.
    지금 줄 바꿈을 68 자로 변경 하시겠습니까?
sending-hidden-rcpt = BCC (숨은 참조) 수신자는 암호화 된 메시지를 보낼 때 사용할 수 없습니다. 이 암호화 된 메시지를 보내려면 BCC 수신자를 제거하거나 CC 필드로 이동하십시오.
sending-news =
    암호화 된 보내기 작업이 중단되었습니다.
    뉴스 그룹 수신자가 있으므로 이 메시지를 암호화 할 수 없습니다. 암호화하지 않고 메시지를 다시 보내십시오.
send-to-news-warning =
    경고 : 암호화 된 이메일을 뉴스 그룹에 보내려고 합니다.
    이는 그룹의 모든 구성원이 메시지를 복호화 할 수 있는 경우에만 의미가 있기 때문에 권장되지 않습니다. 즉, 메시지는 모든 그룹 참가자의 키로 암호화되어야 합니다. 수행 중인 작업을 정확히 알고 있는 경우에만이 메시지를 보내십시오.
    계속하시겠습니까?
save-attachment-header = 복호화된 첨부 파일 저장
no-temp-dir =
    사용할 임시 디렉토리를 찾을 수 없음
    TEMP 환경 변수를 설정하세요
possibly-pgp-mime = PGP / MIME 암호화 또는 서명 된 메시지 일 수 있음: '복호화/ 검증'기능을 사용하여 확인하기
cannot-send-sig-because-no-own-key = <{ $key }>에 대해 종단 간 암호화를 아직 구성하지 않았으므로 이 메시지에 디지털 서명 할 수 없음
cannot-send-enc-because-no-own-key = <{ $key }>에 대한 종단 간 암호화를 아직 구성하지 않았으므로 이 메시지를 암호화하여 보낼 수 없음
# Strings used in decryption.jsm
do-import-multiple =
    다음 키를 가져 오시겠습니까?
    { $key }
do-import-one = { $name } ({ $id })를 가져 오시겠습니까?
cant-import = 공개 키 가져 오기 오류
unverified-reply = 들여 쓴 메시지 부분 (회신)이 수정 가능성 있음
key-in-message-body = 메시지 본문에서 키를 찾았습니다. 키를 가져 오려면 '키 가져 오기'를 클릭하세요.
sig-mismatch = 오류 - 서명 불일치
invalid-email = 오류 - 잘못된 이메일 주소
attachment-pgp-key =
    여는 첨부 파일 '{ $name }'이 OpenPGP 키 파일 인 것 같습니다.
    포함 된 키를 가져 오려면 '가져 오기'를 클릭하고 브라우저 창에서 파일 내용을 보려면 '보기'를 클릭하세요.
dlg-button-view = 보기
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = 복호화된 메시지 (이전 Exchange 서버로 인해 손상된 PGP 이메일 형식을 복원하여 결과를 읽기에 완벽하지 않을 수 있음)
# Strings used in encryption.jsm
not-required = 오류 - 암호화 불필요
# Strings used in windows.jsm
no-photo-available = 사용 가능한 사진 없음
error-photo-path-not-readable = '{ $photo }' 사진 경로 읽을 수 없음
debug-log-title = OpenPGP 디버그 로그
# Strings used in dialog.jsm
repeat-prefix = 알림 { $count }회 반복
repeat-suffix-singular = 더 많은 시간.
repeat-suffix-plural = 더 많은 시간.
no-repeat = 이 경고는 다시 표시되지 않습니다.
dlg-keep-setting = 설정을 기억하고 다시 묻지 않음
dlg-button-ok = 확인
dlg-button-close = 닫기
dlg-button-cancel = 취소
dlg-no-prompt = 이 대화 상자를 다시 표시하지 않음
enig-prompt = OpenPGP 프롬프트
enig-confirm = OpenPGP 확인
enig-alert = OpenPGP 경고
enig-info = OpenPGP 정보
# Strings used in persistentCrypto.jsm
dlg-button-retry = 재시도
dlg-button-skip = 건너뛰기
# Strings used in enigmailCommon.js
enig-error = OpenPGP 오류
enig-alert-title =
    .title = OpenPGP 경고
