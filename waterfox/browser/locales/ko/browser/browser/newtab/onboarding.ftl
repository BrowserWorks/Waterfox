# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = { -brand-short-name }에 오신 것을 환영합니다
onboarding-start-browsing-button-label = 탐색 시작
onboarding-not-now-button-label = 나중에

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = 좋습니다. { -brand-short-name }를 설치했네요.
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = 이제 <img data-l10n-name="icon"/> <b>{ $addon-name }</b> 부가 기능을 설치하겠습니다.
return-to-amo-add-extension-label = 확장 기능 추가
return-to-amo-add-theme-label = 테마 추가

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 시작하기:  { $current } / { $total } 화면

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = 진행률: { $current } / { $total } 단계
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = 시작
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — 가구 디자이너, Waterfox 팬
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = 애니메이션 끄기

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] 쉽게 접근할 수 있도록 { -brand-short-name }를 Dock에 넣으세요
       *[other] 쉽게 접근할 수 있도록 { -brand-short-name }를 작업 표시줄에 고정하세요
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Dock에 넣기
       *[other] 작업 표시줄에 고정
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = 시작하기
mr1-onboarding-welcome-header = { -brand-short-name }에 오신 것을 환영합니다
mr1-onboarding-set-default-pin-primary-button-label = { -brand-short-name }를 기본 브라우저로 설정
    .title = { -brand-short-name }를 기본 브라우저로 설정하고 작업 표시줄에 고정
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = { -brand-short-name }를 기본 브라우저로 설정
mr1-onboarding-set-default-secondary-button-label = 나중에
mr1-onboarding-sign-in-button-label = 로그인

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = { -brand-short-name }를 기본 브라우저로 설정하세요
mr1-onboarding-default-subtitle = 탐색할 때 속도, 안전 및 개인 정보 보호 기능이 제공됩니다.
mr1-onboarding-default-primary-button-label = 기본 브라우저로 설정

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = 모든 것을 가지고 오세요
mr1-onboarding-import-subtitle = 비밀번호, 북마크 등을 <br/>가져옵니다.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = { $previous }에서 가져오기
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 이전 브라우저에서 가져오기
mr1-onboarding-import-secondary-button-label = 나중에
mr2-onboarding-colorway-header = 색상 라이프
mr2-onboarding-colorway-subtitle = 생동감 넘치는 새로운 컬러웨이입니다. 제한된 시간 동안 사용할 수 있습니다.
mr2-onboarding-colorway-primary-button-label = 컬러웨이 저장
mr2-onboarding-colorway-secondary-button-label = 나중에
mr2-onboarding-colorway-label-soft = 연하게
mr2-onboarding-colorway-label-balanced = 중간
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = 진하게
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = 자동
# This string will be used for Default theme
mr2-onboarding-theme-label-default = 기본
mr1-onboarding-theme-header = 나만의 것으로 만드세요
mr1-onboarding-theme-subtitle = 테마로 { -brand-short-name }를 개인화하세요.
mr1-onboarding-theme-primary-button-label = 테마 저장
mr1-onboarding-theme-secondary-button-label = 나중에
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = 시스템 테마
mr1-onboarding-theme-label-light = 밝게
mr1-onboarding-theme-label-dark = 어둡게
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = 완료

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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = 이 컬러웨이를 사용합니다.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = 이 컬러웨이를 사용합니다.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = { $colorwayName } 컬러웨이를 탐색합니다.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = { $colorwayName } 컬러웨이를 탐색합니다.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = 기본 테마를 탐색합니다.
# Selector description for default themes
mr2-onboarding-default-theme-label = 기본 테마를 탐색합니다.

## Strings for Thank You page

