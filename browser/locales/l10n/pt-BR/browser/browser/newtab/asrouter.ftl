# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensão recomendada
cfr-doorhanger-feature-heading = Recurso recomendado
cfr-doorhanger-pintab-heading = Experimente isso: Fixar aba

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Por que isso apareceu
cfr-doorhanger-extension-cancel-button = Agora não
    .accesskey = n
cfr-doorhanger-extension-ok-button = Adicionar agora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixar esta aba
    .accesskey = x
cfr-doorhanger-extension-manage-settings-button = Gerenciar configuração de recomendações
    .accesskey = m
cfr-doorhanger-extension-never-show-recommendation = Não mostrar esta recomendação
    .accesskey = s
cfr-doorhanger-extension-learn-more-link = Saiba mais
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = por { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomendação
cfr-doorhanger-extension-notification2 = Recomendação
    .tooltiptext = Recomendação de extensão
    .a11y-announcement = Disponível uma recomendação de extensão
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomendação
    .tooltiptext = Recomendação de funcionalidade
    .a11y-announcement = Disponível uma recomendação de funcionalidade

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
        [one] { $total } usuário
       *[other] { $total } usuários
    }
cfr-doorhanger-pintab-description = Tenha acesso fácil aos sites que você mais usa. Mantenha sites abertos em abas (mesmo quando reiniciar).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Clique com o botão direito</b> na aba que você quer fixar.
cfr-doorhanger-pintab-step2 = Selecione <b>Fixar aba</b> no menu.
cfr-doorhanger-pintab-step3 = Se o site tiver uma atualização, aparece um ponto azul na aba fixada.
cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Continuar

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronize seus favoritos em qualquer lugar.
cfr-doorhanger-bookmark-fxa-body = Ótimo achado! Agora não fique sem este favorito nos seus dispositivos móveis. Comece com uma { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar favoritos agora…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botão fechar
    .title = Fechar

## Protections panel

cfr-protections-panel-header = Navegue sem ser seguido
cfr-protections-panel-body = Mantenha seus dados com você. O { -brand-short-name } te protege de muitos dos rastreadores mais comuns que tentam seguir o que você faz online.
cfr-protections-panel-link-text = Saiba mais

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Novo recurso:
cfr-whatsnew-button =
    .label = Novidades
    .tooltiptext = Novidades
cfr-whatsnew-panel-header = Novidades
cfr-whatsnew-release-notes-link-text = Ler as notas de atualização
cfr-whatsnew-fx70-title = O { -brand-short-name } agora luta mais intensamente por sua privacidade
cfr-whatsnew-fx70-body =
    A última atualização aprimora o recurso de proteção contra rastreamento
    e torna mais fácil que nunca criar senhas seguras para cada site.
cfr-whatsnew-tracking-protect-title = Proteja-se de rastreadores
cfr-whatsnew-tracking-protect-body = O { -brand-short-name } bloqueia muitos rastreadores comuns, entre sites e de mídias sociais, que tentam seguir o que você faz online.
cfr-whatsnew-tracking-protect-link-text = Veja seu relatório
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
cfr-whatsnew-lockwise-backup-title = Guarde uma cópia de suas senhas
cfr-whatsnew-lockwise-backup-body = Gere senhas seguras que você pode acessar em qualquer dispositivo.
cfr-whatsnew-lockwise-backup-link-text = Ativar cópias de segurança
cfr-whatsnew-lockwise-take-title = Leve suas senhas com você
cfr-whatsnew-lockwise-take-body = O aplicativo de celular { -lockwise-brand-short-name } permite acessar com segurança em qualquer lugar suas senhas guardadas.
cfr-whatsnew-lockwise-take-link-text = Instalar o aplicativo

## Search Bar

cfr-whatsnew-searchbar-title = Digite menos, encontre mais usando a barra de endereços
cfr-whatsnew-searchbar-body-topsites = Agora basta selecionar a barra de endereços e aparecem links para seus sites preferidos.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ícone da lente de aumento

## Picture-in-Picture

cfr-whatsnew-pip-header = Assista vídeos enquanto navega
cfr-whatsnew-pip-body = A função picture-in-picture exibe vídeos em uma janela flutuante que você posiciona onde quiser, assim pode assistir enquanto usa outras abas.
cfr-whatsnew-pip-cta = Saiba mais

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menos notificações incômodas de sites
cfr-whatsnew-permission-prompt-body = O { -brand-shorter-name } agora impede que sites solicitem automaticamente exibir notificações.
cfr-whatsnew-permission-prompt-cta = Saiba mais

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter bloqueado
       *[other] Fingerprinters bloqueados
    }
