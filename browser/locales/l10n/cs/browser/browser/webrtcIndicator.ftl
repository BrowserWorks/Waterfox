# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title =
    Ukazatel sdílení { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
webrtc-sharing-window = Sdílíte okno jiné aplikace.
webrtc-sharing-browser-window =
    Sdílíte { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    }.
webrtc-sharing-screen = Sdílíte celou vaši obrazovku.
webrtc-stop-sharing-button = Ukončit sdílení
webrtc-microphone-button =
    .title = Váš mikrofón je sdílen. Pro úpravu sdílení klepněte.
webrtc-camera-button =
    .title = Vaše kamera je sdílena. Pro úpravu sdílení klepněte.
webrtc-microphone-unmuted =
    .title = Vypnout mikrofon
webrtc-microphone-muted =
    .title = Zapnout mikrofon
webrtc-camera-unmuted =
    .title = Vypnout kameru
webrtc-camera-muted =
    .title = Zapnout kameru
webrtc-minimize =
    .title = Minimalizovat ukazatel
