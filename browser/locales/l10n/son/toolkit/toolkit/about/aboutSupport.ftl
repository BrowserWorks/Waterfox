# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Karkahattayan alhabar
page-subtitle = Moɲoo woo goo nda goyandi alhabar kaŋ ga hin ka bara nda nafaw waati kaŋ war ga ceeci ka fatta šenday ra. Nda war ga zaabiyaŋ ceeci war zaarikul hãayaney se { -brand-short-name } ga, ir <a data-l10n-name="support-link">faaba Interneti nungoo</a> guna.

crashes-title = Kaŋyan bayrandey
crashes-id = Bayrandi boŋtammaasa
crashes-send-date = Sanba han
crashes-all-reports = Kaŋyan bayrandikey kul
crashes-no-config = Porogaramoo mana hansandi to kaŋyan bayrandey cebe.
extensions-title = Dobuyaney
extensions-name = Maa
extensions-enabled = Tunante
extensions-version = Dumi
extensions-id = ID
support-addons-name = Maa
support-addons-version = Dumi
support-addons-id = ID
features-title = { -brand-short-name } alhaaley
features-name = Maa
features-version = Dumi
features-id = Boŋ-tammaasa
app-basics-title = Porogaram šintin hayey
app-basics-name = Maa
app-basics-version = Dumi
app-basics-build-id = Cinari tammaasa
app-basics-update-channel = Taagandiri kanaara
app-basics-update-history = Taariki taagandi
app-basics-show-update-history = Taariki taagandi cebe
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Fooloɲaa alhal
       *[other] Alhaali foolo
    }
app-basics-enabled-plugins = Sukari tunantey
app-basics-build-config = Cinari hanseyan
app-basics-user-agent = Goyteeri
app-basics-os = OS
app-basics-memory-use = Lakkal goy-alkadar
app-basics-performance = Teeyan sahã
app-basics-service-workers = Service Workers hantumantey
app-basics-profiles = Alhaaley
app-basics-multi-process-support = Goyboobo zanfuney
app-basics-key-mozilla = Mozilla gorodoo goy kufal
app-basics-safe-mode = Saajaw alhaali
show-dir-label =
    { PLATFORM() ->
        [macos] Cebe ceecikoy ra
        [windows] Foolo feeri
       *[other] Fooloɲaa feeri
    }
modified-key-prefs-title = Ibaayi barmayante šifanteyaŋ
modified-prefs-name = Maa
modified-prefs-value = Hinna
user-js-title = user.js ibaayey
user-js-description = War foolo alhaalo goo nda <a data-l10n-name="user-js-link">user.js file</a> kaŋ ra ibaayiyaŋ kaŋ { -brand-short-name } man'i tee.
locked-key-prefs-title = Ibaayi šifante kufalantey
locked-prefs-name = Maa
locked-prefs-value = Hinna
graphics-title = Bii takarey
graphics-features-title = Alhaaley
graphics-diagnostics-title = Malal korosiyan
graphics-failure-log-title = Kaŋyan zaaritiira
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Dabariyan zaaritiira
graphics-crash-guards-title = Kaŋyan hawgay alhaaley ši dira
graphics-workarounds-title = Šendaykuubiyan
place-database-title = Nungey bayrayhay hugu
place-database-integrity = Timmeyan
place-database-verify-integrity = Timmeyan koroši
a11y-title = Duwandiyan
a11y-activated = Dirante
a11y-force-disabled = Duuyan ganji
library-version-title = Tiirahugu dumey
copy-text-to-clipboard-label = Kalimaɲaa kuruI berandi deeji-walhaa ga
copy-raw-data-to-clipboard-label = Bayhaya ganey berandi deeji-walhaa ga
sandbox-title = Lalaba
sandbox-sys-call-index = #
sandbox-sys-call-age = A ga too kayna
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
safe-mode-title = Saajaw alhaali šii
restart-in-safe-mode-label = Tunandi taaga nda tontoni kayantey…

## Media titles

