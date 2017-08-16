web-platform-tests
==================

This directory contains the W3C
[web-platform-tests](http://github.com/w3c/web-platform-tests). They
can be run using `mach`:

    mach web-platform-tests

To limit the testrun to certain directories use the `--include` option;
for example:

    mach web-platform-tests --include=dom

The testsuite contains a mix of javascript tests and reftests. To
limit the type of tests that get run, use `--test-type=testharness` for
javascript tests or `--test-type=reftest` for reftests.

FAQ
---

* I fixed a bug and some tests have started to pass. How do I fix the
  UNEXPECTED-PASS messages when web-platform-tests is run?

  You need to update the expectation data for those tests. See the
  section on expectations below.

* I want to write some new tests for the web-platform-tests
  testsuite. How do I do that?

  See the section on tests below. You can commit the tests directly to
  the Mozilla repository under `testing/web-platform/tests` and they
  will be upstreamed next time the test is imported. For this reason
  please ensure that any tests you write are testing correct-per-spec
  behaviour even if we don't yet pass, get proper review, and have a
  commit message that makes sense outside of the Mozilla
  context. If you are writing tests that should not be upstreamed yet
  for some reason they must be located under
  `testing/web-platform/mozilla/tests`.

  It is important to note that in order for the tests to run the
  manifest file must be updated; this should not be done by hand, but
  by running `mach wpt-manifest-update` (or `mach web-platform-tests
  --manifest-update`, if you also wish to run some tests).

  `mach web-platform-tests-create <path>` is a helper script designed
  to help create new web-platform-tests. It opens a locally configured
  editor at `<path>` with web-platform-tests boilerplate filled in,
  and in the background runs `mach web-platform-tests
  --manifest-update <path>`, so the test being developed is added to
  the manifest and opened for interactive development.

* How do I write a test that requires the use of a Mozilla-specific
  feature?

  Tests in the `mozilla/tests/` directory use the same harness but are
  not synced with any upstream. Be aware that these tests run on the
  server with a `/_mozilla/` prefix to their URLs.

* A test is unstable; how do I disable it?

  See the section on disabling tests.

Directories
-----------

`tests/` contains the tests themselves. This is a copy of a certain
revision of web-platform-tests. Any patches modifying this directory
will be upstreamed next time the tests are imported.

`harness/` contains the [wptrunner](http://github.com/w3c/wptrunner)
test runner. Again the contents of this directory will be overwritten
on update.

`meta/` contains Gecko-specific expectation data. This is explained in
the following section.

`mozilla/tests` contains tests that will not be upstreamed and may
make use of Mozilla-specific features.

`mozilla/meta` contains metadata for the Mozilla-specific tests.

Expectation Data
----------------

With the tests coming from upstream, it is not guaranteed that they
all pass in Gecko-based browsers. For this reason it is necessary to
provide metadata about the expected results of each test. This is
provided in a set of manifest files in the `meta/` subdirectories.

There is one manifest file per test with "non-default"
expectations. By default tests are expected to PASS, and tests with
subtests are expected to have an overall status of OK. The manifest
file of a test has the same path as the test file but under the `meta`
directory rather than the `tests` directory and has the suffix `.ini`.

The format of these files is similar to `ini` files, but with a couple
of important differences; sections can be nested using indentation,
and only `:` is permitted as a key-value separator. For example the
expectation file for a test with one failing subtest and one erroring
subtest might look like:

    [filename.html]
        type: testharness

        [Subtest name for failing test]
            expected: FAIL

        [Subtest name for erroring test]
            expected: ERROR

Expectations can also be made platform-specific using a simple
python-like conditional syntax e.g. for a test that times out on linux
but otherwise fails:

    [filename.html]
        type: reftest
        expected:
            if os == "linux": TIMEOUT
            FAIL

The available variables for the conditions are those provided by
[mozinfo](http://mozbase.readthedocs.org/en/latest/mozinfo.html).

For more information on manifest files, see the
[wptrunner documentation](http://wptrunner.readthedocs.org/en/latest/expectation.html).

Autogenerating Expectation Data
-------------------------------

After changing some code it may be necessary to update the expectation
data for the relevant tests. This can of course be done manually, but
tools are available to automate much of the process.

First one must run the tests that have changed status, and save the
raw log output to a file:

    mach web-platform-tests --include=url/of/test.html --log-raw=new_results.log

Then the `web-platform-tests-update` command may be run using this log
data to update the expectation files:

    mach web-platform-tests-update --no-check-clean new_results.log

By default this only updates the results data for the current
platform. To forcibly overwrite all existing result data, use the
`--ignore-existing` option to the update command.

Disabling Tests
---------------

Tests are disabled using the same manifest files used to set
expectation values. For example, if a test is unstable on Windows, it
can be disabled using an ini file with the contents:

    [filename.html]
        type: testharness
        disabled:
            if os == "win": https://bugzilla.mozilla.org/show_bug.cgi?id=1234567

Enabling Prefs
--------------

Some tests require specific prefs to be enabled before running. These
prefs can be set in the expectation data using a `prefs` key with a
comma-seperate list of `pref.name:value` items to set e.g.

    [filename.html]
        prefs: [dom.serviceWorkers.enabled:true,
                dom.serviceWorkers.exemptFromPerDomainMax:true,
                dom.caches.enabled:true]

Disabling Leak Checks
----------------------

When a test is imported that leaks, it may be necessary to temporarily
disable leak checking for that test in order to allow the import to
proceed. This works in basically the same way as disabling a test, but
with the key 'leaks' e.g.

    [filename.html]
        type: testharness
        leaks:
            if os == "linux": https://bugzilla.mozilla.org/show_bug.cgi?id=1234567

Setting per-Directory Metadata
------------------------------

Occasionally it is useful to set metadata for an entire directory of
tests e.g. to disable then all, or to enable prefs for every test. In
that case it is possible to create a `__dir__.ini` file in the
metadata directory corresponding to the tests for which you want to
set this metadata e.g. to disable all the tests in
`tests/feature/unsupported/`, one might create
`meta/feature/unsupported/__dir__.ini` with the contents:

    disabled: Feature is unsupported

Settings set in this way are inherited into subdirectories. It is
possible to unset a value that has been set in a parent using the
special token `@Reset` (usually used with prefs), or to force a value
to true or false using `@True` and `@False`.  For example to enable
the tests in `meta/feature/unsupported/subfeature-supported` one might
create an ini file
`meta/feature/unsupported/subfeature-supported/__dir__.ini` like:

    disabled: @False

Test Format
-----------

Javascript tests are written using
[testharness.js](http://github.com/w3c/testharness.js/). Reftests are
similar to standard Gecko reftests without an explicit manifest file,
but with in-test or filename conventions for identifying the
reference.

Full documentation on test authoring and submission can be found on
[testthewebforward.org](http://testthewebforward.org/docs).

Test Manifest
-------------

web-platform-tests use a large auto-generated JSON file as their
manifest. This stores data about the type of tests, their references,
if any, and their timeout, gathered by inspecting the filenames and
the contents of the test files.

In order to update the manifest it is recommended that you run `mach
web-platform-tests --manifest-update`. This rescans the test directory
looking for new, removed, or altered tests.

Running Tests In Other Browsers
-------------------------------

web-platform-tests is cross browser, and the runner is compatible with
multiple browsers. Therefore it's possible to check the behaviour of
tests in other browsers. By default Chrome, Edge and Servo are
supported. In order to run the tests in these browsers use the
`--product` argument to wptrunner:

    mach wpt --product chrome dom/historical.html

By default these browsers run without expectation metadata, but it can
be added in the `testing/web-platform/products/<product>`
directory. To run with the same metadata as for Firefox (so that
differences are reported as unexpected results), pass `--meta
testing/web-platform/meta` to the mach command.
