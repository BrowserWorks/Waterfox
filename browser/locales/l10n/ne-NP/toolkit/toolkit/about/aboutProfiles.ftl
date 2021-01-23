# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = प्रोफाइलहरूको बारेमा
profiles-subtitle = यस पृष्ठले तपाईँको प्रोफाईल व्यवस्थापन गर्न सहयोग गर्छ। हरेक प्रोफाईल एउटा अलग ठाउँ हो जसमा छुट्टै इतिहास, पुस्तकचिनो, सेटिङ्, र एडअनहरू हुन्छ।
profiles-create = नयाँ प्रोफाइल सिर्जना गर्नुहोस्
profiles-restart-title = पुनःसुचारु गर्नुहोस्
profiles-restart-in-safe-mode = एडअनहरू असक्षम पारेर पुनः सुरु गर्नुहोस...
profiles-restart-normal = सामान्यरूपमा पुनःसुचारु गर्नुहोस्…

# Variables:
#   $name (String) - Name of the profile
profiles-name = प्रोफाइल: { $name }
profiles-is-default = पूर्वनिर्धारित प्रोफाइल
profiles-rootdir = रुट डाइरेक्टरी

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = स्थानीय डारेक्टरी
profiles-current-profile = यो प्रोफाइल प्रयोगमा छ र हटाउन सकिँदैन ।

profiles-rename = पुनः नामकरण गर्नुहोस्
profiles-remove = हटाउनुहोस्
profiles-set-as-default = पूर्वनिर्धारितका प्रोफाइलको रूपमा सेट गर्नुहोस्
profiles-launch-profile = यो प्रोफाईल नयाँ ब्राउजरमा खोल्नुहोस

profiles-yes = हो
profiles-no = होेइन

profiles-rename-profile-title = प्रोफाइलको पुनःनामाकरण गर्नुहोस्
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = प्रोफाइल { $name } पुनः नामाकरण गर्नुहोस्

profiles-invalid-profile-name-title = अमान्य प्रोफाइल नाम
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = प्रोफाइल “{ $name }” राख्न अनुमति छैन ।

profiles-delete-profile-title = प्रोफाइल मेट्नुहोस्
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    प्रोफाइल मेटाउँदा उपलब्ध प्रोफाइल को सूचीबाट प्रोफाइल हटाईन्छ र पूर्वस्थिति गर्न सकिँदैन।
    तपाईँ आफ्नो सेटिङहरू, प्रमाणपत्रहरू र अन्य प्रयोगकर्ता सम्बन्धित डाटा सहित प्रोफाइल डाटा फाइल मेटाउने चयन गर्न सक्नु हुनेछ। यो विकल्पले “{ $dir }” फोल्डर हटाउँछ र पूर्वस्थिति गर्न सकिँदैन। 
    तपाईँ प्रोफाइल डाटा फाइलहरू मेट्न चाहनुहुन्छ?
profiles-delete-files = फाइलहरू मेट्नुहोस्
profiles-dont-delete-files = फाइलहरू नमेट्नुहोस्

profiles-delete-profile-failed-title = त्रुटि


profiles-opendir =
    { PLATFORM() ->
        [macos] फाइन्डरमा देखाउनुहोस्
        [windows] फोल्डर खोल्नुहोस्
       *[other] डाइरेक्टरी खोल्नुहोस्
    }
