.. highlight:: shell

.. _bugzilla: https://bugzilla.mozilla.org/enter_bug.cgi?assigned_to=nobody%40mozilla.org&bug_ignored=0&bug_severity=normal&bug_status=NEW&cf_fission_milestone=---&cf_fx_iteration=---&cf_fx_points=---&cf_status_firefox65=---&cf_status_firefox66=---&cf_status_firefox67=---&cf_status_firefox_esr60=---&cf_status_thunderbird_esr60=---&cf_tracking_firefox65=---&cf_tracking_firefox66=---&cf_tracking_firefox67=---&cf_tracking_firefox_esr60=---&cf_tracking_firefox_relnote=---&cf_tracking_thunderbird_esr60=---&product=Data%20Platform%20and%20Tools&component=Glean%3A%20SDK&contenttypemethod=list&contenttypeselection=text%2Fplain&defined_groups=1&flag_type-203=X&flag_type-37=X&flag_type-41=X&flag_type-607=X&flag_type-721=X&flag_type-737=X&flag_type-787=X&flag_type-799=X&flag_type-800=X&flag_type-803=X&flag_type-835=X&flag_type-846=X&flag_type-855=X&flag_type-864=X&flag_type-916=X&flag_type-929=X&flag_type-930=X&flag_type-935=X&flag_type-936=X&flag_type-937=X&form_name=enter_bug&maketemplate=Remember%20values%20as%20bookmarkable%20template&op_sys=Unspecified&priority=P3&&rep_platform=Unspecified&status_whiteboard=%5Btelemetry%3Aglean-rs%3Am%3F%5D&target_milestone=---&version=unspecified


============
Contributing
============

Contributions are welcome, and they are greatly appreciated! Every little bit
helps, and credit will always be given.

You can contribute in many ways:

Types of Contributions
----------------------

Report Bugs
~~~~~~~~~~~

Report bugs at bugzilla_.

If you are reporting a bug, please include:

* Your operating system name and version.
* Any details about your local setup that might be helpful in troubleshooting.
* Detailed steps to reproduce the bug.

Fix Bugs
~~~~~~~~

Look through the GitHub issues for bugs. Anything tagged with "bug" and "help
wanted" is open to whoever wants to implement it.

Implement Features
~~~~~~~~~~~~~~~~~~

Look through the GitHub issues for features. Anything tagged with "enhancement"
and "help wanted" is open to whoever wants to implement it.

Write Documentation
~~~~~~~~~~~~~~~~~~~

Glean Parser could always use more documentation, whether as part of the
official Glean Parser docs, in docstrings, or even on the web in blog posts,
articles, and such.

Submit Feedback
~~~~~~~~~~~~~~~

The best way to send feedback is to file an issue at TODO

If you are proposing a feature:

* Explain in detail how it would work.
* Keep the scope as narrow as possible, to make it easier to implement.
* Remember that this is a volunteer-driven project, and that contributions
  are welcome :)

Get Started!
------------

Ready to contribute? Here's how to set up `glean_parser` for local development.

1. Fork the `glean_parser` repo on GitHub.
2. Clone your fork locally::

    $ git clone git@github.com:your_name_here/glean_parser.git

3. Install your local copy into a virtualenv. Assuming you have
   virtualenvwrapper installed, this is how you set up your fork for local
   development::

    $ mkvirtualenv glean_parser
    $ cd glean_parser/
    $ python setup.py develop

4. Create a branch for local development::

    $ git checkout -b name-of-your-bugfix-or-feature

   Now you can make your changes locally.

5. To test your changes to `glean_parser`:

   Install the testing dependencies::

    $ pip install -r requirements_dev.txt

   If using Python 3.5:

    $ pip install -r requirements_dev_35.txt

   Optionally, if you want to ensure that the generated Kotlin code lints correctly, install a Java SDK, and then run::

     $ make install-kotlin-linters

   Then make sure that all lints and tests are passing::

     $ make lint
     $ make test

6. Commit your changes and push your branch to GitHub::

    $ git add .
    $ git commit -m "Your detailed description of your changes."
    $ git push origin name-of-your-bugfix-or-feature

7. Submit a pull request through the GitHub website.

Pull Request Guidelines
-----------------------

Before you submit a pull request, check that it meets these guidelines:

1. The pull request should include tests.
2. If the pull request adds functionality, the docs should be updated. Put
   your new functionality into a function with a docstring, and add the
   feature to the list in README.rst.
3. The pull request should work for Python 3.5, 3.6, 3.7 and 3.8 (The CI system will take care of testing all of these Python versions).
4. The pull request should update the changelog in `HISTORY.rst`.

Tips
----

To run a subset of tests::

$ py.test tests.test_glean_parser


Deploying
---------

A reminder for the maintainers on how to deploy.

Get a clean master branch with all of the changes from `upstream`::

  $ git checkout master
  $ git fetch upstream
  $ git rebase upstream/master

- Update the header with the new version and date in HISTORY.rst.

- (By using the setuptools-scm package, there is no need to update the version anywhere else).

- Make sure all your changes are committed.

- Push the changes upstream::

  $ git push upstream master

- Wait for [continuous integration to
  pass](https://circleci.com/gh/mozilla/glean/tree/master) on master.

- Make the release on GitHub using [this link](https://github.com/mozilla/glean_parser/releases/new)

- Enter the new version in the form `vX.Y.Z`.

- Copy and paste the relevant part of the `HISTORY.rst` file into the description.

The continuous integration system will then automatically deploy to PyPI.
