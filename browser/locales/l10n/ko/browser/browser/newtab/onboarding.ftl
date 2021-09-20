# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = 더 알아보기
onboarding-button-label-get-started = 시작하기

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = { -brand-short-name }에 오신 것을 환영합니다
onboarding-welcome-body = 이제 브라우저가 있습니다.<br/>{ -brand-product-name }의 나머지를 만나 보세요.
onboarding-welcome-learn-more = 장점 더 알아보기
onboarding-welcome-modal-get-body = 이제 브라우저가 있습니다.<br/>{ -brand-product-name }를 최대한 활용해 보세요.
onboarding-welcome-modal-supercharge-body = 개인 정보 보호를 강화하세요.
onboarding-welcome-modal-privacy-body = 이제 브라우저가 있습니다. 개인 정보 보호 기능을 더 추가해 보세요.
onboarding-welcome-modal-family-learn-more = { -brand-product-name } 제품군에 대해 알아보세요.
onboarding-welcome-form-header = 여기서 시작
onboarding-join-form-body = 시작하려면 이메일 주소를 입력하세요.
onboarding-join-form-email =
    .placeholder = 이메일 입력
onboarding-join-form-email-error = 유효한 이메일이 필요함
onboarding-join-form-legal = 계속 진행하면 <a data-l10n-name="terms">서비스 약관</a> 및 <a data-l10n-name="privacy">개인정보처리방침</a>에 동의하게 됩니다.
onboarding-join-form-continue = 계속
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = 계정이 이미 있습니까?
# Text for link to submit the sign in form
onboarding-join-form-signin = 로그인
onboarding-start-browsing-button-label = 탐색 시작
onboarding-cards-dismiss =
    .title = 닫기
    .aria-label = 닫기

## Welcome full page string

onboarding-fullpage-welcome-subheader = 여러분이 할 수 있는 모든 것을 탐험해 봅시다.
onboarding-fullpage-form-email =
    .placeholder = 이메일 주소…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }와 함께 하세요
onboarding-sync-welcome-content = 북마크, 기록, 비밀번호 및 다른 설정을 모든 기기에서 사용해 보세요.
onboarding-sync-welcome-learn-more-link = Waterfox 계정 더 알아보기
onboarding-sync-form-input =
    .placeholder = 이메일
