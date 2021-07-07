# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 새로운 { -brand-short-name }를 만나보세요
upgrade-dialog-new-subtitle = 원하는 곳으로 더 빨리 이동할 수 있도록 설계됨
upgrade-dialog-new-item-menu-title = 간소화된 도구 모음 및 메뉴
upgrade-dialog-new-item-menu-description = 중요한 것에 우선순위를 두어서 필요한 것을 찾을 수 있도록 합니다.
upgrade-dialog-new-item-tabs-title = 현대적인 탭
upgrade-dialog-new-item-tabs-description = 정보를 깔끔하게 포함하여 초점과 유연한 움직임을 지원합니다.
upgrade-dialog-new-item-icons-title = 새로운 아이콘 및 명확한 메시지
upgrade-dialog-new-item-icons-description = 가벼운 터치로 길을 찾을 수 있도록 도와줍니다.
upgrade-dialog-new-primary-default-button = { -brand-short-name }를 기본 브라우저로 설정
upgrade-dialog-new-primary-theme-button = 테마 선택
upgrade-dialog-new-secondary-button = 나중에
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = 확인

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] { -brand-short-name }를 Dock에 넣기
       *[other] { -brand-short-name }를 작업 표시줄에 고정
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] 최신 { -brand-short-name }에 쉽게 접근
       *[other] 최신 { -brand-short-name }를 가까운 곳에 두기
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Dock에 넣기
       *[other] 작업 표시줄에 고정
    }
upgrade-dialog-pin-secondary-button = 나중에

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = { -brand-short-name }를 기본 브라우저로 설정
upgrade-dialog-default-subtitle-2 = 탐색할 때 속도, 안전 및 개인 정보 보호 기능이 제공됩니다.
upgrade-dialog-default-primary-button-2 = 기본 브라우저로 설정
upgrade-dialog-default-secondary-button = 나중에

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = 선명한 테마로 산뜻하게 시작
upgrade-dialog-theme-system = 시스템 테마
    .title = 버튼, 메뉴 및 창에 운영 체제의 테마를 따름

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = 색상 라이프
upgrade-dialog-start-subtitle = 생동감 넘치는 새로운 컬러웨이입니다. 제한된 시간 동안 사용할 수 있습니다.
upgrade-dialog-start-primary-button = 컬러웨이 탐색
upgrade-dialog-start-secondary-button = 나중에

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = 팔레트 선택
upgrade-dialog-colorway-home-checkbox = 테마 배경이 있는 Waterfox 홈으로 전환
upgrade-dialog-colorway-primary-button = 컬러웨이 저장
upgrade-dialog-colorway-secondary-button = 이전 테마 유지
upgrade-dialog-colorway-theme-tooltip =
    .title = 기본 테마 탐색
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = { $colorwayName } 컬러웨이 탐색
upgrade-dialog-colorway-default-theme = 기본
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = 자동
    .title = 버튼, 메뉴 및 창에 운영 체제의 테마를 따름
upgrade-dialog-theme-light = 밝게
    .title = 버튼, 메뉴 및 창에 밝은 테마를 사용
upgrade-dialog-theme-dark = 어둡게
    .title = 버튼, 메뉴 및 창에 어두운 테마를 사용
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = 버튼, 메뉴 및 창에 역동적이고 다양한 색상의 테마를 사용
upgrade-dialog-theme-keep = 이전 유지
    .title = { -brand-short-name }를 업데이트하기 전에 설치한 테마를 사용
upgrade-dialog-theme-primary-button = 테마 저장
upgrade-dialog-theme-secondary-button = 나중에
upgrade-dialog-colorway-variation-soft = 연하게
    .title = 이 컬러웨이 사용
upgrade-dialog-colorway-variation-balanced = 중간
    .title = 이 컬러웨이 사용
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = 진하게
    .title = 이 컬러웨이 사용

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = 저희를 선택해 주셔서 감사합니다
upgrade-dialog-thankyou-subtitle = { -brand-short-name }는 비영리 단체가 지원하는 독립 브라우저입니다. 우리는 함께 웹을 안전하고, 건강하고, 더 사생활 보호를 하도록 만들고 있습니다.
upgrade-dialog-thankyou-primary-button = 탐색 시작
