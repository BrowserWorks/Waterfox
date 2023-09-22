# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = 로깅 정보
about-logging-page-title = 로깅 관리자
about-logging-current-log-file = 현재 로그 파일:
about-logging-new-log-file = 새 로그 파일:
about-logging-currently-enabled-log-modules = 현재 활성화된 로그 모듈:
about-logging-log-tutorial = 이 도구 사용법에 대한 설명은 <a data-l10n-name="logging">HTTP 로깅</a>을 참조하세요.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = 디렉터리 열기
about-logging-set-log-file = 로그 파일 설정
about-logging-set-log-modules = 로그 모듈 설정
about-logging-start-logging = 로깅 시작
about-logging-stop-logging = 로깅 중지
about-logging-buttons-disabled = 환경 변수를 통해 구성된 로깅, 동적 구성을 사용할 수 없습니다.
about-logging-some-elements-disabled = URL을 통해 구성된 로깅, 일부 구성 옵션을 사용할 수 없습니다.
about-logging-info = 정보:
about-logging-log-modules-selection = 로그 모듈 선택
about-logging-new-log-modules = 새 로그 모듈:
about-logging-logging-output-selection = 로깅 출력
about-logging-logging-to-file = 파일로 로깅
about-logging-logging-to-profiler = { -profiler-brand-name }에 로깅
about-logging-no-log-modules = 없음
about-logging-no-log-file = 없음
about-logging-logging-preset-selector-text = 로깅 프리셋:
about-logging-with-profiler-stacks-checkbox = 로그 메시지에 대한 스택 추적 활성화

## Logging presets

about-logging-preset-networking-label = 네트워킹
about-logging-preset-networking-description = 네트워킹 문제를 진단하기 위한 로그 모듈
about-logging-preset-networking-cookie-label = 쿠키
about-logging-preset-networking-cookie-description = 쿠키 문제를 진단하기 위한 로그 모듈
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = WebSocket 문제를 진단하기 위한 로그 모듈
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = HTTP/3 및 QUIC 문제를 진단하기 위한 로그 모듈
about-logging-preset-media-playback-label = 미디어 재생
about-logging-preset-media-playback-description = 미디어 재생 문제를 진단하기 위한 로그 모듈 (화상 회의 문제 아님)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = WebRTC 호출을 진단하기 위한 로그 모듈
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = WebGPU 문제를 진단하기 위한 로그 모듈
about-logging-preset-gfx-label = 그래픽
about-logging-preset-gfx-description = 그래픽 문제를 진단하기 위한 로그 모듈
about-logging-preset-custom-label = 사용자 지정
about-logging-preset-custom-description = 수동으로 선택한 로그 모듈
# Error handling
about-logging-error = 오류:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = “{ $k }“ 키에 대한 잘못된 값 “{ $v }“
about-logging-unknown-logging-preset = 알 수 없는 로깅 프리셋 “{ $v }“
about-logging-unknown-profiler-preset = 알 수 없는 프로파일러 프리셋 “{ $v }“
about-logging-unknown-option = 알 수 없는 about:logging 옵션 “{ $k }“
about-logging-configuration-url-ignored = 구성 URL이 무시됨
about-logging-file-and-profiler-override = 파일 출력을 강제하고 동시에 프로파일러 옵션을 재정의할 수는 없음
about-logging-configured-via-url = URL을 통해 구성된 옵션
