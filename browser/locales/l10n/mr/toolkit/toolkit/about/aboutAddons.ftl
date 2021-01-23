# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = ॲड-ऑन्स् व्यवस्थापक

addons-page-title = ॲड-ऑन्स् व्यवस्थापक

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = या प्रकारचे ॲड-ऑन्स् प्रतिष्ठापीत नाही

list-empty-available-updates =
    .value = सुधारणा आढळले नाही

list-empty-recent-updates =
    .value = आपण नुकतेच कोणतेही ॲड-ऑन्स् सुधारीत केले नाही

list-empty-find-updates =
    .label = सुधारणांकरीता तपासणी करा

list-empty-button =
    .label = ॲड-ऑन्स् विषयी अधिक शिका

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } पर्याय
       *[other] { -brand-short-name } पसंती
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } पर्याय
           *[other] { -brand-short-name } पसंती
        }

show-unsigned-extensions-button =
    .label = काही एक्सटेंशन पडताळले जाऊ शकले नाहीत

show-all-extensions-button =
    .label = सर्व एक्सटेंशन दर्शवा

cmd-show-details =
    .label = आणखी माहिती दाखवा
    .accesskey = S

cmd-find-updates =
    .label = सुधारणा शोधा
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] पर्याय
           *[other] प्राधान्यक्रम
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = दृष्य कल्पना लागू करा
    .accesskey = W

cmd-disable-theme =
    .label = दृष्य कल्पना लागू करू नका
    .accesskey = W

cmd-install-addon =
    .label = इंस्टॉल करा
    .accesskey = I

cmd-contribute =
    .label = योगदान करा
    .accesskey = C
    .tooltiptext = या ॲड-ऑनच्या विकासकरीता योगदान करा

detail-version =
    .label = आवृत्ती

detail-last-updated =
    .label = शेवटच्यावेळी सुधारीत केलेले

detail-contributions-description = छोटेसे योगदान करून या ॲड-ऑनच्या डेव्हलपरने ॲड-ऑनच्या विकाससाठी मदत पुरवण्याची विनंती केली आहे.

detail-update-type =
    .value = स्वयं सुधारणा

detail-update-default =
    .label = पूर्वनिर्धारीत
    .tooltiptext = पूर्वनिर्धारीत असल्यावरच सुधारणा स्वयं प्रतिष्ठापीत करा

detail-update-automatic =
    .label = सुरू करा
    .tooltiptext = स्वयं सुधारणा प्रतिष्ठापीत करा

detail-update-manual =
    .label = बंद करा
    .tooltiptext = स्वयं सुधारणा प्रतिष्ठापीत करू नका

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = खाजगी पटलामध्ये चालवा

detail-private-browsing-on =
    .label = परवानगी द्या
    .tooltiptext = खाजगी ब्राउझिंगमध्ये सक्षम करा

detail-private-browsing-off =
    .label = परवानगी देऊ नका
    .tooltiptext = खाजगी ब्राउझिंगमध्ये अक्षम करा

detail-home =
    .label = मुख्यपृष्ठ

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = ॲड-ऑन प्रोफाइल

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = सुधारणांकरिता तपासणी करा
    .accesskey = f
    .tooltiptext = या ॲड-ऑनकरीता सुधारणांकरीता तपासणी करा

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] पर्याय
           *[other] प्राधान्यक्रम
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] या ॲड-ऑनचे पर्याय बदला
           *[other] या ॲड-ऑनचा प्राधान्यक्रम बदला
        }

detail-rating =
    .value = गुणवत्ताश्रेणी

addon-restart-now =
    .label = आत्ता पुन्हा सुरू करा

disabled-unsigned-heading =
    .value = काही ॲड-ऑन्स् अक्षम केले गेले आहेत

disabled-unsigned-description = खालील अॅड-ऑन { -brand-short-name } मध्ये वापरण्यासाठी पडताळले गेले नाहीत. आपण करू शकता <label data-l10n-name="find-addons">पुनर्बदल शोधा</label> किंवा विकासकाला ते पडताळून घ्यायला सांगा.

disabled-unsigned-learn-more = आपणास ऑनलाईन सुरक्षित कसे ठेवायचे याबाबत आमच्या प्रयत्नांसंबंधी अधिक जाणून घ्या.

disabled-unsigned-devinfo = ज्यांना त्यांचे अॅड-ऑन पडताळून घेण्यात स्वारस्य आहे असे विकासक ते करू शकतात. त्यासाठी वाचा<label data-l10n-name="learn-more">मॅन्युअल</label>.

plugin-deprecation-description = काही शोधताय काय? काही प्लगईन, { -brand-short-name } आता समर्थित नाहीत. <label data-l10n-name="learn-more">अधिक जाणा.</label>

legacy-warning-show-legacy = सर्व वारसा विस्तार दर्शवा

legacy-extensions =
    .value = वारसा विस्तार

legacy-extensions-description = हे विस्तार सध्याच्या { -brand-short-name } मानकांमध्ये बसत नाही म्हणून ते निष्क्रिय करण्यात आले आहेत. <label data-l10n-name="legacy-learn-more">ॲड-ऑन्सबद्दल बदल जाणा</label>

addon-category-extension = एक्सटेंशन
addon-category-extension-title =
    .title = एक्सटेंशन
addon-category-theme = थीम
addon-category-theme-title =
    .title = थीम
