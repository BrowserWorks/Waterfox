# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Проблема при загрузке страницы
certerror-page-title = Предупреждение: Вероятная угроза безопасности
certerror-sts-page-title = Соединение не установлено: Вероятная угроза безопасности
neterror-blocked-by-policy-page-title = Заблокированная страница
neterror-captive-portal-page-title = Вход в сеть
neterror-dns-not-found-title = Сервер не найден
neterror-malformed-uri-page-title = Некорректный URL

## Error page actions

neterror-advanced-button = Дополнительно…
neterror-copy-to-clipboard-button = Скопировать текст в буфер обмена
neterror-learn-more-link = Подробнее…
neterror-open-portal-login-page-button = Открыть страницу входа в сеть
neterror-override-exception-button = Принять риск и продолжить
neterror-pref-reset-button = Восстановить настройки по умолчанию
neterror-return-to-previous-page-button = Вернуться назад
neterror-return-to-previous-page-recommended-button = Вернуться назад (рекомендуется)
neterror-try-again-button = Попробовать снова
neterror-add-exception-button = Всегда продолжать для этого сайта
neterror-settings-button = Изменить настройки DNS
neterror-view-certificate-link = Просмотреть сертификат
neterror-trr-continue-this-time = Продолжить на этот раз
neterror-disable-native-feedback-warning = Всегда продолжать

##

neterror-pref-reset = Похоже, что причиной этого могут быть настройки безопасности вашей сети. Вы хотите восстановить настройки по умолчанию?
neterror-error-reporting-automatic = Отправка сообщений о подобных ошибках поможет { -vendor-short-name } обнаружить и заблокировать вредоносные сайты

## Specific error messages

neterror-generic-error = { -brand-short-name } не может загрузить эту страницу по неопределённой причине.
neterror-load-error-try-again = Возможно, сайт временно недоступен или перегружен запросами. Подождите некоторое время и попробуйте снова.
neterror-load-error-connection = Если вы не можете загрузить ни одну страницу – проверьте настройки соединения с Интернетом.
neterror-load-error-firewall = Если ваш компьютер или сеть защищены межсетевым экраном или прокси-сервером – убедитесь, что { -brand-short-name } разрешён выход в Интернет.
neterror-captive-portal = Вы должны войти в эту сеть перед тем как сможете получить доступ в Интернет.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Возможно, вы хотели перейти на <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Если вы ввели правильный адрес, вы можете:</strong>
neterror-dns-not-found-hint-try-again = Повторить попытку позже
neterror-dns-not-found-hint-check-network = Проверить подключение к сети
neterror-dns-not-found-hint-firewall = Проверить, что { -brand-short-name } имеет разрешение на доступ в Интернет (возможно, вы подключены, но находитесь за межсетевым экраном).

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } не может защитить ваш запрос адреса этого сайта через наш доверенный разрешитель имен DNS. Вот причина:
neterror-dns-not-found-trr-third-party-warning2 = Вы можете продолжить работу с разрешителем имён DNS по умолчанию. Однако третья сторона может увидеть, какие сайты вы посещаете.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } не удалось подключиться к { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Подключение к { $trrDomain } заняло больше времени, чем ожидалось.
neterror-dns-not-found-trr-offline = Вы не подключены к Интернету.
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } не смог найти этот сайт.
neterror-dns-not-found-trr-server-problem = С { $trrDomain } возникла проблема.
neterror-dns-not-found-bad-trr-url = Некорректный URL.
neterror-dns-not-found-trr-unknown-problem = Неожиданная проблема.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } не может защитить ваш запрос адреса этого сайта через наш доверенный разрешитель имён DNS. Вот причина:
neterror-dns-not-found-native-fallback-heuristic = DNS через HTTPS отключён в вашей сети.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } не удалось подключиться к { $trrDomain }.

##

