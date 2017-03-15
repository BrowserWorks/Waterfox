/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/x86-shared/MacroAssembler-x86-shared.h"

#include "jit/JitFrames.h"
#include "jit/MacroAssembler.h"

#include "jit/MacroAssembler-inl.h"

using namespace js;
using namespace js::jit;

// Note: this function clobbers the input register.
void
MacroAssembler::clampDoubleToUint8(FloatRegister input, Register output)
{
    ScratchDoubleScope scratch(*this);
    MOZ_ASSERT(input != scratch);
    Label positive, done;

    // <= 0 or NaN --> 0
    zeroDouble(scratch);
    branchDouble(DoubleGreaterThan, input, scratch, &positive);
    {
        move32(Imm32(0), output);
        jump(&done);
    }

    bind(&positive);

    // Add 0.5 and truncate.
    loadConstantDouble(0.5, scratch);
    addDouble(scratch, input);

    Label outOfRange;

    // Truncate to int32 and ensure the result <= 255. This relies on the
    // processor setting output to a value > 255 for doubles outside the int32
    // range (for instance 0x80000000).
    vcvttsd2si(input, output);
    branch32(Assembler::Above, output, Imm32(255), &outOfRange);
    {
        // Check if we had a tie.
        convertInt32ToDouble(output, scratch);
        branchDouble(DoubleNotEqual, input, scratch, &done);

        // It was a tie. Mask out the ones bit to get an even value.
        // See also js_TypedArray_uint8_clamp_double.
        and32(Imm32(~1), output);
        jump(&done);
    }

    // > 255 --> 255
    bind(&outOfRange);
    {
        move32(Imm32(255), output);
    }

    bind(&done);
}

void
MacroAssembler::alignFrameForICArguments(AfterICSaveLive& aic)
{
    // Exists for MIPS compatibility.
}

void
MacroAssembler::restoreFrameAlignmentForICArguments(AfterICSaveLive& aic)
{
    // Exists for MIPS compatibility.
}

bool
MacroAssemblerX86Shared::buildOOLFakeExitFrame(void* fakeReturnAddr)
{
    uint32_t descriptor = MakeFrameDescriptor(asMasm().framePushed(), JitFrame_IonJS,
                                              ExitFrameLayout::Size());
    asMasm().Push(Imm32(descriptor));
    asMasm().Push(ImmPtr(fakeReturnAddr));
    return true;
}

void
MacroAssemblerX86Shared::branchNegativeZero(FloatRegister reg,
                                            Register scratch,
                                            Label* label,
                                            bool maybeNonZero)
{
    // Determines whether the low double contained in the XMM register reg
    // is equal to -0.0.

#if defined(JS_CODEGEN_X86)
    Label nonZero;

    // if not already compared to zero
    if (maybeNonZero) {
        ScratchDoubleScope scratchDouble(asMasm());

        // Compare to zero. Lets through {0, -0}.
        zeroDouble(scratchDouble);

        // If reg is non-zero, jump to nonZero.
        asMasm().branchDouble(DoubleNotEqual, reg, scratchDouble, &nonZero);
    }
    // Input register is either zero or negative zero. Retrieve sign of input.
    vmovmskpd(reg, scratch);

    // If reg is 1 or 3, input is negative zero.
    // If reg is 0 or 2, input is a normal zero.
    asMasm().branchTest32(NonZero, scratch, Imm32(1), label);

    bind(&nonZero);
#elif defined(JS_CODEGEN_X64)
    vmovq(reg, scratch);
    cmpq(Imm32(1), scratch);
    j(Overflow, label);
#endif
}

void
MacroAssemblerX86Shared::branchNegativeZeroFloat32(FloatRegister reg,
                                                   Register scratch,
                                                   Label* label)
{
    vmovd(reg, scratch);
    cmp32(scratch, Imm32(1));
    j(Overflow, label);
}

MacroAssembler&
MacroAssemblerX86Shared::asMasm()
{
    return *static_cast<MacroAssembler*>(this);
}

const MacroAssembler&
MacroAssemblerX86Shared::asMasm() const
{
    return *static_cast<const MacroAssembler*>(this);
}

