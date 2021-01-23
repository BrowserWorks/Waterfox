use proc_macro2::{Ident, Span, TokenStream};

use syn;
use try;

pub fn wrap_in_const(
    serde_path: Option<&syn::Path>,
    trait_: &str,
    ty: &Ident,
    code: TokenStream,
) -> TokenStream {
    let try_replacement = try::replacement();

    let dummy_const = Ident::new(
        &format!("_IMPL_{}_FOR_{}", trait_, unraw(ty)),
        Span::call_site(),
    );

    let use_serde = match serde_path {
        Some(path) => quote! {
            use #path as _serde;
        },
        None => quote! {
            #[allow(unknown_lints)]
            #[cfg_attr(feature = "cargo-clippy", allow(useless_attribute))]
            #[allow(rust_2018_idioms)]
            extern crate serde as _serde;
        },
    };

    quote! {
        #[allow(non_upper_case_globals, unused_attributes, unused_qualifications)]
        const #dummy_const: () = {
            #use_serde
            #try_replacement
            #code
        };
    }
}

#[allow(deprecated)]
fn unraw(ident: &Ident) -> String {
    // str::trim_start_matches was added in 1.30, trim_left_matches deprecated
    // in 1.33. We currently support rustc back to 1.15 so we need to continue
    // to use the deprecated one.
    ident.to_string().trim_left_matches("r#").to_owned()
}
