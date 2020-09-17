# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = { $identity }에 대한 개인 OpenPGP 키 추가
key-wizard-button =
    .buttonlabelaccept = 계속하기
    .buttonlabelhelp = 뒤로 가기
key-wizard-warning = 이메일 주소에 대한 <b>기존 개인 키가 있는 경우</b> 가져와야 합니다. 그렇지 않으면 암호화 된 이메일 아카이브에 접근할 수 없으며, 기존 키를 계속 사용하는 사람들로부터 암호화 된 수신 이메일을 읽을 수 없습니다.
key-wizard-learn-more = 더 알아보기
radio-create-key =
    .label = 새 OpenPGP 키 만들기
    .accesskey = C
radio-import-key =
    .label = 기존 OpenPGP 키 가져 오기
    .accesskey = I
radio-gnupg-key =
    .label = GnuPG를 통해 외부 키 사용 (예: 스마트 카드에서)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = OpenPGP 키 생성
openpgp-generate-key-info = <b>키 생성을 완료하는 데 최대 몇 분이 소요될 수 있습니다.</b> 키 생성이 진행되는 동안 애플리케이션을 종료하지 마십시오. 키 생성 중에 적극적으로 검색하거나 디스크 집약적인 작업을 수행하면 '무작위 풀(Randomness Pool)'이 보충되고 프로세스 속도가 빨라집니다. 키 생성이 완료되면 경고가 표시됩니다.
openpgp-keygen-expiry-title = 키 만료
openpgp-keygen-expiry-description = 새로 생성 된 키의 만료 시간을 정의합니다. 필요한 경우 나중에 날짜를 제어하여 연장 할 수 있습니다.
radio-keygen-expiry =
    .label = 키 만료
    .accesskey = e
radio-keygen-no-expiry =
    .label = 만료되지 않음
    .accesskey = d
openpgp-keygen-days-label =
    .label = 일
openpgp-keygen-months-label =
    .label = 월
openpgp-keygen-years-label =
    .label = 년
openpgp-keygen-advanced-title = 고급 설정
openpgp-keygen-advanced-description = OpenPGP 키의 고급 설정을 제어합니다.
openpgp-keygen-keytype =
    .value = 키 유형 :
    .accesskey = t
openpgp-keygen-keysize =
    .value = 키 크기 :
    .accesskey = s
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (타원 곡선)
openpgp-keygen-button = 키 생성
openpgp-keygen-progress-title = 새 OpenPGP 키 생성 중…
openpgp-keygen-import-progress-title = OpenPGP 키 가져 오기…
openpgp-import-success = OpenPGP 키를 성공적으로 가져 왔습니다!
openpgp-import-success-title = 가져 오기 과정 완료
openpgp-import-success-description = 가져온 OpenPGP 키를 이메일 암호화에 사용하려면 본 대화 상자를 닫고 계정 설정에 접근하여 선택하세요.
openpgp-keygen-confirm =
    .label = 확인
openpgp-keygen-dismiss =
    .label = 취소
openpgp-keygen-cancel =
    .label = 작업 취소…
openpgp-keygen-import-complete =
    .label = 닫기
    .accesskey = C
openpgp-keygen-missing-username = 현재 계정에 지정된 이름이 없습니다. 계정 설정의 "사용자 이름" 항목에 값을 입력하십시오.
openpgp-keygen-long-expiry = 100년 이상 만료 키는 만들 수 없습니다.
openpgp-keygen-short-expiry = 키는 최소 하루 동안 유효해야 합니다.
openpgp-keygen-ongoing = 키 생성이 이미 진행 중입니다!
openpgp-keygen-error-core = OpenPGP 핵심 서비스를 초기화 할 수 없습니다.
openpgp-keygen-error-failed = OpenPGP 키 생성이 예기치 않게 실패했습니다.
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP 키가 성공적으로 생성되었지만 { $key } 키 해지 목록을 가져 오지 못했습니다.
openpgp-keygen-abort-title = 키 생성을 중단 하시겠습니까?
openpgp-keygen-abort = 현재 OpenPGP 키 생성이 진행 중입니다. 취소 하시겠습니까?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = { $identity }에 대한 공개 및 비밀 키를 생성 하시겠습니까?

## Import Key section

openpgp-import-key-title = 기존 개인 OpenPGP 키 가져 오기
openpgp-import-key-legend = 이전에 백업 한 파일을 선택합니다.
openpgp-import-key-description = 다른 OpenPGP 소프트웨어로 생성 된 개인 키를 가져올 수 있습니다.
openpgp-import-key-info = 다른 소프트웨어는 사용자 고유 키, 비밀 키, 개인 키 또는 키 페어와 같은 대체 용어를 사용하여 개인 키를 설명 할 수 있습니다.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
       *[other] Thunderbird가 가져올 수 있는 { $count } 키를 찾았습니다.
    }
openpgp-import-key-list-description = 개인 키로 취급 할 수 있는 키를 확인하십시오. 자신이 직접 생성하고 자신의 신원을 보여 주는 키만 개인 키로 사용해야 합니다. 나중에 키 속성 대화 상자에서 이 옵션을 변경할 수 있습니다.
openpgp-import-key-list-caption = 개인 키로 취급되는 것으로 표시된 키는 종단 간 암호화 섹션에 나열됩니다. 나머지는 키 관리자에서 사용할 수 있습니다.
openpgp-passphrase-prompt-title = 암호 필요
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = 다음 키를 잠금 해제하려면 암호를 입력하세요: { $key }
openpgp-import-key-button =
    .label = 가져올 파일 선택…
    .accesskey = S
import-key-file = OpenPGP 키 파일 가져 오기
import-key-personal-checkbox =
    .label = 이 키를 개인 키로 취급
gnupg-file = GnuPG 파일
import-error-file-size = <b> 오류! </b> 5MB보다 큰 파일은 지원되지 않습니다.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>오류!</b> 파일을 가져 오지 못했습니다. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>오류!</b> 키를 가져 오지 못했습니다. { $error }
openpgp-import-identity-label = 신분 확인
openpgp-import-fingerprint-label = 지문
openpgp-import-created-label = 생성일
openpgp-import-bits-label = 비트
openpgp-import-key-props =
    .label = 키 속성
    .accesskey = K

## External Key section

openpgp-external-key-title = 외부 GnuPG 키
openpgp-external-key-description = 키 ID를 입력하여 외부 GnuPG 키 구성
openpgp-external-key-info = 또한 키 관리자를 사용하여 해당 공개 키를 가져오고 수락해야 합니다.
openpgp-external-key-warning = <b>외부 GnuPG 키를 하나만 구성 할 수 있습니다.</b> 이전 항목이 대체됩니다.
openpgp-save-external-button = 키 ID 저장
openpgp-external-key-label = 비밀 키 ID :
openpgp-external-key-input =
    .placeholder = 123456789341298340
