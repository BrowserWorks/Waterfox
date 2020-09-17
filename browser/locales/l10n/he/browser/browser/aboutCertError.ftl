# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } משתמש באישור אבטחה שגוי.

cert-error-mitm-intro = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה, המונפקים על־ידי רשויות אישורים.

cert-error-mitm-mozilla = { -brand-short-name } מגובה על־ידי Mozilla, המנהלת חנות רשות אישורים (CA) פתוחה לחלוטין. חנות זו מסייעת להבטיח שרשויות האישורים פועלות לפי שיטות העבודה המומלצות לאבטחת המשתמשים.

cert-error-mitm-connection = { -brand-short-name } עושה שימוש בחנות רשות אישורים של Mozilla כדי לאמת שהחיבור מאובטח, ולא באישורים המסופקים על־ידי מערכת ההפעלה של המשתמש. כך שאם תוכנת אנטי־וירוס או רשת מיירטים חיבור עם אישור אבטחה שהונפק על־ידי רשות אישורים שאינה בחנות רשות האישורים של Mozilla, החיבור ייחשב לא בטוח.

cert-error-trust-unknown-issuer-intro = ייתכן שגורם כלשהו מנסה להתחזות לאתר ולכן מומלץ שלא להמשיך.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה. { -brand-short-name } לא בוטח ב־{ $hostname } מכיוון שמנפיק אישור האבטחה שלו אינו ידוע, האישור נחתם עצמית או שהשרת לא שולח את אישורי הביניים הנכונים.

cert-error-trust-cert-invalid = האישור אינו מהימן מכיוון שהוא הונפק על־ידי רשות אישורים לא חוקית.

cert-error-trust-untrusted-issuer = האישור אינו מהימן מכיוון שהאישור של הגורם המנפיק אינו מהימן.

cert-error-trust-signature-algorithm-disabled = האישור אינו מהימן מכיוון שהוא נחתם על־ידי אלגוריתם חתימה שהושבת מכיוון שאינו מאובטח.

cert-error-trust-expired-issuer = האישור אינו מהימן מכיוון שתוקף האישור של הגורם המנפיק פג.

cert-error-trust-self-signed = האישור אינו מהימן מכיוון שהוא נחתם עצמית.

cert-error-trust-symantec = אישורים שהונפקו על־ידי GeoTrust, ‏RapidSSL, ‏Symantec, ‏Thawte ו־VeriSign אינם נחשבים עוד כבטוחים מכיוון שרשויות האישורים הללו כשלו ביישום נהלי אבטחה.

cert-error-untrusted-default = האישור לא מגיע ממקור מהימן.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה. { -brand-short-name } לא בוטח באתר זה מכיוון שהוא משתמש באישור אבטחה שאינו תקף עבור { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה. { -brand-short-name } לא בוטח באתר זה מכיוון שהוא משתמש באישור אבטחה שאינו תקף עבור { $hostname }. האישור תקף רק עבור <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה. { -brand-short-name } לא בוטח באתר זה מכיוון שהוא משתמש באישור אבטחה שאינו תקף עבור { $hostname }. האישור תקף רק עבור { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה. { -brand-short-name } לא בוטח באתר זה מכיוון שהוא משתמש באישור אבטחה שאינו תקף עבור { $hostname }. האישור תקף עבור השמות הבאים בלבד: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה, התקפים לפרק זמן מוגדר. פג תוקפו של אישור האבטחה עבור { $hostname } ב־{ $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה, התקפים לפרק זמן מוגדר. אישור האבטחה עבור { $hostname } לא יהיה בתוקף עד { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = קוד שגיאה: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = אתרים מוכיחים את זהותם באמצעות אישורי אבטחה, המונפקים על־ידי רשויות אישורים. מרבית הדפדפנים כבר לא סומכים על אישורים שהונפקו על־ידי GeoTrust, ‏RapidSSL, ‏Symantec, ‏Thawte וֿVeriSign. האתר { $hostname } עושה שימוש באישור של אחת מהרשויות הללו ולכן לא ניתן להוכיח את זהות האתר.

cert-error-symantec-distrust-admin = באפשרותך להודיע למנהל האתר על אודות בעיה זו.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = אבטחת תעבורה מחמירה של HTTP ‏(HSTS): { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = הצמדת מפתח ציבורי של HTTP:‏ { $hasHPKP }

cert-error-details-cert-chain-label = שרשרת אישורים:

open-in-new-window-for-csp-or-xfo-error = פתיחת אתר בחלון חדש

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = כדי להגן על האבטחה שלך, { $hostname } לא יאפשר ל־{ -brand-short-name } להציג את הדף אם אתר אחר הטמיע אותו. כדי לצפות בדף זה, עליך לפתוח אותו בחלון חדש.

## Messages used for certificate error titles

connectionFailure-title = כישלון בהתחברות
deniedPortAccess-title = כתובת זו מוגבלת
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = אבוי. יש לנו בעיה למצוא את האתר הזה.
fileNotFound-title = קובץ לא נמצא
fileAccessDenied-title = הגישה לקובץ נדחתה
captivePortal-title = כניסה לרשת
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = אבוי. הכתובת הזו לא נראית תקינה.
netInterrupt-title = החיבור הופסק
notCached-title = תוקף המסמך פג
netOffline-title = מצב לא־מקוון
contentEncodingError-title = שגיאה בקידוד תוכן
unsafeContentType-title = סוג קובץ מסוכן
netReset-title = החיבור הופסק
netTimeout-title = תם הזמן המוקצב לחיבור
unknownProtocolFound-title = כתובת זו אינה מובנת
proxyConnectFailure-title = השרת המתווך דחה את ההתחברות
proxyResolveFailure-title = שרת מתווך לא נמצא
redirectLoop-title = הדף מבצע העברה לא תקינה
unknownSocketType-title = תגובה לא צפויה מהשרת
nssFailure2-title = חיבור מאובטח נכשל
csp-xfo-error-title = ‏{ -brand-short-name } לא יכול לפתוח דף זה
corruptedContentError-title = שגיאת תוכן פגום
remoteXUL-title = XUL מרוחק
sslv3Used-title = לא ניתן להתחבר באופן מאובטח
inadequateSecurityError-title = החיבור שלך אינו מאובטח
blockedByPolicy-title = עמוד חסום
clockSkewError-title = השעון של המחשב שלך אינו מכוון
networkProtocolError-title = שגיאת פרוטוקול רשת
nssBadCert-title = אזהרה: סכנת אבטחה אפשרית לפניך
nssBadCert-sts-title = לא בוצעה התחברות: חולשת אבטחה אפשרית
certerror-mitm-title = תכנית כלשהי מונעת מ־{ -brand-short-name } להתחבר באופן מאובטח לאתר הזה
