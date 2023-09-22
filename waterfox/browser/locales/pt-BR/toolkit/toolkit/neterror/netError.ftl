# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problemas ao carregar a página
certerror-page-title = Alerta: Potencial risco de segurança à frente
certerror-sts-page-title = Não conectou: Potencial problema de segurança
neterror-blocked-by-policy-page-title = Página bloqueada
neterror-captive-portal-page-title = Autenticar na rede
neterror-dns-not-found-title = Servidor não encontrado
neterror-malformed-uri-page-title = URL inválida

## Error page actions

neterror-advanced-button = Avançado…
neterror-copy-to-clipboard-button = Copiar texto para área de transferência
neterror-learn-more-link = Saiba mais…
neterror-open-portal-login-page-button = Abrir página de acesso à rede
neterror-override-exception-button = Aceitar o risco e continuar
neterror-pref-reset-button = Restaurar configurações padrão
neterror-return-to-previous-page-button = Voltar
neterror-return-to-previous-page-recommended-button = Voltar (recomendado)
neterror-try-again-button = Tentar novamente
neterror-add-exception-button = Sempre continuar para este site
neterror-settings-button = Alterar configurações de DNS
neterror-view-certificate-link = Ver certificado
neterror-trr-continue-this-time = Continuar desta vez
neterror-disable-native-feedback-warning = Sempre continuar

##

neterror-pref-reset = Parece que as configurações de segurança de rede podem estar causando isso. Quer restaurar as configurações padrão?
neterror-error-reporting-automatic = Relatar erros como este para ajudar a { -vendor-short-name } a identificar e bloquear sites maliciosos

## Specific error messages

