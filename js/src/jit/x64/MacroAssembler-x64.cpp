/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/x64/MacroAssembler-x64.h"

#include "jit/Bailouts.h"
#include "jit/BaselineFrame.h"
#include "jit/JitCompartment.h"
#include "jit/JitFrames.h"
#include "jit/MacroAssembler.h"
#include "jit/MoveEmitter.h"

#include "jit/MacroAssembler-inl.h"

using namespace js;
using namespace js::jit;

void
MacroAssemblerX64::loadConstantDouble(wasm::RawF64 d, FloatRegister dest)
{
    if (maybeInlineDouble(d, dest))
        return;
    Double* dbl = getDouble(d);
    if (!dbl)
        return;
    // The constants will be stored in a pool appended to the text (see
    // finish()), so they will always be a fixed distance from the
    // instructions which reference them. This allows the instructions to use
    // PC-relative addressing. Use "jump" label support code, because we need
    // the same PC-relative address patching that jumps use.
    JmpSrc j = masm.vmovsd_ripr(dest.encoding());
    propagateOOM(dbl->uses.append(CodeOffset(j.offset())));
}

void
MacroAssemblerX64::loadConstantFloat32(wasm::RawF32 f, FloatRegister dest)
{
    if (maybeInlineFloat(f, dest))
        return;
    Float* flt = getFloat(f);
    if (!flt)
        return;
    // See comment in loadConstantDouble
    JmpSrc j = masm.vmovss_ripr(dest.encoding());
    propagateOOM(flt->uses.append(CodeOffset(j.offset())));
}

void
MacroAssemblerX64::loadConstantSimd128Int(const SimdConstant& v, FloatRegister dest)
{
    if (maybeInlineSimd128Int(v, dest))
        return;
    SimdData* val = getSimdData(v);
    if (!val)
        return;
    JmpSrc j = masm.vmovdqa_ripr(dest.encoding());
    propagateOOM(val->uses.append(CodeOffset(j.offset())));
}

void
MacroAssemblerX64::loadConstantFloat32(float f, FloatRegister dest)
{
    loadConstantFloat32(wasm::RawF32(f), dest);
}

void
MacroAssemblerX64::loadConstantDouble(double d, FloatRegister dest)
{
    loadConstantDouble(wasm::RawF64(d), dest);
}

void
MacroAssemblerX64::loadConstantSimd128Float(const SimdConstant&v, FloatRegister dest)
{
    if (maybeInlineSimd128Float(v, dest))
        return;
    SimdData* val = getSimdData(v);
    if (!val)
        return;
    JmpSrc j = masm.vmovaps_ripr(dest.encoding());
    propagateOOM(val->uses.append(CodeOffset(j.offset())));
}

void
MacroAssemblerX64::convertInt64ToDouble(Register64 input, FloatRegister output)
{
    // Zero the output register to break dependencies, see convertInt32ToDouble.
    zeroDouble(output);

    vcvtsq2sd(input.reg, output, output);
}

void
MacroAssemblerX64::convertInt64ToFloat32(Register64 input, FloatRegister output)
{
    // Zero the output register to break dependencies, see convertInt32ToDouble.
    zeroFloat32(output);

    vcvtsq2ss(input.reg, output, output);
}

bool
MacroAssemblerX64::convertUInt64ToDoubleNeedsTemp()
{
    return false;
}

void
MacroAssemblerX64::convertUInt64ToDouble(Register64 input, FloatRegister output, Register temp)
{
    MOZ_ASSERT(temp == Register::Invalid());

    // Zero the output register to break dependencies, see convertInt32ToDouble.
    zeroDouble(output);

    // If the input's sign bit is not set we use vcvtsq2sd directly.
    // Else, we divide by 2, convert to double, and multiply the result by 2.
    Label done;
    Label isSigned;

    testq(input.reg, input.reg);
    j(Assembler::Signed, &isSigned);
    vcvtsq2sd(input.reg, output, output);
    jump(&done);

    bind(&isSigned);

    ScratchRegisterScope scratch(asMasm());
    mov(input.reg, scratch);
    shrq(Imm32(1), scratch);
    vcvtsq2sd(scratch, output, output);
    vaddsd(output, output, output);

    bind(&done);
}

