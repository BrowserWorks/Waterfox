# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = მონაცემები გაუმართაობის მოსაგვარებლად
page-subtitle = ეს გვერდი შეიცავს ტექნიკურ მონაცემებს, რომლებიც შესაძლოა წარმოქმნილი ხარვეზის მოგვარებაში დაგეხმაროთ. თუ ხშირად დასმულ საკითხებზე ეძებთ პასუხს, რომლითაც შეგეძლებათ გამართოთ { -brand-short-name }, იხილეთ ჩვენი <a data-l10n-name="support-link">მხარდაჭერის გვერდი</a>.
crashes-title = უეცარი გათიშვების მოხსენებები
crashes-id = მოხსენების ID
crashes-send-date = გადაიგზავნა
crashes-all-reports = უეცარი გათიშვების ყველა მოხსენება
crashes-no-config = ეს პროგრამა უეცარი გათიშვების მოხსენებების საჩვენებლად არაა გამართული.
extensions-title = გაფართოებები
extensions-name = სახელი
extensions-enabled = ჩართულია
extensions-version = ვერსია
extensions-id = ID
support-addons-title = დამატებები
support-addons-name = სახელი
support-addons-type = სახეობა
support-addons-enabled = ჩართულია
support-addons-version = ვერსია
support-addons-id = ID
security-software-title = უსაფრთხოების დაცვის პროგრამა
security-software-type = სახეობა
security-software-name = სახელი
security-software-antivirus = ანტივირუსი
security-software-antispyware = ანტიჯაშუში
security-software-firewall = ქსელის ფარი
features-title = { -brand-short-name } – შესაძლებლობები
features-name = სახელი
features-version = ვერსია
features-id = ID
processes-title = დაშორებულად გაშვებული პროცესები
processes-type = სახეობა
processes-count = რაოდენობა
app-basics-title = პროგრამის ძირითადი მონაცემები
app-basics-name = სახელი
app-basics-version = ვერსია
app-basics-build-id = ანაწყობის ID
app-basics-distribution-id = განაწილების ID
app-basics-update-channel = განახლების არხი
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] განახლების მდებარეობა
       *[other] განახლების საქაღალდე
    }
app-basics-update-history = განახლების ისტორია
app-basics-show-update-history = განახლების ისტორიის ჩვენება
# Represents the path to the binary used to start the application.
app-basics-binary = პროგრამის ორობითი ფაილი
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] პროფილის საქაღალდე
       *[other] პროფილის საქაღალდე
    }
app-basics-enabled-plugins = ჩართული მოდულები
app-basics-build-config = ანაწყობის კონფიგურაცია
app-basics-user-agent = მომხმარებლის პროგრამა
app-basics-os = OS
app-basics-memory-use = გამოყენებული მეხსიერება
app-basics-performance = წარმადობა
app-basics-service-workers = დარეგისტრებული Service Worker-ები
app-basics-profiles = პროფილები
app-basics-launcher-process-status = გამშვები პროცესი
app-basics-multi-process-support = მრავალპროცესიანი ფანჯრები
app-basics-remote-processes-count = დაშორებულად გაშვებული პროცესები
app-basics-enterprise-policies = დებულებები კომპანიებისთვის
app-basics-location-service-key-google = Google Location Service-ის გასაღები
app-basics-safebrowsing-key-google = Google Safebrowsing-ის გასაღები
app-basics-key-mozilla = Mozilla მდებარეობის განსაზღვრის გასაღები
app-basics-safe-mode = უსაფრთხო რეჟიმი
show-dir-label =
    { PLATFORM() ->
        [macos] ჩვენება Finder-ში
        [windows] საქაღალდის გახსნა
       *[other] დირექტორიის გახსნა
    }
