//! Helper functions and structures for the translation.
use crate::environ::{TargetEnvironment, WasmResult};
use crate::state::ModuleTranslationState;
use crate::wasm_unsupported;
use core::u32;
use cranelift_codegen::entity::entity_impl;
use cranelift_codegen::ir;
use cranelift_codegen::ir::immediates::V128Imm;
use cranelift_frontend::FunctionBuilder;
#[cfg(feature = "enable-serde")]
use serde::{Deserialize, Serialize};
use wasmparser;

/// Index type of a function (imported or defined) inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
#[cfg_attr(feature = "enable-serde", derive(Serialize, Deserialize))]
pub struct FuncIndex(u32);
entity_impl!(FuncIndex);

/// Index type of a defined function inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct DefinedFuncIndex(u32);
entity_impl!(DefinedFuncIndex);

/// Index type of a defined table inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct DefinedTableIndex(u32);
entity_impl!(DefinedTableIndex);

/// Index type of a defined memory inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct DefinedMemoryIndex(u32);
entity_impl!(DefinedMemoryIndex);

/// Index type of a defined global inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct DefinedGlobalIndex(u32);
entity_impl!(DefinedGlobalIndex);

/// Index type of a table (imported or defined) inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct TableIndex(u32);
entity_impl!(TableIndex);

/// Index type of a global variable (imported or defined) inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct GlobalIndex(u32);
entity_impl!(GlobalIndex);

/// Index type of a linear memory (imported or defined) inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct MemoryIndex(u32);
entity_impl!(MemoryIndex);

/// Index type of a signature (imported or defined) inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct SignatureIndex(u32);
entity_impl!(SignatureIndex);

/// Index type of a passive data segment inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct DataIndex(u32);
entity_impl!(DataIndex);

/// Index type of a passive element segment inside the WebAssembly module.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
pub struct ElemIndex(u32);
entity_impl!(ElemIndex);

/// WebAssembly global.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
pub struct Global {
    /// The type of the value stored in the global.
    pub ty: ir::Type,
    /// A flag indicating whether the value may change at runtime.
    pub mutability: bool,
    /// The source of the initial value.
    pub initializer: GlobalInit,
}

/// Globals are initialized via the `const` operators or by referring to another import.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
pub enum GlobalInit {
    /// An `i32.const`.
    I32Const(i32),
    /// An `i64.const`.
    I64Const(i64),
    /// An `f32.const`.
    F32Const(u32),
    /// An `f64.const`.
    F64Const(u64),
    /// A `vconst`.
    V128Const(V128Imm),
    /// A `global.get` of another global.
    GetGlobal(GlobalIndex),
    /// A `ref.null`.
    RefNullConst,
    /// A `ref.func <index>`.
    RefFunc(FuncIndex),
    ///< The global is imported from, and thus initialized by, a different module.
    Import,
}

/// WebAssembly table.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
pub struct Table {
    /// The type of data stored in elements of the table.
    pub ty: TableElementType,
    /// The minimum number of elements in the table.
    pub minimum: u32,
    /// The maximum number of elements in the table.
    pub maximum: Option<u32>,
}

/// WebAssembly table element. Can be a function or a scalar type.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
pub enum TableElementType {
    /// A scalar type.
    Val(ir::Type),
    /// A function.
    Func,
}

/// WebAssembly linear memory.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
pub struct Memory {
    /// The minimum number of pages in the memory.
    pub minimum: u32,
    /// The maximum number of pages in the memory.
    pub maximum: Option<u32>,
    /// Whether the memory may be shared between multiple threads.
    pub shared: bool,
}

/// Helper function translating wasmparser types to Cranelift types when possible.
pub fn type_to_type<PE: TargetEnvironment + ?Sized>(
    ty: wasmparser::Type,
    environ: &PE,
) -> WasmResult<ir::Type> {
    match ty {
        wasmparser::Type::I32 => Ok(ir::types::I32),
        wasmparser::Type::I64 => Ok(ir::types::I64),
        wasmparser::Type::F32 => Ok(ir::types::F32),
        wasmparser::Type::F64 => Ok(ir::types::F64),
        wasmparser::Type::V128 => Ok(ir::types::I8X16),
        wasmparser::Type::AnyRef | wasmparser::Type::AnyFunc | wasmparser::Type::NullRef => {
            Ok(environ.reference_type())
        }
        ty => Err(wasm_unsupported!("type_to_type: wasm type {:?}", ty)),
    }
}