void
MacroAssemblerX64::convertUInt64ToFloat32(Register64 input, FloatRegister output, Register temp)
{
    MOZ_ASSERT(temp == Register::Invalid());

    // Zero the output register to break dependencies, see convertInt32ToDouble.
    zeroFloat32(output);

    // If the input's sign bit is not set we use vcvtsq2ss directly.
    // Else, we divide by 2, convert to float, and multiply the result by 2.
    Label done;
    Label isSigned;

    testq(input.reg, input.reg);
    j(Assembler::Signed, &isSigned);
    vcvtsq2ss(input.reg, output, output);
    jump(&done);

    bind(&isSigned);

    ScratchRegisterScope scratch(asMasm());
    mov(input.reg, scratch);
    shrq(Imm32(1), scratch);
    vcvtsq2ss(scratch, output, output);
    vaddss(output, output, output);

    bind(&done);
}

void
MacroAssemblerX64::wasmTruncateDoubleToInt64(FloatRegister input, Register64 output, Label* oolEntry,
                                             Label* oolRejoin, FloatRegister tempReg)
{
    vcvttsd2sq(input, output.reg);
    cmpq(Imm32(1), output.reg);
    j(Assembler::Overflow, oolEntry);
    bind(oolRejoin);
}

void
MacroAssemblerX64::wasmTruncateFloat32ToInt64(FloatRegister input, Register64 output, Label* oolEntry,
                                              Label* oolRejoin, FloatRegister tempReg)
{
    vcvttss2sq(input, output.reg);
    cmpq(Imm32(1), output.reg);
    j(Assembler::Overflow, oolEntry);
    bind(oolRejoin);
}

void
MacroAssemblerX64::wasmTruncateDoubleToUInt64(FloatRegister input, Register64 output, Label* oolEntry,
                                              Label* oolRejoin, FloatRegister tempReg)
{
    // If the input < INT64_MAX, vcvttsd2sq will do the right thing, so
    // we use it directly. Else, we subtract INT64_MAX, convert to int64,
    // and then add INT64_MAX to the result.

    Label isLarge;

    ScratchDoubleScope scratch(asMasm());
    loadConstantDouble(double(0x8000000000000000), scratch);
    asMasm().branchDouble(Assembler::DoubleGreaterThanOrEqual, input, scratch, &isLarge);
    vcvttsd2sq(input, output.reg);
    testq(output.reg, output.reg);
    j(Assembler::Signed, oolEntry);
    jump(oolRejoin);

    bind(&isLarge);

    moveDouble(input, tempReg);
    vsubsd(scratch, tempReg, tempReg);
    vcvttsd2sq(tempReg, output.reg);
    testq(output.reg, output.reg);
    j(Assembler::Signed, oolEntry);
    asMasm().or64(Imm64(0x8000000000000000), output);

    bind(oolRejoin);
}

void
MacroAssemblerX64::wasmTruncateFloat32ToUInt64(FloatRegister input, Register64 output, Label* oolEntry,
                                               Label* oolRejoin, FloatRegister tempReg)
{
    // If the input < INT64_MAX, vcvttss2sq will do the right thing, so
    // we use it directly. Else, we subtract INT64_MAX, convert to int64,
    // and then add INT64_MAX to the result.

    Label isLarge;

    ScratchFloat32Scope scratch(asMasm());
    loadConstantFloat32(float(0x8000000000000000), scratch);
    asMasm().branchFloat(Assembler::DoubleGreaterThanOrEqual, input, scratch, &isLarge);
    vcvttss2sq(input, output.reg);
    testq(output.reg, output.reg);
    j(Assembler::Signed, oolEntry);
    jump(oolRejoin);

    bind(&isLarge);

    moveFloat32(input, tempReg);
    vsubss(scratch, tempReg, tempReg);
    vcvttss2sq(tempReg, output.reg);
    testq(output.reg, output.reg);
    j(Assembler::Signed, oolEntry);
    asMasm().or64(Imm64(0x8000000000000000), output);

    bind(oolRejoin);
}

void
MacroAssemblerX64::bindOffsets(const MacroAssemblerX86Shared::UsesVector& uses)
{
    for (CodeOffset use : uses) {
        JmpDst dst(currentOffset());
        JmpSrc src(use.offset());
        // Using linkJump here is safe, as explaind in the comment in
        // loadConstantDouble.
        masm.linkJump(src, dst);
    }
}

