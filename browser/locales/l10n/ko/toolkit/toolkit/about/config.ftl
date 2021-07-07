# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = 주의해서 진행하세요
about-config-intro-warning-text = 고급 구성 설정을 변경하면 { -brand-short-name }의 성능 또는 보안에 영향을 줄 수 있습니다.
about-config-intro-warning-checkbox = 이 설정에 접근하려고 할 때 경고
about-config-intro-warning-button = 위험을 감수하고 계속 진행

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = 다음 설정을 변경하면 { -brand-short-name }의 성능 또는 보안에 영향을 줄 수 있습니다.
about-config-page-title = 고급 설정
about-config-search-input1 =
    .placeholder = 설정 이름 검색
about-config-show-all = 모두 표시
about-config-show-only-modified = 수정한 설정만 표시
about-config-pref-add-button =
    .title = 추가
about-config-pref-toggle-button =
    .title = 설정/해제
about-config-pref-edit-button =
    .title = 편집
about-config-pref-save-button =
    .title = 저장
about-config-pref-reset-button =
    .title = 초기화
about-config-pref-delete-button =
    .title = 삭제

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = 불린
about-config-pref-add-type-number = 숫자
about-config-pref-add-type-string = 문자열

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (기본값)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (사용자 지정)
