# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = प्रोफाइल विज़ार्ड बनायें
    .style = width: 75em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] प्रस्तावना
       *[other] { create-profile-window.title } में आपका स्वागत है
    }

profile-creation-explanation-1 = { -brand-short-name }अपनी सैटिंग की जानकारी एवं वरीयतायें आपके निजी प्रोफाइल में सहेजता है.

profile-creation-explanation-2 = यदि आप { -brand-short-name } की प्रति को अन्य उपयोक्ता के साथ साझा कर रहें हैं तो आप प्रत्येक उपयोक्ता की जानकारी अलग रखने के लिये प्रोफाइल का उपयोग कर सकते हैं. ऐसा करने के लिये प्रत्येक उपयोक्ता को अपना प्रोफाइल बनाना पड़ेगा.

profile-creation-explanation-3 = यदि आप { -brand-short-name } की यह प्रति का उपयोग करने वाले एक ही  व्यक्ति हैं , आपके पास कम से कम एक प्रोफाइल का होना आवश्यक है. यदि आप चाहते हैं तो आप विभिन्न सैटिंग के सैट एवं वरीयतायें को सहेजने के लिए स्वयं अनेक प्रोफाइल बना सकते हैं . जैसे कि आप व्यापारिक एवं निजी उपयोग के लिये अलग-अलग प्रोफाइल बना सकते हैं.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] अपना प्रोफाइल बनाना शुरू करने के लिए, जारी रखें क्लिक करें.
       *[other] अपना प्रोफाइल बनाना आरम्भ करने के लिये अगला क्लिक करें.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] निष्कर्ष
       *[other] { create-profile-window.title } को पूरा किया
    }

profile-creation-intro = यदि आप कई प्रोफाइल बनाते हैं तो आप उन्हें उनके प्रोफाइल नाम से पहचान सकते हैं. आप यहाँ उपलब्ध नाम का उपयोग कर सकते हैं या अपने द्वारा दिये गये नाम का उपयोग कर सकते हैं.

profile-prompt = नया प्रोफाइल दें:
    .accesskey = E

profile-default-name =
    .value = तयशुदा उपयोक्ता

profile-directory-explanation = आपकी उपयोक्ता सेटिंग, वरीयता और दूसरी उपयोक्ता संंबंधित आंकड़ा को जमा किया जाएगा:

create-profile-choose-folder =
    .label = सेल चुनें…
    .accesskey = C

create-profile-use-default =
    .label = तयशुदा कोष्ठ का उपयोग करें
    .accesskey = U