environment-variables-title = გარემოს ცვლადები
environment-variables-name = სახელი
environment-variables-value = მნიშვნელობა
experimental-features-title = საცდელი შესაძლებლობები
experimental-features-name = სახელი
experimental-features-value = მნიშვნელობა
modified-key-prefs-title = ჩასწორებული მნიშვნელოვანი პარამეტრები
modified-prefs-name = სახელი
modified-prefs-value = მნიშვნელობა
user-js-title = user.js პარამეტრები
user-js-description = თქვენი პროფილის საქაღალდე შეიცავს <a data-l10n-name="user-js-link">user.js ფაილს</a>, რომელიც ისეთ მითითებებს შეიცავს, რაც { -brand-short-name }-ს არ შეუქმნია.
locked-key-prefs-title = მნიშვნელოვანი ჩაკეტილი პარამეტრები
locked-prefs-name = სახელი
locked-prefs-value = მნიშვნელობა
graphics-title = გამოსახულებები
graphics-features-title = ფუნქციები
graphics-diagnostics-title = დიაგნოსტიკა
graphics-failure-log-title = აღრიცხული ხარვეზები
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = გადაწყვეტილებების ჩანაწერები
graphics-crash-guards-title = უეცარი გათიშვებისგან დაცვის მიერ გამორთული შესაძლებლობები
graphics-workarounds-title = შემოვლითი გზები
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = ფანჯრის ოქმი
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = სამუშაო მაგიდის გარსი
place-database-title = Places მონაცემთა ბაზა
place-database-integrity = მთლიანობა
place-database-verify-integrity = მთლიანობის გადამოწმება
a11y-title = დამხმარე საშუალებები
a11y-activated = მოქმედი
a11y-force-disabled = დამხმარე საშუალებების აკრძალვა
a11y-handler-used = გამოყენებულია ხელმისაწვდომი დამმუშავებელი
a11y-instantiator = დამხმარე საშუალებების უზრუნველყოფა
library-version-title = ბიბლიოთეკის ვერსიები
copy-text-to-clipboard-label = ტექსტის ასლის აღება
copy-raw-data-to-clipboard-label = ნედლი მონაცემების ასლის აღება
sandbox-title = განცალკევებული გარემო
sandbox-sys-call-log-title = სისტემის უარყოფილი გამოძახებები
sandbox-sys-call-index = #
sandbox-sys-call-age = წამის წინ
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = მიმდინარე მოქმედების სახე
sandbox-sys-call-number = სისტემური გამოძახება
sandbox-sys-call-args = არგუმენტები
safe-mode-title = სცადეთ უსაფრთხო რეჟიმი
restart-in-safe-mode-label = ხელახლა გაშვება გამორთული დამატებებით...
clear-startup-cache-title = სცადეთ გაშვების კეშის გასუფთავება
clear-startup-cache-label = გაშვების კეშის გასუფთავება…
startup-cache-dialog-title = გაშვების კეშის გასუფთავება
startup-cache-dialog-body = ხელახლა ჩართეთ { -brand-short-name } რომ გასუფთავდეს გაშვების დროებითი მონაცემები. ეს არ შეცვლის თქვენს პარამეტრებს და არ მოაცილებს გაფართოებებს, რომლებსაც იყენებს { -brand-short-name }.
restart-button-label = ხელახლა გაშვება

## Media titles

audio-backend = ხმის ქვესისტემა
max-audio-channels = არხების მაქსიმალური რაოდენობა
sample-rate = დისკრეტიზაციის სასურველი სიხშირე
roundtrip-latency = წრიული დაყოვნება (სტანდარტული გადახრა)
media-title = მედია
media-output-devices-title = გამოტანის მოწყობილობები
media-input-devices-title = შეტანის მოწყობილობები
media-device-name = სახელი
media-device-group = ჯგუფი
media-device-vendor = მწარმოებელი
media-device-state = მდგომარეობა
media-device-preferred = სასურველი
media-device-format = ფორმატი
media-device-channels = არხები
media-device-rate = სიხშირე
media-device-latency = დაყოვნება
media-capabilities-title = მასალის შესაძლებლობები
# List all the entries of the database.
media-capabilities-enumerate = მონაცემთა ბაზის გამოთვლა

##

