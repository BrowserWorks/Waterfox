# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = පැතිකඩ විශාරද නිර්මාණය
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] හැඳින්වීම
       *[other] { create-profile-window.title } වෙතට සාදරයෙන් පිළිගනිමු
    }

profile-creation-explanation-1 = ඔබගේ පෞද්හලික පැතිකඩ තුළ { -brand-short-name } විසින් ඔබේ සැසුම් සහ අභිප්‍රේත ගබඩා කරනු ඇත.

profile-creation-explanation-2 = ඔබ මෙම { -brand-short-name } පිටපත තවත් පරිශීලකයින් සමඟ හවුලේ භාවිතා කරයි නම්, පරිශීලක තොරතුරු වෙන්ව තබා ගැනීම සඳහා ඔබට පැතිකඩ භාවිතා කළ හැක. ඒ සඳහා සෑම පරිශීලකුම වෙන් වෙන්ව පැතිකඩක් නිර්මාණය කළ යුතුවේ.

profile-creation-explanation-3 = මෙම { -brand-short-name } පිටපත භාවිතා කරන එකම පුද්ගලයා ඔබ නම්, ඔබට අවම වශයෙන් එක් පැතිකඩක් හෝ තිබිය යුතුයි. ඔබ අවශ්‍ය නම් ඔබේ භාවිතය සඳහා පැතිකඩ කිහිපයක් වුවද නිර්මාණය කිරිමෙන් වෙනස් වූ සැකසුම් සහ අභිප්‍රේත ගබඩා කරගත හැක. උදාහරණයක් ලෙස, ඔබට ව්‍යාපාරික සහ පෞද්ගලික භාවිතය සඳහා පැතිකඩ දෙකක් අවශ්‍ය විය හැක.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] ඔබේ පැතිකඩ නිර්මාණය ඇරඹීමට, මීළඟට මත ක්ලික් කරන්න.
       *[other] ඔබේ පැතිකඩ නිර්මාණය ඇරඹීමට, මීළඟට මත ක්ලික් කරන්න.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] අවසන් කිරීම
       *[other] { create-profile-window.title } අවසන් කරමින් සිටියි
    }

profile-creation-intro = ඔබ පැතිකඩ කිහිපයක් භාවිතා කළ හොත් පැතිකඩ නාමයෙන් ඔබට වෙන් කර හදුනාගත හැක. ඔබට මෙහි ඇති නාමය හෝ ඔබගේම නාමයක් භාවිතා කළ හැක.

profile-prompt = නව පැතිකඩ නාමය ඇතුළත් කරන්න:
    .accesskey = E

profile-default-name =
    .value = පෙරමිනි පරිශීලක

profile-directory-explanation = ඔබේ පරිශීලක සැසුම්, අභිප්‍රේත සහ  වෙනත් පරිශීලක සම්බන්ධ තොරතුරු ගබඩා කරනුයේ:

create-profile-choose-folder =
    .label = බහලුම තෝරන්න...
    .accesskey = C

create-profile-use-default =
    .label = පෙරමිනි බහලුම භාවිතා කරන්න
    .accesskey = U
