# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } bloqueou { $count } rastreador ao longo da semana passada
       *[other] { -brand-short-name } bloqueou { $count } rastreadores ao longo da semana passada
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> rastreador bloqueado desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> rastreadores bloqueados desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = O { -brand-short-name } continua a bloquear os rastreadores em janelas privadas, mas não mantém um registo do que foi bloqueado.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rastreadores que o { -brand-short-name } bloqueou esta semana

protection-report-webpage-title = Painel das proteções
protection-report-page-content-title = Painel das proteções
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = O { -brand-short-name } pode proteger a sua privacidade nos bastidores, enquanto navega. Este é um resumo personalizado destas proteções, incluindo ferramentas para assumir o controle da sua segurança na Internet.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = O { -brand-short-name } protege a sua privacidade, nos bastidores, enquanto navega. Este é um resumo personalizado destas proteções, incluindo ferramentas para assumir a gestão da sua segurança na Internet.

protection-report-settings-link = Gerir as suas definições de privacidade e segurança

etp-card-title-always = Proteção melhorada contra a monitorização: Sempre ligada
etp-card-title-custom-not-blocking = Proteção melhorada contra a monitorização: DESLIGADA
etp-card-content-description = O { -brand-short-name } impede automaticamente que as empresas o sigam secretamente pela Internet.
protection-report-etp-card-content-custom-not-blocking = Atualmente, todas as proteções estão desativadas. Escolha que rastreadores devem ser bloqueados gerindo as definições de proteção do { -brand-short-name }.
protection-report-manage-protections = Gerir definições

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoje

# This string is used to describe the graph for screenreader users.
graph-legend-description = Um gráfico contendo o número total de cada tipo de rastreador bloqueado esta semana.

social-tab-title = Rastreadores de redes sociais
social-tab-contant = As redes sociais colocam rastreadores em outros sites para monitorizar o que faz, vê e assiste na Internet. Isto permite que estas empresas de redes sociais saibam mais sobre si, para além do que partilha no seu perfil nas redes sociais. <a data-l10n-name="learn-more-link">Saber mais</a>

cookie-tab-title = Cookies de monitorização entre sites
cookie-tab-content = Estas cookies seguem-no entre vários sites para recolher dados sobre o que faz na Internet. São definidas por terceiros, como anunciantes ou empresas de análise. O bloqueio de cookies de rastreamento entre sites reduz o número de anúncios que o seguem. <a data-l10n-name="learn-more-link">Saber mais</a>

tracker-tab-title = Monitorização de conteúdo
tracker-tab-description = Os sites podem carregar anúncios, vídeos e outros conteúdos externos com códigos de rastreamento. O bloqueio de conteúdos de rastreamento pode ajudar os sites a carregar mais rapidamente, mas alguns botões, formulários e campos de autenticação podem não funcionar. <a data-l10n-name="learn-more-link">Saber mais</a>

fingerprinter-tab-title = Identificadores
fingerprinter-tab-content = Os identificadores recolhem definições do seu navegador e computador para criar um perfil sobre si. Ao utilizar este identificador digital, estes podem monitorizá-lo em vários sites diferentes. <a data-l10n-name="learn-more-link">Saber mais</a>

cryptominer-tab-title = Cripto-mineradores
cryptominer-tab-content = Os cripto-mineradores utilizam o poder de computação do seu sistema para minerar dinheiro digital. Os scripts de cripto-mineração podem descarregar a sua bateria, tornar o seu computador mais lento e aumentar os custos com a sua fatura elétrica. <a data-l10n-name="learn-more-link">Saber mais</a>

protections-close-button2 =
    .aria-label = Fechar
    .title = Fechar
  
mobile-app-title = Bloquear anúncios de monitorização em mais dispositivos
mobile-app-card-content = Utilize o navegador móvel com proteção integrada contra anúncios de monitorização.
mobile-app-links = O navegador { -brand-product-name } para <a data-l10n-name="android-mobile-inline-link">Android</a> e <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Nunca mais esqueça uma palavra-passe
lockwise-title-logged-in2 = Gestão de palavras-passe
lockwise-header-content = O { -lockwise-brand-name } guarda as suas palavras-passe em segurança no seu navegador.
lockwise-header-content-logged-in = Guarde e sincronize em segurança as suas palavras-passe em todos os seus dispositivos.
protection-report-save-passwords-button = Guardar palavras-passe
    .title = Guardar palavras-passe no { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Gerir palavras-passe
    .title = Gerir palavras-passe no { -lockwise-brand-short-name }
lockwise-mobile-app-title = Leve as suas palavras-passe para todo o lado
lockwise-no-logins-card-content = Utilize as palavras-passe guardadas no { -brand-short-name } em qualquer dispositivo.
lockwise-app-links = { -lockwise-brand-name } para <a data-l10n-name="lockwise-android-inline-link">Android</a> e <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 palavra-passe poderá ter sido exposta numa violação de dados.
       *[other] { $count } palavras-passe poderão ter sido expostas numa violação de dados
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 palavra-passe guardada em segurança.
       *[other] As suas palavras-passe estão a ser guardadas em segurança.
    }
