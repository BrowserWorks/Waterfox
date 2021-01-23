# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name } के लिए रिपोर्ट करें

abuse-report-title-extension = इस विस्तार की रिपोर्ट { -vendor-short-name }
abuse-report-title-theme = इस थीम को { -vendor-short-name } रिपोर्ट करें
abuse-report-subtitle = मुद्दा क्या है?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = <a data-l10n-name="author-name"> { $author-name } </a> द्वारा

abuse-report-learnmore =
    पता लगाएँ कि क्या समस्या है?
    <a data-l10n-name="learnmore-link"> रिपोर्टिंग एक्सटेंशन और थीम के बारे में और जानें </a>

abuse-report-submit-description = समस्या का वर्णन करें (वैकल्पिक)
abuse-report-textarea =
    .placeholder = यदि हमारे पास कोई समस्या है तो हमें समस्या का समाधान करना आसान है। कृपया बताएं कि आप क्या अनुभव कर रहे हैं। वेब को स्वस्थ रखने में हमारी मदद करने के लिए धन्यवाद।
abuse-report-submit-note =
    नोट: व्यक्तिगत जानकारी (जैसे नाम, ईमेल पता, फ़ोन नंबर, भौतिक पता) शामिल नहीं करें।
    { -vendor-short-name } इन रिपोर्टों का एक स्थायी रिकॉर्ड रखता है।

## Panel buttons.

abuse-report-cancel-button = रद्द करें
abuse-report-next-button = अगला
abuse-report-goback-button = वापस जाएँ
abuse-report-submit-button = जमा

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name="addon-name">{ $addon-name }</span> रद्द करने के लिए रिपोर्ट करें।
abuse-report-messagebar-submitting = <span data-l10n-name="addon-name">{ $addon-name }</span> के लिए रिपोर्ट भेजना।
abuse-report-messagebar-submitted = रिपोर्ट प्रस्तुत करने के लिए धन्यवाद। क्या आप <span data-l10n-name="addon-name">{ $addon-name }</span> निकालना चाहते हैं?
abuse-report-messagebar-submitted-noremove = रिपोर्ट प्रस्तुत करने के लिए धन्यवाद।
abuse-report-messagebar-removed-extension = रिपोर्ट प्रस्तुत करने के लिए धन्यवाद। आपने <span data-l10n-name="addon-name">{ $addon-name }</span>एक्सटेंशन को हटा दिया है।
abuse-report-messagebar-removed-theme = रिपोर्ट प्रस्तुत करने के लिए धन्यवाद। आपने <span data-l10n-name="addon-name">{ $addon-name }</span> विषय को हटा दिया है।
abuse-report-messagebar-error = <span data-l10n-name="addon-name">{ $addon-name }</span> के लिए रिपोर्ट भेजने में एक त्रुटि हुई थी।
abuse-report-messagebar-error-recent-submit = <span data-l10n-name="addon-name">{ $addon-name }</span> की रिपोर्ट इसलिए नहीं भेजी गई क्योंकि एक अन्य रिपोर्ट हाल ही में प्रस्तुत की गई थी।

## Message bars actions.

abuse-report-messagebar-action-remove-extension = हां, इसे हटा दें
abuse-report-messagebar-action-keep-extension = नहीं, मैं इसे रखूँगा
abuse-report-messagebar-action-remove-theme = हां, इसे हटा दें
abuse-report-messagebar-action-keep-theme = नहीं, मैं इसे रखूँगा
abuse-report-messagebar-action-retry = पुनः कोशिश करें
abuse-report-messagebar-action-cancel = रद्द करें

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-example = उदाहरण: इंजेक्ट किया गया मैलवेयर या डेटा चुराया गया

abuse-report-spam-example = उदाहरण: वेबपृष्ठों पर विज्ञापन डालें

abuse-report-settings-suggestions = विस्तार की रिपोर्ट करने से पहले, आप अपनी सेटिंग्स बदलने की कोशिश कर सकते हैं:
abuse-report-settings-suggestions-search = अपनी डिफ़ॉल्ट खोज सेटिंग बदलें
abuse-report-settings-suggestions-homepage = अपना मुखपृष्ठ और नया टैब बदलें

abuse-report-deceptive-example = उदाहरण: भ्रामक वर्णन या कल्पना

abuse-report-broken-example = उदाहरण: विशेषताएं धीमी हैं, उपयोग करना कठिन है, या काम नहीं कर रहा है; वेबसाइटों के हिस्से लोड या असामान्य नहीं दिखेंगे
abuse-report-broken-suggestions-extension =
    ऐसा लगता है कि आपने बग की पहचान कर ली है। सबसे अच्छी तरह से यहाँ एक रिपोर्ट प्रस्तुत करने के अलावा
    एक कार्यक्षमता समस्या को हल करने के लिए विस्तार डेवलपर से संपर्क करना है।
    डेवलपर जानकारी प्राप्त करने के लिए <a data-l10n-name="support-link"> एक्सटेंशन की वेबसाइट पर जाएं </a>।
abuse-report-broken-suggestions-theme =
    ऐसा लगता है कि आपने बग की पहचान कर ली है। सबसे अच्छी तरह से यहाँ एक रिपोर्ट प्रस्तुत करने के अलावा
    एक कार्यक्षमता समस्या को हल करने के लिए विषय डेवलपर से संपर्क करना है।
    डेवलपर जानकारी प्राप्त करने के लिए <a data-l10n-name="support-link"> थीम की वेबसाइट </a> पर जाएं।

abuse-report-policy-suggestions =
    नोट: कॉपीराइट और ट्रेडमार्क मुद्दों को एक अलग प्रक्रिया में सूचित किया जाना चाहिए।
    <a data-l10n-name="report-infringement-link"> इन निर्देशों का उपयोग करें </a> से
    समस्या की रिपोर्ट करें।

abuse-report-unwanted-example = उदाहरण: एक एप्लिकेशन ने इसे मेरी अनुमति के बिना स्थापित किया

abuse-report-other-reason = कुछ और

