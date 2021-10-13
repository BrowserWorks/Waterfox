# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#filter substitution

# the default day to start the week on
#0=Sunday 1=Monday 2=Tuesday 3=Wednesday 4=Thursday 5=Friday 6=Saturday
pref("calendar.week.start", 1);

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
pref("calendar.categories.names", "Ajándék,Beszállító,Egyéb,Évforduló,Hívás,Kedvenc,Nyaralás,Ötlet,Probléma,Projekt,Reagálni,Státusz,Szabadság,Személyes,Születésnap,Utazás,Ügyfél,Ünnepnap,Üzlet,Versenytárs,Vevő");
