# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Ang { $hostname } ay gumagamit ng di-wastong security certificate.
cert-error-mitm-intro = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate, na siyang ini-issue nga mga certificate authority.
cert-error-mitm-mozilla = Ang { -brand-short-name } ay sinusuportahan ng non-profit na Mozilla, na nagbibigay ng bukas na certificate authority (CA) store. Sinisiguro ng CA store na sumusunod ang mga certificate authority sa mga best practice para sa seguridad ng user.
cert-error-mitm-connection = Ginagamit ng { -brand-short-name } ang Mozilla CA store para masiguro na secure ang connection, sa halip na gamitin ang mga certificate na binigay ng operating system ng user. Kaya kapag na-intercept ng isang antivirus program o network ang isang connection kung saan ang security certificate ay inissue ng isang CA na wala sa Mozilla CA store, ang connection ay hindi ligtas.
cert-error-trust-unknown-issuer-intro = Maaaring may nagpapanggap gayahin ang site, kaya hindi ka dapat tumuloy dito.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Pinapatunayan ng mga website ang kanilang identity sa pamamagitan ng mga certificate. Hindi pinagkakatiwalaan ng { -brand-short-name } ang { $hostname } dahil hindi nito kilala ang certificate issuer, o kaya ay self-signed ang certificate, o kaya ay hindi pinapadala ng server ang mga tamang intermediate certificate.
cert-error-trust-cert-invalid = Hindi pinagkakatiwalaan ang certificate dahil ito ay inissure ng isang invalid na CA certificate.
cert-error-trust-untrusted-issuer = Hindi pinagkakatiwalaan ang certificate dahil hindi katiwa-tiwala ang nag-issue nito.
cert-error-trust-signature-algorithm-disabled = Hindi pinagkakatiwalaan ang certificate dahil ito ay na-sign gamit ang isang signature algorithm na na-disable dahil hindi secure ang algorithm.
cert-error-trust-expired-issuer = Ang sertipiko ay hindi pinagkakatiwalaan dahil ang issuer ng sertipiko ay expired na.
cert-error-trust-self-signed = Ang certificate ay hindi pinagkakatiwalaan dahil ito ay sariling-pirma lamang.
cert-error-trust-symantec = Hindi na ligtas ang mga certificate na na-issue ng GeoTrust, RapidSSL, Symantec, Thawte, at VeriSign dahil ang mga certificate authority na ito ay hindi sumunod sa mga security practice dati.
cert-error-untrusted-default = Ang certificate ay hindi galing sa pinagkakatiwalaang pinangalingan.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate. Hindi pinagkakatiwalaan ng { -brand-short-name } ang site na ito dahil hindi ito gumagamit ng tamang certificate para sa { $hostname }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate. Hindi pinagkakatiwalaan ng { -brand-short-name } ang site na ito dahil ito ay gumagamit ng hindi tamang certificate para sa { $hostname }. Ang certificate ay para lamang sa <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate. Hindi pinagkakatiwalaan ng { -brand-short-name } ang site na ito dahil gumagamit ito ng certificate na hindi tama para sa { $hostname }. Ang certificate ay para lang sa { $alt-name }.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate. Hindi pinagkakatiwalaan ng { -brand-short-name } ang site na ito dahil gumagamit ito ng certificate na hindi tama para sa { $hostname }. Ang certificate ay para lamang sa mga sumusunod na mga pangalan: { $subject-alt-names }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate, na uubra lamang sa nakatakdang panahon. Nag-expire ang certificate ng { $hostname } noong { $not-after-local-time }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate, na uubra lamang sa nakatakdang panahon. Ang certificate para sa { $hostname } ay hindi maaaring gamitin hanggang { $not-before-local-time }.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Error code: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Pinapatunayan ng mga website ang kanilang identity gamit ang mga certificate na ini-issue ng mga certificate authority. Karamihan ng mga browser ay hindi na nagtitiwala sa mga certificate na inissue ng GeoTrust, RapidSSL, Symantec, Thawte, at VeriSign. Gumagamit ang { $hostname } ng certificate mula sa isa sa mga authority na ito kung kaya't hindi mapapatunayan ang identity ng website.
cert-error-symantec-distrust-admin = Maaari mong i-notify ang administrator ng website tungkol sa problemang ito.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Certificate chain:
open-in-new-window-for-csp-or-xfo-error = Buksan ang Site sa Bagong Window

## Messages used for certificate error titles

connectionFailure-title = Hindi makakonekta
deniedPortAccess-title = Ang address na ito ay pinagbabawalan
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Nagkakaproblema kami sa paghahanap ng site na iyon.
fileNotFound-title = Hindi makita ang file
fileAccessDenied-title = Pinigilan ang pag-access sa file
generic-title = Oops.
captivePortal-title = Mag log in sa network
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ang address na iyon ay hindi tama.
netInterrupt-title = Nasagabal ang koneksyon
notCached-title = Ang Dokumentong ito ay Expired
netOffline-title = Naka-Offline
contentEncodingError-title = May mali sa pag-encode na content
unsafeContentType-title = Hindi ligtas na file type
netReset-title = Ang koneksyon ay na reset
netTimeout-title = Ang koneksyon ay nag-time out
unknownProtocolFound-title = Ang address ay hindi naintindihan
proxyConnectFailure-title = Ang proxy server ay tinatanggihan ang koneksyon
proxyResolveFailure-title = Hindi mahanap ang proxy server
redirectLoop-title = Ang pahina ay hindi nag didirekta ng maayos
unknownSocketType-title = Hindi inaasahang tugon mula sa server
nssFailure2-title = Nabigo ang Ligtas na Koneksyon
csp-xfo-error-title = { -brand-short-name } Hindi Mabuksan ang Pahinang Ito
corruptedContentError-title = Corrupted Content Error
remoteXUL-title = Remote XUL
sslv3Used-title = Hindi Makakonekta nang Ligtas
inadequateSecurityError-title = Ang iyong koneksyon ay hindi ligtas
blockedByPolicy-title = Naka-block na Pahina
clockSkewError-title = Mali ang oras ng iyong computer
networkProtocolError-title = Network Protocol Error
nssBadCert-title = Babala: May Potential na Security Risk
nssBadCert-sts-title = Hindi Nag-connect: Potential Security Issue
certerror-mitm-title = May software na pumipigil sa { -brand-short-name } sa pag-connect nang ligtas sa site na ito