/// Helper function translating wasmparser possible table types to Cranelift types when possible,
/// or None for Func tables.
pub fn tabletype_to_type<PE: TargetEnvironment + ?Sized>(
    ty: wasmparser::Type,
    environ: &PE,
) -> WasmResult<Option<ir::Type>> {
    match ty {
        wasmparser::Type::I32 => Ok(Some(ir::types::I32)),
        wasmparser::Type::I64 => Ok(Some(ir::types::I64)),
        wasmparser::Type::F32 => Ok(Some(ir::types::F32)),
        wasmparser::Type::F64 => Ok(Some(ir::types::F64)),
        wasmparser::Type::V128 => Ok(Some(ir::types::I8X16)),
        wasmparser::Type::AnyRef => Ok(Some(environ.reference_type())),
        wasmparser::Type::AnyFunc => Ok(None),
        ty => Err(wasm_unsupported!(
            "tabletype_to_type: table wasm type {:?}",
            ty
        )),
    }
}

/// Get the parameter and result types for the given Wasm blocktype.
pub fn blocktype_params_results(
    module_translation_state: &ModuleTranslationState,
    ty_or_ft: wasmparser::TypeOrFuncType,
) -> WasmResult<(&[wasmparser::Type], &[wasmparser::Type])> {
    Ok(match ty_or_ft {
        wasmparser::TypeOrFuncType::Type(ty) => match ty {
            wasmparser::Type::I32 => (&[], &[wasmparser::Type::I32]),
            wasmparser::Type::I64 => (&[], &[wasmparser::Type::I64]),
            wasmparser::Type::F32 => (&[], &[wasmparser::Type::F32]),
            wasmparser::Type::F64 => (&[], &[wasmparser::Type::F64]),
            wasmparser::Type::V128 => (&[], &[wasmparser::Type::V128]),
            wasmparser::Type::AnyRef => (&[], &[wasmparser::Type::AnyRef]),
            wasmparser::Type::AnyFunc => (&[], &[wasmparser::Type::AnyFunc]),
            wasmparser::Type::NullRef => (&[], &[wasmparser::Type::NullRef]),
            wasmparser::Type::EmptyBlockType => (&[], &[]),
            ty => return Err(wasm_unsupported!("blocktype_params_results: type {:?}", ty)),
        },
        wasmparser::TypeOrFuncType::FuncType(ty_index) => {
            let sig_idx = SignatureIndex::from_u32(ty_index);
            let (ref params, ref returns) = module_translation_state.wasm_types[sig_idx];
            (&*params, &*returns)
        }
    })
}

/// Create a `Block` with the given Wasm parameters.
pub fn block_with_params<PE: TargetEnvironment + ?Sized>(
    builder: &mut FunctionBuilder,
    params: &[wasmparser::Type],
    environ: &PE,
) -> WasmResult<ir::Block> {
    let block = builder.create_block();
    for ty in params.iter() {
        match ty {
            wasmparser::Type::I32 => {
                builder.append_block_param(block, ir::types::I32);
            }
            wasmparser::Type::I64 => {
                builder.append_block_param(block, ir::types::I64);
            }
            wasmparser::Type::F32 => {
                builder.append_block_param(block, ir::types::F32);
            }
            wasmparser::Type::F64 => {
                builder.append_block_param(block, ir::types::F64);
            }
            wasmparser::Type::AnyRef | wasmparser::Type::AnyFunc | wasmparser::Type::NullRef => {
                builder.append_block_param(block, environ.reference_type());
            }
            wasmparser::Type::V128 => {
                builder.append_block_param(block, ir::types::I8X16);
            }
            ty => {
                return Err(wasm_unsupported!(
                    "block_with_params: type {:?} in multi-value block's signature",
                    ty
                ))
            }
        }
    }
    Ok(block)
}

/// Turns a `wasmparser` `f32` into a `Cranelift` one.
pub fn f32_translation(x: wasmparser::Ieee32) -> ir::immediates::Ieee32 {
    ir::immediates::Ieee32::with_bits(x.bits())
}

/// Turns a `wasmparser` `f64` into a `Cranelift` one.
pub fn f64_translation(x: wasmparser::Ieee64) -> ir::immediates::Ieee64 {
    ir::immediates::Ieee64::with_bits(x.bits())
}

/// Special VMContext value label. It is tracked as 0xffff_fffe label.
pub fn get_vmctx_value_label() -> ir::ValueLabel {
    const VMCTX_LABEL: u32 = 0xffff_fffe;
    ir::ValueLabel::from_u32(VMCTX_LABEL)
}
