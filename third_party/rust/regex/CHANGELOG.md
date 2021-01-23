1.3.3 (2020-01-09)
==================
This is a small maintenance release that upgrades the dependency on
`thread_local` from `0.3` to `1.0`. The minimum supported Rust version remains
at Rust 1.28.


1.3.2 (2020-01-09)
==================
This is a small maintenance release with some house cleaning and bug fixes.

New features:

* [FEATURE #631](https://github.com/rust-lang/regex/issues/631):
  Add a `Match::range` method an a `From<Match> for Range` impl.

Bug fixes:

* [BUG #521](https://github.com/rust-lang/regex/issues/521):
  Corrects `/-/.splitn("a", 2)` to return `["a"]` instead of `["a", ""]`.
* [BUG #594](https://github.com/rust-lang/regex/pull/594):
  Improve error reporting when writing `\p\`.
* [BUG #627](https://github.com/rust-lang/regex/issues/627):
  Corrects `/-/.split("a-")` to return `["a", ""]` instead of `["a"]`.
* [BUG #633](https://github.com/rust-lang/regex/pull/633):
  Squash deprecation warnings for the `std::error::Error::description` method.


1.3.1 (2019-09-04)
==================
This is a maintenance release with no changes in order to try to work-around
a [docs.rs/Cargo issue](https://github.com/rust-lang/docs.rs/issues/400).


1.3.0 (2019-09-03)
==================
This release adds a plethora of new crate features that permit users of regex
to shrink its size considerably, in exchange for giving up either functionality
(such as Unicode support) or runtime performance. When all such features are
disabled, the dependency tree for `regex` shrinks to exactly 1 crate
(`regex-syntax`). More information about the new crate features can be
[found in the docs](https://docs.rs/regex/*/#crate-features).

Note that while this is a new minor version release, the minimum supported
Rust version for this crate remains at `1.28.0`.

New features:

* [FEATURE #474](https://github.com/rust-lang/regex/issues/474):
  The `use_std` feature has been deprecated in favor of the `std` feature.
  The `use_std` feature will be removed in regex 2. Until then, `use_std` will
  remain as an alias for the `std` feature.
* [FEATURE #583](https://github.com/rust-lang/regex/issues/583):
  Add a substantial number of crate features shrinking `regex`.


1.2.1 (2019-08-03)
==================
This release does a bit of house cleaning. Namely:

* This repository is now using rustfmt.
* License headers have been removed from all files, in following suit with the
  Rust project.
* Teddy has been removed from the `regex` crate, and is now part of the
  `aho-corasick` crate.
  [See `aho-corasick`'s new `packed` sub-module for details](https://docs.rs/aho-corasick/0.7.6/aho_corasick/packed/index.html).
* The `utf8-ranges` crate has been deprecated, with its functionality moving
  into the
  [`utf8` sub-module of `regex-syntax`](https://docs.rs/regex-syntax/0.6.11/regex_syntax/utf8/index.html).
* The `ucd-util` dependency has been dropped, in favor of implementing what
  little we need inside of `regex-syntax` itself.

In general, this is part of an ongoing (long term) effort to make optimizations
in the regex engine easier to reason about. The current code is too convoluted
and thus it is very easy to introduce new bugs. This simplification effort is
the primary motivation behind re-working the `aho-corasick` crate to not only
bundle algorithms like Teddy, but to also provide regex-like match semantics
automatically.

Moving forward, the plan is to join up with the `bstr` and `regex-automata`
crates, with the former providing more sophisticated substring search
algorithms (thereby deleting existing code in `regex`) and the latter providing
ahead-of-time compiled DFAs for cases where they are inexpensive to compute.


1.2.0 (2019-07-20)
==================
This release updates regex's minimum supported Rust version to 1.28, which was
release almost 1 year ago. This release also updates regex's Unicode data
tables to 12.1.0.


1.1.9 (2019-07-06)
==================
This release contains a bug fix that caused regex's tests to fail, due to a
dependency on an unreleased behavior in regex-syntax.

* [BUG #593](https://github.com/rust-lang/regex/issues/593):
  Move an integration-style test on error messages into regex-syntax.


1.1.8 (2019-07-04)
==================
This release contains a few small internal refactorings. One of which fixes
an instance of undefined behavior in a part of the SIMD code.

Bug fixes:

* [BUG #545](https://github.com/rust-lang/regex/issues/545):
  Improves error messages when a repetition operator is used without a number.
* [BUG #588](https://github.com/rust-lang/regex/issues/588):
  Removes use of a repr(Rust) union used for type punning in the Teddy matcher.
* [BUG #591](https://github.com/rust-lang/regex/issues/591):
  Update docs for running benchmarks and improve failure modes.


1.1.7 (2019-06-09)
==================
This release fixes up a few warnings as a result of recent deprecations.


1.1.6 (2019-04-16)
==================
This release fixes a regression introduced by a bug fix (for
[BUG #557](https://github.com/rust-lang/regex/issues/557)) which could cause
the regex engine to enter an infinite loop. This bug was originally
[reported against ripgrep](https://github.com/BurntSushi/ripgrep/issues/1247).


1.1.5 (2019-04-01)
==================
This release fixes a bug in regex's dependency specification where it requires
a newer version of regex-syntax, but this wasn't communicated correctly in the
Cargo.toml. This would have been caught by a minimal version check, but this
check was disabled because the `rand` crate itself advertises incorrect
dependency specifications.

Bug fixes:

* [BUG #570](https://github.com/rust-lang/regex/pull/570):
  Fix regex-syntax minimal version.


1.1.4 (2019-03-31)
==================
This release fixes a backwards compatibility regression where Regex was no
longer UnwindSafe. This was caused by the upgrade to aho-corasick 0.7, whose
AhoCorasick type was itself not UnwindSafe. This has been fixed in aho-corasick
0.7.4, which we now require.

Bug fixes:

* [BUG #568](https://github.com/rust-lang/regex/pull/568):
  Fix an API regression where Regex was no longer UnwindSafe.


1.1.3 (2019-03-30)
==================
This releases fixes a few bugs and adds a performance improvement when a regex
is a simple alternation of literals.

Performance improvements:

* [OPT #566](https://github.com/rust-lang/regex/pull/566):
  Upgrades `aho-corasick` to 0.7 and uses it for `foo|bar|...|quux` regexes.

Bug fixes:

* [BUG #527](https://github.com/rust-lang/regex/issues/527):
  Fix a bug where the parser would panic on patterns like `((?x))`.
* [BUG #555](https://github.com/rust-lang/regex/issues/555):
  Fix a bug where the parser would panic on patterns like `(?m){1,1}`.
* [BUG #557](https://github.com/rust-lang/regex/issues/557):
  Fix a bug where captures could lead to an incorrect match.


1.1.2 (2019-02-27)
==================
This release fixes a bug found in the fix introduced in 1.1.1.

Bug fixes:

* [BUG edf45e6f](https://github.com/rust-lang/regex/commit/edf45e6f):
  Fix bug introduced in reverse suffix literal matcher in the 1.1.1 release.


1.1.1 (2019-02-27)
==================
This is a small release with one fix for a bug caused by literal optimizations.

Bug fixes:

* [BUG 661bf53d](https://github.com/rust-lang/regex/commit/661bf53d):
  Fixes a bug in the reverse suffix literal optimization. This was originally
  reported
  [against ripgrep](https://github.com/BurntSushi/ripgrep/issues/1203).


1.1.0 (2018-11-30)
==================
This is a small release with a couple small enhancements. This release also
increases the minimal supported Rust version (MSRV) to 1.24.1 (from 1.20.0). In
accordance with this crate's MSRV policy, this release bumps the minor version
number.

Performance improvements:

* [OPT #511](https://github.com/rust-lang/regex/pull/511),
  [OPT #540](https://github.com/rust-lang/regex/pull/540):
  Improve lazy DFA construction for large regex sets.

New features:

* [FEATURE #538](https://github.com/rust-lang/regex/pull/538):
  Add Emoji and "break" Unicode properties. See [UNICODE.md](UNICODE.md).

Bug fixes:

* [BUG #530](https://github.com/rust-lang/regex/pull/530):
  Add Unicode license (for data tables).
* Various typo/doc fixups.


1.0.6 (2018-11-06)
==================
This is a small release.

Performance improvements:

* [OPT #513](https://github.com/rust-lang/regex/pull/513):
  Improve performance of compiling large Unicode classes by 8-10%.

Bug fixes:

* [BUG #533](https://github.com/rust-lang/regex/issues/533):
  Fix definition of `[[:blank:]]` class that regressed in `regex-syntax 0.5`.


1.0.5 (2018-09-06)
==================
This is a small release with an API enhancement.

New features:

* [FEATURE #509](https://github.com/rust-lang/regex/pull/509):
  Generalize impls of the `Replacer` trait.


1.0.4 (2018-08-25)
==================
This is a small release that bumps the quickcheck dependency.


1.0.3 (2018-08-24)
==================
This is a small bug fix release.

Bug fixes:

* [BUG #504](https://github.com/rust-lang/regex/pull/504):
  Fix for Cargo's "minimal version" support.
* [BUG 1e39165f](https://github.com/rust-lang/regex/commit/1e39165f):
  Fix doc examples for byte regexes.


1.0.2 (2018-07-18)
==================
This release exposes some new lower level APIs on `Regex` that permit
amortizing allocation and controlling the location at which a search is
performed in a more granular way. Most users of the regex crate will not
need or want to use these APIs.

New features:

* [FEATURE #493](https://github.com/rust-lang/regex/pull/493):
  Add a few lower level APIs for amortizing allocation and more fine grained
  searching.

Bug fixes:

* [BUG 3981d2ad](https://github.com/rust-lang/regex/commit/3981d2ad):
  Correct outdated documentation on `RegexBuilder::dot_matches_new_line`.
* [BUG 7ebe4ae0](https://github.com/rust-lang/regex/commit/7ebe4ae0):
  Correct outdated documentation on `Parser::allow_invalid_utf8` in the
  `regex-syntax` crate.
* [BUG 24c7770b](https://github.com/rust-lang/regex/commit/24c7770b):
  Fix a bug in the HIR printer where it wouldn't correctly escape meta
  characters in character classes.


1.0.1 (2018-06-19)
==================
This release upgrades regex's Unicode tables to Unicode 11, and enables SIMD
optimizations automatically on Rust stable (1.27 or newer).

New features:

* [FEATURE #486](https://github.com/rust-lang/regex/pull/486):
  Implement `size_hint` on `RegexSet` match iterators.
* [FEATURE #488](https://github.com/rust-lang/regex/pull/488):
  Update Unicode tables for Unicode 11.
* [FEATURE #490](https://github.com/rust-lang/regex/pull/490):
  SIMD optimizations are now enabled automatically in Rust stable, for versions
  1.27 and up. No compilation flags or features need to be set. CPU support
  SIMD is detected automatically at runtime.

Bug fixes:

* [BUG #482](https://github.com/rust-lang/regex/pull/482):
  Present a better compilation error when the `use_std` feature isn't used.


1.0.0 (2018-05-01)
==================
This release marks the 1.0 release of regex.

While this release includes some breaking changes, most users of older versions
of the regex library should be able to migrate to 1.0 by simply bumping the
version number. The important changes are as follows:

* We adopt Rust 1.20 as the new minimum supported version of Rust for regex.
  We also tentativley adopt a policy that permits bumping the minimum supported
  version of Rust in minor version releases of regex, but no patch releases.
  That is, with respect to semver, we do not strictly consider bumping the
  minimum version of Rust to be a breaking change, but adopt a conservative
  stance as a compromise.
* Octal syntax in regular expressions has been disabled by default. This
  permits better error messages that inform users that backreferences aren't
  available. Octal syntax can be re-enabled via the corresponding option on
  `RegexBuilder`.
* `(?-u:\B)` is no longer allowed in Unicode regexes since it can match at
  invalid UTF-8 code unit boundaries. `(?-u:\b)` is still allowed in Unicode
  regexes.
* The `From<regex_syntax::Error>` impl has been removed. This formally removes
  the public dependency on `regex-syntax`.
* A new feature, `use_std`, has been added and enabled by default. Disabling
  the feature will result in a compilation error. In the future, this may
  permit us to support `no_std` environments (w/ `alloc`) in a backwards
  compatible way.

For more information and discussion, please see
[1.0 release tracking issue](https://github.com/rust-lang/regex/issues/457).


0.2.11 (2018-05-01)
===================
This release primarily contains bug fixes. Some of them resolve bugs where
the parser could panic.

New features:

* [FEATURE #459](https://github.com/rust-lang/regex/pull/459):
  Include C++'s standard regex library and Boost's regex library in the
  benchmark harness. We now include D/libphobos, C++/std, C++/boost, Oniguruma,
  PCRE1, PCRE2, RE2 and Tcl in the harness.

Bug fixes:

* [BUG #445](https://github.com/rust-lang/regex/issues/445):
  Clarify order of indices returned by RegexSet match iterator.
* [BUG #461](https://github.com/rust-lang/regex/issues/461):
  Improve error messages for invalid regexes like `[\d-a]`.
* [BUG #464](https://github.com/rust-lang/regex/issues/464):
  Fix a bug in the error message pretty printer that could cause a panic when
  a regex contained a literal `\n` character.
* [BUG #465](https://github.com/rust-lang/regex/issues/465):
  Fix a panic in the parser that was caused by applying a repetition operator
  to `(?flags)`.
* [BUG #466](https://github.com/rust-lang/regex/issues/466):
  Fix a bug where `\pC` was not recognized as an alias for `\p{Other}`.
* [BUG #470](https://github.com/rust-lang/regex/pull/470):
  Fix a bug where literal searches did more work than necessary for anchored
  regexes.


0.2.10 (2018-03-16)
===================
This release primarily updates the regex crate to changes made in `std::arch`
on nightly Rust.

New features:

* [FEATURE #458](https://github.com/rust-lang/regex/pull/458):
  The `Hir` type in `regex-syntax` now has a printer.


0.2.9 (2018-03-12)
==================
This release introduces a new nightly only feature, `unstable`, which enables
SIMD optimizations for certain types of regexes. No additional compile time
options are necessary, and the regex crate will automatically choose the
best CPU features at run time. As a result, the `simd` (nightly only) crate
dependency has been dropped.

New features:

* [FEATURE #456](https://github.com/rust-lang/regex/pull/456):
  The regex crate now includes AVX2 optimizations in addition to the extant
  SSSE3 optimization.

Bug fixes:

* [BUG #455](https://github.com/rust-lang/regex/pull/455):
  Fix a bug where `(?x)[ / - ]` failed to parse.


0.2.8 (2018-03-12)
==================
Bug gixes:

* [BUG #454](https://github.com/rust-lang/regex/pull/454):
  Fix a bug in the nest limit checker being too aggressive.


0.2.7 (2018-03-07)
==================
This release includes a ground-up rewrite of the regex-syntax crate, which has
been in development for over a year.

New features:

* Error messages for invalid regexes have been greatly improved. You get these
  automatically; you don't need to do anything. In addition to better
  formatting, error messages will now explicitly call out the use of look
  around. When regex 1.0 is released, this will happen for backreferences as
  well.
* Full support for intersection, difference and symmetric difference of
  character classes. These can be used via the `&&`, `--` and `~~` binary
  operators within classes.
* A Unicode Level 1 conformat implementation of `\p{..}` character classes.
  Things like `\p{scx:Hira}`, `\p{age:3.2}` or `\p{Changes_When_Casefolded}`
  now work. All property name and value aliases are supported, and properties
  are selected via loose matching. e.g., `\p{Greek}` is the same as
  `\p{G r E e K}`.
* A new `UNICODE.md` document has been added to this repository that
  exhaustively documents support for UTS#18.
* Empty sub-expressions are now permitted in most places. That is, `()+` is
  now a valid regex.
* Almost everything in regex-syntax now uses constant stack space, even when
  performing anaylsis that requires structural induction. This reduces the risk
  of a user provided regular expression causing a stack overflow.
* [FEATURE #174](https://github.com/rust-lang/regex/issues/174):
  The `Ast` type in `regex-syntax` now contains span information.
* [FEATURE #424](https://github.com/rust-lang/regex/issues/424):
  Support `\u`, `\u{...}`, `\U` and `\U{...}` syntax for specifying code points
  in a regular expression.
* [FEATURE #449](https://github.com/rust-lang/regex/pull/449):
  Add a `Replace::by_ref` adapter for use of a replacer without consuming it.

Bug fixes:

* [BUG #446](https://github.com/rust-lang/regex/issues/446):
  We re-enable the Boyer-Moore literal matcher.


0.2.6 (2018-02-08)
==================
Bug fixes:

* [BUG #446](https://github.com/rust-lang/regex/issues/446):
  Fixes a bug in the new Boyer-Moore searcher that results in a match failure.
  We fix this bug by temporarily disabling Boyer-Moore.


0.2.5 (2017-12-30)
==================
Bug fixes:

* [BUG #437](https://github.com/rust-lang/regex/issues/437):
  Fixes a bug in the new Boyer-Moore searcher that results in a panic.


0.2.4 (2017-12-30)
==================
New features:

* [FEATURE #348](https://github.com/rust-lang/regex/pull/348):
  Improve performance for capture searches on anchored regex.
  (Contributed by @ethanpailes. Nice work!)
* [FEATURE #419](https://github.com/rust-lang/regex/pull/419):
  Expand literal searching to include Tuned Boyer-Moore in some cases.
  (Contributed by @ethanpailes. Nice work!)

Bug fixes:

* [BUG](https://github.com/rust-lang/regex/pull/436):
  The regex compiler plugin has been removed.
* [BUG](https://github.com/rust-lang/regex/pull/436):
  `simd` has been bumped to `0.2.1`, which fixes a Rust nightly build error.
* [BUG](https://github.com/rust-lang/regex/pull/436):
  Bring the benchmark harness up to date.


0.2.3 (2017-11-30)
==================
New features:

* [FEATURE #374](https://github.com/rust-lang/regex/pull/374):
  Add `impl From<Match> for &str`.
* [FEATURE #380](https://github.com/rust-lang/regex/pull/380):
  Derive `Clone` and `PartialEq` on `Error`.
* [FEATURE #400](https://github.com/rust-lang/regex/pull/400):
  Update to Unicode 10.

Bug fixes:

* [BUG #375](https://github.com/rust-lang/regex/issues/375):
  Fix a bug that prevented the bounded backtracker from terminating.
* [BUG #393](https://github.com/rust-lang/regex/issues/393),
  [BUG #394](https://github.com/rust-lang/regex/issues/394):
  Fix bug with `replace` methods for empty matches.


0.2.2 (2017-05-21)
==================
New features:

* [FEATURE #341](https://github.com/rust-lang/regex/issues/341):
  Support nested character classes and intersection operation.
  For example, `[\p{Greek}&&\pL]` matches greek letters and
  `[[0-9]&&[^4]]` matches every decimal digit except `4`.
  (Much thanks to @robinst, who contributed this awesome feature.)

Bug fixes:

* [BUG #321](https://github.com/rust-lang/regex/issues/321):
  Fix bug in literal extraction and UTF-8 decoding.
* [BUG #326](https://github.com/rust-lang/regex/issues/326):
  Add documentation tip about the `(?x)` flag.
* [BUG #333](https://github.com/rust-lang/regex/issues/333):
  Show additional replacement example using curly braces.
* [BUG #334](https://github.com/rust-lang/regex/issues/334):
  Fix bug when resolving captures after a match.
* [BUG #338](https://github.com/rust-lang/regex/issues/338):
  Add example that uses `Captures::get` to API documentation.
* [BUG #353](https://github.com/rust-lang/regex/issues/353):
  Fix RegexSet bug that caused match failure in some cases.
* [BUG #354](https://github.com/rust-lang/regex/pull/354):
  Fix panic in parser when `(?x)` is used.
* [BUG #358](https://github.com/rust-lang/regex/issues/358):
  Fix literal optimization bug with RegexSet.
* [BUG #359](https://github.com/rust-lang/regex/issues/359):
  Fix example code in README.
* [BUG #365](https://github.com/rust-lang/regex/pull/365):
  Fix bug in `rure_captures_len` in the C binding.
* [BUG #367](https://github.com/rust-lang/regex/issues/367):
  Fix byte class bug that caused a panic.


0.2.1
=====
One major bug with `replace_all` has been fixed along with a couple of other
touchups.

* [BUG #312](https://github.com/rust-lang/regex/issues/312):
  Fix documentation for `NoExpand` to reference correct lifetime parameter.
* [BUG #314](https://github.com/rust-lang/regex/issues/314):
  Fix a bug with `replace_all` when replacing a match with the empty string.
* [BUG #316](https://github.com/rust-lang/regex/issues/316):
  Note a missing breaking change from the `0.2.0` CHANGELOG entry.
  (`RegexBuilder::compile` was renamed to `RegexBuilder::build`.)
* [BUG #324](https://github.com/rust-lang/regex/issues/324):
  Compiling `regex` should only require one version of `memchr` crate.


0.2.0
=====
This is a new major release of the regex crate, and is an implementation of the
[regex 1.0 RFC](https://github.com/rust-lang/rfcs/blob/master/text/1620-regex-1.0.md).
We are releasing a `0.2` first, and if there are no major problems, we will
release a `1.0` shortly. For `0.2`, the minimum *supported* Rust version is
1.12.

There are a number of **breaking changes** in `0.2`. They are split into two
types. The first type correspond to breaking changes in regular expression
syntax. The second type correspond to breaking changes in the API.

Breaking changes for regex syntax:

* POSIX character classes now require double bracketing. Previously, the regex
  `[:upper:]` would parse as the `upper` POSIX character class. Now it parses
  as the character class containing the characters `:upper:`. The fix to this
  change is to use `[[:upper:]]` instead. Note that variants like
  `[[:upper:][:blank:]]` continue to work.
* The character `[` must always be escaped inside a character class.
* The characters `&`, `-` and `~` must be escaped if any one of them are
  repeated consecutively. For example, `[&]`, `[\&]`, `[\&\&]`, `[&-&]` are all
  equivalent while `[&&]` is illegal. (The motivation for this and the prior
  change is to provide a backwards compatible path for adding character class
  set notation.)
* A `bytes::Regex` now has Unicode mode enabled by default (like the main
  `Regex` type). This means regexes compiled with `bytes::Regex::new` that
  don't have the Unicode flag set should add `(?-u)` to recover the original
  behavior.

Breaking changes for the regex API:

* `find` and `find_iter` now **return `Match` values instead of
  `(usize, usize)`.** `Match` values have `start` and `end` methods, which
  return the match offsets. `Match` values also have an `as_str` method,
  which returns the text of the match itself.
* The `Captures` type now only provides a single iterator over all capturing
  matches, which should replace uses of `iter` and `iter_pos`. Uses of
  `iter_named` should use the `capture_names` method on `Regex`.
* The `at` method on the `Captures` type has been renamed to `get`, and it
  now returns a `Match`. Similarly, the `name` method on `Captures` now returns
  a `Match`.
* The `replace` methods now return `Cow` values. The `Cow::Borrowed` variant
  is returned when no replacements are made.
* The `Replacer` trait has been completely overhauled. This should only
  impact clients that implement this trait explicitly. Standard uses of
  the `replace` methods should continue to work unchanged. If you implement
  the `Replacer` trait, please consult the new documentation.
* The `quote` free function has been renamed to `escape`.
* The `Regex::with_size_limit` method has been removed. It is replaced by
  `RegexBuilder::size_limit`.
* The `RegexBuilder` type has switched from owned `self` method receivers to
  `&mut self` method receivers. Most uses will continue to work unchanged, but
  some code may require naming an intermediate variable to hold the builder.
* The `compile` method on `RegexBuilder` has been renamed to `build`.
* The free `is_match` function has been removed. It is replaced by compiling
  a `Regex` and calling its `is_match` method.
* The `PartialEq` and `Eq` impls on `Regex` have been dropped. If you relied
  on these impls, the fix is to define a wrapper type around `Regex`, impl
  `Deref` on it and provide the necessary impls.
* The `is_empty` method on `Captures` has been removed. This always returns
  `false`, so its use is superfluous.
* The `Syntax` variant of the `Error` type now contains a string instead of
  a `regex_syntax::Error`. If you were examining syntax errors more closely,
  you'll need to explicitly use the `regex_syntax` crate to re-parse the regex.
* The `InvalidSet` variant of the `Error` type has been removed since it is
  no longer used.
* Most of the iterator types have been renamed to match conventions. If you
  were using these iterator types explicitly, please consult the documentation
  for its new name. For example, `RegexSplits` has been renamed to `Split`.

A number of bugs have been fixed:

* [BUG #151](https://github.com/rust-lang/regex/issues/151):
  The `Replacer` trait has been changed to permit the caller to control
  allocation.
* [BUG #165](https://github.com/rust-lang/regex/issues/165):
  Remove the free `is_match` function.
* [BUG #166](https://github.com/rust-lang/regex/issues/166):
  Expose more knobs (available in `0.1`) and remove `with_size_limit`.
* [BUG #168](https://github.com/rust-lang/regex/issues/168):
  Iterators produced by `Captures` now have the correct lifetime parameters.
* [BUG #175](https://github.com/rust-lang/regex/issues/175):
  Fix a corner case in the parsing of POSIX character classes.
* [BUG #178](https://github.com/rust-lang/regex/issues/178):
  Drop the `PartialEq` and `Eq` impls on `Regex`.
* [BUG #179](https://github.com/rust-lang/regex/issues/179):
  Remove `is_empty` from `Captures` since it always returns false.
* [BUG #276](https://github.com/rust-lang/regex/issues/276):
  Position of named capture can now be retrieved from a `Captures`.
* [BUG #296](https://github.com/rust-lang/regex/issues/296):
  Remove winapi/kernel32-sys dependency on UNIX.
* [BUG #307](https://github.com/rust-lang/regex/issues/307):
  Fix error on emscripten.


0.1.80
======
* [PR #292](https://github.com/rust-lang/regex/pull/292):
  Fixes bug #291, which was introduced by PR #290.

0.1.79
======
* Require regex-syntax 0.3.8.

0.1.78
======
* [PR #290](https://github.com/rust-lang/regex/pull/290):
  Fixes bug #289, which caused some regexes with a certain combination
  of literals to match incorrectly.

0.1.77
======
* [PR #281](https://github.com/rust-lang/regex/pull/281):
  Fixes bug #280 by disabling all literal optimizations when a pattern
  is partially anchored.

0.1.76
======
* Tweak criteria for using the Teddy literal matcher.

0.1.75
======
* [PR #275](https://github.com/rust-lang/regex/pull/275):
  Improves match verification performance in the Teddy SIMD searcher.
* [PR #278](https://github.com/rust-lang/regex/pull/278):
  Replaces slow substring loop in the Teddy SIMD searcher with Aho-Corasick.
* Implemented DoubleEndedIterator on regex set match iterators.

0.1.74
======
* Release regex-syntax 0.3.5 with a minor bug fix.
* Fix bug #272.
* Fix bug #277.
* [PR #270](https://github.com/rust-lang/regex/pull/270):
  Fixes bugs #264, #268 and an unreported where the DFA cache size could be
  drastically under estimated in some cases (leading to high unexpected memory
  usage).

0.1.73
======
* Release `regex-syntax 0.3.4`.
* Bump `regex-syntax` dependency version for `regex` to `0.3.4`.

0.1.72
======
* [PR #262](https://github.com/rust-lang/regex/pull/262):
  Fixes a number of small bugs caught by fuzz testing (AFL).

0.1.71
======
* [PR #236](https://github.com/rust-lang/regex/pull/236):
  Fix a bug in how suffix literals were extracted, which could lead
  to invalid match behavior in some cases.

0.1.70
======
* [PR #231](https://github.com/rust-lang/regex/pull/231):
  Add SIMD accelerated multiple pattern search.
* [PR #228](https://github.com/rust-lang/regex/pull/228):
  Reintroduce the reverse suffix literal optimization.
* [PR #226](https://github.com/rust-lang/regex/pull/226):
  Implements NFA state compression in the lazy DFA.
* [PR #223](https://github.com/rust-lang/regex/pull/223):
  A fully anchored RegexSet can now short-circuit.

0.1.69
======
* [PR #216](https://github.com/rust-lang/regex/pull/216):
  Tweak the threshold for running backtracking.
* [PR #217](https://github.com/rust-lang/regex/pull/217):
  Add upper limit (from the DFA) to capture search (for the NFA).
* [PR #218](https://github.com/rust-lang/regex/pull/218):
  Add rure, a C API.

0.1.68
======
* [PR #210](https://github.com/rust-lang/regex/pull/210):
  Fixed a performance bug in `bytes::Regex::replace` where `extend` was used
  instead of `extend_from_slice`.
* [PR #211](https://github.com/rust-lang/regex/pull/211):
  Fixed a bug in the handling of word boundaries in the DFA.
* [PR #213](https://github.com/rust-lang/pull/213):
  Added RE2 and Tcl to the benchmark harness. Also added a CLI utility from
  running regexes using any of the following regex engines: PCRE1, PCRE2,
  Oniguruma, RE2, Tcl and of course Rust's own regexes.

0.1.67
======
* [PR #201](https://github.com/rust-lang/regex/pull/201):
  Fix undefined behavior in the `regex!` compiler plugin macro.
* [PR #205](https://github.com/rust-lang/regex/pull/205):
  More improvements to DFA performance. Competitive with RE2. See PR for
  benchmarks.
* [PR #209](https://github.com/rust-lang/regex/pull/209):
  Release 0.1.66 was semver incompatible since it required a newer version
  of Rust than previous releases. This PR fixes that. (And `0.1.66` was
  yanked.)

0.1.66
======
* Speculative support for Unicode word boundaries was added to the DFA. This
  should remove the last common case that disqualified use of the DFA.
* An optimization that scanned for suffix literals and then matched the regular
  expression in reverse was removed because it had worst case quadratic time
  complexity. It was replaced with a more limited optimization where, given any
  regex of the form `re$`, it will be matched in reverse from the end of the
  haystack.
* [PR #202](https://github.com/rust-lang/regex/pull/202):
  The inner loop of the DFA was heavily optimized to improve cache locality
  and reduce the overall number of instructions run on each iteration. This
  represents the first use of `unsafe` in `regex` (to elide bounds checks).
* [PR #200](https://github.com/rust-lang/regex/pull/200):
  Use of the `mempool` crate (which used thread local storage) was replaced
  with a faster version of a similar API in @Amanieu's `thread_local` crate.
  It should reduce contention when using a regex from multiple threads
  simultaneously.
* PCRE2 JIT benchmarks were added. A benchmark comparison can be found
  [here](https://gist.github.com/anonymous/14683c01993e91689f7206a18675901b).
  (Includes a comparison with PCRE1's JIT and Oniguruma.)
* A bug where word boundaries weren't being matched correctly in the DFA was
  fixed. This only affected use of `bytes::Regex`.
* [#160](https://github.com/rust-lang/regex/issues/160):
  `Captures` now has a `Debug` impl.
