# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Сазнај више
onboarding-button-label-get-started = Први кораци

## Welcome modal dialog strings

onboarding-welcome-header = Добродошли у { -brand-short-name }
onboarding-welcome-body = Имате прегледач. <br/>Упознајте и остатак { -brand-product-name } екипе.
onboarding-welcome-learn-more = Сазнајте више о предностима.
onboarding-welcome-modal-get-body = Имате прегледач.<br/>А сада искористите максимум из { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Појачајте заштиту приватности.
onboarding-welcome-modal-privacy-body = Инсталација прегледача је завршена. Додајмо сада још више заштите приватности.
onboarding-welcome-modal-family-learn-more = Сазнајте више о { -brand-product-name } породици производа.
onboarding-welcome-form-header = Почните овде
onboarding-join-form-body = Унесите своју е-адресу да бисте започели.
onboarding-join-form-email =
    .placeholder = Унесите е-адресу
onboarding-join-form-email-error = Потребна је важећа е-адреса
onboarding-join-form-legal = Настављањем даље, слажете се са <a data-l10n-name="terms">условима коришћења</a> и <a data-l10n-name="privacy">изјавом о политици приватности</a>.
onboarding-join-form-continue = Настави
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Већ имате налог?
# Text for link to submit the sign in form
onboarding-join-form-signin = Пријавите се
onboarding-start-browsing-button-label = Почните са прегледањем
onboarding-cards-dismiss =
    .title = Уклони
    .aria-label = Уклони

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Добродошли у <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Брз, сигуран и приватни прегледач који је подржан од непрофитне организације.
onboarding-multistage-welcome-primary-button-label = Покрените подешавање
onboarding-multistage-welcome-secondary-button-label = Пријавите се
onboarding-multistage-welcome-secondary-button-text = Имате налог?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Увезите ваше лозинке, обележиваче и <span data-l10n-name="zap">друго</span>
onboarding-multistage-import-subtitle = Долазите од другог прегледача? Све можете лако увести у { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Покрени увоз
onboarding-multistage-import-secondary-button-label = Не сада
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Странице са ове листе нису пронађене на овом уређају. { -brand-short-name } не чува нити синхронизује податке из другог прегледача, осим ако не изаберете да их увезете.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Први кораци: екран { $current } од { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Изаберите <span data-l10n-name="zap">изглед</span>
onboarding-multistage-theme-subtitle = Прилагодите { -brand-short-name } темом.
onboarding-multistage-theme-primary-button-label = Сачувај тему
onboarding-multistage-theme-secondary-button-label = Не сада
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Аутоматски
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Користи системску тему
onboarding-multistage-theme-label-light = Светла
onboarding-multistage-theme-label-dark = Тамна
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Наследите изглед вашег оперативног
        система за тастере, меније и прозоре.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Користите светли изглед за тастере,
        меније и прозоре.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Користите тамни изглед за тастере,
        меније и прозоре.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Користите шарени изглед за тастере,
        меније и прозоре.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Наследите изглед вашег оперативног
        система за тастере, меније и прозоре.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Наследите изглед вашег оперативног
        система за тастере, меније и прозоре.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Користите светли изглед за тастере,
        меније и прозоре.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Користите светли изглед за тастере,
        меније и прозоре.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Користите тамни изглед за тастере,
        меније и прозоре.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Користите тамни изглед за тастере,
        меније и прозоре.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Користите шарени изглед за тастере,
        меније и прозоре.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Користите шарени изглед за тастере,
        меније и прозоре.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Хајде да истражимо шта све можете да урадите.
onboarding-fullpage-form-email =
    .placeholder = Ваша адреса е-поште…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Понесите { -brand-product-name } са собом
onboarding-sync-welcome-content = Имајте све забелешке, историјат, лозинке и друге поставке на свим вашим уређајима.
onboarding-sync-welcome-learn-more-link = Сазнајте више о Firefox Accounts
onboarding-sync-form-input =
    .placeholder = Адреса е-поште
onboarding-sync-form-continue-button = Настави
onboarding-sync-form-skip-login-button = Прескочи овај корак

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Унесите вашу адресу е-поште
onboarding-sync-form-sub-header = да бисте наставили на { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Радите ефикасније са породицом алатки које поштују вашу приватност на свим вашим уређајима.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Све што радимо поштује наше обећање о личним подацима: узми мање података, добро их чувај и без икаквих тајни.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Синхронизујте ознаке, лозинке, историју и остало свуда где користите { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Примите обавештење када се ваши лични подаци појаве у познатом цурењу података.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Управљајте лозинкама које су заштићене и преносиве.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Заштита од праћења
onboarding-tracking-protection-text2 = { -brand-short-name } помаже вам у спречавању веб страница да вас прате на мрежи, што отежава огласима да вас прате на вебу.
onboarding-tracking-protection-button2 = Како то ради
onboarding-data-sync-title = Понесите своја подешавања са собом
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Синхронизујте своје забелешке, лозинке и остало свуда где користите { -brand-product-name }.
onboarding-data-sync-button2 = Пријавите се у { -sync-brand-short-name }
onboarding-firefox-monitor-title = Будите у приправности од повреде података
onboarding-firefox-monitor-text2 = { -monitor-brand-name } надгледа вашу имејл адресу ако се појави у познатом цурењу података и обавестиће вас уколико је открије.
onboarding-firefox-monitor-button = Пријавите се за упозорења
onboarding-browse-privately-title = Прегледајте приватно
onboarding-browse-privately-text = Приватно прегледање брише историју претраге и прегледања како би остала скривена од било кога ко користи ваш рачунар.
onboarding-browse-privately-button = Отвори приватни прозор
onboarding-firefox-send-title = Држите своје дељене датотеке приватним
onboarding-firefox-send-text2 = Пренесите датотеке на { -send-brand-name } да их поделите с енкрипцијом с-краја-на-крај и везом која аутоматски истиче.
onboarding-firefox-send-button = Испробајте { -send-brand-name }
onboarding-mobile-phone-title = Преузмите { -brand-product-name } на Ваш телефон
onboarding-mobile-phone-text = Преузмите { -brand-product-name } за iOS или Андроид и синхронизујте податке између уређаја.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Преузмите мобилни прегледач
onboarding-send-tabs-title = Пошаљите себи отворене језичке
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Једноставно шаљите језичке са једног уређаја на други - без копирања и лепљења веза или напуштања прегледача.
onboarding-send-tabs-button = Почните да користите слање језичака
onboarding-pocket-anywhere-title = Читајте и слушајте било где
onboarding-pocket-anywhere-text2 = Сачувајте ваш омиљени садржај офлајн уз помоћ { -pocket-brand-name } апликације и читајте, слушајте и гледајте кад год вам то одговара.
onboarding-pocket-anywhere-button = Испробајте { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Стварајте и чувајте јаке лозинке
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } ствара јаке лозинке у трену и све их чува на једном месту.
onboarding-lockwise-strong-passwords-button = Управљајте вашим пријавама
onboarding-facebook-container-title = Поставите границе с Facebook-ом
onboarding-facebook-container-text2 = { -facebook-container-brand-name } држи ваш профил одвојеним од свега осталог и на тај начин отежава Facebook-у да вас бомбардује рекламама.
onboarding-facebook-container-button = Додајте проширење
onboarding-import-browser-settings-title = Увезите ваше обележиваче, лозинке и више
onboarding-import-browser-settings-text = Слободно истражите — понесите са собом Chrome странице и подешавања.
onboarding-import-browser-settings-button = Увезите Chrome податке
onboarding-personal-data-promise-title = Дизајниран за приватност
onboarding-personal-data-promise-text = { -brand-product-name } поштује ваше податке тако што их прикупља мање, штити их и даје до знања на који начин их користи.
onboarding-personal-data-promise-button = Прочитајте наше обећање

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Одлично, добили сте { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Сада ћемо вам помоћи са додатком <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Додај проширење
return-to-amo-get-started-button = Крените са коришћењем програма { -brand-short-name }
