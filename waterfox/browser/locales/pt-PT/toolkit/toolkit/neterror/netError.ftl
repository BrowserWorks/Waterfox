# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problema ao carregar página
certerror-page-title = Aviso: Potencial risco de segurança à frente
certerror-sts-page-title = Não se ligou: potencial problema de segurança
neterror-blocked-by-policy-page-title = Página bloqueada
neterror-captive-portal-page-title = Iniciar sessão na rede
neterror-dns-not-found-title = Servidor não encontrado
neterror-malformed-uri-page-title = URL inválido

## Error page actions

neterror-advanced-button = Avançado…
neterror-copy-to-clipboard-button = Copiar texto para a área de transferência
neterror-learn-more-link = Saber mais…
neterror-open-portal-login-page-button = Abrir página de início de sessão da rede
neterror-override-exception-button = Aceitar o risco e continuar
neterror-pref-reset-button = Restaurar definições predefinidas
neterror-return-to-previous-page-button = Retroceder
neterror-return-to-previous-page-recommended-button = Retroceder (recomendado)
neterror-try-again-button = Tentar novamente
neterror-add-exception-button = Continuar sempre para este site
neterror-settings-button = Alterar definições de DNS
neterror-view-certificate-link = Ver certificado
neterror-trr-continue-this-time = Continuar desta vez
neterror-disable-native-feedback-warning = Continuar sempre

##

neterror-pref-reset = Parece que as suas definições de segurança de rede podem estar a causar isto. Pretende que as definições predefinidas sejam restauradas?
neterror-error-reporting-automatic = Comunicar erros como este para ajudar a { -vendor-short-name } a identificar e bloquear sites maliciosos

## Specific error messages