void
MacroAssemblerX64::finish()
{
    if (!doubles_.empty())
        masm.haltingAlign(sizeof(double));
    for (const Double& d : doubles_) {
        bindOffsets(d.uses);
        masm.int64Constant(d.value);
    }

    if (!floats_.empty())
        masm.haltingAlign(sizeof(float));
    for (const Float& f : floats_) {
        bindOffsets(f.uses);
        masm.int32Constant(f.value);
    }

    // SIMD memory values must be suitably aligned.
    if (!simds_.empty())
        masm.haltingAlign(SimdMemoryAlignment);
    for (const SimdData& v : simds_) {
        bindOffsets(v.uses);
        masm.simd128Constant(v.value.bytes());
    }

    MacroAssemblerX86Shared::finish();
}

void
MacroAssemblerX64::boxValue(JSValueType type, Register src, Register dest)
{
    MOZ_ASSERT(src != dest);

    JSValueShiftedTag tag = (JSValueShiftedTag)JSVAL_TYPE_TO_SHIFTED_TAG(type);
#ifdef DEBUG
    if (type == JSVAL_TYPE_INT32 || type == JSVAL_TYPE_BOOLEAN) {
        Label upper32BitsZeroed;
        movePtr(ImmWord(UINT32_MAX), dest);
        asMasm().branchPtr(Assembler::BelowOrEqual, src, dest, &upper32BitsZeroed);
        breakpoint();
        bind(&upper32BitsZeroed);
    }
#endif
    mov(ImmShiftedTag(tag), dest);
    orq(src, dest);
}

void
MacroAssemblerX64::handleFailureWithHandlerTail(void* handler)
{
    // Reserve space for exception information.
    subq(Imm32(sizeof(ResumeFromException)), rsp);
    movq(rsp, rax);

    // Call the handler.
    asMasm().setupUnalignedABICall(rcx);
    asMasm().passABIArg(rax);
    asMasm().callWithABI(handler);

    Label entryFrame;
    Label catch_;
    Label finally;
    Label return_;
    Label bailout;

    loadPtr(Address(rsp, offsetof(ResumeFromException, kind)), rax);
    asMasm().branch32(Assembler::Equal, rax, Imm32(ResumeFromException::RESUME_ENTRY_FRAME), &entryFrame);
    asMasm().branch32(Assembler::Equal, rax, Imm32(ResumeFromException::RESUME_CATCH), &catch_);
    asMasm().branch32(Assembler::Equal, rax, Imm32(ResumeFromException::RESUME_FINALLY), &finally);
    asMasm().branch32(Assembler::Equal, rax, Imm32(ResumeFromException::RESUME_FORCED_RETURN), &return_);
    asMasm().branch32(Assembler::Equal, rax, Imm32(ResumeFromException::RESUME_BAILOUT), &bailout);

    breakpoint(); // Invalid kind.

    // No exception handler. Load the error value, load the new stack pointer
    // and return from the entry frame.
    bind(&entryFrame);
    moveValue(MagicValue(JS_ION_ERROR), JSReturnOperand);
    loadPtr(Address(rsp, offsetof(ResumeFromException, stackPointer)), rsp);
    ret();

    // If we found a catch handler, this must be a baseline frame. Restore state
    // and jump to the catch block.
    bind(&catch_);
    loadPtr(Address(rsp, offsetof(ResumeFromException, target)), rax);
    loadPtr(Address(rsp, offsetof(ResumeFromException, framePointer)), rbp);
    loadPtr(Address(rsp, offsetof(ResumeFromException, stackPointer)), rsp);
    jmp(Operand(rax));

    // If we found a finally block, this must be a baseline frame. Push
    // two values expected by JSOP_RETSUB: BooleanValue(true) and the
    // exception.
    bind(&finally);
    ValueOperand exception = ValueOperand(rcx);
    loadValue(Address(esp, offsetof(ResumeFromException, exception)), exception);

    loadPtr(Address(rsp, offsetof(ResumeFromException, target)), rax);
    loadPtr(Address(rsp, offsetof(ResumeFromException, framePointer)), rbp);
    loadPtr(Address(rsp, offsetof(ResumeFromException, stackPointer)), rsp);

    pushValue(BooleanValue(true));
    pushValue(exception);
    jmp(Operand(rax));

    // Only used in debug mode. Return BaselineFrame->returnValue() to the caller.
    bind(&return_);
    loadPtr(Address(rsp, offsetof(ResumeFromException, framePointer)), rbp);
    loadPtr(Address(rsp, offsetof(ResumeFromException, stackPointer)), rsp);
    loadValue(Address(rbp, BaselineFrame::reverseOffsetOfReturnValue()), JSReturnOperand);
    movq(rbp, rsp);
    pop(rbp);

    // If profiling is enabled, then update the lastProfilingFrame to refer to caller
    // frame before returning.
    {
        Label skipProfilingInstrumentation;
        AbsoluteAddress addressOfEnabled(GetJitContext()->runtime->spsProfiler().addressOfEnabled());
        asMasm().branch32(Assembler::Equal, addressOfEnabled, Imm32(0), &skipProfilingInstrumentation);
        profilerExitFrame();
        bind(&skipProfilingInstrumentation);
    }

    ret();

    // If we are bailing out to baseline to handle an exception, jump to
    // the bailout tail stub.
    bind(&bailout);
    loadPtr(Address(esp, offsetof(ResumeFromException, bailoutInfo)), r9);
    mov(ImmWord(BAILOUT_RETURN_OK), rax);
    jmp(Operand(rsp, offsetof(ResumeFromException, target)));
}

