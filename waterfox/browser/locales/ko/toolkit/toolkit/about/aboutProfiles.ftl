# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = 프로필 정보
profiles-subtitle = 이 페이지에서는 프로필을 관리할 수 있습니다. 각각의 프로필은 분리된 기록과 북마크, 설정, 부가 기능을 포함합니다.
profiles-create = 새 프로필 만들기
profiles-restart-title = 다시 시작
profiles-restart-in-safe-mode = 부가 기능을 끄고 다시 시작…
profiles-restart-normal = 일반 모드로 다시 시작…
profiles-conflict = { -brand-product-name }의 다른 복사본이 프로필을 변경했습니다. 변경하기 전에 { -brand-short-name }를 다시 시작해야 합니다.
profiles-flush-fail-title = 변경 내용이 저장되지 않음
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = 예상치 못한 오류가 발생하여 변경 내용을 저장하지 못했습니다.
profiles-flush-restart-button = { -brand-short-name } 다시 시작

# Variables:
#   $name (String) - Name of the profile
profiles-name = 프로필: { $name }
profiles-is-default = 기본 프로필
profiles-rootdir = 루트 디렉터리

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = 로컬 디렉터리
profiles-current-profile = 이 프로필은 사용 중이므로 삭제할 수 없습니다.
profiles-in-use-profile = 이 프로필을 다른 애플리케이션에서 사용하고 있기 때문에 삭제할 수 없습니다.

profiles-rename = 이름 변경
profiles-remove = 삭제
profiles-set-as-default = 기본 프로필로 설정
profiles-launch-profile = 새 브라우저에서 프로필 실행

profiles-cannot-set-as-default-title = 기본값으로 설정할 수 없음
profiles-cannot-set-as-default-message = { -brand-short-name }의 기본 프로필은 변경할 수 없습니다.

profiles-yes = 예
profiles-no = 아니오

profiles-rename-profile-title = 프로필 이름 변경
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } 프로필 이름 변경

profiles-invalid-profile-name-title = 유효하지 않은 프로필 이름
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }"는 프로필 이름으로 사용할 수 없습니다.

profiles-delete-profile-title = 프로필 삭제
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    프로필을 삭제하면 사용 가능한 프로필 목록에서 프로필을 삭제하며 이는 다시 되돌릴 수 없습니다.
    설정과 인증서, 다른 사용자 데이터를 포함한 데이터 파일을 같이 삭제하도록 선택할 수 있습니다. 이 선택 사항은 "{ $dir }" 폴더를 삭제하며 이는 다시 되돌릴 수 없습니다.
    프로필 데이터 파일을 같이 삭제하시겠습니까?
profiles-delete-files = 파일 삭제
profiles-dont-delete-files = 삭제 안 함

profiles-delete-profile-failed-title = 오류
profiles-delete-profile-failed-message = 이 프로필을 삭제하는 동안 오류가 발생했습니다.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder에서 보기
        [windows] 폴더 열기
       *[other] 디렉터리 열기
    }
