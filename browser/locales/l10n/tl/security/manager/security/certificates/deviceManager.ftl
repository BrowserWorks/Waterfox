# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Device Manager
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Mga Security Module at Device

devmgr-header-details =
    .label = Detalye

devmgr-header-value =
    .label = Halaga

devmgr-button-login =
    .label = Mag - Log In
    .accesskey = n

devmgr-button-logout =
    .label = Mag - Log Out
    .accesskey = O

devmgr-button-changepw =
    .label = Palitan ang Password
    .accesskey = P

devmgr-button-load =
    .label = I-load
    .accesskey = L

devmgr-button-unload =
    .label = I-unload
    .accesskey = U

devmgr-button-enable-fips =
    .label = I-enable ang FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = I-disable ang FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = I-load ang PKCS#11 Device Driver

load-device-info = Ipasok ang impormasyon para sa module na gusto mong idagdag.

load-device-modname =
    .value = Pangalan ng Module
    .accesskey = M

load-device-modname-default =
    .value = Bago PKCS#11 Module

load-device-filename =
    .value = Filename ng Module
    .accesskey = f

load-device-browse =
    .label = Mag-browse…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = Status

devinfo-status-disabled =
    .label = Hindi Magagamit

devinfo-status-not-present =
    .label = Hindi Natagpuan

devinfo-status-uninitialized =
    .label = Uninitialized

devinfo-status-not-logged-in =
    .label = Hindi Naka-Login

devinfo-status-logged-in =
    .label = Nakalog-in

devinfo-status-ready =
    .label = Handa na

devinfo-desc =
    .label = Paglalarawan

devinfo-man-id =
    .label = Gumawa

devinfo-hwversion =
    .label = HW Version
devinfo-fwversion =
    .label = FW Version

devinfo-modname =
    .label = Module

devinfo-modpath =
    .label = Path

login-failed = Nabigong mag-Login

devinfo-label =
    .label = Label

devinfo-serialnum =
    .label = Serial Number

fips-nonempty-password-required = Kinakailangan ng FIPS mode na mayroon kang Master Password sa bawat security device. Pakitakda ang password bago subukang mag-enable ng FIPS mode.

unable-to-toggle-fips = Hindi kayang baguhin ang FIPS mode para sa security device. Minumungkahing isara mo at i-restart itong application.
load-pk11-module-file-picker-title = Pumili ng PKCS#11 device driver na ilo-load

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Ang pangalan ng module ay hindi maaaring walang laman.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ ay nakareserba at hindi maaaring gamitin bilang pangalan ng module.

add-module-failure = Hindi nakapagdagdag ng module
del-module-warning = Sigurado ka bang gusto mong burahin itong security module?
del-module-error = Hindi kayang mabura ang module