void
MacroAssemblerX64::profilerEnterFrame(Register framePtr, Register scratch)
{
    AbsoluteAddress activation(GetJitContext()->runtime->addressOfProfilingActivation());
    loadPtr(activation, scratch);
    storePtr(framePtr, Address(scratch, JitActivation::offsetOfLastProfilingFrame()));
    storePtr(ImmPtr(nullptr), Address(scratch, JitActivation::offsetOfLastProfilingCallSite()));
}

void
MacroAssemblerX64::profilerExitFrame()
{
    jmp(GetJitContext()->runtime->jitRuntime()->getProfilerExitFrameTail());
}

MacroAssembler&
MacroAssemblerX64::asMasm()
{
    return *static_cast<MacroAssembler*>(this);
}

const MacroAssembler&
MacroAssemblerX64::asMasm() const
{
    return *static_cast<const MacroAssembler*>(this);
}

void
MacroAssembler::subFromStackPtr(Imm32 imm32)
{
    if (imm32.value) {
        // On windows, we cannot skip very far down the stack without touching the
        // memory pages in-between.  This is a corner-case code for situations where the
        // Ion frame data for a piece of code is very large.  To handle this special case,
        // for frames over 1k in size we allocate memory on the stack incrementally, touching
        // it as we go.
        uint32_t amountLeft = imm32.value;
        while (amountLeft > 4096) {
            subq(Imm32(4096), StackPointer);
            store32(Imm32(0), Address(StackPointer, 0));
            amountLeft -= 4096;
        }
        subq(Imm32(amountLeft), StackPointer);
    }
}

//{{{ check_macroassembler_style
// ===============================================================
// ABI function calls.

void
MacroAssembler::setupUnalignedABICall(Register scratch)
{
    setupABICall();
    dynamicAlignment_ = true;

    movq(rsp, scratch);
    andq(Imm32(~(ABIStackAlignment - 1)), rsp);
    push(scratch);
}

void
MacroAssembler::callWithABIPre(uint32_t* stackAdjust, bool callFromWasm)
{
    MOZ_ASSERT(inCall_);
    uint32_t stackForCall = abiArgs_.stackBytesConsumedSoFar();

    if (dynamicAlignment_) {
        // sizeof(intptr_t) accounts for the saved stack pointer pushed by
        // setupUnalignedABICall.
        stackForCall += ComputeByteAlignment(stackForCall + sizeof(intptr_t),
                                             ABIStackAlignment);
    } else {
        static_assert(sizeof(wasm::Frame) % ABIStackAlignment == 0,
                      "wasm::Frame should be part of the stack alignment.");
        stackForCall += ComputeByteAlignment(stackForCall + framePushed(),
                                             ABIStackAlignment);
    }

    *stackAdjust = stackForCall;
    reserveStack(stackForCall);

    // Position all arguments.
    {
        enoughMemory_ &= moveResolver_.resolve();
        if (!enoughMemory_)
            return;

        MoveEmitter emitter(*this);
        emitter.emit(moveResolver_);
        emitter.finish();
    }

    assertStackAlignment(ABIStackAlignment);
}

