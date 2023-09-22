# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = { -brand-full-name } 정보

releaseNotes-link = 새 기능

update-checkForUpdatesButton =
    .label = 업데이트 확인
    .accesskey = C

update-updateButton =
    .label = { -brand-shorter-name } 업데이트를 위해 다시 시작
    .accesskey = R

update-checkingForUpdates = 업데이트 확인 중…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>업데이트 다운로드 중 — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = 업데이트 다운로드 중 — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = 업데이트 적용 중…

update-failed = 업데이트에 실패했습니다. <label data-l10n-name="failed-link">최신 버전 다운로드</label>
update-failed-main = 업데이트에 실패했습니다. <a data-l10n-name="failed-link-main">최신 버전 다운로드</a>

update-adminDisabled = 시스템 관리자에 의해 업데이트가 비활성화됨
update-noUpdatesFound = { -brand-short-name }가 최신 버전입니다
aboutdialog-update-checking-failed = 업데이트 확인에 실패했습니다.
update-otherInstanceHandlingUpdates = 다른 { -brand-short-name }에서 이미 업데이트를 하고 있음

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = <label data-l10n-name="manual-link">{ $displayUrl }</label>에서 업데이트를 사용 가능합니다.
settings-update-manual-with-link = <a data-l10n-name="manual-link">{ $displayUrl }</a>에서 업데이트를 사용 가능합니다.

update-unsupported = 이 시스템에서는 더 이상 업데이트를 할 수 없습니다.<label data-l10n-name="unsupported-link">더 알아보기</label>

update-restarting = 다시 시작하는 중…

update-internal-error2 = 내부 오류로 인해 업데이트를 확인할 수 없습니다. <label data-l10n-name="manual-link">{ $displayUrl }</label>에서 업데이트를 사용 가능합니다.

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = 현재 사용 중인 업데이트 채널은 <label data-l10n-name="current-channel">{ $channel }</label> 입니다.

warningDesc-version = { -brand-short-name }는 실험적 버전으로서 불안정할 수 있습니다.

aboutdialog-help-user = { -brand-product-name } 도움말
aboutdialog-submit-feedback = 의견 보내기

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label>는  <label data-l10n-name="community-exp-creditsLink">모든 사람이 공공 자원으로서 사용하는 </label> 열린 웹을 만들고자 하는 글로벌 커뮤니티입니다.

community-2 = { -brand-short-name }는 모든 사람이 공공 자원으로서 사용하는 열린 웹을 만들고자 하는 <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>라는 <label data-l10n-name="community-creditsLink">글로벌 커뮤니티</label>에서 설계했습니다.

helpus = 돕고 싶으십니까? <label data-l10n-name="helpus-donateLink">기부</label>하시거나 <label data-l10n-name="helpus-getInvolvedLink">참여</label>하세요!

bottomLinks-license = 라이선스 정보
bottomLinks-rights = 사용자 권리
bottomLinks-privacy = 개인정보처리방침

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-비트)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-비트)
