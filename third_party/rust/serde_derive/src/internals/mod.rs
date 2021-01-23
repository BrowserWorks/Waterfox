pub mod ast;
pub mod attr;

mod ctxt;
pub use self::ctxt::Ctxt;

mod case;
mod check;
mod symbol;

#[derive(Copy, Clone)]
pub enum Derive {
    Serialize,
    Deserialize,
}
