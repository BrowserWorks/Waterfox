# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = 모든 다운로드를 취소하시겠습니까?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] 지금 종료하면 1개의 다운로드가 취소됩니다. 종료하시겠습니까?
       *[other] 지금 종료하면 { $downloadsCount }개의 다운로드가 취소됩니다. 종료하시겠습니까?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] 지금 종료하면 1개의 다운로드가 취소됩니다. 종료하시겠습니까?
       *[other] 지금 종료하면 { $downloadsCount }개의 다운로드가 취소됩니다. 종료하시겠습니까?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] 종료 안 함
       *[other] 종료 안 함
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] 오프라인 상태가 되면 1개의 다운로드가 취소됩니다. 오프라인 상태로 전환하시겠습니까?
       *[other] 오프라인 상태가 되면 { $downloadsCount }개의 다운로드가 취소됩니다. 오프라인 상태로 전환하시겠습니까?
    }
download-ui-dont-go-offline-button = 온라인 상태 유지

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] 모든 사생활 보호 창을 닫으면, 1개의 다운로드가 취소됩니다. 사생활 보호 모드에서 나가시겠습니까?
       *[other] 모든 사생활 보호 창을 닫으면, { $downloadsCount }개의 다운로드가 취소됩니다. 사생활 보호 모드에서 나가시겠습니까?
    }
download-ui-dont-leave-private-browsing-button = 사생활 보호 모드 계속하기

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] 다운로드 1개 취소
       *[other] 다운로드 { $downloadsCount }개 취소
    }

##

download-ui-file-executable-security-warning-title = 실행 파일을 여시겠습니까?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }"는 실행 파일입니다. 실행 파일에는 컴퓨터를 손상시킬 수 있는 바이러스 또는 기타 악성 코드가 포함되어 있을 수 있습니다. 이 파일을 열 때 주의하세요. "{ $executable }"을(를) 실행하시겠습니까?
