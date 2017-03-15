/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 *
 * Copyright 2015 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_binary_h
#define wasm_binary_h

#include "builtin/SIMD.h"

namespace js {
namespace wasm {

static const uint32_t MagicNumber        = 0x6d736100; // "\0asm"
static const uint32_t EncodingVersion    = 0x01;

enum class SectionId {
    UserDefined                          = 0,
    Type                                 = 1,
    Import                               = 2,
    Function                             = 3,
    Table                                = 4,
    Memory                               = 5,
    Global                               = 6,
    Export                               = 7,
    Start                                = 8,
    Elem                                 = 9,
    Code                                 = 10,
    Data                                 = 11
};

static const char NameSectionName[] = "name";

enum class TypeCode
{
    I32                                  = 0x7f,  // SLEB128(-0x01)
    I64                                  = 0x7e,  // SLEB128(-0x02)
    F32                                  = 0x7d,  // SLEB128(-0x03)
    F64                                  = 0x7c,  // SLEB128(-0x04)

    // Only emitted internally for asm.js, likely to get collapsed into I128
    I8x16                                = 0x7b,
    I16x8                                = 0x7a,
    I32x4                                = 0x79,
    F32x4                                = 0x78,
    B8x16                                = 0x77,
    B16x8                                = 0x76,
    B32x4                                = 0x75,

    // A function pointer with any signature
    AnyFunc                              = 0x70,  // SLEB128(-0x10)

    // Type constructor for function types
    Func                                 = 0x60,  // SLEB128(-0x20)

    // Special code representing the block signature ()->()
    BlockVoid                            = 0x40,  // SLEB128(-0x40)

    Limit                                = 0x80
};

enum class ValType
{
    I32                                  = uint8_t(TypeCode::I32),
    I64                                  = uint8_t(TypeCode::I64),
    F32                                  = uint8_t(TypeCode::F32),
    F64                                  = uint8_t(TypeCode::F64),

    // ------------------------------------------------------------------------
    // The rest of these types are currently only emitted internally when
    // compiling asm.js and are rejected by wasm validation.

    I8x16                                = uint8_t(TypeCode::I8x16),
    I16x8                                = uint8_t(TypeCode::I16x8),
    I32x4                                = uint8_t(TypeCode::I32x4),
    F32x4                                = uint8_t(TypeCode::F32x4),
    B8x16                                = uint8_t(TypeCode::B8x16),
    B16x8                                = uint8_t(TypeCode::B16x8),
    B32x4                                = uint8_t(TypeCode::B32x4)
};

typedef Vector<ValType, 8, SystemAllocPolicy> ValTypeVector;

enum class DefinitionKind
{
    Function                             = 0x00,
    Table                                = 0x01,
    Memory                               = 0x02,
    Global                               = 0x03
};

enum class GlobalTypeImmediate
{
    IsMutable                            = 0x1,
    AllowedMask                          = 0x1
};

enum class MemoryTableFlags
{
    Default                              = 0x0
};

enum class Op
{
    // Control flow operators
    Unreachable                          = 0x00,
    Nop                                  = 0x01,
    Block                                = 0x02,
    Loop                                 = 0x03,
    If                                   = 0x04,
    Else                                 = 0x05,
    End                                  = 0x0b,
    Br                                   = 0x0c,
    BrIf                                 = 0x0d,
    BrTable                              = 0x0e,
    Return                               = 0x0f,

    // Call operators
    Call                                 = 0x10,
    CallIndirect                         = 0x11,

    // Parametric operators
    Drop                                 = 0x1a,
    Select                               = 0x1b,

    // Variable access
    GetLocal                             = 0x20,
    SetLocal                             = 0x21,
    TeeLocal                             = 0x22,
    GetGlobal                            = 0x23,
    SetGlobal                            = 0x24,

    // Memory-related operators
    I32Load                              = 0x28,
    I64Load                              = 0x29,
    F32Load                              = 0x2a,
    F64Load                              = 0x2b,
    I32Load8S                            = 0x2c,
    I32Load8U                            = 0x2d,
    I32Load16S                           = 0x2e,
    I32Load16U                           = 0x2f,
    I64Load8S                            = 0x30,
    I64Load8U                            = 0x31,
    I64Load16S                           = 0x32,
    I64Load16U                           = 0x33,
    I64Load32S                           = 0x34,
    I64Load32U                           = 0x35,
    I32Store                             = 0x36,
    I64Store                             = 0x37,
    F32Store                             = 0x38,
    F64Store                             = 0x39,
    I32Store8                            = 0x3a,
    I32Store16                           = 0x3b,
    I64Store8                            = 0x3c,
    I64Store16                           = 0x3d,
    I64Store32                           = 0x3e,
    CurrentMemory                        = 0x3f,
    GrowMemory                           = 0x40,