neterror-generic-error = O { -brand-short-name } não conseguiu carregar a página por alguma razão.
neterror-load-error-try-again = O site pode estar temporariamente indisponível ou demasiado ocupado. Tente novamente dentro de alguns momentos.
neterror-load-error-connection = Se não conseguir carregar quaisquer páginas, verifique a ligação do seu computador à rede.
neterror-load-error-firewall = Se o seu computador ou rede estiverem protegidos por uma firewall ou proxy, certifique-se de que o { -brand-short-name } tem permissão para aceder à Web.
neterror-captive-portal = Tem de iniciar sessão nesta rede antes de poder aceder à Internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Pretendia aceder a <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Se inseriu o endereço correto, pode:</strong>
neterror-dns-not-found-hint-try-again = Tentar novamente mais tarde
neterror-dns-not-found-hint-check-network = Verificar a sua ligação à rede
neterror-dns-not-found-hint-firewall = Verificar se { -brand-short-name } tem permissão para aceder à Internet (pode estar ligado, mas atrás de uma firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = O { -brand-short-name } não pode proteger o seu pedido para o endereço deste site através do nosso tradutor de DNS de confiança. Eis o motivo:
neterror-dns-not-found-trr-third-party-warning2 = Pode continuar com o seu tradutor de DNS predefinido. No entanto, terceiros poderão conseguir consultar os sites que visita.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } não conseguiu conectar-se a { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = A ligação a { $trrDomain } demorou mais do que era expectável.
neterror-dns-not-found-trr-offline = Não se encontra ligado à Internet.
neterror-dns-not-found-trr-unknown-host2 = Este site não foi encontrado por { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Houve um problema com { $trrDomain }.
neterror-dns-not-found-bad-trr-url = URL inválido.
neterror-dns-not-found-trr-unknown-problem = Problema inesperado.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = O { -brand-short-name } não pode proteger o seu pedido para o endereço deste site através do nosso tradutor de DNS de confiança. Eis o motivo:
neterror-dns-not-found-native-fallback-heuristic = O DNS sob HTTPS foi desativado na sua rede.
neterror-dns-not-found-native-fallback-not-confirmed2 = O { -brand-short-name } não conseguiu ligar-se a { $trrDomain }.

##

neterror-file-not-found-filename = Verifique se existem erros de escrita no nome do ficheiro.
neterror-file-not-found-moved = Verifique se o ficheiro foi movido, renomeado ou apagado.
neterror-access-denied = Este pode ter sido removido, movido ou as permissões do ficheiro podem estar a impedir o acesso.
neterror-unknown-protocol = Pode precisar de instalar outro programa para abrir este endereço.
neterror-redirect-loop = Este problema pode, por vezes, ser causado por desativar ou recusar aceitar cookies.
neterror-unknown-socket-type-psm-installed = Verifique se o seu sistema tem o Personal Security Manager instalado.
neterror-unknown-socket-type-server-config = Isto pode ser causado por uma configuração não comum no servidor.
neterror-not-cached-intro = O documento solicitado não está disponível na cache do { -brand-short-name }.
neterror-not-cached-sensitive = Como medida de segurança, o { -brand-short-name } não solicita novamente e de forma automática documentos sensíveis.
neterror-not-cached-try-again = Clique em Tentar novamente para solicitar novamente o documento do site.
neterror-net-offline = Pressione “Tentar novamente” para trocar para o modo online e recarregar a página.
neterror-proxy-resolve-failure-settings = Verifique se as definições do proxy estão corretas.
neterror-proxy-resolve-failure-connection = Verifique se o seu computador tem uma ligação de rede ativa.
neterror-proxy-resolve-failure-firewall = Se o seu computador ou rede estiverem protegidos por uma firewall ou um proxy, verifique se o { -brand-short-name } tem permissão de acesso à Web.
neterror-proxy-connect-failure-settings = Verifique as definições do proxy.
neterror-proxy-connect-failure-contact-admin = Contacte o administrador de rede para ter a certeza de que o servidor proxy está a funcionar.
neterror-content-encoding-error = Por favor, contacte os proprietários do site para os informar deste problema.
neterror-unsafe-content-type = Por favor, contacte os proprietários do site para os informar deste problema.
neterror-nss-failure-not-verified = A página que está a tentar ver não pode ser mostrada porque não foi possível verificar a autenticidade dos dados recebidos.
neterror-nss-failure-contact-website = Por favor, contacte os proprietários do site para os informar deste problema.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = O { -brand-short-name } detetou um potencial risco de segurança e não continuou para <b>{ $hostname }</b>. Se visitar este site, atacantes podem tentar furtar informação como palavras-passe, emails, ou detalhes de cartão de crédito.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = O { -brand-short-name } detetou uma potencial ameaça de segurança e não continuou para <b>{ $hostname }</b> porque este site requer uma ligação segura.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = O { -brand-short-name } detetou um problema e não continuou para <b>{ $hostname }</b>. O site está mal configurado ou o relógio do computador está definido para a hora errada.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> é provavelmente um site seguro, mas uma ligação segura não pôde ser estabelecida. O problema é causado por <b>{ $mitm }</b>, que é um software no seu computador ou rede.
neterror-corrupted-content-intro = A página que está a tentar ver não pode ser mostrada porque foi detetado um erro na transmissão de dados.
neterror-corrupted-content-contact-website = Por favor contacte os proprietários do site para os informar sobre este problema.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Informação avançada: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> utiliza tecnologia de segurança que está desatualizada e vulnerável a ataques. Um atacante pode facilmente revelar a informação que você achou que estaria segura. O administrador do site necessita de corrigir o problema no servidor antes de poder visitar o site.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Código de erro: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = O seu computador pensa que são { DATETIME($now, dateStyle: "medium") }, o que impede que o { -brand-short-name } se ligue corretamente. Para visitar <b>{ $hostname }</b>, atualize o relógio do seu computador nas suas definições de sistema para a data, hora, e fuso horário corretos, e depois atualize <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = A página que está a tentar ver não pode ser mostrada porque um erro de protocolo de rede foi detetado.
neterror-network-protocol-error-contact-website = Por favor contacte os proprietários do site para os informar sobre este problema.
certerror-expired-cert-second-para = É provável que o certificado do site tenha expirado, o que impede o { -brand-short-name } de se ligar com segurança. Se visitar este site, atacantes podem tentar furtar informação como as suas palavras-passe, emails, ou detalhes de cartões de crédito.
certerror-expired-cert-sts-second-para = É provável que o certificado do site tenha expirado, o que impede o { -brand-short-name } de se ligar com segurança.
certerror-what-can-you-do-about-it-title = O que pode fazer quanto a isto?
certerror-unknown-issuer-what-can-you-do-about-it-website = O mais provável é que o problema seja do site e não há nada que possa fazer para o resolver.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Se está numa rede empresarial ou a utilizar software de anti-vírus, pode entrar em contacto com as equipas de apoio para assistência. Pode também notificar o administrador do site sobre o problema.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = O relógio do seu computador está definido para { DATETIME($now, dateStyle: "medium") }. Certifique-se que o seu computador está definido para a data, hora e fuso horário corretos nas suas definições de sistema, e depois atualize <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Se o seu relógio já está definido para a hora correta, o site deve estar mal configurado e não há nada que possa fazer para resolver o problema. Pode notificar o administrador do site sobre o problema.
certerror-bad-cert-domain-what-can-you-do-about-it = O mais provável é que o problema seja do site e não há nada que possa fazer para o resolver. Pode notificar o administrador do site sobre o problema.
certerror-mitm-what-can-you-do-about-it-antivirus = Se o seu software antivírus inclui uma funcionalidade que verifica ligações encriptadas (geralmente chamado “verificação da web” ou “verificação de https”), pode desativar essa funcionalidade. Se isso não funcionar, pode remover ou reinstalar o software antivírus.
certerror-mitm-what-can-you-do-about-it-corporate = Se está uma rede corporativa, pode contactar o seu departamento de TI.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Se não estiver familiarizado(a) com <b>{ $mitm }</b>, então isto pode ser um ataque e não deve continuar para o site.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Se não estiver familiarizado(a) com <b>{ $mitm }</b>, então isto pode ser um ataque, e não há nada que possa fazer para aceder ao site.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> tem uma política de segurança chamada HTTP Strict Transport Security (HSTS), que significa que o { -brand-short-name } apenas pode ligar-se em segurança. Não pode adicionar uma exceção para visitar este site.
