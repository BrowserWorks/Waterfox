# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label = { -brand-short-name }로 열기
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows] { -brand-short-name } 설정에서 변경할 수 있습니다.
           *[other] { -brand-short-name } 설정에서 변경할 수 있습니다.
        }

unknowncontenttype-intro = 다음 파일 열기를 선택하셨습니다:
unknowncontenttype-which-is = 파일 형식:
unknowncontenttype-from = 원본 위치:
unknowncontenttype-prompt = 이 파일을 저장하시겠습니까?
unknowncontenttype-action-question = { -brand-short-name }로 어떤 작업을 하시겠습니까?
unknowncontenttype-open-with =
    .label = 열기:
    .accesskey = o
unknowncontenttype-other =
    .label = 기타…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] 선택하기…
           *[other] 찾아보기…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
unknowncontenttype-save-file =
    .label = 파일 저장
    .accesskey = s
unknowncontenttype-remember-choice =
    .label = 이 파일 형식에 대해 다시 묻지 않음
    .accesskey = a
