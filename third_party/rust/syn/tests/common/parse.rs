extern crate rustc_expand;
extern crate rustc_parse as parse;
extern crate rustc_span;
extern crate syntax;

use rustc_span::FileName;
use syntax::ast;
use syntax::ptr::P;
use syntax::sess::ParseSess;
use syntax::source_map::FilePathMapping;

use std::panic;

pub fn libsyntax_expr(input: &str) -> Option<P<ast::Expr>> {
    match panic::catch_unwind(|| {
        let sess = ParseSess::new(FilePathMapping::empty());
        sess.span_diagnostic.set_continue_after_error(false);
        let e = parse::new_parser_from_source_str(
            &sess,
            FileName::Custom("test_precedence".to_string()),
            input.to_string(),
        )
        .parse_expr();
        match e {
            Ok(expr) => Some(expr),
            Err(mut diagnostic) => {
                diagnostic.emit();
                None
            }
        }
    }) {
        Ok(Some(e)) => Some(e),
        Ok(None) => None,
        Err(_) => {
            errorf!("libsyntax panicked\n");
            None
        }
    }
}

pub fn syn_expr(input: &str) -> Option<syn::Expr> {
    match syn::parse_str(input) {
        Ok(e) => Some(e),
        Err(msg) => {
            errorf!("syn failed to parse\n{:?}\n", msg);
            None
        }
    }
}
