# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed =
    { -relay-brand-name.gender ->
        [masculine] { -relay-brand-name } nedokázal vygenerovat novou masku. Kód chyby HTTP: { $status }.
        [feminine] { -relay-brand-name } nedokázala vygenerovat novou masku. Kód chyby HTTP: { $status }.
        [neuter] { -relay-brand-name } nedokázalo vygenerovat novou masku. Kód chyby HTTP: { $status }.
       *[other] Služba { -relay-brand-name } nedokázala vygenerovat novou masku. Kód chyby HTTP: { $status }.
    }
firefox-relay-get-reusable-masks-failed =
    { -relay-brand-name.gender ->
        [masculine] { -relay-brand-name } nenašel znovupoužitelné masky. Kód chyby HTTP: { $status }.
        [feminine] { -relay-brand-name } nenašla znovupoužitelné masky. Kód chyby HTTP: { $status }.
        [neuter] { -relay-brand-name } nenašlo znovupoužitelné masky. Kód chyby HTTP: { $status }.
       *[other] Služba { -relay-brand-name } nenašla znovupoužitelné masky. Kód chyby HTTP: { $status }.
    }

##

firefox-relay-must-login-to-fxa = Abyste mohli používat { -relay-brand-name(case: "acc") }, musíte se přihlásit k { -fxaccount-brand-name(case: "", capitalization: "lower") }.
firefox-relay-must-login-to-account = Pokud chcete používat své e-mailové masky služby { -relay-brand-name }, přihlaste se ke svému účtu.
firefox-relay-get-unlimited-masks =
    .label = Spravovat masky
    .accesskey = m
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Chraňte svou e-mailovou adresu:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = Použít e-mailovou masku služby { -relay-brand-name }
firefox-relay-use-mask-title = Použít e-mailovou masku služby { -relay-brand-name }
firefox-relay-opt-in-confirmation-enable-button =
    .label = Použít e-mailovou masku
    .accesskey = P
firefox-relay-opt-in-confirmation-disable =
    .label = Příště už nezobrazovat
    .accesskey = u
firefox-relay-opt-in-confirmation-postpone =
    .label = Teď ne
    .accesskey = n
