# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = Sobre os Service Workers
about-service-workers-main-title = Service Workers registrados
about-service-workers-warning-not-enabled = Os Service Workers não estão ativados.
about-service-workers-warning-no-service-workers = Nenhum Service Workers registrado.
# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = Origem: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>Escopo:</strong> { $name }
script-spec = <strong>Especificação do script:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>URL do Worker atual:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>Nome da cache ativa:</strong> { $name }
waiting-cache-name = <strong>Nome da cache em espera:</strong> { $name }
push-end-point-waiting = <strong>Ponto final de publicação:</strong> { waiting }
push-end-point-result = <strong>Ponto final de publicação:</strong> { $name }
# This term is used as a button label (verb, not noun).
update-button = Atualizar
unregister-button = Cancelar registro
unregister-error = Falha ao cancelar o registro deste Service Worker.
waiting = Esperando…
