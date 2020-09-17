# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = সমস্যার সমাধান সংক্রান্ত তথ্য
page-subtitle = এ পাতায় প্রযুক্তিগত তথ্য আছে যা সমস্যা সমাধানের সময় আপনার জন্য উপকারী হতে পারে। আপনি যদি { -brand-short-name } সম্পর্কিত কোনো সাধারণ প্রশ্নের উত্তর খুঁজতে থাকেন তবে, আমাদের <a data-l10n-name="support-link"> সাপোর্ট ওয়েব সাইট পরীক্ষা করে দেখেন</a>।

crashes-title = ক্র্যাশ প্রতিবেদন
crashes-id = প্রতিবেদন আইডি
crashes-send-date = প্রেরিত
crashes-all-reports = সমস্ত ক্র্যাশ রিপোর্ট
crashes-no-config = এই এপ্লিকেশনটি ক্র্যাশ রিপোর্ট প্রদর্শন এর জন্য কনফিগার করা হয় নি।
extensions-title = এক্সটেনশন
extensions-name = নাম
extensions-enabled = সক্রিয়
extensions-version = সংস্করণ
extensions-id = ID
support-addons-name = নাম
support-addons-version = সংস্করণ
support-addons-id = ID
security-software-title = নিরাপত্তার সফটওয়্যার
security-software-type = ধরণ
security-software-name = নাম
security-software-antivirus = এন্টিভাইরাস
security-software-antispyware = এন্টিস্পাইওয়্যার
security-software-firewall = ফায়ারওয়াল
features-title = { -brand-short-name } বৈশিষ্ট্যসমূহ
features-name = নাম
features-version = সংস্করণ
features-id = ID
processes-title = দূরবর্তী প্রক্রিয়া
processes-type = ধরণ
processes-count = গণনা
app-basics-title = অ্যাপ্লিকেশনের প্রাথমিক তথ্য
app-basics-name = নাম
app-basics-version = সংস্করণ
app-basics-build-id = বিল্ড ID
app-basics-update-channel = হালনাগাদ চ্যানেলে
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] directory হালনাগাদ
       *[other] folder হালনাগাদ
    }
app-basics-update-history = হালনাগাদের ইতিহাস
app-basics-show-update-history = হালনাগাদের ইতিহাস প্রদর্শন
# Represents the path to the binary used to start the application.
app-basics-binary = বাইনারি এপ্লিকেশন
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] প্রোফাইল ডিরেক্টরি
       *[other] প্রোফাইল ফোল্ডার
    }
app-basics-enabled-plugins = সক্রিয় প্লাগইন
app-basics-build-config = বিল্ড কনফিগারেশন
app-basics-user-agent = ব্যবহারকারী এজেন্ট
app-basics-os = OS
app-basics-memory-use = মেমোরির ব্যবহার
app-basics-performance = কার্যকারিতা
app-basics-service-workers = নিবন্ধিত সার্ভিস কর্মীরা
app-basics-profiles = প্রোফাইল
app-basics-launcher-process-status = লঞ্চার প্রক্রিয়া
app-basics-multi-process-support = মাল্টিপ্রসেস উইন্ডো
app-basics-remote-processes-count = দূরবর্তী প্রক্রিয়া
app-basics-enterprise-policies = এন্ট্রারপ্রাইজ নীতিগুলি
app-basics-location-service-key-google = Google অবস্থান পরিষেবা কী
app-basics-safebrowsing-key-google = Google নিরাপদ ব্রাউজিং কী
app-basics-key-mozilla = Mozilla লোকেশন সার্ভিস Key
app-basics-safe-mode = সেফ মোড
show-dir-label =
    { PLATFORM() ->
        [macos] ফাইন্ডারে প্রদর্শন
        [windows] ফোল্ডার খুলুন
       *[other] ডিরেক্টরি খুলুন
    }
