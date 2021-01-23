# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] မှတ်တမ်းကို ပြသရန် ကလစ်ဖိဆွဲချပါ။
           *[other] မှတ်တမ်းကို ပြသရန် ညာဘက်ကလစ် သို့မဟုတ် ကလစ်ဖိဆွဲချပါ။
        }

## Back

main-context-menu-back =
    .tooltiptext = တစ်မျက်နှာ နောက်ဆုတ်ပါ
    .aria-label = နောက်သို့
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = တစ်မျက်နှာ ရှေ့သွားပါ
    .aria-label = ရှေ့သို့
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = ပြန်ဖွင့်ပါ
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = ရပ်
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = စာမျက်နှာကို သိမ်းမည်…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = ဒီစာမျက်နှာကို မှတ်သားပါ
    .accesskey = m
    .tooltiptext = စာအမှတ်အားမှတ်သားထားမည်

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = ဒီစာမျက်နှာကို မှတ်သားပါ
    .accesskey = m
    .tooltiptext = စာအမှတ်အားမှတ်သားထားမည် ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = ဒီစာမှတ်ကို ပြင်ဆင်မည်
    .accesskey = m
    .tooltiptext = စာအမှတ်အားပြင်မည်

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = ဒီစာမှတ်ကို ပြင်ဆင်မည်
    .accesskey = m
    .tooltiptext = စာအမှတ်အားပြင်မည် ({ $shortcut })

main-context-menu-open-link =
    .label = လင့်ခ်ကို ဖွင့်ပါ
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = လင့်ခ်ကို တပ်ဗ်အသစ်တွင် ဖွင့်ပါ
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = လင့်ခ်ကို ကွန်တိန်နာတပ်ဗ်အသစ်တွင် ဖွင့်ပါ
    .accesskey = z

main-context-menu-open-link-new-window =
    .label = လင့်ခ်ကို ဝင်းဒိုးအသစ်တွင် ဖွင့်ပါ
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = လင့်ခ်ကို သီးသန့်ဝင်းဒိုးတွင် ဖွင့်ပါ
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = ဒီလင့်ခ်ကို မှတ်သားပါ
    .accesskey = L

main-context-menu-save-link =
    .label = လင့်ခ်ကို သိမ်းမည်…
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = အီးမေးလ် လိပ်စာကို ကူးယူပါ
    .accesskey = E

main-context-menu-copy-link =
    .label = လင့်ခ်တည်နေရာကို ကူးယူပါ
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = ဖွင့်ပါ
    .accesskey = P

main-context-menu-media-pause =
    .label = ခေတ္တရပ်ပါ
    .accesskey = P

##

main-context-menu-media-mute =
    .label = အသံ ပိတ်ထားပါ
    .accesskey = M

main-context-menu-media-unmute =
    .label = အသံ ပြန်ဖွင့်ပါ
    .accesskey = m

