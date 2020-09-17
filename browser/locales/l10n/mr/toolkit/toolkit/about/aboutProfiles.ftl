# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = प्रोफाइल्स बद्दल
profiles-subtitle = हे पृष्ठ आपल्याला प्रोफाइल व्यवस्थापनात मदत करेल. प्रत्येक प्रोफाइल हे एक वेगळं जग आहे ज्यात इतिहास, वाचनखूण, सेटिंग्स आणि ॲड-ऑन्स स्वतंत्र असतात.
profiles-create = एक नवीन प्रोफाइल बनवा
profiles-restart-title = पुनःसुरु
profiles-restart-in-safe-mode = ॲड-ऑन्स निष्क्रिय करुन पुनःसुरू करा…
profiles-restart-normal = साधारणरित्या पुनःसुरु करा…

# Variables:
#   $name (String) - Name of the profile
profiles-name = प्रोफाइल: { $name }
profiles-is-default = पूर्वनिर्धारित प्रोफाइल
profiles-rootdir = मुख्य संचयिका

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = स्थानिक संचयिका
profiles-current-profile = ही प्रोफाइल वापरात आहे आणि काढणे शक्य नाही.

profiles-rename = परत नामकरण करा
profiles-remove = काढा
profiles-set-as-default = पूर्वनिर्धारित प्रोफाइल म्हणून निश्चित करा
profiles-launch-profile = नवीन ब्राउझरमध्ये प्रोफाइल लाँच करा

profiles-yes = होय
profiles-no = नाही

profiles-rename-profile-title = प्रोफाइलचे पुनःनामांकरण करा
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = प्रोफाइल पुनःनामांकरण { $name }

profiles-invalid-profile-name-title = अवैध प्रोफाइल नाव
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }" हे प्रोफाइलचे नाव अनुमत नाही.

profiles-delete-profile-title = प्रोफाइल काढा
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    प्रोफाइल काढून टाकल्यास उपलब्ध यादीतून प्रोफाइल काढूण टाकले जाईल व पुन्हा प्राप्त केले जाऊ शकत नाही.
    आपण प्रोफाइल माहिती फाइल, सेटिंग्स, प्रमाणपत्रे व अन्य वापरकर्ता-संबंधित माहितीसह काढून टाकण्याकरीता निवडू शकता. ह्या पर्यायामुळे संचयीका "{ $dir }" काढूण टाकली जाईल व पुन्हा प्राप्त होणार नाही.
    आपणाला प्रोफाइल माहिती फाइल काढायची?
profiles-delete-files = फाइल्स काढा
profiles-dont-delete-files = फाइल्स काढू नका

profiles-delete-profile-failed-title = त्रुटी
profiles-delete-profile-failed-message = ही प्रोफाइल हटविण्याचा प्रयत्न करताना त्रुटी आढळली.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder मध्ये दाखवा
        [windows] फोल्डर उघडा
       *[other] निर्देशिका उघडा
    }