addon-category-plugin = प्लगईन
addon-category-plugin-title =
    .title = प्लगईन
addon-category-dictionary = शब्दकोष
addon-category-dictionary-title =
    .title = शब्दकोष
addon-category-locale = भाषा
addon-category-locale-title =
    .title = भाषा
addon-category-available-updates = उपलब्ध सुधारणा
addon-category-available-updates-title =
    .title = उपलब्ध सुधारणा
addon-category-recent-updates = नुकतीच सुधारणा
addon-category-recent-updates-title =
    .title = नुकतीच सुधारणा

## These are global warnings

extensions-warning-safe-mode = सेफ मोडद्वारे सर्व ॲड-ऑन्स् बंद केले आहे.
extensions-warning-check-compatibility = ॲड-ऑन सहत्वता तपासणी बंद केली आहे. आपल्याकडे असहत्व ॲड-ऑन्स् असू शकतात.
extensions-warning-check-compatibility-button = सुरू करा
    .title = ॲड-ऑन सहत्वता तपासणी सुरू करा
extensions-warning-update-security = ॲड-ऑन सुधारणा सुरक्षा तपासणी बंद केले आहे. सुधारणा करतेवेळी सतर्क रहा.
extensions-warning-update-security-button = सुरू करा
    .title = ॲड-ऑन सुधारणा सुरक्षा तपासणी सुरू करा


## Strings connected to add-on updates

addon-updates-check-for-updates = सुधारणांकरीता तपासणी करा
    .accesskey = C
addon-updates-view-updates = नुकत्याच सुधारणांचे दृष्य
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = ॲड-ऑन्स् स्वयं सुधारित करा
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = स्वयं सुधारणा करण्यासाठी सर्व ॲड-ऑन्स् मूळस्थितीत आणा
    .accesskey = R
addon-updates-reset-updates-to-manual = सुधारणा स्वहस्ते करण्यासाठी सर्व ॲड-ऑन्स् मूळस्थितीत आणा
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = ॲड-ऑन्स् सुधारीत करत आहे
addon-updates-installed = आपले ॲड-ऑन्स् सुधारीत केले.
addon-updates-none-found = सुधारणा आढळले नाही
addon-updates-manual-updates-found = उपलब्ध सुधारणांचे दृष्य

## Add-on install/debug strings for page options menu

addon-install-from-file = फाइलपासून ॲड-ऑन इंस्टॉल करा…
    .accesskey = I
addon-install-from-file-dialog-title = प्रतिष्ठापनकरीता ॲड-ऑन नीवडा
addon-install-from-file-filter-name = ॲड-ऑन्स्
addon-open-about-debugging = अॅड-ऑनस डीबग करा
    .accesskey = b

## Extension shortcut management

shortcuts-input =
    .placeholder = एक शॉर्टकट टाइप करा

shortcuts-pageAction = पृष्ठ क्रिया सक्रिय करा

shortcuts-letter = एक अक्षर टाइप करा

shortcuts-card-collapse-button = कमी दर्शवा

header-back-button =
    .title = मागे जा

## Recommended add-ons page

discopane-notice-learn-more = अधिक जाणा

# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = व्‍यवस्‍थापित करा
find-more-addons = अधिक ऍड-ऑन्स शोधा

## Add-on actions

remove-addon-button = काढून टाका
disable-addon-button = निष्क्रिय
enable-addon-button = सक्रिय
details-addon-button = तपशील
release-notes-addon-button = प्रकाशन टीपा
permissions-addon-button = परवानग्या

ask-to-activate-button = सक्रिय करण्यास विचारा
always-activate-button = नेहमी सक्रिय करा
never-activate-button = कधीही सक्रिय करू नका

addon-detail-author-label = लेखक
addon-detail-version-label = आवृत्ती
addon-detail-homepage-label = मुख्यपृष्ठ
addon-detail-rating-label = गुणवत्ताश्रेणी

## Pending uninstall message bar

pending-uninstall-undo-button = पूर्ववत् करा

addon-detail-updates-radio-default = पूर्वनिर्धारीत
addon-detail-updates-radio-on = चालू
addon-detail-updates-radio-off = बंद
addon-detail-update-check-label = सुधारणांकरीता तपासणी करा
install-update-button = अद्ययावत करा

addon-detail-private-browsing-allow = परवानगी द्या
addon-detail-private-browsing-disallow = परवानगी देऊ नका

available-updates-heading = उपलब्ध सुधारणा
recent-updates-heading = नुकतीच सुधारणा

release-notes-loading = लोड करत आहे…
release-notes-error = माफ करा, परंतु प्रकाशन टिपा लोड करतेवेळी त्रुटी आढळली.

addon-permissions-empty = या विस्तारास कोणत्याही परवानगीची आवश्यकता नाही

recommended-extensions-heading = शिफारस केलेले विस्तार

## Page headings

extension-heading = विस्तार व्यवस्थापित करा
theme-heading = थीम व्यवस्थापित करा
plugin-heading = प्लगइन व्यवस्थापित करा
dictionary-heading = शब्दकोश व्यवस्थापित करा
locale-heading = भाषा व्यवस्थापित करा
shortcuts-heading = विस्तार शॉर्टकट व्यवस्थापित करा

addon-page-options-button =
    .title = सर्व ॲड-ऑन्स् करीता साधने
