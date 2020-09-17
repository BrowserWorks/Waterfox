# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } একটি অকার্যকর নিরাপত্তার সার্টিফিকেট ব্যবহার করে।

cert-error-mitm-intro = ওয়েবসাইট সার্টিফিকেটের মাধ্যমে তাদের পরিচয় প্রমাণ করে, যা সার্টিফিকেট কর্তৃপক্ষ ইস্যু করে।

cert-error-mitm-mozilla = { -brand-short-name } অলাভজনক প্রতিষ্ঠান Mozilla দ্বারা সমর্থিত, এটি সম্পূর্ণ স্বাধীন সার্টিফিকেট অথোরিটি (CA) স্টোর পরিচালনা করে। CA স্টোরটি নিশ্চিত করতে সহায়তা করে যে সার্টিফিকেট অথোরিটি ব্যবহারকারী সুরক্ষার জন্য সর্বোত্তম অনুশীলনগুলি অনুসরণ করছে।

cert-error-mitm-connection = { -brand-short-name } ব্যবহারকারীর অপারেটিং সিস্টেম দ্বারা সরবরাহিত সার্টিফিকেটের চেয়ে কোনও সংযোগ নিরাপদ কিনা তা যাচাই করতে Mozilla CA স্টোরটি ব্যবহার করে। সুতরাং, যদি কোনও অ্যান্টিভাইরাস প্রোগ্রাম বা কোনও নেটওয়ার্ক Mozilla CA স্টোরটিতে নেই এমন কোনও CA দ্বারা জারি করা সুরক্ষা সার্টিফিকেটের সাথে সংযোগকে বাধা দেয়, তবে সংযোগটি অনিরাপদ হিসাবে বিবেচিত হবে।

cert-error-trust-unknown-issuer-intro = কেউ সাইটটির ছদ্মবেশ তৈরি করার চেষ্টা করতে পারে এবং আপনার চালিয়ে যাওয়া উচিত নয়।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = ওয়েবসাইটগুলি সার্টিফিকেটের মাধ্যমে তাদের পরিচয় প্রমাণ করে। { -brand-short-name } বিশ্বাস করে না { $hostname } কারণ এটির সার্টিফিকেট ইস্যুকারী অজানা, সার্টিফিকেটটি স্ব-স্বাক্ষরিত, অথবা সার্ভার সঠিক মধ্যবর্তী সার্টিফিকেট প্রেরণ করছে না।

cert-error-trust-cert-invalid = অকার্যকর CA সার্টিফিকেট দ্বারা সার্টিফিকেট নির্মিত হওয়ার ফলে সেটি বিশ্বস্ত নয়।

cert-error-trust-untrusted-issuer = সার্টিফিকেট নির্মাণকারীর সার্টিফিকেট বিশ্বস্ত না হওয়ার ফলে এই সার্টিফিকেট বিশ্বস্ত নয়।

cert-error-trust-signature-algorithm-disabled = সনদপত্রটি টি নির্ভরযোগ্য নয় কারন এটি যে স্বাক্ষর সমাধান পদ্ধতি (অ্যালগরিদিম) ব্যবহার করে স্বাক্ষরিত হয়েছে তা নিষ্ক্রিয় করা আছে কারন সমাধান পদ্ধতি (অ্যালগরিদিম) টি নিরাপদ নয়।

cert-error-trust-expired-issuer = সার্টিফিকেট নির্মাণকারীর মেয়াদ উত্তীর্ণ হওয়ার ফলে এই সার্টিফিকেট বিশ্বস্ত নয়।

cert-error-trust-self-signed = স্বয়ং স্বাক্ষরিত হওয়ার ফলে এই সার্টিফিকেটটি বিশ্বস্ত নয়।

cert-error-trust-symantec = GeoTrust, RapidSSL, Symantec, Thawte এবং VeriSign এর দেয়া প্রমাণপত্র এখন আর নিরাপদ বলে বিবেচ্য নয় কেননা প্রমাণপত্রের কর্তৃপক্ষ অতীতে সুরক্ষা পদ্ধতি অনুসরণ করতে ব্যর্থ হয়েছিলো।

