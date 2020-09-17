# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Problēmu novēršanas informācija
page-subtitle = Šī lapa satur tehnisku informāciju, kas var būt noderīga, mēģinot novērst problēmu. Ja meklējat atbildes uz vienkāršiem jautājumiem par { -brand-short-name }, aplūkojiet mūsu <a data-l10n-name="support-link">atbalsta mājas lapu</a>.

crashes-title = Avārijas ziņojumi
crashes-id = Ziņojuma ID
crashes-send-date = Nosūtīts
crashes-all-reports = Visi avārijas ziņojumi
crashes-no-config = Šī aplikācija nav nokonfigurēta avārijas ziņojumu attēlošanai.
extensions-title = Papildinājumi
extensions-name = Nosaukums
extensions-enabled = Ieslēgts
extensions-version = Versija
extensions-id = ID
support-addons-name = Nosaukums
support-addons-version = Versija
support-addons-id = ID
security-software-title = Drošības programmatūra
security-software-type = Tips
security-software-name = Nosaukums
security-software-antivirus = Pretvīrusu aizsardzība
security-software-antispyware = Pretspiegprogrammatūra
security-software-firewall = Ugunsmūris
features-title = { -brand-short-name } iespējas
features-name = Nosaukums
features-version = Versija
features-id = ID
app-basics-title = Programmas pamatinformācija
app-basics-name = Nosaukums
app-basics-version = Versija
app-basics-build-id = Būvējuma ID
app-basics-update-channel = Atjauninājumu kanāls
app-basics-update-history = Atjauninājumu vēsture
app-basics-show-update-history = Parādīt atjauninājumu vēsturi
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profila direktorija
       *[other] Profila mape
    }
app-basics-enabled-plugins = Aktivizētie spraudņi
app-basics-build-config = Būvējuma konfigurācija
app-basics-user-agent = Lietotāja aģents
app-basics-os = OS
app-basics-memory-use = Atmiņas izmantojums
app-basics-performance = Veiktspēja
app-basics-service-workers = Reģistrētie pakalpojumu darbinieki
app-basics-profiles = Profili
app-basics-multi-process-support = Vairāku procesu logs
app-basics-enterprise-policies = Uzņēmuma politikas
app-basics-key-mozilla = Mozilla atrašanās vietas pakalpojuma atslēga
app-basics-safe-mode = Drošais režīms
show-dir-label =
    { PLATFORM() ->
        [macos] Rādīt ar Finder
        [windows] Atvērt mapi
       *[other] Atvērt mapi
    }
modified-key-prefs-title = Svarīgie modificētie iestatījumi
modified-prefs-name = Nosaukums
modified-prefs-value = Vērtība
user-js-title = user.js iestatījumi
user-js-description = Jūsu profila mapē atrodas <a data-l10n-name="user-js-link">user.js fails</a>, kas satur iestatījumus, ko nav izveidojis { -brand-short-name }.
locked-key-prefs-title = Svarīgi bloķētie iestatījumi
locked-prefs-name = Nosaukums
locked-prefs-value = Vērtība
graphics-title = Grafika
graphics-features-title = Iespējas
graphics-diagnostics-title = Diagnostika
graphics-failure-log-title = Avāriju žurnāls
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Lēmumu žurnāls
graphics-crash-guards-title = Avāriju aizsardzības deaktivētās iespējas
graphics-workarounds-title = Pagaidu risinājumi
place-database-title = Vietu datubāze
place-database-integrity = Integritāte
place-database-verify-integrity = Pārbaudīt integritāti
a11y-title = Pieejamība
a11y-activated = Aktivizēta
a11y-force-disabled = Neatļaut pieejamību
a11y-handler-used = Izmantots pieejamības rīks
a11y-instantiator = Pieejamības indikators
library-version-title = Bibliotēkas versijas
copy-text-to-clipboard-label = Kopēt tekstu atmiņā
copy-raw-data-to-clipboard-label = Kopēt datus atmiņā
sandbox-title = Ierobežošana
sandbox-sys-call-log-title = Noraidītie sistēmas izsaukumi
sandbox-sys-call-index = #
sandbox-sys-call-age = Pirms pirkļa
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Procesa tipa
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumenti
safe-mode-title = Izmēģini drošo režīmu
restart-in-safe-mode-label = Pārstartēt ar deaktivētiem papildinājumiem…

## Media titles

audio-backend = Skaņas Backend
max-audio-channels = Maksimālie kanāli
sample-rate = Vēlamais kadra ātrums
media-title = Multimēdijas
media-output-devices-title = Izvades ierīces
media-input-devices-title = Ievades ierīces
media-device-name = Nosaukums
media-device-group = Grupa
media-device-vendor = Ražotājs
media-device-state = Stāvoklis
media-device-preferred = Vēlamais
media-device-format = Formāts
media-device-channels = Kanāli
media-device-rate = Ātrums
media-device-latency = Aizture

##

