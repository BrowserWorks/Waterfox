# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - 공유 표시기
webrtc-indicator-window =
    .title = { -brand-short-name } - 공유 표시기

## Used as list items in sharing menu

webrtc-item-camera = 카메라
webrtc-item-microphone = 마이크
webrtc-item-audio-capture = 탭 소리
webrtc-item-application = 애플리케이션
webrtc-item-screen = 화면
webrtc-item-window = 창
webrtc-item-browser = 탭

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = 알 수 없는 출처

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = 기기를 공유하는 탭
    .accesskey = d

webrtc-sharing-window = 다른 애플리케이션 창을 공유하고 있습니다.
webrtc-sharing-browser-window = { -brand-short-name }를 공유하고 있습니다.
webrtc-sharing-screen = 전체 화면을 공유하고 있습니다.
webrtc-stop-sharing-button = 공유 중지
webrtc-microphone-unmuted =
    .title = 마이크 끄기
webrtc-microphone-muted =
    .title = 마이크 켜기
webrtc-camera-unmuted =
    .title = 카메라 끄기
webrtc-camera-muted =
    .title = 카메라 켜기
webrtc-minimize =
    .title = 표시기 최소화

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = 카메라를 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-microphone-system-menu =
    .label = 마이크를 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-screen-system-menu =
    .label = 창이나 화면을 공유하고 있습니다. 공유를 제어하려면 누르세요.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = 카메라와 마이크를 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-camera =
    .tooltiptext = 카메라를 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-microphone =
    .tooltiptext = 마이크를 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-application =
    .tooltiptext = 애플리케이션을 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-screen =
    .tooltiptext = 화면을 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-window =
    .tooltiptext = 창을 공유하고 있습니다. 공유를 제어하려면 누르세요.
webrtc-indicator-sharing-browser =
    .tooltiptext = 탭을 공유하고 있습니다. 공유를 제어하려면 누르세요.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = 공유 설정
webrtc-indicator-menuitem-control-sharing-on =
    .label = "{ $streamTitle }" 공유 설정

webrtc-indicator-menuitem-sharing-camera-with =
    .label = "{ $streamTitle }"로 카메라 공유 중
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label = 탭 { $tabCount }개에서 카메라 공유 중

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = "{ $streamTitle }"로 마이크 공유 중
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label = 탭 { $tabCount }개에서 마이크 공유 중

webrtc-indicator-menuitem-sharing-application-with =
    .label = "{ $streamTitle }"로 애플리케이션 공유 중
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label = 탭 { $tabCount }개에서 애플리케이션 공유 중

webrtc-indicator-menuitem-sharing-screen-with =
    .label = "{ $streamTitle }"로 화면 공유 중
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label = 탭 { $tabCount }개에서 화면 공유 중

webrtc-indicator-menuitem-sharing-window-with =
    .label = "{ $streamTitle }"로 창 공유 중
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label = 탭 { $tabCount }개에서 창 공유 중

webrtc-indicator-menuitem-sharing-browser-with =
    .label = "{ $streamTitle }"로 탭 공유 중
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label = 탭 { $tabCount }개에서 탭 공유 중

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = { $origin } 사이트가 이 탭의 소리를 들을 수 있도록 허용하시겠습니까?
webrtc-allow-share-camera = { $origin } 사이트가 카메라를 사용하도록 허용하시겠습니까?
webrtc-allow-share-microphone = { $origin } 사이트가 마이크를 사용하도록 허용하시겠습니까?
webrtc-allow-share-screen = { $origin } 사이트가 화면을 볼 수 있도록 허용하시겠습니까?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = { $origin } 사이트가 다른 스피커를 사용하도록 허용하시겠습니까?
webrtc-allow-share-camera-and-microphone = { $origin } 사이트가 카메라와 마이크를 사용하도록 허용하시겠습니까?
webrtc-allow-share-camera-and-audio-capture = { $origin } 사이트가 카메라를 사용하고 이 탭의 소리를 듣을 수 있도록 허용하시겠습니까?
webrtc-allow-share-screen-and-microphone = { $origin } 사이트가 마이크를 사용하고 화면을 볼 수 있도록 허용하시겠습니까?
webrtc-allow-share-screen-and-audio-capture = { $origin } 사이트가 이 탭의 소리를 듣고 화면을 볼 수 있도록 허용하시겠습니까?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 이 탭의 소리를 들을 수 있도록 권한을 부여하는 것을 허용하시겠습니까?
webrtc-allow-share-camera-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 카메라에 접근할 수 있도록 허용하시겠습니까?
webrtc-allow-share-microphone-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 마이크에 접근할 수 있도록 허용하시겠습니까?
webrtc-allow-share-screen-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 화면을 볼 수 있도록 권한을 부여하는 것을 허용하시겠습니까?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 다른 스피커에 접근할 수 있도록 허용하시겠습니까?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 카메라와 마이크에 접근할 수 있도록 허용하시겠습니까?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 카메라에 접근하고 이 탭의 소리를 들을 수 있도록 허용하시겠습니까?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 마이크에 접근하고 화면을 볼 수 있도록 허용하시겠습니까?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = { $origin } 사이트가 { $thirdParty }에 이 탭의 소리를 듣고 화면을 볼 수 있도록 권한을 부여하는 것을 허용하시겠습니까?

##

webrtc-share-screen-warning = 신뢰할 수 있는 사이트에서만 화면을 공유하세요. 공유는 의심되는 사이트가 당신을 사칭하고 개인 정보를 빼앗아갈 수 있게 합니다.
webrtc-share-browser-warning = 신뢰할 수 있는 사이트에서만 { -brand-short-name }를 공유하세요. 공유는 의심되는 사이트가 당신을 사칭하고 개인 정보를 빼앗아갈 수 있게 합니다.

webrtc-share-screen-learn-more = 더 알아보기
webrtc-pick-window-or-screen = 창이나 화면 선택
webrtc-share-entire-screen = 전체 화면
webrtc-share-pipe-wire-portal = 운영 체제 설정 사용
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = 화면 { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application = { $appName } (창 { $windowCount }개)

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = 허용
    .accesskey = A
webrtc-action-block =
    .label = 차단
    .accesskey = B
webrtc-action-always-block =
    .label = 항상 차단
    .accesskey = w
webrtc-action-not-now =
    .label = 나중에
    .accesskey = N

##

webrtc-remember-allow-checkbox = 이 선택 기억하기
webrtc-mute-notifications-checkbox = 공유하는 동안 웹 사이트 알림 음소거

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name }가 더 이상 당신의 화면에 접근할 수 없습니다.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name }가 이제 어느 탭을 공유할지 더 이상 묻지 않고 탭의 소리에 접근합니다.
webrtc-reason-for-no-permanent-allow-insecure = 이 사이트에 대한 연결이 안전하지 않습니다. 보호를 위해 { -brand-short-name }는 이 세션에 대한 접근만 허용합니다.
