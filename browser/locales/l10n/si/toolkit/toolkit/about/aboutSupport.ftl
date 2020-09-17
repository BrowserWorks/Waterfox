# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = දොස් සෙවීම් තොරතුරු
page-subtitle =
    This page contains technical information that might be useful when you're
    trying to solve a problem. If you are looking for answers to common questions
    about { -brand-short-name }, check out our <a data-l10n-name="support-link">support web site</a>.

crashes-title = බිදවැටුම් වාර්තා
crashes-id = වාර්තා අංකය
crashes-send-date = පළකළ
crashes-all-reports = සියළු බිදවැටුම් වාර්තා
crashes-no-config = මෙම යෙදුම බිඳවැටුම් වාර්ථා පෙන්වීමට සකසා නොමැත.
extensions-title = දිගුකිරීම්
extensions-name = නම
extensions-enabled = බලැති (Enabled)
extensions-version = නිකුතුව
extensions-id = ID
support-addons-name = නම
support-addons-version = නිකුතුව
support-addons-id = ID
security-software-title = ආරක්ෂක මෘදුකාංග
security-software-type = වර්ගය
security-software-name = නම
security-software-antivirus = ප්‍රතිවෛරස
features-name = නම
features-version = නිකුතුව
features-id = ID
app-basics-title = යෙදුම් මූලිකාංග
app-basics-name = නම
app-basics-version = නිකුතුව
app-basics-build-id = නිකුතු ID
app-basics-update-channel = යාවත් නාලිකාව
app-basics-update-history = යාවත්කාලීන ඉතිහාසය
app-basics-show-update-history = යාවත්කාලීන ඉතිහාසය පෙන්වන්න
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] ප්‍රොපයිල ඩිරෙක්ටරිය
       *[other] ෆ්‍රොපයිල ෆෝල්ඩරය
    }
app-basics-enabled-plugins = ප්ලගීන බලැති (Enable) කරන්න
app-basics-build-config = Build Configuration
app-basics-user-agent = User Agent
app-basics-os = OS
app-basics-memory-use = මෙමරි භාවිතය
app-basics-performance = ක්‍රියාකාරීත්වය
app-basics-service-workers = ලියාපදිංචි කළ Service Workers
app-basics-profiles = පැතිකඩයන්
app-basics-launcher-process-status = දියත්කිරීම් සැකසුම
app-basics-multi-process-support = බහුසැකසුම් කවුළු
app-basics-enterprise-policies = ව්‍යවසාය ප්‍රතිපත්ති
app-basics-key-mozilla = Mozilla ස්ථාන සේවා යතුර
app-basics-safe-mode = ආරක්ෂිත ප්‍රකාරය
show-dir-label =
    { PLATFORM() ->
        [macos] Finder තුළ පෙන්වන්න
        [windows] බහළුම තුළ පෙන්වන්න
       *[other] නාමාවලිය තුළ පෙන්වන්න
    }
modified-key-prefs-title = ආයාතකළ වෙනස්කළ මනාපයන්
modified-prefs-name = නම
modified-prefs-value = අගය
user-js-title = user.js අභිප්‍රේත
user-js-description = ඔබේ පැතිකඩ බහලුම සතුව { -brand-short-name } මගින් නිර්මාණය නොකල අභිප්‍රේතද අඩංගු <a data-l10n-name="user-js-link">user.js file</a> පවතී.
locked-key-prefs-title = වැදගත් අගුළුලූ අභිප්‍රේත
locked-prefs-name = නම
locked-prefs-value = අගය
graphics-title = පිංතූර
graphics-features-title = විශේෂාංග
graphics-diagnostics-title = දෝෂ නිර්ණය
graphics-failure-log-title = අසමර්ථ වාර්ථාව
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = තීරණ වාර්ථාව
a11y-title = ප්‍රවේශතාව
a11y-activated = සක්‍රීය කළ
a11y-force-disabled = පිවිසුම අබල කරන්න
library-version-title = පුස්තකාල නිකුතුව
copy-text-to-clipboard-label = පෙළ පසුරු පුවරුවට පිටපත් කරන්න
copy-raw-data-to-clipboard-label = අමු දත්ත පසුරු පුවරුවට පිටපත් කරන්න
sandbox-title = සෑන්ඩ්බොක්ස්
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-args = තර්ක
safe-mode-title = ආරක්ෂිත ප්‍රකාරය උත්සහ කරන්න
restart-in-safe-mode-label = ඇඩෝන අක්‍රීය කර යළි ආරම්භ කරන්න…

## Media titles

media-output-devices-title = ප්‍රතිදාන උපාංග
media-input-devices-title = ආදාන උපකරණ
media-device-name = නම
media-device-group = සමුහය
media-device-vendor = සම්පාදක
media-device-state = තත්වය
media-device-preferred = කැමති
media-device-format = හැඩසවිය

##

