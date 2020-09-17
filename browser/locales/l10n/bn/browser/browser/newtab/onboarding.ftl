# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = আরও জানুন
onboarding-button-label-get-started = শুরু করুন

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } এ স্বাগতম
onboarding-welcome-body = ব্রাউজার ইন্সটল হয়েছে। <br/> { -brand-product-name } বাকি  অংশ দেখুন।
onboarding-welcome-learn-more = সুবিধাগুলো সম্পর্কে আরও জানুন।

onboarding-welcome-modal-get-body = ব্রাউজার ইনস্টল হয়েছে।<br/>এখন { -brand-product-name } থেকে সর্বাধিক সুবিধা পান।
onboarding-welcome-modal-supercharge-body = আপনার গোপনীয়তা সুরক্ষা সুপারচার্জ করুন।
onboarding-welcome-modal-privacy-body = ব্রাউজার ইনস্টল হয়েছে। চলুন, আরো গোপনীয়তা সুরক্ষা যুক্ত করা যাক।
onboarding-welcome-modal-family-learn-more = পণ্যের { -brand-product-name } গোত্র সম্পর্কে জানুন।
onboarding-welcome-form-header = এখান থেকে শুরু করুন

onboarding-join-form-body = শুরু করতে এখানে আপনার ইমেইল ঠিকানা দিন।
onboarding-join-form-email =
    .placeholder = ইমেইল লিখুন
onboarding-join-form-email-error = বৈধ ইমেইল আবশ্যক
onboarding-join-form-legal = এগিয়ে যাওয়ার মাধ্যমে আপনি <a data-l10n-name="terms"> এর পরিষেবার শর্তাবলী</a> এবং <a data-l10n-name="privacy"> গোপনীয়তা বিজ্ঞপ্তি</a> এর সাথে একমত হবেন।
onboarding-join-form-continue = চালিয়ে যান

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে?
# Text for link to submit the sign in form
onboarding-join-form-signin = সাইন ইন

onboarding-start-browsing-button-label = ব্রাউজিং শুরু করুন

onboarding-cards-dismiss =
    .title = বাতিল
    .aria-label = বাতিল

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = আসুন আপনি যা কিছু করতে পারেন তা অন্বেষণ করা শুরু করুন।
onboarding-fullpage-form-email =
    .placeholder = আপনার ইমেইল ঠিকানা…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = অাপনি { -brand-product-name } ব্যবহার করুন
onboarding-sync-welcome-content = আপনার সমস্ত ডিভাইসে আপনার বুকমার্ক, ইতিহাস, পাসওয়ার্ড এবং অন্যান্য সেটিংস পাওয়া যাবে।
onboarding-sync-welcome-learn-more-link = Firefox অ্যাকাউন্ট সম্পর্কে আরও জানুন

onboarding-sync-form-input =
    .placeholder = ইমেইল

onboarding-sync-form-continue-button = চালিয়ে যান
onboarding-sync-form-skip-login-button = এই ধাপটি বাদ দিন

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = আপনার ই-মেইল লিখুন
onboarding-sync-form-sub-header = { -sync-brand-name } অব্যাহত রাখতে


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = টুলসের সমষ্টি দিয়ে কাজ সেরে নিন যা আপনার গোপনীয়তাকে গুরুত্ব দেয়।

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = আমরা ব্যক্তিগত  তথ্যের প্রতিশ্রুতিকে সম্মান করি: কম রাখি , নিরাপদে রাখি , কোন লুকোচুরি নেই।


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = আপনার বুকমার্ক, পাসওয়ার্ড, ইতিহাস এবং আরো অনেক কিছু { -brand-product-name } এর সাহায্যে সাথে নিন

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = আপনার ব্যক্তিগত তথ্য বেহাত করে তা সম্পর্কে অবহিত হন।

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = আপনার নিরাপদ ও বহনযোগ্য পাসওয়ার্ড ম্যানেজ করুন।


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = ট্র্যাকিং থেকে সুরক্ষা
onboarding-tracking-protection-text2 = { -brand-short-name } আপনাকে ওয়েবসাইটগুলোর অনলাইনে ট্র্যাক করা বন্ধ করতে সাহায্য করে, বিজ্ঞাপণের জন্য ওয়েবে আপনাকে অনুসরণ করা কঠিন করে তোলে।
onboarding-tracking-protection-button2 = কিভাবে এটা কাজ করে