intl-title = საერთაშორისოობა და ცალკეულ ენებზე მორგება
intl-app-title = პროგრამის პარამეტრები
intl-locales-requested = მოთხოვნილი ენები
intl-locales-available = ხელმისაწვდომი ენები
intl-locales-supported = პროგრამის ენები
intl-locales-default = ნაგულისხმევი ენა
intl-os-title = საოპერაციო სისტემა
intl-os-prefs-system-locales = სისტემის ენები
intl-regional-prefs = რეგიონალური პარამეტრები

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = დაშორებული გამართვა (Chromium-ოქმი)
remote-debugging-accepting-connections = კავშირების მიღება
remote-debugging-url = URL-ბმული

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] უეცარი გათიშვების მოხსენებები, ბოლო ერთ დღეში
       *[other] უეცარი გათიშვების მოხსენებები, ბოლო { $days } დღეში
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } წუთის წინ
       *[other] { $minutes } წუთის წინ
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } საათის წინ
       *[other] { $hours } საათის წინ
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } დღის წინ
       *[other] { $days } დღის წინ
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] უეცარი გათიშვების მოხსენებები (მათ შორის ერთი გასაგზავნად გამზადებული, მოცემული დროის შუალედში)
       *[other] უეცარი გათიშვების მოხსენებები (მათ შორის { $reports } გასაგზავნად გამზადებული, მოცემული დროის შუალედში)
    }
