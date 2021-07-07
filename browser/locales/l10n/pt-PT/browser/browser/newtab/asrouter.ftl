# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensão recomendada
cfr-doorhanger-feature-heading = Funcionalidade recomendada
cfr-doorhanger-pintab-heading = Experimente isto: Fixar separador

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Porque é que estou a ver isto
cfr-doorhanger-extension-cancel-button = Agora não
    .accesskey = n
cfr-doorhanger-extension-ok-button = Adicionar agora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixar este separador
    .accesskey = p
cfr-doorhanger-extension-manage-settings-button = Gerir definições de recomendações
    .accesskey = m
cfr-doorhanger-extension-never-show-recommendation = Não me mostrar esta recomendação
    .accesskey = s
cfr-doorhanger-extension-learn-more-link = Saber mais
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = por { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomendação
cfr-doorhanger-extension-notification2 = Recomendação
    .tooltiptext = Recomendação de extensão
    .a11y-announcement = Recomendação de extensão disponível
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomendação
    .tooltiptext = Recomendação de funcionalidade
    .a11y-announcement = Recomendação de funcionalidade disponível

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } estrela
           *[other] { $total } estrelas
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } utilizador
       *[other] { $total } utilizadores
    }
cfr-doorhanger-pintab-description = Obtenha acesso fácil aos seus sites mais utilizados. Mantenha sites abertos num separador (mesmo quando reinicia).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Clique com o botão direito</ b> no separador que pretende fixar.
cfr-doorhanger-pintab-step2 = Selecione <b>Fixar separador</ b> a partir do menu.
cfr-doorhanger-pintab-step3 = Se o site tiver uma atualização irá ver um ponto azul no separador fixado.
cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Retomar

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronize os seus marcadores em todo o lado.
cfr-doorhanger-bookmark-fxa-body = Ótimo achado! Agora não fique sem este marcador nos seus dispositivos móveis. Comece com uma { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar marcadores agora...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botão de fecho
    .title = Fechar

## Protections panel

cfr-protections-panel-header = Navegue sem ser seguido
cfr-protections-panel-body = Guarde os seus dados para si. O { -brand-short-name } protege-o de muitos dos rastreadores mais comuns que monitorizam o que faz na Internet.
cfr-protections-panel-link-text = Saber mais

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nova funcionalidade:
cfr-whatsnew-button =
    .label = Novidades
    .tooltiptext = Novidades
cfr-whatsnew-panel-header = Novidades
cfr-whatsnew-release-notes-link-text = Leia as notas de lançamento
cfr-whatsnew-fx70-title = O { -brand-short-name } agora luta mais pela sua privacidade
cfr-whatsnew-fx70-body =
    A atualização mais recente melhora a funcionalidade de Proteção contra a monitorização e torna
    mais fácil do que nunca a criação de palavras-passe seguras para cada site.
cfr-whatsnew-tracking-protect-title = Proteja-se contra os rastreadores
cfr-whatsnew-tracking-protect-body =
    O { -brand-short-name } bloqueia muitos dos rastreadores mais comuns entre sites e de 
    redes sociais que monitorizam o que faz na Internet.
cfr-whatsnew-tracking-protect-link-text = Ver o seu relatório
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rastreador bloqueado
       *[other] Rastreadores bloqueados
    }
cfr-whatsnew-tracking-blocked-subtitle = Desde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Ver relatório
cfr-whatsnew-lockwise-backup-title = Faça uma cópia das suas palavras-passe
cfr-whatsnew-lockwise-backup-body = Agora, crie palavras-passe seguras que pode aceder em qualquer lugar onde inicie a sessão.
cfr-whatsnew-lockwise-backup-link-text = Ative as cópias de segurança
cfr-whatsnew-lockwise-take-title = Leve as suas palavras-passe consigo
cfr-whatsnew-lockwise-take-body =
    A aplicação móvel { -lockwise-brand-short-name } permite-lhe aceder com segurança e em  
    qualquer lugar às cópias de segurança das suas palavras-passe.
cfr-whatsnew-lockwise-take-link-text = Obter a aplicação

## Search Bar

cfr-whatsnew-searchbar-title = Escreva menos e encontre mais, com a barra de endereço
cfr-whatsnew-searchbar-body-topsites = Agora, basta selecionar a barra de endereço e será expandida uma caixa com ligações para os principais sites.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ícone de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Veja vídeos enquanto navega
cfr-whatsnew-pip-body = A funcionalidade de vídeo em janela flutuante apresenta o vídeo numa janela independente para que possa assistir ao vídeo enquanto navega nos outros separadores.
cfr-whatsnew-pip-cta = Saber mais

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menos pop-ups irritantes
cfr-whatsnew-permission-prompt-body = Agora o { -brand-shorter-name } impede que os sites solicitem, de forma automática, o envio de mensagens em pop-ups.
cfr-whatsnew-permission-prompt-cta = Saber mais

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Identificador bloqueado
       *[other] Identificadores bloqueados
    }