    // Constants
    I32Const                             = 0x41,
    I64Const                             = 0x42,
    F32Const                             = 0x43,
    F64Const                             = 0x44,

    // Comparison operators
    I32Eqz                               = 0x45,
    I32Eq                                = 0x46,
    I32Ne                                = 0x47,
    I32LtS                               = 0x48,
    I32LtU                               = 0x49,
    I32GtS                               = 0x4a,
    I32GtU                               = 0x4b,
    I32LeS                               = 0x4c,
    I32LeU                               = 0x4d,
    I32GeS                               = 0x4e,
    I32GeU                               = 0x4f,
    I64Eqz                               = 0x50,
    I64Eq                                = 0x51,
    I64Ne                                = 0x52,
    I64LtS                               = 0x53,
    I64LtU                               = 0x54,
    I64GtS                               = 0x55,
    I64GtU                               = 0x56,
    I64LeS                               = 0x57,
    I64LeU                               = 0x58,
    I64GeS                               = 0x59,
    I64GeU                               = 0x5a,
    F32Eq                                = 0x5b,
    F32Ne                                = 0x5c,
    F32Lt                                = 0x5d,
    F32Gt                                = 0x5e,
    F32Le                                = 0x5f,
    F32Ge                                = 0x60,
    F64Eq                                = 0x61,
    F64Ne                                = 0x62,
    F64Lt                                = 0x63,
    F64Gt                                = 0x64,
    F64Le                                = 0x65,
    F64Ge                                = 0x66,

    // Numeric operators
    I32Clz                               = 0x67,
    I32Ctz                               = 0x68,
    I32Popcnt                            = 0x69,
    I32Add                               = 0x6a,
    I32Sub                               = 0x6b,
    I32Mul                               = 0x6c,
    I32DivS                              = 0x6d,
    I32DivU                              = 0x6e,
    I32RemS                              = 0x6f,
    I32RemU                              = 0x70,
    I32And                               = 0x71,
    I32Or                                = 0x72,
    I32Xor                               = 0x73,
    I32Shl                               = 0x74,
    I32ShrS                              = 0x75,
    I32ShrU                              = 0x76,
    I32Rotl                              = 0x77,
    I32Rotr                              = 0x78,
    I64Clz                               = 0x79,
    I64Ctz                               = 0x7a,
    I64Popcnt                            = 0x7b,
    I64Add                               = 0x7c,
    I64Sub                               = 0x7d,
    I64Mul                               = 0x7e,
    I64DivS                              = 0x7f,
    I64DivU                              = 0x80,
    I64RemS                              = 0x81,
    I64RemU                              = 0x82,
    I64And                               = 0x83,
    I64Or                                = 0x84,
    I64Xor                               = 0x85,
    I64Shl                               = 0x86,
    I64ShrS                              = 0x87,
    I64ShrU                              = 0x88,
    I64Rotl                              = 0x89,
    I64Rotr                              = 0x8a,
    F32Abs                               = 0x8b,
    F32Neg                               = 0x8c,
    F32Ceil                              = 0x8d,
    F32Floor                             = 0x8e,
    F32Trunc                             = 0x8f,
    F32Nearest                           = 0x90,
    F32Sqrt                              = 0x91,
    F32Add                               = 0x92,
    F32Sub                               = 0x93,
    F32Mul                               = 0x94,
    F32Div                               = 0x95,
    F32Min                               = 0x96,
    F32Max                               = 0x97,
    F32CopySign                          = 0x98,
    F64Abs                               = 0x99,
    F64Neg                               = 0x9a,
    F64Ceil                              = 0x9b,
    F64Floor                             = 0x9c,
    F64Trunc                             = 0x9d,
    F64Nearest                           = 0x9e,
    F64Sqrt                              = 0x9f,
    F64Add                               = 0xa0,
    F64Sub                               = 0xa1,
    F64Mul                               = 0xa2,
    F64Div                               = 0xa3,
    F64Min                               = 0xa4,
    F64Max                               = 0xa5,
    F64CopySign                          = 0xa6,

    // Conversions
    I32WrapI64                           = 0xa7,
    I32TruncSF32                         = 0xa8,
    I32TruncUF32                         = 0xa9,
    I32TruncSF64                         = 0xaa,
    I32TruncUF64                         = 0xab,
    I64ExtendSI32                        = 0xac,
    I64ExtendUI32                        = 0xad,
    I64TruncSF32                         = 0xae,
    I64TruncUF32                         = 0xaf,
    I64TruncSF64                         = 0xb0,
    I64TruncUF64                         = 0xb1,
    F32ConvertSI32                       = 0xb2,
    F32ConvertUI32                       = 0xb3,
    F32ConvertSI64                       = 0xb4,
    F32ConvertUI64                       = 0xb5,
    F32DemoteF64                         = 0xb6,
    F64ConvertSI32                       = 0xb7,
    F64ConvertUI32                       = 0xb8,
    F64ConvertSI64                       = 0xb9,
    F64ConvertUI64                       = 0xba,
    F64PromoteF32                        = 0xbb,

