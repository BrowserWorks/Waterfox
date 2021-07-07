# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] { -brand-short-name }가 지난 주 동안 { $count }개의 추적기를 차단함
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } 이후 <b>{ $count }</b>개의 추적기가 차단됨
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name }는 사생활 보호 창에서 추적기를 계속 차단하지만, 차단 된 내용은 기록하지 않습니다.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = 이번 주에 { -brand-short-name }가 차단한 추적기

protection-report-webpage-title = 보호 대시보드
protection-report-page-content-title = 보호 대시보드
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name }는 탐색하는 동안 뒤에서 개인 정보를 보호할 수 있습니다. 다음은 온라인 보안을 제어하는 도구를 포함하여 이러한 보호 기능에 대한 개인화된 요약입니다.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name }는 탐색하는 동안 뒤에서 개인 정보를 보호합니다. 다음은 온라인 보안을 제어하는 도구를 포함하여 이러한 보호 기능에 대한 개인화된 요약입니다.

protection-report-settings-link = 개인 정보 및 보안 설정 관리

etp-card-title-always = 향상된 추적 방지 기능: 항상 사용
etp-card-title-custom-not-blocking = 향상된 추적 방지 기능: 꺼짐
etp-card-content-description = { -brand-short-name }는 회사가 웹에서 사용자를 몰래 따라 다니는 것을 자동으로 중지합니다.
protection-report-etp-card-content-custom-not-blocking = 현재 모든 보호 기능이 꺼져 있습니다. { -brand-short-name } 보호 설정에서 차단할 추적기를 선택하세요.
protection-report-manage-protections = 설정 관리

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = 오늘

# This string is used to describe the graph for screenreader users.
graph-legend-description = 이번 주에 차단된 각 유형의 추적기의 전체 수를 포함하는 그래프입니다.

social-tab-title = 소셜 미디어 추적기
social-tab-contant = 소셜 네트워크는 다른 웹 사이트에 추적기를 배치하여 온라인에서 한 일이나 본 것, 재생한 것을 추적합니다. 이를 통해 소셜 미디어 회사들은 소셜 미디어 프로필에서 공유하는 것 이상의 자세한 정보를 얻을 수 있습니다. <a data-l10n-name="learn-more-link">더 알아보기</a>

cookie-tab-title = 교차 사이트 추적 쿠키
cookie-tab-content = 이러한 쿠키는 사용자가 온라인에서 수행하는 작업에 대한 데이터를 수집하기 위해 사이트 간에 사용자를 따라 다닙니다. 광고사나 분석 회사와 같은 제3자가 설정합니다. 교차 사이트 추적 쿠키를 차단하면 따라다니는 광고 수가 줄어듭니다. <a data-l10n-name="learn-more-link">더 알아보기</a>

tracker-tab-title = 추적 콘텐츠
tracker-tab-description = 웹 사이트에서 외부 광고, 동영상 및 기타 추적 코드가 포함된 콘텐츠를 로드할 수 있습니다. 추적 콘텐츠를 차단하면 사이트를 더 빨리 로드할 수 있지만 일부 버튼, 양식 및 로그인 필드가 작동하지 않을 수 있습니다. <a data-l10n-name="learn-more-link">더 알아보기</a>

fingerprinter-tab-title = 디지털 지문
fingerprinter-tab-content = 디지털 지문은 브라우저와 컴퓨터에서 설정을 수집하여 사용자의 프로필을 만듭니다. 이를 사용하여 여러 웹 사이트에서 사용자를 추적할 수 있습니다. <a data-l10n-name="learn-more-link">더 알아보기</a>

cryptominer-tab-title = 암호화폐 채굴기
cryptominer-tab-content = 암호화폐 채굴기는 디지털 화폐를 채굴하기 위해 시스템의 연산 능력을 사용합니다. 암호 해독 스크립트는 배터리를 소모하고 컴퓨터 속도를 저하시키며 에너지 요금을 증가시킬 수 있습니다. <a data-l10n-name="learn-more-link">더 알아보기</a>

protections-close-button2 =
    .aria-label = 닫기
    .title = 닫기
  
mobile-app-title = 더 많은 기기에서 광고 추적기 차단
mobile-app-card-content = 광고 추적에 대한 보호 기능이 내장된 모바일 브라우저를 사용하세요.
mobile-app-links = <a data-l10n-name="android-mobile-inline-link">Android</a> 및 <a data-l10n-name="ios-mobile-inline-link">iOS</a>용 { -brand-product-name } 브라우저

