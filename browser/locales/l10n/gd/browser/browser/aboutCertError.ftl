# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Tha { $hostname } a' cleachdadh teisteanas tèarainteachd mì-dhligheach.
cert-error-mitm-intro = Tha làraichean-lìn a’ dearbhadh cò iad le teisteanasan agus tha iad sin ’gam foillseachadh le ùghdarrasan theisteanasan.
cert-error-mitm-mozilla = Tha taic a’ bhuidhinn neo-phrothaidich Mozilla aig { -brand-short-name } agus tha iad a’ rianachd ùghdarras theisteanasan (CA) fosgailte. Tha stòras an CA a’ dèanamh cinnteach gu bheil ùghdarrasan nan teisteanasan a’ leantainn nan riaghailtean a mholar airson tèarainteachd chleachdaichean.
cert-error-mitm-connection = Tha { -brand-short-name } a’ cleachdadh stòras CA Mozilla airson dearbhadh gu bheil ceangal tèarainte, seach teisteanasan a sholair siostam-obrachaidh a’ chleachdaiche. Ma tha prògram an aghaidh bhìorasan no lìonra ag eadar-cheapadh ceangal le teisteanas tèarainteachd a chaidh fhoillseachadh le CA nach eil ann an stòras CA Mozilla, tuigear dheth nach eil an ceangal sàbhailte.
cert-error-trust-unknown-issuer-intro = Dh’fhaoidte gu bheil cuideigin a’ leigeil orra gur iad-san an làrach seo agus cha bu chòir dhut leantainn air adhart.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan. Chan eil { -brand-short-name } a’ cur earbsa ann an { $hostname } a chionn ’s nach aithne dhuinn foillsichear an teisteanais aca, gun deach an teisteanas a fhèin-soidhneadh no nach eil am frithealaiche a’ cur nam meadhan-teisteanasan ceart.
cert-error-trust-cert-invalid = Chan eil earbsa san teisteanas seo a chionn 's gun deach fhoillseachadh le teisteanas mì-dhligheach de dh'ùghdarras teisteanachaidh.
cert-error-trust-untrusted-issuer = Chan eil earbsa san teisteanas seo a chionn 's nach eil earbsa ann am foillsichear an teisteanais.
cert-error-trust-signature-algorithm-disabled = Chan eil earbsa san teisteanas a chionn 's gun deach a shoidhneadh le algairim soidhnidh a chaidh a chur à comas a chionn 's nach eil an algairim tèarainte.
cert-error-trust-expired-issuer = Chan eil earbsa san teisteanas seo a chionn 's gun do dh'fhalbh an ùine air teisteanas an fhoillsicheir.
cert-error-trust-self-signed = Chan eil earbsa san teisteanas seo a chionn 's gun deach a fhèin-shoidhneadh.
cert-error-trust-symantec = Chan eilear dhen bheachd gu bheil teisteanasan le GeoTrust, RapidSSL, Symantec, Thawte agus VeriSign sàbhailte tuilleadh a chionn ’s nach robh na h-ùghdarrasan theisteanasan seo a’ leantainn gnàthasan tèarainteach roimhe seo.
cert-error-untrusted-default = Chan eil earbsa san tùs on dàinig an teisteanas seo.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan. Chan eil earbsa aig { -brand-short-name } san làrachd seo a chionn ’s gu bheil e a’ cleachdadh teisteanas nach eil dligheach mu choinneamh { $hostname }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan. Chan eil earbsa aig { -brand-short-name } san làrachd seo a chionn ’s gu bheil e a’ cleachdadh teisteanas nach eil dligheach mu choinneamh { $hostname }. Chan e teisteanas dligheach a tha seo ach airson <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan. Chan eil earbsa aig { -brand-short-name } san làrachd seo a chionn ’s gu bheil e a’ cleachdadh teisteanas nach eil dligheach mu choinneamh { $hostname }. Chan e teisteanas dligheach a tha seo ach airson { $alt-name }.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan tèarainteachd. Chan eil earbsa aig { -brand-short-name } san làrach seo a chionn ’s gu bheil e a’ cleachdadh teisteanas nach eil dligheach airson { $hostname }. Chan eil an teisteanas dligheach ach airson nan ainmean a leanas: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan a dh’obraicheas fad greis. Dh’fhalbh an ùine air an teisteanas aig { $hostname } { $not-after-local-time }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan a dh’obraicheas fad greis. Cha bhi teisteanas airson { $hostname } dligheach ron { $not-before-local-time }.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Còd na mearachd: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Bidh làraichean-lìn a’ dearbhadh cò iad le teisteanasan tèarainteachd a tha ’gam foillseachadh le ùghdarrasan theisteanasan. Chan eil earbsa aig a’ mhòrchuid de bhrabhsairean ann an GeoTrust, RapidSSL, Symantec, Thawte agus VeriSign tuilleadh. Tha { $hostname } a’ cleachdadh teisteanas o aon dhe na h-ùghdarrasan seo agus cha ghabh dearbh-aithne na làraich-lìn a dhearbhadh ri linn sin.
cert-error-symantec-distrust-admin = ’S urrainn dhut fios a leigeil gu rianaire na làraich-lìn seo mun duilgheadas seo.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Sèine an teisteanais:
open-in-new-window-for-csp-or-xfo-error = Fosgail an làrach ann an uinneag ùr

