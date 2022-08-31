# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
csp-error-missing-directive = السياسة ينقصها التوجيه المطلوب: ’{ $directive }‘

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $keyword (String): the name of a CSP keyword, usually 'unsafe-inline'.
csp-error-illegal-keyword = يحتوي توجيه ’{ $directive }‘ على كلمة أساسية ممنوعة: { $keyword }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-protocol = يحتوي توجيه ’{ $directive }‘ على مصدر بروتوكول ممنوع: { $scheme }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-missing-host = ‏{ $scheme }: يتطلب البروتكول مستضيفا في توجيهات ’{ $directive }‘

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $source (String): the name of a CSP source, usually 'self'.
csp-error-missing-source = يجب أن يحتوي ’{ $directive }‘ على المصدر { $source }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-host-wildcard = { $scheme }: مصادر المطابقة في توجيهات ’{ $directive }‘ يجب أن تحتوي على الأقل نطاق فرعي واحد غير عام (مثلا، ‪*.example.com‬ بدلا من ‪*.com‬)
