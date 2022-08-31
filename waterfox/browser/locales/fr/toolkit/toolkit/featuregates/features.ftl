# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS : Masonry Layout
experimental-features-css-masonry-description = Active la prise en charge de la fonctionnalité expérimentale CSS Masonry Layout. Consultez <a data-l10n-name="explainer">cette explication</a> pour une description de haut niveau de la fonctionnalité. Pour soumettre vos commentaires, veuillez commenter dans <a data-l10n-name="w3c-issue">cette issue sur GitHub</a> ou <a data-l10n-name="bug">ce bug</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = API web : WebGPU
experimental-features-web-gpu-description2 = Cette nouvelle API fournit une prise en charge de bas niveau pour effectuer des calculs et des rendus graphiques à l’aide du <a data-l10n-name="wikipedia">processeur graphique (GPU)</a> de l’appareil ou de l’ordinateur de l’utilisateur. La <a data-l10n-name="spec">spécification</a> est toujours en cours de développement. Voir le <a data-l10n-name="bugzilla">bug 1602129</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Multimédia : JPEG XL
experimental-features-media-jxl-description = Lorsque cette fonctionnalité est activée, { -brand-short-name } prend en charge le format JPEG XL (JXL). Il s’agit d’un format de fichier image amélioré qui prend en charge la transition sans perte à partir des fichiers JPEG traditionnels. Voir le <a data-l10n-name="bugzilla">bug 1539075</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS : Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = L’ajout d’un constructeur à l’interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> ainsi qu’un ensemble de modifications connexes permettent de créer directement de nouvelles feuilles de style sans avoir à ajouter celles-ci au HTML. Cela facilite beaucoup la création de feuilles de style réutilisables à utiliser avec le <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Voir le <a data-l10n-name="bugzilla">bug 1520690</a> pour plus de détails.
experimental-features-devtools-compatibility-panel =
    .label = Outils de développement : panneau Compatibilité
experimental-features-devtools-compatibility-panel-description = Un panneau latéral pour l’inspecteur de page qui affiche des informations détaillant l’état de compatibilité entre navigateurs de votre application. Voir le <a data-l10n-name="bugzilla">bug 1584464</a> pour plus de détails.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies : SameSite=Lax par défaut
experimental-features-cookie-samesite-lax-by-default2-description = Traite les cookies comme « SameSite=Lax » par défaut si l’attribut « SameSite » n’est pas spécifié. Les développeurs doivent choisir le status quo actuel d’utilisation sans restriction en définissant explicitement « SameSite=None ».
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies : SameSite=None nécessite l’attribut secure
experimental-features-cookie-samesite-none-requires-secure2-description = Les cookies avec l’attribut « SameSite=None » doivent être munis de l’attribut secure. Cette fonctionnalité nécessite l’activation de « Cookies : SameSite=Lax par défaut ».
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Cache de démarrage pour about:home
experimental-features-abouthome-startup-cache-description = Cache pour le contenu initial de la page about:home qui est chargée par défaut au démarrage. Le but de ce cache est d’améliorer les performances de démarrage.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies : Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Traite les cookies du même domaine mais avec des schémas différents (par exemple http://example.com et https://example.com) comme venant de sites différents au lieu d’un même site. Améliore la sécurité, mais casse potentiellement des choses.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Outils de développement : débogage de Service worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Active la prise en charge expérimentale des Service workers dans le panneau Débogueur. Cette fonctionnalité peut ralentir les outils de développement et augmenter la consommation de mémoire.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Activer/désactiver l’audio et la vidéo WebRTC au niveau global
experimental-features-webrtc-global-mute-toggles-description = Ajoute des commandes à l’indicateur de partage global WebRTC qui permettent aux utilisateurs de désactiver globalement leur microphone et leurs flux de caméra.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT : Warp
experimental-features-js-warp-description = Active Warp, un projet pour améliorer les performances JavaScript et l’utilisation mémoire.
# Search during IME
experimental-features-ime-search =
    .label = Barre d’adresse : afficher les résultats pendant la composition IME
experimental-features-ime-search-description = Un IME (Input Method Editor, éditeur de méthode de saisie) est un outil qui permet la saisie de symboles complexes, tels que ceux utilisés pour écrire les langues indiennes ou celles d’Asie de l’Est, tout en utilisant un clavier ordinaire. Activer cette expérience conserve ouvert le panneau de la barre d’adresse qui affiche les résultats de recherche et des suggestions, pendant que l’IME est utilisé pour saisir du texte. Notez que l’IME pourrait afficher un panneau recouvrant les résultats de la barre d’adresse, c’est pourquoi cette préférence n’est suggérée que pour les IME qui n’utilisent pas ce type de panneau.
# Text recognition for images
experimental-features-text-recognition =
    .label = Reconnaissance de texte
experimental-features-text-recognition-description = Activer les fonctionnalités de reconnaissance de texte dans des images.
