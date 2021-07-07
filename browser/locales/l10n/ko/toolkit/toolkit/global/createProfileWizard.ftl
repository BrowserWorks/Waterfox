# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = 프로필 만들기
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] 소개
       *[other] { create-profile-window.title } 사용을 환영합니다.
    }

profile-creation-explanation-1 = { -brand-short-name }는 사용자 설정 및 기타 사용자 항목에 대한 정보를 사용자 프로필에 저장합니다.

profile-creation-explanation-2 = 이 { -brand-short-name }를 다른 사용자와 함께 사용하려는 경우, 여러 프로필을 사용하여 각 사용자의 정보를 별도로 유지할 수 있습니다. 이렇게 하려면 각 사용자가 자신의 프로필을 만들어야 합니다.

profile-creation-explanation-3 = 사용자가 { -brand-short-name }를 사용하는 유일한 사용자라도 최소한 하나의 프로필은 가지고 있어야 합니다. 또한 여러 개의 프로필을 만들어 다른 설정으로 사용할 수도 있습니다. 예를 들어 업무용과 개인용으로 별도의 프로필을 만들 수 있습니다.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] 프로필을 만들려면 계속을 선택하세요.
       *[other] 프로필을 만들려면 다음을 선택하세요.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] 결론
       *[other] { create-profile-window.title } 완료
    }

profile-creation-intro = 여러 개의 프로필을 만들면 프로필 이름으로 이들을 구별 할 수 있습니다. 여기에 제공된 이름을 사용하시거나 자신이 원하는 이름을 사용할 수 있습니다.

profile-prompt = 새 프로필 이름 입력:
    .accesskey = E

profile-default-name =
    .value = Default User

profile-directory-explanation = 사용자 설정 및 기타 사용자 관련 데이터 저장 위치:

create-profile-choose-folder =
    .label = 폴더 선택…
    .accesskey = C

create-profile-use-default =
    .label = 기본 폴더 사용
    .accesskey = U