    // Reinterpretations
    I32ReinterpretF32                    = 0xbc,
    I64ReinterpretF64                    = 0xbd,
    F32ReinterpretI32                    = 0xbe,
    F64ReinterpretI64                    = 0xbf,

    // ------------------------------------------------------------------------
    // The rest of these operators are currently only emitted internally when
    // compiling asm.js and are rejected by wasm validation.

    // asm.js-specific operators
    TeeGlobal                            = 0xc8,
    I32Min,
    I32Max,
    I32Neg,
    I32BitNot,
    I32Abs,
    F32TeeStoreF64,
    F64TeeStoreF32,
    I32TeeStore8,
    I32TeeStore16,
    I64TeeStore8,
    I64TeeStore16,
    I64TeeStore32,
    I32TeeStore,
    I64TeeStore,
    F32TeeStore,
    F64TeeStore,
    F64Mod,
    F64Sin,
    F64Cos,
    F64Tan,
    F64Asin,
    F64Acos,
    F64Atan,
    F64Exp,
    F64Log,
    F64Pow,
    F64Atan2,

    // asm.js-style call_indirect with the callee evaluated first.
    OldCallIndirect,

    // Atomics
    I32AtomicsCompareExchange,
    I32AtomicsExchange,
    I32AtomicsLoad,
    I32AtomicsStore,
    I32AtomicsBinOp,

    // SIMD
#define SIMD_OPCODE(TYPE, OP) TYPE##OP,
#define _(OP) SIMD_OPCODE(I8x16, OP)
    FORALL_INT8X16_ASMJS_OP(_)
    I8x16Constructor,
    I8x16Const,
#undef _
    // Unsigned I8x16 operations. These are the SIMD.Uint8x16 operations that
    // behave differently from their SIMD.Int8x16 counterparts.
    I8x16extractLaneU,
    I8x16addSaturateU,
    I8x16subSaturateU,
    I8x16shiftRightByScalarU,
    I8x16lessThanU,
    I8x16lessThanOrEqualU,
    I8x16greaterThanU,
    I8x16greaterThanOrEqualU,

#define SIMD_OPCODE(TYPE, OP) TYPE##OP,
#define _(OP) SIMD_OPCODE(I16x8, OP)
    FORALL_INT16X8_ASMJS_OP(_)
    I16x8Constructor,
    I16x8Const,
#undef _
    // Unsigned I16x8 operations. These are the SIMD.Uint16x8 operations that
    // behave differently from their SIMD.Int16x8 counterparts.
    I16x8extractLaneU,
    I16x8addSaturateU,
    I16x8subSaturateU,
    I16x8shiftRightByScalarU,
    I16x8lessThanU,
    I16x8lessThanOrEqualU,
    I16x8greaterThanU,
    I16x8greaterThanOrEqualU,

#define SIMD_OPCODE(TYPE, OP) TYPE##OP,
#define _(OP) SIMD_OPCODE(I32x4, OP)
    FORALL_INT32X4_ASMJS_OP(_)
    I32x4Constructor,
    I32x4Const,
#undef _
    // Unsigned I32x4 operations. These are the SIMD.Uint32x4 operations that
    // behave differently from their SIMD.Int32x4 counterparts.
    I32x4shiftRightByScalarU,
    I32x4lessThanU,
    I32x4lessThanOrEqualU,
    I32x4greaterThanU,
    I32x4greaterThanOrEqualU,
    I32x4fromFloat32x4U,
#define _(OP) SIMD_OPCODE(F32x4, OP)
    FORALL_FLOAT32X4_ASMJS_OP(_)
    F32x4Constructor,
    F32x4Const,
#undef _

#define _(OP) SIMD_OPCODE(B8x16, OP)
    FORALL_BOOL_SIMD_OP(_)
    B8x16Constructor,
    B8x16Const,
#undef _
#undef OPCODE

#define _(OP) SIMD_OPCODE(B16x8, OP)
    FORALL_BOOL_SIMD_OP(_)
    B16x8Constructor,
    B16x8Const,
#undef _
#undef OPCODE

#define _(OP) SIMD_OPCODE(B32x4, OP)
    FORALL_BOOL_SIMD_OP(_)
    B32x4Constructor,
    B32x4Const,
#undef _
#undef OPCODE

    Limit
};

// Telemetry sample values for the JS_AOT_USAGE key, indicating whether asm.js
// or WebAssembly is used.

enum class Telemetry
{
    ASMJS = 0,
    WASM = 1
};

} // namespace wasm
} // namespace js

#endif // wasm_binary_h
