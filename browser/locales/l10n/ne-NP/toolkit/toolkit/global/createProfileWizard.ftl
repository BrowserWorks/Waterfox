# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = प्रोफाइल विजार्ड सिर्जना गर्नुहोस्
    .style = width: 46em; height: 34em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] परिचय
       *[other] { create-profile-window.title } मा स्वागत छ
    }

profile-creation-explanation-1 = { -brand-short-name } मेरो सेटिङ् र प्राथमिकताको बारेमा भएका जानकारीहरू मेरो ब्यक्तिगत खातामा राख्नुहोस्।

profile-creation-explanation-2 = यदि तपाईँले { -brand-short-name } को प्रतिलिपि अरु प्रयोगकर्ताहरूसँग बाँडिरहनु भएको छ भने,तपाईँले प्रत्येक प्रयोगकर्ताको जानकारीहरू भिन्न राख्नलाई प्रोफाइलहरू प्रयोग गर्न सक्नुहुन्छ। यसो गर्नलाई प्रत्येक प्रयोगकर्ताले आफ्नो प्रोफाइल सिर्जना गर्नुपर्ने हुन्छ।

profile-creation-explanation-3 = यदि तपाईँ मात्र { -brand-short-name } को प्रतिलिपि प्रयोग गर्ने व्यक्ति हो भने तपाईँसँग कम्तिमा एउटा प्रोफाइल हुनुपर्ने हुन्छ। यदि तपाईँ चाहनुहुन्छ भने, आफ्ना लागि सेटिङ्हरूका भिन्न सेटहरू र प्राथमिकताहरू भण्डारण गर्नका लागि धेरै फ्रोफाइलहरू सिर्जना गर्न सक्नुहुन्छ। उदाहरणार्थ, तपाईँले व्यापारिक र व्यक्तिगत प्रयोगका लागि भिन्न प्रोफाइलहरू चाहनुभएको हुनसक्छ।

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] खाता बनाउन सुरु गर्न, जारी राख्नुहोस बटन मा क्लिक गर्नुहोस .
       *[other] खाता बनाउन सुरु गर्नु अगाडी लेखिएको बटन मा क्लिक गर्नु होस्
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] निष्कर्ष
       *[other] { create-profile-window.title } लाई सम्पन्न गर्दै
    }

profile-creation-intro = यदि तपाईँले धेरै प्रोफाइलहरू सिर्जना गर्नुभयो भने तपाईँ तिनीहरूलाई भिन्न प्रोफाइल नामहरूबाट भन्न सक्नुहुन्छ। तपाईँ यहाँ दिइएको नाम वा आफ्नै नाम प्रयोग गर्न सक्नुहुन्छ।

profile-prompt = नयाँ प्रोफाइल नाम प्रविष्ट गर्नुहोस्:
    .accesskey = E

profile-default-name =
    .value = पूर्वनिर्धारित प्रयोगकर्ता

profile-directory-explanation = तपाईँको प्रयोगकर्ता सेटिङ , प्राथमिकता र अरु प्रयोग कर्ता सम्बन्धित तथ्याङ्कहरू यहाँ सञ्चित गरिएको छ

create-profile-choose-folder =
    .label = & फोल्डर छान्नुहोस्
    .accesskey = C

create-profile-use-default =
    .label = पूर्वनिर्धारित फोल्डर प्रयोग गर्नुहोस्
    .accesskey = U