neterror-generic-error = O { -brand-short-name } não conseguiu carregar esta página por algum motivo.
neterror-load-error-try-again = Este site pode estar temporariamente indisponível ou sobrecarregado. Tente novamente daqui a pouco.
neterror-load-error-connection = Se você não conseguir carregar nenhuma página, verifique a conexão de rede do computador.
neterror-load-error-firewall = Se a rede ou o computador estiver protegido por um firewall ou proxy, verifique se o { -brand-short-name } está autorizado a acessar a web.
neterror-captive-portal = Você deve se autenticar nessa rede antes de poder acessar a internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Pretendia acessar <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Se você digitou o endereço correto, pode:</strong>
neterror-dns-not-found-hint-try-again = Tentar novamente mais tarde
neterror-dns-not-found-hint-check-network = Verificar a conexão de rede
neterror-dns-not-found-hint-firewall = Verificar se o { -brand-short-name } tem permissão para acessar a web (a conexão pode estar limitada por um firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = O { -brand-short-name } não pode proteger sua requisição para o endereço deste site através de nosso resolvedor confiável de DNS. Motivo:
neterror-dns-not-found-trr-third-party-warning2 = Você pode continuar com seu resolvedor de DNS padrão. No entanto, terceiros podem conseguir ver quais sites você visita.
neterror-dns-not-found-trr-only-could-not-connect = O { -brand-short-name } não conseguiu se conectar com { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = A conexão com { $trrDomain } demorou mais do que o esperado.
neterror-dns-not-found-trr-offline = Você não está conectado à internet.
neterror-dns-not-found-trr-unknown-host2 = Este site não foi encontrado por { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Houve um problema com { $trrDomain }.
neterror-dns-not-found-bad-trr-url = URL inválida.
neterror-dns-not-found-trr-unknown-problem = Problema não esperado.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = O { -brand-short-name } não pode proteger sua requisição para o endereço deste site através de nosso resolvedor confiável de DNS. Motivo:
neterror-dns-not-found-native-fallback-heuristic = O DNS sobre HTTPS foi desativado em sua rede.
neterror-dns-not-found-native-fallback-not-confirmed2 = O { -brand-short-name } não conseguiu se conectar com { $trrDomain }.

##

neterror-file-not-found-filename = Verifique se o nome do arquivo tem letras maiúsculas ou outros erros de digitação.
neterror-file-not-found-moved = Verifique se o arquivo foi movido, renomeado ou excluído.
neterror-access-denied = Pode ter sido removido, movido ou as permissões do arquivo podem estar impedindo o acesso.
neterror-unknown-protocol = Pode ser necessário instalar algum aplicativo para abrir este endereço.
neterror-redirect-loop = Às vezes, esse problema pode ser causado pela desativação ou recusa em aceitar cookies.
neterror-unknown-socket-type-psm-installed = Verifique se o sistema tem o Personal Security Manager instalado.
neterror-unknown-socket-type-server-config = Isto pode ser devido a uma configuração não padrão no servidor.
neterror-not-cached-intro = O documento solicitado não está disponível no cache do { -brand-short-name }.
neterror-not-cached-sensitive = Como precaução de segurança, o { -brand-short-name } não volta a solicitar automaticamente documentos sensíveis.
neterror-not-cached-try-again = Clique em 'Tentar novamente' para solicitar novamente o documento do site.
neterror-net-offline = Clique em “Tentar novamente” para mudar para modo online e recarregar a página.
neterror-proxy-resolve-failure-settings = Verifique se as configurações de proxy estão corretas.
neterror-proxy-resolve-failure-connection = Verifique se o computador tem uma conexão de rede funcionando.
neterror-proxy-resolve-failure-firewall = Se a rede ou o computador estiver protegido por um firewall ou proxy, verifique se o { -brand-short-name } está autorizado a acessar a web.
neterror-proxy-connect-failure-settings = Verifique se as configurações de proxy estão corretas.
neterror-proxy-connect-failure-contact-admin = Entre em contato com um administrador de rede para verificar se o servidor proxy está  funcionando.
neterror-content-encoding-error = Entre em contato com os responsáveis pelo site para informar este problema.
neterror-unsafe-content-type = Entre em contato com os responsáveis pelo site para informar este problema.
neterror-nss-failure-not-verified = A página que você está tentando ver não pode ser exibida porque a autenticidade dos dados recebidos não pôde ser comprovada.
neterror-nss-failure-contact-website = Entre em contato com os responsáveis pelo site para informar este problema.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = O { -brand-short-name } detectou uma potencial ameaça de segurança e não seguiu para <b>{ $hostname }</b>. Se você acessar este site, invasores podem tentar roubar suas informações, como senhas, endereços de email ou detalhes de cartões de crédito.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = O { -brand-short-name } detectou uma potencial ameaça de segurança e não seguiu para <b>{ $hostname }</b> porque este site exige uma conexão segura.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = O { -brand-short-name } detectou um problema e não seguiu para <b>{ $hostname }</b>. O site foi mal configurado ou o relógio interno desde computador está errado.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> provavelmente é um site seguro, mas não pôde ser estabelecida uma conexão segura. Este problema é causado por <b>{ $mitm }</b>, que é um programa neste computador ou na rede.
neterror-corrupted-content-intro = A página que você está tentando ver não pode ser exibida porque foi detectado um erro na transmissão de dados.
neterror-corrupted-content-contact-website = Entre em contato com os responsáveis pelo site para informar este problema.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Informações avançadas: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> usa uma tecnologia de segurança ultrapassada e vulnerável a ataques. Um invasor pode facilmente coletar informações que você acreditava estar seguras. O administrador do site precisa consertar o servidor antes de você poder acessar o site.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Código de erro: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = O relógio deste computador está em { DATETIME($now, dateStyle: "medium") }, o que impede que o { -brand-short-name } se conecte com segurança. Para acessar <b>{ $hostname }</b>, ajuste o relógio do computador para data, hora e fuso horário corretos nas configurações do sistema, depois recarregue <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = A página que você está tentando ver não pode ser exibida porque foi detectado um erro no protocolo de rede.
neterror-network-protocol-error-contact-website = Entre em contato com os responsáveis pelo site para informar este problema.
certerror-expired-cert-second-para = Provavelmente o certificado do site está expirado, impedindo que o { -brand-short-name } se conecte com segurança. Se você acessar este site, invasores podem tentar roubar informações como senhas, endereços de email ou detalhes de cartões de crédito.
certerror-expired-cert-sts-second-para = Provavelmente o certificado do site está expirado, impedindo que o { -brand-short-name } se conecte com segurança.
certerror-what-can-you-do-about-it-title = O que você pode fazer a respeito?
certerror-unknown-issuer-what-can-you-do-about-it-website = É mais provável que o problema seja no site, não há nada que você possa fazer para resolver.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Se estiver em uma rede corporativa ou usando um antivírus, você pode pedir ajuda às equipes de suporte. Também pode notificar o administrador do site.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = O relógio desde computador está definido para { DATETIME($now, dateStyle: "medium") }. Verifique se o computador está configurado com data, hora e fuso horário corretos nas configurações do sistema, depois recarregue <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Se o relógio já está com a hora correta, o site deve estar configurado incorretamente, não há nada que você possa fazer para resolver. Notifique o problema para o administrador do site.
certerror-bad-cert-domain-what-can-you-do-about-it = É mais provável que o problema seja no site, não há nada que você possa fazer para resolver. Você pode notificar o administrador do site.
certerror-mitm-what-can-you-do-about-it-antivirus = Se seu programa antivírus tem um recurso que varre conexões criptografadas (normalmente chamado “web scanning” ou “https scanning”), você pode desativar este recurso. Se isso não resolver, pode tentar remover e reinstalar o programa antivírus.
certerror-mitm-what-can-you-do-about-it-corporate = Se você está em uma rede corporativa, pode entrar em contato com o departamento de informática.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Se você não está familiarizado com <b>{ $mitm }</b>, então isso pode ser uma tentativa de ataque. É melhor não seguir para o site.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Se você não está familiarizado com <b>{ $mitm }</b>, então isso pode ser uma tentativa de ataque e não há nada que você possa fazer para acessar o site.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> tem uma diretiva de segurança chamada HTTP Strict Transport Security (HSTS), que significa que o { -brand-short-name } só pode se conectar a ele com segurança. Você não pode adicionar uma exceção para acessar este site.
