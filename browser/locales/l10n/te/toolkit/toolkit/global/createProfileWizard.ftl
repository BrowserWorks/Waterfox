# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = ప్రొఫైల్ విజార్డును సృష్టించు
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] పరిచయం
       *[other] { create-profile-window.title }కు స్వాగతం
    }

profile-creation-explanation-1 = { -brand-short-name } మీ అమరికలు మరియు అభీష్టాలకు సంభందిచిన సమాచారాన్ని మీ వ్యక్తిగత ప్రొఫైల్‌నందు నిల్వవుంచుతుంది.

profile-creation-explanation-2 = మీరు { -brand-short-name } యొక్క ఒక కాపీను ఇతర వాడుకరులు బాగస్వామ్యపరుచుకుంటే, మీరు ప్రతివాడుకరి సమాచారాన్ని వేరువేరుగా ప్రొఫైల్సు నిర్వహించి వుంచవలెను. ఇది చేయుటకు, ప్రతి వాడుకరి అతని లేదా అమె యొక్క స్వంతప్రొఫైల్ సృష్టించవలెను.

profile-creation-explanation-3 = మీరు ఒక్కరు మాత్రమే { -brand-short-name } కాపీ ఉపయోగిస్తున్నట్లైతే, మీరు తప్పక ఒక ప్రొఫైలైనా కలిగిఉండాలి. మీరు ఇష్టపడితే, వేర్వేరు అమరికలు మరియు అభీష్టాలు నిల్వవుంచుటకు బహుళ ప్రొఫైల్సు మీ వరకు సృష్టించుకోవచ్చు. ఉదాహరణకు, మీరు వ్యాపార మరియు వ్యక్తిగత ఉపయోగాల కొరకు వేర్వేరు ప్రోఫైల్సు కావాలనుకోవచ్చు.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] మీ ప్రొఫైల్ సృష్టీకరణ ప్రారంభమునకు, కొనసాగించు నొక్కండి.
       *[other] మీ ప్రొఫైలు తయారుచెయ్యడం మొదలుపెట్టడానికి, తర్వాత నొక్కండి.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] ముగింపు
       *[other] { create-profile-window.title }ను పూర్తిచేయుచున్నది
    }

profile-creation-intro = మీరు చాలా ప్రొఫైల్సు సృష్టించినట్లైతే వాటని ప్రొఫైల్ నామాలద్వారా తెలుపవచ్చు. ఇక్కడ ఇవ్వబడిన నామమును వాడవచ్చు లేదా మీ స్వంత దానిని వాడవచ్చు.

profile-prompt = కొత్త ప్రొఫైల్ పేరును ఇవ్వండి:
    .accesskey = E

profile-default-name =
    .value = అప్రమేయ వాడుకరి

profile-directory-explanation = మీ వాడుకరి అమరికలు, అభిరుచులు, ఇతర వాడుకరి-సంబంధిత డేటా ఇందులో నిల్వ ఉంటుంది:

create-profile-choose-folder =
    .label = సంచయాన్ని ఎంచుకోండి…
    .accesskey = C

create-profile-use-default =
    .label = అప్రమేయ సంచయాన్ని వాడు
    .accesskey = U