main-context-menu-media-play-speed =
    .label = ပြသနှုန်း
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = အနှေး(0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = ပုံမှန်
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = အမြန် (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = ပိုမြန် (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = အင်မတန်မြန်(2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = ပြန်ကျော့ရန်
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = ထိန်းချုပ်ခလုတ်များကို ပြပါ
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = ထိန်းချုပ်ခလုတ်များကို ဖျောက်ပါ
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = အပြည့်ကြည့်ရန်
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = မျက်နှာပြင်အပြည့်ကြည့်ခြင်းမှ ထွက်ရန်
    .accesskey = u

main-context-menu-image-reload =
    .label = ရုပ်ပုံကို ပြန်ဖွင့်ပါ
    .accesskey = R

main-context-menu-image-view =
    .label = ရုပ်ပုံကို ဖွင့်ကြည့်ရန်
    .accesskey = I

main-context-menu-video-view =
    .label = ဗီဒီယိုကို ဖွင့်ကြည့်ရန်
    .accesskey = i

main-context-menu-image-copy =
    .label = ရုပ်ပုံကို ကူးယူပါ
    .accesskey = y

main-context-menu-image-copy-location =
    .label = ရုပ်ပုံရှိရာ လမ်းကြောင်းကို ကူးယူပါ
    .accesskey = o

main-context-menu-video-copy-location =
    .label = ဗီဒီယိုရှိရာ လမ်းကြောင်းကို ကူးယူပါ
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = အော်ဒီယို တည်နေရာကို ကူးယူပါ
    .accesskey = o

main-context-menu-image-save-as =
    .label = ရုပ်ပုံကို သိမ်းမည်…
    .accesskey = v

main-context-menu-image-email =
    .label = ရုပ်ပုံကို အီးမေးလ်ပို့ရန်…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = နောက်ခံရုပ်ပုံအဖြစ် သတ်မှတ်ရန်...
    .accesskey = S

main-context-menu-image-info =
    .label = ရုပ်ပုံ၏အချက်အလက်
    .accesskey = ပ

main-context-menu-image-desc =
    .label = ဖော်ပြချက်ကို ကြည့်ရန်
    .accesskey = D

main-context-menu-video-save-as =
    .label = ဗီဒီယိုကို သိမ်းမည်…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = အသံကို သိမ်းမည်…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = လျှပ်တစ်ပြက်ရိုက်ချက်ကို သိမ်းမည်…
    .accesskey = S

main-context-menu-video-email =
    .label = ဗီဒီယိုကို အီးမေးလ်ပို့ရန်…
    .accesskey = a

main-context-menu-audio-email =
    .label = အော်ဒီယိုကို အီးမေးလ်ပို့ရန်…
    .accesskey = a

main-context-menu-plugin-play =
    .label = ဒီပလက်အင်ကို ဆောင်ရွက်စေပါ
    .accesskey = c

main-context-menu-plugin-hide =
    .label = ဒီပလက်အင်ကို ဖျောက်ထားပါ
    .accesskey = H

main-context-menu-send-to-device =
    .label = စာမျက်နှာကို ကိရိယာသို့ ပို့ပါ
    .accesskey = D

main-context-menu-view-background-image =
    .label = နောက်ခံရုပ်ပုံကို ကြည့်ရန်
    .accesskey = w

main-context-menu-keyword =
    .label = ဒီရှာဖွေမှုအတွက် အဓိကစာလုံးကို ထည့်ပါ…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = လင့်ခ်ကို ကိရိယာသို့ ပို့ပါ
    .accesskey = D

main-context-menu-frame =
    .label = ဒီဘောင်
    .accesskey = h

main-context-menu-frame-show-this =
    .label = ဒီဘောင်ကိုပဲ ပြပါ
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = ဘောင်ကို တပ်ဗ်အသစ်တွင် ဖွင့်ပါ
    .accesskey = T

main-context-menu-frame-open-window =
    .label = ဘောင်ကို ဝင်းဒိုးအသစ်တွင် ဖွင့်ပါ
    .accesskey = W

main-context-menu-frame-reload =
    .label = ဘောင်ကို ပြန်ဖွင့်ပါ
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = ဒီဘောင်ကို မှတ်သားပါ
    .accesskey = m

main-context-menu-frame-save-as =
    .label = ဘောင်ကို သိမ်းမည်…
    .accesskey = F

main-context-menu-frame-print =
    .label = ဘောင်ကို ပုံနှိပ်မည်…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ဘောင်ရင်းမြစ်ကို ကြည့်ရန်
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ဘောင်အချက်အလက်ကို ကြည့်ရန်
    .accesskey = I

main-context-menu-view-selection-source =
    .label = ရွေးချယ်မှုအရင်းအမြစ်ကို ကြည့်ရန်
    .accesskey = e

main-context-menu-view-page-source =
    .label = စာမျက်နှာရင်းမြစ်ကုဒ်ကို ကြည့်ရန်
    .accesskey = V

main-context-menu-view-page-info =
    .label = စာမျက်နှာ၏ အချက်လက်ကို ကြည့်ရန်
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = စာ၏ ဦးတည်ချက်ကို ပြောင်းလဲရန်
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = စာမျက်နှာ၏ ဦးတည်ချက်ကို ပြောင်းလဲရန်
    .accesskey = D

main-context-menu-inspect-element =
    .label = အစိတ်အပိုင်းကို လေ့လာရန်
    .accesskey = Q

main-context-menu-eme-learn-more =
    .label = DRM အကြောင်း ပိုမိုလေ့လာပါ…
    .accesskey = D