void
MacroAssembler::callWithABIPost(uint32_t stackAdjust, MoveOp::Type result)
{
    freeStack(stackAdjust);
    if (dynamicAlignment_)
        pop(rsp);

#ifdef DEBUG
    MOZ_ASSERT(inCall_);
    inCall_ = false;
#endif
}

static bool
IsIntArgReg(Register reg)
{
    for (uint32_t i = 0; i < NumIntArgRegs; i++) {
        if (IntArgRegs[i] == reg)
            return true;
    }

    return false;
}

void
MacroAssembler::callWithABINoProfiler(Register fun, MoveOp::Type result)
{
    if (IsIntArgReg(fun)) {
        // Callee register may be clobbered for an argument. Move the callee to
        // r10, a volatile, non-argument register.
        propagateOOM(moveResolver_.addMove(MoveOperand(fun), MoveOperand(r10),
                                           MoveOp::GENERAL));
        fun = r10;
    }

    MOZ_ASSERT(!IsIntArgReg(fun));

    uint32_t stackAdjust;
    callWithABIPre(&stackAdjust);
    call(fun);
    callWithABIPost(stackAdjust, result);
}

void
MacroAssembler::callWithABINoProfiler(const Address& fun, MoveOp::Type result)
{
    Address safeFun = fun;
    if (IsIntArgReg(safeFun.base)) {
        // Callee register may be clobbered for an argument. Move the callee to
        // r10, a volatile, non-argument register.
        propagateOOM(moveResolver_.addMove(MoveOperand(fun.base), MoveOperand(r10),
                                           MoveOp::GENERAL));
        safeFun.base = r10;
    }

    MOZ_ASSERT(!IsIntArgReg(safeFun.base));

    uint32_t stackAdjust;
    callWithABIPre(&stackAdjust);
    call(safeFun);
    callWithABIPost(stackAdjust, result);
}

// ===============================================================
// Branch functions

void
MacroAssembler::branchPtrInNurseryChunk(Condition cond, Register ptr, Register temp, Label* label)
{
    MOZ_ASSERT(cond == Assembler::Equal || cond == Assembler::NotEqual);

    ScratchRegisterScope scratch(*this);
    MOZ_ASSERT(ptr != temp);
    MOZ_ASSERT(ptr != scratch);

    movePtr(ptr, scratch);
    orPtr(Imm32(gc::ChunkMask), scratch);
    branch32(cond, Address(scratch, gc::ChunkLocationOffsetFromLastByte),
             Imm32(int32_t(gc::ChunkLocation::Nursery)), label);
}

void
MacroAssembler::branchValueIsNurseryObject(Condition cond, const Address& address, Register temp,
                                           Label* label)
{
    branchValueIsNurseryObjectImpl(cond, address, temp, label);
}

void
MacroAssembler::branchValueIsNurseryObject(Condition cond, ValueOperand value, Register temp,
                                           Label* label)
{
    branchValueIsNurseryObjectImpl(cond, value, temp, label);
}

template <typename T>
void
MacroAssembler::branchValueIsNurseryObjectImpl(Condition cond, const T& value, Register temp,
                                               Label* label)
{
    MOZ_ASSERT(cond == Assembler::Equal || cond == Assembler::NotEqual);
    MOZ_ASSERT(temp != InvalidReg);

    Label done;
    branchTestObject(Assembler::NotEqual, value, cond == Assembler::Equal ? &done : label);

    extractObject(value, temp);
    orPtr(Imm32(gc::ChunkMask), temp);
    branch32(cond, Address(temp, gc::ChunkLocationOffsetFromLastByte),
             Imm32(int32_t(gc::ChunkLocation::Nursery)), label);

    bind(&done);
}

void
MacroAssembler::branchTestValue(Condition cond, const ValueOperand& lhs,
                                const Value& rhs, Label* label)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ScratchRegisterScope scratch(*this);
    MOZ_ASSERT(lhs.valueReg() != scratch);
    moveValue(rhs, scratch);
    cmpPtr(lhs.valueReg(), scratch);
    j(cond, label);
}

