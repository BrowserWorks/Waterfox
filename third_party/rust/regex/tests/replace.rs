macro_rules! replace(
    ($name:ident, $which:ident, $re:expr,
     $search:expr, $replace:expr, $result:expr) => (
        #[test]
        fn $name() {
            let re = regex!($re);
            assert_eq!(re.$which(text!($search), $replace), text!($result));
        }
    );
);

replace!(first, replace, r"[0-9]", "age: 26", t!("Z"), "age: Z6");
replace!(plus, replace, r"[0-9]+", "age: 26", t!("Z"), "age: Z");
replace!(all, replace_all, r"[0-9]", "age: 26", t!("Z"), "age: ZZ");
replace!(
    groups,
    replace,
    r"(?-u)(\S+)\s+(\S+)",
    "w1 w2",
    t!("$2 $1"),
    "w2 w1"
);
replace!(
    double_dollar,
    replace,
    r"(?-u)(\S+)\s+(\S+)",
    "w1 w2",
    t!("$2 $$1"),
    "w2 $1"
);
// replace!(adjacent_index, replace,
// r"([^aeiouy])ies$", "skies", t!("$1y"), "sky");
replace!(
    named,
    replace_all,
    r"(?-u)(?P<first>\S+)\s+(?P<last>\S+)(?P<space>\s*)",
    "w1 w2 w3 w4",
    t!("$last $first$space"),
    "w2 w1 w4 w3"
);
replace!(
    trim,
    replace_all,
    "^[ \t]+|[ \t]+$",
    " \t  trim me\t   \t",
    t!(""),
    "trim me"
);
replace!(number_hypen, replace, r"(.)(.)", "ab", t!("$1-$2"), "a-b");
// replace!(number_underscore, replace, r"(.)(.)", "ab", t!("$1_$2"), "a_b");
replace!(
    simple_expand,
    replace_all,
    r"(?-u)(\w) (\w)",
    "a b",
    t!("$2 $1"),
    "b a"
);
replace!(
    literal_dollar1,
    replace_all,
    r"(?-u)(\w+) (\w+)",
    "a b",
    t!("$$1"),
    "$1"
);
replace!(
    literal_dollar2,
    replace_all,
    r"(?-u)(\w+) (\w+)",
    "a b",
    t!("$2 $$c $1"),
    "b $c a"
);
replace!(
    no_expand1,
    replace,
    r"(?-u)(\S+)\s+(\S+)",
    "w1 w2",
    no_expand!("$2 $1"),
    "$2 $1"
);
replace!(
    no_expand2,
    replace,
    r"(?-u)(\S+)\s+(\S+)",
    "w1 w2",
    no_expand!("$$1"),
    "$$1"
);
use_!(Captures);
replace!(
    closure_returning_reference,
    replace,
    r"([0-9]+)",
    "age: 26",
    |captures: &Captures| {
        match_text!(captures.get(1).unwrap())[0..1].to_owned()
    },
    "age: 2"
);
replace!(
    closure_returning_value,
    replace,
    r"[0-9]+",
    "age: 26",
    |_captures: &Captures| t!("Z").to_owned(),
    "age: Z"
);

// See https://github.com/rust-lang/regex/issues/314
replace!(
    match_at_start_replace_with_empty,
    replace_all,
    r"foo",
    "foobar",
    t!(""),
    "bar"
);

// See https://github.com/rust-lang/regex/issues/393
replace!(single_empty_match, replace, r"^", "bar", t!("foo"), "foobar");

// See https://github.com/rust-lang/regex/issues/399
replace!(
    capture_longest_possible_name,
    replace_all,
    r"(.)",
    "b",
    t!("${1}a $1a"),
    "ba "
);
