# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = पूर्वनिर्धारित डेव्हलपर साधने

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * सध्याच्या साधनपेटी लक्ष्यकरिता समर्थीत नाही

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = ॲड-ऑन्स् सतर्फे इन्स्टॉल केलेले डेव्हलपर साधने

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = उपलब्ध साधनपेटी बटन्स

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = थीम्स

## Inspector section

# The heading
options-context-inspector = इंस्पेक्टर

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = ब्राउझर शैली दाखवा
options-show-user-agent-styles-tooltip =
    .title = याला सुरू करून ब्राउझरतर्फे लोड करण्याजोगी पूर्वनिर्धारित शेली दाखवले जाईल.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM गुणधर्म संकुचित करा
options-collapse-attrs-tooltip =
    .title = इन्स्पेक्टर चे लांब गुणधर्म संकुचित करा

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = पूर्वनिर्धारित रंग एकक
options-default-color-unit-authored = लेखका प्रमाणे
options-default-color-unit-hex = हेक्स
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = रंगांचे नाव

## Style Editor section

# The heading
options-styleeditor-label = शैली संपादक

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS स्वपूर्ण करा
options-stylesheet-autocompletion-tooltip =
    .title = स्टाइल संपादकात टाइप करत असल्याप्रमाणे CSS गुणधर्म, मूल्य आणि सिलेक्टर्स स्वपूर्ण करा

## Screenshot section

# The heading
options-screenshot-label = स्क्रीनशॉट वर्तन

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = क्लिपबोर्ड वर स्क्रीनशॉट घ्या
options-screenshot-clipboard-tooltip =
    .title = स्क्रीनशॉट क्लिपबोर्ड वर साठवा

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = कॅमेरा शटर चा ध्वनी चालवा
options-screenshot-audio-tooltip =
    .title = स्क्रीनशॉट घेताना कॅमेरा चा ध्वनी चालवा

## Editor section

# The heading
options-sourceeditor-label = संपादक प्राधान्यक्रम

options-sourceeditor-detectindentation-tooltip =
    .title = स्रोत अंतर्भुत माहितीवर आधारित इंडेंटेशन ओळखा
options-sourceeditor-detectindentation-label = इंडेंटेशन ओळखा
options-sourceeditor-autoclosebrackets-tooltip =
    .title = बंद कंस स्वतः अंतर्भुत करा
options-sourceeditor-autoclosebrackets-label = कंस स्व बंद करा
options-sourceeditor-expandtab-tooltip =
    .title = टॅब की ऐवजी स्पेसेस की चा वापर करा
options-sourceeditor-expandtab-label = मोकळ्या जागेचा वापर समासकरिता करा
options-sourceeditor-tabsize-label = टॅब आकार
options-sourceeditor-keybinding-label = किबाइंडिंग्ज
options-sourceeditor-keybinding-default-label = पूर्वनिर्धारीत

## Advanced section

# The heading
options-context-advanced-settings = प्रगत सेटिंग्ज

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP कॅशे निष्क्रिय करा (साधनपेटी खुले असतेवेळी)
options-disable-http-cache-tooltip =
    .title = हा पर्याय सुरु केल्यामुळे साधनपेटी उघडे असलेले सर्व टॅब्ससाठी HTTP कॅशे निष्क्रिय होईल. Service Workers वर याचा परिणाम होणार नाही.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript * बंद करा
options-disable-javascript-tooltip =
    .title = सध्याच्या टॅबकरिता ह्या पर्यायची निवड केल्यास JavaScript बंद होईल. टॅब किंवा साधनपेटी बंद केल्यास ह्या सेटिंगकडे दुर्लक्ष केले जाईल.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = ब्राउझर chrome आणि ॲड-ऑन डिबगिंग साधनपेट्या सक्रीय करा
options-enable-chrome-tooltip =
    .title = हे पर्याय सुरु केल्यामुळे आपल्याला खूप डेवलपर साधने ब्राउझर मध्ये वापरता येतील (साधने > वेब डेवलपर > साधनपेटी) आणि ॲड-ऑन्स् व्यवस्थापकाहून ॲड-ऑन्स् डीबग करा.

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = दूरस्त डिबगिंग सुरू करा

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Service Workers, HTTP वर सक्रिय करा (जेव्हा साधनपेटी उघडी असेल)
options-enable-service-workers-http-tooltip =
    .title = हा पर्याय सुरू केल्याने, असे टॅब्स ज्यांची साधनपेटी उघडी आहे त्यासाठी, HTTP वरील service workers सुरू केले जाईल.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = सोर्स नकाशे सक्षम करा
options-source-maps-tooltip =
    .title = आपण हा पर्याय स्त्रोत सक्षम केल्यास साधनांमध्ये मॅप केला जाईल.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * फक्त सध्याच्या सत्रकरिता, पृष्ठ पुन्हा लोड करते

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko प्लॅटफॉर्म माहिती दाखवा
options-show-platform-data-tooltip =
    .title = हा पर्याय सुरू केल्यास, JavaScript प्रोफाइलर रिपोर्ट्समध्ये खालील समाविष्ट होईल Gecko प्लॅटफॉर्म सिम्बल्स
