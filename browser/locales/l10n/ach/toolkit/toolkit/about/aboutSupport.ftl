# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Kwedo bal me Ngec
page-subtitle = Pot buk man tye ki ngec matek me tic cing ma pire twero bedo tek ka itye ka temo cobo peko. Ka ce itye kamoyo pi lagam me lapeny ma ngene ikom { -brand-short-name }, rot <a data-l10n-name="support-link">support web site</a>.

crashes-title = Ripot me poto
crashes-id = Cwal ngec me ID
crashes-send-date = Kicwalo
crashes-all-reports = Ripot me poto weng
crashes-no-config = Purugram man pe kicano me yaro ripot me poto.
extensions-title = Lamed
extensions-name = Nying
extensions-enabled = Matyero
extensions-version = Cik
extensions-id = ID
support-addons-name = Nying
support-addons-version = Cik
support-addons-id = ID
security-software-name = Nying
features-title = Jami me { -brand-short-name }
features-name = Nying
features-id = ID
app-basics-title = Tic mapire tego
app-basics-name = Nying
app-basics-version = Cik
app-basics-build-id = ID me gedo
app-basics-update-channel = Yoo me ngec manyen
app-basics-update-history = Gin mukato me ngec manyen
app-basics-show-update-history = Nyut gin mukato me ngec manyen
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Lacim me Ngec ikome
       *[other] Boc me lok ikome
    }
app-basics-enabled-plugins = Keto ite ma kimino
app-basics-build-config = Yub Cano
app-basics-user-agent = Lukony Lutic kwede
app-basics-os = OS
app-basics-memory-use = Tic pa Lapo wic
app-basics-performance = Tic
app-basics-service-workers = Service Workers ma kicoyo
app-basics-profiles = Propwail
app-basics-multi-process-support = Dirica me tic mapol
app-basics-safe-mode = Kit maber
show-dir-label =
    { PLATFORM() ->
        [macos] Nyut i Gin manongo
        [windows] Yab Boc
       *[other] Yab Boc
    }
modified-key-prefs-title = Ter mapire tek ma kiyubu gi
modified-prefs-name = Nying
modified-prefs-value = Wel
user-js-title = user.js Ter
user-js-description = Boc me profile mamegi tye ki<a data-l10n-name="user-js-link">pwail me user.js</a>, ma tye ki ma imaro ma pe kicweyo ki { -brand-short-name }.
locked-key-prefs-title = Ter mapire tek ma kiloro gi
locked-prefs-name = Nying
locked-prefs-value = Wel
graphics-title = Cal
graphics-features-title = Jami
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Rikod pi moko tam
graphics-workarounds-title = Yoo me loyo ne
a11y-title = Kite me nongo
a11y-activated = Tye katic
a11y-force-disabled = Geng Donyo iye
library-version-title = Cik pa kagwoko jami
copy-text-to-clipboard-label = Lok coc i bao coc
copy-raw-data-to-clipboard-label = Lok data manumu i bao coc
sandbox-title = Lapok kin purugram
sandbox-sys-call-index = #
sandbox-sys-call-age = Ceken angec
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
safe-mode-title = Tem kit maber
restart-in-safe-mode-label = Cak odoco ma nongo kijuko med-ikome…

## Media titles

media-device-name = Nying

##

intl-locales-requested = Leb ma kipenyo pi gi
intl-locales-available = Leb matye
intl-locales-supported = Leb me purugram
intl-locales-default = Leb makwongo

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Ripot me poto pi nino { $days } mukato
       *[other] Ripot me poto pi nino { $days } mukato
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] dakika { $minutes } angec
       *[other] dakika { $minutes } angec
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] cawa { $hours } angec
       *[other] cawa { $hours } angec
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] nino { $days }angec
       *[other] nino { $days } angec
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Ripot me poto weng (medo ki poto { $reports } mapud tye i wang cawa ma kimiyo)
       *[other] Ripot me poto weng (medo ki poto { $reports } mapud tye i wang cawa ma kimiyo)
    }

raw-data-copied = Kiloko data ma numu i bao coc
text-copied = Kiloko coc i bao me coc

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Gigengo woko deribwa pi cik me cal mamegi.
blocked-gfx-card = Gigengo woko kad me cal mamegi pi kop pa deribwa mape kicobo.
blocked-os-version = Gigengo pi cik me kit tic mamegi.
blocked-mismatched-version = Kigengo woko pi kit pa deriba me cal mamegi mape rwate ikin registry ki DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Gigengo woko pi kit ladwor cal mamegi. Tem keto ngec manyen iye ladwor cal mamegi i cik { $driverVersion } onyo manyen ne.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType Paramita

yes = Eyo
no = Pe

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Kinongo
missing = Pe tye

gpu-description = Lok ikome
gpu-vendor-id = ID pa Lacat
gpu-device-id = ID me Jami tic
gpu-subsys-id = Subsys ID
gpu-ram = RAM
gpu-driver-version = Cik pa Deribwa
gpu-driver-date = Nino dwe pa Deribwa
gpu-active = Tye katic
blocklisted-bug = Kigengo pi peki ma ki ngeyo

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bal { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Kigengo woko; kod me poto { $failureCode }

d3d11video-crash-guard = Lagony Vidio D3D11
d3d9video-crash-guard = Lagony Vidio D3D9
glcontext-crash-guard = OpenGL

min-lib-versions = Cik me gwoko cik mamite
loaded-lib-versions = Gutye ka tic ki cik

has-seccomp-bpf = Seccomp-BPF (System Call Filtering)
has-seccomp-tsync = Seccomp Thread Synchronization
has-user-namespaces = Namespace pa lutic
has-privileged-user-namespaces = Namespace pa lutic pi twero me tic
can-sandbox-content = Poko kin gin manonge iye program
can-sandbox-media = Poko kin larwak me adyere
sandbox-proc-type-content = jami

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Latic kwede aye ocako
multi-process-status-1 = Kicako calo makwongo
multi-process-status-2 = Kijuko woko
multi-process-status-4 = Jami tic me kit me nongo aye ojuko
multi-process-status-6 = Coc ma pe kicwako aye ojuko
multi-process-status-7 = Med-ikome aye ojuko
multi-process-status-8 = Ki juko tektek
multi-process-status-unknown = Tye ne pe ngene

async-pan-zoom = Pan/Zoom mape time la kacel
apz-none = pe tye
wheel-enabled = kicako ket me wheel
touch-enabled = kicako ket me gud
drag-enabled = kicako ywac me lanyut ma wire

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = kijuko woko keto wheel mape time la kacel pi ter mape kicwako: { $preferenceKey }
touch-warning = kijuko woko keto me aguda mape time la kacel pi ter mape kicwako: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Pe tye katic
policies-active = Tye katic
policies-error = Bal
