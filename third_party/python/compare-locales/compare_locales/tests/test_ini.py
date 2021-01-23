# -*- coding: utf-8 -*-
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import
from __future__ import unicode_literals
import unittest

from compare_locales.tests import ParserTestMixin, BaseHelper
from compare_locales.paths import File
from compare_locales.parser import (
    Comment,
    IniSection,
    Junk,
    Whitespace,
)


mpl2 = '''\
; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this file,
; You can obtain one at http://mozilla.org/MPL/2.0/.'''


class TestIniParser(ParserTestMixin, unittest.TestCase):

    filename = 'foo.ini'

    def testSimpleHeader(self):
        self._test('''; This file is in the UTF-8 encoding
[Strings]
TitleText=Some Title
''', (
            (Comment, 'UTF-8 encoding'),
            (Whitespace, '\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def testMPL2_Space_UTF(self):
        self._test(mpl2 + '''

; This file is in the UTF-8 encoding
[Strings]
TitleText=Some Title
''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (Comment, 'UTF-8'),
            (Whitespace, '\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def testMPL2_Space(self):
        self._test(mpl2 + '''

[Strings]
TitleText=Some Title
''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def testMPL2_no_space(self):
        self._test(mpl2 + '''
[Strings]
TitleText=Some Title
''', (
            (Comment, mpl2),
            (Whitespace, '\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def testMPL2_MultiSpace(self):
        self._test(mpl2 + '''

; more comments

[Strings]
TitleText=Some Title
''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (Comment, 'more comments'),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def testMPL2_JunkBeforeCategory(self):
        self._test(mpl2 + '''
Junk
[Strings]
TitleText=Some Title
''', (
            (Comment, mpl2),
            (Whitespace, '\n'),
            (Junk, 'Junk\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n')))

    def test_TrailingComment(self):
        self._test(mpl2 + '''

[Strings]
TitleText=Some Title
;Stray trailing comment
''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n'),
            (Comment, 'Stray trailing'),
            (Whitespace, '\n')))

    def test_SpacedTrailingComments(self):
        self._test(mpl2 + '''

[Strings]
TitleText=Some Title

;Stray trailing comment
;Second stray comment

''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n\n'),
            (Comment, 'Second stray comment'),
            (Whitespace, '\n\n')))

    def test_TrailingCommentsAndJunk(self):
        self._test(mpl2 + '''

[Strings]
TitleText=Some Title

;Stray trailing comment
Junk
;Second stray comment

''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n\n'),
            (Comment, 'Stray trailing'),
            (Whitespace, '\n'),
            (Junk, 'Junk\n'),
            (Comment, 'Second stray comment'),
            (Whitespace, '\n\n')))

    def test_JunkInbetweenEntries(self):
        self._test(mpl2 + '''

[Strings]
TitleText=Some Title

Junk

Good=other string
''', (
            (Comment, mpl2),
            (Whitespace, '\n\n'),
            (IniSection, 'Strings'),
            (Whitespace, '\n'),
            ('TitleText', 'Some Title'),
            (Whitespace, '\n\n'),
            (Junk, 'Junk\n\n'),
            ('Good', 'other string'),
            (Whitespace, '\n')))

    def test_empty_file(self):
        self._test('', tuple())
        self._test('\n', ((Whitespace, '\n'),))
        self._test('\n\n', ((Whitespace, '\n\n'),))
        self._test(' \n\n', ((Whitespace, ' \n\n'),))


class TestChecks(BaseHelper):
    file = File('foo.ini', 'foo.ini')
    refContent = b'''\
[Strings]
foo=good
'''

    def test_ok(self):
        self._test(
            b'[Strings]\nfoo=other',
            tuple()
        )

    def test_bad_encoding(self):
        self._test(
            'foo=touché'.encode('latin-1'),
            (
                (
                    "warning",
                    9,
                    "\ufffd in: foo",
                    "encodings"
                ),
            )
        )
