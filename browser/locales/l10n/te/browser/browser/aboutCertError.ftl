# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } ఒక సరికాని ధృవీకరణపత్రాన్ని ఉపయోగిస్తోంది.
cert-error-mitm-intro = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి, వీటిని సర్టిఫికెట్ అథారిటీలు జారీ చేస్తారు.
cert-error-trust-unknown-issuer-intro = ఎవరో ఈ సైటును అనుకరించడానికి ప్రయత్నిస్తూండవచ్చు, మీరు ముందుకి వెళ్ళకూడదు.
cert-error-trust-cert-invalid = ఈ ధృవపత్రాన్ని నమ్మలేము ఎందుకంటే అది చెల్లని CA ధృవపత్రం ద్వారా జారీ చెయ్యబడింది.
cert-error-trust-untrusted-issuer = ఈ ధ్రువపత్రాన్ని నమ్మలేము ఎందుకంటే దీన్ని జారీ చేసినవారి ధ్రువపత్రం నమ్మదగినది కాదు.
cert-error-trust-signature-algorithm-disabled = సురక్షితం కాని అచేతనం చేయబడిన అల్గార్దెమ్ ఉపయోగించి సంతకం చేయుట వలన ఆ ధృవీకరణపత్రం నమ్మదగినది కాదు.
cert-error-trust-expired-issuer = ఆ ధృవీకరణపత్రం నమ్మలేము ఎంచేతంటే ఇచ్చినవాని ధృవీకరణపత్రం కాలముతీరినది.
cert-error-trust-self-signed = ఆ ధృవీకరణపత్రం నమ్మలేము ఎంచేతంటే తనుకుతానై సంతకంచేసివుంది.
cert-error-trust-symantec = జియోట్రస్ట్, రాపిడ్SSL, సిమాంటెక్, థావ్టే, వెరిసైన్‌లు జారీ చేసిన ధృవపత్రాలు ఇకపై సురక్షితమైనవిగా పరిగణించబడవు ఎందుకంటే ఈ సర్టిఫికేట్ అధికారులు గతంలో భద్రతా పద్ధతులను అనుసరించడంలో విఫలమయ్యారు.
cert-error-untrusted-default = ఆ ధృవీకరణపత్రం  నమ్మకమైన మూలంనుండి రాలేదు.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి. ఈ సైటును { -brand-short-name } నమ్మడంలేదు ఎందుకంటే వారు { $hostname }కి చెల్లని ధృవపత్రాన్ని వాడుతున్నారు.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి. ఈ సైటును { -brand-short-name } నమ్మడంలేదు ఎందుకంటే వారు { $hostname }కి చెల్లని ధ్రువపత్రాన్ని వాడుతున్నారు. ఆ ధ్రువపత్రం కేవలం <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>కి మాత్రమే చెల్లుతుంది.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి. ఈ సైటును { -brand-short-name } నమ్మడంలేదు ఎందుకంటే వారు { $hostname }కి చెల్లని ధ్రువపత్రాన్ని వాడుతున్నారు. ఆ ధ్రువపత్రం కేవలం { $alt-name }కి మాత్రమే చెల్లుతుంది.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి. ఈ సైటును { -brand-short-name } నమ్మడంలేదు ఎందుకంటే వారు { $hostname }కి చెల్లని ధ్రువపత్రాన్ని వాడుతున్నారు. ఆ ధ్రువపత్రం కేవలం ఈ పేర్లకు మాత్రమే చెల్లుతుంది: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి, వాటి చెల్లుబాటుకు కాల పరిమితి ఉంటుంది. { $hostname } వారి ధ్రువపత్రం { $not-after-local-time }కి కాలంచెల్లిపోయింది.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = వెబ్‌సైట్లు తమ గుర్తింపును ధృవపత్రాల ద్వారా నిరూపిస్తాయి, వాటి చెల్లుబాటుకు కాల పరిమితి ఉంటుంది. { $hostname } వారి ధ్రువపత్రం { $not-before-local-time } ముందు చెల్లుబాటు కాదు.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = దోష సంకేతం: <a data-l10n-name="error-code-link">{ $error }</a>
cert-error-symantec-distrust-admin = ఈ సమస్య గురించి మీరు వెబ్‌సైట్ నిర్వాహకులకు తెలియజేయవచ్చు.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP స్క్రిప్ట్ ట్రాన్స్‌పోర్ట్ సెక్యూరిటి: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP పబ్లిక్ కీ పిన్నింగ్: { $hasHPKP }
cert-error-details-cert-chain-label = ధృవీకరణపత్రం చైన్:
open-in-new-window-for-csp-or-xfo-error = సైటును కొత్త కిటికీలో తెరువు

## Messages used for certificate error titles

connectionFailure-title = సంధానం సాధ్యం కావడంలేదు
deniedPortAccess-title = ఈ చిరునామా నిషిద్దం
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = హ్మ్. ఆ సైటుని కనుక్కోవడం సమస్యగా ఉంది.
fileNotFound-title = ఫైలు కనబడ లేదు
fileAccessDenied-title = ఫైలుకి ఆక్సెస్ తిరస్కరించబడింది
generic-title = అయ్యో.
captivePortal-title = నెట్వర్కులోనికి ప్రవేశించండి
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = హ్మ్. ఆ చిరునామా సరిగా లేదు.
netInterrupt-title = అనుసంధానానికి అంతరాయం కలిగింది
notCached-title = పత్రం కాలం చెల్లింది
netOffline-title = ఆఫ్‌లైన్ రీతి
contentEncodingError-title = కాంటెంట్ ఎన్‌కోడింగ్ తప్పిదం
unsafeContentType-title = సురక్షితం కాని ఫైలు రకం
netReset-title = అనుసంధానం పునరుద్ధరించబడింది
netTimeout-title = అనుసంధాన సమయం అయిపోయింది
unknownProtocolFound-title = ఆ చిరునామా అర్థం కాలేదు
proxyConnectFailure-title = ఆ ప్రాక్సీ సేవిక అనుసంధానాలను తిరస్కరిస్తోంది
proxyResolveFailure-title = ప్రాక్సీ సేవికను కనుగొనలేకపోయాం
redirectLoop-title = పేజీ సరిగా దారిమళ్ళించడం లేదు
unknownSocketType-title = సేవిక నుండి అనుకోని స్పందన
nssFailure2-title = సురక్షిత అనుసంధానం విఫలమైంది
csp-xfo-error-title = { -brand-short-name } ఈ పేజీని తెరవలేకుంది
corruptedContentError-title = పాడైన విషయ దోషం
remoteXUL-title = రిమోట్ XUL
sslv3Used-title = సురక్షితంగా అనుసంధానం కాలేకున్నాము
inadequateSecurityError-title = మీ అనుసంధానం సురక్షితమైనది కాదు
blockedByPolicy-title = నిరోధించిన పేజీ
clockSkewError-title = మీ కంప్యూటర్ గడియారం తప్పు
networkProtocolError-title = నెట్‌వర్క్ ప్రొటోకాల్ తప్పిదం
nssBadCert-title = హెచ్చరిక: సంభావ్య భద్రతా అపాయం ముందుంది
nssBadCert-sts-title = అనుసంధానం కాలేదు: సంభావ్య భద్రతా సమస్య
certerror-mitm-title = { -brand-short-name }ను ఈ సైటుకు సురక్షితంగా అనుసంధానమవ్వకుండా సాఫ్ట్‌వేర్ నివారిస్తుంది
