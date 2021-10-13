# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = 작업 관리자

## Column headers

column-name = 이름
column-type = 유형
column-energy-impact = 에너지 영향
column-memory = 메모리

## Special values for the Name column

ghost-windows = 최근 닫힌 탭
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = 미리로드됨 : { $title }

## Values for the Type column

type-tab = 탭
type-subframe = 서브 프레임
type-tracker = 추적기
type-addon = 부가 기능
type-browser = 브라우저
type-worker = Worker
type-other = 기타

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = 높음({ $value })
energy-impact-medium = 보통({ $value })
energy-impact-low = 낮음({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = 탭 닫기
show-addon =
    .title = 부가 기능 관리자에서 보기

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        로드 이후 디스패치: { $totalDispatches } ({ $totalDuration }ms)
        마지막 초 이후 디스패치: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