modified-key-prefs-title = গুরুত্বপূর্ণ পরিবর্তিত পছন্দসমূহ
modified-prefs-name = নাম
modified-prefs-value = মান
user-js-title = user.js পছন্দসমূহ
user-js-description = আপনার প্রোফাইল ফোল্ডারে একটি <a data-l10n-name="user-js-link"> user.js ফাইল রয়েছে</a>, যাতে { -brand-short-name } কর্তৃক তৈরিকৃত নয় এমন পছন্দসমূহ অর্ন্তভূক্ত।
locked-key-prefs-title = গুরুত্বপূর্ণ অবরুদ্ধ পছন্দসমূহ
locked-prefs-name = নাম
locked-prefs-value = মান
graphics-title = গ্রাফিক্স
graphics-features-title = বৈশিষ্ট্যসমূহ
graphics-diagnostics-title = সমস্যা নির্নয়ক
graphics-failure-log-title = ব্যর্থ হওয়ার লগ
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = সিদ্ধান্ত লগ
graphics-crash-guards-title = Crash Guard নিষ্ক্রিয় বৈশিষ্ট্য
graphics-workarounds-title = কাজ করা হবে
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = উইন্ডো প্রোটোকল
place-database-title = স্থান ডাটাবেজ
place-database-integrity = বিশুদ্ধতা
place-database-verify-integrity = বিশুদ্ধতা যাচাই
a11y-title = অভিগম্যতা
a11y-activated = সক্রিয়
a11y-force-disabled = অভিগম্যতা প্রতিরোধ
a11y-handler-used = অ্যাক্সেসিবল হ্যান্ডলার ইউসড
a11y-instantiator = অ্যাক্সেসিবিলিটি ইন্সট্যানশিয়েটর
library-version-title = লাইব্রেরী সংস্করণসমূহ
copy-text-to-clipboard-label = ক্লিপবোর্ডে সব অনুলিপি করুন
copy-raw-data-to-clipboard-label = ক্লিপবোর্ডে অবিন্যস্ত ডাটা অনুলিপি করুন
sandbox-title = স্যান্ডবক্স
sandbox-sys-call-log-title = প্রত্যাখ্যাত সিস্টেম কল
sandbox-sys-call-index = #
sandbox-sys-call-age = সেকেন্ড আগে
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = প্রক্রিয়া প্রকার
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = আর্গুমেন্ট
safe-mode-title = সুরক্ষিত মোডে চেষ্টা করুন
restart-in-safe-mode-label = অ্যাড-অন নিস্ক্রিয় করে রিস্টার্ট করুন…

## Media titles

audio-backend = অডিও ব্যাক-এন্ড
max-audio-channels = ম্যাক্স চ্যানেল
sample-rate = পছন্দের নমুনা হার
media-title = মিডিয়া
media-output-devices-title = আউটপুট ডিভাইস
media-input-devices-title = ইনপুট ডিভাইস
media-device-name = নাম
media-device-group = দল
media-device-vendor = বিক্রেতা
media-device-state = অবস্থা
media-device-preferred = অধিকতর পছন্দ
media-device-format = ফরম্যাট
media-device-channels = চ্যানেল
media-device-rate = মূল্যায়ন করুন
media-device-latency = যোজনী
media-capabilities-title = মিডিয়ার ক্ষমতা
# List all the entries of the database.
media-capabilities-enumerate = ডাটাবেইজ তালিকাভুক্তি

##

intl-title = আন্তর্জাতিকিকরণ & স্থানীয়করণ
intl-app-title = অ্যাপ্লিকেশন সেটিং
intl-locales-requested = অনুরোধকৃত লোকেলগুলি
intl-locales-available = উপলব্ধ লোকেলগুলি
intl-locales-supported = অ্যাপ লোকেলস
intl-locales-default = ডিফল্ট লোকেল
intl-os-title = অপারেটিং সিস্টেম
intl-os-prefs-system-locales = সিস্টেম লোকেল
intl-regional-prefs = আঞ্চলিক পছন্দসমূহ

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = রিমোট ডিবাগিং (ক্রোমিয়াম প্রোটোকল)
remote-debugging-accepting-connections = সংযোগ গ্রহণ করা হচ্ছে
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] সর্বশেষ { $days } দিনের ক্র্যাশ রিপোর্ট
       *[other] সর্বশেষ { $days } দিনের ক্র্যাশ রিপোর্ট
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } মিনিট পূর্বে
       *[other] { $minutes } মিনিট পূর্বে
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } ঘন্টা পূর্বে
       *[other] { $hours } ঘন্টা পূর্বে
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } দিন পূর্বে
       *[other] { $days } দিন পূর্বে
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] সকল ক্র্যাশ রিপোর্ট (প্রদান করা সময়ের মধ্যে { $reports } টি অমীমাংসিত ক্র্যাশ সহ)
       *[other] সকল ক্র্যাশ রিপোর্ট (প্রদান করা সময়ের মধ্যে { $reports } টি অমীমাংসিত ক্র্যাশ সহ)
    }

