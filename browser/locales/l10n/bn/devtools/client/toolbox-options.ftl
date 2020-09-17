# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = ডিফল্ট ডেভেলপার টুলসমূহ

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * বর্তমান টুলবক্স টার্গেট এর জন্য সমর্থিত নয়

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = এড-অন এর মাধ্যমে ইন্সটলকৃত ডেভেলপার টুল

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = প্রাপ্তিসাধ্য টুলবক্স বাটন

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = থিম

## Inspector section

# The heading
options-context-inspector = পরিদর্শক

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = ব্রাউজার স্টাইল দেখান
options-show-user-agent-styles-tooltip =
    .title = এটি চালু করলে, ব্রাউজারে লোড থাকা ডিফল্ট স্টাইলগুলো দেখানো হবে।

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM বৈশিষ্ট্য টার্নকেট করো
options-collapse-attrs-tooltip =
    .title = পরিদর্কের দীর্ঘ বৈশিষ্ট্য টার্নকেট করো

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = ডিফল্ট রঙের একক u
options-default-color-unit-authored = লেখক হিসেবে
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = রঙের নামসমূহ

## Style Editor section

# The heading
options-styleeditor-label = স্টাইল সম্পাদনা

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = স্বয়ংসম্পূর্ণ CSS
options-stylesheet-autocompletion-tooltip =
    .title = স্টাইল সম্পাদকের অংশে আপনার লিপিবদ্ধকৃত স্বয়ংসম্পূর্ণ CSS বৈশিষ্ট্যাবলী, মান ও নির্বাচক

## Screenshot section

# The heading
options-screenshot-label = স্ক্রিনশটের আচরণ

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = স্ক্রিনশট ক্লিপবোর্ডে পাঠাও
options-screenshot-clipboard-tooltip =
    .title = স্ক্রিনশটটি সরাসরি ক্লিপবোর্ডে সংরক্ষণ কর

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = ক্যামেরা সাটার শব্দ চালাও
options-screenshot-audio-tooltip =
    .title = স্ক্রিনশট নেওয়ার সময় ক্যামেরা অডিও শব্দ সক্রিয় কর

## Editor section

# The heading
options-sourceeditor-label = এডিটর পছন্দসমূহ

options-sourceeditor-detectindentation-tooltip =
    .title = উৎসের কন্টেন্টের ভিত্তিতে ইনডেন্টেশন ধারণা করুন
options-sourceeditor-detectindentation-label = ইনডেন্টেশন শনাক্তকরণ
options-sourceeditor-autoclosebrackets-tooltip =
    .title = স্বয়ংক্রিয়ভাবে ক্লোজিং ব্র্যাকেট দিন
options-sourceeditor-autoclosebrackets-label = অটোক্লোজ ব্র্যাকেট
options-sourceeditor-expandtab-tooltip =
    .title = ট্যাব ক্যারেক্টারের পরিবর্তে স্পেস ব্যবহার করুন
options-sourceeditor-expandtab-label = ফাঁকাস্থান ব্যবহার করে ইনডেন্ট করুন
options-sourceeditor-tabsize-label = ট্যাবের আকার
options-sourceeditor-keybinding-label = কীবাইন্ডিং
options-sourceeditor-keybinding-default-label = ডিফল্ট

## Advanced section

# The heading
options-context-advanced-settings = উন্নত সেটিং

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP ক্যাশে নিষ্ক্রিয় করুন (টুলবক্স খোলা থাকাকালীন)
options-disable-http-cache-tooltip =
    .title = এই অপশনটি চালু করলে, যেসকল ট্যাব এর টুলবক্স খোলা রয়েছে, সেগুলোর HTTP ক্যাশে নিষ্ক্রিয় হয়ে যাবে। পরিসেবা কার্যক্রমে এই অপশনের কোন প্রভাব পরবে না।

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = জাভাস্ক্রিপ্ট নিস্ক্রিয় করুন*
options-disable-javascript-tooltip =
    .title = এই অপশন চালুর ফলে বর্তমান ট্যাবে জাভাস্ক্রিপ্ট নিস্ক্রিয় হবে। যদি ট্যাব অথবা টুলবক্স বন্ধ করা হয় তবে এই সেটিং ভুলে যাবে।

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = ব্রাউজার chrome ও অ্যাড অন ডিবাগ টুলবক্স সক্রিয় করুন
options-enable-chrome-tooltip =
    .title = এই অপশান চালু করলে আপনি অনেকগুলো টুল ব্যবহার করতে পারবেন ব্রাউজার কন্টেক্সট এ (Tools > Web Developer > Browser Toolbox এর মাধ্যমে) এবং অ্যাড-অন ম্যানেজার দিয়ে অ্যাড-অন ডিবাগ করতে পারবেন

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = রিমোট ডিবাগিং সক্রিয় করুন

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = HTTP এ সার্ভিস ওয়ার্কারদের সক্রিয় করুন (যখন টুলবক্স খোলা থাকে)
options-enable-service-workers-http-tooltip =
    .title = এই অপশন চালু থাকলে যেসব ট্যাবের টুলবক্স খোলা আছে সেগুলোর HTTP এ সার্ভিস ওয়ার্কারদের সক্রিয় করে দিবে।

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = উৎস ম্যাপ সক্রিয় করুন
options-source-maps-tooltip =
    .title = আপনি যদি এই অপশন সক্রিয় করেন টুলে সোর্স ম্যাপড হবে।

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = *কেবল বর্তমান সেশন, পাতা পুনরায় লোড করে

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = গেকো প্ল্যাটফর্ম ডাটা দেখান
options-show-platform-data-tooltip =
    .title = যদি আপনি এই অপশন সক্রিয় করেন তবে জাভাস্ক্রিপ্ট প্রোফাইলার গেকো প্লাটফর্ম চিহ্নে অর্ন্তভূক্ত রাখবে
