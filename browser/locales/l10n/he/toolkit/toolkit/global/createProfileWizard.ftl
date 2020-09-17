# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = אשף יצירת פרופיל
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] הקדמה
       *[other] ברוכים הבאים אל { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } מאחסן מידע על ההגדרות וההעדפות שלך בפרופיל האישי שלך.

profile-creation-explanation-2 = אם אתה חולק עותק זה של { -brand-short-name } עם משתמשים אחרים, תוכל להשתמש בפרופילים כדי לשמור את המידע של כל משתמש בנפרד. כדי לעשות זאת, על כל משתמש ומשתמשת ליצור פרופיל משלו (או משלה).

profile-creation-explanation-3 = אם אתה האדם היחיד המשתמש בעותק זה של { -brand-short-name }, חייב להיות להיות לך לפחות פרופיל אחד. אם תרצה, תוכל ליצור לעצמך מספר פרופילים כדי לאחסן קבוצות שונות של הגדרות והעדפות. למשל, ייתכן שתרצה פרופילים נפרדים לשימוש עסקי ואישי.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] כדי להתחיל ליצור את הפרופיל שלך, לחץ על "המשך".
       *[other] כדי להתחיל ביצירת הפרופיל שלך, יש ללחוץ על הבא.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] סוף
       *[other] משלים את { create-profile-window.title }
    }

profile-creation-intro = אם תיצור מספר פרופילים תוכל להבדיל ביניהם לפי שמם. תוכל להשתמש בשם המסופק כאן או להשתמש בשם משלך.

profile-prompt = הכנס שם לפרופיל חדש:
    .accesskey = E

profile-default-name =
    .value = משתמש בררת מחדל

profile-directory-explanation = הגדרות המשתמש, ההעדפות, ונתונים אחרים הקשורים למשתמש שלך יאוחסנו ב:

create-profile-choose-folder =
    .label = בחירת תיקיה…
    .accesskey = ת

create-profile-use-default =
    .label = שימוש בתיקיית בררת המחדל
    .accesskey = ה
