# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } gebruik 'n ongeldige sekuriteitsertifikaat.

cert-error-trust-cert-invalid = Die sertifikaat word nie vertrou nie omdat dit deur 'n ongeldige SO-sertifikaat uitgereik is.

cert-error-trust-untrusted-issuer = Die sertifikaat word nie vertrou nie omdat die uitreikersertifikaat nie vertrou word nie.

cert-error-trust-signature-algorithm-disabled = Die sertifikaat word nie vertrou nie omdat dit geteken is met 'n handtekeningalgoritme wat gedeaktiveer is omdat daardie algoritme nie veilig is nie.

cert-error-trust-expired-issuer = Die sertifikaat word nie vertrou nie omdat die uitreikersertifikaat verval het.

cert-error-trust-self-signed = Die sertifikaat word nie vertrou nie omdat dit selfonderteken is.

cert-error-untrusted-default = Die sertifikaat kom nie van 'n vertroude bron nie.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP streng oordragsekuriteit: { $hasHSTS }

cert-error-details-cert-chain-label = Sertifikaaatketting:

## Messages used for certificate error titles

connectionFailure-title = Kan nie koppel nie
deniedPortAccess-title = Hierdie adres het beperkings op
fileNotFound-title = Lêer nie gevind nie
fileAccessDenied-title = Toegang tot die lêer is geweier
generic-title = Oeps.
captivePortal-title = Meld aan by netwerk
netInterrupt-title = Die verbinding is onderbreek
notCached-title = Dokumentgeldigheid het verval
netOffline-title = Vanlynmodus
contentEncodingError-title = Inhoudenkoderingfout
unsafeContentType-title = Onveilige lêersoort
netReset-title = Die verbinding is teruggestel
netTimeout-title = Die verbinding het uitgetel
unknownProtocolFound-title = Die adres word nie verstaan nie
proxyConnectFailure-title = Die instaanbediener weier die verbindings
proxyResolveFailure-title = Kon nie die instaanbediener vind nie
redirectLoop-title = Die bladsy herverwys nie behoorlik nie
unknownSocketType-title = Onverwagse respons vanaf bediener
nssFailure2-title = Kon nie beveilig koppel nie
corruptedContentError-title = Fout: inhoud korrup
remoteXUL-title = Afgeleë XUL
sslv3Used-title = Kan nie beveilig koppel nie
inadequateSecurityError-title = Die verbinding is nie beveilig nie