cfr-whatsnew-fingerprinter-counter-body = O { -brand-shorter-name } bloqueia muitos identificadores que recolhem, em segredo, informações sobre o seu dispositivo e ações para criar um perfil publicitário de si.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Identificadores
cfr-whatsnew-fingerprinter-counter-body-alt = O { -brand-shorter-name } pode bloquear muitos identificadores que recolhem, em segredo, informações sobre o seu dispositivo e ações para criar um perfil publicitário de si.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obtenha este marcador no seu telemóvel
cfr-doorhanger-sync-bookmarks-body = Leve os seus marcadores, palavras-passe, histórico e muito mais onde tiver a sessão iniciada no { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Ligar { -sync-brand-short-name }
    .accesskey = L

## Login Sync

cfr-doorhanger-sync-logins-header = Nunca mais perca uma palavra-passe
cfr-doorhanger-sync-logins-body = Armazene e sincronize com segurança as suas palavras-passe em todos os seus dispositivos.
cfr-doorhanger-sync-logins-ok-button = Ligar { -sync-brand-short-name }
    .accesskey = L

## Send Tab

cfr-doorhanger-send-tab-header = Leia isto em qualquer lugar
cfr-doorhanger-send-tab-recipe-header = Leve esta receita para a cozinha
cfr-doorhanger-send-tab-body = O Enviar separador permite-lhe partilhar facilmente esta ligação com o seu telefone ou em qualquer lugar em que tenha a sessão iniciada no { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Experimente o Send Tab
    .accesskey = t

## Firefox Send

cfr-doorhanger-firefox-send-header = Partilhe este PDF com segurança
cfr-doorhanger-firefox-send-body = Mantenha os seus documentos sensíveis seguros de olhares indiscretos com encriptação ponta-a-ponta e uma ligação que desaparece quando terminar.
cfr-doorhanger-firefox-send-ok-button = Experimente o { -send-brand-name }
    .accesskey = t

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver proteções
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Fechar
    .accesskey = c
cfr-doorhanger-socialtracking-dont-show-again = Não voltar a mostrar mensagens como esta
    .accesskey = v
cfr-doorhanger-socialtracking-heading = O { -brand-short-name } impediu que uma rede social o monitorizasse aqui
cfr-doorhanger-socialtracking-description = A sua privacidade é importante. O { -brand-short-name } agora bloqueia os rastreadores mais comuns das redes sociais, limitando a quantidade de dados que estes podem recolher sobre o que faz na Internet.
cfr-doorhanger-fingerprinters-heading = O { -brand-short-name } bloqueou um identificador nesta página
cfr-doorhanger-fingerprinters-description = A sua privacidade é importante. O { -brand-short-name } agora bloqueia identificadores, que recolhem partes de informação de identificação exclusiva sobre o seu dispositivo para o monitorizar.
cfr-doorhanger-cryptominers-heading = O { -brand-short-name } bloqueou um cripto-minerador nesta página
cfr-doorhanger-cryptominers-description = A sua privacidade é importante. O { -brand-short-name } agora bloqueia os cripto-mineradores, que utilizam o poder de computação do seu sistema para minerar dinheiro digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } bloqueou mais de <b>{ $blockedCount }</b> rastreadores desde { $date }!
       *[other] { -brand-short-name } bloqueou mais de <b>{ $blockedCount }</b> rastreadores desde { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] O { -brand-short-name } bloqueou <b>{ $blockedCount }</b> rastreador desde { DATETIME($date, month: "long", year: "numeric") }!
       *[other] O { -brand-short-name } bloqueou <b>{ $blockedCount }</b> rastreadores desde { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Ver tudo
    .accesskey = V

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Crie palavras-passe seguras com facilidade
cfr-whatsnew-lockwise-body = É difícil pensar em palavras-passe únicas e seguras para todas as contas. Ao criar uma palavra-passe, selecione o campo da palavra-passe para utilizar uma palavra-passe segura, gerada no { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ícone do { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Receba alertas sobre palavras-passe vulneráveis
cfr-whatsnew-passwords-body = Os piratas sabem que as pessoas reutilizam as mesmas palavras-passe. Se utilizou a mesma palavra-passe em vários sites e um desses sites teve uma violação de dados, irá ver um alerta no { -lockwise-brand-short-name } para alterar a sua palavra-passe nesses sites.
cfr-whatsnew-passwords-icon-alt = Ícone de chave de palavra-passe vulnerável

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Colocar o vídeo em janela flutuante em ecrã inteiro
cfr-whatsnew-pip-fullscreen-body = Quando coloca um vídeo numa janela flutuante, agora pode clicar duas vezes nessa janela para o vídeo ocupar o ecrã inteiro.
cfr-whatsnew-pip-fullscreen-icon-alt = Ícone de vídeo em janela flutuante

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Fechar
    .accesskey = F

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Visão geral das proteções
cfr-whatsnew-protections-body = O Painel de protecão inclui relatórios resumidos sobre violações de dados e gestão de palavras-passe. Agora pode acompanhar quantas violações de dados resolveu e ver se alguma das suas palavras-passe guardadas pode ter sido exposta em uma violação de dados.
cfr-whatsnew-protections-cta-link = Ver painel de proteções
cfr-whatsnew-protections-icon-alt = Ícone de um escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Melhor experiência com PDF
cfr-whatsnew-better-pdf-body = Os documentos PDF são agora abertos diretamente no { -brand-short-name }, mantendo e facilitando o seu fluxo de trabalho.

## DOH Message

cfr-doorhanger-doh-body = A sua privacidade é importante. Agora, o { -brand-short-name } encaminha os seus pedidos de DNS de forma segura e sempre que possível, para um serviço de um parceiro para o proteger enquanto navega.
cfr-doorhanger-doh-header = Pesquisas de DNS encriptadas e mais seguras
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Desativar
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = A sua privacidade é importante. O { -brand-short-name } agora isola os sites uns dos outros, o que torna mais difícil que os piratas roubem palavras-passe, números de cartão de crédito e outras informações sensíveis.
cfr-doorhanger-fission-header = Isolamento de sites
cfr-doorhanger-fission-primary-button = OK, percebi
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Saber mais
    .accesskey = b

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Proteção automática contra táticas sorrateiras de monitorização
cfr-whatsnew-clear-cookies-body = Alguns rastreadores redirecionam-no para outros sites que, secretamente, definem cookies. O { -brand-short-name } agora elimina estas cookies automaticamente para que não possa ser monitorizado.
cfr-whatsnew-clear-cookies-image-alt = Ilustração do bloqueio de cookies

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Mais controlos de media
cfr-whatsnew-media-keys-body = Reproduza e pare o áudio ou vídeo diretamente com o teclado ou auscultadores, facilitando o controlo da media a partir de outro separador, programa ou mesmo quando o computador estiver bloqueado. Também pode alternar entre as faixas utilizando as teclas de avanço e retrocesso.
cfr-whatsnew-media-keys-button = Saber mais

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Atalhos de pesquisa na barra de endereço
cfr-whatsnew-search-shortcuts-body = Agora, quando digita um motor de pesquisa ou um site específico na barra de endereço, será apresentado um atalho azul nas sugestões de pesquisa. Selecione este atalho para completar a sua pesquisa diretamente da barra de endereço.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Proteção contra super-cookies maliciosos
cfr-whatsnew-supercookies-body = Os sites podem, secretamente, anexar uma “super-cookie” ao seu navegador que pode seguir o que faz na Internet, mesmo depois de limpar os cookies. O { -brand-short-name } fornece agora uma forte proteção contra super-cookies, de modo a que estas não possam ser utilizadas para monitorizar as suas atividades online de um site para outro.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Marcadores melhorados
cfr-whatsnew-bookmarking-body = É mais fácil seguir os seus sites favoritos. O { -brand-short-name } agora lembra-se da sua localização preferida para os favoritos guardados, mostra a barra de ferramentas de favoritos por predefinição em novos separadores e oferece um acesso fácil ao resto dos seus favoritos através de uma pasta na barra de ferramentas.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Proteção abrangente contra rastreamento de cookies entre sites
cfr-whatsnew-cross-site-tracking-body = Agora pode optar por obter uma melhor proteção contra as cookies de rastreamento. O { -brand-short-name } pode isolar as suas atividades e dados dos sites que não esteja a visitar, para que as informações armazenadas no navegador não sejam partilhadas entre os sites.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Os vídeos neste site podem não ser reproduzidos corretamente nesta versão do { -brand-short-name }. Para uma maior compatibilidade vídeo, atualize agora o { -brand-short-name }.
cfr-doorhanger-video-support-header = Atualizar o { -brand-short-name } para reproduzir o vídeo
cfr-doorhanger-video-support-primary-button = Atualizar agora
    .accesskey = u