## Messages used for certificate error titles

connectionFailure-title = Cha ghabh ceangal a dhèanamh ris
deniedPortAccess-title = Tha an seòladh seo cuingichte
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hm, tha duilgheasan againn a’ faighinn sgeul air an làrach seo.
fileNotFound-title = Cha deach am faidhle a lorg
fileAccessDenied-title = Chaidh inntrigeadh dhan fhaidhle a dhiùltadh
generic-title = Mo chreach!
captivePortal-title = Clàraich a-steach dhan lìonra
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hm chan eil coltas ceart air an t-seòladh sin.
netInterrupt-title = Bhris rudeigin a-steach air a' cheangal
notCached-title = Dh'fhalbh an ùine air an sgrìobhainn
netOffline-title = Am modh far loidhne
contentEncodingError-title = Mearachd le còdachadh na susbaint
unsafeContentType-title = Faidhle de sheòrsa neo-thèarainte
netReset-title = Chaidh an ceangal ath-shuidheachadh
netTimeout-title = Dh'fhalbh an ùine air a' cheangal
unknownProtocolFound-title = Cha deach an seòladh a thuigsinn
proxyConnectFailure-title = Tha am frithealaiche progsaidh a' diùltadh cheanglaichean
proxyResolveFailure-title = Cha ghabh am frithealaiche progsaidh a lorg
redirectLoop-title = Chan eil an duilleag ag ath-stiùireadh mar bu chòir
unknownSocketType-title = Freagairt ris nach robh dùil on fhrithealaiche
nssFailure2-title = Dh’fhàillig an ceangal tèarainte
corruptedContentError-title = Mearachd air sgàth susbaint thruaillte
remoteXUL-title = XUL cèin
sslv3Used-title = Chan urrainn dhuinn ceangal tèarainte a dhèanamh
inadequateSecurityError-title = Chan eil an ceangal agad tèarainte
blockedByPolicy-title = Duilleag bhacte
clockSkewError-title = Tha cleoc a’ choimpiutair agad cearr
networkProtocolError-title = Mearachd pròtacal an lìonraidh
nssBadCert-title = Rabhadh: Tha rud romhad a dh’fhaodadh a bhith ’na chunnart tèarainteachd
nssBadCert-sts-title = Cha deach ceangal a dhèanamh: Rud a dh’fhaodadh a bhith ’na chunnart tèarainteachd
certerror-mitm-title = Tha bathar-bog ann a tha a’ cumail { -brand-short-name } o bhith a’ dèanamh ceangal tèarainte ris an làrach seo
