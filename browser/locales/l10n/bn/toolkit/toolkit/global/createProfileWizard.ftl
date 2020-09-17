# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = প্রোফাইল উইজার্ড তৈরি
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] ভূমিকা
       *[other] { create-profile-window.title } এ আপনাকে স্বাগতম
    }

profile-creation-explanation-1 = { -brand-short-name } আপনার ব্যক্তিগত প্রোফাইলে আপনার ব্যবহৃত সেটিংসমূহ ও পছন্দসমূহ সম্পর্কিত তথ্য সংরক্ষণ করে।

profile-creation-explanation-2 = আপনি যদি { -brand-short-name } এর এই অনুলিপিটি অন্যান্য ব্যবহারকারীদের সাথে যৌথভাবে ব্যবহার করে থাকেন, তাহলে প্রত্যেক ব্যবহারকারীর তথ্য পৃথক রাখার জন্য আলাদা প্রোফাইল ব্যবহার করতে পারেন। এর জন্য, প্রত্যেক ব্যবহারকারীকে নিজস্ব প্রোফাইল তৈরি করতে হবে।

profile-creation-explanation-3 = আপনি যদি একা { -brand-short-name } ব্যবহার করে থাকেন, তাহলে অন্তত একটি প্রোফাইল বিদ্যমান থাকা আবশ্যক। আপনি চাইলে, বিভিন্ন সেটিংসমূহ ও পছন্দসমূহ সংরক্ষণ করার জন্য আপনার নিজের একাধিক প্রোফাইল তৈরী করতে পারেন। উদাহরণস্বরূপ, ব্যক্তিগত ও ব্যবসায়িক প্রয়োজন অনুসারে আপনি পৃথক প্রোফাইল তৈরী করতে পারেন।

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] প্রোফাইল তৈরী আরম্ভ করতে, "চালিয়ে যান" ক্লিক করুন।
       *[other] প্রোফাইল তৈরী আরম্ভ করতে, "পরবর্তী" ক্লিক করুন।
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] সমাপ্তি
       *[other] { create-profile-window.title } সম্পন্ন করা হচ্ছে
    }

profile-creation-intro = একাধিক প্রোফাইল তৈরী করলে আপনি নাম দিয়ে এগুলোকে চিহ্নিত করতে পারবেন। এখানে দেয়া নাম অথবা আপনার পছন্দসই অন্য যে কোনো নাম ব্যবহার করতে পারেন।

profile-prompt = নতুন প্রোফাইলের নাম লিখুন: (E)
    .accesskey = E

profile-default-name =
    .value = ডিফল্ট ব্যবহারকারী

profile-directory-explanation = আপনার ব্যবহারকারী সেটিংসমূহ, পছন্দসমূহ ও অন্যান্য ব্যবহারকারী-সম্পর্কিত তথ্য সংরক্ষণের স্থান:

create-profile-choose-folder =
    .label = ফোল্ডার বেছে নিন… (C)
    .accesskey = C

create-profile-use-default =
    .label = ডিফল্ট ফোল্ডার ব্যবহার
    .accesskey = U
