# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests of miscellaneous stuff."""

import pytest

from coverage.misc import contract, dummy_decorator_with_args, file_be_gone
from coverage.misc import Hasher, one_of, substitute_variables
from coverage.misc import CoverageException, USE_CONTRACTS

from tests.coveragetest import CoverageTest


class HasherTest(CoverageTest):
    """Test our wrapper of md5 hashing."""

    run_in_temp_dir = False

    def test_string_hashing(self):
        h1 = Hasher()
        h1.update("Hello, world!")
        h2 = Hasher()
        h2.update("Goodbye!")
        h3 = Hasher()
        h3.update("Hello, world!")
        self.assertNotEqual(h1.hexdigest(), h2.hexdigest())
        self.assertEqual(h1.hexdigest(), h3.hexdigest())

    def test_bytes_hashing(self):
        h1 = Hasher()
        h1.update(b"Hello, world!")
        h2 = Hasher()
        h2.update(b"Goodbye!")
        self.assertNotEqual(h1.hexdigest(), h2.hexdigest())

    def test_unicode_hashing(self):
        h1 = Hasher()
        h1.update(u"Hello, world! \N{SNOWMAN}")
        h2 = Hasher()
        h2.update(u"Goodbye!")
        self.assertNotEqual(h1.hexdigest(), h2.hexdigest())

    def test_dict_hashing(self):
        h1 = Hasher()
        h1.update({'a': 17, 'b': 23})
        h2 = Hasher()
        h2.update({'b': 23, 'a': 17})
        self.assertEqual(h1.hexdigest(), h2.hexdigest())

    def test_dict_collision(self):
        h1 = Hasher()
        h1.update({'a': 17, 'b': {'c': 1, 'd': 2}})
        h2 = Hasher()
        h2.update({'a': 17, 'b': {'c': 1}, 'd': 2})
        self.assertNotEqual(h1.hexdigest(), h2.hexdigest())


class RemoveFileTest(CoverageTest):
    """Tests of misc.file_be_gone."""

    def test_remove_nonexistent_file(self):
        # It's OK to try to remove a file that doesn't exist.
        file_be_gone("not_here.txt")

    def test_remove_actual_file(self):
        # It really does remove a file that does exist.
        self.make_file("here.txt", "We are here, we are here, we are here!")
        file_be_gone("here.txt")
        self.assert_doesnt_exist("here.txt")

    def test_actual_errors(self):
        # Errors can still happen.
        # ". is a directory" on Unix, or "Access denied" on Windows
        with self.assertRaises(OSError):
            file_be_gone(".")


class ContractTest(CoverageTest):
    """Tests of our contract decorators."""

    run_in_temp_dir = False

    def setUp(self):
        super(ContractTest, self).setUp()
        if not USE_CONTRACTS:
            self.skipTest("Contracts are disabled")

    def test_bytes(self):
        @contract(text='bytes|None')
        def need_bytes(text=None):
            return text

        assert need_bytes(b"Hey") == b"Hey"
        assert need_bytes() is None
        with pytest.raises(Exception):
            need_bytes(u"Oops")

    def test_unicode(self):
        @contract(text='unicode|None')
        def need_unicode(text=None):
            return text

        assert need_unicode(u"Hey") == u"Hey"
        assert need_unicode() is None
        with pytest.raises(Exception):
            need_unicode(b"Oops")

    def test_one_of(self):
        @one_of("a, b, c")
        def give_me_one(a=None, b=None, c=None):
            return (a, b, c)

        assert give_me_one(a=17) == (17, None, None)
        assert give_me_one(b=set()) == (None, set(), None)
        assert give_me_one(c=17) == (None, None, 17)
        with pytest.raises(AssertionError):
            give_me_one(a=17, b=set())
        with pytest.raises(AssertionError):
            give_me_one()

    def test_dummy_decorator_with_args(self):
        @dummy_decorator_with_args("anything", this=17, that="is fine")
        def undecorated(a=None, b=None):
            return (a, b)

        assert undecorated() == (None, None)
        assert undecorated(17) == (17, None)
        assert undecorated(b=23) == (None, 23)
        assert undecorated(b=42, a=3) == (3, 42)


VARS = {
    'FOO': 'fooey',
    'BAR': 'xyzzy',
}

@pytest.mark.parametrize("before, after", [
    ("Nothing to do", "Nothing to do"),
    ("Dollar: $$", "Dollar: $"),
    ("Simple: $FOO is fooey", "Simple: fooey is fooey"),
    ("Braced: X${FOO}X.", "Braced: XfooeyX."),
    ("Missing: x${NOTHING}y is xy", "Missing: xy is xy"),
    ("Multiple: $$ $FOO $BAR ${FOO}", "Multiple: $ fooey xyzzy fooey"),
    ("Ill-formed: ${%5} ${{HI}} ${", "Ill-formed: ${%5} ${{HI}} ${"),
    ("Strict: ${FOO?} is there", "Strict: fooey is there"),
    ("Defaulted: ${WUT-missing}!", "Defaulted: missing!"),
    ("Defaulted empty: ${WUT-}!", "Defaulted empty: !"),
])
def test_substitute_variables(before, after):
    assert substitute_variables(before, VARS) == after

@pytest.mark.parametrize("text", [
    "Strict: ${NOTHING?} is an error",
])
def test_substitute_variables_errors(text):
    with pytest.raises(CoverageException) as exc_info:
        substitute_variables(text, VARS)
    assert text in str(exc_info.value)
    assert "Variable NOTHING is undefined" in str(exc_info.value)