audio-backend = Jinde bendoo

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
        [one] Kaŋyan bayrandey jirbi kokorante { $days } se
       *[other] Kaŋyan bayrandey jirbi koraw { $days } se
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Za miniti { $minutes }
       *[other] Za miniti { $minutes }
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Za guuru { $hours }
       *[other] Za guuru { $hours }
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Za jirbi { $days }
       *[other] Za jirbi { $days }
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Kaŋyan bayrandey kul (nda kaŋyan maatante { $reports } waati dimma foo ra)
       *[other] Kaŋyan bayrandey kul (nda kaŋyan maatante { $reports } waati dimma foo ra)
    }

raw-data-copied = Bayhaya ganey berandi deeji-walhaa ga
text-copied = Kalimaɲaa kuru berandi deeji-walhaa ga

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Gagayandi war bii takari dirandikaw dumoo še.
blocked-gfx-card = Gagayandi war bii takari kattaa še zama dirandikaw šenday fooyaŋ cindi.
blocked-os-version = Gagayandi war goyandi dabariɲaa dumoo še.
blocked-mismatched-version = Gagayandi za war bii takari dirandikaa dumoo se jišidogoo nda DLL ši tenji.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Gagayandi war bii takari dirandikaa še. Ceeci ka bii takari dirandikaa taagandi nda { $driverVersion } dumoo wala itaaga tana.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType goy hansarey

compositing = Hantumyan
hardware-h264 = H264 jinay šenda feeriyan
main-thread-no-omtc = šilli boŋ, OMTC kul šii
yes = Ayyo
no = Kalaa

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

gpu-description = Šilbayyan
gpu-vendor-id = Neerekaw boŋ-šilbay
gpu-device-id = Jinay boŋ-šilbay
gpu-subsys-id = Dabariɲaa-cire tammaasa
gpu-drivers = Dirandikey
gpu-ram = RAM
gpu-driver-version = Jinay dirandikaw dumi
gpu-driver-date = Jinay dirandikaw han
gpu-active = Dirante
blocklisted-bug = Gagayandi mise bayanteyaŋ se

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = laybu { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Gagayante; kayyan ašariya { $failureCode }

d3d11layers-crash-guard = D3D11 teekaw
d3d11video-crash-guard = D3D11 widewo feerandikaw
d3d9video-crash-guard = D3D9 widewo feerandikaw
glcontext-crash-guard = OpenGL

reset-on-next-restart = Yeeti hiino tunandiyanoo ga
gpu-process-kill-button = GPU goyoo kayandi

min-lib-versions = Dumi naatante kul ikaccaa
loaded-lib-versions = Dumi goyante

has-seccomp-bpf = Seccomp-BPF (Dabariɲaa ciyari fayyan)
has-seccomp-tsync = Seccomp šilli cerehangandiyan
has-user-namespaces = Goykaw maafarrey
has-privileged-user-namespaces = Goykaw maafaarey fondo suubarey se
can-sandbox-content = Gundekuna koyjineyan lalabayan
can-sandbox-media = Hoorayjina sukari lalabayan
content-sandbox-level = Gundekuna koyjineyan Sandbox dimma

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Goykaa k'a tunandi
multi-process-status-1 = Kaŋ tunandi nda tilasu
multi-process-status-2 = Kayante
multi-process-status-4 = Duwandiyan goyjinawey k'a kayandi
multi-process-status-6 = Hantum damhaya bila nda faaba k'a kayandi
multi-process-status-7 = Tontoney k'a kayandi
multi-process-status-8 = A kay nda gaabi
multi-process-status-unknown = Alhaali šibayante

async-pan-zoom = Waani-waani bii tuti nda cendiyan
apz-none = baffoo
wheel-enabled = kanje damhaya tunandi
touch-enabled = maate damhaya tunandi
drag-enabled = cendizuu n' ka tunanndi

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = ganje howante damhaya ibaayi kaŋ ši nda kanbe sabbu ra: { $preferenceKey }
touch-warning = manyan howante damahay kay ibaayi kaŋ ši kanbe sabbu ra: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

