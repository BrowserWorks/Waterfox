Getting reviews
===============


Thorough code reviews are one of Mozilla's ways of ensuring code quality.
Every patch must be reviewed by the module owner of the code, or one of their designated peers.

To request a review, you will need to specify a review group (starts with #). If there is not, you should select one or more usernames either when you submit the patch, or afterward in the UI.
If you have a mentor, the mentor can usually either also review or find a suitable reviewer on your behalf.

Getting attention: If a reviewer doesn't respond within a week, or so of the review request:

  * Contact the reviewer directly (either via e-mail or on Matrix).
  * Join developers on `Mozilla's Matrix server <https://chat.mozilla.org>`_, and ask if anyone knows why a review may be delayed. Please link to the bug too.
  * If the review is still not addressed, mail the reviewer directly, asking if/when they'll have time to review the patch, or might otherwise be able to review it.

Review groups
-------------


.. list-table::
   :header-rows: 1

   * - Name
     - Owns
     - Members
   * - #build or #firefox-build-system-reviewers
     - The configure & build system
     - `Member list <https://phabricator.services.mozilla.com/project/members/20/>`__
   * - #dom-workers-and-storage-reviewers
     - DOM Workers & Storage
     - `Member list <https://phabricator.services.mozilla.com/project/members/115/>`__
   * - #devtools-inspector-reviewers
     - The devtools inspector tool
     - `Member list <https://phabricator.services.mozilla.com/project/members/109/>`__
   * - #fluent-reviewers
     - Changes to Fluent (FTL) files (translation).
     - `Member list <https://phabricator.services.mozilla.com/project/members/105/>`__
   * - #firefox-source-docs-reviewers
     - Documentation files and its build
     - `Member list <https://phabricator.services.mozilla.com/project/members/118/>`__
   * - #firefox-ux-team
     - User experience (UX)
     - `Member list <https://phabricator.services.mozilla.com/project/members/91/>`__
   * - #firefox-svg-reviewers
     - SVG-related changes
     - `Member list <https://phabricator.services.mozilla.com/project/members/97/>`__
   * - #geckoview-reviewers
     - Changes to GeckoView
     - `Member list <https://phabricator.services.mozilla.com/project/members/92/>`__
   * - #intermittent-reviewers
     - Test manifest changes
     - `Member list <https://phabricator.services.mozilla.com/project/members/110/>`__
   * - #linter-reviewers
     - tools/lint/*
     - `Member list <https://phabricator.services.mozilla.com/project/members/119/>`__
   * - #marionette-reviewers
     - Changes to Marionette
     - `Member list <https://phabricator.services.mozilla.com/project/members/117/>`__
   * - #mozbase
     - Changes to Mozbase
     - `Member list <https://phabricator.services.mozilla.com/project/members/113/>`__
   * - #mozbase-rust
     - Changes to Mozbase in Rust
     - `Member list <https://phabricator.services.mozilla.com/project/members/114/>`__
   * - #perftest-reviewers
     - Perf Tests
     - `Member list <https://phabricator.services.mozilla.com/project/members/102/>`__
   * - #remote-protocol-reviewers
     - Remote protocol
     - `Member list <https://phabricator.services.mozilla.com/project/members/101/>`__
   * - #remote-debugging-reviewers
     - Remote Debugging UI & tools
     - `Member list <https://phabricator.services.mozilla.com/project/members/108/>`__
   * - #static-analysis-reviewers
     - Changes related to Static Analysis
     - `Member list <https://phabricator.services.mozilla.com/project/members/120/>`__
   * - #style or #firefox-style-system-reviewers
     - Firefox style system (servo, layout/style).
     - `Member list <https://phabricator.services.mozilla.com/project/members/90/>`__
   * - #webdriver-reviewers
     - Marionette and Geckodriver in Firefox
     - `Member list <https://phabricator.services.mozilla.com/project/members/103/>`__
   * - #webidl
     - Changes related to WebIDL
     - `Member list <https://phabricator.services.mozilla.com/project/members/112/>`__
   * - #xpcom-reviewers
     - Changes related to XPCOM
     - `Member list <https://phabricator.services.mozilla.com/project/members/125/>`__

To create a new group, fill a `new bug in Conduit::Administration <https://bugzilla.mozilla.org/enter_bug.cgi?product=Conduit&component=Administration>`__.
See `bug 1613306 <https://bugzilla.mozilla.org/show_bug.cgi?id=1613306>`__ as example.