onboarding-data-sync-title = আপনার সেটিং আপনার সঙ্গে নিন
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = আপনি যেখানেই { -brand-product-name } ব্যবহার করুন, আপনার বুকমার্ক, পাসওয়ার্ড এবং আরো অনেক কিছু সিঙ্ক করুন।
onboarding-data-sync-button2 = { -sync-brand-short-name } এ সাইন ইন করুন

onboarding-firefox-monitor-title = ডাটা ব্রীচ সম্পর্কে সতর্ক থাকুন
onboarding-firefox-monitor-text2 = { -monitor-brand-name } নজর রাখে আপনার ইমেইল জানা কোনো ডাটা লঙ্ঘনে পড়েছে কিনা যদি নতুন কোনো লঙ্ঘনে পড়ে থাকে তাহলে আপনাকে সতর্ক করে।
onboarding-firefox-monitor-button = বিপদসঙ্কেতের জন্য সাইন আপ করুন

onboarding-browse-privately-title = গোপনভাবে ব্রাউজ করুন
onboarding-browse-privately-text = আপনার কম্পিউটার ব্যবহার করে এমন কারো কাছ থেকে গোপন রাখতে গোপনীয় ব্রাউজিং আপনার অনুসন্ধান এবং ব্রাউজিং ইতিহাস সংরক্ষণ করে না ।
onboarding-browse-privately-button = ব্যাক্তিগত উইন্ডোতে খুলুন

onboarding-firefox-send-title = আপনার শেয়ার করা ফাইলগুলো গোপন রাখুন
onboarding-firefox-send-text2 = এন্ড টু এন্ড এনক্রিপশনের মাধ্যমে শেয়ার করতে ফাইলগুলো { -send-brand-name } এ আপলোড করুন  এবং যাতে লিঙ্ক স্বয়ংক্রিয়ভাবে মেয়াদোত্তীর্ণ হয়।
onboarding-firefox-send-button = { -send-brand-name } পরখ করুন

onboarding-mobile-phone-title = আপনার ফোনে { -brand-product-name } ডাউনলোড করুন
onboarding-mobile-phone-text = iOS বা Android জন্য { -brand-product-name } ডাউনলোড করুন এবং ডিভাইসগুলোতে আপনার ডেটা সিঙ্ক করুন।
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = মোবাইল ব্রাউজার ডাউনলোড করুন

onboarding-send-tabs-title = তাৎক্ষনিক নিজেকে ট্যাব পাঠান
onboarding-send-tabs-button = Send Tabs ব্যবহার শুরু করুন

onboarding-pocket-anywhere-title = যেকোন স্থানে পড়ুন এবং শুনুন।
onboarding-pocket-anywhere-text2 = আপনার প্রিয় কনটেন্ট { -pocket-brand-name } অ্যাপে অফলাইনে সংরক্ষণ করে রাখুন এবং আপনার সুবিধামতো পড়ুন , শুনুন ও দেখুন।
onboarding-pocket-anywhere-button = { -pocket-brand-name } পরখ করুন

onboarding-lockwise-strong-passwords-title = শক্তিশালী পাসওয়ার্ড তৈরি ও জমা করুন
onboarding-lockwise-strong-passwords-button = আপনার লগইন নিয়ন্ত্রন করুন

onboarding-facebook-container-title = Facebook এর মাধ্যমে সীমানা নির্ধারণ করুন
onboarding-facebook-container-text2 = { -facebook-container-brand-name } আপনার প্রোফাইলকে সবকিছু থেকে আলাদা রেখে Facebook এ আপনাকে লক্ষ্য করে বিজ্ঞাপণ দেওয়া কঠিন করে তোলে।
onboarding-facebook-container-button = এক্সটেনশনটি যোগ করুন


onboarding-import-browser-settings-title = আপনার বুকমার্ক, পাসওয়ার্ড এবং আরও অনেক কিছু নিয়ে আসুন এখানে
onboarding-import-browser-settings-text = এক্ষুনি আসুন—সহজেই আপনার Chrome সাইট এবং সেটিংস আপনার সাথে নিয়ে আসে।

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = দারুণ, আপনি { -brand-short-name } পেয়েছেন

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = এখন আপনি পাবেন <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = এক্সটেনশন যোগ করুন
return-to-amo-get-started-button = { -brand-short-name } দিয়ে শুরু করুন
