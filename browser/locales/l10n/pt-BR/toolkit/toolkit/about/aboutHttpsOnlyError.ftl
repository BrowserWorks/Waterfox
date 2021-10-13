# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = Alerta de modo somente HTTPS
about-httpsonly-title-connection-not-available = Conexão segura não disponível
about-httpsonly-title-site-not-available = Site seguro não disponível
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Você ativou o modo somente HTTPS para maior segurança, mas uma versão HTTPS de <em>{ $websiteUrl }</em> não está disponível.
about-httpsonly-explanation-question = O que pode estar causando isso?
about-httpsonly-explanation-nosupport = Provavelmente, o site simplesmente não oferece suporte a HTTPS.
about-httpsonly-explanation-risk = Também é possível que um invasor esteja envolvido. Se você decidir visitar o site, não deve inserir nenhuma informação sensível, como senhas, emails ou detalhes de cartões de crédito.
about-httpsonly-explanation-continue = Se você continuar, o modo somente HTTPS será desativado temporariamente neste site.
about-httpsonly-button-continue-to-site = Continuar para a versão HTTP do site
about-httpsonly-button-go-back = Voltar
about-httpsonly-link-learn-more = Saiba mais…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Possível alternativa
about-httpsonly-suggestion-box-www-text = Existe uma versão segura de <em>www.{ $websiteUrl }</em>. Você pode visitar esta página ao invés de <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Ir para www.{ $websiteUrl }
