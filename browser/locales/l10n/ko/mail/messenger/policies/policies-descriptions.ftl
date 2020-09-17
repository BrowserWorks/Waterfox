# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = WebExtensions이 chrome.storage.managed를 통해 액세스할 수 있는 정책을 설정합니다.

policy-AppAutoUpdate = 응용 프로그램 자동 업데이트를 사용하거나 사용하지 않게 합니다.

policy-AppUpdateURL = 앱 업데이트를 위한 맞춤 URL을 설정합니다.

policy-Authentication = 지원하는 웹 사이트를 위하여 통합 인증을 설정합니다.

policy-BlockAboutAddons = 애드온 관리자 (about:addons) 접속을 차단합니다.

policy-BlockAboutConfig = about:config 페이지 접속을 차단합니다.

policy-BlockAboutProfiles = about:profiles 페이지 접속을 차단합니다.

policy-BlockAboutSupport = about:support 페이지 접속을 차단합니다.

policy-CaptivePortal = 캡티브 포탈 지원을 작동시키거나 작동하지 않게 합니다.

policy-CertificatesDescription = 인증서를 추가하거나 기본 제공 인증서를 사용합니다.

policy-Cookies = 웹 사이트에서 쿠키를 허용하거나 거부합니다.

policy-DisabledCiphers = 암호화를 사용 안 합니다.

policy-DefaultDownloadDirectory = 기본 다운로드 디렉토리를 설정하십시오.

policy-DisableAppUpdate = { -brand-short-name }가 업데이트되지 못하게 합니다.

policy-DisableDefaultClientAgent = 기본 클라이언트 에이전트가 조치를 수행하지 못하게 하십시오. Windows에 만 적용됩니다. 다른 플랫폼에는 에이전트가 없습니다.

policy-DisableDeveloperTools = 개발자 도구 접속을 차단합니다.

policy-DisableFeedbackCommands = 도움말 메뉴의 의견 보내기 명령(의견과 가짜 사이트 신고)을 비활성화합니다.

policy-DisableForgetButton = Forget 버튼에 대한 접근을 금지합니다.

policy-DisableFormHistory = 검색과 양식 기록을 저장하지 않습니다.

policy-DisableMasterPasswordCreation = 설정되어 있으면 기본 비밀번호를 만들 수 없습니다.

policy-DisablePasswordReveal = 저장된 로그인에 비밀번호 보기 기능을 허용하지 않습니다.

policy-DisableProfileImport = 다른 앱에서 데이터를 가져오는 메뉴 명령을 작동하지 않게 합니다.

policy-DisableSafeMode = 안전 모드로 재시작하는 기능을 비활성화 합니다. 참고: 그룹 정책을 사용해서 쉬프트키를 눌러서 안전 모드로 들어가는 방법을 비활성화 하는 것은 윈도우에서만 가능합니다.

policy-DisableSecurityBypass = 사용자가 특정 보안 경고를 우회하지 못하게 합니다.

policy-DisableSystemAddonUpdate = { -brand-short-name }가 시스템 부가기능을 설치하거나 업데이트하지 못하게 합니다.

policy-DisableTelemetry = 원격 측정을 끕니다.

policy-DisplayMenuBar = 기본으로 메뉴바를 표시합니다.

policy-DNSOverHTTPS = HTTPS를 통한 DNS를 설정합니다.

policy-DontCheckDefaultClient = 시작할 때 기본 브라우저 확인을 사용하지 않습니다.

policy-DownloadDirectory = 다운로드 디렉토리를 설정하고 잠급니다.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = 콘텐츠 차단을 작동시키거나 작동하지 않게 하고 선택적으로 이를 고정합니다.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = 암호화된 미디어 확장 기능을 사용하거나 사용하지 않게 하고 선택적으로 잠급니다.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = 확장기능을 설치하거나 제거, 잠급니다. 설치 옵션은 URL이나 경로를 파라메터로 받습니다. 설치 제거와 잠금 옵션은 확장기능의 ID를 받습니다.

policy-ExtensionSettings = 확장기능 설치의 모든 측면을 관리합니다.

policy-ExtensionUpdate = 확장기능의 자동 업데이트를 활성화하거나 비활성화합니다.

policy-HardwareAcceleration = False면 하드웨어 가속을 끕니다.

policy-InstallAddonsPermission = 특정 웹사이트가 애드온을 설치하도록 허용합니다.

policy-LegacyProfiles = 각 설치별로 다른 프로필 사용을 강제하는 기능을 사용 안 합니다.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = 기본 레거시 SameSite 쿠키 동작 설정을 사용합니다.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = 지정된 사이트의 쿠키에 대해 레거시 SameSite 동작으로 되돌립니다.

##

policy-LocalFileLinks = 특정 웹사이트가 로컬 파일에 연결하는 것을 허용합니다.

policy-NetworkPrediction = 네트워크 예측(DNS의 프리패치)을 작동시키거나 작동하지 않게 합니다.

policy-OfferToSaveLogins = { -brand-short-name }가 로그인과 비밀번호 기억을 제공하도록 허용하는 설정을 강제합니다. True와 false 값을 사용할 수 있습니다.

policy-OfferToSaveLoginsDefault = 저장된 로그인과 비밀번호를 기억하도록 { -brand-short-name }가 제공하는 기본값을 설정하세요. true 및 false 값이 모두 허용됩니다.

policy-OverrideFirstRunPage = 처음 시작 페이지 설정을 재정의 합니다. 처음 시작 페이지를 비활성화 하려면 이 정책을 빈칸으로 설정하세요.

policy-OverridePostUpdatePage = “새기능” 업데이트 후 페이지를 재정의 합니다. 업데이트 후 페이지를 비활성화 하려면 이 정책을 빈칸으로 설정하세요.

policy-PasswordManagerEnabled = 비밀번호 관리자에 비밀번호 저장을 사용합니다.

# PDF.js and PDF should not be translated
policy-PDFjs = { -brand-short-name }에 내장된 PDF 뷰어인 PDF.js를 사용 안하거나 구성합니다.

policy-Permissions2 = 카메라, 마이크, 위치, 알림 및 자동 재생에 대한 권한을 구성합니다.

policy-Preferences = 설정의 하위 집합에 대한 값을 설정하고 고정합니다.

policy-PromptForDownloadLocation = 다운로드시 저장할 곳을 묻습니다.

policy-Proxy = 프록시를 설정합니다.

policy-RequestedLocales = 어플리케이션의 요청된 로케일의 목록을 설정 순서로 설정합니다.

policy-SanitizeOnShutdown2 = 끌 때 탐색 정보를 지웁니다.

policy-SearchEngines = 검색 엔진 설정을 구성합니다. 이 정책은 확장 지원 버전(ESR)에서만 가능합니다.

policy-SearchSuggestEnabled = 검색 제안을 사용하거나 사용하지 않게 합니다.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 모듈을 설치하십시오.

policy-SSLVersionMax = 최대 SSL 버전을 설정하십시오.

policy-SSLVersionMin = 최소 SSL 버전을 설정하십시오.

policy-SupportMenu = 도움말 메뉴에 맞춤 지원 메뉴 항목을 추가합니다.

policy-UserMessaging = 사용자에게 특정 메시지를 표시하지 않습니다.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = 특정 웹사이트 방문을 차단합니다. 자세한 형식에 대해서는 문서를 참고하세요.