neterror-file-not-found-filename = Проверьте правильность введённого имени файла, соответствие регистра и отсутствие других ошибок в имени файла.
neterror-file-not-found-moved = Проверьте, не был ли файл переименован, удалён или перемещён.
neterror-access-denied = Возможно, что он был удалён или перемещён, или разрешения на файл не дают получить к нему доступ.
neterror-unknown-protocol = Для открытия данного адреса вам, возможно, понадобится установить стороннее программное обеспечение.
neterror-redirect-loop = Эта проблема может возникать при отключении или запрещении принятия кук.
neterror-unknown-socket-type-psm-installed = Убедитесь, что в вашей системе установлен «Менеджер личной защиты (PSM)».
neterror-unknown-socket-type-server-config = Возможно, это произошло из-за нестандартной конфигурации сервера.
neterror-not-cached-intro = Запрошенный документ недоступен в кеше { -brand-short-name }.
neterror-not-cached-sensitive = В целях безопасности { -brand-short-name } не производит автоматический повторный запрос важных документов.
neterror-not-cached-try-again = Нажмите «Попробовать снова», чтобы повторно запросить документ с веб-сайта.
neterror-net-offline = Нажмите «Попробовать снова», чтобы подключиться к сети и перезагрузить страницу.
neterror-proxy-resolve-failure-settings = Проверьте правильность установленных настроек прокси-сервера.
neterror-proxy-resolve-failure-connection = Проверьте работу соединения вашего компьютера с сетью.
neterror-proxy-resolve-failure-firewall = Если ваш компьютер или сеть защищены межсетевым экраном или прокси-сервером – убедитесь, что { -brand-short-name } разрешён выход в Интернет.
neterror-proxy-connect-failure-settings = Проверьте настройки прокси-сервера и убедитесь, что они верны.
neterror-proxy-connect-failure-contact-admin = Свяжитесь с вашим системным администратором и убедитесь, что прокси-сервер работает.
neterror-content-encoding-error = Пожалуйста, свяжитесь с владельцами веб-сайта и сообщите им об этой проблеме.
neterror-unsafe-content-type = Пожалуйста, свяжитесь с владельцами веб-сайта и сообщите им об этой проблеме.
neterror-nss-failure-not-verified = Страница, которую вы пытаетесь просмотреть, не может быть отображена, так как достоверность полученных данных не может быть проверена.
neterror-nss-failure-contact-website = Пожалуйста, свяжитесь с владельцами веб-сайта и сообщите им об этой проблеме.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } обнаружил вероятную угрозу безопасности и не стал открывать <b>{ $hostname }</b>. Если вы посетите этот сайт, злоумышленники могут попытаться похитить вашу информацию, такую как пароли, адреса электронной почты или данные банковских карт.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } обнаружил вероятную угрозу безопасности и не стал открывать <b>{ $hostname }</b>, так как для подключения к этому сайту необходимо установить защищённое соединение.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } обнаружил вероятную угрозу безопасности и не стал открывать <b>{ $hostname }</b>. Либо веб-сайт неправильно настроен, либо часы вашего компьютера установлены неправильно.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b>, вероятно, является безопасным сайтом, но защищённое соединение не может быть установлено. Эта проблема вызвана <b>{ $mitm }</b>, программным обеспечением на вашем компьютере или в вашей сети.
neterror-corrupted-content-intro = Страница, которую вы пытаетесь просмотреть, не может быть показана, так как была обнаружена ошибка при передаче данных.
neterror-corrupted-content-contact-website = Пожалуйста, свяжитесь с владельцами веб-сайта и сообщите им об этой проблеме.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Дополнительная информация: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> использует защитную технологию, которая является устаревшей и уязвимой для атаки. Злоумышленник может легко выявить информацию, которая, как вы думали, находится в безопасности. Для того, чтобы вы смогли посетить веб-сайт, администратор веб-сайта должен сначала исправить его сервер.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Код ошибки: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Ваш компьютер считает, что текущее время — { DATETIME($now, dateStyle: "medium") }, что не даёт { -brand-short-name } установить защищённое соединение. Чтобы посетить <b>{ $hostname }</b>, укажите в компьютерных часах в настройках системы текущую дату, время и часовой пояс, а затем перезагрузите <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Страница, которую вы пытаетесь просмотреть, не может быть показана, так как была обнаружена ошибка в сетевом протоколе.
neterror-network-protocol-error-contact-website = Пожалуйста, свяжитесь с владельцами веб-сайта и сообщите им об этой проблеме.
certerror-expired-cert-second-para = Вероятно, сертификат веб-сайта истёк, что не даёт { -brand-short-name } установить защищённое соединение. Если вы посетите этот сайт, злоумышленники могут попытаться похитить вашу информацию, такую как пароли, адреса электронной почты или данные банковских карт.
certerror-expired-cert-sts-second-para = Вероятно, сертификат веб-сайта истёк, что не даёт { -brand-short-name } установить защищённое соединение.
certerror-what-can-you-do-about-it-title = Как вы можете это исправить?
certerror-unknown-issuer-what-can-you-do-about-it-website = Скорее всего, эта проблема связана с самим веб-сайтом, и вы ничего не сможете с этим сделать.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Если вы находитесь в корпоративной сети или используете антивирусную программу, вы можете связаться со службой поддержки для получения помощи. Вы также можете сообщить администратору веб-сайта об этой проблеме.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Часы вашего компьютера показывают { DATETIME($now, dateStyle: "medium") }. Убедитесь, что в настройках системы вашего компьютера установлены правильные дата, время и часовой пояс, после чего перезагрузите <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Если ваши часы установлены правильно, то скорее всего неправильно настроен веб-сайт и вы ничего не сможете с этим сделать. Вы можете сообщить об этой проблеме администратору веб-сайта.
certerror-bad-cert-domain-what-can-you-do-about-it = Скорее всего, эта проблема связана с самим веб-сайтом, и вы ничего не сможете с этим сделать. Вы можете сообщить администратору веб-сайта об этой проблеме.
certerror-mitm-what-can-you-do-about-it-antivirus = Если ваша антивирусная программа содержит функциональность, которая сканирует защищённые соединения (часто называемую «веб-сканирование» или «https-сканирование», то вы можете отключить её. Если это не поможет, то вы можете удалить и переустановить антивирусное программное обеспечение.
certerror-mitm-what-can-you-do-about-it-corporate = Если вы находитесь в корпоративной сети, то вы можете связаться со своим IT-отделом.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Если вы не знакомы с <b>{ $mitm }</b>, то, вероятно, это может быть атакой и вам не следует продолжать работу с сайтом.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Если вы не знакомы с <b>{ $mitm }</b>, то, вероятно, это может быть атакой и вы никак не сможете получить доступ к сайту.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> имеет политику безопасности называемую Форсированное защищённое соединение HTTP (HSTS), что означает, что { -brand-short-name } может подключиться к нему только через защищённое соединение. Вы не можете добавить исключение, чтобы посетить этот сайт.
