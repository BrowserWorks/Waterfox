aho-corasick
============
A library for finding occurrences of many patterns at once with SIMD
acceleration in some cases. This library provides multiple pattern
search principally through an implementation of the
[Aho-Corasick algorithm](https://en.wikipedia.org/wiki/Aho%E2%80%93Corasick_algorithm),
which builds a finite state machine for executing searches in linear time.
Features include case insensitive matching, overlapping matches and search &
replace in streams.

[![Linux build status](https://api.travis-ci.org/BurntSushi/aho-corasick.svg)](https://travis-ci.org/BurntSushi/aho-corasick)
[![Windows build status](https://ci.appveyor.com/api/projects/status/github/BurntSushi/aho-corasick?svg=true)](https://ci.appveyor.com/project/BurntSushi/aho-corasick)
[![](http://meritbadge.herokuapp.com/aho-corasick)](https://crates.io/crates/aho-corasick)

Dual-licensed under MIT or the [UNLICENSE](http://unlicense.org).


### Documentation

https://docs.rs/aho-corasick


### Usage

Add this to your `Cargo.toml`:

```toml
[dependencies]
aho-corasick = "0.7"
```

and this to your crate root (if you're using Rust 2015):

```rust
extern crate aho_corasick;
```


### Example: basic searching

This example shows how to search for occurrences of multiple patterns
simultaneously. Each match includes the pattern that matched along with the
byte offsets of the match.

```rust
use aho_corasick::AhoCorasick;

let patterns = &["apple", "maple", "Snapple"];
let haystack = "Nobody likes maple in their apple flavored Snapple.";

let ac = AhoCorasick::new(patterns);
let mut matches = vec![];
for mat in ac.find_iter(haystack) {
    matches.push((mat.pattern(), mat.start(), mat.end()));
}
assert_eq!(matches, vec![
    (1, 13, 18),
    (0, 28, 33),
    (2, 43, 50),
]);
```


### Example: case insensitivity

This is like the previous example, but matches `Snapple` case insensitively
using `AhoCorasickBuilder`:

```rust
use aho_corasick::AhoCorasickBuilder;

let patterns = &["apple", "maple", "snapple"];
let haystack = "Nobody likes maple in their apple flavored Snapple.";

let ac = AhoCorasickBuilder::new()
    .ascii_case_insensitive(true)
    .build(patterns);
let mut matches = vec![];
for mat in ac.find_iter(haystack) {
    matches.push((mat.pattern(), mat.start(), mat.end()));
}
assert_eq!(matches, vec![
    (1, 13, 18),
    (0, 28, 33),
    (2, 43, 50),
]);
```


### Example: replacing matches in a stream

This example shows how to execute a search and replace on a stream without
loading the entire stream into memory first.

```rust
use aho_corasick::AhoCorasick;

# fn example() -> Result<(), ::std::io::Error> {
let patterns = &["fox", "brown", "quick"];
let replace_with = &["sloth", "grey", "slow"];

// In a real example, these might be `std::fs::File`s instead. All you need to
// do is supply a pair of `std::io::Read` and `std::io::Write` implementations.
let rdr = "The quick brown fox.";
let mut wtr = vec![];

let ac = AhoCorasick::new(patterns);
ac.stream_replace_all(rdr.as_bytes(), &mut wtr, replace_with)?;
assert_eq!(b"The slow grey sloth.".to_vec(), wtr);
# Ok(()) }; example().unwrap()
```


### Example: finding the leftmost first match

In the textbook description of Aho-Corasick, its formulation is typically
structured such that it reports all possible matches, even when they overlap
with another. In many cases, overlapping matches may not be desired, such as
the case of finding all successive non-overlapping matches like you might with
a standard regular expression.

Unfortunately the "obvious" way to modify the Aho-Corasick algorithm to do
this doesn't always work in the expected way, since it will report matches as
soon as they are seen. For example, consider matching the regex `Samwise|Sam`
against the text `Samwise`. Most regex engines (that are Perl-like, or
non-POSIX) will report `Samwise` as a match, but the standard Aho-Corasick
algorithm modified for reporting non-overlapping matches will report `Sam`.

A novel contribution of this library is the ability to change the match
semantics of Aho-Corasick (without additional search time overhead) such that
`Samwise` is reported instead. For example, here's the standard approach:

```rust
use aho_corasick::AhoCorasick;

let patterns = &["Samwise", "Sam"];
let haystack = "Samwise";

let ac = AhoCorasick::new(patterns);
let mat = ac.find(haystack).expect("should have a match");
assert_eq!("Sam", &haystack[mat.start()..mat.end()]);
```

And now here's the leftmost-first version, which matches how a Perl-like
regex will work:

```rust
use aho_corasick::{AhoCorasickBuilder, MatchKind};

let patterns = &["Samwise", "Sam"];
let haystack = "Samwise";

let ac = AhoCorasickBuilder::new()
    .match_kind(MatchKind::LeftmostFirst)
    .build(patterns);
let mat = ac.find(haystack).expect("should have a match");
assert_eq!("Samwise", &haystack[mat.start()..mat.end()]);
```

In addition to leftmost-first semantics, this library also supports
leftmost-longest semantics, which match the POSIX behavior of a regular
expression alternation. See `MatchKind` in the docs for more details.


### Minimum Rust version policy

This crate's minimum supported `rustc` version is `1.28.0`.

In general, this crate will be conservative with respect to the minimum
supported version of Rust. In general, it will follow the `regex` crate's
policy, since `regex` is an important dependent.


### Future work

Here are some plans for the future:

* Assuming the current API is sufficient, I'd like to commit to it and release
  a `1.0` version of this crate some time in the next 6-12 months.
* Support stream searching with leftmost match semantics. Currently, only
  standard match semantics are supported. Getting this right seems possible,
  but is tricky since the match state needs to be propagated through multiple
  searches. (With standard semantics, as soon as a match is seen the search
  ends.)
