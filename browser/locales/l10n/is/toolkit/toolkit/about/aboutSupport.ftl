# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Upplýsingar fyrir úrræðaleit
page-subtitle =   Þessi síða inniheldur tæknilegar upplýsingar sem gætu verið hjálplegar ef þú ert að reyna að leysa eitthvað vandamál. Ef þú ert að leita að svörum við algengum spurningum um { -brand-short-name }, athugaðu þá <a data-l10n-name="support-link">hjálparvefsvæðið okkar</a>.

crashes-title = Hrunskýrslur
crashes-id = Skýrslu auðkenni
crashes-send-date = Sent
crashes-all-reports = Allar hrunskýrslur
crashes-no-config = Ekki er búið að stilla þetta forrit til að birta hrunskýrslur.
extensions-title = Viðbætur
extensions-name = Nafn
extensions-enabled = Virk
extensions-version = Útgáfa
extensions-id = Auðkenni
support-addons-name = Nafn
support-addons-version = Útgáfa
support-addons-id = Auðkenni
security-software-title = Öryggishugbúnaður
security-software-type = Tegund
security-software-name = Nafn
security-software-antivirus = Vírusvörn
security-software-antispyware = Vírusvörn
security-software-firewall = Eldveggur
features-title = { -brand-short-name } eiginleikar
features-name = Nafn
features-version = Útgáfa
features-id = Auðkenni
processes-title = Fjarvinnslur
processes-type = Tegund
processes-count = Fjöldi
app-basics-title = Grunnupplýsingar forrits
app-basics-name = Nafn
app-basics-version = Útgáfa
app-basics-build-id = Byggingarauðkenni
app-basics-update-channel = Uppfærslurás
app-basics-update-history = Uppfærslusaga
app-basics-show-update-history = Sýna uppfærslusögu
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Notandamappa
       *[other] Notandamappa
    }
app-basics-enabled-plugins = Virk tengiforrit
app-basics-build-config = Smíð stillingar
app-basics-user-agent = Auðkenni forrits
app-basics-os = Stýrikerfi
app-basics-memory-use = Notað minni
app-basics-performance = Afköst
app-basics-service-workers = Skráðir Service Workers
app-basics-profiles = Notendur
app-basics-launcher-process-status = Ræsiferli
app-basics-multi-process-support = Margþráða gluggi
app-basics-remote-processes-count = Fjarvinnslur
app-basics-enterprise-policies = Stefna fyrirtækisins
app-basics-location-service-key-google = Google staðsetningarlykill
app-basics-safebrowsing-key-google = Google lykill fyrir örugga vöfrun
app-basics-key-mozilla = Mozilla Location Service lykill
app-basics-safe-mode = Öryggishamur
show-dir-label =
    { PLATFORM() ->
        [macos] Sýna í Finder
        [windows] Opna möppu
       *[other] Opna möppu
    }
modified-key-prefs-title = Mikilvægar breyttar stillingar
modified-prefs-name = Nafn
modified-prefs-value = Gildi
user-js-title = user.js stillingar
user-js-description = Notandamappan þín inniheldur <a data-l10n-name="user-js-link">user.js skrá</a>, sem inniheldur stillingar sem voru ekki búnar til af { -brand-short-name }.
locked-key-prefs-title = Mikilvægir læstir valkostir
locked-prefs-name = Nafn
locked-prefs-value = Gildi
graphics-title = Grafík
graphics-features-title = Eiginleikar
graphics-diagnostics-title = Greining
graphics-failure-log-title = Villu loggur
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Atburðaskrá fyrir ákvarðanir
graphics-crash-guards-title = Óvirkar stillingar fyrir hrunvara
graphics-workarounds-title = Leiðir framhjá villum
place-database-title = Gagnagrunnur fyrir staði
place-database-integrity = Áreiðanleiki
place-database-verify-integrity = Sannprófa áreiðanleika
a11y-title = Auðveldað aðgengi
a11y-activated = Virkt
a11y-force-disabled = Koma í veg fyrir aðgengi
a11y-handler-used = Aðgengishjálpari notaður
a11y-instantiator = Accessibility Instantiator
library-version-title = Útgáfa forritasafns
copy-text-to-clipboard-label = Afrita texta á klemmuspjald
copy-raw-data-to-clipboard-label = Afrita hrá gögn á klemmuspjald
sandbox-title = Sandbox
sandbox-sys-call-log-title = Hunsuð kerfisköll
sandbox-sys-call-index = #
sandbox-sys-call-age = Fyrir nokkrum sekúndum
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tegund ferlis
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Breytur
safe-mode-title = Prófaðu öryggisham
restart-in-safe-mode-label = Endurræsa með viðbætur óvirkar…

## Media titles

audio-backend = Hljóðkerfi
max-audio-channels = Hámarksfjöldi rása
sample-rate = Preferred Sample Rate
media-title = Gögn
media-output-devices-title = Útakstæki
media-input-devices-title = Inntakstæki
media-device-name = Nafn
media-device-group = Hópur
media-device-vendor = Hugbúnaðarsali
media-device-state = Staða
media-device-preferred = Kjörstilling
media-device-format = Snið
media-device-channels = Rásir
media-device-rate = Hraði
media-device-latency = Biðtími

##