mr2-onboarding-thank-you-header = 저희를 선택해 주셔서 감사합니다.
mr2-onboarding-thank-you-text = { -brand-short-name }는 비영리 단체가 지원하는 독립 브라우저입니다. 우리는 함께 웹을 안전하고, 건강하고, 더 사생활 보호를 하도록 만들고 있습니다.
mr2-onboarding-start-browsing-button-label = 탐색 시작

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = 언어를 선택하세요
mr2022-onboarding-live-language-text = { -brand-short-name }는 사용자의 언어로 표시합니다
mr2022-language-mismatch-subtitle = 커뮤니티 덕분에 { -brand-short-name }는 90개 이상의 언어로 번역되었습니다. 사용자의 시스템은 { $systemLanguage } 언어를 사용 중이고 { -brand-short-name }는 { $appLanguage } 언어를 사용하고 있는 것 같습니다.
onboarding-live-language-button-label-downloading = { $negotiatedLanguage }용 언어 팩 다운로드 중…
onboarding-live-language-waiting-button = 사용 가능한 언어를 가져오는 중…
onboarding-live-language-installing = { $negotiatedLanguage }용 언어 팩 설치 중…
mr2022-onboarding-live-language-switch-to = { $negotiatedLanguage } 언어로 전환
mr2022-onboarding-live-language-continue-in = { $appLanguage } 언어로 계속 사용
onboarding-live-language-secondary-cancel-download = 취소
onboarding-live-language-skip-button-label = 건너뛰기

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100
    <span data-l10n-name="zap">감사합니다</span>
fx100-thank-you-subtitle = 100번째 출시입니다! 더 나은 건강한 인터넷을 구축할 수 있도록 도와주셔서 감사합니다.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name }를 Dock에 넣기
       *[other] { -brand-short-name }를 작업 표시줄에 고정
    }
fx100-upgrade-thanks-header = 100 감사합니다
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = 100번째 { -brand-short-name } 출시입니다. 더 나은 건강한 인터넷을 구축할 수 있도록 도와주셔서 <em>감사합니다</em>.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = 100번째 출시입니다! 커뮤니티의 일원이 되어주셔서 감사합니다. 다음 100번을 위해 클릭 한 번으로 { -brand-short-name }를 유지하세요.
mr2022-onboarding-secondary-skip-button-label = 이 단계 건너뛰기

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = 놀라운 인터넷을 여세요
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = 어디서나 클릭 한 번으로 { -brand-short-name }를 실행하세요. 그럴 때마다 더 개방적이고 독립적인 웹을 선택하게 됩니다.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name }를 Dock에 넣기
       *[other] { -brand-short-name }를 작업 표시줄에 고정
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = 비영리 단체가 지원하는 브라우저로 시작하세요. 웹을 탐색하시는 동안 저희는 개인 정보를 보호합니다.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = { -brand-product-name }를 사랑해 주셔서 감사합니다.
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = 어디서나 클릭 한 번으로 더 건강한 인터넷을 시작하세요. 최신 업데이트에는 여러분이 좋아할 만한 새로운 것들이 가득합니다.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = 웹을 탐색하는 동안 개인 정보를 보호하는 브라우저를 사용하세요. 최신 업데이트는 당신이 좋아하는 것들로 가득 차 있습니다.
mr2022-onboarding-existing-pin-checkbox-label = { -brand-short-name } 사생활 보호 모드도 추가

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = { -brand-short-name }를 기본 브라우저로 만드세요
mr2022-onboarding-set-default-primary-button-label = { -brand-short-name }를 기본 브라우저로 설정
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = 비영리 단체가 지원하는 브라우저를 사용하세요. 웹을 탐색하시는 동안 저희는 개인 정보를 보호합니다.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = 최신 버전이 사용자 중심으로 구축되어, 그 어느 때보다 쉽게 웹을 둘러볼 수 있습니다. 여러분이 좋아할 만한 기능으로 가득 차 있습니다.
mr2022-onboarding-get-started-primary-button-label = 빠른 설정

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = 매우 빠른 설정
mr2022-onboarding-import-subtitle = { -brand-short-name }를 원하는 대로 설정하세요. 기존 브라우저에서 북마크, 비밀번호 등을 추가하세요.
mr2022-onboarding-import-primary-button-label-no-attribution = 이전 브라우저에서 가져오기

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = 영감을 주는 색상을 선택하세요
mr2022-onboarding-colorway-subtitle = 독립적인 목소리가 문화를 바꿀 수 있습니다.
mr2022-onboarding-colorway-primary-button-label = 컬러웨이 설정
mr2022-onboarding-existing-colorway-checkbox-label = { -firefox-home-brand-name }를 다채로운 홈페이지로 만드세요
mr2022-onboarding-colorway-label-default = 기본
mr2022-onboarding-colorway-tooltip-default =
    .title = 기본
