# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utiliza um certificado de segurança inválido.

cert-error-mitm-intro = Os websites provam a sua identidade via certificados, que são emitidos por autoridades certificadoras.

cert-error-mitm-mozilla = O { -brand-short-name } é apoiado pela, sem fins lucrativos, Waterfox, que administra um armazenamento completamente aberto de autoridade certificadora (CA). O armazenamento CA ajuda a assegura que as autoridades certificadoras estão a seguir as melhores práticas para segurança de utilizadores.

cert-error-mitm-connection = O { -brand-short-name } utiliza o armazenamento CA da Waterfox para verificar que uma ligação é segura, em vez dos certificados fornecidos pelo sistema operativo do utilizador. Por isso, se um programa antivírus ou rede estão a intercetar uma ligação com um certificado de segurança emitido por uma CA que não está no armazenamento CA da Waterfox, a ligação é considerada insegura.

cert-error-trust-unknown-issuer-intro = Alguém pode estar a tentar fazer-se passar pelo site e você não deve continuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Os websites provam a sua identidade via certificados. O { -brand-short-name } não confia em { $hostname } porque o seu emissor de certificados é desconhecido, o certificado é auto-assinado, ou o servidor não está a enviar os certificados intermediários corretos.

cert-error-trust-cert-invalid = O certificado não é de confiança porque foi emitido por uma AC inválida.

cert-error-trust-untrusted-issuer = O certificado não é de confiança porque o certificado do emissor não é de confiança.

cert-error-trust-signature-algorithm-disabled = O certificado não é de confiança porque foi assinado com um algoritmo que foi desativado por não ser seguro.

cert-error-trust-expired-issuer = O certificado não é de confiança porque o certificado do emissor expirou.

cert-error-trust-self-signed = O certificado não é de confiança porque é auto-assinado.

cert-error-trust-symantec = Certificados emitidos por GeoTrust, RapidSSL, Symantec, Thawte, e VeriSign não são mais considerados seguros porque estas autoridades de certificados não seguiram práticas de segurança no passado.

cert-error-untrusted-default = O certificado não vem de uma fonte confiável.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Os websites provam a sua identidade via certificados. O { -brand-short-name } não confia neste site porque este utiliza um certificado que não é válido para { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Os websites provam a sua identidade via certificados. O { -brand-short-name } não confia neste site porque este utiliza um certificado que não é válido para { $hostname }. O certificado só é válido para <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Os websites provam a sua identidade via certificados. O { -brand-short-name } não confia neste site porque este utiliza um certificado que não é válido para { $hostname }. O certificado só é válido para { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Os websites provam a sua identidade via certificados. O { -brand-short-name } não confia neste site porque este utiliza um certificado que não é válido para { $hostname }. O certificado apenas é válido para os seguintes nomes: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Os websites provam a sua identidade via certificados, que são válidos para um período definido de tempo. O certificado para { $hostname } expirou em { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Os websites provam a sua identidade via certificados, que são válidos para um período definido de tempo. O certificado para { $hostname } não irá ser válido até { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Código de erro: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Os websites provam a sua identidade via certificados, que são emitidos por autoridades certificadoras. A maioria dos navegadores não irão mais confiar em certificados emitidos por GeoTrust, RapidSSL, Symantec, e VeriSign. { $hostname } utiliza um certificado de uma destas autoridades e por isso a identidade do website não pode ser provada.

cert-error-symantec-distrust-admin = Pode notificar o administrador do website acerca deste problema.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Segurança rigorosa de transporte HTTP (HSTS): { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Cadeia de certificados:

open-in-new-window-for-csp-or-xfo-error = Abrir site numa nova janela

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Para proteger a sua segurança, { $hostname } não permitirá que o { -brand-short-name } apresente a página se a mesma for incorporada noutro site. Para ver esta página, deve abrir a mesma numa nova janela.

## Messages used for certificate error titles

connectionFailure-title = Ligação não estabelecida
deniedPortAccess-title = Este endereço é restrito
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hum. Estamos a ter problemas em encontrar esse site.
fileNotFound-title = Ficheiro não encontrado
fileAccessDenied-title = O acesso ao ficheiro foi negado
generic-title = Oops.
captivePortal-title = Iniciar sessão na rede
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Esse endereço não parece bem.
netInterrupt-title = A ligação foi interrompida
notCached-title = Documento expirado
netOffline-title = Modo offline
contentEncodingError-title = Erro de codificação de conteúdo
unsafeContentType-title = Tipo de ficheiro inseguro
netReset-title = A ligação foi reposta
netTimeout-title = A ligação expirou
unknownProtocolFound-title = O endereço não foi compreendido
proxyConnectFailure-title = O servidor proxy está a recusar ligações
proxyResolveFailure-title = Servidor proxy não encontrado
redirectLoop-title = A página não está a redirecionar corretamente
unknownSocketType-title = Resposta inesperada do servidor
nssFailure2-title = A ligação segura falhou
csp-xfo-error-title = O { -brand-short-name } não pode abrir esta página
corruptedContentError-title = Conteúdo corrompido
remoteXUL-title = XUL remoto
sslv3Used-title = Não é possível ligar com segurança
inadequateSecurityError-title = A sua ligação não é segura
blockedByPolicy-title = Página bloqueada
clockSkewError-title = O relógio do seu computador está errado
networkProtocolError-title = Erro de protocolo de rede
nssBadCert-title = Aviso: Potencial risco de segurança à frente
nssBadCert-sts-title = Não se ligou: potencial problema de segurança
certerror-mitm-title = Software está a impedir o { -brand-short-name } de se ligar em segurança a este site
