# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Fabhtcheartú
page-subtitle = Ar an leathanach seo tá eolas teicniúil a d'fhéadfadh a bheith úsáideach agus tú ag iarraidh fadhb a réiteach. Má tá freagraí á lorg agat ar cheisteanna coitianta maidir le { -brand-short-name }, féach ar ár <a data-l10n-name="support-link">suíomh tacaíochta</a>.

crashes-title = Tuairiscí Tuairteála
crashes-id = Aitheantas na Tuairisce
crashes-send-date = Seolta
crashes-all-reports = Gach Tuairisc Tuairteála
crashes-no-config = Ní raibh an feidhmchlár seo cumraithe le tuairiscí tuairteála a thaispeáint.
extensions-title = Eisínteachtaí
extensions-name = Ainm
extensions-enabled = Cumasaithe
extensions-version = Leagan
extensions-id = Aitheantas
support-addons-name = Ainm
support-addons-version = Leagan
support-addons-id = Aitheantas
features-title = Gnéithe { -brand-short-name }
features-name = Ainm
features-version = Leagan
features-id = Aitheantas
app-basics-title = Buntús an Fheidhmchláir
app-basics-name = Ainm
app-basics-version = Leagan
app-basics-build-id = Aitheantas Tógála
app-basics-update-channel = Nuashonraigh an Cainéal
app-basics-update-history = Stair na Nuashonruithe
app-basics-show-update-history = Taispeáin Stair na Nuashonruithe
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Comhadlann Phróifíle
       *[other] Fillteán Próifíle
    }
app-basics-enabled-plugins = Forlíontáin Chumasaithe
app-basics-build-config = Cumraíocht an Leagain
app-basics-user-agent = Gníomhaire Úsáideora
app-basics-os = CO
app-basics-memory-use = Úsáid Chuimhne
app-basics-performance = Feidhmíocht
app-basics-service-workers = Oibrithe Seirbhíse Cláraithe
app-basics-profiles = Próifílí
app-basics-multi-process-support = Fuinneoga Ilphróisis
app-basics-key-mozilla = Eochair Sheirbhís Geoshuite Mozilla
app-basics-safe-mode = Mód Slán
show-dir-label =
    { PLATFORM() ->
        [macos] Taispeáin san Aimsitheoir
        [windows] Oscail an Fillteán
       *[other] Oscail Comhadlann
    }
modified-key-prefs-title = Sainroghanna Tábhachtacha Athraithe
modified-prefs-name = Ainm
modified-prefs-value = Luach
user-js-title = Sainroghanna user.js
user-js-description = Tá <a data-l10n-name="user-js-link">comhad user.js</a> i do fhillteán próifíle, ina bhfuil sainroghanna nach raibh cruthaithe ag { -brand-short-name }.
locked-key-prefs-title = Sainroghanna Tábhachtacha Faoi Ghlas
locked-prefs-name = Ainm
locked-prefs-value = Luach
graphics-title = Grafaic
graphics-features-title = Gnéithe
graphics-diagnostics-title = Diagnóisic
graphics-failure-log-title = Logchomhad Clistí
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Logchomhad Cinntí
graphics-crash-guards-title = Gnéithe Díchumasaithe ag an gCosantóir Tuairteála
graphics-workarounds-title = Seifteanna
place-database-title = Bunachar Sonraí Áiteanna
place-database-integrity = Sláine
place-database-verify-integrity = Deimhnigh an tSláine
a11y-title = Inrochtaineacht
a11y-activated = Gníomhachtaithe
a11y-force-disabled = Coisc Inrochtaineacht
a11y-handler-used = Úsáideadh an Láimhseálaí Inrochtana
library-version-title = Leaganacha Leabharlann
copy-text-to-clipboard-label = Cóipeáil an téacs go dtí an ghearrthaisce
copy-raw-data-to-clipboard-label = Cóipeáil amhshonraí go dtí an ghearrthaisce
sandbox-title = Bosca gainimh
sandbox-sys-call-log-title = Glaonna Córais Diúltaithe
sandbox-sys-call-index = #
sandbox-sys-call-age = Soicind ó shin
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Cineál an Phróisis
sandbox-sys-call-number = Glao ar an gcóras
sandbox-sys-call-args = Argóintí
safe-mode-title = Bain triail as an Mód Slán
restart-in-safe-mode-label = Atosaigh gan aon bhreiseáin…

## Media titles

audio-backend = Inneall Fuaime

##


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
        [one] Tuairiscí Tuairteála sa { $days } lá is déanaí
        [two] Tuairiscí Tuairteála sa { $days } lá is déanaí
        [few] Tuairiscí Tuairteála sa { $days } lá is déanaí
        [many] Tuairiscí Tuairteála sa { $days } lá is déanaí
       *[other] Tuairiscí Tuairteála sa { $days } lá is déanaí
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } nóiméad ó shin
        [two] { $minutes } nóiméad ó shin
        [few] { $minutes } nóiméad ó shin
        [many] { $minutes } nóiméad ó shin
       *[other] { $minutes } nóiméad ó shin
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } uair ó shin
        [two] { $hours } uair ó shin
        [few] { $hours } huaire ó shin
        [many] { $hours } n-uaire ó shin
       *[other] { $hours } uair ó shin
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } lá ó shin
        [two] { $days } lá ó shin
        [few] { $days } lá ó shin
        [many] { $days } lá ó shin
       *[other] { $days } lá ó shin
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Gach Tuairisc Tuairteála (le { $reports } tuairt sa raon ama seo ar feitheamh)
        [two] Gach Tuairisc Tuairteála (le { $reports } thuairt sa raon ama seo ar feitheamh)
        [few] Gach Tuairisc Tuairteála (le { $reports } thuairt sa raon ama seo ar feitheamh)
        [many] Gach Tuairisc Tuairteála (le { $reports } dtuairt sa raon ama seo ar feitheamh)
       *[other] Gach Tuairisc Tuairteála (le { $reports } tuairt sa raon ama seo ar feitheamh)
    }

