# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
csp-error-missing-directive = นโยบายไม่มีคำสั่ง ‘{ $directive }’ ที่จำเป็น

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $keyword (String): the name of a CSP keyword, usually 'unsafe-inline'.
csp-error-illegal-keyword = คำสั่ง ‘{ $directive }’ มีคำสำคัญ { $keyword } ที่ไม่ได้รับอนุญาต

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-protocol = คำสั่ง ‘{ $directive }’ มี { $scheme }: แหล่งโปรโตคอลที่ไม่ได้รับอนุญาต

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-missing-host = { $scheme }: โปรโตคอลจำเป็นต้องมีโฮสต์ในคำสั่ง ‘{ $directive }’

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $source (String): the name of a CSP source, usually 'self'.
csp-error-missing-source = ‘{ $directive }’ ต้องมีแหล่ง { $source }

# Variables:
#   $directive (String): the name of a CSP directive, such as "script-src".
#   $scheme (String): a protocol name, such as "http", which appears as "http:", as it would in a URL.
csp-error-illegal-host-wildcard = { $scheme }: แหล่งที่เป็นอักขระตัวแทนในคำสั่ง ‘{ $directive }’ ต้องมีโดเมนย่อยแบบไม่ใช่ชนิดทั่วไปอย่างน้อยหนึ่งโดเมน (เช่น *.example.com แทนที่จะเป็น *.com)
