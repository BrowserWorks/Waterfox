# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = Защищённое соединение недоступно
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = Вы работаете в режиме «Только HTTPS». Защищённая HTTPS-версия сайта <em>{ $websiteUrl }</em> недоступна.
about-httpsonly-insecure-explanation-reasons = Скорее всего сайт не поддерживает HTTPS, но также возможно, что злоумышленник блокирует HTTPS версию.
about-httpsonly-insecure-explanation-exception = Хотя угроза безопасности является низкой, если вы решите посетить HTTP-версию веб-сайта, вам не следует вводить на ней какие-либо конфиденциальные данные, такие как пароли, адреса электронной почты или данные банковских карт.
about-httpsonly-button-make-exception = Принять риск и перейти на сайт
about-httpsonly-title-alert = Предупреждение о режиме «Только HTTPS»
about-httpsonly-title-connection-not-available = Защищённое соединение недоступно
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Для повышения уровня безопасности вы включили режим «Только HTTPS». Однако HTTPS-версия сайта <em>{ $websiteUrl }</em> недоступна.
about-httpsonly-explanation-question = Что могло это вызвать?
about-httpsonly-explanation-nosupport = Скорее всего, веб-сайт просто не поддерживает HTTPS.
about-httpsonly-explanation-risk = Также возможно, что это было вызвано злоумышленником. Если вы решите посетить веб-сайт, вам не следует вводить на нём какие-либо конфиденциальные данные, такие как пароли, адреса электронной почты или данные банковских карт.
about-httpsonly-explanation-continue = Если вы продолжите, режим «Только HTTPS» для этого сайта будет временно отключён.
about-httpsonly-button-continue-to-site = Перейти на HTTP-сайт
about-httpsonly-button-go-back = Вернуться назад
about-httpsonly-link-learn-more = Подробнее…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Возможная альтернатива
about-httpsonly-suggestion-box-www-text = Существует защищённая версия <em>www.{ $websiteUrl }</em>. Вы можете посетить её вместо перехода на <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Перейти на www.{ $websiteUrl }
