# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = 장치 관리자
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = 보안 모듈 및 장치

devmgr-header-details =
    .label = 상세 정보

devmgr-header-value =
    .label = 값

devmgr-button-login =
    .label = 로그인
    .accesskey = n

devmgr-button-logout =
    .label = 로그아웃
    .accesskey = O

devmgr-button-changepw =
    .label = 비밀번호 변경
    .accesskey = P

devmgr-button-load =
    .label = 장착하기
    .accesskey = L

devmgr-button-unload =
    .label = 분리하기
    .accesskey = U

devmgr-button-enable-fips =
    .label = FIPS 사용
    .accesskey = F

devmgr-button-disable-fips =
    .label = FIPS 사용 안 함
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS#11 장치 드라이버 로드

load-device-info = 추가하고자 하는 모듈에 대한 정보를 입력하세요.

load-device-modname =
    .value = 모듈 이름
    .accesskey = M

load-device-modname-default =
    .value = 새 PKCS #11 모듈

load-device-filename =
    .value = 모듈 파일 이름
    .accesskey = f

load-device-browse =
    .label = 찾아보기…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = 상태

devinfo-status-disabled =
    .label = 사용 안 함

devinfo-status-not-present =
    .label = 제공되지 않음

devinfo-status-uninitialized =
    .label = 초기화 안 됨

devinfo-status-not-logged-in =
    .label = 로그인 안 됨

devinfo-status-logged-in =
    .label = 로그인됨

devinfo-status-ready =
    .label = 준비

devinfo-desc =
    .label = 설명

devinfo-man-id =
    .label = 공급자

devinfo-hwversion =
    .label = 하드웨어 버전
devinfo-fwversion =
    .label = 펌웨어 버전

devinfo-modname =
    .label = 모듈

devinfo-modpath =
    .label = 경로

login-failed = 로그인 실패

devinfo-label =
    .label = 레이블

devinfo-serialnum =
    .label = 일련 번호

fips-nonempty-primary-password-required = FIPS 모드는 각 보안 장치에 대해 기본 비밀번호가 설정되어 있어야 합니다. FIPS 모드를 사용하기 전에 먼저 기본 비밀번호를 설정하세요.
unable-to-toggle-fips = 보안 장치에 대해 FIPS 모드를 변경할 수 없습니다. 이 애플리케이션을 종료 후 다시 시작하는 것을 권장합니다.
load-pk11-module-file-picker-title = 로드 할 PKCS#11 장치 드라이버 선택

# Load Module Dialog
load-module-help-empty-module-name =
    .value = 모듈 이름은 필수입니다.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘는 예약어이기 때문에 모듈 이름으로 사용할 수 없습니다.

add-module-failure = 모듈을 추가할 수 없음
del-module-warning = 정말로 이 보안 모듈을 삭제하시겠습니까?
del-module-error = 모듈을 삭제할 수 없음