mr2022-onboarding-colorway-description-default = <b>현재의 { -brand-short-name } 색상을 사용합니다.</b>
mr2022-onboarding-colorway-label-playmaker = 플레이메이커
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = 플레이메이커
mr2022-onboarding-colorway-description-playmaker = <b>플레이메이커입니다.</b> 여러분은 승리할 수 있는 기회를 만들고 주변의 모든 사람들이 게임을 향상시킬 수 있도록 돕습니다.
mr2022-onboarding-colorway-label-expressionist = 표현주의자
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = 표현주의자
mr2022-onboarding-colorway-description-expressionist = <b>표현주의자입니다.</b> 여러분은 세상을 다르게 보고 여러분의 창조물이 다른 사람들의 감정을 자극합니다.
mr2022-onboarding-colorway-label-visionary = 공상가
mr2022-onboarding-colorway-tooltip-visionary =
    .title = 공상가
mr2022-onboarding-colorway-description-visionary = <b>공상가입니다.</b> 여러분은 현상 유지에 의문을 제기하고 더 나은 미래를 상상하도록 다른 사람들을 움직입니다.
mr2022-onboarding-colorway-label-activist = 활동가
mr2022-onboarding-colorway-tooltip-activist =
    .title = 활동가
mr2022-onboarding-colorway-description-activist = <b>활동가입니다.</b> 여러분은 세상을 당신이 발견한 것보다 더 나은 곳으로 남겨두고 다른 사람들이 믿도록 이끕니다.
mr2022-onboarding-colorway-label-dreamer = 몽상가
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = 몽상가
mr2022-onboarding-colorway-description-dreamer = <b>몽상가입니다.</b> 여러분은 행운이 대담한 사람을 선호하고 다른 사람들에게 용기를 북돋아준다고 믿습니다.
mr2022-onboarding-colorway-label-innovator = 혁신가
mr2022-onboarding-colorway-tooltip-innovator =
    .title = 혁신가
mr2022-onboarding-colorway-description-innovator = <b>혁신가입니다.</b> 여러분은 어디에서나 기회를 보고 여러분 주변의 모든 사람들의 삶에 영향을 미칩니다.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = 노트북에서 휴대폰으로 이동 후 다시 이동
mr2022-onboarding-mobile-download-subtitle = 한 기기의 탭을 가져와서 다른 기기에서 중단한 부분부터 다시 시작하세요. 또한 { -brand-product-name }를 사용하는 곳이면 어디에서나 북마크와 비밀번호를 동기화할 수 있습니다.
mr2022-onboarding-mobile-download-cta-text = QR 코드를 스캔하여 모바일용 { -brand-product-name }를 받거나 <a data-l10n-name="download-label">다운로드 링크를 보내세요.</a>
mr2022-onboarding-no-mobile-download-cta-text = 모바일용 { -brand-product-name }를 받으려면 QR 코드를 스캔하세요.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = 한 번의 클릭으로 사생활 보호 모드의 자유를 얻으세요
mr2022-upgrade-onboarding-pin-private-window-subtitle = 쿠키나 기록이 저장되지 않습니다. 아무도 보고 있지 않은 것처럼 탐색하세요.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } 사생활 보호 모드를 Dock에 넣기
       *[other] { -brand-short-name } 사생활 보호 모드를 작업 표시줄에 고정
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = 항상 개인 정보를 존중합니다
mr2022-onboarding-privacy-segmentation-subtitle = 지능적인 제안에서 더 똑똑한 검색에 이르기까지 저희는 더 좋고 더 개인화된 { -brand-product-name }를 만들기 위해 끊임없이 노력하고 있습니다.
mr2022-onboarding-privacy-segmentation-text-cta = 사용자의 탐색을 향상시키기 위해 사용자의 데이터를 사용하는 새로운 기능을 제공할 때 무엇을 보고 싶습니까?
mr2022-onboarding-privacy-segmentation-button-primary-label = { -brand-product-name } 추천 사용
mr2022-onboarding-privacy-segmentation-button-secondary-label = 자세한 정보 표시

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = 저희가 더 나은 웹을 만드는 것을 돕고 계십니다.
mr2022-onboarding-gratitude-subtitle = Waterfox 재단이 지원하는 { -brand-short-name }를 사용해 주셔서 감사합니다. 여러분의 지원으로 우리는 인터넷을 보다 개방적이고 접근 가능하며 모두에게 더 좋게 만들기 위해 노력하고 있습니다.
mr2022-onboarding-gratitude-primary-button-label = 새 기능 보기
mr2022-onboarding-gratitude-secondary-button-label = 탐색 시작
