# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = सुनिश्चित डेवलपर औज़ार

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * मौजूदा औज़ारपेटी लक्ष्य के लिए समर्थित नहीं

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = सहयुक्ति द्वारा संस्थापित डेवलेपर औज़ार

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = उपलब्ध उपकरण बॉक्स बटन

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = प्रसंग

## Inspector section

# The heading
options-context-inspector = इंस्पेक्टर

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = ब्राउज़र शैलियाँ दिखाएँ
options-show-user-agent-styles-tooltip =
    .title = इस चालू करना तयशुदा शैली दिखाएगा जो ब्राउज़र के द्वारा लोड किया हुआ है.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM को भागों मैं तोड़ें
options-collapse-attrs-tooltip =
    .title = निरीक्षक में बड़ी विशेषताओं को छाँटें

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = तयशुदा रंग इकाई
options-default-color-unit-authored = लेखक जैसा
options-default-color-unit-hex = हेक्स
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = रंग नाम

## Style Editor section

# The heading
options-styleeditor-label = शैली संपादक

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = स्वतःपूर्ण CSS
options-stylesheet-autocompletion-tooltip =
    .title = स्वतःपूर्ण CSS विशेषता, मान और शैली संपादक में चयनक आपके टाइप करने के दौरान

## Screenshot section

# The heading
options-screenshot-label = स्क्रीनशॉट व्यवहार

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = स्क्रीनशॉट क्लिपबोर्ड पर भेजें
options-screenshot-clipboard-tooltip =
    .title = स्क्रीनबोर्ड को सीधे क्लिपबोर्ड पर सहेजता है

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = कैमरा शटर ध्वनि चलाएँ
options-screenshot-audio-tooltip =
    .title = स्क्रीनशॉट लेते समय कैमरा ऑडियो ध्वनि सक्षम करता है

## Editor section

# The heading
options-sourceeditor-label = संपादक वरीयताएँ

options-sourceeditor-detectindentation-tooltip =
    .title = स्रोत सामग्री के आधार पर हाशिया का अनुमान करें
options-sourceeditor-detectindentation-label = हाशिया जाँचें
options-sourceeditor-autoclosebrackets-tooltip =
    .title = बंद कोष्ठक स्वतः डालें
options-sourceeditor-autoclosebrackets-label = कोष्ठक स्वतःबंद
options-sourceeditor-expandtab-tooltip =
    .title = टैब वर्ण के बदले स्थान का उपयोग करें
options-sourceeditor-expandtab-label = स्थान के उपयोग से हाशिया
options-sourceeditor-tabsize-label = टैब आकार
options-sourceeditor-keybinding-label = कीबाइंडिंग
options-sourceeditor-keybinding-default-label = तयशुदा

## Advanced section

# The heading
options-context-advanced-settings = उन्नत सेटिंग...

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP कैश निष्क्रिय करें (जब औज़ारपेटी खुला हो)
options-disable-http-cache-tooltip =
    .title = इस विकल्प को चालू करना उन सारे टैब्स के लिए HTTP कैश को अक्षम कर देगा जिनके लिए औजारपेटी खुला है. सेवाकर्मी इस विकल्प द्वारा प्रभावित नहीं हैं.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = निष्क्रिय करें JavaScript *
options-disable-javascript-tooltip =
    .title = इस विकल्प को बंद करना जावास्क्रिप्ट को निष्क्रिय कर देगा मौजूदा टैब के लिए. यदि वह टैब या औज़ारपेटी बंद है तो तो यह सेटिंग विस्मृत कर दिया जाएगा.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = ब्राउज़र क्रोम और ऐड-ऑन डिबगिंग टूलबॉक्स को सक्षम करें
options-enable-chrome-tooltip =
    .title = इस विकल्प को चालू करना आपको ब्राउज़र संदर्भ में कई डेवलपर टूल को उपयोग करने की स्वीकृति देगा(Tools > Web Developer > Browser Toolbox के द्वारा) और सहयुक्ति प्रबंधक से सहयुक्ति डिबग करेगा

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = (जब टूलबॉक्स खुले हों) HTTP पर श्रमिक सेवा सक्षम करें
options-enable-service-workers-http-tooltip =
    .title = इस विकल्प को सक्रिय करने से HTTP पर श्रमिक सेवा सक्रिय हो जाएगी उन सभी टैब के लिए जिनमें औजारपेटी खुली होगी |

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = स्रोत नक्शा सक्षम करें
options-source-maps-tooltip =
    .title = यदि आप इस विकल्प को सक्षम करते हैं तो सूत्रों को साधनों में मैप किया जाएगा.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * वर्तमान सत्र केवल, फिर से पृष्ठ लोड करता है

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = दिखाएँ गेक्को मंच डेटा
options-show-platform-data-tooltip =
    .title = आप इस विकल्प को सक्षम जावास्क्रिप्ट प्रोफाइलर रिपोर्टों गेक्को मंच प्रतीकों शामिल होंगे.