cert-error-untrusted-default = সার্টিফিকেটের উৎস বিশ্বস্ত নয়।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে। { -brand-short-name } এই সাইটটির উপর আস্থা রাখে না কারণ এটি যে প্রমাণপত্র ব্যবহার করে তা { $hostname } এর জন্য বৈধ নয়।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে। { -brand-short-name } এই সাইটটির উপর আস্থা রাখে না কারণ এটি যে প্রমাণপত্র ব্যবহার করে তা { $hostname } এর জন্য বৈধ নয়। এই প্রশংসাপত্র শুধুমাত্র <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> এর জন্য বৈধ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে। { -brand-short-name } এই সাইটটির উপর আস্থা রাখে না কারণ এটি যে প্রমাণপত্র ব্যবহার করে তা { $hostname } এর জন্য বৈধ নয়। এই প্রশংসাপত্র শুধুমাত্র { $alt-name } এর জন্য বৈধ।

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে। { -brand-short-name } এই সাইটটির উপর আস্থা রাখে না কারণ এটি যে প্রমাণপত্র ব্যবহার করে তা { $hostname } এর জন্য বৈধ নয়। এই প্রশংসাপত্র শুধুমাত্র { $subject-alt-names } এর জন্য বৈধ।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে যা একটি নির্দিষ্ট সময়ের জন্য বৈধ। { $hostname } এর প্রমাণপত্রের মেয়াদ শেষ হয়েছে { $not-after-local-time }।

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = ওয়েবসাইটগুলো প্রমাণপত্রের মাধ্যমে তাদের পরিচয় প্রমাণ করে যা একটি নির্দিষ্ট সময়ের জন্য বৈধ। { $hostname } এর প্রমাণপত্র { $not-before-local-time } এর আগে বৈধ হবে না।

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = ভুল কোড: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = ওয়েবসাইটগুলি সার্টিফিকেটের মাধ্যমে তাদের পরিচয় প্রমাণ করে, যা সার্টিফিকেট অথোরিটি দ্বারা জারি করা হয়। বেশিরভাগ ব্রাউজারগুলি GeoTrust, RapidSSL, Symantec, Thawte, এবং VeriSign দ্বারা জারি করা সার্টিফিকেট আর বিশ্বাস করে না। { $hostname } এই অথোরিটিগুলির কোন একটির সার্টিফিকেট ব্যবহার করে এবং তাই ওয়েবসাইটটির পরিচয় প্রমাণ করা যায় না।

cert-error-symantec-distrust-admin = আপনি এই সমস্যা সম্পর্কে ওয়েবসাইট প্রশাসককে অবহিত করতে পারেন।

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP কঠোর পরিবহন নিরাপত্তা: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP পাবলিক কী পিন: { $hasHPKP }

cert-error-details-cert-chain-label = সার্টিফিকেট চেইন:

## Messages used for certificate error titles

connectionFailure-title = সংযোগ করতে ব্যর্থ
deniedPortAccess-title = এই ঠিকানাটি সীমাবদ্ধ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = হুমম। আমরা সাইটটি ঠিক খুঁজে পাচ্ছি না।
fileNotFound-title = ফাইল পাওয়া যায়নি
fileAccessDenied-title = ফাইলে প্রবেশাধিকার প্রত্যাখ্যাত হয়েছে
generic-title = ওহ্ হো!
captivePortal-title = নেটওয়ার্কে লগইন করুন
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = হ্যাঁ। ঠিকানাটি টিক দেখাচ্ছে না।
netInterrupt-title = সংযোগ বিঘ্নিত হয়েছে
notCached-title = ডকুমেন্ট মেয়াদউত্তীর্ণ হয়েছে
netOffline-title = অফলাইন মোড
contentEncodingError-title = কন্টেন্টের এনকোডিং-এ ত্রুটি
unsafeContentType-title = অনিরাপদ শ্রেণীর ফাইল
netReset-title = সংযোগ পুনঃনির্ধারণ করা হয়েছে
netTimeout-title = সংযোগের সময়সীমা উত্তীর্ণ হয়েছে
unknownProtocolFound-title = ঠিকানাটি বোঝা যায়নি
proxyConnectFailure-title = প্রক্সি সার্ভার সংযোগ প্রত্যাখ্যান করছে
proxyResolveFailure-title = প্রক্সি সার্ভার পাওয়া যায়নি
redirectLoop-title = পাতাটি সঠিকভাবে রিডিরেক্ট হচ্ছে না
unknownSocketType-title = সার্ভার থেকে অপ্রত্যাশিত উত্তর
nssFailure2-title = নিরাপদ সংযোগ স্থাপন করতে ব্যর্থ
corruptedContentError-title = ক্ষতিগ্রস্ত বিষয়বস্তুর ত্রুটি
remoteXUL-title = রিমোট XUL
sslv3Used-title = সুরক্ষিতভাবে কানেক্ট করতে ব্যার্থ
inadequateSecurityError-title = আপনার সংযোগ নিরাপদ নয়
blockedByPolicy-title = ব্লক করা পাতা
clockSkewError-title = আপনার কম্পিউটারের ঘড়ি ভুল
networkProtocolError-title = নেটওয়ার্ক প্রটোকল ত্রুটি
nssBadCert-title = সতর্কতা: সামনে সম্ভাব্য নিরাপত্তা ঝুঁকি রয়েছে
nssBadCert-sts-title = সংযুক্ত হয়নি: সম্ভাব্য নিরাপত্তা সমস্যা
certerror-mitm-title = নিরাপদে এই সাইটে সংযোগ প্রদানে সফ্টওয়্যার { -brand-short-name } কে বাঁধা দিচ্ছে
