# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = 새 탭
tabbrowser-empty-private-tab-title = 새 사생활 보호 탭
tabbrowser-menuitem-close-tab =
    .label = 탭 닫기
tabbrowser-menuitem-close =
    .label = 닫기
# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = 탭 { $tabCount }개 닫기

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = 탭 { $tabCount }개 음소거 ({ $shortcut })
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = 탭 { $tabCount }개 음소거 해제 ({ $shortcut })
tabbrowser-mute-tab-audio-background-tooltip =
    .label = 탭 { $tabCount }개 음소거
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = 탭 { $tabCount }개 음소거 해제
tabbrowser-unblock-tab-audio-tooltip =
    .label = 탭 { $tabCount }개 재생

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = 탭 { $tabCount }개를 닫으시겠습니까?
tabbrowser-confirm-close-tabs-button = 탭 닫기
tabbrowser-confirm-close-tabs-checkbox = 여러 탭을 닫기 전에 확인

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = 창 { $windowCount }개를 닫으시겠습니까?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] 닫기 및 종료
       *[other] 닫기 및 종료
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = 창을 닫고 { -brand-short-name }를 종료하시겠습니까?
tabbrowser-confirm-close-tabs-with-key-button = { -brand-short-name } 종료
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = { $quitKey } 단축키로 종료하기 전에 확인

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = 열기 확인
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] 지금 { $tabCount }개 탭을 열려고 합니다. 페이지가 로드되는 동안 { -brand-short-name }가 느려질 수도 있습니다. 계속하시겠습니까?
    }
tabbrowser-confirm-open-multiple-tabs-button = 탭 열기
tabbrowser-confirm-open-multiple-tabs-checkbox = { -brand-short-name }가 느려질 수 있는 여러 탭 열기 경고

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = 커서 브라우징
tabbrowser-confirm-caretbrowsing-message = F7 키를 누르면 커서 브라우징을 켜거나 끕니다. 이 기능은 웹 페이지에 이동 가능한 커서를 배치하여 키보드로 텍스트를 선택할 수 있습니다. 커서 브라우징을 켜시겠습니까?
tabbrowser-confirm-caretbrowsing-checkbox = 이 대화 상자를 다시 표시하지 않음.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = { $domain }의 이런 알림이 해당 사이트의 탭으로 전환하도록 허용
tabbrowser-customizemode-tab-title = { -brand-short-name } 사용자 지정

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = 탭 음소거
    .accesskey = M
tabbrowser-context-unmute-tab =
    .label = 탭 음소거 해제
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = 탭 음소거
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = 탭 음소거 해제
    .accesskey = m
# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = 오디오 재생

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = 전체 탭 { $tabCount }개 목록

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = 탭 음소거
tabbrowser-manager-unmute-tab =
    .tooltiptext = 탭 음소거 해제
tabbrowser-manager-close-tab =
    .tooltiptext = 탭 닫기
