# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = 프로파일러 설정
perftools-intro-description =
    기록은 새 탭에서 profiler.firefox.com을 시작합니다. 모든 데이터는 
    로컬에 저장되지만 공유를 위해 업로드하도록 선택할 수 있습니다.

## All of the headings for the various sections.

perftools-heading-settings = 전체 설정
perftools-heading-buffer = 버퍼 설정
perftools-heading-features = 기능
perftools-heading-features-default = 기능 (기본적으로 권장됨)
perftools-heading-features-disabled = 비활성화된 기능
perftools-heading-features-experimental = 실험
perftools-heading-threads = 스레드
perftools-heading-threads-jvm = JVM 스레드
perftools-heading-local-build = 로컬 빌드

##

perftools-description-intro =
    기록은 새 탭에서 <a>profiler.firefox.com</a>을 시작합니다. 모든 데이터는 
    로컬에 저장되지만 공유를 위해 업로드하도록 선택할 수 있습니다.
perftools-description-local-build =
    직접 컴파일한 빌드를 프로파일링하는 경우
    이 컴퓨터에서 빌드의 objdir을 아래 목록에 추가하여 
    기호 정보를 조회하는데 사용할 수 있습니다.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = 샘플링 간격:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = 버퍼 크기:
perftools-custom-threads-label = 이름으로 사용자 지정 스레드 추가:
perftools-devtools-interval-label = 간격:
perftools-devtools-threads-label = 스레드:
perftools-devtools-settings-label = 설정

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = 다른 도구에 의해 기록이 중지되었습니다.
perftools-status-restart-required = 이 기능을 사용하려면 브라우저를 다시 시작해야 합니다.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = 기록 중지
perftools-request-to-get-profile-and-stop-profiler = 프로필 캡처

##

perftools-button-start-recording = 기록 시작
perftools-button-capture-recording = 기록 캡처
perftools-button-cancel-recording = 기록 취소
perftools-button-save-settings = 설정을 저장하고 뒤로 가기
perftools-button-restart = 다시 시작
perftools-button-add-directory = 디렉터리 추가
perftools-button-remove-directory = 선택 항목 삭제
perftools-button-edit-settings = 설정 편집…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = 부모 프로세스와 콘텐츠 프로세스 모두에 대한 메인 프로세스
perftools-thread-compositor =
    .title = 페이지에서 서로 다른 페인트 요소를 함께 합성
perftools-thread-dom-worker =
    .title = web worker와 service worker를 모두 처리함
perftools-thread-renderer =
    .title = WebRender가 활성화되면 OpenGL 호출을 실행하는 스레드
perftools-thread-render-backend =
    .title = WebRender RenderBackend 스레드
perftools-thread-paint-worker =
    .title = 오프 메인 스레드 페인팅이 활성화되면 페인팅이 발생하는 스레드
perftools-thread-timer =
    .title = 스레드 처리 타이머 (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = 스타일 계산이 여러 스레드로 분할됨
pref-thread-stream-trans =
    .title = 네트워크 스트림 전송
perftools-thread-socket-thread =
    .title = 네트워킹 코드가 차단 소켓 호출을 실행하는 스레드
perftools-thread-img-decoder =
    .title = 이미지 디코딩 스레드
perftools-thread-dns-resolver =
    .title = 이 스레드에서 DNS 확인 발생
perftools-thread-task-controller =
    .title = TaskController 스레드 풀 스레드
perftools-thread-jvm-gecko =
    .title = 메인 Gecko JVM 스레드
perftools-thread-jvm-nimbus =
    .title = Nimbus 실험 SDK의 메인 스레드
perftools-thread-jvm-default-dispatcher =
    .title = Kotlin 코루틴 라이브러리의 기본 디스패처
perftools-thread-jvm-glean =
    .title = Glean 원격 분석 SDK의 메인 스레드
perftools-thread-jvm-arch-disk-io =
    .title = Kotlin 코루틴 라이브러리의 IO 디스패처
perftools-thread-jvm-pool =
    .title = 이름 없는 스레드 풀에서 생성된 스레드

##

perftools-record-all-registered-threads = 위의 선택 사항을 무시하고 등록된 모든 스레드를 기록
perftools-tools-threads-input-label =
    .title = 이러한 스레드 이름은 프로파일러에서 스레드의 프로파일링을 활성화하는데 사용되는 쉼표로 구분된 목록입니다. 이름은 포함할 스레드 이름과 부분적으로 일치해야 합니다. 공백에 민감합니다.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>새 기능</b>: { -profiler-brand-name }가 이제 개발자 도구에 통합되었습니다. 이 강력한 새 도구에 대해 <a>더 알아보세요</a>.
perftools-onboarding-close-button =
    .aria-label = 온보딩 메시지 닫기

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = 웹 개발자
perftools-presets-web-developer-description = 오버헤드가 낮은 대부분의 웹 앱 디버깅에 권장되는 프리셋입니다.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = { -brand-shorter-name } 프로파일링에 권장되는 프리셋입니다.
perftools-presets-graphics-label = 그래픽
perftools-presets-graphics-description = { -brand-shorter-name }의 그래픽 버그를 조사하기 위한 프리셋입니다.
perftools-presets-media-label = 미디어
perftools-presets-media-description2 = { -brand-shorter-name }의 오디오 및 비디오 버그를 조사하기 위한 프리셋입니다.
perftools-presets-networking-label = 네트워킹
perftools-presets-networking-description = { -brand-shorter-name }의 네트워킹 버그를 조사하기 위한 프리셋입니다.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = 전력
perftools-presets-power-description = 오버헤드가 낮은 { -brand-shorter-name }의 전력 사용 버그를 조사하기 위한 프리셋입니다.
perftools-presets-custom-label = 사용자 지정

##