intl-os-title = මෙහෙයුම් පද්ධතිය

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
        [one] අවසන් { $days } දිනය සඳහා බිඳවැටීම් වාර්ථා
       *[other] අවසන් { $days } දින සඳහා බිඳවැටීම් වාර්ථා
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] මිනිත්තු { $minutes } පෙර
       *[other] මිනිත්තු { $minutes } පෙර
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] පැය { $hours } පෙර
       *[other] පැය { $hours } පෙර
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] දින { $days } පෙර
       *[other] දින { $days } පෙර
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] සියළුම බිඳවැටීම් වාර්ථා (දෙනලද කාල පරාසය තුළ පොරොත්තු වූ { $reports } බිඳවැටීමද ඇතුළුව)
       *[other] සියළුම බිඳවැටීම් වාර්ථා (දෙනලද කාල පරාසය තුළ පොරොත්තු වූ { $reports } බිඳවැටීම්ද ඇතුළුව)
    }

raw-data-copied = අමු දත්ත පසුරු පුවරුවට පිටපත් විය
text-copied = Text copied to clipboard

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = ඔබගේ ග්‍රැපික්ස් ධාවක නිකුතුව සඳහා අවහිර කර ඇත.
blocked-gfx-card = නොවිසඳුනු ධාවක ගැටළු නිසා ඔබගේ ග්‍රැපික්ස් කාඩ් එක සඳහා අවහිර කර ඇත.
blocked-os-version = ඔබගේ මෙහෙයුම් පද්ධති නිකුතුව සඳහා අවහිර කර ඇත.
blocked-mismatched-version = ඔබගේ චිත්‍රණ ධාවක නිකුතුව ලියාපදිංචිය හා DLL අතර නොගැලපීම නිසා අවහිර කර ඇත.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = ඔබගේ ග්‍රැපික්ස් ධාවක නිකුතුව සඳහා අවහිර කර ඇත. { $driverVersion } හෝ ඊට අළුත් නැකුතුවක් වෙත ග්‍රැපික්ස් ධාවක නිකුතුව යාවත්කාලීන කර උත්සාහ කරන්න.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType Parameters

compositing = නිබන්ධනය කරමින්
hardware-h264 = දෘඩාංග H264 විකේතණය
main-thread-no-omtc = ප්‍රධාන තීරය, OMTC නොමැත
yes = ඔව්
no = නැහැ
unknown = නොදන්නා

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = හමුවුණි

gpu-description = විස්තරය
gpu-vendor-id = නිශ්පාදක ID
gpu-device-id = උපාංග ID
gpu-subsys-id = අනුපද්ධති ID
gpu-drivers = ධාවකයන්
gpu-ram = RAM
gpu-driver-version = ධාවක නිකුතුව
gpu-driver-date = ධාවක දිනය
gpu-active = සක්‍රීය
webgl1-version = WebGL 1 ධාවක අනුවාදය
webgl1-driver-extensions = WebGL 1 ධාවක දිගු
webgl1-extensions = WebGL 1 දිගු
webgl2-version = WebGL 2 ධාවක අනුවාදය
webgl2-driver-extensions = WebGL 2 ධාවක දිගු
webgl2-extensions = WebGL 2 දිගු

glcontext-crash-guard = OpenGL

min-lib-versions = බලාපොරුත්තුවන අවම නිකුතුව
loaded-lib-versions = දැනට භාවිතා වන නිකුතුව

has-seccomp-bpf = Seccomp-BPF (පද්ධති ඇමතුම් පෙරහණ්කරනය)
has-seccomp-tsync = Seccomp තීර සම්මුහුර්ථකරණය
has-user-namespaces = පරිශීලක නාම ඉඩ
has-privileged-user-namespaces = බලලත් ක්‍රියාවලියන් සඳහා පරිශීලක නාම ඉඩ
can-sandbox-content = අන්තර්ගත සැකසුම් සෑන්ඩ්බොක්ස්කරණය
can-sandbox-media = මාධ්‍ය ප්ලගින සෑන්ඩ්බොක්ස්කරණය
sandbox-proc-type-content = අන්තර්ගතය

launcher-process-status-0 = සක්‍රීය කළ
launcher-process-status-unknown = නොදන්නා තත්වයකි

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = පරිශීලක විසින් සක්‍රීය කළ
multi-process-status-1 = පෙරනිමියෙන් සක්‍රීය කළ
multi-process-status-2 = අක්‍රීය කළ
multi-process-status-4 = පිවිසුම්කාරක මෙවලම් මගින් අක්‍රීය කළ
multi-process-status-6 = සහය නොදක්වන පෙළ ආදානයක් නිසා අක්‍රීය කර ඇත
multi-process-status-7 = ඇඩෝන මගින් අක්‍රීය කර ඇත
multi-process-status-8 = බලාත්මකව අක්‍රීය කර ඇත
multi-process-status-unknown = නොදන්නා තත්ත්වයකි

async-pan-zoom = අසමමුහූර්තක Pan/Zoom
apz-none = නොමැත
wheel-enabled = රෝද ආදාන සක්‍රීයයි
touch-enabled = ස්පර්ශ ආදාන සක්‍රීයයි
drag-enabled = ස්ක්‍රෝල් තීරු ඇදීම සක්‍රීයයි
keyboard-enabled = යතුරුපුවරුව සක්‍රීය

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = සහය නොදක්වන අභිප්‍රේයක් නිසා අසම්මුහුර්තක රෝද ආදානය අක්‍රීයයි: { $preferenceKey }
touch-warning = සහය නොදක්වන අභිප්‍රේයක් නිසා අසම්මුහුර්තක ස්පර්ශක ආදානය අක්‍රීයයි: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = අක්‍රීය
policies-active = සක්‍රීය
policies-error = දෝෂය
