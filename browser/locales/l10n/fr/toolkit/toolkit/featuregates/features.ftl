# This Source Code Form is subject to the terms of the Mozilla Public
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
experimental-features-media-avif =
    .label = Multimédia : AVIF
experimental-features-media-avif-description = Lorsque cette fonctionnalité est activée, { -brand-short-name } prend en charge le format AV1 Image File (AVIF). Ce format de fichier d’image fixe exploite les capacités des algorithmes de compression vidéo AV1 pour réduire la taille de l’image. Consultez <a data-l10n-name="bugzilla">bug 1443863</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = API web : inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Notre implémentation de l’attribut global <a data-l10n-name="mdn-inputmode">inputmode</a> a été mise à jour conformément à <a data-l10n-name="whatwg">la spécification WHATWG</a>, mais nous devons encore apporter d’autres modifications, comme la rendre disponible sur du contenu modifiable via contenteditable. Voir le <a data-l10n-name="bugzilla">bug 1205133</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = API web : <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = L’attribut <a data-l10n-name="rel">rel</a> avec la valeur « <code>"preload"</code> » sur un élément <a data-l10n-name="link">&lt;link&gt;</a> est destiné à améliorer les performances en vous permettant de télécharger des ressources plus tôt dans le cycle de vie de la page, en vous assurant qu’elles sont disponibles plus tôt et qu’elles sont moins susceptibles de bloquer le rendu de la page. Lisez « <a data-l10n-name="readmore">Préchargement de contenu avec <code>rel="preload"</code></a> » ou consultez le <a data-l10n-name="bugzilla">bug 1583604</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS : pseudo-classe :focus-visible
experimental-features-css-focus-visible-description = Permet d’appliquer des styles de focus à des éléments tels que des boutons et des contrôles de formulaire, uniquement lorsqu’ils sont focalisés au clavier (par exemple lors de la tabulation entre les éléments), et non lorsqu’ils sont focalisés à l’aide d’une souris ou d’un autre dispositif de pointage. Consultez le <a data-l10n-name="bugzilla">bug 1617600</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = API web : évènement beforeinput
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = L’évènement global <a data-l10n-name="mdn-beforeinput">beforeinput</a> est activé sur des éléments <a data-l10n-name="mdn-input">&lt;input&gt;</a> et <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, ou tout élément dont l’attribut <a data-l10n-name="mdn-contenteditable">contenteditable</a> est défini, immédiatement avant que l’élément change de valeur. Cet évènement permet aux applications web d’outrepasser le comportement par défaut du navigateur pour l’interaction avec l’utilisateur. Par exemple, des applications web peuvent annuler la saisie de l’utilisateur uniquement pour des caractères spécifiques, ou peuvent modifier le collage d’un texte formaté uniquement avec des styles approuvés.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS : Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = L’ajout d’un constructeur à l’interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> ainsi qu’un ensemble de modifications connexes permettent de créer directement de nouvelles feuilles de style sans avoir à ajouter celles-ci au HTML. Cela facilite beaucoup la création de feuilles de style réutilisables à utiliser avec le <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Voir le <a data-l10n-name="bugzilla">bug 1520690</a> pour plus de détails.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = API web : API Media Session
experimental-features-media-session-api-description = L’implémentation complète de l’API Media Session dans { -brand-short-name } est actuellement expérimentale. Cette API est utilisée pour personnaliser la gestion des notifications liées aux médias, pour gérer les évènements et les données servant à présenter une interface utilisateur pour la gestion de la lecture multimédia et pour obtenir les métadonnées des fichiers multimédias. Voir le <a data-l10n-name="bugzilla">bug 1112032</a> pour plus de détails.
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
experimental-features-print-preview-tab-modal =
    .label = Refonte de l’aperçu avant impression
experimental-features-print-preview-tab-modal-description = Active un aperçu avant impression repensé et le rend disponible sur macOS. Cela entraîne potentiellement des dysfonctionnements et n’inclut pas tous les paramètres liés à l’impression. Pour accéder à tous les paramètres liés à l’impression, sélectionnez « Imprimer à l’aide de la boîte de dialogue système… » dans le panneau Imprimer.
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
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Affichage : zoom fluide par pincement
experimental-features-graphics-desktop-zooming-description = Active la prise en charge d’un zoom fluide par pincement sur les écrans tactiles et les pavés tactiles de précision.
