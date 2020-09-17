# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = ইমপোর্ট উইজার্ড

import-from =
    { PLATFORM() ->
        [windows] উল্লেখিত স্থান থেকে অপশনসমূহ, বুকমার্ক, ইতিহাস, পাসওয়ার্ড ও অন্যান্য তথ্য ইমপোর্ট করা হবে:
       *[other] উল্লেখিত স্থান থেকে পছন্দসমূহ, বুকমার্ক, ইতিহাস, পাসওয়ার্ড ও অন্যান্য তথ্য ইমপোর্ট করা হবে:
    }

import-from-bookmarks = উল্লেখিত স্থান থেকে বুকমার্ক ইমপোর্ট করা হবে:
import-from-ie =
    .label = মাইক্রোসফট ইন্টারনেট এক্সপ্লোরার
    .accesskey = M
import-from-edge =
    .label = মাইক্রোসফট Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = কিছুই ইমপোর্ট করা হবে না
    .accesskey = D
import-from-safari =
    .label = সাফারি
    .accesskey = S
import-from-canary =
    .label = ক্রোম ক্যানারি
    .accesskey = n
import-from-chrome =
    .label = ক্রোম C
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = ক্রোমিয়াম
    .accesskey = য়
import-from-firefox =
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = 360 নিরাপদ ব্রাউজার
    .accesskey = 3

no-migration-sources = বুকমার্ক, ইতিহাস অথবা পাসওয়ার্ড ধারণকারী কোনো প্রোগ্রাম পাওয়া যায়নি।

import-source-page-title = সেটিং ও তথ্য ইমপোর্ট করুন
import-items-page-title = ইমপোর্ট করা হবে

import-items-description = ইমপোর্ট করার জন্য আইটেম নির্বাচন:

import-migrating-page-title = ইমপোর্ট করা হচ্ছে...

import-migrating-description = বর্তমানে নিম্নলিখিত আইটেম ইমপোর্ট করা হচ্ছে...

import-select-profile-page-title = প্রোফাইল নির্বাচন

import-select-profile-description = নিম্নলিখিত প্রোফাইলগুলি থেকে বর্তমানে ইমপোর্ট করা সম্ভব:

import-done-page-title = ইমপোর্ট সমাপ্ত

import-done-description = নিম্নলিখিত আইটেমের ইমপোর্ট সফল হয়েছে:

import-close-source-browser = কন্টিনিউ করার পূর্বে এটি নিশ্চিত করুন যে আপনার ব্রাউসারটি বন্ধ।

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } থেকে

source-name-ie = ইন্টারনেট এক্সপ্লোরার
source-name-edge = মাইক্রোসফট এজ
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = সাফারি
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = ক্রোমিয়াম
source-name-firefox = Mozilla Firefox
source-name-360se = 360 নিরাপদ ব্রাউজার

imported-safari-reading-list = তালিকা পড়া হচ্ছে (সাফারি হতে)
imported-edge-reading-list = তালিকা পড়া হচ্ছে (Edge হতে)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-session-checkbox =
    .label = উইন্ডো এবং ট্যাব
browser-data-session-label =
    .value = উইন্ডো এবং ট্যাব