raw-data-copied = ნედლი მონაცემების ასლი აღებულია
text-copied = ტექსტის ასლი აღებულია

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = შეზღუდულია, თქვენი გრაფიკული დრაივერის ვერსიისთვის.
blocked-gfx-card = შეზღუდულია თქვენი გრაფიკული ბარათისთვის, დრაივერთან დაკავშირებული, აღმოუფხვრელი ხარვეზების გამო.
blocked-os-version = შეზღუდულია თქვენი საოპერაციო სისტემის ვერსიისთვის.
blocked-mismatched-version = შეზღუდულია თქვენი გრაფიკული დრაივერის ვერსიითვის, რეესტრის ჩანაწერისა და DLL ბიბლიოთეკის შეუსაბამობის გამო.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = შეზღუდულია თქვენი გრაფიკული დრაივერის ვერსიითვის. სცადეთ დრაივერის განახლება { $driverVersion } ან უფრო ახალ ვერსიამდე.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType პარამეტრები
compositing = გამოსახულების დამუშავება
hardware-h264 = აპარატურული H264 გაშიფვრა
main-thread-no-omtc = მთავარი ნაკადი, OMTC-ს გარეშე
yes = დიახ
no = არა
unknown = უცნობი
virtual-monitor-disp = წარმოსახვითი ეკრანის ჩვენება

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = მოძიებულია
missing = აკლია
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = აღწერა
gpu-vendor-id = მწარმოებლის ID
gpu-device-id = მოწყობილობის ID
gpu-subsys-id = ქვესისტემის ID
gpu-drivers = დრაივერები
gpu-ram = RAM
gpu-driver-vendor = დრაივერის გამომშვები
gpu-driver-version = დრაივერის ვერსია
gpu-driver-date = დრაივერის თარიღი
gpu-active = მოქმედი
webgl1-wsiinfo = WebGL 1 დრაივერის WSI მონაცემები
webgl1-renderer = WebGL 1 დრაივერის რენდერერი
webgl1-version = WebGL 1 დრაივერის ვერსია
webgl1-driver-extensions = WebGL 1 დრაივერის გაფართოებები
webgl1-extensions = WebGL 1 გაფართოებები
webgl2-wsiinfo = WebGL 2 დრაივერის WSI მონაცემები
webgl2-renderer = WebGL2 რენდერერი
webgl2-version = WebGL 2 დრაივერის ვერსია
webgl2-driver-extensions = WebGL 2 დრაივერის გაფართოებები
webgl2-extensions = WebGL 2 გაფართოებები
blocklisted-bug = დამატებულია შეზღუდულთა სიაში, ცნობილი ხარვეზების გამო
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = შეცდომა { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = შეზღუდულთა სიაშია, შემდეგი მიზეზის გამო: <a data-l10n-name="bug-link">ხარვეზი { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = დამატებულია შეზღუდულთა სიაში; შეცდომის კოდი { $failureCode }
d3d11layers-crash-guard = ასოთამწყობი D3D11
d3d11video-crash-guard = D3D11 ვიდეომშიფრავი
d3d9video-crash-guard = D3D9 ვიდეომშიფრავი
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX ვიდეოგამშიფრავი
reset-on-next-restart = ჩამოყრა მომდევნო ჩართვისას
gpu-process-kill-button = GPU პროცესის შეწყვეტა
gpu-device-reset = მოწყობილობის ხელახალი გამართვა
gpu-device-reset-button = მოწყობილობაზე პარამეტრების ჩამოყრის ამოქმედება
uses-tiling = მოზაიკურად
content-uses-tiling = მოზაიკურად (შიგთავსი)
off-main-thread-paint-enabled = გენერირება ძირითადი ნაკადის მიღმა, ჩართულია
off-main-thread-paint-worker-count = ძირითადი ნაკადის მიღმა გენერირების ათვლა
target-frame-rate = კადრის სასურველი სიხშირე
min-lib-versions = მოსალოდნელი მინიმალური ვერსია
loaded-lib-versions = მიმდინარე ვერსია
has-seccomp-bpf = Seccomp-BPF (სისტემური ზარების გაფილტვრა)
has-seccomp-tsync = Seccomp ნაკადის სინქრონიზაცია
has-user-namespaces = მომხმარებლის სახელის სივრცეები
has-privileged-user-namespaces = მომხმარებლის სახელის სივრცეები პრივილეგირებული პროცესებისთვის
can-sandbox-content = შიგთავსის პროცესის გამიჯვნა
can-sandbox-media = მედია მოდულის გამიჯვნა
content-sandbox-level = შიგთავსის პროცესის გამიჯვნის დონე
effective-content-sandbox-level = შიგთავსის პროცესის გამიჯვნის ეფექტიანი დონე
sandbox-proc-type-content = შიგთავსი
sandbox-proc-type-file = ფაილის შიგთავსი
sandbox-proc-type-media-plugin = მედიის მოდული
sandbox-proc-type-data-decoder = მონაცემთა გამშიფრავი
startup-cache-title = გაშვების კეში
startup-cache-disk-cache-path = დისკის დროებითი საცავის მისამართი
startup-cache-ignore-disk-cache = დისკის დროებითი საცავის უგულებელყოფა
startup-cache-found-disk-cache-on-init = ნაპოვნია დისკის დროებითი საცავი Init-ზე
startup-cache-wrote-to-disk-cache = ჩაწერილია დისკის დროებით საცავში
launcher-process-status-0 = ჩართულია
launcher-process-status-1 = გამორთულია ხარვეზის გამო
launcher-process-status-2 = გამორთულია ძალით
launcher-process-status-unknown = უცნობი მდგომარეობა
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = მომხმარებლის მიერ ჩართული
multi-process-status-1 = ნაგულისხმევად ჩართული
multi-process-status-2 = გამორთული
multi-process-status-4 = გამორთული დამხმარე საშუალებების მიერ
multi-process-status-6 = გამორთული მხარდაუჭერელი ტექსტ-შეყვანის მიერ
multi-process-status-7 = დამატებების მიერ გამორთული
multi-process-status-8 = იძულებით გამორთული
multi-process-status-unknown = უცნობი მდგომარეობა
async-pan-zoom = ასინქრონული პანორამირება/ზომის ცვლილება
apz-none = არაფერი
wheel-enabled = რგოლით შეყვანა ჩართულია
touch-enabled = შეხებით შეტანა ჩართულია
drag-enabled = გადაადგილების ზოლის გადატანა შესაძლებელია
keyboard-enabled = კლავიატურა ჩართულია
autoscroll-enabled = თვითგადაადგილება ჩართულია
zooming-enabled = ორი თითით გლუვი მოახლოება და დაშორება ჩართულია

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = თაგვის რგოლით შეტანილი ასინქრონული მონაცემი ბლოკირებულია, { $preferenceKey } პარამეტრის გამო, რომელიც არაა მხარდაჭერილი.
touch-warning = შეხებით ასინქრონული შეტანა გაუქმებულია, ვინაიდან მხარდაუჭერელია პარამეტრი: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = უმოქმედო
policies-active = მოქმედი
policies-error = შეცდომა