lockwise-title = 비밀번호를 다시 잊지 마세요
lockwise-title-logged-in2 = 비밀번호 관리
lockwise-header-content = { -lockwise-brand-name }는 비밀번호를 브라우저에 안전하게 저장합니다.
lockwise-header-content-logged-in = 비밀번호를 모든 기기에 안전하게 저장하고 동기화합니다.
protection-report-save-passwords-button = 비밀번호 저장
    .title = { -lockwise-brand-short-name }에 비밀번호 저장
protection-report-manage-passwords-button = 비밀번호 관리
    .title = { -lockwise-brand-short-name }에서 비밀번호 관리
lockwise-mobile-app-title = 어디에서나 비밀번호를 사용하세요
lockwise-no-logins-card-content = 모든 기기에서 { -brand-short-name }에 저장된 비밀번호를 사용하세요.
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> 및 <a data-l10n-name="lockwise-ios-inline-link">iOS</a>용 { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] 데이터 유출에 { $count }개의 비밀번호가 노출되었을 수 있습니다.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] 비밀번호가 안전하게 저장되고 있습니다.
    }
lockwise-how-it-works-link = 작동 방식

monitor-title = 데이터 유출에 주의하세요
monitor-link = 작동 방식
monitor-header-content-no-account = { -monitor-brand-name }를 확인하여 사용자가 알려진 데이터 유출 사건의 피해자인지 확인하고 새로운 유출에 대한 알림을 받습니다.
monitor-header-content-signed-in = 알려진 데이터 유출 사건에 사용의 정보가 있으면 { -monitor-brand-name }가 경고합니다.
monitor-sign-up-link = 유출 알림 가입하기
    .title = { -monitor-brand-name }에서 유출 알림 가입하기
auto-scan = 오늘의 자동 스캔

monitor-emails-tooltip =
    .title = { -monitor-brand-short-name }에서 모니터링된 이메일 주소 보기
monitor-breaches-tooltip =
    .title = { -monitor-brand-short-name }에서 알려진 데이터 유출 보기
monitor-passwords-tooltip =
    .title = { -monitor-brand-short-name }에서 노출된 비밀번호 보기

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] 모니터되는 이메일 주소
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] 알려진 데이터 유출로 인해 정보가 노출되었습니다.
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] 해결된 것으로 표시된 알려진 데이터 유출
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] 모든 유출에 걸처 비밀번호가 노출되었습니다.
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] 해결되지 않은 유출에 노출된 비밀번호
    }

monitor-no-breaches-title = 좋은 소식!
monitor-no-breaches-description = 알려진 유출이 없습니다. 변경되면 알려 드리겠습니다.
monitor-view-report-link = 보고서 보기
    .title = { -monitor-brand-short-name }에서 유출 해결
monitor-breaches-unresolved-title = 유출 해결
monitor-breaches-unresolved-description = 유출 세부 사항을 검토하고 정보를 보호하기 위한 조치를 취한 후, 유출을 해결된 것으로 표시할 수 있습니다.
monitor-manage-breaches-link = 유출 관리
    .title = { -monitor-brand-short-name }에서 유출 관리
monitor-breaches-resolved-title = 좋아요! 알려진 모든 유출을 해결했습니다.
monitor-breaches-resolved-description = 사용자의 이메일이 새로운 유출에 나타나면 알려 드리겠습니다.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreaches }개의 유출 중 { $numBreachesResolved }개가 해결된 것으로 표시되었습니다
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% 완료

monitor-partial-breaches-motivation-title-start = 시작!
monitor-partial-breaches-motivation-title-middle = 계속하세요!
monitor-partial-breaches-motivation-title-end = 거의 다 했어요! 계속하세요.
monitor-partial-breaches-motivation-description = { -monitor-brand-short-name }에서 나머지 유출을 해결하세요.
monitor-resolve-breaches-link = 유출 해결
    .title = { -monitor-brand-short-name }에서 유출 해결

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = 소셜 미디어 추적기
    .aria-label =
        { $count ->
           *[other] { $count } 소셜 미디어 추적기 ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = 교차 사이트 추적 쿠키
    .aria-label =
        { $count ->
           *[other] { $count } 교차 사이트 추적 쿠키 ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = 추적 콘텐츠
    .aria-label =
        { $count ->
           *[other] { $count } 추적 콘텐츠 ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = 디지털 지문
    .aria-label =
        { $count ->
           *[other] { $count } 핑거프린터 ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = 암호화폐 채굴기
    .aria-label =
        { $count ->
           *[other] { $count } 암호화폐 채굴기 ({ $percentage }%)
        }
