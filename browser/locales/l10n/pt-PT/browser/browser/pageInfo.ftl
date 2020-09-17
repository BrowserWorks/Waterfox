# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Copiar
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Selecionar tudo
    .accesskey = t

close-dialog =
    .key = w

general-tab =
    .label = Geral
    .accesskey = G
general-title =
    .value = Título:
general-url =
    .value = Endereço:
general-type =
    .value = Tipo:
general-mode =
    .value = Modo de renderização:
general-size =
    .value = Tamanho:
general-referrer =
    .value = URL referente:
general-modified =
    .value = Modificado:
general-encoding =
    .value = Codificação de texto:
general-meta-name =
    .label = Nome
general-meta-content =
    .label = Conteúdo

media-tab =
    .label = Multimédia
    .accesskey = M
media-location =
    .value = Localização:
media-text =
    .value = Texto associado:
media-alt-header =
    .label = Texto alternativo
media-address =
    .label = Endereço
media-type =
    .label = Tipo
media-size =
    .label = Tamanho
media-count =
    .label = Contador
media-dimension =
    .value = Dimensões:
media-long-desc =
    .value = Descrição longa:
media-save-as =
    .label = Guardar como…
    .accesskey = G
media-save-image-as =
    .label = Guardar como…
    .accesskey = e

perm-tab =
    .label = Permissões
    .accesskey = P
permissions-for =
    .value = Permissões para:

security-tab =
    .label = Segurança
    .accesskey = S
security-view =
    .label = Ver certificado
    .accesskey = V
security-view-unknown = Desconhecido
    .value = Desconhecido
security-view-identity =
    .value = Identidade do site
security-view-identity-owner =
    .value = Proprietário:
security-view-identity-domain =
    .value = Site:
security-view-identity-verifier =
    .value = Verificado por:
security-view-identity-validity =
    .value = Expira em:
security-view-privacy =
    .value = Privacidade e histórico

security-view-privacy-history-value = Já visitei este site no passado?
security-view-privacy-sitedata-value = Este site está a armazenar informação no meu computador?

security-view-privacy-clearsitedata =
    .label = Limpar cookies e dados de sites
    .accesskey = c

security-view-privacy-passwords-value = Guardei quaisquer palavras-passe para este site?

security-view-privacy-viewpasswords =
    .label = Ver palavras-passe guardadas
    .accesskey = s
security-view-technical =
    .value = Detalhes técnicos

help-button =
    .label = Ajuda

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Sim, cookies e { $value } { $unit } de dados de sites
security-site-data-only = Sim, { $value } { $unit } de dados de sites

security-site-data-cookies-only = Sim, cookies
security-site-data-no = Não

image-size-unknown = Desconhecido
page-info-not-specified =
    .value = Não especificado
not-set-alternative-text = Não especificado
not-set-date = Não especificado
media-img = Imagem
media-bg-img = Fundo
media-border-img = Margem
media-list-img = Marcas
media-cursor = Cursor
media-object = Objeto
media-embed = Embutido
media-link = Ícone
media-input = Entrada
media-video = Vídeo
media-audio = Áudio
saved-passwords-yes = Sim
saved-passwords-no = Não

no-page-title =
    .value = Página sem título:
general-quirks-mode =
    .value = Modo quirks
general-strict-mode =
    .value = Modo de cumprimento dos padrões
page-info-security-no-owner =
    .value = Este site não fornece informações sobre o proprietário.
media-select-folder = Selecione uma pasta para guardar as imagens
media-unknown-not-cached =
    .value = Desconhecido (não está em cache)
permissions-use-default =
    .label = Utilizar predefinição
security-no-visits = Não

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 etiqueta)
           *[other] Meta ({ $tags } etiquetas)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Não
        [one] Sim, uma vez
       *[other] Sim, { $visits } vezes
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } byte)
           *[other] { $kb } KB ({ $bytes } bytes)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Imagem { $type } (animada, { $frames } frame)
           *[other] Imagem { $type } (animada, { $frames } frames)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Imagem { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (redimensionado para { $scaledx }px × { $scaledy }px)

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
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Bloquear imagens de { $website }
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Informação da página - { $website }
page-info-frame =
    .title = Informação do frame - { $website }
