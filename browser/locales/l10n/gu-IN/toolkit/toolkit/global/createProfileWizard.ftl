# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = રુપરેખા વિઝાર્ડ બનાવો
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] પરિચય
       *[other] { create-profile-window.title } માં સ્વાગત છે
    }

profile-creation-explanation-1 = { -brand-short-name } તમારી ગોઠવણી અને પસંદગીઓને તમારી અંગત રુપરેખામાં સંગ્રહ કરે છે.

profile-creation-explanation-2 = જો તમે બીજા વપરાશકર્તાઓની સાથે { -brand-short-name } ની નકલની ભાગીદારી કરો છો તો તમે બીજા વપરાશકર્તાઓની માહિતી રાખવા માટે અલગ રુપરેખા બનાવી શકો છો.  આ કરવા માટે બધા વપરાશકર્તાઓએ પોતાની રુપરેખા બનાવી પડશે.

profile-creation-explanation-3 = જો તમે { -brand-short-name } ની નકલ એકલાજ વાપરો છો, તો તમારી પાસે એક રુપરેખા તો જરુરી છે. તમે એકથી વધુ રુપરેખા પણ બનાવી શકો છો. દા.ત. તમે વેપાર અને અંગત વપરાશ માટે અલગ રુપરેખાઓ બનાવી શકો છો.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] તમારી રૂપરેખા બનાવવાનું શરૂ કરવા માટે, ચાલુ રાખો ક્લિક કરો.
       *[other] તમારી રુપરેખા બનાવવા માટે, આગળ પર ક્લિક કરો.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] તારણ
       *[other] { create-profile-window.title } સમાપ્ત કરી રહ્યા છીએ
    }

profile-creation-intro = જો તમે ઘણી બધી રુપરેખા બનાવશો તો તેને તમે નામથી અલગ પાડી શકશો. તમે અહીં આપેલ નામ અથવા તમારા પોતાના નામ પસંદ કરી શકશો.

profile-prompt = નવી રુપરેખાનુ દાખલ કરો:
    .accesskey = E

profile-default-name =
    .value = મૂળભુત વપરાશકર્તા

profile-directory-explanation = તમારા વપરાશકર્તા સેટીંગ, પસંદગીઓ અને અન્ય વપરાશકર્તા-સંબંધિત માહિતી આમાં સંગ્રહવામાં આવશે:

create-profile-choose-folder =
    .label = ફોલ્ડર પસંદ કરો...
    .accesskey = C

create-profile-use-default =
    .label = મૂળભુત ફોલ્ડર વાપરો
    .accesskey = U
