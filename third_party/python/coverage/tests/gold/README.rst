.. Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
.. For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

Gold files
==========

These are files used in comparisons for some of the tests.  Code to support
these comparisons is in tests/goldtest.py.

If gold tests are failing, it can useful to set the COVERAGE_KEEP_TMP
environment variable.  If set, the test working directories at
$TMPDIR/coverage_test are kept after the tests are run, so that you can
manually inspect the differences.

Do this to clean the output directories and run only the failed tests while
keeping the output::

    rm -rf $TMPDIR/coverage_test
    COVERAGE_KEEP_TMP=1 tox -e py37 -- --lf

The saved HTML files in the html directories can't be viewed properly without
the supporting CSS and Javascript files. But we don't want to save copies of
those files in every subdirectory.  There's a Makefile in the html directory
for working with the saved copies of the support files.

If the output files are correct, you can update the gold files with "make
update-gold".  If there are version-specific gold files (for example,
bom/2/\*), you'll need to update them manually.