intl-title = Alþjóðavæðing og þýðingar
intl-app-title = Stillingar forrits
intl-locales-requested = Umbeðin tungumál
intl-locales-available = Tiltæk tungumál
intl-locales-supported = Tungumál Apps
intl-locales-default = Sjálfgefið tungumál
intl-os-title = Stýrikerfi
intl-os-prefs-system-locales = Tungumál kerfis
intl-regional-prefs = Svæðisstillingar

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
        [one] Hrunskýrslur fyrir seinasta { $days } dag
       *[other] Hrunskýrslur fyrir seinustu { $days } daga
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } mínútu síðan
       *[other] { $minutes } mínútum síðan
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } klukkustund síðan
       *[other] { $hours } klukkustundum síðan
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } degi síðan
       *[other] { $days } dögum síðan
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Allar hrunskýrslur (einnig { $reports } hrunskýrsla í vinnslu á gefnum tíma)
       *[other] Allar hrunskýrslur (einnig { $reports } hrunskýrslur í vinnslu á gefnum tíma)
    }

raw-data-copied = Hrá gögn afrituð á klemmuspjald
text-copied = Texti afritaður á klemmuspjald

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Lokað á fyrir þína útgáfu af skjárekli.
blocked-gfx-card = Lokað á fyrir þitt skjákort vegna óleystra vandamála í skjárekli.
blocked-os-version = Lokað á fyrir þína stýrikerfisútgáfu.
blocked-mismatched-version = Útgáfumismunur á milli stýrisrkáar og DLL sem er fyrir Blocked fyrir myndrekil.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Lokað á fyrir þína útgáfu af skjárekli. Reyndu að uppfæra skjárekil yfir í útgáfu { $driverVersion } eða nýrri.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType breytur

compositing = Samsetning
hardware-h264 = H264 kóðun í vélbúnaði
main-thread-no-omtc = aðalþráður, ekkert OMTC
yes = Já
no = Nei
unknown = Óþekkt
virtual-monitor-disp = Sýndarskjár

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Fannst
missing = Vantar

gpu-process-pid = GPUVinnslaPid
gpu-process = GPUVinnsla
gpu-description = Lýsing
gpu-vendor-id = Auðkenni framleiðanda
gpu-device-id = Auðkenni tækis
gpu-subsys-id = Auðkenni Subsys
gpu-drivers = Reklar
gpu-ram = RAM
gpu-driver-version = Útgáfa rekils
gpu-driver-date = Dagsetning rekils
gpu-active = Virkt
webgl1-wsiinfo = Upplýsingar um WebGL 1 rekil WSI
webgl1-renderer = WebGL 1 myndrekill
webgl1-version = WebGL 1 útgáfa rekils
webgl1-driver-extensions = WebGL 1 reklaviðbætur
webgl1-extensions = WebGL 1 viðbætur
webgl2-wsiinfo = Upplýsingar um WebGL 2 rekil WSI
webgl2-renderer = WebGL 2 myndrekill
webgl2-version = WebGL 2 útgáfa rekils
webgl2-driver-extensions = WebGL 2 reklaviðbætur
webgl2-extensions = WebGL 2 viðbætur
blocklisted-bug = Á svörtum lista vegna þekktra vandamál

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = villa { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Á svörtum lista; villukóði { $failureCode }

d3d11layers-crash-guard = D3D11 Compositor
d3d11video-crash-guard = D3D11 Vídeó afkóðari
d3d9video-crash-guard = D3D9 Vídeó afkóðari
glcontext-crash-guard = OpenGL

reset-on-next-restart = Endurstilla í næstu endurræsingu
gpu-process-kill-button = Stöðva GPU ferli
gpu-device-reset = Endurstilla tæki
gpu-device-reset-button = Endurstilla tæki
uses-tiling = Notar flísar
content-uses-tiling = Notar flísar (innihald)
off-main-thread-paint-enabled = Litun fyrir utan aðalþráð virkt
off-main-thread-paint-worker-count = Fjöldi vinnsluþráða fyrir litun fyrir utan aðalþráð
target-frame-rate = Markhraði ramma

min-lib-versions = Bjóst við lágmarksútgáfu
loaded-lib-versions = Útgáfa í notkun

has-seccomp-bpf = Seccomp-BPF (System Call sía)
has-seccomp-tsync = Seccomp Þráða samstilling
has-user-namespaces = Nafnarými notanda
has-privileged-user-namespaces = Nafnarými notanda fyrir forgangsþræði
can-sandbox-content = Content Process Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Content Process Sandbox Level
effective-content-sandbox-level = Effective Content Process Sandbox Level
sandbox-proc-type-content = innihald
sandbox-proc-type-file = innihald skráar
sandbox-proc-type-media-plugin = miðils tengiforrit
sandbox-proc-type-data-decoder = gagnaafkóðari

launcher-process-status-0 = Virkt
launcher-process-status-1 = Óvirkt vegna óhapps
launcher-process-status-2 = Gert óvirkt með valdi
launcher-process-status-unknown = Óþekkt staða

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Virkjað af notanda
multi-process-status-1 = Sjálfgefið virkjað
multi-process-status-2 = Óvirkt
multi-process-status-4 = Gert óvirkt af auðveldað aðgengi
multi-process-status-6 = Gert óvirkt vegna texta inntaks sem er ekki með stuðning
multi-process-status-7 = Gert óvirkt af viðbótum
multi-process-status-8 = Gert óvirkt með valdi
multi-process-status-unknown = Óþekkt staða

async-pan-zoom = Ósamstillt Færa/Þysja
apz-none = ekkert
wheel-enabled = músa skrunhjól virkt
touch-enabled = snertiskjár virkur
drag-enabled = draga til flettistiku virk
keyboard-enabled = lyklaborð virkt
autoscroll-enabled = sjálfvirkt skrun virkjað

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = ósamstillt skrunhjól óvirkt vegna óstuddar stillingar: { $preferenceKey }
touch-warning = ósamstilltur snertiskjár óvirkur vegna óstuddar stillingar: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Óvirkt
policies-active = Virkt
policies-error = Villa
