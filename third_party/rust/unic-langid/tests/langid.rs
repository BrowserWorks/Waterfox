use unic_langid::LanguageIdentifier;
#[cfg(feature = "unic-langid-macros")]
use unic_langid::{langid, langids};

#[test]
fn basic_test() {
    let loc: LanguageIdentifier = "en-US".parse().expect("Malformed Language Identifier");
    assert_eq!(&loc.to_string(), "en-US");
}

#[test]
#[cfg(feature = "unic-langid-macros")]
fn langid_macro_test() {
    let loc = langid!("en-US");
    assert_eq!(&loc.to_string(), "en-US");
}

#[test]
#[cfg(feature = "unic-langid-macros")]
fn langids_macro_test() {
    let langids = langids!["en-US", "pl", "de-AT", "Pl-Latn-PL"];
    assert_eq!(langids.len(), 4);
    assert_eq!(langids.get(3).unwrap().language(), "pl");
}

#[test]
fn langid_ord() {
    let mut input = vec!["en-Latn", "en-US"];

    let mut langids: Vec<LanguageIdentifier> = input.iter().map(|l| l.parse().unwrap()).collect();

    assert_eq!(
        langids
            .iter()
            .map(|l: &LanguageIdentifier| l.to_string())
            .collect::<Vec<_>>(),
        &["en-Latn", "en-US"]
    );

    input.sort();
    assert_eq!(input, &["en-Latn", "en-US"]);

    langids.sort();

    assert_eq!(
        langids
            .iter()
            .map(|l: &LanguageIdentifier| l.to_string())
            .collect::<Vec<_>>(),
        &["en-US", "en-Latn"]
    );
}
