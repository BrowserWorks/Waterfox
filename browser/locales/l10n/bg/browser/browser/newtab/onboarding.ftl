# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Научете повече
onboarding-button-label-get-started = Въведение

## Welcome modal dialog strings

onboarding-welcome-header = Добре дошли във { -brand-short-name }

onboarding-welcome-body = Разполагате с четеца.<br/>Запознайте се с останалото от { -brand-product-name }
onboarding-welcome-learn-more = Научете повече за ползите.

onboarding-welcome-modal-get-body = Разполагате с четеца.<br/>Сега се възползвайте максимално от { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Презаредете защитата на поверителността си.
onboarding-welcome-modal-privacy-body = Разполагате с четеца. Нека подобрим поверителността.
onboarding-welcome-modal-family-learn-more = Научете повече за семейството от продукти на { -brand-product-name }.
onboarding-welcome-form-header = Започнете оттук

onboarding-join-form-body = За начало въведете адреса на своята ел. поща.
onboarding-join-form-email =
    .placeholder = Въведете електронен адрес
onboarding-join-form-email-error = Необходим е валиден адрес на ел. поща
onboarding-join-form-legal = Продължавайки, вие се съгласявате с <a data-l10n-name="terms">условията на услугата</a> и <a data-l10n-name="privacy">политиката за лични данни</a>.
onboarding-join-form-continue = Продължаване

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Имате профил?
# Text for link to submit the sign in form
onboarding-join-form-signin = Впишете се

onboarding-start-browsing-button-label = Започнете да разглеждате

onboarding-cards-dismiss =
    .title = Отхвърляне
    .aria-label = Отхвърляне

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-form-email =
    .placeholder = Адрес на електронна поща

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Вземете { -brand-product-name } с вас
onboarding-sync-welcome-content = Вземете своите отметки, история, пароли и всички други настройки на всички ваши устройства.
onboarding-sync-welcome-learn-more-link = Научете повече за Firefox Accounts

onboarding-sync-form-input =
    .placeholder = адрес на електронна поща

onboarding-sync-form-continue-button = Продължаване
onboarding-sync-form-skip-login-button = Пропускане

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Въведете своята ел. поща,
onboarding-sync-form-sub-header = за да продължите към { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Всичко, което правим зачита нашето обещание за личните данни: Взимаме по-малко, Пазим го зорко. Без тайни.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Вземете вашите отметки, пароли, история и всичко друго навсякъде, където използвате { -brand-product-name }.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Бъдете информирани, когато личните ви данни са изтекли неправомерно в интернет.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Управлявайте пароли, които са защитени и преносими.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Защита от проследяване
onboarding-tracking-protection-text2 = { -brand-short-name } помага да спрете уебсайтовете да ви следят онлайн, като затруднява и рекламите да ви досаждат в мрежата.
onboarding-tracking-protection-button2 = Как работи

onboarding-data-sync-title = Вземете своите настройки със себе си
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Синхронизирайте своите отметки, пароли и други навсякъде, където използвате { -brand-product-name }.
onboarding-data-sync-button2 = Вписване в { -sync-brand-short-name }

onboarding-firefox-monitor-title = Бъдете уведомени при пробив на данни
onboarding-firefox-monitor-button = Регистриране за сигнали

onboarding-browse-privately-title = Разглеждайте поверително
onboarding-browse-privately-button = Отваряне на поверителен прозорец

onboarding-firefox-send-title = Дръжте споделените си файлове лични
onboarding-firefox-send-text2 = Качете файловете си в { -send-brand-name }, за да ги споделите с шифроване от край до край и препратка, която изтича автоматично.
onboarding-firefox-send-button = Опитайте { -send-brand-name }

onboarding-mobile-phone-title = Изтеглете { -brand-product-name } на телефона си
onboarding-mobile-phone-text = Изтеглете { -brand-product-name } за iOS или Android и синхронизирайте данни между устройствата си.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Изтеглете мобилен четец

onboarding-send-tabs-title = Незабавно си изпращайте раздели
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Лесно споделяйте страници между устройствата си, без да се налага да копирате препратки или да напускате четеца.
onboarding-send-tabs-button = Започнете да изпращате раздели

onboarding-pocket-anywhere-title = Четете и слушайте навсякъде
onboarding-pocket-anywhere-button = Опитайте { -pocket-brand-name }

onboarding-lockwise-strong-passwords-title = Създавайте и съхранявайте силни пароли
onboarding-lockwise-strong-passwords-button = Управление на регистрации

onboarding-facebook-container-title = Сложете ограда на Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } държи профила ви отделен от всичко останало, което затруднява Facebook да ви показва целеви реклами.
onboarding-facebook-container-button = Добавяне на разширението


onboarding-import-browser-settings-title = Внесете вашите отметки, пароли и др.
onboarding-import-browser-settings-button = Внасяне на данни от Chrome

onboarding-personal-data-promise-button = Прочетете нашето обещание

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Страхотно е че имате { -brand-short-name }

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Сега нека инсталираме <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Добавяне на разширението
return-to-amo-get-started-button = Започнете работа с { -brand-short-name }