// ========================================================================
// Memory access primitives.
template <typename T>
void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const T& dest, MIRType slotType)
{
    if (valueType == MIRType::Double) {
        storeDouble(value.reg().typedReg().fpu(), dest);
        return;
    }

    // For known integers and booleans, we can just store the unboxed value if
    // the slot has the same type.
    if ((valueType == MIRType::Int32 || valueType == MIRType::Boolean) && slotType == valueType) {
        if (value.constant()) {
            Value val = value.value();
            if (valueType == MIRType::Int32)
                store32(Imm32(val.toInt32()), dest);
            else
                store32(Imm32(val.toBoolean() ? 1 : 0), dest);
        } else {
            store32(value.reg().typedReg().gpr(), dest);
        }
        return;
    }

    if (value.constant())
        storeValue(value.value(), dest);
    else
        storeValue(ValueTypeFromMIRType(valueType), value.reg().typedReg().gpr(), dest);
}

template void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const Address& dest, MIRType slotType);
template void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const BaseIndex& dest, MIRType slotType);

// ========================================================================
// wasm support

void
MacroAssembler::wasmLoad(const wasm::MemoryAccessDesc& access, Operand srcAddr, AnyRegister out)
{
    memoryBarrier(access.barrierBefore());

    size_t loadOffset = size();
    switch (access.type()) {
      case Scalar::Int8:
        movsbl(srcAddr, out.gpr());
        break;
      case Scalar::Uint8:
        movzbl(srcAddr, out.gpr());
        break;
      case Scalar::Int16:
        movswl(srcAddr, out.gpr());
        break;
      case Scalar::Uint16:
        movzwl(srcAddr, out.gpr());
        break;
      case Scalar::Int32:
      case Scalar::Uint32:
        movl(srcAddr, out.gpr());
        break;
      case Scalar::Float32:
        loadFloat32(srcAddr, out.fpu());
        break;
      case Scalar::Float64:
        loadDouble(srcAddr, out.fpu());
        break;
      case Scalar::Float32x4:
        switch (access.numSimdElems()) {
          // In memory-to-register mode, movss zeroes out the high lanes.
          case 1: loadFloat32(srcAddr, out.fpu()); break;
          // See comment above, which also applies to movsd.
          case 2: loadDouble(srcAddr, out.fpu()); break;
          case 4: loadUnalignedSimd128Float(srcAddr, out.fpu()); break;
          default: MOZ_CRASH("unexpected size for partial load");
        }
        break;
      case Scalar::Int32x4:
        switch (access.numSimdElems()) {
          // In memory-to-register mode, movd zeroes out the high lanes.
          case 1: vmovd(srcAddr, out.fpu()); break;
          // See comment above, which also applies to movq.
          case 2: vmovq(srcAddr, out.fpu()); break;
          case 4: loadUnalignedSimd128Int(srcAddr, out.fpu()); break;
          default: MOZ_CRASH("unexpected size for partial load");
        }
        break;
      case Scalar::Int8x16:
        MOZ_ASSERT(access.numSimdElems() == 16, "unexpected partial load");
        loadUnalignedSimd128Int(srcAddr, out.fpu());
        break;
      case Scalar::Int16x8:
        MOZ_ASSERT(access.numSimdElems() == 8, "unexpected partial load");
        loadUnalignedSimd128Int(srcAddr, out.fpu());
        break;
      case Scalar::Int64:
        MOZ_CRASH("int64 loads must use load64");
      case Scalar::Uint8Clamped:
      case Scalar::MaxTypedArrayViewType:
        MOZ_CRASH("unexpected array type");
    }
    append(access, loadOffset, framePushed());

    memoryBarrier(access.barrierAfter());
}

