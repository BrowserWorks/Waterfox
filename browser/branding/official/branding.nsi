# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# NSIS branding defines for official release builds.
# The nightly build branding.nsi is located in browser/installer/windows/nsis/
# The unofficial build branding.nsi is located in browser/branding/unofficial/

# BrandFullNameInternal is used for some registry and file system values
# instead of BrandFullName and typically should not be modified.
!define BrandFullNameInternal "Mozilla Firefox"
!define CompanyName           "Mozilla Corporation"
!define URLInfoAbout          "https://www.mozilla.org"
!define URLUpdateInfo         "https://www.mozilla.org/firefox/${AppVersion}/releasenotes"
!define HelpLink              "https://support.mozilla.org"

; The OFFICIAL define is a workaround to support different urls for Release and
; Beta since they share the same branding when building with other branches that
; set the update channel to beta.
!define OFFICIAL
!define URLStubDownload32 "http://download.mozilla.org/?os=win&lang=${AB_CD}&product=firefox-latest"
!define URLStubDownload64 "http://download.mozilla.org/?os=win64&lang=${AB_CD}&product=firefox-latest"
!define URLManualDownload "https://www.mozilla.org/${AB_CD}/firefox/installer-help/?channel=release&installer_lang=${AB_CD}"
!define URLSystemRequirements "https://www.mozilla.org/firefox/system-requirements/"
!define Channel "release"

# The installer's certificate name and issuer expected by the stub installer
!define CertNameDownload   "Mozilla Corporation"
!define CertIssuerDownload "DigiCert SHA2 Assured ID Code Signing CA"

# Dialog units are used so the UI displays correctly with the system's DPI
# settings.
# The dialog units for the bitmap's dimensions should match exactly with the
# bitmap's width and height in pixels.
!define APPNAME_BMP_WIDTH_DU "134u"
!define APPNAME_BMP_HEIGHT_DU "36u"
!define INTRO_BLURB_WIDTH_DU "258u"
!define INTRO_BLURB_EDGE_DU "170u"
!define INTRO_BLURB_LTR_TOP_DU "20u"
!define INTRO_BLURB_RTL_TOP_DU "12u"

# UI Colors that can be customized for each channel
!define FOOTER_CONTROL_TEXT_COLOR_NORMAL 0x000000
!define FOOTER_CONTROL_TEXT_COLOR_FADED 0x666666
!define FOOTER_BKGRD_COLOR 0xFFFFFF
!define INTRO_BLURB_TEXT_COLOR 0x666666
!define INSTALL_BLURB_TEXT_COLOR 0x666666
!define INSTALL_PROGRESS_TEXT_COLOR_NORMAL 0x666666
!define COMMON_TEXT_COLOR_NORMAL 0x000000
!define COMMON_TEXT_COLOR_FADED 0x666666
!define COMMON_BKGRD_COLOR 0xF0F0F0
