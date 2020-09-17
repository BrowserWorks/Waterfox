# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Inkcazelo yesisombululi-ngxaki
page-subtitle = Eli phepha liqulethe inkcazelo yobuchwepheshe enokuba luncedo xa uzama ukusombulula ingxaki. Ukuba ufuna iimpendulo kwimibuzo eqhelekileyo ye-{ -brand-short-name }, khangela kwisayithi yethu <a data-l10n-name="support-link">support website</a>.

crashes-title = Iingxelo zomonakalo
crashes-id = Isazisi sengxelo
crashes-send-date = Ithunyelwe
crashes-all-reports = Zonke iingxelo zokonakala
crashes-no-config = Le aplikeyishini ayilungiselelwanga ukubonisa iingxelo zokonakala.
extensions-title = Izandiso
extensions-name = Igama
extensions-enabled = Ezivunyelweyo
extensions-version = Uguqulelo
extensions-id = ID
support-addons-name = Igama
support-addons-version = Uguqulelo
support-addons-id = ID
app-basics-title = Iziseko zeaplikheshini
app-basics-name = Igama
app-basics-version = Uguqulelo
app-basics-build-id = Yakha i-ID
app-basics-update-channel = Hlaziya iTshaneli
app-basics-update-history = Imbali yohlaziyo
app-basics-show-update-history = Bonisa Imbali Ehlaziyiweyo
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Isalathiso seprofayile
       *[other] Ifolda yeprofayile
    }
app-basics-enabled-plugins = Isoftwe encedisayo evunyelweyo
app-basics-build-config = Yakha uLungiselelo
app-basics-user-agent = IArhente yomsebenzisi
app-basics-os = OS
app-basics-memory-use = Ukusetyenziswa kwememori
app-basics-performance = Ukusebenza
app-basics-service-workers = Abasebenzisi beNkonzo Ababhalisiweyo
app-basics-profiles = Iiprofayile
app-basics-multi-process-support = IWindows yeenkqubo ezininzi
app-basics-safe-mode = IMowudi Ekhuselekileyo
show-dir-label =
    { PLATFORM() ->
        [macos] Bonisa kwisifumanisi
        [windows] Vula iFolda
       *[other] Isalathiso esivulekileyo
    }
modified-key-prefs-title = Iipriferensi ezilungisiweyo ezibalulekileyo
modified-prefs-name = Igama
modified-prefs-value = Ixabiso
user-js-title = Iipriferensi ze-user.js
user-js-description = Ifolda yakho yeprofayile iqulethe ifayile <a data-l10n-name="user-js-link">user.js </a>, equlethe iipriferensi ezingenziwanga yi-{ -brand-short-name }.
locked-key-prefs-title = Iipriferensi ezitshixiweyo ezibalulekileyo
locked-prefs-name = Igama
locked-prefs-value = Ixabiso
graphics-title = Iigrafikhi
graphics-features-title = Iifitsha
graphics-diagnostics-title = Iidayagnostiki
graphics-failure-log-title = Isilele ukuLoga
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Ilogi Yesigqibo
graphics-crash-guards-title = Isilondolozi Sokukresha Siyekise Iifitsha
graphics-workarounds-title = Ukusebenza
place-database-title = Ibeka Oovimba
place-database-integrity = Intembeko
place-database-verify-integrity = Qinisekisa Intembeko
a11y-title = Ufikeleleko
a11y-activated = Ihlaziyiwe
a11y-force-disabled = Thintela ufikelelo
library-version-title = Iinguqulelo zelayibhrari
copy-text-to-clipboard-label = Khuphela umbhalo kwiklipbhodi
copy-raw-data-to-clipboard-label = Khuphela iingcombolo ezingahlelwanga kwiklipbhodi
sandbox-title = Ibhokisi yesanti
safe-mode-title = Zama iMo yokuSebenza eKhuselekileyo
restart-in-safe-mode-label = Qalisa kwakhona izongezelelo zenziwe azasebenza…

## Media titles

audio-backend = I-Audio Backend

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
        [one] Iingxelo zokonakala kolu Suku { $days } lugqithileyo
       *[other] iNgxelo zokonakala kwezu Ntsuku zi{ $days } zigqithileyo
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] umzuzu om-{ $minutes } ogqithileyo
       *[other] imizuzu e-{ $minutes } egqithileyo
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] iyure e{ $hours } egqithileyo
       *[other] iiyure ezi{ $hours } ezigqithileyo
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] usuku olu{ $days } olugqithileyo
       *[other] iintsuku ezi{ $days } ezigqithileyo
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Zonke iiNgxelo zoKonakala (kuquka ukonakala oku{ $reports } okusaseleyo kweli xesha)
       *[other] Zonke iiNgxelo zoKonakala (kuquka ukonakala oku{ $reports } okusaseleyo kweli xesha)
    }

