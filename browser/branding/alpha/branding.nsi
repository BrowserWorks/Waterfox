# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# NSIS branding defines for Developer Edition builds.
# The official release build branding.nsi is located in other-license/branding/firefox/
# The unofficial build branding.nsi is located in browser/branding/unofficial/

# BrandFullNameInternal is used for some registry and file system values
# instead of BrandFullName and typically should not be modified.
!define BrandFullNameInternal "Waterfox Alpha"
!define BrandShortName        "Waterfox Alpha"
!define BrandFullName         "Waterfox Alpha"
!define CompanyName           "waterfox.net"
!define URLInfoAbout          "https://www.waterfox.net"
!define HelpLink              "https://www.reddit.com/r/waterfox"

!define URLStubDownloadX86 "https://www.waterfox.net/releases"
!define URLStubDownloadAMD64 "https://www.waterfox.net/releases"
!define URLStubDownloadAArch64 "https://www.waterfox.net/releases"
!define URLManualDownload "https://www.waterfox.net/releases"
!define URLSystemRequirements "https://www.waterfox.net/releases"
!define Channel "aurora"

# The installer's certificate name and issuer expected by the stub installer
!define CertNameDownload   "Mozilla Corporation"
!define CertIssuerDownload "DigiCert SHA2 Assured ID Code Signing CA"

# Dialog units are used so the UI displays correctly with the system's DPI
# settings.
# The dialog units for the bitmap's dimensions should match exactly with the
# bitmap's width and height in pixels.
!define APPNAME_BMP_WIDTH_DU 108u
!define APPNAME_BMP_HEIGHT_DU 48u
!define INTRO_BLURB_WIDTH_DU "232u"
!define INTRO_BLURB_EDGE_DU "196u"
!define INTRO_BLURB_LTR_TOP_DU "16u"
!define INTRO_BLURB_RTL_TOP_DU "11u"
!define INSTALL_FOOTER_TOP_DU "-48u"

# UI Colors that can be customized for each channel
!define FOOTER_CONTROL_TEXT_COLOR_NORMAL 0x000000
!define FOOTER_CONTROL_TEXT_COLOR_FADED 0x999999
!define FOOTER_BKGRD_COLOR 0xFFFFFF
!define INSTALL_FOOTER_TEXT_COLOR 0xFFFFFF
!define INTRO_BLURB_TEXT_COLOR 0xFFFFFF
!define INSTALL_BLURB_TEXT_COLOR 0xFFFFFF
!define INSTALL_PROGRESS_TEXT_COLOR_NORMAL 0xFFFFFF
!define COMMON_TEXT_COLOR_NORMAL 0xFFFFFF
!define COMMON_TEXT_COLOR_FADED 0xA1AAB3
!define COMMON_BKGRD_COLOR 0x0F1B26

# Enable DeveloperEdition-specific behavior
!define DEV_EDITION
