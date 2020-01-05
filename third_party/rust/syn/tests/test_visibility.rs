mod features;

use proc_macro2::TokenStream;
use syn::parse::{Parse, ParseStream};
use syn::{Result, Visibility};

#[derive(Debug)]
struct VisRest {
    vis: Visibility,
    rest: TokenStream,
}

impl Parse for VisRest {
    fn parse(input: ParseStream) -> Result<Self> {
        Ok(VisRest {
            vis: input.parse()?,
            rest: input.parse()?,
        })
    }
}

macro_rules! assert_vis_parse {
    ($input:expr, Ok($p:pat)) => {
        assert_vis_parse!($input, Ok($p) + "");
    };

    ($input:expr, Ok($p:pat) + $rest:expr) => {
        let expected = $rest.parse::<TokenStream>().unwrap();
        let parse: VisRest = syn::parse_str($input).unwrap();

        match parse.vis {
            $p => {}
            _ => panic!("Expected {}, got {:?}", stringify!($p), parse.vis),
        }

        // NOTE: Round-trips through `to_string` to avoid potential whitespace
        // diffs.
        assert_eq!(parse.rest.to_string(), expected.to_string());
    };

    ($input:expr, Err) => {
        syn::parse2::<VisRest>($input.parse().unwrap()).unwrap_err();
    };
}

#[test]
fn test_pub() {
    assert_vis_parse!("pub", Ok(Visibility::Public(_)));
}

#[test]
fn test_crate() {
    assert_vis_parse!("crate", Ok(Visibility::Crate(_)));
}

#[test]
fn test_inherited() {
    assert_vis_parse!("", Ok(Visibility::Inherited));
}

#[test]
fn test_in() {
    assert_vis_parse!("pub(in foo::bar)", Ok(Visibility::Restricted(_)));
}

#[test]
fn test_pub_crate() {
    assert_vis_parse!("pub(crate)", Ok(Visibility::Restricted(_)));
}

#[test]
fn test_pub_self() {
    assert_vis_parse!("pub(self)", Ok(Visibility::Restricted(_)));
}

#[test]
fn test_pub_super() {
    assert_vis_parse!("pub(super)", Ok(Visibility::Restricted(_)));
}

#[test]
fn test_missing_in() {
    assert_vis_parse!("pub(foo::bar)", Ok(Visibility::Public(_)) + "(foo::bar)");
}

#[test]
fn test_missing_in_path() {
    assert_vis_parse!("pub(in)", Err);
}

#[test]
fn test_crate_path() {
    assert_vis_parse!("pub(crate::A, crate::B)", Ok(Visibility::Public(_)) + "(crate::A, crate::B)");
}

#[test]
fn test_junk_after_in() {
    assert_vis_parse!("pub(in some::path @@garbage)", Err);
}
