/// Parse the input TokenStream of a macro, triggering a compile error if the
/// tokens fail to parse.
///
/// Refer to the [`parse` module] documentation for more details about parsing
/// in Syn.
///
/// [`parse` module]: crate::rustdoc_workaround::parse_module
///
/// <br>
///
/// # Intended usage
///
/// This macro must be called from a function that returns
/// `proc_macro::TokenStream`. Usually this will be your proc macro entry point,
/// the function that has the #\[proc_macro\] / #\[proc_macro_derive\] /
/// #\[proc_macro_attribute\] attribute.
///
/// ```
/// # extern crate proc_macro;
/// #
/// use proc_macro::TokenStream;
/// use syn::{parse_macro_input, Result};
/// use syn::parse::{Parse, ParseStream};
///
/// struct MyMacroInput {
///     /* ... */
/// }
///
/// impl Parse for MyMacroInput {
///     fn parse(input: ParseStream) -> Result<Self> {
///         /* ... */
/// #       Ok(MyMacroInput {})
///     }
/// }
///
/// # const IGNORE: &str = stringify! {
/// #[proc_macro]
/// # };
/// pub fn my_macro(tokens: TokenStream) -> TokenStream {
///     let input = parse_macro_input!(tokens as MyMacroInput);
///
///     /* ... */
/// #   "".parse().unwrap()
/// }
/// ```
///
/// <br>
///
/// # Expansion
///
/// `parse_macro_input!($variable as $Type)` expands to something like:
///
/// ```no_run
/// # extern crate proc_macro;
/// #
/// # macro_rules! doc_test {
/// #     ($variable:ident as $Type:ty) => {
/// match syn::parse::<$Type>($variable) {
///     Ok(syntax_tree) => syntax_tree,
///     Err(err) => return proc_macro::TokenStream::from(err.to_compile_error()),
/// }
/// #     };
/// # }
/// #
/// # fn test(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
/// #     let _ = doc_test!(input as syn::Ident);
/// #     proc_macro::TokenStream::new()
/// # }
/// ```
#[macro_export]
macro_rules! parse_macro_input {
    ($tokenstream:ident as $ty:ty) => {
        match $crate::parse_macro_input::parse::<$ty>($tokenstream) {
            $crate::export::Ok(data) => data,
            $crate::export::Err(err) => {
                return $crate::export::TokenStream::from(err.to_compile_error());
            }
        }
    };
    ($tokenstream:ident) => {
        $crate::parse_macro_input!($tokenstream as _)
    };
}

////////////////////////////////////////////////////////////////////////////////
// Can parse any type that implements Parse.

use crate::parse::{Parse, ParseStream, Parser, Result};
use proc_macro::TokenStream;

// Not public API.
#[doc(hidden)]
pub fn parse<T: ParseMacroInput>(token_stream: TokenStream) -> Result<T> {
    T::parse.parse(token_stream)
}

// Not public API.
#[doc(hidden)]
pub trait ParseMacroInput: Sized {
    fn parse(input: ParseStream) -> Result<Self>;
}

impl<T: Parse> ParseMacroInput for T {
    fn parse(input: ParseStream) -> Result<Self> {
        <T as Parse>::parse(input)
    }
}

////////////////////////////////////////////////////////////////////////////////
// Any other types that we want `parse_macro_input!` to be able to parse.

#[cfg(any(feature = "full", feature = "derive"))]
use crate::AttributeArgs;

#[cfg(any(feature = "full", feature = "derive"))]
impl ParseMacroInput for AttributeArgs {
    fn parse(input: ParseStream) -> Result<Self> {
        let mut metas = Vec::new();

        loop {
            if input.is_empty() {
                break;
            }
            let value = input.parse()?;
            metas.push(value);
            if input.is_empty() {
                break;
            }
            input.parse::<Token![,]>()?;
        }

        Ok(metas)
    }
}
