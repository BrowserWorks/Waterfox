# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Сохранённые адреса
autofill-manage-addresses-list-header = Адреса

autofill-manage-credit-cards-title = Сохранённые банковские карты
autofill-manage-credit-cards-list-header = Банковские карты

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Удалить
autofill-manage-add-button = Добавить…
autofill-manage-edit-button = Изменить…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Добавить новый адрес
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Изменить адрес

autofill-address-given-name = Имя
autofill-address-additional-name = Отчество
autofill-address-family-name = Фамилия
autofill-address-organization = Организация
autofill-address-street = Адрес

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Микрорайон
# Used in MY
autofill-address-village-township = Деревня или поселок
autofill-address-island = Остров
# Used in IE
autofill-address-townland = Городская земля

## address-level-2 names

autofill-address-city = Город
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Район
# Used in GB, NO, SE
autofill-address-post-town = Почтовый город
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Пригород

## address-level-1 names

autofill-address-province = Провинция
autofill-address-state = Штат
autofill-address-county = Графство
# Used in BB, JM
autofill-address-parish = Приход
# Used in JP
autofill-address-prefecture = Префектура
# Used in HK
autofill-address-area = Район
# Used in KR
autofill-address-do-si = До/Си
# Used in NI, CO
autofill-address-department = Департамент
# Used in AE
autofill-address-emirate = Эмират
# Used in RU and UA
autofill-address-oblast = Регион

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Почтовый индекс
autofill-address-zip = Почтовый индекс
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Страна или регион
autofill-address-tel = Телефон
autofill-address-email = Эл. почта

autofill-cancel-button = Отмена
autofill-save-button = Сохранить
autofill-country-warning-message = В настоящее время автозаполнение форм доступно только для некоторых стран.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Добавить новую банковскую карту
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Изменить банковскую карту

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] показать данные банковской карты
        [windows] { -brand-short-name } пытается показать данные банковской карты. Подтвердите ниже доступ к этой учётной записи Windows.
       *[other] { -brand-short-name } пытается показать данные банковской карты.
    }

autofill-card-number = Номер карты
autofill-card-invalid-number = Введите корректный номер карты
autofill-card-name-on-card = Имя держателя
autofill-card-expires-month = Месяц срока действия
autofill-card-expires-year = Год срока действия
autofill-card-billing-address = Адрес выставления счёта
autofill-card-network = Тип карты

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = American Express
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = Discover
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = MasterCard
autofill-card-network-mir = МИР
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = Visa