cfr-whatsnew-fingerprinter-counter-body = O { -brand-shorter-name } bloqueia muitos rastreadores de identidade digital, que coletam secretamente informações sobre seu dispositivo e suas ações, traçando um perfil seu para mostrar propaganda direcionada.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = O { -brand-shorter-name } consegue bloquear rastreadores de identidade digital, que coletam secretamente informações sobre seu dispositivo e suas ações, traçando um perfil seu para mostrar propaganda direcionada.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Tenha este favorito em seu celular
cfr-doorhanger-sync-bookmarks-body = Tenha seus favoritos, senhas, histórico e muito mais em qualquer lugar que acesse sua conta no { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Ativar o { -sync-brand-short-name }
    .accesskey = t

## Login Sync

cfr-doorhanger-sync-logins-header = Nunca perca uma senha novamente
cfr-doorhanger-sync-logins-body = Armazene e sincronize suas senhas com segurança em todos os seus dispositivos.
cfr-doorhanger-sync-logins-ok-button = Ativar o { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Leia isso em movimento
cfr-doorhanger-send-tab-recipe-header = Leve esta receita para a cozinha
cfr-doorhanger-send-tab-body = Enviar aba permite compartilhar este link facilmente para seu celular, ou onde quer que acesse sua conta no { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Experimente enviar aba
    .accesskey = E

## Firefox Send

cfr-doorhanger-firefox-send-header = Compartilhe este PDF com segurança
cfr-doorhanger-firefox-send-body = Mantenha seus documentos sensíveis a salvo de intrometidos, com criptografia de ponta a ponta e um link que desaparece quando você terminar de usar.
cfr-doorhanger-firefox-send-ok-button = Experimente o { -send-brand-name }
    .accesskey = E

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver proteções
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Fechar
    .accesskey = F
cfr-doorhanger-socialtracking-dont-show-again = Não mostrar mais mensagens como esta
    .accesskey = N
cfr-doorhanger-socialtracking-heading = O { -brand-short-name } impediu que uma rede social rastreasse você aqui
cfr-doorhanger-socialtracking-description = Sua privacidade é importante. Agora o { -brand-short-name } bloqueia rastreadores comuns de mídias sociais, limitando quantos dados conseguem coletar sobre o que você faz online.
cfr-doorhanger-fingerprinters-heading = O { -brand-short-name } bloqueou um fingerprinter nesta página
cfr-doorhanger-fingerprinters-description = Sua privacidade é importante. Agora o { -brand-short-name } bloqueia fingerprinters (rastreadores de identidade digital), que tentam coletar elementos de informação unicamente identificáveis sobre seu dispositivo para rastrear você.
cfr-doorhanger-cryptominers-heading = O { -brand-short-name } bloqueou um criptominerador nesta página
cfr-doorhanger-cryptominers-description = Sua privacidade é importante. Agora o { -brand-short-name } bloqueia criptomineradores, que tentam usar o poder computacional do seu sistema para minerar moedas digitais.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] O { -brand-short-name } bloqueou mais de <b>{ $blockedCount }</b> rastreadores desde { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] O { -brand-short-name } bloqueou <b>{ $blockedCount }</b> rastreador desde { DATETIME($date, month: "long", year: "numeric") }!
       *[other] O { -brand-short-name } bloqueou mais de <b>{ $blockedCount }</b> rastreadores desde { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Ver tudo
    .accesskey = V

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Crie senhas seguras facilmente
cfr-whatsnew-lockwise-body = É difícil pensar em senhas únicas e seguras para cada conta. Ao criar uma senha, selecione o campo de senha para usar uma senha segura, gerada automaticamente pelo { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ícone do { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Receba alertas em caso de senhas vulneráveis
cfr-whatsnew-passwords-body = Os hackers sabem que as pessoas reusam as mesmas senhas. Caso tenha usado a mesma senha em vários sites, e algum desses sites tenha se envolvido em um vazamento de dados, aparece um alerta no { -lockwise-brand-short-name } avisando para alterar sua senha nesses sites.
cfr-whatsnew-passwords-icon-alt = Ícone de chave de senha vulnerável

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Use picture-in-picture em tela inteira
cfr-whatsnew-pip-fullscreen-body = Após transferir um vídeo para uma janela flutuante, agora você pode dar um duplo-clique nessa janela para exibir em tela inteira.
cfr-whatsnew-pip-fullscreen-icon-alt = Ícone de picture-in-picture

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Fechar
    .accesskey = F

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Visão geral das proteções
cfr-whatsnew-protections-body = O painel de proteções inclui relatórios concisos sobre vazamentos de dados e gerenciamento de senhas. Agora você pode acompanhar quantos vazamentos já resolveu e ver se alguma de suas senhas salvas pode ter sido exposta em um vazamento de dados.
cfr-whatsnew-protections-cta-link = Ver painel de proteções
cfr-whatsnew-protections-icon-alt = Ícone de escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Melhor experiência de uso em PDF
cfr-whatsnew-better-pdf-body = Documentos PDF agora são abertos diretamente no { -brand-short-name }, mantendo seu fluxo de trabalho facilmente ao alcance.

## DOH Message

cfr-doorhanger-doh-body = Sua privacidade é importante. Agora o { -brand-short-name } roteia com segurança suas requisição de DNS, sempre que possível, para um serviço parceiro para proteger você enquanto navega.
cfr-doorhanger-doh-header = Pesquisas de DNS mais seguras e criptografadas
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Desativar
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Sua privacidade é importante. O { -brand-short-name } agora isola (sandbox) sites uns dos outros, o que dificulta os hackers roubarem senhas, números de cartões de crédito e outras informações confidenciais.
cfr-doorhanger-fission-header = Isolamento de sites
cfr-doorhanger-fission-primary-button = OK, entendi
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Saiba mais
    .accesskey = S

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Proteção automática contra táticas furtivas de rastreamento
cfr-whatsnew-clear-cookies-body = Alguns rastreadores redirecionam para outros sites que secretamente criam cookies. O { -brand-short-name } agora limpa automaticamente esses cookies para que você não possa ser seguido.
cfr-whatsnew-clear-cookies-image-alt = Ilustração de cookie bloqueado

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Mais controles de mídia
cfr-whatsnew-media-keys-body = Reproduza e interrompa áudio ou vídeo, usando diretamente o teclado ou fone de ouvido, o que facilita controlar mídias a partir de outra aba, outro programa ou mesmo quando o computador estiver bloqueado. Você também pode mudar de faixa usando as teclas de avançar e voltar.
cfr-whatsnew-media-keys-button = Saiba como

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Atalhos de pesquisa na barra de endereços
cfr-whatsnew-search-shortcuts-body = Agora, quando você digita um mecanismo de pesquisa ou site específico na barra de endereços, um atalho azul aparece nas sugestões de pesquisa. Selecione esse atalho para concluir a pesquisa diretamente na barra de endereços.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Proteção contra supercookies maliciosos
cfr-whatsnew-supercookies-body = Alguns sites podem anexar secretamente ao seu navegador um “supercookie” que pode te seguir pela web, mesmo após você limpar seus cookies. O { -brand-short-name } agora oferece forte proteção contra supercookies, assim eles não podem ser usados para rastrear suas atividades online de um site para outro.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Melhora nos favoritos
cfr-whatsnew-bookmarking-body = É mais fácil acompanhar seus sites preferidos. Agora o { -brand-short-name } memoriza seu local preferido de salvar favoritos, mostra por padrão a barra de ferramentas de favoritos em novas abas e oferece acesso fácil ao restante de seus favoritos por meio de uma pasta na barra de ferramentas.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Proteção abrangente contra rastreamento de cookies entre sites
cfr-whatsnew-cross-site-tracking-body = Agora você pode optar por ter melhor proteção contra rastreamento de cookies. O { -brand-short-name } pode isolar suas atividades e dados do site em que você está no momento, para que as informações armazenadas no navegador não sejam compartilhadas entre sites.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Os vídeos neste site podem não ser reproduzidos corretamente nesta versão do { -brand-short-name }. Para suporte completo a vídeos, atualize agora o { -brand-short-name }.
cfr-doorhanger-video-support-header = Atualize o { -brand-short-name } para reproduzir vídeo
cfr-doorhanger-video-support-primary-button = Atualizar agora
    .accesskey = A
