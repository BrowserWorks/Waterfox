# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = 브라우저 데이터 가져오기
migration-wizard-selection-list = 가져올 데이터를 선택하세요.
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge 레거시
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = CSV 파일의 비밀번호
migration-wizard-migrator-display-name-file-bookmarks = HTML 파일의 북마크
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = 사용 가능한 모든 데이터 가져오기
migration-no-selected-data-label = 가져올 데이터가 선택되지 않음
migration-selected-data-label = 선택한 데이터 가져오기

##

migration-select-all-option-label = 모두 선택
migration-bookmarks-option-label = 북마크
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = 즐겨찾기
migration-logins-and-passwords-option-label = 저장된 로그인 및 비밀번호
migration-history-option-label = 방문 기록
migration-extensions-option-label = 확장 기능
migration-form-autofill-option-label = 양식 자동 채우기 데이터
migration-payment-methods-option-label = 결제 방법
migration-cookies-option-label = 쿠키
migration-session-option-label = 창과 탭
migration-otherdata-option-label = 기타 데이터
migration-passwords-from-file-progress-header = 비밀번호 파일 가져오기
migration-passwords-from-file-success-header = 비밀번호를 성공적으로 가져옴
migration-passwords-from-file = 비밀번호 파일 확인 중
migration-passwords-new = 새 비밀번호
migration-passwords-updated = 기존 비밀번호
migration-passwords-from-file-no-valid-data = 파일에 유효한 비밀번호 데이터가 포함되어 있지 않습니다. 다른 파일을 선택하세요.
migration-passwords-from-file-picker-title = 비밀번호 파일 가져오기
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV 문서
       *[other] CSV 파일
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV 문서
       *[other] TSV 파일
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords = { $newEntries }개 추가됨
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords = { $updatedEntries }개 업데이트됨
migration-bookmarks-from-file-picker-title = 북마크 파일 가져오기
migration-bookmarks-from-file-progress-header = 북마크 가져오는 중
migration-bookmarks-from-file = 북마크
migration-bookmarks-from-file-success-header = 북마크를 성공적으로 가져옴
migration-bookmarks-from-file-no-valid-data = 파일에 북마크 데이터가 포함되어 있지 않습니다. 다른 파일을 선택하세요.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML 문서
       *[other] HTML 파일
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON 파일
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks = 북마크 { $newEntries }개
migration-import-button-label = 가져오기
migration-choose-to-import-from-file-button-label = 파일에서 가져오기
migration-import-from-file-button-label = 파일 선택
migration-cancel-button-label = 취소
migration-done-button-label = 완료
migration-continue-button-label = 계속
migration-wizard-import-browser-no-browsers = { -brand-short-name }는 북마크, 기록 또는 비밀번호 데이터가 포함된 프로그램을 찾을 수 없습니다.
migration-wizard-import-browser-no-resources = 오류가 발생했습니다. { -brand-short-name }는 해당 브라우저 프로필에서 가져올 데이터를 찾을 수 없습니다.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = 북마크
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = 즐겨찾기
migration-list-password-label = 비밀번호
migration-list-history-label = 기록
migration-list-extensions-label = 확장 기능
migration-list-autofill-label = 자동 채우기 데이터
migration-list-payment-methods-label = 결제 방법

##

migration-wizard-progress-header = 데이터 가져오기
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = 데이터를 성공적으로 가져옴
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = 데이터 가져오기 완료
migration-wizard-progress-icon-in-progress =
    .aria-label = 가져오는 중…
migration-wizard-progress-icon-completed =
    .aria-label = 완료
migration-safari-password-import-header = Safari에서 비밀번호 가져오기
migration-safari-password-import-steps-header = Safari 비밀번호를 가져오려면:
migration-safari-password-import-step1 = Safari에서 "Safari" 메뉴를 열고 설정 > 비밀번호로 이동하세요
migration-safari-password-import-step2 = <img data-l10n-name="safari-icon-3dots"/> 버튼을 선택하고 "모든 비밀번호 내보내기"를 선택하세요
migration-safari-password-import-step3 = 비밀번호 파일을 저장하세요
migration-safari-password-import-step4 = 아래의 "파일 선택"을 사용하여 저장한 비밀번호 파일을 선택하세요.
migration-safari-password-import-skip-button = 건너뛰기
migration-safari-password-import-select-button = 파일 선택
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks = 북마크 { $quantity }개
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites = 즐겨찾기 { $quantity }개

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions = 확장 기능 { $quantity }개
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } / { $quantity } 확장 기능
migration-wizard-progress-extensions-support-link = { -brand-product-name }가 확장 기능 일치하는 방법 알아보기
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = 일치하는 확장 기능 없음
migration-wizard-progress-extensions-addons-link = { -brand-short-name } 확장 기능 탐색

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords = 비밀번호 { $quantity }개
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history = 지난 { $maxAgeInDays }일부터
migration-wizard-progress-success-formdata = 양식 기록
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods = 결제 방법 { $quantity }개
migration-wizard-safari-permissions-sub-header = Safari 북마크 및 방문 기록을 가져오려면:
migration-wizard-safari-instructions-continue = "계속"을 선택하세요
migration-wizard-safari-instructions-folder = 목록에서 Safari 폴더를 선택하고 "열기"를 선택하세요