intl-title = Internacionalizācija un lokalizācija
intl-app-title = Programmatūras iestatījumi
intl-locales-requested = Pieprasītais valodas
intl-locales-available = Pieejamās valodas
intl-locales-supported = Lietotnes valodas
intl-locales-default = Noklusētā valoda
intl-os-title = Operētājsisēma
intl-os-prefs-system-locales = Sistēmas valodas
intl-regional-prefs = Reģiona iesatījumi

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
        [zero] Pēdējās { $days } dienas avārijas ziņojumi
        [one] Pēdējo { $days } dienu avārijas ziņojumi
       *[other] Pēdējo { $days } dienu avārijas ziņojumi
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [zero] pirms { $minutes } minūtes
        [one] pirms { $minutes } minūtēm
       *[other] pirms { $minutes } minūtēm
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [zero] pirms { $hours } stundas
        [one] pirms { $hours } stundām
       *[other] pirms { $hours } stundām
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [zero] pirms { $days } dienām
        [one] pirms { $days } dienas
       *[other] pirms { $days } dienām
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [zero] Visi avārijas ziņojumi (ieskaitot { $reports } nenosūtītu avārijas ziņojumu norādītajā laika intervālā)
        [one] Visi avārijas ziņojumi (ieskaitot { $reports } nenosūtītus avārijas ziņojumus norādītajā laika intervālā)
       *[other] Visi avārijas ziņojumi (ieskaitot { $reports } nenosūtītus avārijas ziņojumus norādītajā laika intervālā)
    }

raw-data-copied = Dati nokopēti atmiņā
text-copied = Teksts nokopēts atmiņā

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloķēts jūsu videokartes draivera versijai.
blocked-gfx-card = Bloķēts jūsu videokartei neatrisinātu draiveru problēmu dēļ.
blocked-os-version = Bloķēts jūsu operētājsistēmas versijai.
blocked-mismatched-version = Bloķēts jūsu grafiskā draivera versijas atšķirībai starp reģistru un DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloķēts jūsu videokartei. Mēģiniet atjaunināt videokartes draiveri uz versiju { $driverVersion } vai jaunāku.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType parametri

compositing = Kompozicionēšana
hardware-h264 = Aparatūras H264 kodēšana
main-thread-no-omtc = galvenais pavediens, nav OMTC
yes = Jā
no = Nē

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Atrasts
missing = Trūkst

gpu-description = Apraksts
gpu-vendor-id = Ražotāja ID
gpu-device-id = Ierīces ID
gpu-subsys-id = Subsys ID
gpu-drivers = Draiveri
gpu-ram = Atmiņa
gpu-driver-version = Draivera versija
gpu-driver-date = Draivera datums
gpu-active = Aktīvs
webgl1-wsiinfo = WebGL 1 draivera WSI info
webgl1-renderer = WebGL 1 draivera renderētājs
webgl1-version = WebGL 1 draivera versija
webgl1-driver-extensions = WebGL 1 draivera paplašinājumi
webgl1-extensions = WebGL 1 paplašinājumi
webgl2-wsiinfo = WebGL 2 draivera WSI info
webgl2-renderer = WebGL2 Renderer
webgl2-version = WebGL 2 draivera versija
webgl2-driver-extensions = WebGL 2 draivera paplašinājumi
webgl2-extensions = WebGL 2 paplašinājumi
blocklisted-bug = Bloķēts zināmu kļūdu dēļ

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = kļūda { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Bloķēts; kļūdas kods { $failureCode }

d3d11layers-crash-guard = D3D11 kompozitors
d3d11video-crash-guard = D3D11 Video dekoderis
d3d9video-crash-guard = D3D11 Video dekoderis
glcontext-crash-guard = OpenGL

reset-on-next-restart = Atjaunot nākamajā pārstartēšanā
gpu-process-kill-button = Pārtraukt GPU procesu
gpu-device-reset-button = Izraisīt ierīces atiestatīšanu
uses-tiling = Izmanto grupēšanu
content-uses-tiling = Izmanto virsrakstošanu (saturs)
off-main-thread-paint-enabled = Aktivēta zīmēšana ne galvenajā pavedienā
off-main-thread-paint-worker-count = Ne galvenajā pavedienā zīmējošo darbinieku skaits

min-lib-versions = Gaidītā minimālā versija
loaded-lib-versions = Izmantotā versija

has-seccomp-bpf = Seccomp-BPF (Sistēmas izsaukumu filtrešana)
has-seccomp-tsync = Seccomp pavedienu sinhronizēšana
has-user-namespaces = Lietotāju vārdtelpas
has-privileged-user-namespaces = Priviliģēto procesu lietotāju vārdtelpas
can-sandbox-content = Satura apstrādes ierobešošana
can-sandbox-media = Mediju spraudņu ierobežošana
content-sandbox-level = Satura procesa ierobežošanas līmenis
effective-content-sandbox-level = Efektīvs satura procesa ierobežošanas līmenis
sandbox-proc-type-content = saturs
sandbox-proc-type-file = faila saturs
sandbox-proc-type-media-plugin = multivides spraudnis

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Lietotāja aktivēts
multi-process-status-1 = Aktivēts pēc noklusējuma
multi-process-status-2 = Deaktivēts
multi-process-status-4 = Pieejamības rīku deaktivēts
multi-process-status-6 = Deaktivēts neatbalstīta teksta ievades dēļ
multi-process-status-7 = Papildinājumu deaktivēts
multi-process-status-8 = Deaktivēts piespiedu kārtā
multi-process-status-unknown = Nezināms statuss

async-pan-zoom = Asinhronā pietuvināšana/palielināšana
apz-none = nav
wheel-enabled = ripas ievade aktivēta
touch-enabled = skāriena ievade aktivēta
drag-enabled = ritjoslas vilkšana aktivēta
keyboard-enabled = klaviatūra aktivēta
autoscroll-enabled = automātiskā ritināšana aktivēta

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = asinhronā ripas ievade deaktivēta neatbalstīta iestatījuma dēļ: { $preferenceKey }
touch-warning = asinhronā pieskāriena ievade deaktivēta neatbalstīta iestatījuma dēļ: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Neaktīva
policies-active = Aktīva
policies-error = Kļūda
