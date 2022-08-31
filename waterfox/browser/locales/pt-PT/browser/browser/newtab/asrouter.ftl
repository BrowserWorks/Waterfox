# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensão recomendada
cfr-doorhanger-feature-heading = Funcionalidade recomendada

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Porque é que estou a ver isto
cfr-doorhanger-extension-cancel-button = Agora não
    .accesskey = n
cfr-doorhanger-extension-ok-button = Adicionar agora
    .accesskey = A
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

## Waterfox Accounts Message

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
cfr-whatsnew-release-notes-link-text = Leia as notas de lançamento

## Enhanced Tracking Protection Milestones

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
cfr-doorhanger-milestone-close-button = Fechar
    .accesskey = F

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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Os vídeos neste site podem não ser reproduzidos corretamente nesta versão do { -brand-short-name }. Para uma maior compatibilidade vídeo, atualize agora o { -brand-short-name }.
cfr-doorhanger-video-support-header = Atualizar o { -brand-short-name } para reproduzir o vídeo
cfr-doorhanger-video-support-primary-button = Atualizar agora
    .accesskey = u

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Saber mais
    .title = Expanda para saber mais sobre a funcionalidade
spotlight-learn-more-expanded = Saber mais
    .title = Fechar

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Parece que está a utilizar uma rede Wi-Fi pública
spotlight-public-wifi-vpn-body = Para ocultar a sua localização e atividade de navegação, considere uma Rede Privada Virtual. Isto irá melhorar a sua proteção ao navegar em locais públicos, como aeroportos e cafés.
spotlight-public-wifi-vpn-primary-button = Mantenha a sua privacidade com a { -mozilla-vpn-brand-name }
    .accesskey = M
spotlight-public-wifi-vpn-link = Agora não
    .accesskey = n

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Teste a nossa mais poderosa
    experiência de privacidade de sempre
spotlight-total-cookie-protection-body = A Proteção total de cookies impede que os rastreadores utilizem cookies para o perseguir na Internet.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = O { -brand-short-name } isola as cookies, limitando o acesso aos mesmos ao site em que está, de modo a que os rastreadores não os possam utilizar para o monitorizar. Com este acesso antecipado, estará a ajudar a otimizar esta funcionalidade para que possamos continuar a construir uma Internet melhor para todos.
spotlight-total-cookie-protection-primary-button = Ativar a Proteção total de cookies
spotlight-total-cookie-protection-secondary-button = Agora não
cfr-total-cookie-protection-header = Graças a si, { -brand-short-name } está mais privado e seguro do que nunca
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = A Proteção Total de Cookies é a nossa proteção de privacidade mais forte até ao momento – e agora é uma predefinição para o { -brand-short-name } em todo o lado. Não teríamos conseguido fazer isto sem os participantes na versão de acesso antecipado, como você. Muito obrigado por nos ajudar a criar uma Internet melhor e mais privada.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Uma Internet melhor começa por si
spotlight-better-internet-body = Quando utiliza o { -brand-short-name }, está a votar numa Internet aberta e acessível, o que é melhor para todos.
spotlight-peace-mind-header = Estamos consigo
spotlight-peace-mind-body = Todos os meses, o { -brand-short-name } bloqueia uma média de mais de 3.000 rastreadores por utilizador. Porque nada, especialmente empecilhos de privacidade como os rastreadores, devem ficar entre si e uma boa Internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Manter na Doca
       *[other] Fixar na barra de tarefas
    }
spotlight-pin-secondary-button = Agora não
