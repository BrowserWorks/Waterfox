# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } સાથેના જોડાણ દરમ્યાન ભૂલ ઉદ્ભવી કારણ કે તે અયોગ્ય સુરક્ષા પ્રમાણપત્ર વાપરે છે.

cert-error-mitm-intro = વેબસાઈટસ પ્રમાણપત્રો દ્વારા તેમની ઓળખ સાબિત કરે છે, જે પ્રમાણપત્ર સત્તાવાળાઓ દ્વારા જારી કરવામાં આવે છે.

cert-error-mitm-mozilla = { -brand-short-name } નો નફાકારક Mozilla દ્વારા સમર્થન છે, જે સંપૂર્ણપણે ખુલ્લા પ્રમાણપત્ર અધિકારી (CA) સ્ટોરનું સંચાલન કરે છે. CA સ્ટોર એ સુનિશ્ચિત કરવામાં સહાય કરે છે કે પ્રમાણપત્ર અધિકારીઓ વપરાશકર્તા સુરક્ષા માટે શ્રેષ્ઠ પ્રયાસોનું પાલન કરે છે.

cert-error-mitm-connection = { -brand-short-name } એ Mozilla CA સ્ટોરનો ઉપયોગ કરે છે કે જે યુઝરની ઑપરેટિંગ સિસ્ટમ દ્વારા પ્રમાણિત કરેલા પ્રમાણપત્રોને બદલે કનેક્શન સુરક્ષિત છે તે ચકાસવા માટે. તેથી, જો એન્ટીવાયરસ પ્રોગ્રામ અથવા નેટવર્ક CA દ્વારા જારી કરાયેલ સુરક્ષા પ્રમાણપત્ર સાથે કનેક્શનને અટકાવી રહ્યું છે જે Mozilla CA સ્ટોરમાં નથી, તો કનેક્શનને અસુરક્ષિત માનવામાં આવે છે.

cert-error-trust-unknown-issuer-intro = કોઈ વ્યક્તિ સાઇટને છુટાછવાયા કરવાનો પ્રયાસ કરી શકે છે અને તમારે ચાલુ રાખવું જોઈએ નહીં.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = વેબસાઇટ્સ પ્રમાણપત્ર દ્વારા તેમની ઓળખ સાબિત કરે છે. { -brand-short-name } આના { $hostname } પર વિશ્વાસ કરતું નથી કારણ કે તેનું પ્રમાણપત્ર રજૂ કરનાર અજ્ઞાત છે, પ્રમાણપત્ર સ્વતઃ-સહી કરેલું છે, અથવા સર્વર સાચા મધ્યવર્તી પ્રમાણપત્રો મોકલતું નથી.

cert-error-trust-cert-invalid = પ્રમાણપત્ર વિશ્વાસુ નથી કારણ કે તે અયોગ્ય CA પ્રમાણપત્ર દ્વારા અદાથયેલ છે.

cert-error-trust-untrusted-issuer = પ્રમાણપત્ર વિશ્વાસુ નથી કારણ કે પ્રમાણપત્ર અદા કરનાર વિશ્વાસુ નથી.

cert-error-trust-signature-algorithm-disabled = પ્રમાણપત્ર વિશ્ર્વાસપાત્ર નથી કારણ કે તે હસ્તાક્ષર અલ્ગોરિધમની મદદથી હસ્તાક્ષર થયેલ હતુ કે જે નિષ્ક્રિય થયેલ છે કારણ કે અલ્ગોરિધમ સુરક્ષિત નથી.

cert-error-trust-expired-issuer = પ્રમાણપત્ર વિશ્વાસુ નથી કારણ કે પ્રમાણપત્ર અદા કરનાર નિવૃત્ત થઈ ગયેલ છે.

cert-error-trust-self-signed = પ્રમાણપત્ર વિશ્વાસુ નથી કારણ કે  કારણ કે તે જાતે સહી થયેલ છે.

cert-error-trust-symantec = GeoTrust, RapidSSL, સિમેન્ટેક, થવેટી અને VeriSign દ્વારા જારી કરાયેલા પ્રમાણપત્રો હવે લાંબા ગાળા માટે સલામત માનવામાં આવતાં નથી કારણ કે આ પ્રમાણપત્ર સત્તાવાળાઓ ભૂતકાળમાં સલામતીની રીતને અનુસરવામાં નિષ્ફળ રહ્યા હતા.

