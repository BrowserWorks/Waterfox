# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } ប្រើ​វិញ្ញាបនបត្រ​សុវត្ថិភាព​មិន​ត្រឹមត្រូវ ។

cert-error-mitm-intro = គេហទំព័រ​​បញ្ជាក់​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ ដែល​បាន​ចេញ​ដោយ​អាជ្ញាធរ​វិញ្ញាបនបត្រ។

cert-error-mitm-mozilla = { -brand-short-name } ត្រឡប់​មកវិញ​តាមរយៈ Mozilla មិន​រក​ប្រាក់​ចំណេញ ដែល​ជា​អ្នក​គ្រប់គ្រង​​​កន្លែង​ផ្ទុក​អាជ្ញាធរ​​វិញ្ញាបនបត្រ​ (CA) បើក​ចំហ។ កន្លែង​ផ្ទុក CA ជួយ​ធានា​ថា អាជ្ញាធរ​វិញ្ញាបនបត្រកំពុង​​អនុវត្ត​តាមការអនុវត្ត​ដ៏​ប្រសើរ​បំផុត​ដើម្បី​សុវត្ថិភាព​អ្នក​ប្រើប្រាស់។

cert-error-mitm-connection = { -brand-short-name } ប្រើប្រាស់​កន្លែង​ផ្ទុក CA របស់ Mozilla ដើម្បី​ផ្ទៀងផ្ទាត់​ថា ការតភ្ជាប់​មាន​សុវត្ថិភាព ជាជាង​មើល​លើ​វិញ្ញាបនបត្រ​ដែល​បាន​ផ្ដល់​ដោយ​ប្រព័ន្ធ​ប្រតិបត្តិការ​របស់​អ្នក​ប្រើប្រាស់។ ដូច្នេះ ប្រសិនបើ​កម្មវិធី​មេរោគ ឬ​បណ្ដាញ​កំពុង​ជួបប្រទះ​ការតភ្ជាប់​ដែល​មាន​វិញ្ញាបនបត្រ​សុវត្ថិភាព​បាន​ចេញ​ដោយ CA ដែល​មិន​ស្ថិត​នៅ​ក្នុង​កន្លែង​ផ្ទុក CA របស់ Mozilla នោះ​ការតភ្ជាប់​ត្រូវបាន​ចាត់ទុកថា​អសុវត្ថិភាព។

cert-error-trust-unknown-issuer-intro = អាច​មាន​អ្នក​ណា​ម្នាក់​កំពុង​ព្យាយាម​ក្លែង​ធ្វើ​ជា​អ្នក​នៅ​លើ​គេហទំព័រ​នេះ ដូច្នេះ​អ្នក​មិន​គួរ​បន្ត​ទេ។

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = គេហទំព័រ​បញ្ជាក់​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ។ { -brand-short-name } កុំ​ទុកជឿទុកចិត្ត { $hostname } ដោយ​សារ​មិន​ស្គាល់​អ្នក​ចេញ​វិញ្ញាបនបត្រ​របស់​ខ្លួន វិញ្ញាបនបត្រ​នេះ​ត្រូវបាន​ចុះហត្ថលេខា​ដោយ​ខ្លួនឯង ឬ​ម៉ាស៊ីន​មេ​​មិន​កំពុង​បញ្ជូន​វិញ្ញាបនបត្រ​ត្រឹមត្រូវ។

cert-error-trust-cert-invalid = វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត​ឡើយ ពីព្រោះ​វា​ត្រូវ​បាន​ចេញ​ដោយ​​ប្រភព​វិញ្ញាបនបត្រ​មិន​ត្រឹមត្រូវ ។

cert-error-trust-untrusted-issuer = វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត​ឡើយ ពីព្រោះ​អ្នក​ចេញ​វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត​ឡើយ ។

cert-error-trust-signature-algorithm-disabled = វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត ពីព្រោះ​វា​ត្រូ​វបាន​ចុះ​ហត្ថលេខា​ដោយ​ប្រើ​​ក្បួន​ហត្ថលេខា ដែល​ត្រូវ​បាន​បិទ ពីព្រោះ​ក្បួន​នោះ​មិនមាន​សុវត្ថិភាព​ទេ ។

cert-error-trust-expired-issuer = វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត​ឡើយ ពីព្រោះ​អ្នក​ចេញ​វិញ្ញាបនបត្រ​ផុត​កំណត់ ។

