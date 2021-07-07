# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = Alerta modo Apenas HTTPS
about-httpsonly-title-connection-not-available = Ligação segura não disponível
about-httpsonly-title-site-not-available = Site seguro não disponível
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Ativou o modo Apenas HTTPS para uma maior segurança e não está disponível uma versão HTTPS de <em>{ $websiteUrl }</em>.
about-httpsonly-explanation-question = O que pode estar na origem disto?
about-httpsonly-explanation-nosupport = Provavelmente, o site simplesmente não suporta HTTPS.
about-httpsonly-explanation-risk = Também é possível que um atacante esteja envolvido. Se decidir visitar o site, não deve introduzir quaisquer informações sensíveis, como palavras-passe, e-mails ou detalhes de cartões de crédito.
about-httpsonly-explanation-continue = Se você continuar, o modo Apenas HTTPS será temporariamente desativado para este site.
about-httpsonly-button-continue-to-site = Continuar para site HTTP
about-httpsonly-button-go-back = Retroceder
about-httpsonly-link-learn-more = Saber mais…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Possível alternativa
about-httpsonly-suggestion-box-www-text = Existe uma versão segura de <em>www.{ $websiteUrl }</em>. Pode optar por visitar esta página em vez de <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Ir para www.{ $websiteUrl }
