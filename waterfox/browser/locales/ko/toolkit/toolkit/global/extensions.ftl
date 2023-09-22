# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = { $extension } 확장 기능을 추가하시겠습니까?
webext-perms-header-with-perms = { $extension } 확장 기능을 추가하시겠습니까? 이 확장 기능은 다음의 권한을 갖습니다:
webext-perms-header-unsigned = { $extension } 확장 기능을 추가하시겠습니까? 이 확장 기능은 확인되지 않았습니다. 악성 확장 기능은 개인 정보를 훔치거나 컴퓨터를 손상시킬 수 있습니다. 출처를 신뢰하는 경우에만 추가하세요.
webext-perms-header-unsigned-with-perms = { $extension } 확장 기능을 추가하시겠습니까? 이 확장 기능은 확인되지 않았습니다. 악성 확장 기능은 개인 정보를 훔치거나 컴퓨터를 손상시킬 수 있습니다. 출처를 신뢰하는 경우에만 추가하세요. 이 확장 기능은 다음의 권한을 갖습니다:
webext-perms-sideload-header = { $extension } 부가 기능이 추가됨
webext-perms-optional-perms-header = { $extension } 확장 기능이 추가 권한을 요청합니다.

##

webext-perms-add =
    .label = 추가
    .accesskey = A
webext-perms-cancel =
    .label = 취소
    .accesskey = C
webext-perms-sideload-text = 다른 프로그램이 브라우저에 영향을 줄 수 있는 부가 기능을 설치했습니다. 이 부가 기능의 권한을 확인하고 사용함 또는 취소(사용 안 함 상태로 둠)를 누르세요.
webext-perms-sideload-text-no-perms = 다른 프로그램이 브라우저에 영향을 줄 수 있는 부가 기능을 설치했습니다. 사용함 또는 취소(사용 안 함 상태로 둠)를 누르세요.
webext-perms-sideload-enable =
    .label = 사용함
    .accesskey = E
webext-perms-sideload-cancel =
    .label = 취소
    .accesskey = C
# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } 확장 기능이 업데이트되었습니다. 업데이트된 버전이 설치되기 전에 새 권한을 승인해야 합니다. “취소”를 누르면 현재 버전을 유지합니다. 이 확장 기능은 다음의 권한을 갖습니다:
webext-perms-update-accept =
    .label = 업데이트
    .accesskey = U
webext-perms-optional-perms-list-intro = 필요한 권한:
webext-perms-optional-perms-allow =
    .label = 허용
    .accesskey = A
webext-perms-optional-perms-deny =
    .label = 거부
    .accesskey = D
webext-perms-host-description-all-urls = 모든 웹 사이트에 대한 사용자 데이터에 접근
# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = { $domain } 도메인 사이트에 대한 사용자 데이터에 접근
# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards = 다른 도메인 { $domainCount }개에 대한 사용자 데이터에 접근
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = { $domain }에 대한 사용자 데이터에 접근
# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites = 다른 사이트 { $domainCount }개에 대한 사용자 데이터에 접근

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = 이 부가 기능은 { $hostname }에 MIDI 기기에 대한 접근 권한을 부여합니다.
webext-site-perms-header-with-gated-perms-midi-sysex = 이 부가 기능은 { $hostname }에 MIDI 기기에 대한 접근 권한을 부여합니다 (SysEx 지원).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    이들은 일반적으로 오디오 신디사이저와 같은 플러그인 기기이지만, 컴퓨터에 내장되어 있을 수도 있습니다.
    
    일반적으로 웹 사이트는 MIDI 기기에 접근할 수 없습니다. 부적절한 사용으로 인해 손상이 발생하거나 보안이 손상될 수 있습니다.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = { $extension } 확장 기능을 추가하시겠습니까? 이 확장 기능은 { $hostname }에 다음 권한을 부여합니다:
webext-site-perms-header-unsigned-with-perms = { $extension } 확장 기능을 추가하시겠습니까? 이 확장 기능은 확인되지 않았습니다. 악성 확장 기능은 개인 정보를 훔치거나 컴퓨터를 손상시킬 수 있습니다. 이 확장 기능은 { $hostname }에 다음 권한을 부여합니다:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = MIDI 기기 접근
webext-site-perms-midi-sysex = SysEx 지원과 함께 MIDI 기기 접근
