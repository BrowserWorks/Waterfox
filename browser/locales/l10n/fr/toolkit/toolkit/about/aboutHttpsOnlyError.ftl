# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = Connexion sécurisée non disponible
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = Vous naviguez en mode HTTPS uniquement, mais aucune version HTTPS sécurisée de <em>{ $websiteUrl }</em> n’est disponible.
about-httpsonly-insecure-explanation-reasons = Il est très probable que le site web ne prenne pas en charge HTTPS, mais il est également possible qu’un attaquant bloque la version HTTPS.
about-httpsonly-insecure-explanation-exception = Bien que le risque de sécurité soit faible, si vous décidez de visiter la version HTTP du site web, il vaut mieux éviter de saisir des informations sensibles comme des mots de passe, des adresses électroniques ou des informations de cartes bancaires.
about-httpsonly-button-make-exception = Accepter le risque et continuer sur le site
about-httpsonly-title-alert = Avertissement du mode « HTTPS uniquement »
about-httpsonly-title-connection-not-available = Connexion sécurisée non disponible
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Vous avez activé le mode « HTTPS uniquement » pour une sécurité renforcée, mais il n’existe aucune version HTTPS du site <em>{ $websiteUrl }</em>.
about-httpsonly-explanation-question = Quelle peut en être la cause ?
about-httpsonly-explanation-nosupport = Très probablement, le site web ne prend tout simplement pas en charge HTTPS.
about-httpsonly-explanation-risk = Il est également possible qu’un malfaiteur soit impliqué. Si vous décidez de visiter ce site web, il vaut mieux éviter de saisir des informations sensibles comme des mots de passe, des adresses électroniques ou des informations de cartes bancaires.
about-httpsonly-explanation-continue = Si vous continuez, le mode « HTTPS uniquement » sera temporairement désactivé pour ce site.
about-httpsonly-button-continue-to-site = Continuer vers le site HTTP
about-httpsonly-button-go-back = Retour
about-httpsonly-link-learn-more = En savoir plus…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Autre possibilité
about-httpsonly-suggestion-box-www-text = Il existe une version sécurisée de <em>www.{ $websiteUrl }</em>. Vous pouvez visiter cette page au lieu de <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Ouvrir www.{ $websiteUrl }
