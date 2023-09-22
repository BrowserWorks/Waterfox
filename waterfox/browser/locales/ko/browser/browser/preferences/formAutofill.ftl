# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = 저장된 주소
autofill-manage-addresses-list-header = 주소

autofill-manage-credit-cards-title = 저장된 신용 카드
autofill-manage-credit-cards-list-header = 신용 카드

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = 삭제
autofill-manage-add-button = 추가…
autofill-manage-edit-button = 수정…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = 새 주소 추가
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = 주소 편집

autofill-address-given-name = 이름
autofill-address-additional-name = 중간 이름
autofill-address-family-name = 성
autofill-address-organization = 조직
autofill-address-street = 도로 주소

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = 단지
# Used in MY
autofill-address-village-township = 마을 또는 읍
autofill-address-island = 섬
# Used in IE
autofill-address-townland = 타운랜드

## address-level-2 names

autofill-address-city = 도시
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = 군/구
# Used in GB, NO, SE
autofill-address-post-town = 포스트타운
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = 근교

## address-level-1 names

autofill-address-province = 주
autofill-address-state = 주
autofill-address-county = 주
# Used in BB, JM
autofill-address-parish = 교구
# Used in JP
autofill-address-prefecture = 현
# Used in HK
autofill-address-area = 지역
# Used in KR
autofill-address-do-si = 도/시
# Used in NI, CO
autofill-address-department = 주
# Used in AE
autofill-address-emirate = 토후국
# Used in RU and UA
autofill-address-oblast = 주

## Postal code name types

# Used in IN
autofill-address-pin = 우편 번호
autofill-address-postal-code = 우편 번호
autofill-address-zip = 우편 번호
# Used in IE
autofill-address-eircode = 우편 번호

##

autofill-address-country = 국가 또는 지역
autofill-address-tel = 전화
autofill-address-email = 이메일

autofill-cancel-button = 취소
autofill-save-button = 저장
autofill-country-warning-message = 양식 자동 채우기는 현재 일부 국가에서만 사용할 수 있습니다.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = 새 신용 카드 추가
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = 신용 카드 수정

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] 신용 카드 정보 표시
        [windows] { -brand-short-name }가 신용카드 정보를 표시하려고 합니다. 아래 Windows 계정에 대한 접근을 확인하세요.
       *[other] { -brand-short-name }가 신용카드 정보를 표시하려고 합니다.
    }

autofill-card-number = 카드 번호
autofill-card-invalid-number = 유효한 카드 번호를 입력하세요
autofill-card-name-on-card = 카드상의 이름
autofill-card-expires-month = 만료월
autofill-card-expires-year = 만료년
autofill-card-billing-address = 청구 주소
autofill-card-network = 카드 종류

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = 아메리칸 엑스프레스
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = 다이너스 클럽
autofill-card-network-discover = 디스커버 카드
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = 마스터카드
autofill-card-network-mir = MIR
autofill-card-network-unionpay = 유니온페이
autofill-card-network-visa = 비자카드
