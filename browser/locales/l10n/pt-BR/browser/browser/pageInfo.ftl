# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 620px; min-height: 550px;
copy =
    .key = C
menu-copy =
    .label = Copiar
    .accesskey = C
select-all =
    .key = a
menu-select-all =
    .label = Selecionar tudo
    .accesskey = S
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
    .value = Página de origem:
general-modified =
    .value = Modificada em:
general-encoding =
    .value = Codificação de texto:
general-meta-name =
    .label = Nome
general-meta-content =
    .label = Conteúdo
media-tab =
    .label = Mídia
    .accesskey = M
media-location =
    .value = Endereço:
media-text =
    .value = Texto substituto:
media-alt-header =
    .label = Texto alternativo
media-address =
    .label = Endereço
media-type =
    .label = Tipo
media-size =
    .label = Tamanho
media-count =
    .label = Quantidade
media-dimension =
    .value = Dimensões:
media-long-desc =
    .value = Descrição longa:
media-save-as =
    .label = Salvar como…
    .accesskey = v
media-save-image-as =
    .label = Salvar como…
    .accesskey = a
perm-tab =
    .label = Permissões
    .accesskey = P
permissions-for =
    .value = Permissões de:
security-tab =
    .label = Segurança
    .accesskey = S
security-view =
    .label = Ver certificado
    .accesskey = E
security-view-unknown = Desconhecido
    .value = Desconhecido
security-view-identity =
    .value = Identidade do site
security-view-identity-owner =
    .value = Proprietário:
security-view-identity-domain =
    .value = Site:
security-view-identity-verifier =
    .value = Homologado por:
security-view-identity-validity =
    .value = Expira em:
security-view-privacy =
    .value = Privacidade e histórico
security-view-privacy-history-value = Eu já visitei este site antes?
security-view-privacy-sitedata-value = Este site está armazenando informações no meu computador?
security-view-privacy-clearsitedata =
    .label = Limpar cookies e dados de sites
    .accesskey = L
security-view-privacy-passwords-value = Eu salvei alguma senha deste site?
security-view-privacy-viewpasswords =
    .label = Ver senhas salvas
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

security-site-data-cookies = Sim, cookies e { $value } { $unit } de dados do site
security-site-data-only = Sim, { $value } { $unit } de dados do site
security-site-data-cookies-only = Sim, cookies
security-site-data-no = Não

##

image-size-unknown = Desconhecido
page-info-not-specified =
    .value = Não especificado
not-set-alternative-text = Não especificado
not-set-date = Não especificado
media-img = Imagem
media-bg-img = Fundo
media-border-img = Borda
media-list-img = Marcador
media-cursor = Cursor
media-object = Objeto
media-embed = Integrado
media-link = Ícone
media-input = Entrada
media-video = Vídeo
media-audio = Áudio
saved-passwords-yes = Sim
saved-passwords-no = Não
no-page-title =
    .value = Página sem título:
general-quirks-mode =
    .value = Modo de compatibilidade
general-strict-mode =
    .value = Modo de conformidade com normas
page-info-security-no-owner =
    .value = Este site não fornece informações de propriedade.
media-select-folder = Selecione uma pasta onde salvar as imagens
media-unknown-not-cached =
    .value = Desconhecido (não armazenado em cache)
permissions-use-default =
    .label = Usar o padrão
security-no-visits = Não
# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Meta (1 tag)
           *[other] Meta ({ $tags } tags)
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
    .value = { $dimx }px × { $dimy }px (redimensionada para { $scaledx }px × { $scaledy }px)
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
media-file-size = { $size } KB
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
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = Informações da página - { $website }
page-info-frame =
    .title = Informações do frame { $website }
