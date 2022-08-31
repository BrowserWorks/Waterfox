# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = Предупреждение режима «Только HTTPS»
about-httpsonly-title-site-not-available = Безопасная версия сайта недоступна
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Вы включили режим «Только HTTPS» для повышения безопасности, однако HTTPS-версия сайта <em>{ $websiteUrl }</em> недоступна.
about-httpsonly-explanation-question = Чем это может быть вызвано?
about-httpsonly-explanation-nosupport = Скорее всего, веб-сайт просто не поддерживает HTTPS.
about-httpsonly-explanation-risk = Причиной этого также может быть злоумышленник. Если вы решите посетить этот веб-сайт, не вводите на нём никакой личной информации, такой как пароли, адреса электронной почты и данные банковских карт.
about-httpsonly-explanation-continue = Если вы продолжите, режим «Только HTTPS» для этого сайта будет временно отключён.
about-httpsonly-button-continue-to-site = Перейти на HTTP-версию
about-httpsonly-button-go-back = Назад
about-httpsonly-link-learn-more = Подробнее…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Возможная альтернатива
about-httpsonly-suggestion-box-www-text = Существует безопасная версия <em>www.{ $websiteUrl }</em>. Вы можете открыть её вместо <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Перейти на www.{ $websiteUrl }