raw-data-copied = Cóipeáladh na hamhshonraí go dtí an ghearrthaisce
text-copied = Cóipeáladh an téacs go dtí an ghearrthaisce

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Chuir thiománaí do chárta grafaice cosc air.
blocked-gfx-card = Chuir tiománaí do chárta grafaice cosc air mar gheall ar fhadhbanna gan réiteach leis an tiománaí.
blocked-os-version = Níl sé ar fáil ar do chóras oibriúcháin.
blocked-mismatched-version = Coiscthe do do thiománaí grafaice: ní ionann an leagan sa chlárlann agus leagan an DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Chuir thiománaí do chárta grafaice cosc air. Bain triail as leagan { $driverVersion } nó níos nuaí den tiománaí.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Paraiméadair ClearType

compositing = Cumasc
hardware-h264 = Díchódú Crua-Earraí H264
main-thread-no-omtc = príomhshnáithe, gan OMTC
yes = Tá
no = Níl

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Aimsithe
missing = Ar iarraidh

gpu-description = Cur Síos
gpu-vendor-id = Aitheantas an tSoláthraí
gpu-device-id = Aitheantas Gléis
gpu-subsys-id = Aitheantas Fochórais
gpu-drivers = Tiománaithe
gpu-ram = RAM
gpu-driver-version = Leagan an Tiománaí
gpu-driver-date = Dáta an Tiománaí
gpu-active = Gníomhach
webgl1-wsiinfo = Eolas WSI an Tiománaí WebGL 1
webgl1-renderer = Rindreálaí an Tiománaí WebGL 1
webgl1-version = Leagan an Tiománaí WebGL 1
webgl1-driver-extensions = Eisínteachtaí an Tiománaí WebGL 1
webgl1-extensions = Eisínteachtaí WebGL 1
webgl2-wsiinfo = Eolas WSI an Tiománaí WebGL 2
webgl2-renderer = Rindreálaí an Tiománaí WebGL 2
webgl2-version = Leagan an Tiománaí WebGL 2
webgl2-driver-extensions = Eisínteachtaí an Tiománaí WebGL 2
webgl2-extensions = Eisínteachtaí WebGL 2
blocklisted-bug = Ar an liosta blocála mar gheall ar fhadhbanna atá ar eolas

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = fabht { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Ar an liosta blocála; cód teipthe { $failureCode }

d3d11layers-crash-guard = Eagraí D3D11
d3d11video-crash-guard = Díchódóir Físe D3D11
d3d9video-crash-guard = Díchódóir Físe D3D9
glcontext-crash-guard = OpenGL

reset-on-next-restart = Athshocrú ar an chéad atosú eile
gpu-process-kill-button = Cuir deireadh le próiseas GPU
gpu-device-reset-button = Cuir tús le hatosú an ghléis

min-lib-versions = Leagan is sine a rabhthas ag súil leis
loaded-lib-versions = Leagan in úsáid

has-seccomp-bpf = Seccomp-BPF (Scagadh Glaonna Córais)
has-seccomp-tsync = Sioncronú Snáitheanna Seccomp
has-user-namespaces = Ainmspásanna Úsáideora
has-privileged-user-namespaces = Ainmspásanna Úsáideora do phróisis phribhléideacha
can-sandbox-content = Próiseas Ábhair i mBosca Gainimh
can-sandbox-media = Forlíontán Meán i mBosca Gainimh
content-sandbox-level = Leibhéal Bosca Gainimh don Phróiseas Ábhair
effective-content-sandbox-level = Fíorleibhéal Bosca Gainimh don Phróiseas Ábhair
sandbox-proc-type-content = ábhar
sandbox-proc-type-media-plugin = forlíontán meáin

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Chumasaigh úsáideoir é seo
multi-process-status-1 = Cumasaithe mar réamhshocrú
multi-process-status-2 = Díchumasaithe
multi-process-status-4 = Dhíchumasaithe trí uirlisí rochtana
multi-process-status-6 = Díchumasaithe de bharr ionchur téacs gan tacaíocht
multi-process-status-7 = Díchumasaithe trí bhreiseáin
multi-process-status-8 = Díchumasaithe le lámh láidir
multi-process-status-unknown = Stádas anaithnid

async-pan-zoom = Peanáil/Zúmáil Aisioncronach
apz-none = faic
wheel-enabled = ionchur rotha cumasaithe
touch-enabled = ionchur tadhaill cumasaithe
drag-enabled = tarraingt an scrollbharra cumasaithe
keyboard-enabled = méarchlár cumasaithe

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = díchumasaíodh ionchur rotha aisioncronach mar gheall ar shainrogha gan tacaíocht: { $preferenceKey }
touch-warning = díchumasaíodh ionchur tadhaill aisioncronach mar gheall ar shainrogha gan tacaíocht: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