raw-data-copied = Iingcombolo ezingahlelwanga zikhutshelwe kwiklipbhodi
text-copied = Umbhalo ukhutshelwe kwiklipbhodi

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Ithintelwe kwinguqulelo yedrayiva yeegrafikhi zakho.
blocked-gfx-card = Ithintelwe kwikhadi leegrafikhi zakho ngenxa yeemeko zedrayiva ezingasonjululwanga.
blocked-os-version = Ithintelwe kwinguqulelo yenkqubo yekhompyutha.
blocked-mismatched-version = Ithintelwe kwinguqulelo yedrayiva yeegrafikhi zakho okungafaniyo phakathi kwerejistri ne-DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Ithintelwe kwinguqulelo yedrayiva yeegrafikhi zakho. Zama ukuhlaziya idrayiva yeegrafikhi zakho kwinguqulelo { $driverVersion } okanye.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Iiparamitha zefonti ecacileyo

compositing = Ukuyila
hardware-h264 = Ihadwe H264 Isusa Ikhowudi
main-thread-no-omtc = Ithredi eyintloko, akukho OMTC
yes = Ewe
no = Hayi

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

gpu-description = Inkcazelo
gpu-vendor-id = I-Vendor ID
gpu-device-id = I-ID yesixhobo
gpu-subsys-id = I-ID ye-Subsys
gpu-drivers = Iidrayivazi
gpu-ram = i-RAM
gpu-driver-version = Inguqulelo yedrayiva
gpu-driver-date = Umhla wedrayiva
gpu-active = Esebenzayo
blocklisted-bug = Ibhlokiwe ngenxa yemiba eyaziwayo

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = ibhagi { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Ibhlokiwe, ikhowudi yokusilela { $failureCode }

d3d11layers-crash-guard = D3D11 Umyili
d3d11video-crash-guard = I-D3D11 Video Decoder
d3d9video-crash-guard = I-D3D9 Video Decoder
glcontext-crash-guard = I-OpenGL

reset-on-next-restart = Seta kwakhona Xa Uphinda Uqala
gpu-process-kill-button = Yekisa iNkqubo yeGPU

min-lib-versions = Inguqulelo encinane elindelekileyo
loaded-lib-versions = Inguqulelo esetyenziswayo

has-seccomp-bpf = Seccomp-BPF (System Call Filtering)
has-seccomp-tsync = Ungqamaniso lwe-Seccomp Thread
has-user-namespaces = Izithuba zamaGama oMsebenzisi
has-privileged-user-namespaces = Izithuba zamaGama oMsebenzisi ngeenkqubo eziselungelweni
can-sandbox-content = Inkqubo yesiqulatho yebhokisi yesanti
can-sandbox-media = Ukhuseleko olwahlula iinkqubo ezinesoftwe eyongeza ifitsha ethile yemidiya
content-sandbox-level = Umlinganiselo weNkqubo yeSiqulatho yeBhokisi yeSanti

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Ivulwe ngumsebenzisi
multi-process-status-1 = Ivulwe ngokuzenzekelayo
multi-process-status-2 = Yenziwe ukuba ingasebenzi
multi-process-status-4 = Iyekiswe zizixhobo zofikelelo
multi-process-status-6 = Iyekiswe lufakelo lweteksti engaxhaswayo
multi-process-status-7 = Iyekiswe zizongezelelo
multi-process-status-8 = Iyekiswe ngenkani
multi-process-status-unknown = Imo engaziwayo

async-pan-zoom = Asynchronous Pan/Zoom
apz-none = nakanye
wheel-enabled = ufakelo lwevili lwenziwe alwasebenza
touch-enabled = ufakelo lwe-touch lwenziwe alwasebenza
drag-enabled = utsalo lweskrolbha luvuliwe

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = ufakelo lwevili lwe-async lwenziwe alwasebenza ngenxa yento ekhethwayo engaxhaswayo: { $preferenceKey }
touch-warning = ufakelo lwe-touch lwe-async lwenziwe alwasebenza ngenxa yento ekhethwayo engaxhaswayo: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

