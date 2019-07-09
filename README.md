The Waterfox source code is a specialised modification of the Mozilla platform, designed for privacy and user choice in mind. You should be able to
install it and compile Waterfox without any issues. Other modifications and patches that are more
upstream have been implemented as well to fix any compatibility/security issues that Mozilla may 
lag behind in implementing (usually due to not being high priority). High request features removed by Mozilla but wanted by users are retained (if they aren't removed due to security).

### Features


* Compiled with Clang-cl on Windows, Clang+LLVM on Linux
* Disabled Encrypted Media Extensions (EME)
* Disabled Web Runtime (deprecated as of 2015)
* Removed Pocket
* Removed Telemetry
* Removed data collection
* Removed startup profiling
* Allow running of all 64-Bit NPAPI plugins
* Allow running of unsigned extensions
* Removal of Sponsored Tiles on New Tab Page
* Addition of Duplicate Tab option (toggle with browser.tabs.duplicateTab, thanks to PandaCodex)
* Locale selector in about:preferences > General (further improved by PandaCodex)


Waterfox is released under the Mozilla Public License Version 2.0:

	https://www.mozilla.org/MPL/2.0/
	
Waterfox binaries are kindly being redistributed free of charge by:

  [<img src="https://s3-us-west-2.amazonaws.com/elof/stackpath-logo-reversed.png" style="width:300px;">](https://www.stackpath.com/?utm_campaign=Partner%20Display&utm_source=Partner%20Display&utm_medium=WaterFox)

From Mozilla's Readme.txt:

An explanation of the Mozilla Source Code Directory Structure and links to
project pages with documentation can be found at:

    https://developer.mozilla.org/en/Mozilla_Source_Code_Directory_Structure

For information on how to build Mozilla from the source code, see:

    http://developer.mozilla.org/en/docs/Build_Documentation

To have your bug fix / feature added to Mozilla, you should create a patch and
submit it to Bugzilla (https://bugzilla.mozilla.org). Instructions are at:

    http://developer.mozilla.org/en/docs/Creating_a_patch
    http://developer.mozilla.org/en/docs/Getting_your_patch_in_the_tree

If you have a question about developing Mozilla, and can't find the solution
on http://developer.mozilla.org, you can try asking your question in a
mozilla.* Usenet group, or on IRC at irc.mozilla.org. [The Mozilla news groups
are accessible on Google Groups, or news.mozilla.org with a NNTP reader.]

You can download nightly development builds from the Mozilla FTP server.
Keep in mind that nightly builds, which are used by Mozilla developers for
testing, may be buggy. Firefox nightlies, for example, can be found at:

    ftp://ftp.mozilla.org/pub/firefox/nightly/latest-trunk/
            - or -
    http://nightly.mozilla.org/