lockwise-how-it-works-link = Como é que funciona

monitor-title = Procurar por violações de dados
monitor-link = Como funciona
monitor-header-content-no-account = Aceda ao { -monitor-brand-name } para confirmar se fez parte de uma violação de dados conhecida e para obter alertas sobre novas violações de dados.
monitor-header-content-signed-in = O { -monitor-brand-name } avisa-o se a sua informação apareceu numa violação de dados conhecida.
monitor-sign-up-link = Registar para alertas de violações de dados
    .title = Registar no { -monitor-brand-name } para alertas de violações de dados
auto-scan = Analisado hoje, de forma automática

monitor-emails-tooltip =
    .title = Ver os endereços de e-mail monitorados no { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ver no { -monitor-brand-short-name } as violações de dados conhecidas
monitor-passwords-tooltip =
    .title = Ver no { -monitor-brand-short-name } as palavras-passe expostas.

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] endereço de e-mail em monitorização
       *[other] endereços de e-mail em monitorização
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Violação de dados conhecida que expôs a sua informação
       *[other] Violações de dados conhecidas que expuseram a sua informação
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Violação de dados conhecida marcada como resolvida
       *[other] Violações de dados conhecidas marcadas como resolvidas
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] palavra-passe exposta em todas as violações de dados
       *[other] palavras-passe expostas em todas as violações de dados
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Palavra-passe exposta em violações de dados não resolvidas
       *[other] Palavras-passe expostas em violações de dados não resolvidas
    }

monitor-no-breaches-title = Boas notícias!
monitor-no-breaches-description = Você não tem violações de dados conhecidas. Se isto se alterar, nós iremos avisá-lo.
monitor-view-report-link = Ver relatório
    .title = Resolver violações de dados no { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resolver as suas violações de dados
monitor-breaches-unresolved-description =
    Depois de analisar os detalhes sobre a violação de dados e tomar medidas para proteger
    as suas informações, pode marcar as violações de dados como resolvidas.
monitor-manage-breaches-link = Gerir violações de dados
    .title = Gerir violações de dados no { -monitor-brand-short-name }
monitor-breaches-resolved-title = Muito bem! Resolveu todas as violações de dados conhecidas.
monitor-breaches-resolved-description = Iremos informá-lo se o seu e-mail aparecer em novas violações de dados.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } de { $numBreaches } violação de dados marcada como resolvida
       *[other] { $numBreachesResolved } de { $numBreaches } violações de dados marcadas como resolvidas
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } concluído

monitor-partial-breaches-motivation-title-start = Ótimo começo!
monitor-partial-breaches-motivation-title-middle = Continue assim!
monitor-partial-breaches-motivation-title-end = Está quase! Continue assim.
monitor-partial-breaches-motivation-description = Resolver as violações de dados remanescentes no { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver violações de dados
    .title = Resolver violações de dados no { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Rastreadores de redes sociais
    .aria-label =
        { $count ->
            [one] { $count } rastreador de rede social ({ $percentage }%)
           *[other] { $count } rastreadores de redes sociais ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies de monitorização entre sites
    .aria-label =
        { $count ->
            [one]
                { $count } cookie de monitorização entre sites ({ $percentage }%)
                { $count } cross-site tracking cookie ({ $percentage }%)
                { $count } cookie de monitorização ente sites ({ $percentage }%)
           *[other] { $count } cookies de monitorização entre sites ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Conteúdo de monitorização
    .aria-label =
        { $count ->
            [one] { $count } conteúdo de monitorização ({ $percentage }%)
           *[other] { $count } conteúdos de monitorização ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Identificadores
    .aria-label =
        { $count ->
            [one] { $count } identificador ({ $percentage }%)
           *[other] { $count } identificadores ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cripto-mineradores
    .aria-label =
        { $count ->
            [one] { $count } cripto-minerador ({ $percentage }%)
           *[other] { $count } cripto-mineradores ({ $percentage }%)
        }
