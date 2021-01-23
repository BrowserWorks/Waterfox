# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Úsáideann { $hostname } teastas neamhbhailí slándála.

cert-error-trust-cert-invalid = Ní chuirtear muinín sa teastas toisc é a bheith eisithe ag teastas neamhbhailí Údaráis Deimhniúcháin.

cert-error-trust-untrusted-issuer = Ní chuirtear muinín sa teastas toisc nach gcuirtear muinín i dteastas an eisitheora.

cert-error-trust-signature-algorithm-disabled = Ní chuirtear muinín sa teastas toisc gur síníodh é le halgartam atá díchumasaithe toisc nach bhfuil sé slán.

cert-error-trust-expired-issuer = Ní chuirtear muinín sa teastas mar tá teastas an eisitheora as feidhm.

cert-error-trust-self-signed = Ní chuirtear muinín sa teastas mar tá sé féinsínithe.

cert-error-untrusted-default = Ní thagann an teastas ó fhoinse ina gcuirtear muinín.

cert-error-symantec-distrust-admin = Tig leat scéala a chur chuig riarthóir an tsuímh faoin bhfadhb sin.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Slándáil Dhian Aistrithe HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Pionnáil Eochrach Poiblí HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Slabhra teastais:

## Messages used for certificate error titles

connectionFailure-title = Ní féidir ceangal
deniedPortAccess-title = Tá an seoladh seo srianta
fileNotFound-title = Comhad gan aimsiú
fileAccessDenied-title = Diúltaíodh rochtain ar an gcomhad
generic-title = Úps.
captivePortal-title = Logáil isteach sa líonra
netInterrupt-title = Idirbhriseadh an ceangal
notCached-title = Cáipéis As Feidhm
netOffline-title = Mód as líne
contentEncodingError-title = Earráid Ionchódaithe Inneachair
unsafeContentType-title = Cineál Comhaid Baolach
netReset-title = Athshocraíodh an ceangal
netTimeout-title = Ceangal imithe thar am
unknownProtocolFound-title = Níor tuigeadh an seoladh
proxyConnectFailure-title = Tá an seachfhreastalaí ag diúltú le ceangail
proxyResolveFailure-title = Ní féidir an seachfhreastalaí a aimsiú
redirectLoop-title = Níl an leathanach ag atreorú i gceart
unknownSocketType-title = Freagra nach rabhthas ag súil leis ón bhfreastalaí
nssFailure2-title = Níorbh Fhéidir Ceangal Slán a Bhunú
corruptedContentError-title = Earráid: Ábhar Truaillithe
remoteXUL-title = XUL Cianda
sslv3Used-title = Ní féidir ceangal slán a bhunú
inadequateSecurityError-title = Níl do cheangal slán
