# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
csp-error-missing-directive = Il criterio non contiene la direttiva obbligatoria “{ $directive }”

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $keyword (String): the name of a CSP keyword, usually 'unsafe-inline'.
csp-error-illegal-keyword = La direttiva “{ $directive }” contiene una parola chiave non consentita { $keyword }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-protocol = La direttiva “{ $directive }” contiene un protocollo sorgente non consentito { $scheme }:

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-missing-host = Il protocollo { $scheme }: richiede un host nella direttiva “{ $directive }”

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $source (String): the name of a CSP source, usually 'self'.
csp-error-missing-source = “{ $directive }” deve includere la sorgente { $source }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-host-wildcard = Sorgenti { $scheme }: con wildcard nelle direttive “{ $directive }” devono includere almeno un sottodominio non generico (ad esempio *.example.com invece di *.com)