cert-error-trust-self-signed = វិញ្ញាបនបត្រ​មិន​ត្រូវ​បាន​ជឿ​ទុកចិត្ត​ឡើយ ពីព្រោះ​វា​ត្រូវ​បាន​ចុះ​ហត្ថលេខា​ខ្លួន​ឯង ។

cert-error-trust-symantec = វិញ្ញាបនបត្រ​ដែល​បាន​ចេញ​ដោយ GeoTrust, RapidSSL, Symantec, Thawte និង VeriSign លែង​ចាត់ទុក​ថា​មាន​សុវត្ថិភាព​ទៀត​ហើយ ដោយសារ​អាជ្ញាធរ​​វិញ្ញាបនបត្រ​ទាំងនេះ​មិន​អនុវត្ត​តាម​គោលការណ៍​សុវត្ថិភាព​កាលពី​មុន។

cert-error-untrusted-default = វិញ្ញាបនបត្រ​មិន​មក​ពី​ប្រភព​ដែល​ជឿ​ទុកចិត្ត​ឡើយ ។

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = គេហទំព័រ​បញ្ជាក់​​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ។ { -brand-short-name } មិន​ជឿជាក់​លើ​គេហទំព័រ​នេះ ដោយសារ​វា​ប្រើប្រាស់​វិញ្ញាបនបត្រ​ដែល​មិន​អាច​ប្រើ​បាន​​សម្រាប់ { $hostname } ទេ។

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = គេហទំព័រ​បញ្ជាក់​​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ។ { -brand-short-name } មិន​ជឿជាក់​លើ​គេហទំព័រ​នេះ ដោយសារ​វា​ប្រើប្រាស់​វិញ្ញាបនបត្រ​ដែល​មិន​អាច​ប្រើ​បាន​សម្រាប់ { $hostname } ទេ។ វិញ្ញាបនបត្រ​នេះ​​អាច​ប្រើ​បាន​សម្រាប់​តែ <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> ប៉ុណ្ណោះ។

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = គេហទំព័រ​បញ្ជាក់​​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ។ { -brand-short-name } មិន​ជឿជាក់​លើ​គេហទំព័រ​នេះ ដោយសារ​វា​ប្រើប្រាស់​វិញ្ញាបនបត្រ​ដែល​មិន​​មិន​អាច​ប្រើ​បាន​សម្រាប់ { $hostname } ទេ។ វិញ្ញាបនបត្រ​នេះ​អាច​ប្រើ​បាន​សម្រាប់តែ { $alt-name } ប៉ុណ្ណោះ។

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = គេហទំព័រ​បញ្ជាក់​​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ។ { -brand-short-name } មិន​ជឿជាក់​លើ​គេហទំព័រ​នេះ ដោយសារ​វា​ប្រើប្រាស់​វិញ្ញាបនបត្រ​ដែល​មិនអាច​ប្រើ​បាន​សម្រាប់ { $hostname } ទេ។ វិញ្ញា​បនបត្រ​នេះ​​អាច​ប្រើ​បាន​សម្រាប់​តែ​ឈ្មោះ​ខាងក្រោម៖ { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = គេហទំព័រ​បញ្ជាក់​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ ដែល​អាច​ប្រើ​បាន​ក្នុង​រយៈពេល​បាន​កំណត់​មួយ។ វិញ្ញាបនបត្រ​សម្រាប់ { $hostname } ផុត​កំណត់​នៅ { $not-after-local-time } ។

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = គេហទំព័រ​បញ្ជាក់​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ ដែល​អាច​ប្រើ​បាន​ក្នុង​រយៈពេល​បាន​កំណត់​មួយ។ វិញ្ញាបនបត្រ​សម្រាប់ { $hostname } នឹង​មិន​អាច​ប្រើ​បាន​រហូតដល់ { $not-before-local-time } ។

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = បញ្ហា​កូដ៖ <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = គេហទំព័រ​បញ្ជាក់​អត្តសញ្ញាណ​របស់​ខ្លួន​តាមរយៈ​វិញ្ញាបនបត្រ ដែល​ត្រូវបាន​ចេញ​ដោយ​អាជ្ញាធរ​វិញ្ញាបនបត្រ។ កម្មវិធី​រុករក​តាម​អ៊ីនធឺណិត​ច្រើន​បំផុត​លែង​ទុកចិត្ត​វិញ្ញាបនបត្រ​ដែល​បាន​ចេញ​ដោយ GeoTrust, RapidSSL, Symantec, Thawte និង VeriSign ទៀត​ហើយ។ { $hostname } ប្រើប្រាស់​វិញ្ញាបនបត្រ​ពី​អាជ្ញាធរ​មួយ​ក្នុង​ចំណោម​អាជ្ញាធរ​ទាំងនេះ ដូច្នេះ​ហើយ​អត្តសញ្ញាណ​របស់​គេហទំព័រ​នេះ​មិន​អាច​បញ្ជាក់​បាន​ទេ។

cert-error-symantec-distrust-admin = អ្នក​អាច​ជូនដំណឹង​ដល់​អ្នក​គ្រប់គ្រង​គេហទំព័រ​​អំពី​បញ្ហា​នេះ។

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = សុវត្ថិភាព​ដឹកជញ្ជូន​តឹងរ៉ឹង HTTP៖ { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = ការ​ខ្ទាស់​កូន​សោ​សាធារណៈ HTTP៖ { $hasHPKP }

cert-error-details-cert-chain-label = ច្រវាក់​​វិញ្ញាបនបត្រ៖

open-in-new-window-for-csp-or-xfo-error = បើក​គេហទំព័រ​នៅ​ក្នុង​ផ្ទាំង​ថ្មី

## Messages used for certificate error titles

connectionFailure-title = មិន​អាច​តភ្ជាប់
deniedPortAccess-title = អាសយដ្ឋាន​នេះ​ត្រូវ​បាន​ដាក់កម្រិត
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = ហឹម។ យើងកំពុងមានបញ្ហាក្នុងការរក​គេហទំព័រ​នោះ។
fileNotFound-title = រក​មិន​ឃើញ​ឯកសារ
fileAccessDenied-title = ការ​ចូល​ប្រើប្រាស់​ឯកសារ​ត្រូវបាន​បដិសេធ
generic-title = អ្ហុះ !
captivePortal-title = ចូល​បណ្ដាញ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = ហឹម។ អាសយដ្ឋាននោះមើលទៅមិនត្រឹមត្រូវ​ទេ។
netInterrupt-title = ការ​តភ្ជាប់​ត្រូវ​បាន​កាត់​ផ្តាច់
notCached-title = ឯកសារ​បាន​ផុត​កំណត់
netOffline-title = របៀប​ក្រៅ​បណ្ដាញ
contentEncodingError-title = កំហុស​ក្នុង​ការ​អ៊ិនកូដ​មាតិកា
unsafeContentType-title = ប្រភេទ​ឯកសារ​គ្មាន​សុវត្ថិភាព
netReset-title = ការ​តភ្ជាប់​ត្រូវ​បាន​កំណត់​ឡើង​វិញ
netTimeout-title = អស់​ពេល​ក្នុង​ការ​តភ្ជាប់
unknownProtocolFound-title = មិន​ស្គាល់​អាសយដ្ឋាន​នេះ
proxyConnectFailure-title = ម៉ាស៊ីន​បម្រើ​ប្រូកស៊ី​កំពុងតែ​បដិសេធ​ការ​តភ្ជាប់
proxyResolveFailure-title = មិន​អាច​រក​ឃើញ​ម៉ាស៊ីន​បម្រើ​ប្រូកស៊ី​
redirectLoop-title = ទំព័រ​មិន​កំពុងតែ​ប្ដូរ​ទិស​យ៉ាង​ត្រឹមត្រូវ​ទេ
unknownSocketType-title = ចម្លើយតប​ពី​ម៉ាស៊ីន​បម្រើ​ដែល​មិន​បាន​រំពឹងទុក
nssFailure2-title = ​ការ​តភ្ជាប់​សុវត្ថិភាព​បរាជ័យ
corruptedContentError-title = កំហុស​មាតិកា​ដែល​ខូច
remoteXUL-title = XUL ពី​ចម្ងាយ
sslv3Used-title = មិន​អាច​តភ្ជាប់​ដោយ​សុវត្ថិភាព​ឡើយ
inadequateSecurityError-title = ការ​ត​ភ្ជាប់​របស់​អ្នក​មិន​មាន​សុវត្ថិភាពឡើយ​
blockedByPolicy-title = ទំព័រត្រូវបានទប់ស្កាត់
clockSkewError-title = នាឡិកាកុំព្យូទ័ររបស់អ្នកមិនត្រឹមត្រូវ
networkProtocolError-title = បញ្ហា​​ពិធីការ​បណ្ដាញ
nssBadCert-title = ប្រុងប្រយ័ត្ន៖ មានហានិភ័យសុវត្ថិភាពដែលអាច​នឹង​កើត​មាន