raw-data-copied = অবিন্যস্ত ডাটা ক্লিপবোর্ডে অনুলিপি করা হয়েছে
text-copied = টেক্সট ক্লিপবোর্ডে অনুলিপি করা হয়েছে

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = আপনার গ্রাফিক্স ড্রাইভার সংস্করণের জন্য ব্লক করুন।
blocked-gfx-card = অমিমাংসিত ড্রাইভার বিষয়ের কারণে আপনার গ্রফিক্সকার্ড ব্লক করা হয়েছে।
blocked-os-version = আপনার অপারেটিং সিস্টেম সংস্করণের জন্য ব্লক করা হয়েছে।
blocked-mismatched-version = রেজিস্ট্রি এবং DLL এর মধ্যে আপনার গ্রাফিক্স ড্রাইভারের সংস্করণ মেলেনি তাই অবরুদ্ধ হয়েছে।
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = আপনার গ্রাফিক্স ড্রাইভার সংস্করণের জন্য ব্লক করুন। সংস্করণের { $driverVersion } অথবা আরও নতুন সংস্করণে আপনার গ্রাফিক্স ড্রাইভার হালনাগাদ করার চেষ্টা করুন।

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType স্থিতিমাপসমূহ

compositing = কম্পোজিটিং
hardware-h264 = H264 হার্ডওয়্যার ডিকোডিং
main-thread-no-omtc = মূল থ্রেড, OMTC নাই
yes = হ্যাঁ
no = না
unknown = অজানা
virtual-monitor-disp = ভার্চুয়াল মনিটর প্রদর্শন

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = পাওয়া গেছে
missing = নিখোঁজ

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = বিবরণ
gpu-vendor-id = ভেন্ডর ID
gpu-device-id = ডিভাইস ID
gpu-subsys-id = Subsys ID
gpu-drivers = ড্রাইভার
gpu-ram = RAM
gpu-driver-vendor = ড্রাইভার বিক্রেতা
gpu-driver-version = ড্রাইভার সংস্করণ
gpu-driver-date = ড্রাইভারের তারিখ
gpu-active = সক্রিয়
webgl1-wsiinfo = WebGL 1 ড্রাইভার WSI তথ্য
webgl1-renderer = WebGL 1 ড্রাইভার Renderer
webgl1-version = WebGL 1 ড্রাইভার সংষ্করণ
webgl1-driver-extensions = WebGL 1 ড্রাইভার এক্সটেনসন
webgl1-extensions = WebGL 1 এক্সটেনসন
webgl2-wsiinfo = WebGL 2 ড্রাইভার WSI তথ্য
webgl2-renderer = WebGL 2 ড্রাইভার Renderer
webgl2-version = WebGL 2 ড্রাইভার সংষ্করণ
webgl2-driver-extensions = WebGL 2 ড্রাইভার এক্সটেনসন
webgl2-extensions = WebGL 2 এক্সটেনশন
blocklisted-bug = জ্ঞাত সমস্যার কারণে ব্লকতালিকাভুক্ত

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = বাগ { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = ব্লকতালিকাভুক্ত; ব্যর্থ কোড { $failureCode }

d3d11layers-crash-guard = D3D11 কম্পোজিটর
d3d11video-crash-guard = D3D11 ভিডিও ডিকোডার
d3d9video-crash-guard = D3D9 ভিডিও ডিকোডার
glcontext-crash-guard = OpenGL

reset-on-next-restart = পুনরায় শুরু করার সময় রিসেট করুন
gpu-process-kill-button = GPU প্রক্রিয়া বন্ধ করুন
gpu-device-reset = ডিভাইস রিসেট
gpu-device-reset-button = ট্রিগার ডিভাইস রিসেট
uses-tiling = Tiling ব্যবহার করে
content-uses-tiling = টাইলিং (কনটেন্ট) এর ব্যবহার
off-main-thread-paint-enabled = অফ মেইন থ্রেড পেইন্টিং সক্রিয়
off-main-thread-paint-worker-count = Main Thread Painting Worker Count বন্ধ
target-frame-rate = টার্গেট ফ্রেম রেট

min-lib-versions = প্রত্যাশিত সর্বনিম্ন সংস্করণ
loaded-lib-versions = ব্যবহৃত সংস্করণ

has-seccomp-bpf = Seccomp-BPF (সিস্টেম কল ফিল্টারিং)
has-seccomp-tsync = সিকম্প থ্রেড সিংক্রোনাইজেশন
has-user-namespaces = ব্যবহারকারী নামস্থান
has-privileged-user-namespaces = তৈরী প্রসেসের জন্য ব্যবহারকারী নামস্থানসমূহ
can-sandbox-content = কন্টেন্ট প্রক্রিয়ার স্যান্ডবক্সিং
can-sandbox-media = মিডিয়া প্লাগইন Sandboxing
content-sandbox-level = কন্টেন্ট প্রক্রিয়ার স্যান্ডবক্সিং স্তর
effective-content-sandbox-level = ইফেক্টিভ কন্টেন্ট প্রসেস স্যান্ডবক্স লেভেল
sandbox-proc-type-content = কন্টেন্ট
sandbox-proc-type-file = ফাইল কনটেন্ট
sandbox-proc-type-media-plugin = মিডিয়া প্লাগইন
sandbox-proc-type-data-decoder = ডাটা ডিকোডার

launcher-process-status-0 = সক্রিয় হয়েছে
launcher-process-status-1 = ব্যর্থতার কারণে নিস্ক্রিয়
launcher-process-status-2 = জোরপূর্বক নিষ্ক্রিয় করা হয়েছে
launcher-process-status-unknown = অজ্ঞাত অবস্থা

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = ব্যবহারকারী দ্বারা সক্রিয়
multi-process-status-1 = বাই ডিফল্ট সক্রিয় রয়েছে
multi-process-status-2 = নিষ্ক্রিয় রয়েছে
multi-process-status-4 = অ্যাক্সেসেবিলিটি তুল দ্বারা নিষ্ক্রিয় রয়েছে
multi-process-status-6 = অসমর্থিত টেক্সট ইনপুটের কারনে নিষ্ক্রিয় হয়েছে
multi-process-status-7 = অ্যান্ড-অন দ্বারা নিষ্ক্রিয় হয়েছে
multi-process-status-8 = বলপূর্বক নিষ্ক্রিয় করা হয়েছে
multi-process-status-unknown = অজানা অবস্থা

async-pan-zoom = অ্যাসিংক্রোনাস প্যান/জুম
apz-none = কোনোটি নয়
wheel-enabled = চাকা নিবেশ সক্ষম
touch-enabled = স্পর্শকারী ইনপুট সক্রিয়
drag-enabled = স্ক্রলবার ড্র্যাগ সক্রিয়
keyboard-enabled = কিবোর্ড সয়ংক্রিয়
autoscroll-enabled = অটোস্ক্রোল সক্রিয়

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = অ্যাসিঙ্ক হুইল ইনপুট অসমর্থিত পছন্দ: { $preferenceKey } -এর জন্য নিস্ক্রিয়
touch-warning = অ্যাসিঙ্ক টাচ ইনপুট অসমর্থিত পছন্দ: { $preferenceKey } -এর জন্যে নিস্ক্রিয়

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = নিষ্ক্রিয়
policies-active = সক্রিয়
policies-error = ত্রুটি
