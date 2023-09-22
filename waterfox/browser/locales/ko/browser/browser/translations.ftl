# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = 페이지 번역
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = 페이지 번역 - 베타
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext = { -brand-shorter-name }에서 개인 정보가 보호되는 번역을 사용해 보세요 - 베타
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = { $fromLanguage }에서 { $toLanguage }(으)로 번역된 페이지
urlbar-translations-button-loading =
    .tooltiptext = 번역 진행 중
translations-panel-settings-button =
    .aria-label = 번역 설정 관리
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } 베타

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = 언어 관리
translations-panel-settings-about = { -brand-shorter-name } 번역 정보
translations-panel-settings-about2 =
    .label = { -brand-shorter-name } 번역 정보
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = 항상 { $language } 번역
translations-panel-settings-always-translate-unknown-language =
    .label = 항상 이 언어 번역
translations-panel-settings-always-offer-translation =
    .label = 항상 번역 제안
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = 항상 { $language } 번역하지 않음
translations-panel-settings-never-translate-unknown-language =
    .label = 항상 이 언어 번역하지 않음
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = 항상 이 사이트 번역하지 않음

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = 이 페이지를 번역할까요?
translations-panel-translate-button =
    .label = 번역
translations-panel-translate-button-loading =
    .label = 잠시만 기다려 주세요…
translations-panel-translate-cancel =
    .label = 취소
translations-panel-learn-more-link = 더 알아보기
translations-panel-intro-header = { -brand-shorter-name }에서 개인 정보가 보호되는 번역을 사용해 보세요
translations-panel-intro-description = 개인 정보 보호를 위해 번역은 사용자의 기기를 떠나지 않습니다. 새로운 언어와 개선 사항이 곧 제공됩니다!
translations-panel-error-translating = 번역하는 중에 문제가 발생했습니다. 다시 시도하세요.
translations-panel-error-load-languages = 언어를 로드할 수 없음
translations-panel-error-load-languages-hint = 인터넷 연결을 확인하고 다시 시도하세요.
translations-panel-error-load-languages-hint-button =
    .label = 다시 시도
translations-panel-error-unsupported = 이 페이지는 번역할 수 없습니다.
translations-panel-error-dismiss-button =
    .label = 확인
translations-panel-error-change-button =
    .label = 원본 언어 변경
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = 죄송합니다. 아직 { $language } 언어는 지원하지 않습니다.
translations-panel-error-unsupported-hint-unknown = 죄송합니다. 아직 이 언어는 지원하지 않습니다.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = 원본 언어:
translations-panel-to-label = 대상 언어:

## The translation panel appears from the url bar, and this view is the "restore" view
## that lets a user restore a page to the original language, or translate into another
## language.

# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `The page is translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
translations-panel-revisit-header = 이 페이지는 { $fromLanguage }에서 { $toLanguage }(으)로 번역됨
translations-panel-choose-language =
    .label = 언어 선택
translations-panel-restore-button =
    .label = 원본 보기

## Waterfox Translations language management in about:preferences.

translations-manage-header = 번역
translations-manage-settings-button =
    .label = 설정…
    .accesskey = t
translations-manage-description = 오프라인 번역을 위한 언어를 다운로드합니다.
translations-manage-all-language = 모든 언어
translations-manage-download-button = 다운로드
translations-manage-delete-button = 삭제
translations-manage-error-download = 언어 파일을 다운로드하는 중에 문제가 발생했습니다. 다시 시도하세요.
translations-manage-error-delete = 언어 파일을 삭제하는 동안 오류가 발생했습니다. 다시 시도하세요.
translations-manage-intro = 언어 및 사이트 번역 기본 설정을 하고 오프라인 번역을 위해 설치된 언어를 관리합니다.
translations-manage-install-description = 오프라인 번역을 위한 언어를 설치합니다.
translations-manage-language-install-button =
    .label = 설치
translations-manage-language-install-all-button =
    .label = 모두 설치
    .accesskey = I
translations-manage-language-remove-button =
    .label = 제거
translations-manage-language-remove-all-button =
    .label = 모두 제거
    .accesskey = e
translations-manage-error-install = 언어 파일을 설치하는 중에 문제가 발생했습니다. 다시 시도하세요.
translations-manage-error-remove = 언어 파일을 제거하는 동안 오류가 발생했습니다. 다시 시도하세요.
translations-manage-error-list = 번역에 사용할 수 있는 언어 목록을 가져오지 못했습니다. 다시 시도하려면 페이지를 새로 고침하세요.
translations-settings-title =
    .title = 번역 설정
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = 다음 언어는 자동으로 번역됨
translations-settings-never-translate-langs-description = 다음 언어는 번역이 제공되지 않음
translations-settings-never-translate-sites-description = 다음 사이트는 번역이 제공되지 않음
translations-settings-languages-column =
    .label = 언어
translations-settings-remove-language-button =
    .label = 언어 제거
    .accesskey = R
translations-settings-remove-all-languages-button =
    .label = 모든 언어 제거
    .accesskey = e
translations-settings-sites-column =
    .label = 웹 사이트
translations-settings-remove-site-button =
    .label = 사이트 제거
    .accesskey = S
translations-settings-remove-all-sites-button =
    .label = 모든 사이트 제거
    .accesskey = m
translations-settings-close-dialog =
    .buttonlabelaccept = 닫기
    .buttonaccesskeyaccept = C
