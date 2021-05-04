# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for FileReporters"""

import os

from coverage.plugin import FileReporter
from coverage.python import PythonFileReporter

from tests.coveragetest import CoverageTest, UsingModulesMixin

# pylint: disable=import-error
# Unable to import 'aa' (No module named aa)


def native(filename):
    """Make `filename` into a native form."""
    return filename.replace("/", os.sep)


class FileReporterTest(UsingModulesMixin, CoverageTest):
    """Tests for FileReporter classes."""

    run_in_temp_dir = False

    def test_filenames(self):
        acu = PythonFileReporter("aa/afile.py")
        bcu = PythonFileReporter("aa/bb/bfile.py")
        ccu = PythonFileReporter("aa/bb/cc/cfile.py")
        self.assertEqual(acu.relative_filename(), "aa/afile.py")
        self.assertEqual(bcu.relative_filename(), "aa/bb/bfile.py")
        self.assertEqual(ccu.relative_filename(), "aa/bb/cc/cfile.py")
        self.assertEqual(acu.source(), "# afile.py\n")
        self.assertEqual(bcu.source(), "# bfile.py\n")
        self.assertEqual(ccu.source(), "# cfile.py\n")

    def test_odd_filenames(self):
        acu = PythonFileReporter("aa/afile.odd.py")
        bcu = PythonFileReporter("aa/bb/bfile.odd.py")
        b2cu = PythonFileReporter("aa/bb.odd/bfile.py")
        self.assertEqual(acu.relative_filename(), "aa/afile.odd.py")
        self.assertEqual(bcu.relative_filename(), "aa/bb/bfile.odd.py")
        self.assertEqual(b2cu.relative_filename(), "aa/bb.odd/bfile.py")
        self.assertEqual(acu.source(), "# afile.odd.py\n")
        self.assertEqual(bcu.source(), "# bfile.odd.py\n")
        self.assertEqual(b2cu.source(), "# bfile.py\n")

    def test_modules(self):
        import aa
        import aa.bb
        import aa.bb.cc

        acu = PythonFileReporter(aa)
        bcu = PythonFileReporter(aa.bb)
        ccu = PythonFileReporter(aa.bb.cc)
        self.assertEqual(acu.relative_filename(), native("aa/__init__.py"))
        self.assertEqual(bcu.relative_filename(), native("aa/bb/__init__.py"))
        self.assertEqual(ccu.relative_filename(), native("aa/bb/cc/__init__.py"))
        self.assertEqual(acu.source(), "# aa\n")
        self.assertEqual(bcu.source(), "# bb\n")
        self.assertEqual(ccu.source(), "")  # yes, empty

    def test_module_files(self):
        import aa.afile
        import aa.bb.bfile
        import aa.bb.cc.cfile

        acu = PythonFileReporter(aa.afile)
        bcu = PythonFileReporter(aa.bb.bfile)
        ccu = PythonFileReporter(aa.bb.cc.cfile)
        self.assertEqual(acu.relative_filename(), native("aa/afile.py"))
        self.assertEqual(bcu.relative_filename(), native("aa/bb/bfile.py"))
        self.assertEqual(ccu.relative_filename(), native("aa/bb/cc/cfile.py"))
        self.assertEqual(acu.source(), "# afile.py\n")
        self.assertEqual(bcu.source(), "# bfile.py\n")
        self.assertEqual(ccu.source(), "# cfile.py\n")

    def test_comparison(self):
        acu = FileReporter("aa/afile.py")
        acu2 = FileReporter("aa/afile.py")
        zcu = FileReporter("aa/zfile.py")
        bcu = FileReporter("aa/bb/bfile.py")
        assert acu == acu2 and acu <= acu2 and acu >= acu2      # pylint: disable=chained-comparison
        assert acu < zcu and acu <= zcu and acu != zcu
        assert zcu > acu and zcu >= acu and zcu != acu
        assert acu < bcu and acu <= bcu and acu != bcu
        assert bcu > acu and bcu >= acu and bcu != acu

    def test_egg(self):
        # Test that we can get files out of eggs, and read their source files.
        # The egg1 module is installed by an action in igor.py.
        import egg1
        import egg1.egg1

        # Verify that we really imported from an egg.  If we did, then the
        # __file__ won't be an actual file, because one of the "directories"
        # in the path is actually the .egg zip file.
        self.assert_doesnt_exist(egg1.__file__)

        ecu = PythonFileReporter(egg1)
        eecu = PythonFileReporter(egg1.egg1)
        self.assertEqual(ecu.source(), u"")
        self.assertIn(u"# My egg file!", eecu.source().splitlines())