void
MacroAssembler::wasmLoadI64(const wasm::MemoryAccessDesc& access, Operand srcAddr, Register64 out)
{
    MOZ_ASSERT(!access.isAtomic());
    MOZ_ASSERT(!access.isSimd());

    size_t loadOffset = size();
    switch (access.type()) {
      case Scalar::Int8:
        movsbq(srcAddr, out.reg);
        break;
      case Scalar::Uint8:
        movzbq(srcAddr, out.reg);
        break;
      case Scalar::Int16:
        movswq(srcAddr, out.reg);
        break;
      case Scalar::Uint16:
        movzwq(srcAddr, out.reg);
        break;
      case Scalar::Int32:
        movslq(srcAddr, out.reg);
        break;
      // Int32 to int64 moves zero-extend by default.
      case Scalar::Uint32:
        movl(srcAddr, out.reg);
        break;
      case Scalar::Int64:
        movq(srcAddr, out.reg);
        break;
      case Scalar::Float32:
      case Scalar::Float64:
      case Scalar::Float32x4:
      case Scalar::Int8x16:
      case Scalar::Int16x8:
      case Scalar::Int32x4:
        MOZ_CRASH("non-int64 loads should use load()");
      case Scalar::Uint8Clamped:
      case Scalar::MaxTypedArrayViewType:
        MOZ_CRASH("unexpected array type");
    }
    append(access, loadOffset, framePushed());
}

void
MacroAssembler::wasmStore(const wasm::MemoryAccessDesc& access, AnyRegister value, Operand dstAddr)
{
    memoryBarrier(access.barrierBefore());

    size_t storeOffset = size();
    switch (access.type()) {
      case Scalar::Int8:
      case Scalar::Uint8:
        movb(value.gpr(), dstAddr);
        break;
      case Scalar::Int16:
      case Scalar::Uint16:
        movw(value.gpr(), dstAddr);
        break;
      case Scalar::Int32:
      case Scalar::Uint32:
        movl(value.gpr(), dstAddr);
        break;
      case Scalar::Int64:
        movq(value.gpr(), dstAddr);
        break;
      case Scalar::Float32:
        storeUncanonicalizedFloat32(value.fpu(), dstAddr);
        break;
      case Scalar::Float64:
        storeUncanonicalizedDouble(value.fpu(), dstAddr);
        break;
      case Scalar::Float32x4:
        switch (access.numSimdElems()) {
          // In memory-to-register mode, movss zeroes out the high lanes.
          case 1: storeUncanonicalizedFloat32(value.fpu(), dstAddr); break;
          // See comment above, which also applies to movsd.
          case 2: storeUncanonicalizedDouble(value.fpu(), dstAddr); break;
          case 4: storeUnalignedSimd128Float(value.fpu(), dstAddr); break;
          default: MOZ_CRASH("unexpected size for partial load");
        }
        break;
      case Scalar::Int32x4:
        switch (access.numSimdElems()) {
          // In memory-to-register mode, movd zeroes out the high lanes.
          case 1: vmovd(value.fpu(), dstAddr); break;
          // See comment above, which also applies to movq.
          case 2: vmovq(value.fpu(), dstAddr); break;
          case 4: storeUnalignedSimd128Int(value.fpu(), dstAddr); break;
          default: MOZ_CRASH("unexpected size for partial load");
        }
        break;
      case Scalar::Int8x16:
        MOZ_ASSERT(access.numSimdElems() == 16, "unexpected partial store");
        storeUnalignedSimd128Int(value.fpu(), dstAddr);
        break;
      case Scalar::Int16x8:
        MOZ_ASSERT(access.numSimdElems() == 8, "unexpected partial store");
        storeUnalignedSimd128Int(value.fpu(), dstAddr);
        break;
      case Scalar::Uint8Clamped:
      case Scalar::MaxTypedArrayViewType:
        MOZ_CRASH("unexpected array type");
    }
    append(access, storeOffset, framePushed());

    memoryBarrier(access.barrierAfter());
}

void
MacroAssembler::wasmTruncateDoubleToUInt32(FloatRegister input, Register output, Label* oolEntry)
{
    vcvttsd2sq(input, output);

    // Check that the result is in the uint32_t range.
    ScratchRegisterScope scratch(*this);
    move32(Imm32(0xffffffff), scratch);
    cmpq(scratch, output);
    j(Assembler::Above, oolEntry);
}

void
MacroAssembler::wasmTruncateFloat32ToUInt32(FloatRegister input, Register output, Label* oolEntry)
{
    vcvttss2sq(input, output);

    // Check that the result is in the uint32_t range.
    ScratchRegisterScope scratch(*this);
    move32(Imm32(0xffffffff), scratch);
    cmpq(scratch, output);
    j(Assembler::Above, oolEntry);
}

//}}} check_macroassembler_style
