# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] ইতিহাস দেখতে নীচে টেনে আনুন
           *[other] ইতিহাস প্রদর্শনের জন্য ডান বাটন ক্লিক করুন অথবা নীচে টেনে আনুন
        }

## Back

main-context-menu-back =
    .tooltiptext = পূর্ববর্তী পাতায় ফিরে যান
    .aria-label = পূর্ববর্তী
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = পরবর্তী পাতায় যাও
    .aria-label = পরবর্তী
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = পুনরায় লোড
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = থামুন
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = পাতা নতুনভাবে সংরক্ষণ…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = এই পাতা বুকমার্ক করুন
    .accesskey = m
    .tooltiptext = পাতাটি বুকমার্ক করুন

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = এই পাতা বুকমার্ক করুন
    .accesskey = m
    .tooltiptext = পাতাটি বুকমার্ক করুন ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = বুকমার্ক সম্পাদনা
    .accesskey = m
    .tooltiptext = এই বুকমার্কটি সম্পাদনা

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = বুকমার্ক সম্পাদনা
    .accesskey = m
    .tooltiptext = এই বুকমার্কটি সম্পাদনা ({ $shortcut })

main-context-menu-open-link =
    .label = লিঙ্ক খুলুন O
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = একটি নতুন ট্যাবে লিঙ্ক খুলুন
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = একটি নতুন কন্টেইনার ট্যাবে লিঙ্ক খুলুন
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = একটি নতুন উইন্ডোতে লিঙ্ক খুলুন
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = নতুন উইন্ডোতে লিঙ্ক খুলুন
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = এই লিঙ্ক বুকমার্ক করুন
    .accesskey = L

main-context-menu-save-link =
    .label = লিঙ্কটি নতুনভাবে সংরক্ষণ…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = { -pocket-brand-name } এ লিঙ্ক সংরক্ষণ করুন
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ইমেইল ঠিকানা অনুলিপি
    .accesskey = E

main-context-menu-copy-link =
    .label = লিঙ্কটির ঠিকানা অনুলিপি করুন
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = চালান
    .accesskey = P

main-context-menu-media-pause =
    .label = বিরতি
    .accesskey = P

##

main-context-menu-media-mute =
    .label = শব্দ বন্ধ
    .accesskey = M

main-context-menu-media-unmute =
    .label = শব্দ চালু
    .accesskey = m

main-context-menu-media-play-speed =
    .label = চালনার গতি d
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = ধীরে (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = স্বাভাবিক
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = দ্রুত (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = Faster (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ludicrous (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = পুনরাবৃত্তি
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = কন্ট্রোলসমূহ প্রদর্শন
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = কন্ট্রোলসমূহ আড়াল
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = পূর্ণ পর্দাজুড়ে
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = পূর্ণ পর্দাজুড়ে প্রদর্শন মোড হতে প্রস্থান
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = ছবির মধ্যে ছবি
    .accesskey = u

main-context-menu-image-reload =
    .label = ছবি আবার লোড করা হবে
    .accesskey = R

main-context-menu-image-view =
    .label = ছবি প্রদর্শন
    .accesskey = I

main-context-menu-video-view =
    .label = ভিডিও প্রদর্শন
    .accesskey = i

main-context-menu-image-copy =
    .label = ছবি অনুলিপি
    .accesskey = y

main-context-menu-image-copy-location =
    .label = ছবির ঠিকানা অনুলিপি
    .accesskey = o

main-context-menu-video-copy-location =
    .label = ভিডিওর ঠিকানা অনুলিপি
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = অডিওর ঠিকানা অনুলিপি
    .accesskey = o

main-context-menu-image-save-as =
    .label = ছবি নতুনভাবে সংরক্ষণ…
    .accesskey = v

main-context-menu-image-email =
    .label = ছবি ইমেইল করুন... g
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = ডেস্কটপের পটভূমি হিসেবে নির্ধারণ…
    .accesskey = S

main-context-menu-image-info =
    .label = ছবির তথ্য প্রদর্শন
    .accesskey = f

main-context-menu-image-desc =
    .label = বর্ণনা দেখুন
    .accesskey = D

main-context-menu-video-save-as =
    .label = ভিডিও নতুনভাবে সংরক্ষণ…
    .accesskey = V

main-context-menu-audio-save-as =
    .label = অডিও নতুনভাবে সংরক্ষণ…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = স্ন্যাপশট হিসেবে সংরক্ষণ করুন...
    .accesskey = S

main-context-menu-video-email =
    .label = ভিডিও ইমেইল করুন... a
    .accesskey = a

main-context-menu-audio-email =
    .label = A অডিও ইমেইল করুন...
    .accesskey = A

main-context-menu-plugin-play =
    .label = এই প্লাগইনটি সচল করুন
    .accesskey = c

main-context-menu-plugin-hide =
    .label = প্লাগইনটি আড়াল করুন
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = { -pocket-brand-name } এ পাতাটি সংরক্ষণ করুন
    .accesskey = k

main-context-menu-send-to-device =
    .label = ডিভাইসে পাতা পাঠাও
    .accesskey = D

main-context-menu-view-background-image =
    .label = পটভূমির ছবি প্রদর্শন
    .accesskey = w

main-context-menu-keyword =
    .label = অনুসন্ধানের জন্য কীওয়ার্ড যোগ করুন…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ডিভাইসে লিঙ্ক পাঠাও
    .accesskey = D

main-context-menu-frame =
    .label = এই ফ্রেম
    .accesskey = h

main-context-menu-frame-show-this =
    .label = শুধুমাত্র এই ফ্রেমটি প্রদর্শন করা হবে
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = একটি নতুন ট্যাবে ফ্রেম খুলুন
    .accesskey = T

main-context-menu-frame-open-window =
    .label = একটি নতুন উইন্ডোতে ফ্রেম খুলুন
    .accesskey = W

main-context-menu-frame-reload =
    .label = ফ্রেম পুনরায় লোড করা হবে
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = এই ফ্রেম বুকমার্ক করা হবে
    .accesskey = m

main-context-menu-frame-save-as =
    .label = ফ্রেম নতুনভাবে সংরক্ষণ…
    .accesskey = F

main-context-menu-frame-print =
    .label = ফ্রেম মুদ্রণ…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ফ্রেমের সোর্স প্রদর্শন
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ফ্রেম সংক্রান্ত তথ্য
    .accesskey = I

main-context-menu-view-selection-source =
    .label = নির্বাচিত অংশের সোর্স প্রদর্শন
    .accesskey = e

main-context-menu-view-page-source =
    .label = পাতার সোর্স প্রদর্শন
    .accesskey = V

main-context-menu-view-page-info =
    .label = পাতা সংক্রান্ত তথ্য
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = লেখার দিকবিন্যাস পরিবর্তন
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = পাতার দিকবিন্যাস পরিবর্তন
    .accesskey = D

main-context-menu-inspect-element =
    .label = উপাদান পর্যবেক্ষণ করুন
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = অভিগম্যতা বৈশিষ্ট্যগুলো পর্যবেক্ষণ করুন

main-context-menu-eme-learn-more =
    .label = DRM সম্পর্কে আরও জানুন…
    .accesskey = D

