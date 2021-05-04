# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for coverage.py's improved tokenizer."""

import os.path
import re
import textwrap

from coverage import env
from coverage.phystokens import source_token_lines, source_encoding
from coverage.phystokens import neuter_encoding_declaration, compile_unicode
from coverage.python import get_python_source

from tests.coveragetest import CoverageTest, TESTS_DIR


# A simple program and its token stream.
SIMPLE = u"""\
# yay!
def foo():
  say('two = %d' % 2)
"""

SIMPLE_TOKENS = [
    [('com', "# yay!")],
    [('key', 'def'), ('ws', ' '), ('nam', 'foo'), ('op', '('), ('op', ')'), ('op', ':')],
    [('ws', '  '), ('nam', 'say'), ('op', '('),
        ('str', "'two = %d'"), ('ws', ' '), ('op', '%'),
        ('ws', ' '), ('num', '2'), ('op', ')')],
]

# Mixed-whitespace program, and its token stream.
MIXED_WS = u"""\
def hello():
        a="Hello world!"
\tb="indented"
"""

MIXED_WS_TOKENS = [
    [('key', 'def'), ('ws', ' '), ('nam', 'hello'), ('op', '('), ('op', ')'), ('op', ':')],
    [('ws', '        '), ('nam', 'a'), ('op', '='), ('str', '"Hello world!"')],
    [('ws', '        '), ('nam', 'b'), ('op', '='), ('str', '"indented"')],
]

# https://github.com/nedbat/coveragepy/issues/822
BUG_822 = u"""\
print( "Message 1" )
array = [ 1,2,3,4,       # 4 numbers \\
          5,6,7 ]        # 3 numbers
print( "Message 2" )
"""

class PhysTokensTest(CoverageTest):
    """Tests for coverage.py's improved tokenizer."""

    run_in_temp_dir = False

    def check_tokenization(self, source):
        """Tokenize `source`, then put it back together, should be the same."""
        tokenized = ""
        for line in source_token_lines(source):
            text = "".join(t for _, t in line)
            tokenized += text + "\n"
        # source_token_lines doesn't preserve trailing spaces, so trim all that
        # before comparing.
        source = source.replace('\r\n', '\n')
        source = re.sub(r"(?m)[ \t]+$", "", source)
        tokenized = re.sub(r"(?m)[ \t]+$", "", tokenized)
        self.assertMultiLineEqual(source, tokenized)

    def check_file_tokenization(self, fname):
        """Use the contents of `fname` for `check_tokenization`."""
        self.check_tokenization(get_python_source(fname))

    def test_simple(self):
        self.assertEqual(list(source_token_lines(SIMPLE)), SIMPLE_TOKENS)
        self.check_tokenization(SIMPLE)

    def test_missing_final_newline(self):
        # We can tokenize source that is missing the final newline.
        self.assertEqual(list(source_token_lines(SIMPLE.rstrip())), SIMPLE_TOKENS)

    def test_tab_indentation(self):
        # Mixed tabs and spaces...
        self.assertEqual(list(source_token_lines(MIXED_WS)), MIXED_WS_TOKENS)

    def test_bug_822(self):
        self.check_tokenization(BUG_822)

    def test_tokenize_real_file(self):
        # Check the tokenization of a real file (large, btw).
        real_file = os.path.join(TESTS_DIR, "test_coverage.py")
        self.check_file_tokenization(real_file)

    def test_stress(self):
        # Check the tokenization of a stress-test file.
        stress = os.path.join(TESTS_DIR, "stress_phystoken.tok")
        self.check_file_tokenization(stress)
        stress = os.path.join(TESTS_DIR, "stress_phystoken_dos.tok")
        self.check_file_tokenization(stress)


# The default encoding is different in Python 2 and Python 3.
if env.PY3:
    DEF_ENCODING = "utf-8"
else:
    DEF_ENCODING = "ascii"


ENCODING_DECLARATION_SOURCES = [
    # Various forms from http://www.python.org/dev/peps/pep-0263/
    (1, b"# coding=cp850\n\n", "cp850"),
    (1, b"# coding=latin-1\n", "iso-8859-1"),
    (1, b"# coding=iso-latin-1\n", "iso-8859-1"),
    (1, b"#!/usr/bin/python\n# -*- coding: cp850 -*-\n", "cp850"),
    (1, b"#!/usr/bin/python\n# vim: set fileencoding=cp850:\n", "cp850"),
    (1, b"# This Python file uses this encoding: cp850\n", "cp850"),
    (1, b"# This file uses a different encoding:\n# coding: cp850\n", "cp850"),
    (1, b"\n# coding=cp850\n\n", "cp850"),
    (2, b"# -*-  coding:cp850 -*-\n# vim: fileencoding=cp850\n", "cp850"),
]

