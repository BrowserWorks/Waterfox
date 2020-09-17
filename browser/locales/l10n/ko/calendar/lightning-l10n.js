# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#filter substitution

# the default day to start the week on
#0=Sunday 1=Monday 2=Tuesday 3=Wednesday 4=Thursday 5=Friday 6=Saturday
pref("calendar.week.start", 0);

# default days off (not in work week)
pref("calendar.week.d0sundaysoff", true);
pref("calendar.week.d1mondaysoff", false);
pref("calendar.week.d2tuesdaysoff", false);
pref("calendar.week.d3wednesdaysoff", false);
pref("calendar.week.d4thursdaysoff", false);
pref("calendar.week.d5fridaysoff", false);
pref("calendar.week.d6saturdaysoff", true);

pref("general.useragent.locale", "@AB_CD@");

# categories
pref("calendar.categories.names", "기념일,생일,엄무,호출,손님,시합,고객,선호,진행 사항,선물,휴가,아이디어,논의 사항,기타,개인,프로젝트,공휴일,상태,납품,여행,방학");
