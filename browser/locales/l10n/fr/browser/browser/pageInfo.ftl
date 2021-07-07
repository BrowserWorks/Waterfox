# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 650px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = Copier
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Tout sélectionner
    .accesskey = T

close-dialog =
    .key = w

general-tab =
    .label = Général
    .accesskey = G
general-title =
    .value = Titre :
general-url =
    .value = Adresse (URL) :
general-type =
    .value = Type :
general-mode =
    .value = Mode de rendu :
general-size =
    .value = Taille :
general-referrer =
    .value = URL de provenance :
general-modified =
    .value = Modifiée le :
general-encoding =
    .value = Encodage du texte :
general-meta-name =
    .label = Nom
general-meta-content =
    .label = Contenu

media-tab =
    .label = Médias
    .accesskey = M
media-location =
    .value = Emplacement :
media-text =
    .value = Texte associé :
media-alt-header =
    .label = Texte alternatif
media-address =
    .label = Adresse
media-type =
    .label = Type
media-size =
    .label = Taille
media-count =
    .label = Nombre
media-dimension =
    .value = Dimensions :
media-long-desc =
    .value = Description longue :
media-save-as =
    .label = Enregistrer sous…
    .accesskey = s
media-save-image-as =
    .label = Enregistrer sous…
    .accesskey = E

perm-tab =
    .label = Permissions
    .accesskey = P
permissions-for =
    .value = Permissions pour :

security-tab =
    .label = Sécurité
    .accesskey = S
security-view =
    .label = Afficher le certificat
    .accesskey = A
security-view-unknown = Inconnu
    .value = Inconnu
security-view-identity =
    .value = Identité du site web
security-view-identity-owner =
    .value = Propriétaire :
security-view-identity-domain =
    .value = Site web :
security-view-identity-verifier =
    .value = Vérifiée par :
security-view-identity-validity =
    .value = Expire le :
security-view-privacy =
    .value = Vie privée et historique

security-view-privacy-history-value = Ai-je déjà visité ce site web auparavant ?
security-view-privacy-sitedata-value = Ce site web conserve-t-il des informations sur mon ordinateur ?

security-view-privacy-clearsitedata =
    .label = Effacer les cookies et les données de sites
    .accesskey = E

security-view-privacy-passwords-value = Ai-je un mot de passe enregistré pour ce site web ?

security-view-privacy-viewpasswords =
    .label = Voir les mots de passe enregistrés
    .accesskey = V
security-view-technical =
    .value = Détails techniques

help-button =
    .label = Aide

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Oui, des cookies et { $value } { $unit } de données de sites
security-site-data-only = Oui, { $value } { $unit } de données de sites

security-site-data-cookies-only = Oui, des cookies
security-site-data-no = Non

##

image-size-unknown = Inconnu
page-info-not-specified =
    .value = Non spécifié
not-set-alternative-text = Non spécifié
not-set-date = Non spécifié
media-img = Image
media-bg-img = Image de fond
media-border-img = Bordure
media-list-img = Liste à puces
media-cursor = Curseur
media-object = Objet
media-embed = Intégré
media-link = Icône
media-input = Entrée
media-video = Vidéo
media-audio = Audio
saved-passwords-yes = Oui
saved-passwords-no = Non

no-page-title =
    .value = Page sans titre :
general-quirks-mode =
    .value = Mode de compatibilité (quirks)
general-strict-mode =
    .value = Mode de respect des standards
page-info-security-no-owner =
    .value = Ce site web ne fournit pas d’informations sur son propriétaire.
media-select-folder = Sélectionner un dossier où enregistrer les images
media-unknown-not-cached =
    .value = Inconnu (pas dans le cache)
permissions-use-default =
    .label = Permissions par défaut
security-no-visits = Non

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Métaélément (1 balise)
           *[other] Métaéléments ({ $tags } balises)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Non
        [one] Oui, une fois
       *[other] Oui, { $visits } fois
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } Ko ({ $bytes } octet)
           *[other] { $kb } Ko ({ $bytes } octets)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Image { $type } (animée, { $frames } calque)
           *[other] Image { $type } (animée, { $frames } calques)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Image { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (redimensionné à { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } Ko

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Bloquer les images en provenance de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informations sur la page - { $website }
page-info-frame =
    .title = Informations sur le cadre - { $website }