cert-error-untrusted-default = પ્રમાણપત્ર વિશ્વાસુ સ્રથી આવતું નથી.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = વેબસાઇટ્સ પ્રમાણપત્ર દ્વારા તેમની ઓળખ સાબિત કરે છે. { -brand-short-name } આ સાઇટ પર વિશ્વાસ કરતું નથી કારણ કે તે પ્રમાણપત્રનો ઉપયોગ કરે છે જે { $hostname } માટે માન્ય નથી.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = વેબસાઇટ્સ પ્રમાણપત્ર દ્વારા તેમની ઓળખ સાબિત કરે છે. { -brand-short-name } આ સાઇટ પર વિશ્વાસ કરતું નથી કારણ કે તે પ્રમાણપત્રનો ઉપયોગ કરે છે જે { $hostname } માટે માન્ય નથી. પ્રમાણપત્ર ફક્ત <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> માટે માન્ય છે.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = વેબસાઇટ્સ પ્રમાણપત્ર દ્વારા તેમની ઓળખ સાબિત કરે છે. { -brand-short-name } આ સાઇટ પર વિશ્વાસ કરતું નથી કારણ કે તે પ્રમાણપત્રનો ઉપયોગ કરે છે જે { $hostname } માટે માન્ય નથી. પ્રમાણપત્ર ફક્ત { $alt-name } માટે માન્ય છે.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = વેબસાઇટ્સ પ્રમાણપત્ર દ્વારા તેમની ઓળખ સાબિત કરે છે. { -brand-short-name } આ સાઇટ પર વિશ્વાસ કરતું નથી કારણ કે તે પ્રમાણપત્રનો ઉપયોગ કરે છે જે { $hostname } માટે માન્ય નથી. પ્રમાણપત્ર ફક્ત નીચેના નામો માટે માન્ય છે: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = વેબસાઈટો તેમની ઓળખ પ્રમાણપત્રો દ્વારા સાબિત કરે છે, જે સેટ ટાઇમ અવધિ માટે માન્ય છે. { $hostname } માટેનો પ્રમાણપત્ર { $not-after-local-time } પર સમાપ્ત થયો નથી.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = વેબસાઈટો તેમની ઓળખ પ્રમાણપત્રો દ્વારા સાબિત કરે છે, જે સેટ ટાઇમ અવધિ માટે માન્ય છે. { $hostname } માટેનો પ્રમાણપત્ર { $not-before-local-time } સુધી માન્ય રહેશે નહીં.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = ભૂલ કોડ: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = વેબસાઇટ્સ પ્રમાણપત્રો દ્વારા તેમની ઓળખ સાબિત કરે છે, જે પ્રમાણપત્ર સત્તાવાળાઓ દ્વારા જાહેર કરવામાં આવે છે. મોટાભાગના બ્રાઉઝર્સ હવે GeoTrust, RapidSSL, Symantec, Thawte, અને VeriSign દ્વારા પ્રમાણિત પ્રમાણપત્રો પર વિશ્વાસ કરતા નથી. { $hostname } આ અધિકારીઓમાંથી એકમાંથી પ્રમાણપત્રનો ઉપયોગ કરે છે અને તેથી વેબસાઇટની ઓળખ સાબિત કરી શકાતી નથી.

cert-error-symantec-distrust-admin = તમે વેબસાઇટના વ્યવસ્થાપકને આ સમસ્યાની જાણ કરી શકો છો.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP સખત પરિવહન સુરક્ષા: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP સાર્વજનિક કી પિનિંગ: { $hasHPKP }

cert-error-details-cert-chain-label = પ્રમાણપત્ર સાંકળ:

## Messages used for certificate error titles

connectionFailure-title = જોડાવામાં અસમર્થ
deniedPortAccess-title = આ સરનામું આરક્ષિત છે
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = હમ્મ. અમને તે સાઇટ શોધવામાં સમસ્યા આવી રહી છે.
fileNotFound-title = ફાઈલ મળી નહિં
fileAccessDenied-title = ફાઇલની પ્રવેશ માટે નકારવામાં આવી હતી
generic-title = અરરર.
captivePortal-title = નેટવર્કમાં પ્રવેશ કરો
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = હમ્મ. તે સરનામું બરાબર લાગતું નથી.
netInterrupt-title = જોડાણ અટકાવી દેવાયું હતું
notCached-title = દસ્તાવેજ નિવૃત્ત થઈ ગયું
netOffline-title = ઓફલાઈન સ્થિતિ
contentEncodingError-title = સમાવિષ્ટ સંગ્રહપદ્ધતિ ભૂલ
unsafeContentType-title = અસુરક્ષિત ફાઈલ પ્રકાર
netReset-title = જોડાણ પુનઃસુયોજિત થયું હતું
netTimeout-title = જોડાણ સમય સમાપ્ત થઈ ગયો
unknownProtocolFound-title = સરનામું સમજમાં આવતુ ન હતુ
proxyConnectFailure-title = પ્રોક્સી સર્વર જોડાણ તોડી રહ્યું છે
proxyResolveFailure-title = પ્રોક્સી સર્વર શોધવામાં અસમર્થ
redirectLoop-title = પાનું યોગ્ય રીતે પુનઃદિશાકરણ વાપરી રહ્યું નથી
unknownSocketType-title = સર્વરમાંથી અનિચ્છનિય પ્રત્યુત્તર
nssFailure2-title = સુરક્ષિત જોડાણ નિષ્ફળ થયું
corruptedContentError-title = બગડેલું વસ્તુ સંપાદક
remoteXUL-title = દૂરસ્થ XUL
sslv3Used-title = સુરક્ષિત રીતે જોડાણ કરવામાં અસમર્થ
inadequateSecurityError-title = તમારું જોડાણ સુરક્ષિત નથી
blockedByPolicy-title = અવરોધિત પૃષ્ઠ
clockSkewError-title = તમારાં કમ્પ્યુટરની ઘડિયાળ ખોટી છે
networkProtocolError-title = નેટવર્ક પ્રોટોકોલ ભૂલ
nssBadCert-title = ચેતવણી: આગળ સંભવિત સુરક્ષા જોખમ
nssBadCert-sts-title = કનેક્ટ કર્યું નહોતું: સંભવિત સુરક્ષા સમસ્યા
certerror-mitm-title = સૉફ્ટવેર રોકે છે { -brand-short-name } સલામત રીતે આ સાઇટથી કનેક્ટ થવાથી