class SourceEncodingTest(CoverageTest):
    """Tests of source_encoding() for detecting encodings."""

    run_in_temp_dir = False

    def test_detect_source_encoding(self):
        for _, source, expected in ENCODING_DECLARATION_SOURCES:
            self.assertEqual(
                source_encoding(source),
                expected,
                "Wrong encoding in %r" % source
            )

    def test_detect_source_encoding_not_in_comment(self):
        if env.PYPY3:           # pragma: no metacov
            # PyPy3 gets this case wrong. Not sure what I can do about it,
            # so skip the test.
            self.skipTest("PyPy3 is wrong about non-comment encoding. Skip it.")
        # Should not detect anything here
        source = b'def parse(src, encoding=None):\n    pass'
        self.assertEqual(source_encoding(source), DEF_ENCODING)

    def test_dont_detect_source_encoding_on_third_line(self):
        # A coding declaration doesn't count on the third line.
        source = b"\n\n# coding=cp850\n\n"
        self.assertEqual(source_encoding(source), DEF_ENCODING)

    def test_detect_source_encoding_of_empty_file(self):
        # An important edge case.
        self.assertEqual(source_encoding(b""), DEF_ENCODING)

    def test_bom(self):
        # A BOM means utf-8.
        source = b"\xEF\xBB\xBFtext = 'hello'\n"
        self.assertEqual(source_encoding(source), 'utf-8-sig')

    def test_bom_with_encoding(self):
        source = b"\xEF\xBB\xBF# coding: utf-8\ntext = 'hello'\n"
        self.assertEqual(source_encoding(source), 'utf-8-sig')

    def test_bom_is_wrong(self):
        # A BOM with an explicit non-utf8 encoding is an error.
        source = b"\xEF\xBB\xBF# coding: cp850\n"
        with self.assertRaisesRegex(SyntaxError, "encoding problem: utf-8"):
            source_encoding(source)

    def test_unknown_encoding(self):
        source = b"# coding: klingon\n"
        with self.assertRaisesRegex(SyntaxError, "unknown encoding: klingon"):
            source_encoding(source)


class NeuterEncodingDeclarationTest(CoverageTest):
    """Tests of phystokens.neuter_encoding_declaration()."""

    run_in_temp_dir = False

    def test_neuter_encoding_declaration(self):
        for lines_diff_expected, source, _ in ENCODING_DECLARATION_SOURCES:
            neutered = neuter_encoding_declaration(source.decode("ascii"))
            neutered = neutered.encode("ascii")

            # The neutered source should have the same number of lines.
            source_lines = source.splitlines()
            neutered_lines = neutered.splitlines()
            self.assertEqual(len(source_lines), len(neutered_lines))

            # Only one of the lines should be different.
            lines_different = sum(
                int(nline != sline) for nline, sline in zip(neutered_lines, source_lines)
            )
            self.assertEqual(lines_diff_expected, lines_different)

            # The neutered source will be detected as having no encoding
            # declaration.
            self.assertEqual(
                source_encoding(neutered),
                DEF_ENCODING,
                "Wrong encoding in %r" % neutered
            )

    def test_two_encoding_declarations(self):
        input_src = textwrap.dedent(u"""\
            # -*- coding: ascii -*-
            # -*- coding: utf-8 -*-
            # -*- coding: utf-16 -*-
            """)
        expected_src = textwrap.dedent(u"""\
            # (deleted declaration) -*-
            # (deleted declaration) -*-
            # -*- coding: utf-16 -*-
            """)
        output_src = neuter_encoding_declaration(input_src)
        self.assertEqual(expected_src, output_src)

    def test_one_encoding_declaration(self):
        input_src = textwrap.dedent(u"""\
            # -*- coding: utf-16 -*-
            # Just a comment.
            # -*- coding: ascii -*-
            """)
        expected_src = textwrap.dedent(u"""\
            # (deleted declaration) -*-
            # Just a comment.
            # -*- coding: ascii -*-
            """)
        output_src = neuter_encoding_declaration(input_src)
        self.assertEqual(expected_src, output_src)


class Bug529Test(CoverageTest):
    """Test of bug 529"""

    def test_bug_529(self):
        # Don't over-neuter coding declarations. This happened with a test
        # file which contained code in multi-line strings, all with coding
        # declarations. The neutering of the file also changed the multi-line
        # strings, which it shouldn't have.
        self.make_file("the_test.py", '''\
            # -*- coding: utf-8 -*-
            import unittest
            class Bug529Test(unittest.TestCase):
                def test_two_strings_are_equal(self):
                    src1 = u"""\\
                        # -*- coding: utf-8 -*-
                        # Just a comment.
                        """
                    src2 = u"""\\
                        # -*- coding: utf-8 -*-
                        # Just a comment.
                        """
                    self.assertEqual(src1, src2)

            if __name__ == "__main__":
                unittest.main()
            ''')
        status, out = self.run_command_status("coverage run the_test.py")
        self.assertEqual(status, 0)
        self.assertIn("OK", out)
        # If this test fails, the output will be super-confusing, because it
        # has a failing unit test contained within the failing unit test.


class CompileUnicodeTest(CoverageTest):
    """Tests of compiling Unicode strings."""

    run_in_temp_dir = False

    def assert_compile_unicode(self, source):
        """Assert that `source` will compile properly with `compile_unicode`."""
        source += u"a = 42\n"
        # This doesn't raise an exception:
        code = compile_unicode(source, "<string>", "exec")
        globs = {}
        exec(code, globs)
        self.assertEqual(globs['a'], 42)

    def test_cp1252(self):
        uni = u"""# coding: cp1252\n# \u201C curly \u201D\n"""
        self.assert_compile_unicode(uni)

    def test_double_coding_declaration(self):
        # Build this string in a weird way so that actual vim's won't try to
        # interpret it...
        uni = u"# -*-  coding:utf-8 -*-\n# v" "im: fileencoding=utf-8\n"
        self.assert_compile_unicode(uni)