template<typename T>
void
MacroAssemblerX86Shared::compareExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem,
                                                        Register oldval, Register newval,
                                                        Register temp, AnyRegister output)
{
    switch (arrayType) {
      case Scalar::Int8:
        compareExchange8SignExtend(mem, oldval, newval, output.gpr());
        break;
      case Scalar::Uint8:
        compareExchange8ZeroExtend(mem, oldval, newval, output.gpr());
        break;
      case Scalar::Int16:
        compareExchange16SignExtend(mem, oldval, newval, output.gpr());
        break;
      case Scalar::Uint16:
        compareExchange16ZeroExtend(mem, oldval, newval, output.gpr());
        break;
      case Scalar::Int32:
        compareExchange32(mem, oldval, newval, output.gpr());
        break;
      case Scalar::Uint32:
        // At the moment, the code in MCallOptimize.cpp requires the output
        // type to be double for uint32 arrays.  See bug 1077305.
        MOZ_ASSERT(output.isFloat());
        compareExchange32(mem, oldval, newval, temp);
        asMasm().convertUInt32ToDouble(temp, output.fpu());
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
MacroAssemblerX86Shared::compareExchangeToTypedIntArray(Scalar::Type arrayType, const Address& mem,
                                                        Register oldval, Register newval, Register temp,
                                                        AnyRegister output);
template void
MacroAssemblerX86Shared::compareExchangeToTypedIntArray(Scalar::Type arrayType, const BaseIndex& mem,
                                                        Register oldval, Register newval, Register temp,
                                                        AnyRegister output);

template<typename T>
void
MacroAssemblerX86Shared::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem,
                                                       Register value, Register temp, AnyRegister output)
{
    switch (arrayType) {
      case Scalar::Int8:
        atomicExchange8SignExtend(mem, value, output.gpr());
        break;
      case Scalar::Uint8:
        atomicExchange8ZeroExtend(mem, value, output.gpr());
        break;
      case Scalar::Int16:
        atomicExchange16SignExtend(mem, value, output.gpr());
        break;
      case Scalar::Uint16:
        atomicExchange16ZeroExtend(mem, value, output.gpr());
        break;
      case Scalar::Int32:
        atomicExchange32(mem, value, output.gpr());
        break;
      case Scalar::Uint32:
        // At the moment, the code in MCallOptimize.cpp requires the output
        // type to be double for uint32 arrays.  See bug 1077305.
        MOZ_ASSERT(output.isFloat());
        atomicExchange32(mem, value, temp);
        asMasm().convertUInt32ToDouble(temp, output.fpu());
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
MacroAssemblerX86Shared::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const Address& mem,
                                                       Register value, Register temp, AnyRegister output);
template void
MacroAssemblerX86Shared::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const BaseIndex& mem,
                                                       Register value, Register temp, AnyRegister output);

template<class T, class Map>
T*
MacroAssemblerX86Shared::getConstant(const typename T::Pod& value, Map& map,
                                     Vector<T, 0, SystemAllocPolicy>& vec)
{
    typedef typename Map::AddPtr AddPtr;
    if (!map.initialized()) {
        enoughMemory_ &= map.init();
        if (!enoughMemory_)
            return nullptr;
    }
    size_t index;
    if (AddPtr p = map.lookupForAdd(value)) {
        index = p->value();
    } else {
        index = vec.length();
        enoughMemory_ &= vec.append(T(value));
        if (!enoughMemory_)
            return nullptr;
        enoughMemory_ &= map.add(p, value, index);
        if (!enoughMemory_)
            return nullptr;
    }
    return &vec[index];
}

MacroAssemblerX86Shared::Float*
MacroAssemblerX86Shared::getFloat(wasm::RawF32 f)
{
    return getConstant<Float, FloatMap>(f.bits(), floatMap_, floats_);
}

MacroAssemblerX86Shared::Double*
MacroAssemblerX86Shared::getDouble(wasm::RawF64 d)
{
    return getConstant<Double, DoubleMap>(d.bits(), doubleMap_, doubles_);
}

MacroAssemblerX86Shared::SimdData*
MacroAssemblerX86Shared::getSimdData(const SimdConstant& v)
{
    return getConstant<SimdData, SimdMap>(v, simdMap_, simds_);
}

template<class T, class Map>
static bool
MergeConstants(size_t delta, const Vector<T, 0, SystemAllocPolicy>& other,
               Map& map, Vector<T, 0, SystemAllocPolicy>& vec)
{
    typedef typename Map::AddPtr AddPtr;
    if (!map.initialized() && !map.init())
        return false;

    for (const T& c : other) {
        size_t index;
        if (AddPtr p = map.lookupForAdd(c.value)) {
            index = p->value();
        } else {
            index = vec.length();
            if (!vec.append(T(c.value)) || !map.add(p, c.value, index))
                return false;
        }
        MacroAssemblerX86Shared::UsesVector& uses = vec[index].uses;
        for (CodeOffset use : c.uses) {
            use.offsetBy(delta);
            if (!uses.append(use))
                return false;
        }
    }

    return true;
}

bool
MacroAssemblerX86Shared::asmMergeWith(const MacroAssemblerX86Shared& other)
{
    size_t sizeBefore = masm.size();
    if (!Assembler::asmMergeWith(other))
        return false;
    if (!MergeConstants<Double, DoubleMap>(sizeBefore, other.doubles_, doubleMap_, doubles_))
        return false;
    if (!MergeConstants<Float, FloatMap>(sizeBefore, other.floats_, floatMap_, floats_))
        return false;
    if (!MergeConstants<SimdData, SimdMap>(sizeBefore, other.simds_, simdMap_, simds_))
        return false;
    return true;
}

void
MacroAssemblerX86Shared::minMaxDouble(FloatRegister first, FloatRegister second, bool canBeNaN,
                                      bool isMax)
{
    Label done, nan, minMaxInst;

    // Do a vucomisd to catch equality and NaNs, which both require special
    // handling. If the operands are ordered and inequal, we branch straight to
    // the min/max instruction. If we wanted, we could also branch for less-than
    // or greater-than here instead of using min/max, however these conditions
    // will sometimes be hard on the branch predictor.
    vucomisd(second, first);
    j(Assembler::NotEqual, &minMaxInst);
    if (canBeNaN)
        j(Assembler::Parity, &nan);

    // Ordered and equal. The operands are bit-identical unless they are zero
    // and negative zero. These instructions merge the sign bits in that
    // case, and are no-ops otherwise.
    if (isMax)
        vandpd(second, first, first);
    else
        vorpd(second, first, first);
    jump(&done);

    // x86's min/max are not symmetric; if either operand is a NaN, they return
    // the read-only operand. We need to return a NaN if either operand is a
    // NaN, so we explicitly check for a NaN in the read-write operand.
    if (canBeNaN) {
        bind(&nan);
        vucomisd(first, first);
        j(Assembler::Parity, &done);
    }

    // When the values are inequal, or second is NaN, x86's min and max will
    // return the value we need.
    bind(&minMaxInst);
    if (isMax)
        vmaxsd(second, first, first);
    else
        vminsd(second, first, first);

    bind(&done);
}

void
MacroAssemblerX86Shared::minMaxFloat32(FloatRegister first, FloatRegister second, bool canBeNaN,
                                       bool isMax)
{
    Label done, nan, minMaxInst;

    // Do a vucomiss to catch equality and NaNs, which both require special
    // handling. If the operands are ordered and inequal, we branch straight to
    // the min/max instruction. If we wanted, we could also branch for less-than
    // or greater-than here instead of using min/max, however these conditions
    // will sometimes be hard on the branch predictor.
    vucomiss(second, first);
    j(Assembler::NotEqual, &minMaxInst);
    if (canBeNaN)
        j(Assembler::Parity, &nan);

    // Ordered and equal. The operands are bit-identical unless they are zero
    // and negative zero. These instructions merge the sign bits in that
    // case, and are no-ops otherwise.
    if (isMax)
        vandps(second, first, first);
    else
        vorps(second, first, first);
    jump(&done);

    // x86's min/max are not symmetric; if either operand is a NaN, they return
    // the read-only operand. We need to return a NaN if either operand is a
    // NaN, so we explicitly check for a NaN in the read-write operand.
    if (canBeNaN) {
        bind(&nan);
        vucomiss(first, first);
        j(Assembler::Parity, &done);
    }

    // When the values are inequal, or second is NaN, x86's min and max will
    // return the value we need.
    bind(&minMaxInst);
    if (isMax)
        vmaxss(second, first, first);
    else
        vminss(second, first, first);

    bind(&done);
}

//{{{ check_macroassembler_style
// ===============================================================
// MacroAssembler high-level usage.

void
MacroAssembler::flush()
{
}

void
MacroAssembler::comment(const char* msg)
{
    masm.comment(msg);
}

// ===============================================================
// Stack manipulation functions.

void
MacroAssembler::PushRegsInMask(LiveRegisterSet set)
{
    FloatRegisterSet fpuSet(set.fpus().reduceSetForPush());
    unsigned numFpu = fpuSet.size();
    int32_t diffF = fpuSet.getPushSizeInBytes();
    int32_t diffG = set.gprs().size() * sizeof(intptr_t);

    // On x86, always use push to push the integer registers, as it's fast
    // on modern hardware and it's a small instruction.
    for (GeneralRegisterBackwardIterator iter(set.gprs()); iter.more(); ++iter) {
        diffG -= sizeof(intptr_t);
        Push(*iter);
    }
    MOZ_ASSERT(diffG == 0);

    reserveStack(diffF);
    for (FloatRegisterBackwardIterator iter(fpuSet); iter.more(); ++iter) {
        FloatRegister reg = *iter;
        diffF -= reg.size();
        numFpu -= 1;
        Address spillAddress(StackPointer, diffF);
        if (reg.isDouble())
            storeDouble(reg, spillAddress);
        else if (reg.isSingle())
            storeFloat32(reg, spillAddress);
        else if (reg.isSimd128())
            storeUnalignedSimd128Float(reg, spillAddress);
        else
            MOZ_CRASH("Unknown register type.");
    }
    MOZ_ASSERT(numFpu == 0);
    // x64 padding to keep the stack aligned on uintptr_t. Keep in sync with
    // GetPushBytesInSize.
    diffF -= diffF % sizeof(uintptr_t);
    MOZ_ASSERT(diffF == 0);
}

void
MacroAssembler::PopRegsInMaskIgnore(LiveRegisterSet set, LiveRegisterSet ignore)
{
    FloatRegisterSet fpuSet(set.fpus().reduceSetForPush());
    unsigned numFpu = fpuSet.size();
    int32_t diffG = set.gprs().size() * sizeof(intptr_t);
    int32_t diffF = fpuSet.getPushSizeInBytes();
    const int32_t reservedG = diffG;
    const int32_t reservedF = diffF;

    for (FloatRegisterBackwardIterator iter(fpuSet); iter.more(); ++iter) {
        FloatRegister reg = *iter;
        diffF -= reg.size();
        numFpu -= 1;
        if (ignore.has(reg))
            continue;

        Address spillAddress(StackPointer, diffF);
        if (reg.isDouble())
            loadDouble(spillAddress, reg);
        else if (reg.isSingle())
            loadFloat32(spillAddress, reg);
        else if (reg.isSimd128())
            loadUnalignedSimd128Float(spillAddress, reg);
        else
            MOZ_CRASH("Unknown register type.");
    }
    freeStack(reservedF);
    MOZ_ASSERT(numFpu == 0);
    // x64 padding to keep the stack aligned on uintptr_t. Keep in sync with
    // GetPushBytesInSize.
    diffF -= diffF % sizeof(uintptr_t);
    MOZ_ASSERT(diffF == 0);

    // On x86, use pop to pop the integer registers, if we're not going to
    // ignore any slots, as it's fast on modern hardware and it's a small
    // instruction.
    if (ignore.emptyGeneral()) {
        for (GeneralRegisterForwardIterator iter(set.gprs()); iter.more(); ++iter) {
            diffG -= sizeof(intptr_t);
            Pop(*iter);
        }
    } else {
        for (GeneralRegisterBackwardIterator iter(set.gprs()); iter.more(); ++iter) {
            diffG -= sizeof(intptr_t);
            if (!ignore.has(*iter))
                loadPtr(Address(StackPointer, diffG), *iter);
        }
        freeStack(reservedG);
    }
    MOZ_ASSERT(diffG == 0);
}

void
MacroAssembler::Push(const Operand op)
{
    push(op);
    adjustFrame(sizeof(intptr_t));
}

void
MacroAssembler::Push(Register reg)
{
    push(reg);
    adjustFrame(sizeof(intptr_t));
}

void
MacroAssembler::Push(const Imm32 imm)
{
    push(imm);
    adjustFrame(sizeof(intptr_t));
}

void
MacroAssembler::Push(const ImmWord imm)
{
    push(imm);
    adjustFrame(sizeof(intptr_t));
}

void
MacroAssembler::Push(const ImmPtr imm)
{
    Push(ImmWord(uintptr_t(imm.value)));
}

void
MacroAssembler::Push(const ImmGCPtr ptr)
{
    push(ptr);
    adjustFrame(sizeof(intptr_t));
}

void
MacroAssembler::Push(FloatRegister t)
{
    push(t);
    adjustFrame(sizeof(double));
}

void
MacroAssembler::Pop(const Operand op)
{
    pop(op);
    implicitPop(sizeof(intptr_t));
}

void
MacroAssembler::Pop(Register reg)
{
    pop(reg);
    implicitPop(sizeof(intptr_t));
}

void
MacroAssembler::Pop(FloatRegister reg)
{
    pop(reg);
    implicitPop(sizeof(double));
}

void
MacroAssembler::Pop(const ValueOperand& val)
{
    popValue(val);
    implicitPop(sizeof(Value));
}

// ===============================================================
// Simple call functions.

CodeOffset
MacroAssembler::call(Register reg)
{
    return Assembler::call(reg);
}

CodeOffset
MacroAssembler::call(Label* label)
{
    return Assembler::call(label);
}

void
MacroAssembler::call(const Address& addr)
{
    Assembler::call(Operand(addr.base, addr.offset));
}

void
MacroAssembler::call(wasm::SymbolicAddress target)
{
    mov(target, eax);
    Assembler::call(eax);
}

void
MacroAssembler::call(ImmWord target)
{
    Assembler::call(target);
}

void
MacroAssembler::call(ImmPtr target)
{
    Assembler::call(target);
}

void
MacroAssembler::call(JitCode* target)
{
    Assembler::call(target);
}

CodeOffset
MacroAssembler::callWithPatch()
{
    return Assembler::callWithPatch();
}
void
MacroAssembler::patchCall(uint32_t callerOffset, uint32_t calleeOffset)
{
    Assembler::patchCall(callerOffset, calleeOffset);
}

void
MacroAssembler::callAndPushReturnAddress(Register reg)
{
    call(reg);
}

void
MacroAssembler::callAndPushReturnAddress(Label* label)
{
    call(label);
}

// ===============================================================
// Patchable near/far jumps.

CodeOffset
MacroAssembler::farJumpWithPatch()
{
    return Assembler::farJumpWithPatch();
}

void
MacroAssembler::patchFarJump(CodeOffset farJump, uint32_t targetOffset)
{
    Assembler::patchFarJump(farJump, targetOffset);
}

void
MacroAssembler::repatchFarJump(uint8_t* code, uint32_t farJumpOffset, uint32_t targetOffset)
{
    Assembler::repatchFarJump(code, farJumpOffset, targetOffset);
}

CodeOffset
MacroAssembler::nopPatchableToNearJump()
{
    return Assembler::twoByteNop();
}

void
MacroAssembler::patchNopToNearJump(uint8_t* jump, uint8_t* target)
{
    Assembler::patchTwoByteNopToJump(jump, target);
}

void
MacroAssembler::patchNearJumpToNop(uint8_t* jump)
{
    Assembler::patchJumpToTwoByteNop(jump);
}

// ===============================================================
// Jit Frames.

uint32_t
MacroAssembler::pushFakeReturnAddress(Register scratch)
{
    CodeLabel cl;

    mov(cl.patchAt(), scratch);
    Push(scratch);
    use(cl.target());
    uint32_t retAddr = currentOffset();

    addCodeLabel(cl);
    return retAddr;
}

// wasm specific methods, used in both the wasm baseline compiler and ion.

// RAII class that generates the jumps to traps when it's destructed, to
// prevent some code duplication in the outOfLineWasmTruncateXtoY methods.
struct MOZ_RAII AutoHandleWasmTruncateToIntErrors
{
    MacroAssembler& masm;
    Label inputIsNaN;
    Label fail;
    wasm::TrapOffset off;

    explicit AutoHandleWasmTruncateToIntErrors(MacroAssembler& masm, wasm::TrapOffset off)
      : masm(masm), off(off)
    { }

    ~AutoHandleWasmTruncateToIntErrors() {
        // Handle errors.
        masm.bind(&fail);
        masm.jump(wasm::TrapDesc(off, wasm::Trap::IntegerOverflow, masm.framePushed()));

        masm.bind(&inputIsNaN);
        masm.jump(wasm::TrapDesc(off, wasm::Trap::InvalidConversionToInteger, masm.framePushed()));
    }
};

void
MacroAssembler::wasmTruncateDoubleToInt32(FloatRegister input, Register output, Label* oolEntry)
{
    vcvttsd2si(input, output);
    cmp32(output, Imm32(1));
    j(Assembler::Overflow, oolEntry);
}

void
MacroAssembler::wasmTruncateFloat32ToInt32(FloatRegister input, Register output, Label* oolEntry)
{
    vcvttss2si(input, output);
    cmp32(output, Imm32(1));
    j(Assembler::Overflow, oolEntry);
}

void
MacroAssembler::outOfLineWasmTruncateDoubleToInt32(FloatRegister input, bool isUnsigned,
                                                   wasm::TrapOffset off, Label* rejoin)
{
    AutoHandleWasmTruncateToIntErrors traps(*this, off);

    // Eagerly take care of NaNs.
    branchDouble(Assembler::DoubleUnordered, input, input, &traps.inputIsNaN);

    // Handle special values (not needed for unsigned values).
    if (isUnsigned)
        return;

    // We've used vcvttsd2si. The only valid double values that can
    // truncate to INT32_MIN are in ]INT32_MIN - 1; INT32_MIN].
    loadConstantDouble(double(INT32_MIN) - 1.0, ScratchDoubleReg);
    branchDouble(Assembler::DoubleLessThanOrEqual, input, ScratchDoubleReg, &traps.fail);

    loadConstantDouble(double(INT32_MIN), ScratchDoubleReg);
    branchDouble(Assembler::DoubleGreaterThan, input, ScratchDoubleReg, &traps.fail);
    jump(rejoin);
}

void
MacroAssembler::outOfLineWasmTruncateFloat32ToInt32(FloatRegister input, bool isUnsigned,
                                                    wasm::TrapOffset off, Label* rejoin)
{
    AutoHandleWasmTruncateToIntErrors traps(*this, off);

    // Eagerly take care of NaNs.
    branchFloat(Assembler::DoubleUnordered, input, input, &traps.inputIsNaN);

    // Handle special values (not needed for unsigned values).
    if (isUnsigned)
        return;

    // We've used vcvttss2si. Check that the input wasn't
    // float(INT32_MIN), which is the only legimitate input that
    // would truncate to INT32_MIN.
    loadConstantFloat32(float(INT32_MIN), ScratchFloat32Reg);
    branchFloat(Assembler::DoubleNotEqual, input, ScratchFloat32Reg, &traps.fail);
    jump(rejoin);
}

void
MacroAssembler::outOfLineWasmTruncateDoubleToInt64(FloatRegister input, bool isUnsigned,
                                                   wasm::TrapOffset off, Label* rejoin)
{
    AutoHandleWasmTruncateToIntErrors traps(*this, off);

    // Eagerly take care of NaNs.
    branchDouble(Assembler::DoubleUnordered, input, input, &traps.inputIsNaN);

    // Handle special values.
    if (isUnsigned) {
        loadConstantDouble(-0.0, ScratchDoubleReg);
        branchDouble(Assembler::DoubleGreaterThan, input, ScratchDoubleReg, &traps.fail);
        loadConstantDouble(-1.0, ScratchDoubleReg);
        branchDouble(Assembler::DoubleLessThanOrEqual, input, ScratchDoubleReg, &traps.fail);
        jump(rejoin);
        return;
    }

    // We've used vcvtsd2sq. The only legit value whose i64
    // truncation is INT64_MIN is double(INT64_MIN): exponent is so
    // high that the highest resolution around is much more than 1.
    loadConstantDouble(double(int64_t(INT64_MIN)), ScratchDoubleReg);
    branchDouble(Assembler::DoubleNotEqual, input, ScratchDoubleReg, &traps.fail);
    jump(rejoin);
}

void
MacroAssembler::outOfLineWasmTruncateFloat32ToInt64(FloatRegister input, bool isUnsigned,
                                                    wasm::TrapOffset off, Label* rejoin)
{
    AutoHandleWasmTruncateToIntErrors traps(*this, off);

    // Eagerly take care of NaNs.
    branchFloat(Assembler::DoubleUnordered, input, input, &traps.inputIsNaN);

    // Handle special values.
    if (isUnsigned) {
        loadConstantFloat32(-0.0f, ScratchFloat32Reg);
        branchFloat(Assembler::DoubleGreaterThan, input, ScratchFloat32Reg, &traps.fail);
        loadConstantFloat32(-1.0f, ScratchFloat32Reg);
        branchFloat(Assembler::DoubleLessThanOrEqual, input, ScratchFloat32Reg, &traps.fail);
        jump(rejoin);
        return;
    }

    // We've used vcvtss2sq. See comment in outOfLineWasmTruncateDoubleToInt64.
    loadConstantFloat32(float(int64_t(INT64_MIN)), ScratchFloat32Reg);
    branchFloat(Assembler::DoubleNotEqual, input, ScratchFloat32Reg, &traps.fail);
    jump(rejoin);
}

//}}} check_macroassembler_style