onboarding-sync-form-continue-button = 계속
onboarding-sync-form-skip-login-button = 단계 건너뛰기

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = 이메일 입력
onboarding-sync-form-sub-header = 해서 { -sync-brand-name } 사용

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = 내가 사용하는 모든 기기에서 개인 정보를 존중하는 도구를 사용합니다.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = 우리가 하는 모든 활동은 개인 정보 약속을 존중합니다: 적게 가집니다. 안전하게 보관합니다. 비밀은 없습니다.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = { -brand-product-name }를 사용하는 모든 곳에서 북마크, 기록, 비밀번호 등을 사용하세요.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = 개인 정보가 알려진 데이터 유출에서 발견되면 알림을 받습니다.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = 비밀번호를 보호하면서 항상 가지고 다녀 보세요.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = 추적으로부터의 보호
onboarding-tracking-protection-text2 = { -brand-short-name }는 웹 사이트가 온라인에서 사용자를 추적하는 것을 막아, 광고가 웹에서 사용자를 따라 다니는 것을 어렵게 만듭니다.
onboarding-tracking-protection-button2 = 작동 방식
onboarding-data-sync-title = 설정을 항상 유지하기
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = { -brand-product-name }를 사용하는 모든 곳에서 북마크, 비밀번호 등을 동기화하세요.
onboarding-data-sync-button2 = { -sync-brand-short-name }에 로그인하기
onboarding-firefox-monitor-title = 데이터 유출 알림
onboarding-firefox-monitor-text2 = { -monitor-brand-name }는 데이터 유출 사건에 사용자의 이메일이 있는지를 모니터링하고 새 데이터 유출 사건에 있으면 사용자에게 알려 줍니다.
onboarding-firefox-monitor-button = 알림 가입 신청
onboarding-browse-privately-title = 사생활 보호 모드
onboarding-browse-privately-text = 사생활 보호 모드는 검색 및 방문 기록을 지우므로 컴퓨터를 사용하는 다른 사람들로부터 비밀을 유지할 수 있습니다.
onboarding-browse-privately-button = 사생활 보호 창 열기
onboarding-firefox-send-title = 공유 파일 보호
onboarding-firefox-send-text2 = 파일을 { -send-brand-name }에 업로드하여 종단 간 암호화와 자동으로 만료되는 링크로 공유하세요.
onboarding-firefox-send-button = { -send-brand-name }를 사용해보세요
onboarding-mobile-phone-title = 휴대폰에서 { -brand-product-name } 받기
onboarding-mobile-phone-text = iOS 또는 Android용 { -brand-product-name }를 다운로드하고 기기 간에 데이터를 동기화합니다.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = 모바일 브라우저 다운로드
onboarding-send-tabs-title = 즉시 탭 보내기
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = 링크를 복사하거나 브라우저를 떠나지 않고도 다른 기기에 페이지를 쉽게 공유할 수 있습니다.
onboarding-send-tabs-button = 탭 보내기 사용 시작
onboarding-pocket-anywhere-title = 어디서나 읽고 듣기
onboarding-pocket-anywhere-text2 = { -pocket-brand-name } 앱으로 좋아하는 콘텐츠를 오프라인에 저장하고 편리할 때마다 읽고, 듣고, 시청할 수 있습니다.
onboarding-pocket-anywhere-button = { -pocket-brand-name }을 사용해보세요
onboarding-lockwise-strong-passwords-title = 강력한 비밀번호 생성 및 저장
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name }는 즉석에서 강력한 비밀번호를 만들고 모든 비밀번호를 한 곳에 저장합니다.
onboarding-lockwise-strong-passwords-button = 로그인 관리
onboarding-facebook-container-title = Facebook 경계 설정
onboarding-facebook-container-text2 = { -facebook-container-brand-name }는 프로필을 다른 것과 구분하여 유지하므로 Facebook이 사용자를 구분하여 광고하는 것을 어렵게 만듭니다.
onboarding-facebook-container-button = 확장 기능 추가
onboarding-import-browser-settings-title = 북마크, 비밀번호 등을 가져오기
onboarding-import-browser-settings-text = Chrome 사이트와 설정을 쉽게 가져올 수 있습니다.
onboarding-import-browser-settings-button = Chrome 데이터 가져오기
onboarding-personal-data-promise-title = 사생활 보호를 고려한 설계
onboarding-personal-data-promise-text = { -brand-product-name }는 사용자의 데이터를 적게 사용하고 보호하며 사용하는 방법을 명확히 함으로써 사용자의 데이터를 존중합니다.
onboarding-personal-data-promise-button = 우리의 약속을 읽으세요

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = 좋습니다. { -brand-short-name }를 설치했네요.
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = 이제 <icon></icon><b>{ $addon-name } 부가 기능</b>을 설치하겠습니다.
return-to-amo-extension-button = 확장 기능 추가
return-to-amo-get-started-button = { -brand-short-name } 시작하기
onboarding-not-now-button-label = 나중에

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = 좋습니다. { -brand-short-name }를 설치했네요.
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = 이제 <img data-l10n-name="icon"/> <b>{ $addon-name }</b> 부가 기능을 설치하겠습니다.
return-to-amo-add-extension-label = 확장 기능 추가

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span>에 오신 것을 환영합니다
onboarding-multistage-welcome-subtitle = 비영리 단체가 지원하는, 빠르고 안전하며 사생활 보호를 위한 브라우저입니다.
onboarding-multistage-welcome-primary-button-label = 설정 시작
onboarding-multistage-welcome-secondary-button-label = 로그인
onboarding-multistage-welcome-secondary-button-text = 계정이 있으십니까?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = { -brand-short-name }를 <span data-l10n-name="zap">기본 브라우저</span>로 설정하기
onboarding-multistage-set-default-subtitle = 탐색할 때 속도, 안전 및 개인 정보 보호 기능이 제공됩니다.
onboarding-multistage-set-default-primary-button-label = 기본 브라우저로
onboarding-multistage-set-default-secondary-button-label = 나중에
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = 클릭 한 번으로 <span data-l10n-name="zap">{ -brand-short-name }</span> 시작
onboarding-multistage-pin-default-subtitle = 웹을 사용할 때 빠르고 안전하며 사생활 보호를 할 수 있습니다.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = 설정이 열리면 웹 브라우저에서 { -brand-short-name }를 선택하세요
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = 그러면 { -brand-short-name }가 작업 표시줄에 고정되고 설정이 열립니다
onboarding-multistage-pin-default-primary-button-label = { -brand-short-name }를 내 기본 브라우저로 만들기
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = 비밀번호, 북마크 및 <span data-l10n-name="zap">기타</span> 가져오기
onboarding-multistage-import-subtitle = 다른 브라우저에서 오셨나요? 모든 것을 { -brand-short-name }에 쉽게 가져올 수 있습니다.
onboarding-multistage-import-primary-button-label = 가져오기 시작
onboarding-multistage-import-secondary-button-label = 나중에
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = 이 기기에서 여기에 나열된 사이트들을 찾았습니다. 사용자가 가져오도록 선택하지 않는 한, { -brand-short-name }는 다른 브라우저로부터 데이터를 저장하거나 동기화하지 않습니다.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 시작하기:  { $current } / { $total } 화면
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = <span data-l10n-name="zap">외양</span> 선택하기
onboarding-multistage-theme-subtitle = 테마로 { -brand-short-name }를 개인화하세요.
onboarding-multistage-theme-primary-button-label2 = 완료
onboarding-multistage-theme-secondary-button-label = 나중에
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 자동
onboarding-multistage-theme-label-light = 밝게
onboarding-multistage-theme-label-dark = 어둡게
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        버튼, 메뉴 및 창에
        운영 체제의 모양을 상속합니다.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        버튼, 메뉴 및 창에
        운영 체제의 모양을 상속합니다.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        버튼, 메뉴 및 창에
        밝은 화면 배색을 사용합니다.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        버튼, 메뉴 및 창에
        밝은 화면 배색을 사용합니다.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        버튼, 메뉴 및 창에
        어두운 화면 배색을 사용합니다.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        버튼, 메뉴 및 창에
        어두운 화면 배색을 사용합니다.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        버튼, 메뉴 및 창에
        색상형 화면 배색을 사용합니다.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        버튼, 메뉴 및 창에
        색상형 화면 배색을 사용합니다.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = 시작
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — 가구 디자이너, Firefox 팬
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = 애니메이션 끄기

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] 쉽게 접근할 수 있도록 { -brand-short-name }를 Dock에 넣기
       *[other] 쉽게 접근할 수 있도록 { -brand-short-name }를 작업 표시 줄에 고정
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Dock에 넣기
       *[other] 작업 표시줄에 고정
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = 시작하기
mr1-onboarding-welcome-header = { -brand-short-name }에 오신 것을 환영합니다
mr1-onboarding-set-default-pin-primary-button-label = { -brand-short-name }를 기본 브라우저로 설정
    .title = { -brand-short-name }를 기본 브라우저로 설정하고 작업 표시줄에 고정
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = { -brand-short-name }를 기본 브라우저로 설정
mr1-onboarding-set-default-secondary-button-label = 나중에
mr1-onboarding-sign-in-button-label = 로그인

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = { -brand-short-name }를 기본 브라우저로 설정
mr1-onboarding-default-subtitle = 탐색할 때 속도, 안전 및 개인 정보 보호 기능이 제공됩니다.
mr1-onboarding-default-primary-button-label = 기본 브라우저로 설정

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = 모든 것을 가져오기
mr1-onboarding-import-subtitle = 비밀번호, 북마크 등을 <br/>가져옵니다.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = { $previous }에서 가져오기
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 이전 브라우저에서 가져오기
mr1-onboarding-import-secondary-button-label = 나중에
mr1-onboarding-theme-header = 나만의 것으로 만들기
mr1-onboarding-theme-subtitle = 테마로 { -brand-short-name }를 개인화하세요.
mr1-onboarding-theme-primary-button-label = 테마 저장
mr1-onboarding-theme-secondary-button-label = 나중에
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = 시스템 테마
mr1-onboarding-theme-label-light = 밝게
mr1-onboarding-theme-label-dark = 어둡게
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        버튼, 메뉴 및 창에 
        운영 체제의 테마를 따릅니다.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        버튼, 메뉴 및 창에 
        운영 체제의 테마를 따릅니다.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        버튼, 메뉴 및 창에 
        밝은 테마를 사용합니다.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        버튼, 메뉴 및 창에 
        밝은 테마를 사용합니다.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        버튼, 메뉴 및 창에 
        어두운 테마를 사용합니다.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        버튼, 메뉴 및 창에 
        어두운 테마를 사용합니다.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        버튼, 메뉴 및 창에 
        역동적이고 다양한 색상의 테마를 사용합니다.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        버튼, 메뉴 및 창에 
        역동적이고 다양한 색상의 테마를 사용합니다.
