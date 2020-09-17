# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = प्रोफ़ाइल परिचय
profiles-subtitle = यह पृष्ठ आपको अपने प्रोफाइल का प्रबंधन करने में मदद करता है. प्रत्येक प्रोफ़ाइल अलग है जिसमे अलग इतिहास, पुस्तचिह्न,विन्यास और add-ons शामिल है।
profiles-create = नया प्रोफ़ाइल बनाएँ
profiles-restart-title = पुनः आरंभ करें
profiles-restart-in-safe-mode = निष्क्रिय सहयुक्तियों के साथ पुनः आरंभ करें…
profiles-restart-normal = सामान्य रूप से पुनः आरंभ करें...
profiles-flush-fail-title = परिवर्तन सहेजे नहीं गए
profiles-flush-conflict = { profiles-conflict }
profiles-flush-restart-button = { -brand-short-name } पुनः आरंभ करें

# Variables:
#   $name (String) - Name of the profile
profiles-name = प्रोफ़ाइल: { $name }
profiles-is-default = सुनिश्चित प्रोफ़ाइल
profiles-rootdir = मूल निदेशिका

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = स्थानीय निर्देशिका
profiles-current-profile = यह प्रोफाइल प्रयोग में है और इसे हटाया नहीं जा सकता.
profiles-in-use-profile = यह प्रोफ़ाइल किसी अन्य अनुप्रयोग द्वारा उपयोग में है तथा इसे मिटाया नहीं जा सकता है.

profiles-rename = पुनर्नामकरण
profiles-remove = हटाएँ
profiles-set-as-default = मूलभूत प्रोफ़ाइल के रूप में स्थापित करे
profiles-launch-profile = प्रोफ़ाइल नये ब्राउज़र में प्रक्षेपित करें

profiles-cannot-set-as-default-title = तयशुदा सेट करने में असमर्थ
profiles-cannot-set-as-default-message = { -brand-short-name } के लिए तयशुदा प्रोफ़ाइल को नहीं बदला जा सकता है।

profiles-yes = हाँ
profiles-no = नहीं

profiles-rename-profile-title = प्रोफाइल का पुनर्नामकरण करें
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = प्रोफ़ाइल का नाम बदलें { $name }

profiles-invalid-profile-name-title = अवैध प्रोफ़ाइल नाम
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = प्रोफ़ाइल नाम "{ $name }" स्वीकृत नहीं है.

profiles-delete-profile-title = प्रोफाइल हटाये
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    किसी प्रोफाइल को मिटाना प्रोफाइल को उपलब्ध प्रोफाइलों की सूची से मिटा देगा और असंपादित नहीं किया जा सकता है.
    आप प्रोफाइल आंकड़ा फाइलों को मिटाने के लिए चुन सकते हैं, अपने समायोजन, प्रमाणपत्र और दूसरे उपयोक्ता-संबंधित आंकड़ा के साथ. यह विकल्प "{ $dir }" फोल्डर को मिटाएगा और पहले जैसा नहीं किया जा सकता है.
    क्या आप प्रोफाइल आंकड़ा फाइलें मिटाना चाहेंगे?
profiles-delete-files = दस्तावेज़ मिटाएँ
profiles-dont-delete-files = दस्तावेजों को मत मिटाएँ

profiles-delete-profile-failed-title = त्रुटि
profiles-delete-profile-failed-message = इस प्रोफ़ाईल को मिटाते समय कोई त्रुटि उत्पन्न हुयी.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder में दिखाएँ
        [windows] खुले फ़ोल्डर
       *[other] मुक्त निर्देशिका
    }
