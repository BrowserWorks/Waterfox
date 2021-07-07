# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = Conexión segura no disponible
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = Está navegando en modo solo HTTPS, y no hay disponible una versión segura HTTPS de <em>{ $websiteUrl }</em>.
about-httpsonly-insecure-explanation-reasons = Lo más probable es que el sitio web no sea compatible con HTTPS, pero también es posible que un atacante esté bloqueando la versión HTTPS.
about-httpsonly-insecure-explanation-exception = Aunque el riesgo de seguridad es bajo, si decide visitar la versión HTTP del sitio web, no debe proporcionar ninguna información confidencial como contraseñas, correos electrónicos o detalles de tarjetas de crédito.
about-httpsonly-button-make-exception = Aceptar el riesgo e ir al sitio
about-httpsonly-title-alert = Alerta de modo solo HTTPS
about-httpsonly-title-connection-not-available = Conexión segura no disponible
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Ha activado el modo solo HTTPS para mejorar la seguridad pero no está disponible una versión HTTPS de <em>{ $websiteUrl }</em>.
about-httpsonly-explanation-question = ¿Qué podría estar causando esto?
about-httpsonly-explanation-nosupport = Lo más probable es que el sitio web simplemente no sea compatible con HTTPS.
about-httpsonly-explanation-risk = También es posible que un atacante esté involucrado. Si decide visitar el sitio web, no debe ingresar información confidencial como contraseñas, correos electrónicos o detalles de tarjetas de crédito.
about-httpsonly-explanation-continue = Si continúa, el modo solo HTTPS se desactivará temporalmente para este sitio.
about-httpsonly-button-continue-to-site = Continuar al sitio HTTP
about-httpsonly-button-go-back = Retroceder
about-httpsonly-link-learn-more = Saber más…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Posible alternativa
about-httpsonly-suggestion-box-www-text = Hay una versión segura de <em www.{ $websiteUrl }</em>. Puede visitar esta página en lugar de em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Ir a www.{ $websiteUrl }
