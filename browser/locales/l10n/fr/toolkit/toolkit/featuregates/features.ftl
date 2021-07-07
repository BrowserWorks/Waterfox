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
experimental-features-css-cascade-layers =
    .label = CSS : Cascade Layers
experimental-features-css-cascade-layers-description = Active la prise en charge des couches CSS en cascade (cascade layers). Voir la <a data-l10n-name="spec">spécification en cours de création</a> pour plus de détails. Signalez tout problème en créant un bug bloquant le <a data-l10n-name="bugzilla">bug 1699215</a> s’il est lié à cette fonctionnalité.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = API web : WebGPU
experimental-features-web-gpu-description2 = Cette nouvelle API fournit une prise en charge de bas niveau pour effectuer des calculs et des rendus graphiques à l’aide du <a data-l10n-name="wikipedia">processeur graphique (GPU)</a> de l’appareil ou de l’ordinateur de l’utilisateur. La <a data-l10n-name="spec">spécification</a> est toujours en cours de développement. Voir le <a data-l10n-name="bugzilla">bug 1602129</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Multimédia : AVIF
experimental-features-media-avif-description = Lorsque cette fonctionnalité est activée, { -brand-short-name } prend en charge le format AV1 Image File (AVIF). Ce format de fichier d’image fixe exploite les capacités des algorithmes de compression vidéo AV1 pour réduire la taille de l’image. Consultez le <a data-l10n-name="bugzilla">bug 1443863</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Multimédia : JPEG XL
experimental-features-media-jxl-description = Lorsque cette fonctionnalité est activée, { -brand-short-name } prend en charge le format JPEG XL (JXL). Il s’agit d’un format de fichier image amélioré qui prend en charge la transition sans perte à partir des fichiers JPEG traditionnels. Voir le <a data-l10n-name="bugzilla">bug 1539075</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = API web : inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Notre implémentation de l’attribut global <a data-l10n-name="mdn-inputmode">inputmode</a> a été mise à jour conformément à <a data-l10n-name="whatwg">la spécification WHATWG</a>, mais nous devons encore apporter d’autres modifications, comme la rendre disponible sur du contenu modifiable via contenteditable. Voir le <a data-l10n-name="bugzilla">bug 1205133</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS : Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = L’ajout d’un constructeur à l’interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> ainsi qu’un ensemble de modifications connexes permettent de créer directement de nouvelles feuilles de style sans avoir à ajouter celles-ci au HTML. Cela facilite beaucoup la création de feuilles de style réutilisables à utiliser avec le <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Voir le <a data-l10n-name="bugzilla">bug 1520690</a> pour plus de détails.
experimental-features-devtools-color-scheme-simulation =
    .label = Outils de développement : simulation de jeux de couleurs
experimental-features-devtools-color-scheme-simulation-description = Ajoute une option pour simuler différents schémas de couleurs vous permettant de tester les requêtes média <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. L’utilisation de cette requête permet à votre feuille de style de répondre aux préférences utilisateur d’une interface claire ou sombre. Cette fonctionnalité vous permet de tester votre code sans avoir à modifier les paramètres de votre navigateur (ou du système d’exploitation, si le navigateur gère ce paramètre à l’échelle du système). Voir les <a data-l10n-name="bugzilla1">bug 1550804</a> et <a data-l10n-name="bugzilla2">bug 1137699</a> pour plus de détails.
experimental-features-devtools-execution-context-selector =
    .label = Outils de développement : sélecteur de contexte d’exécution
experimental-features-devtools-execution-context-selector-description = Cette fonction affiche un bouton sur la ligne de commande de la console permettant de modifier le contexte dans lequel l’expression saisie sera exécutée. Pour plus de détails, consultez les <a data-l10n-name="bugzilla1">bug 1605154</a> et <a data-l10n-name="bugzilla2">bug 1605153</a>.
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
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Verrouillage Win32k
experimental-features-win32k-lockdown-description = Désactive l’utilisation des API Win32k dans les onglets du navigateur. Permet une augmentation de la sécurité, mais peut être instable ou incomplet pour le moment. (Windows uniquement)
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT : Warp
experimental-features-js-warp-description = Active Warp, un projet pour améliorer les performances JavaScript et l’utilisation mémoire.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (isolement des sites)
experimental-features-fission-description = Fission (isolement des sites) est une fonctionnalité expérimentale de { -brand-short-name } qui fournit un niveau supplémentaire de défense contre des problèmes de sécurité. En isolant chaque site dans un processus séparé, Fission rend plus compliqué pour des sites malveillants l’accès aux informations d’autres pages que vous visitez. Il s’agit d’un changement d’architecture majeur de { -brand-short-name } et nous apprécions que vous le testiez et signaliez tous les problèmes que vous pourriez rencontrer. Pour davantage de détails, consultez <a data-l10n-name="wiki">le wiki</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Prise en charge de plusieurs incrustations vidéo
experimental-features-multi-pip-description = Prise en charge expérimentale de l’ouverture simultanée de plusieurs incrustations vidéo.
# Search during IME
experimental-features-ime-search =
    .label = Barre d’adresse : afficher les résultats pendant la composition IME
experimental-features-ime-search-description = Un IME (Input Method Editor, éditeur de méthode de saisie) est un outil qui permet la saisie de symboles complexes, tels que ceux utilisés pour écrire les langues indiennes ou celles d’Asie de l’Est, tout en utilisant un clavier ordinaire. Activer cette expérience conserve ouvert le panneau de la barre d’adresse qui affiche les résultats de recherche et des suggestions, pendant que l’IME est utilisé pour saisir du texte. Notez que l’IME pourrait afficher un panneau recouvrant les résultats de la barre d’adresse, c’est pourquoi cette préférence n’est suggérée que pour les IME qui n’utilisent pas ce type de panneau.
