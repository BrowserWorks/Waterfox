/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_arm64_MacroAssembler_arm64_h
#define jit_arm64_MacroAssembler_arm64_h

#include "jit/arm64/Assembler-arm64.h"
#include "jit/arm64/vixl/Debugger-vixl.h"
#include "jit/arm64/vixl/MacroAssembler-vixl.h"

#include "jit/AtomicOp.h"
#include "jit/JitFrames.h"
#include "jit/MoveResolver.h"

namespace js {
namespace jit {

// Import VIXL operands directly into the jit namespace for shared code.
using vixl::Operand;
using vixl::MemOperand;

struct ImmShiftedTag : public ImmWord
{
    ImmShiftedTag(JSValueShiftedTag shtag)
      : ImmWord((uintptr_t)shtag)
    { }

    ImmShiftedTag(JSValueType type)
      : ImmWord(uintptr_t(JSValueShiftedTag(JSVAL_TYPE_TO_SHIFTED_TAG(type))))
    { }
};

struct ImmTag : public Imm32
{
    ImmTag(JSValueTag tag)
      : Imm32(tag)
    { }
};

class MacroAssemblerCompat : public vixl::MacroAssembler
{
  public:
    typedef vixl::Condition Condition;

  private:
    // Perform a downcast. Should be removed by Bug 996602.
    js::jit::MacroAssembler& asMasm();
    const js::jit::MacroAssembler& asMasm() const;

  public:
    // Restrict to only VIXL-internal functions.
    vixl::MacroAssembler& asVIXL();
    const MacroAssembler& asVIXL() const;

  protected:
    bool enoughMemory_;
    uint32_t framePushed_;

    MacroAssemblerCompat()
      : vixl::MacroAssembler(),
        enoughMemory_(true),
        framePushed_(0)
    { }

  protected:
    MoveResolver moveResolver_;

  public:
    bool oom() const {
        return Assembler::oom() || !enoughMemory_;
    }
    static MemOperand toMemOperand(Address& a) {
        return MemOperand(ARMRegister(a.base, 64), a.offset);
    }
    void doBaseIndex(const vixl::CPURegister& rt, const BaseIndex& addr, vixl::LoadStoreOp op) {
        const ARMRegister base = ARMRegister(addr.base, 64);
        const ARMRegister index = ARMRegister(addr.index, 64);
        const unsigned scale = addr.scale;

        if (!addr.offset && (!scale || scale == static_cast<unsigned>(CalcLSDataSize(op)))) {
            LoadStoreMacro(rt, MemOperand(base, index, vixl::LSL, scale), op);
            return;
        }

        vixl::UseScratchRegisterScope temps(this);
        ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(!scratch64.Is(rt));
        MOZ_ASSERT(!scratch64.Is(base));
        MOZ_ASSERT(!scratch64.Is(index));

        Add(scratch64, base, Operand(index, vixl::LSL, scale));
        LoadStoreMacro(rt, MemOperand(scratch64, addr.offset), op);
    }
    void Push(ARMRegister reg) {
        push(reg);
        adjustFrame(reg.size() / 8);
    }
    void Push(Register reg) {
        vixl::MacroAssembler::Push(ARMRegister(reg, 64));
        adjustFrame(8);
    }
    void Push(Imm32 imm) {
        push(imm);
        adjustFrame(8);
    }
    void Push(FloatRegister f) {
        push(ARMFPRegister(f, 64));
        adjustFrame(8);
    }
    void Push(ImmPtr imm) {
        push(imm);
        adjustFrame(sizeof(void*));
    }
    void push(FloatRegister f) {
        vixl::MacroAssembler::Push(ARMFPRegister(f, 64));
    }
    void push(ARMFPRegister f) {
        vixl::MacroAssembler::Push(f);
    }
    void push(Imm32 imm) {
        if (imm.value == 0) {
            vixl::MacroAssembler::Push(vixl::xzr);
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            move32(imm, scratch64.asUnsized());
            vixl::MacroAssembler::Push(scratch64);
        }
    }
    void push(ImmWord imm) {
        if (imm.value == 0) {
            vixl::MacroAssembler::Push(vixl::xzr);
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            Mov(scratch64, imm.value);
            vixl::MacroAssembler::Push(scratch64);
        }
    }
    void push(ImmPtr imm) {
        if (imm.value == nullptr) {
            vixl::MacroAssembler::Push(vixl::xzr);
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            movePtr(imm, scratch64.asUnsized());
            vixl::MacroAssembler::Push(scratch64);
        }
    }
    void push(ImmGCPtr imm) {
        if (imm.value == nullptr) {
            vixl::MacroAssembler::Push(vixl::xzr);
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            movePtr(imm, scratch64.asUnsized());
            vixl::MacroAssembler::Push(scratch64);
        }
    }
    void push(ARMRegister reg) {
        vixl::MacroAssembler::Push(reg);
    }
    void push(Address a) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(a.base != scratch64.asUnsized());
        loadPtr(a, scratch64.asUnsized());
        vixl::MacroAssembler::Push(scratch64);
    }

    // Push registers.
    void push(Register reg) {
        vixl::MacroAssembler::Push(ARMRegister(reg, 64));
    }
    void push(Register r0, Register r1) {
        vixl::MacroAssembler::Push(ARMRegister(r0, 64), ARMRegister(r1, 64));
    }
    void push(Register r0, Register r1, Register r2) {
        vixl::MacroAssembler::Push(ARMRegister(r0, 64), ARMRegister(r1, 64), ARMRegister(r2, 64));
    }
    void push(Register r0, Register r1, Register r2, Register r3) {
        vixl::MacroAssembler::Push(ARMRegister(r0, 64), ARMRegister(r1, 64),
                                   ARMRegister(r2, 64), ARMRegister(r3, 64));
    }
    void push(ARMFPRegister r0, ARMFPRegister r1, ARMFPRegister r2, ARMFPRegister r3) {
        vixl::MacroAssembler::Push(r0, r1, r2, r3);
    }

    // Pop registers.
    void pop(Register reg) {
        vixl::MacroAssembler::Pop(ARMRegister(reg, 64));
    }
    void pop(Register r0, Register r1) {
        vixl::MacroAssembler::Pop(ARMRegister(r0, 64), ARMRegister(r1, 64));
    }
    void pop(Register r0, Register r1, Register r2) {
        vixl::MacroAssembler::Pop(ARMRegister(r0, 64), ARMRegister(r1, 64), ARMRegister(r2, 64));
    }
    void pop(Register r0, Register r1, Register r2, Register r3) {
        vixl::MacroAssembler::Pop(ARMRegister(r0, 64), ARMRegister(r1, 64),
                                  ARMRegister(r2, 64), ARMRegister(r3, 64));
    }
    void pop(ARMFPRegister r0, ARMFPRegister r1, ARMFPRegister r2, ARMFPRegister r3) {
        vixl::MacroAssembler::Pop(r0, r1, r2, r3);
    }

    void pop(const ValueOperand& v) {
        pop(v.valueReg());
    }
    void pop(const FloatRegister& f) {
        vixl::MacroAssembler::Pop(ARMRegister(f.code(), 64));
    }

    void implicitPop(uint32_t args) {
        MOZ_ASSERT(args % sizeof(intptr_t) == 0);
        adjustFrame(-args);
    }
    void Pop(ARMRegister r) {
        vixl::MacroAssembler::Pop(r);
        adjustFrame(- r.size() / 8);
    }
    // FIXME: This is the same on every arch.
    // FIXME: If we can share framePushed_, we can share this.
    // FIXME: Or just make it at the highest level.
    CodeOffset PushWithPatch(ImmWord word) {
        framePushed_ += sizeof(word.value);
        return pushWithPatch(word);
    }
    CodeOffset PushWithPatch(ImmPtr ptr) {
        return PushWithPatch(ImmWord(uintptr_t(ptr.value)));
    }

    uint32_t framePushed() const {
        return framePushed_;
    }
    void adjustFrame(int32_t diff) {
        setFramePushed(framePushed_ + diff);
    }

    void setFramePushed(uint32_t framePushed) {
        framePushed_ = framePushed;
    }

    void freeStack(Register amount) {
        vixl::MacroAssembler::Drop(Operand(ARMRegister(amount, 64)));
    }

    // Update sp with the value of the current active stack pointer, if necessary.
    void syncStackPtr() {
        if (!GetStackPointer64().Is(vixl::sp))
            Mov(vixl::sp, GetStackPointer64());
    }
    void initStackPtr() {
        if (!GetStackPointer64().Is(vixl::sp))
            Mov(GetStackPointer64(), vixl::sp);
    }
    void storeValue(ValueOperand val, const Address& dest) {
        storePtr(val.valueReg(), dest);
    }

    template <typename T>
    void storeValue(JSValueType type, Register reg, const T& dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != reg);
        tagValue(type, reg, ValueOperand(scratch));
        storeValue(ValueOperand(scratch), dest);
    }
    template <typename T>
    void storeValue(const Value& val, const T& dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        moveValue(val, ValueOperand(scratch));
        storeValue(ValueOperand(scratch), dest);
    }
    void storeValue(ValueOperand val, BaseIndex dest) {
        storePtr(val.valueReg(), dest);
    }
    void storeValue(const Address& src, const Address& dest, Register temp) {
        loadPtr(src, temp);
        storePtr(temp, dest);
    }

    void loadValue(Address src, Register val) {
        Ldr(ARMRegister(val, 64), MemOperand(src));
    }
    void loadValue(Address src, ValueOperand val) {
        Ldr(ARMRegister(val.valueReg(), 64), MemOperand(src));
    }
    void loadValue(const BaseIndex& src, ValueOperand val) {
        doBaseIndex(ARMRegister(val.valueReg(), 64), src, vixl::LDR_x);
    }
    void tagValue(JSValueType type, Register payload, ValueOperand dest) {
        // This could be cleverer, but the first attempt had bugs.
        Orr(ARMRegister(dest.valueReg(), 64), ARMRegister(payload, 64), Operand(ImmShiftedTag(type).value));
    }
    void pushValue(ValueOperand val) {
        vixl::MacroAssembler::Push(ARMRegister(val.valueReg(), 64));
    }
    void popValue(ValueOperand val) {
        vixl::MacroAssembler::Pop(ARMRegister(val.valueReg(), 64));
    }
    void pushValue(const Value& val) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        if (val.isMarkable()) {
            BufferOffset load = movePatchablePtr(ImmPtr(val.bitsAsPunboxPointer()), scratch);
            writeDataRelocation(val, load);
            push(scratch);
        } else {
            moveValue(val, scratch);
            push(scratch);
        }
    }
    void pushValue(JSValueType type, Register reg) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != reg);
        tagValue(type, reg, ValueOperand(scratch));
        push(scratch);
    }
    void pushValue(const Address& addr) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != addr.base);
        loadValue(addr, scratch);
        push(scratch);
    }
    template <typename T>
    void storeUnboxedPayload(ValueOperand value, T address, size_t nbytes) {
        switch (nbytes) {
          case 8: {
            vixl::UseScratchRegisterScope temps(this);
            const Register scratch = temps.AcquireX().asUnsized();
            unboxNonDouble(value, scratch);
            storePtr(scratch, address);
            return;
          }
          case 4:
            store32(value.valueReg(), address);
            return;
          case 1:
            store8(value.valueReg(), address);
            return;
          default: MOZ_CRASH("Bad payload width");
        }
    }
    void moveValue(const Value& val, Register dest) {
        if (val.isMarkable()) {
            BufferOffset load = movePatchablePtr(ImmPtr(val.bitsAsPunboxPointer()), dest);
            writeDataRelocation(val, load);
        } else {
            movePtr(ImmWord(val.asRawBits()), dest);
        }
    }
    void moveValue(const Value& src, const ValueOperand& dest) {
        moveValue(src, dest.valueReg());
    }
    void moveValue(const ValueOperand& src, const ValueOperand& dest) {
        if (src.valueReg() != dest.valueReg())
            movePtr(src.valueReg(), dest.valueReg());
    }

    CodeOffset pushWithPatch(ImmWord imm) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        CodeOffset label = movWithPatch(imm, scratch);
        push(scratch);
        return label;
    }

    CodeOffset movWithPatch(ImmWord imm, Register dest) {
        BufferOffset off = immPool64(ARMRegister(dest, 64), imm.value);
        return CodeOffset(off.getOffset());
    }
    CodeOffset movWithPatch(ImmPtr imm, Register dest) {
        BufferOffset off = immPool64(ARMRegister(dest, 64), uint64_t(imm.value));
        return CodeOffset(off.getOffset());
    }

    void boxValue(JSValueType type, Register src, Register dest) {
        Orr(ARMRegister(dest, 64), ARMRegister(src, 64), Operand(ImmShiftedTag(type).value));
    }
    void splitTag(Register src, Register dest) {
        ubfx(ARMRegister(dest, 64), ARMRegister(src, 64), JSVAL_TAG_SHIFT, (64 - JSVAL_TAG_SHIFT));
    }
    Register extractTag(const Address& address, Register scratch) {
        loadPtr(address, scratch);
        splitTag(scratch, scratch);
        return scratch;
    }
    Register extractTag(const ValueOperand& value, Register scratch) {
        splitTag(value.valueReg(), scratch);
        return scratch;
    }
    Register extractObject(const Address& address, Register scratch) {
        loadPtr(address, scratch);
        unboxObject(scratch, scratch);
        return scratch;
    }
    Register extractObject(const ValueOperand& value, Register scratch) {
        unboxObject(value, scratch);
        return scratch;
    }
    Register extractInt32(const ValueOperand& value, Register scratch) {
        unboxInt32(value, scratch);
        return scratch;
    }
    Register extractBoolean(const ValueOperand& value, Register scratch) {
        unboxBoolean(value, scratch);
        return scratch;
    }

    inline void ensureDouble(const ValueOperand& source, FloatRegister dest, Label* failure);

    void emitSet(Condition cond, Register dest) {
        Cset(ARMRegister(dest, 64), cond);
    }

    void testNullSet(Condition cond, const ValueOperand& value, Register dest) {
        cond = testNull(cond, value);
        emitSet(cond, dest);
    }
    void testObjectSet(Condition cond, const ValueOperand& value, Register dest) {
        cond = testObject(cond, value);
        emitSet(cond, dest);
    }
    void testUndefinedSet(Condition cond, const ValueOperand& value, Register dest) {
        cond = testUndefined(cond, value);
        emitSet(cond, dest);
    }

    void convertBoolToInt32(Register source, Register dest) {
        Uxtb(ARMRegister(dest, 64), ARMRegister(source, 64));
    }

    void convertInt32ToDouble(Register src, FloatRegister dest) {
        Scvtf(ARMFPRegister(dest, 64), ARMRegister(src, 32)); // Uses FPCR rounding mode.
    }
    void convertInt32ToDouble(const Address& src, FloatRegister dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != src.base);
        load32(src, scratch);
        convertInt32ToDouble(scratch, dest);
    }
    void convertInt32ToDouble(const BaseIndex& src, FloatRegister dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != src.base);
        MOZ_ASSERT(scratch != src.index);
        load32(src, scratch);
        convertInt32ToDouble(scratch, dest);
    }

    void convertInt32ToFloat32(Register src, FloatRegister dest) {
        Scvtf(ARMFPRegister(dest, 32), ARMRegister(src, 32)); // Uses FPCR rounding mode.
    }
    void convertInt32ToFloat32(const Address& src, FloatRegister dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != src.base);
        load32(src, scratch);
        convertInt32ToFloat32(scratch, dest);
    }

    void convertUInt32ToDouble(Register src, FloatRegister dest) {
        Ucvtf(ARMFPRegister(dest, 64), ARMRegister(src, 32)); // Uses FPCR rounding mode.
    }
    void convertUInt32ToDouble(const Address& src, FloatRegister dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != src.base);
        load32(src, scratch);
        convertUInt32ToDouble(scratch, dest);
    }

    void convertUInt32ToFloat32(Register src, FloatRegister dest) {
        Ucvtf(ARMFPRegister(dest, 32), ARMRegister(src, 32)); // Uses FPCR rounding mode.
    }
    void convertUInt32ToFloat32(const Address& src, FloatRegister dest) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != src.base);
        load32(src, scratch);
        convertUInt32ToFloat32(scratch, dest);
    }

    void convertFloat32ToDouble(FloatRegister src, FloatRegister dest) {
        Fcvt(ARMFPRegister(dest, 64), ARMFPRegister(src, 32));
    }
    void convertDoubleToFloat32(FloatRegister src, FloatRegister dest) {
        Fcvt(ARMFPRegister(dest, 32), ARMFPRegister(src, 64));
    }

    using vixl::MacroAssembler::B;
    void B(wasm::TrapDesc) {
        MOZ_CRASH("NYI");
    }
    void B(wasm::TrapDesc, Condition cond) {
        MOZ_CRASH("NYI");
    }

    void convertDoubleToInt32(FloatRegister src, Register dest, Label* fail,
                              bool negativeZeroCheck = true)
    {
        vixl::UseScratchRegisterScope temps(this);
        const ARMFPRegister scratch64 = temps.AcquireD();

        ARMFPRegister fsrc(src, 64);
        ARMRegister dest32(dest, 32);
        ARMRegister dest64(dest, 64);

        MOZ_ASSERT(!scratch64.Is(fsrc));

        Fcvtzs(dest32, fsrc); // Convert, rounding toward zero.
        Scvtf(scratch64, dest32); // Convert back, using FPCR rounding mode.
        Fcmp(scratch64, fsrc);
        B(fail, Assembler::NotEqual);

        if (negativeZeroCheck) {
            Label nonzero;
            Cbnz(dest32, &nonzero);
            Fmov(dest64, fsrc);
            Cbnz(dest64, fail);
            bind(&nonzero);
        }
    }
    void convertFloat32ToInt32(FloatRegister src, Register dest, Label* fail,
                               bool negativeZeroCheck = true)
    {
        vixl::UseScratchRegisterScope temps(this);
        const ARMFPRegister scratch32 = temps.AcquireS();

        ARMFPRegister fsrc(src, 32);
        ARMRegister dest32(dest, 32);
        ARMRegister dest64(dest, 64);

        MOZ_ASSERT(!scratch32.Is(fsrc));

        Fcvtzs(dest64, fsrc); // Convert, rounding toward zero.
        Scvtf(scratch32, dest32); // Convert back, using FPCR rounding mode.
        Fcmp(scratch32, fsrc);
        B(fail, Assembler::NotEqual);

        if (negativeZeroCheck) {
            Label nonzero;
            Cbnz(dest32, &nonzero);
            Fmov(dest32, fsrc);
            Cbnz(dest32, fail);
            bind(&nonzero);
        }
        And(dest64, dest64, Operand(0xffffffff));
    }

    void floor(FloatRegister input, Register output, Label* bail) {
        Label handleZero;
        //Label handleNeg;
        Label fin;
        ARMFPRegister iDbl(input, 64);
        ARMRegister o64(output, 64);
        ARMRegister o32(output, 32);
        Fcmp(iDbl, 0.0);
        B(Assembler::Equal, &handleZero);
        //B(Assembler::Signed, &handleNeg);
        // NaN is always a bail condition, just bail directly.
        B(Assembler::Overflow, bail);
        Fcvtms(o64, iDbl);
        Cmp(o64, Operand(o64, vixl::SXTW));
        B(NotEqual, bail);
        Mov(o32, o32);
        B(&fin);

        bind(&handleZero);
        // Move the top word of the double into the output reg, if it is non-zero,
        // then the original value was -0.0.
        Fmov(o64, iDbl);
        Cbnz(o64, bail);
        bind(&fin);
    }

    void floorf(FloatRegister input, Register output, Label* bail) {
        Label handleZero;
        //Label handleNeg;
        Label fin;
        ARMFPRegister iFlt(input, 32);
        ARMRegister o64(output, 64);
        ARMRegister o32(output, 32);
        Fcmp(iFlt, 0.0);
        B(Assembler::Equal, &handleZero);
        //B(Assembler::Signed, &handleNeg);
        // NaN is always a bail condition, just bail directly.
        B(Assembler::Overflow, bail);
        Fcvtms(o64, iFlt);
        Cmp(o64, Operand(o64, vixl::SXTW));
        B(NotEqual, bail);
        Mov(o32, o32);
        B(&fin);

        bind(&handleZero);
        // Move the top word of the double into the output reg, if it is non-zero,
        // then the original value was -0.0.
        Fmov(o32, iFlt);
        Cbnz(o32, bail);
        bind(&fin);
    }

    void ceil(FloatRegister input, Register output, Label* bail) {
        Label handleZero;
        Label fin;
        ARMFPRegister iDbl(input, 64);
        ARMRegister o64(output, 64);
        ARMRegister o32(output, 32);
        Fcmp(iDbl, 0.0);
        B(Assembler::Overflow, bail);
        Fcvtps(o64, iDbl);
        Cmp(o64, Operand(o64, vixl::SXTW));
        B(NotEqual, bail);
        Cbz(o64, &handleZero);
        Mov(o32, o32);
        B(&fin);

        bind(&handleZero);
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch = temps.AcquireX();
        Fmov(scratch, iDbl);
        Cbnz(scratch, bail);
        bind(&fin);
    }

    void ceilf(FloatRegister input, Register output, Label* bail) {
        Label handleZero;
        Label fin;
        ARMFPRegister iFlt(input, 32);
        ARMRegister o64(output, 64);
        ARMRegister o32(output, 32);
        Fcmp(iFlt, 0.0);

        // NaN is always a bail condition, just bail directly.
        B(Assembler::Overflow, bail);
        Fcvtps(o64, iFlt);
        Cmp(o64, Operand(o64, vixl::SXTW));
        B(NotEqual, bail);
        Cbz(o64, &handleZero);
        Mov(o32, o32);
        B(&fin);

        bind(&handleZero);
        // Move the top word of the double into the output reg, if it is non-zero,
        // then the original value was -0.0.
        Fmov(o32, iFlt);
        Cbnz(o32, bail);
        bind(&fin);
    }

    void jump(Label* label) {
        B(label);
    }
    void jump(JitCode* code) {
        branch(code);
    }
    void jump(RepatchLabel* label) {
        MOZ_CRASH("jump (repatchlabel)");
    }
    void jump(Register reg) {
        Br(ARMRegister(reg, 64));
    }
    void jump(const Address& addr) {
        loadPtr(addr, ip0);
        Br(vixl::ip0);
    }
    void jump(wasm::TrapDesc target) {
        MOZ_CRASH("NYI");
    }

    void align(int alignment) {
        armbuffer_.align(alignment);
    }

    void haltingAlign(int alignment) {
        // TODO: Implement a proper halting align.
        // ARM doesn't have one either.
        armbuffer_.align(alignment);
    }
    void nopAlign(int alignment) {
        MOZ_CRASH("NYI");
    }

    void movePtr(Register src, Register dest) {
        Mov(ARMRegister(dest, 64), ARMRegister(src, 64));
    }
    void movePtr(ImmWord imm, Register dest) {
        Mov(ARMRegister(dest, 64), int64_t(imm.value));
    }
    void movePtr(ImmPtr imm, Register dest) {
        Mov(ARMRegister(dest, 64), int64_t(imm.value));
    }
    void movePtr(wasm::SymbolicAddress imm, Register dest) {
        BufferOffset off = movePatchablePtr(ImmWord(0xffffffffffffffffULL), dest);
        append(wasm::SymbolicAccess(CodeOffset(off.getOffset()), imm));
    }
    void movePtr(ImmGCPtr imm, Register dest) {
        BufferOffset load = movePatchablePtr(ImmPtr(imm.value), dest);
        writeDataRelocation(imm, load);
    }

    void mov(ImmWord imm, Register dest) {
        movePtr(imm, dest);
    }
    void mov(ImmPtr imm, Register dest) {
        movePtr(imm, dest);
    }
    void mov(wasm::SymbolicAddress imm, Register dest) {
        movePtr(imm, dest);
    }
    void mov(Register src, Register dest) {
        movePtr(src, dest);
    }

    void move32(Imm32 imm, Register dest) {
        Mov(ARMRegister(dest, 32), (int64_t)imm.value);
    }
    void move32(Register src, Register dest) {
        Mov(ARMRegister(dest, 32), ARMRegister(src, 32));
    }

    // Move a pointer using a literal pool, so that the pointer
    // may be easily patched or traced.
    // Returns the BufferOffset of the load instruction emitted.
    BufferOffset movePatchablePtr(ImmWord ptr, Register dest);
    BufferOffset movePatchablePtr(ImmPtr ptr, Register dest);

    void loadPtr(wasm::SymbolicAddress address, Register dest) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch = temps.AcquireX();
        movePtr(address, scratch.asUnsized());
        Ldr(ARMRegister(dest, 64), MemOperand(scratch));
    }
    void loadPtr(AbsoluteAddress address, Register dest) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch = temps.AcquireX();
        movePtr(ImmWord((uintptr_t)address.addr), scratch.asUnsized());
        Ldr(ARMRegister(dest, 64), MemOperand(scratch));
    }
    void loadPtr(const Address& address, Register dest) {
        Ldr(ARMRegister(dest, 64), MemOperand(address));
    }
    void loadPtr(const BaseIndex& src, Register dest) {
        Register base = src.base;
        uint32_t scale = Imm32::ShiftOf(src.scale).value;
        ARMRegister dest64(dest, 64);
        ARMRegister index64(src.index, 64);

        if (src.offset) {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch = temps.AcquireX();
            MOZ_ASSERT(!scratch.Is(ARMRegister(base, 64)));
            MOZ_ASSERT(!scratch.Is(dest64));
            MOZ_ASSERT(!scratch.Is(index64));

            Add(scratch, ARMRegister(base, 64), Operand(int64_t(src.offset)));
            Ldr(dest64, MemOperand(scratch, index64, vixl::LSL, scale));
            return;
        }

        Ldr(dest64, MemOperand(ARMRegister(base, 64), index64, vixl::LSL, scale));
    }
    void loadPrivate(const Address& src, Register dest);

    void store8(Register src, const Address& address) {
        Strb(ARMRegister(src, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store8(Imm32 imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        move32(imm, scratch32.asUnsized());
        Strb(scratch32, MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store8(Register src, const BaseIndex& address) {
        doBaseIndex(ARMRegister(src, 32), address, vixl::STRB_w);
    }
    void store8(Imm32 imm, const BaseIndex& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        MOZ_ASSERT(scratch32.asUnsized() != address.index);
        Mov(scratch32, Operand(imm.value));
        doBaseIndex(scratch32, address, vixl::STRB_w);
    }

    void store16(Register src, const Address& address) {
        Strh(ARMRegister(src, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store16(Imm32 imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        move32(imm, scratch32.asUnsized());
        Strh(scratch32, MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store16(Register src, const BaseIndex& address) {
        doBaseIndex(ARMRegister(src, 32), address, vixl::STRH_w);
    }
    void store16(Imm32 imm, const BaseIndex& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        MOZ_ASSERT(scratch32.asUnsized() != address.index);
        Mov(scratch32, Operand(imm.value));
        doBaseIndex(scratch32, address, vixl::STRH_w);
    }

    void storePtr(ImmWord imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != address.base);
        movePtr(imm, scratch);
        storePtr(scratch, address);
    }
    void storePtr(ImmPtr imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != address.base);
        Mov(scratch64, uint64_t(imm.value));
        Str(scratch64, MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void storePtr(ImmGCPtr imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != address.base);
        movePtr(imm, scratch);
        storePtr(scratch, address);
    }
    void storePtr(Register src, const Address& address) {
        Str(ARMRegister(src, 64), MemOperand(ARMRegister(address.base, 64), address.offset));
    }

    void storePtr(ImmWord imm, const BaseIndex& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != address.base);
        MOZ_ASSERT(scratch64.asUnsized() != address.index);
        Mov(scratch64, Operand(imm.value));
        doBaseIndex(scratch64, address, vixl::STR_x);
    }
    void storePtr(ImmGCPtr imm, const BaseIndex& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != address.base);
        MOZ_ASSERT(scratch != address.index);
        movePtr(imm, scratch);
        doBaseIndex(ARMRegister(scratch, 64), address, vixl::STR_x);
    }
    void storePtr(Register src, const BaseIndex& address) {
        doBaseIndex(ARMRegister(src, 64), address, vixl::STR_x);
    }

    void storePtr(Register src, AbsoluteAddress address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        Mov(scratch64, uint64_t(address.addr));
        Str(ARMRegister(src, 64), MemOperand(scratch64));
    }

    void store32(Register src, AbsoluteAddress address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        Mov(scratch64, uint64_t(address.addr));
        Str(ARMRegister(src, 32), MemOperand(scratch64));
    }
    void store32(Imm32 imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        Mov(scratch32, uint64_t(imm.value));
        Str(scratch32, MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store32(Register r, const Address& address) {
        Str(ARMRegister(r, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void store32(Imm32 imm, const BaseIndex& address) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        MOZ_ASSERT(scratch32.asUnsized() != address.index);
        Mov(scratch32, imm.value);
        doBaseIndex(scratch32, address, vixl::STR_w);
    }
    void store32(Register r, const BaseIndex& address) {
        doBaseIndex(ARMRegister(r, 32), address, vixl::STR_w);
    }

    void store32_NoSecondScratch(Imm32 imm, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        temps.Exclude(ARMRegister(ScratchReg2, 32)); // Disallow ScratchReg2.
        const ARMRegister scratch32 = temps.AcquireW();

        MOZ_ASSERT(scratch32.asUnsized() != address.base);
        Mov(scratch32, uint64_t(imm.value));
        Str(scratch32, MemOperand(ARMRegister(address.base, 64), address.offset));
    }

    void store64(Register64 src, Address address) {
        storePtr(src.reg, address);
    }

    // SIMD.
    void loadInt32x1(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadInt32x1(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadInt32x2(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadInt32x2(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadInt32x3(const Address& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadInt32x3(const BaseIndex& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeInt32x1(FloatRegister src, const Address& dest) { MOZ_CRASH("NYI"); }
    void storeInt32x1(FloatRegister src, const BaseIndex& dest) { MOZ_CRASH("NYI"); }
    void storeInt32x2(FloatRegister src, const Address& dest) { MOZ_CRASH("NYI"); }
    void storeInt32x2(FloatRegister src, const BaseIndex& dest) { MOZ_CRASH("NYI"); }
    void storeInt32x3(FloatRegister src, const Address& dest) { MOZ_CRASH("NYI"); }
    void storeInt32x3(FloatRegister src, const BaseIndex& dest) { MOZ_CRASH("NYI"); }
    void loadAlignedSimd128Int(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadAlignedSimd128Int(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeAlignedSimd128Int(FloatRegister src, const Address& addr) { MOZ_CRASH("NYI"); }
    void storeAlignedSimd128Int(FloatRegister src, const BaseIndex& addr) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Int(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Int(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Int(FloatRegister dest, const Address& addr) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Int(FloatRegister dest, const BaseIndex& addr) { MOZ_CRASH("NYI"); }

    void loadFloat32x3(const Address& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadFloat32x3(const BaseIndex& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadAlignedSimd128Float(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadAlignedSimd128Float(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeAlignedSimd128Float(FloatRegister src, const Address& addr) { MOZ_CRASH("NYI"); }
    void storeAlignedSimd128Float(FloatRegister src, const BaseIndex& addr) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Float(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Float(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Float(FloatRegister dest, const Address& addr) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Float(FloatRegister dest, const BaseIndex& addr) { MOZ_CRASH("NYI"); }

    // StackPointer manipulation.
    template <typename T> void addToStackPtr(T t);
    template <typename T> void addStackPtrTo(T t);

    template <typename T> inline void subFromStackPtr(T t);
    template <typename T> inline void subStackPtrFrom(T t);

    template <typename T> void andToStackPtr(T t);
    template <typename T> void andStackPtrTo(T t);

    template <typename T>
    void moveToStackPtr(T t) { movePtr(t, getStackPointer()); syncStackPtr(); }
    template <typename T>
    void moveStackPtrTo(T t) { movePtr(getStackPointer(), t); }

    template <typename T>
    void loadStackPtr(T t) { loadPtr(t, getStackPointer()); syncStackPtr(); }
    template <typename T>
    void storeStackPtr(T t) { storePtr(getStackPointer(), t); }

    // StackPointer testing functions.
    template <typename T>
    inline void branchTestStackPtr(Condition cond, T t, Label* label);
    template <typename T>
    void branchStackPtr(Condition cond, T rhs, Label* label);
    template <typename T>
    void branchStackPtrRhs(Condition cond, T lhs, Label* label);

    void testPtr(Register lhs, Register rhs) {
        Tst(ARMRegister(lhs, 64), Operand(ARMRegister(rhs, 64)));
    }
    void test32(Register lhs, Register rhs) {
        Tst(ARMRegister(lhs, 32), Operand(ARMRegister(rhs, 32)));
    }
    void test32(const Address& addr, Imm32 imm) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != addr.base);
        load32(addr, scratch32.asUnsized());
        Tst(scratch32, Operand(imm.value));
    }
    void test32(Register lhs, Imm32 rhs) {
        Tst(ARMRegister(lhs, 32), Operand(rhs.value));
    }
    void cmp32(Register lhs, Imm32 rhs) {
        Cmp(ARMRegister(lhs, 32), Operand(rhs.value));
    }
    void cmp32(Register a, Register b) {
        Cmp(ARMRegister(a, 32), Operand(ARMRegister(b, 32)));
    }
    void cmp32(const Address& lhs, Imm32 rhs) {
        cmp32(Operand(lhs.base, lhs.offset), rhs);
    }
    void cmp32(const Address& lhs, Register rhs) {
        cmp32(Operand(lhs.base, lhs.offset), rhs);
    }
    void cmp32(const Operand& lhs, Imm32 rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        Mov(scratch32, lhs);
        Cmp(scratch32, Operand(rhs.value));
    }
    void cmp32(const Operand& lhs, Register rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        Mov(scratch32, lhs);
        Cmp(scratch32, Operand(ARMRegister(rhs, 32)));
    }

    void cmpPtr(Register lhs, Imm32 rhs) {
        Cmp(ARMRegister(lhs, 64), Operand(rhs.value));
    }
    void cmpPtr(Register lhs, ImmWord rhs) {
        Cmp(ARMRegister(lhs, 64), Operand(rhs.value));
    }
    void cmpPtr(Register lhs, ImmPtr rhs) {
        Cmp(ARMRegister(lhs, 64), Operand(uint64_t(rhs.value)));
    }
    void cmpPtr(Register lhs, Register rhs) {
        Cmp(ARMRegister(lhs, 64), ARMRegister(rhs, 64));
    }
    void cmpPtr(Register lhs, ImmGCPtr rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != lhs);
        movePtr(rhs, scratch);
        cmpPtr(lhs, scratch);
    }

    void cmpPtr(const Address& lhs, Register rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != lhs.base);
        MOZ_ASSERT(scratch64.asUnsized() != rhs);
        Ldr(scratch64, MemOperand(ARMRegister(lhs.base, 64), lhs.offset));
        Cmp(scratch64, Operand(ARMRegister(rhs, 64)));
    }
    void cmpPtr(const Address& lhs, ImmWord rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != lhs.base);
        Ldr(scratch64, MemOperand(ARMRegister(lhs.base, 64), lhs.offset));
        Cmp(scratch64, Operand(rhs.value));
    }
    void cmpPtr(const Address& lhs, ImmPtr rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != lhs.base);
        Ldr(scratch64, MemOperand(ARMRegister(lhs.base, 64), lhs.offset));
        Cmp(scratch64, Operand(uint64_t(rhs.value)));
    }
    void cmpPtr(const Address& lhs, ImmGCPtr rhs) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != lhs.base);
        loadPtr(lhs, scratch);
        cmpPtr(scratch, rhs);
    }

    void loadDouble(const Address& src, FloatRegister dest) {
        Ldr(ARMFPRegister(dest, 64), MemOperand(src));
    }
    void loadDouble(const BaseIndex& src, FloatRegister dest) {
        ARMRegister base(src.base, 64);
        ARMRegister index(src.index, 64);

        if (src.offset == 0) {
            Ldr(ARMFPRegister(dest, 64), MemOperand(base, index, vixl::LSL, unsigned(src.scale)));
            return;
        }

        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != src.base);
        MOZ_ASSERT(scratch64.asUnsized() != src.index);

        Add(scratch64, base, Operand(index, vixl::LSL, unsigned(src.scale)));
        Ldr(ARMFPRegister(dest, 64), MemOperand(scratch64, src.offset));
    }
    void loadFloatAsDouble(const Address& addr, FloatRegister dest) {
        Ldr(ARMFPRegister(dest, 32), MemOperand(ARMRegister(addr.base,64), addr.offset));
        fcvt(ARMFPRegister(dest, 64), ARMFPRegister(dest, 32));
    }
    void loadFloatAsDouble(const BaseIndex& src, FloatRegister dest) {
        ARMRegister base(src.base, 64);
        ARMRegister index(src.index, 64);
        if (src.offset == 0) {
            Ldr(ARMFPRegister(dest, 32), MemOperand(base, index, vixl::LSL, unsigned(src.scale)));
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            MOZ_ASSERT(scratch64.asUnsized() != src.base);
            MOZ_ASSERT(scratch64.asUnsized() != src.index);

            Add(scratch64, base, Operand(index, vixl::LSL, unsigned(src.scale)));
            Ldr(ARMFPRegister(dest, 32), MemOperand(scratch64, src.offset));
        }
        fcvt(ARMFPRegister(dest, 64), ARMFPRegister(dest, 32));
    }

    void loadFloat32(const Address& addr, FloatRegister dest) {
        Ldr(ARMFPRegister(dest, 32), MemOperand(ARMRegister(addr.base,64), addr.offset));
    }
    void loadFloat32(const BaseIndex& src, FloatRegister dest) {
        ARMRegister base(src.base, 64);
        ARMRegister index(src.index, 64);
        if (src.offset == 0) {
            Ldr(ARMFPRegister(dest, 32), MemOperand(base, index, vixl::LSL, unsigned(src.scale)));
        } else {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            MOZ_ASSERT(scratch64.asUnsized() != src.base);
            MOZ_ASSERT(scratch64.asUnsized() != src.index);

            Add(scratch64, base, Operand(index, vixl::LSL, unsigned(src.scale)));
            Ldr(ARMFPRegister(dest, 32), MemOperand(scratch64, src.offset));
        }
    }

    void moveDouble(FloatRegister src, FloatRegister dest) {
        fmov(ARMFPRegister(dest, 64), ARMFPRegister(src, 64));
    }
    void zeroDouble(FloatRegister reg) {
        fmov(ARMFPRegister(reg, 64), vixl::xzr);
    }
    void zeroFloat32(FloatRegister reg) {
        fmov(ARMFPRegister(reg, 32), vixl::wzr);
    }

    void moveFloat32(FloatRegister src, FloatRegister dest) {
        fmov(ARMFPRegister(dest, 32), ARMFPRegister(src, 32));
    }
    void moveFloatAsDouble(Register src, FloatRegister dest) {
        MOZ_CRASH("moveFloatAsDouble");
    }

    void splitTag(const ValueOperand& operand, Register dest) {
        splitTag(operand.valueReg(), dest);
    }
    void splitTag(const Address& operand, Register dest) {
        loadPtr(operand, dest);
        splitTag(dest, dest);
    }
    void splitTag(const BaseIndex& operand, Register dest) {
        loadPtr(operand, dest);
        splitTag(dest, dest);
    }

    // Extracts the tag of a value and places it in ScratchReg.
    Register splitTagForTest(const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != value.valueReg());
        Lsr(scratch64, ARMRegister(value.valueReg(), 64), JSVAL_TAG_SHIFT);
        return scratch64.asUnsized(); // FIXME: Surely we can make a better interface.
    }
    void cmpTag(const ValueOperand& operand, ImmTag tag) {
        MOZ_CRASH("cmpTag");
    }

    void load32(const Address& address, Register dest) {
        Ldr(ARMRegister(dest, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void load32(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 32), src, vixl::LDR_w);
    }
    void load32(AbsoluteAddress address, Register dest) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        movePtr(ImmWord((uintptr_t)address.addr), scratch64.asUnsized());
        ldr(ARMRegister(dest, 32), MemOperand(scratch64));
    }
    void load64(const Address& address, Register64 dest) {
        loadPtr(address, dest.reg);
    }

    void load8SignExtend(const Address& address, Register dest) {
        Ldrsb(ARMRegister(dest, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void load8SignExtend(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 32), src, vixl::LDRSB_w);
    }

    void load8ZeroExtend(const Address& address, Register dest) {
        Ldrb(ARMRegister(dest, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void load8ZeroExtend(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 32), src, vixl::LDRB_w);
    }

    void load16SignExtend(const Address& address, Register dest) {
        Ldrsh(ARMRegister(dest, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void load16SignExtend(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 32), src, vixl::LDRSH_w);
    }

    void load16ZeroExtend(const Address& address, Register dest) {
        Ldrh(ARMRegister(dest, 32), MemOperand(ARMRegister(address.base, 64), address.offset));
    }
    void load16ZeroExtend(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 32), src, vixl::LDRH_w);
    }

    void adds32(Register src, Register dest) {
        Adds(ARMRegister(dest, 32), ARMRegister(dest, 32), Operand(ARMRegister(src, 32)));
    }
    void adds32(Imm32 imm, Register dest) {
        Adds(ARMRegister(dest, 32), ARMRegister(dest, 32), Operand(imm.value));
    }
    void adds32(Imm32 imm, const Address& dest) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != dest.base);

        Ldr(scratch32, MemOperand(ARMRegister(dest.base, 64), dest.offset));
        Adds(scratch32, scratch32, Operand(imm.value));
        Str(scratch32, MemOperand(ARMRegister(dest.base, 64), dest.offset));
    }

    void subs32(Imm32 imm, Register dest) {
        Subs(ARMRegister(dest, 32), ARMRegister(dest, 32), Operand(imm.value));
    }
    void subs32(Register src, Register dest) {
        Subs(ARMRegister(dest, 32), ARMRegister(dest, 32), Operand(ARMRegister(src, 32)));
    }

    void ret() {
        pop(lr);
        abiret();
    }

    void retn(Imm32 n) {
        // ip0 <- [sp]; sp += n; ret ip0
        Ldr(vixl::ip0, MemOperand(GetStackPointer64(), ptrdiff_t(n.value), vixl::PostIndex));
        syncStackPtr(); // SP is always used to transmit the stack between calls.
        Ret(vixl::ip0);
    }

    void j(Condition cond, Label* dest) {
        B(dest, cond);
    }

    void branch(Condition cond, Label* label) {
        B(label, cond);
    }
    void branch(JitCode* target) {
        syncStackPtr();
        BufferOffset loc = b(-1); // The jump target will be patched by executableCopy().
        addPendingJump(loc, ImmPtr(target->raw()), Relocation::JITCODE);
    }

    CodeOffsetJump jumpWithPatch(RepatchLabel* label, Condition cond = Always,
                                 Label* documentation = nullptr)
    {
        ARMBuffer::PoolEntry pe;
        BufferOffset load_bo;
        BufferOffset branch_bo;

        // Does not overwrite condition codes from the caller.
        {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            load_bo = immPool64(scratch64, (uint64_t)label, &pe);
        }

        MOZ_ASSERT(!label->bound());
        if (cond != Always) {
            Label notTaken;
            B(&notTaken, Assembler::InvertCondition(cond));
            branch_bo = b(-1);
            bind(&notTaken);
        } else {
            nop();
            branch_bo = b(-1);
        }
        label->use(branch_bo.getOffset());
        return CodeOffsetJump(load_bo.getOffset(), pe.index());
    }
    CodeOffsetJump backedgeJump(RepatchLabel* label, Label* documentation = nullptr) {
        return jumpWithPatch(label, Always, documentation);
    }

    void compareDouble(DoubleCondition cond, FloatRegister lhs, FloatRegister rhs) {
        Fcmp(ARMFPRegister(lhs, 64), ARMFPRegister(rhs, 64));
    }

    void compareFloat(DoubleCondition cond, FloatRegister lhs, FloatRegister rhs) {
        Fcmp(ARMFPRegister(lhs, 32), ARMFPRegister(rhs, 32));
    }

    void branchNegativeZero(FloatRegister reg, Register scratch, Label* label) {
        MOZ_CRASH("branchNegativeZero");
    }
    void branchNegativeZeroFloat32(FloatRegister reg, Register scratch, Label* label) {
        MOZ_CRASH("branchNegativeZeroFloat32");
    }

    void boxDouble(FloatRegister src, const ValueOperand& dest) {
        Fmov(ARMRegister(dest.valueReg(), 64), ARMFPRegister(src, 64));
    }
    void boxNonDouble(JSValueType type, Register src, const ValueOperand& dest) {
        boxValue(type, src, dest.valueReg());
    }

    // Note that the |dest| register here may be ScratchReg, so we shouldn't use it.
    void unboxInt32(const ValueOperand& src, Register dest) {
        move32(src.valueReg(), dest);
    }
    void unboxInt32(const Address& src, Register dest) {
        load32(src, dest);
    }
    void unboxDouble(const Address& src, FloatRegister dest) {
        loadDouble(src, dest);
    }
    void unboxDouble(const ValueOperand& src, FloatRegister dest) {
        Fmov(ARMFPRegister(dest, 64), ARMRegister(src.valueReg(), 64));
    }

    void unboxArgObjMagic(const ValueOperand& src, Register dest) {
        MOZ_CRASH("unboxArgObjMagic");
    }
    void unboxArgObjMagic(const Address& src, Register dest) {
        MOZ_CRASH("unboxArgObjMagic");
    }

    void unboxBoolean(const ValueOperand& src, Register dest) {
        move32(src.valueReg(), dest);
    }
    void unboxBoolean(const Address& src, Register dest) {
        load32(src, dest);
    }

    void unboxMagic(const ValueOperand& src, Register dest) {
        move32(src.valueReg(), dest);
    }
    // Unbox any non-double value into dest. Prefer unboxInt32 or unboxBoolean
    // instead if the source type is known.
    void unboxNonDouble(const ValueOperand& src, Register dest) {
        unboxNonDouble(src.valueReg(), dest);
    }
    void unboxNonDouble(Address src, Register dest) {
        loadPtr(src, dest);
        unboxNonDouble(dest, dest);
    }

    void unboxNonDouble(Register src, Register dest) {
        And(ARMRegister(dest, 64), ARMRegister(src, 64), Operand((1ULL << JSVAL_TAG_SHIFT) - 1ULL));
    }

    void unboxPrivate(const ValueOperand& src, Register dest) {
        ubfx(ARMRegister(dest, 64), ARMRegister(src.valueReg(), 64), 1, JSVAL_TAG_SHIFT - 1);
    }

    void notBoolean(const ValueOperand& val) {
        ARMRegister r(val.valueReg(), 64);
        eor(r, r, Operand(1));
    }
    void unboxObject(const ValueOperand& src, Register dest) {
        unboxNonDouble(src.valueReg(), dest);
    }
    void unboxObject(Register src, Register dest) {
        unboxNonDouble(src, dest);
    }
    void unboxObject(const Address& src, Register dest) {
        loadPtr(src, dest);
        unboxNonDouble(dest, dest);
    }
    void unboxObject(const BaseIndex& src, Register dest) {
        doBaseIndex(ARMRegister(dest, 64), src, vixl::LDR_x);
        unboxNonDouble(dest, dest);
    }

    inline void unboxValue(const ValueOperand& src, AnyRegister dest);

    void unboxString(const ValueOperand& operand, Register dest) {
        unboxNonDouble(operand, dest);
    }
    void unboxString(const Address& src, Register dest) {
        unboxNonDouble(src, dest);
    }
    void unboxSymbol(const ValueOperand& operand, Register dest) {
        unboxNonDouble(operand, dest);
    }
    void unboxSymbol(const Address& src, Register dest) {
        unboxNonDouble(src, dest);
    }
    // These two functions use the low 32-bits of the full value register.
    void boolValueToDouble(const ValueOperand& operand, FloatRegister dest) {
        convertInt32ToDouble(operand.valueReg(), dest);
    }
    void int32ValueToDouble(const ValueOperand& operand, FloatRegister dest) {
        convertInt32ToDouble(operand.valueReg(), dest);
    }

    void boolValueToFloat32(const ValueOperand& operand, FloatRegister dest) {
        convertInt32ToFloat32(operand.valueReg(), dest);
    }
    void int32ValueToFloat32(const ValueOperand& operand, FloatRegister dest) {
        convertInt32ToFloat32(operand.valueReg(), dest);
    }

    void loadConstantDouble(wasm::RawF64 d, FloatRegister dest) {
        loadConstantDouble(d.fp(), dest);
    }
    void loadConstantFloat32(wasm::RawF32 f, FloatRegister dest) {
        loadConstantFloat32(f.fp(), dest);
    }
    void loadConstantDouble(double d, FloatRegister dest) {
        Fmov(ARMFPRegister(dest, 64), d);
    }
    void loadConstantFloat32(float f, FloatRegister dest) {
        Fmov(ARMFPRegister(dest, 32), f);
    }

    // Register-based tests.
    Condition testUndefined(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_UNDEFINED));
        return cond;
    }
    Condition testInt32(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_INT32));
        return cond;
    }
    Condition testBoolean(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_BOOLEAN));
        return cond;
    }
    Condition testNull(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_NULL));
        return cond;
    }
    Condition testString(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_STRING));
        return cond;
    }
    Condition testSymbol(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_SYMBOL));
        return cond;
    }
    Condition testObject(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_OBJECT));
        return cond;
    }
    Condition testDouble(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, Imm32(JSVAL_TAG_MAX_DOUBLE));
        return (cond == Equal) ? BelowOrEqual : Above;
    }
    Condition testNumber(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, Imm32(JSVAL_UPPER_INCL_TAG_OF_NUMBER_SET));
        return (cond == Equal) ? BelowOrEqual : Above;
    }
    Condition testGCThing(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, Imm32(JSVAL_LOWER_INCL_TAG_OF_GCTHING_SET));
        return (cond == Equal) ? AboveOrEqual : Below;
    }
    Condition testMagic(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, ImmTag(JSVAL_TAG_MAGIC));
        return cond;
    }
    Condition testPrimitive(Condition cond, Register tag) {
        MOZ_ASSERT(cond == Equal || cond == NotEqual);
        cmp32(tag, Imm32(JSVAL_UPPER_EXCL_TAG_OF_PRIMITIVE_SET));
        return (cond == Equal) ? Below : AboveOrEqual;
    }
    Condition testError(Condition cond, Register tag) {
        return testMagic(cond, tag);
    }

    // ValueOperand-based tests.
    Condition testInt32(Condition cond, const ValueOperand& value) {
        // The incoming ValueOperand may use scratch registers.
        vixl::UseScratchRegisterScope temps(this);

        if (value.valueReg() == ScratchReg2) {
            MOZ_ASSERT(temps.IsAvailable(ScratchReg64));
            MOZ_ASSERT(!temps.IsAvailable(ScratchReg2_64));
            temps.Exclude(ScratchReg64);

            if (cond != Equal && cond != NotEqual)
                MOZ_CRASH("NYI: non-equality comparisons");

            // In the event that the tag is not encodable in a single cmp / teq instruction,
            // perform the xor that teq would use, this will leave the tag bits being
            // zero, or non-zero, which can be tested with either and or shift.
            unsigned int n, imm_r, imm_s;
            uint64_t immediate = uint64_t(ImmTag(JSVAL_TAG_INT32).value) << JSVAL_TAG_SHIFT;
            if (IsImmLogical(immediate, 64, &n, &imm_s, &imm_r)) {
                Eor(ScratchReg64, ScratchReg2_64, Operand(immediate));
            } else {
                Mov(ScratchReg64, immediate);
                Eor(ScratchReg64, ScratchReg2_64, ScratchReg64);
            }
            Tst(ScratchReg64, Operand((unsigned long long)(-1ll) << JSVAL_TAG_SHIFT));
            return cond;
        }

        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(scratch != value.valueReg());

        splitTag(value, scratch);
        return testInt32(cond, scratch);
    }
    Condition testBoolean(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testBoolean(cond, scratch);
    }
    Condition testDouble(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testDouble(cond, scratch);
    }
    Condition testNull(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testNull(cond, scratch);
    }
    Condition testUndefined(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testUndefined(cond, scratch);
    }
    Condition testString(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testString(cond, scratch);
    }
    Condition testSymbol(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testSymbol(cond, scratch);
    }
    Condition testObject(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testObject(cond, scratch);
    }
    Condition testNumber(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testNumber(cond, scratch);
    }
    Condition testPrimitive(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testPrimitive(cond, scratch);
    }
    Condition testMagic(Condition cond, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(value.valueReg() != scratch);
        splitTag(value, scratch);
        return testMagic(cond, scratch);
    }
    Condition testError(Condition cond, const ValueOperand& value) {
        return testMagic(cond, value);
    }

    // Address-based tests.
    Condition testGCThing(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testGCThing(cond, scratch);
    }
    Condition testMagic(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testMagic(cond, scratch);
    }
    Condition testInt32(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testInt32(cond, scratch);
    }
    Condition testDouble(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testDouble(cond, scratch);
    }
    Condition testBoolean(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testBoolean(cond, scratch);
    }
    Condition testNull(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testNull(cond, scratch);
    }
    Condition testUndefined(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testUndefined(cond, scratch);
    }
    Condition testString(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testString(cond, scratch);
    }
    Condition testSymbol(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testSymbol(cond, scratch);
    }
    Condition testObject(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testObject(cond, scratch);
    }
    Condition testNumber(Condition cond, const Address& address) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(address.base != scratch);
        splitTag(address, scratch);
        return testNumber(cond, scratch);
    }

    // BaseIndex-based tests.
    Condition testUndefined(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testUndefined(cond, scratch);
    }
    Condition testNull(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testNull(cond, scratch);
    }
    Condition testBoolean(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testBoolean(cond, scratch);
    }
    Condition testString(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testString(cond, scratch);
    }
    Condition testSymbol(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testSymbol(cond, scratch);
    }
    Condition testInt32(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testInt32(cond, scratch);
    }
    Condition testObject(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testObject(cond, scratch);
    }
    Condition testDouble(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testDouble(cond, scratch);
    }
    Condition testMagic(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testMagic(cond, scratch);
    }
    Condition testGCThing(Condition cond, const BaseIndex& src) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        MOZ_ASSERT(src.base != scratch);
        MOZ_ASSERT(src.index != scratch);
        splitTag(src, scratch);
        return testGCThing(cond, scratch);
    }

    Condition testInt32Truthy(bool truthy, const ValueOperand& operand) {
        ARMRegister payload32(operand.valueReg(), 32);
        Tst(payload32, payload32);
        return truthy ? NonZero : Zero;
    }

    Condition testBooleanTruthy(bool truthy, const ValueOperand& operand) {
        ARMRegister payload32(operand.valueReg(), 32);
        Tst(payload32, payload32);
        return truthy ? NonZero : Zero;
    }
    Condition testStringTruthy(bool truthy, const ValueOperand& value) {
        vixl::UseScratchRegisterScope temps(this);
        const Register scratch = temps.AcquireX().asUnsized();
        const ARMRegister scratch32(scratch, 32);
        const ARMRegister scratch64(scratch, 64);

        MOZ_ASSERT(value.valueReg() != scratch);

        unboxString(value, scratch);
        Ldr(scratch32, MemOperand(scratch64, JSString::offsetOfLength()));
        Cmp(scratch32, Operand(0));
        return truthy ? Condition::NonZero : Condition::Zero;
    }
    void int32OrDouble(Register src, ARMFPRegister dest) {
        Label isInt32;
        Label join;
        testInt32(Equal, ValueOperand(src));
        B(&isInt32, Equal);
        // is double, move teh bits as is
        Fmov(dest, ARMRegister(src, 64));
        B(&join);
        bind(&isInt32);
        // is int32, do a conversion while moving
        Scvtf(dest, ARMRegister(src, 32));
        bind(&join);
    }
    void loadUnboxedValue(Address address, MIRType type, AnyRegister dest) {
        if (dest.isFloat()) {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            MOZ_ASSERT(scratch64.asUnsized() != address.base);
            Ldr(scratch64, toMemOperand(address));
            int32OrDouble(scratch64.asUnsized(), ARMFPRegister(dest.fpu(), 64));
        } else if (type == MIRType::Int32 || type == MIRType::Boolean) {
            load32(address, dest.gpr());
        } else {
            loadPtr(address, dest.gpr());
            unboxNonDouble(dest.gpr(), dest.gpr());
        }
    }

    void loadUnboxedValue(BaseIndex address, MIRType type, AnyRegister dest) {
        if (dest.isFloat()) {
            vixl::UseScratchRegisterScope temps(this);
            const ARMRegister scratch64 = temps.AcquireX();
            MOZ_ASSERT(scratch64.asUnsized() != address.base);
            MOZ_ASSERT(scratch64.asUnsized() != address.index);
            doBaseIndex(scratch64, address, vixl::LDR_x);
            int32OrDouble(scratch64.asUnsized(), ARMFPRegister(dest.fpu(), 64));
        }  else if (type == MIRType::Int32 || type == MIRType::Boolean) {
            load32(address, dest.gpr());
        } else {
            loadPtr(address, dest.gpr());
            unboxNonDouble(dest.gpr(), dest.gpr());
        }
    }

    void loadInstructionPointerAfterCall(Register dest) {
        MOZ_CRASH("loadInstructionPointerAfterCall");
    }

    // Emit a B that can be toggled to a CMP. See ToggleToJmp(), ToggleToCmp().
    CodeOffset toggledJump(Label* label) {
        BufferOffset offset = b(label, Always);
        CodeOffset ret(offset.getOffset());
        return ret;
    }

    // load: offset to the load instruction obtained by movePatchablePtr().
    void writeDataRelocation(ImmGCPtr ptr, BufferOffset load) {
        if (ptr.value)
            dataRelocations_.writeUnsigned(load.getOffset());
    }
    void writeDataRelocation(const Value& val, BufferOffset load) {
        if (val.isMarkable()) {
            gc::Cell* cell = val.toMarkablePointer();
            if (cell && gc::IsInsideNursery(cell))
                embedsNurseryPointers_ = true;
            dataRelocations_.writeUnsigned(load.getOffset());
        }
    }

    void writePrebarrierOffset(CodeOffset label) {
        preBarriers_.writeUnsigned(label.offset());
    }

    void computeEffectiveAddress(const Address& address, Register dest) {
        Add(ARMRegister(dest, 64), ARMRegister(address.base, 64), Operand(address.offset));
    }
    void computeEffectiveAddress(const BaseIndex& address, Register dest) {
        ARMRegister dest64(dest, 64);
        ARMRegister base64(address.base, 64);
        ARMRegister index64(address.index, 64);

        Add(dest64, base64, Operand(index64, vixl::LSL, address.scale));
        if (address.offset)
            Add(dest64, dest64, Operand(address.offset));
    }

  public:
    CodeOffset labelForPatch() {
        return CodeOffset(nextOffset().getOffset());
    }

    void handleFailureWithHandlerTail(void* handler);

    void profilerEnterFrame(Register framePtr, Register scratch) {
        AbsoluteAddress activation(GetJitContext()->runtime->addressOfProfilingActivation());
        loadPtr(activation, scratch);
        storePtr(framePtr, Address(scratch, JitActivation::offsetOfLastProfilingFrame()));
        storePtr(ImmPtr(nullptr), Address(scratch, JitActivation::offsetOfLastProfilingCallSite()));
    }
    void profilerExitFrame() {
        branch(GetJitContext()->runtime->jitRuntime()->getProfilerExitFrameTail());
    }
    Address ToPayload(Address value) {
        return value;
    }
    Address ToType(Address value) {
        return value;
    }

  private:
    template <typename T>
    void compareExchange(int nbytes, bool signExtend, const T& address, Register oldval,
                         Register newval, Register output)
    {
        MOZ_CRASH("compareExchange");
    }

    template <typename T>
    void atomicFetchOp(int nbytes, bool signExtend, AtomicOp op, const Imm32& value,
                       const T& address, Register temp, Register output)
    {
        MOZ_CRASH("atomicFetchOp");
    }

    template <typename T>
    void atomicFetchOp(int nbytes, bool signExtend, AtomicOp op, const Register& value,
                       const T& address, Register temp, Register output)
    {
        MOZ_CRASH("atomicFetchOp");
    }

    template <typename T>
    void atomicEffectOp(int nbytes, AtomicOp op, const Register& value, const T& mem) {
        MOZ_CRASH("atomicEffectOp");
    }

    template <typename T>
    void atomicEffectOp(int nbytes, AtomicOp op, const Imm32& value, const T& mem) {
        MOZ_CRASH("atomicEffectOp");
    }

  public:
    // T in {Address,BaseIndex}
    // S in {Imm32,Register}

    template <typename T>
    void compareExchange8SignExtend(const T& mem, Register oldval, Register newval, Register output)
    {
        compareExchange(1, true, mem, oldval, newval, output);
    }
    template <typename T>
    void compareExchange8ZeroExtend(const T& mem, Register oldval, Register newval, Register output)
    {
        compareExchange(1, false, mem, oldval, newval, output);
    }
    template <typename T>
    void compareExchange16SignExtend(const T& mem, Register oldval, Register newval, Register output)
    {
        compareExchange(2, true, mem, oldval, newval, output);
    }
    template <typename T>
    void compareExchange16ZeroExtend(const T& mem, Register oldval, Register newval, Register output)
    {
        compareExchange(2, false, mem, oldval, newval, output);
    }
    template <typename T>
    void compareExchange32(const T& mem, Register oldval, Register newval, Register output)  {
        compareExchange(4, false, mem, oldval, newval, output);
    }
    template <typename T>
    void atomicExchange32(const T& mem, Register value, Register output) {
        MOZ_CRASH("atomicExchang32");
    }

    template <typename T>
    void atomicExchange8ZeroExtend(const T& mem, Register value, Register output) {
        MOZ_CRASH("atomicExchange8ZeroExtend");
    }
    template <typename T>
    void atomicExchange8SignExtend(const T& mem, Register value, Register output) {
        MOZ_CRASH("atomicExchange8SignExtend");
    }

    template <typename T, typename S>
    void atomicFetchAdd8SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, true, AtomicFetchAddOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAdd8ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, false, AtomicFetchAddOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAdd16SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, true, AtomicFetchAddOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAdd16ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, false, AtomicFetchAddOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAdd32(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(4, false, AtomicFetchAddOp, value, mem, temp, output);
    }

    template <typename T, typename S>
    void atomicAdd8(const S& value, const T& mem) {
        atomicEffectOp(1, AtomicFetchAddOp, value, mem);
    }
    template <typename T, typename S>
    void atomicAdd16(const S& value, const T& mem) {
        atomicEffectOp(2, AtomicFetchAddOp, value, mem);
    }
    template <typename T, typename S>
    void atomicAdd32(const S& value, const T& mem) {
        atomicEffectOp(4, AtomicFetchAddOp, value, mem);
    }

    template <typename T>
    void atomicExchange16ZeroExtend(const T& mem, Register value, Register output) {
        MOZ_CRASH("atomicExchange16ZeroExtend");
    }
    template <typename T>
    void atomicExchange16SignExtend(const T& mem, Register value, Register output) {
        MOZ_CRASH("atomicExchange16SignExtend");
    }

    template <typename T, typename S>
    void atomicFetchSub8SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, true, AtomicFetchSubOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchSub8ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, false, AtomicFetchSubOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchSub16SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, true, AtomicFetchSubOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchSub16ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, false, AtomicFetchSubOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchSub32(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(4, false, AtomicFetchSubOp, value, mem, temp, output);
    }

    template <typename T, typename S>
    void atomicSub8(const S& value, const T& mem) {
        atomicEffectOp(1, AtomicFetchSubOp, value, mem);
    }
    template <typename T, typename S>
    void atomicSub16(const S& value, const T& mem) {
        atomicEffectOp(2, AtomicFetchSubOp, value, mem);
    }
    template <typename T, typename S>
    void atomicSub32(const S& value, const T& mem) {
        atomicEffectOp(4, AtomicFetchSubOp, value, mem);
    }

    template <typename T, typename S>
    void atomicFetchAnd8SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, true, AtomicFetchAndOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAnd8ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, false, AtomicFetchAndOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAnd16SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, true, AtomicFetchAndOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAnd16ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, false, AtomicFetchAndOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchAnd32(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(4, false, AtomicFetchAndOp, value, mem, temp, output);
    }

    template <typename T, typename S>
    void atomicAnd8(const S& value, const T& mem) {
        atomicEffectOp(1, AtomicFetchAndOp, value, mem);
    }
    template <typename T, typename S>
    void atomicAnd16(const S& value, const T& mem) {
        atomicEffectOp(2, AtomicFetchAndOp, value, mem);
    }
    template <typename T, typename S>
    void atomicAnd32(const S& value, const T& mem) {
        atomicEffectOp(4, AtomicFetchAndOp, value, mem);
    }

    template <typename T, typename S>
    void atomicFetchOr8SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, true, AtomicFetchOrOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchOr8ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, false, AtomicFetchOrOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchOr16SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, true, AtomicFetchOrOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchOr16ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, false, AtomicFetchOrOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchOr32(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(4, false, AtomicFetchOrOp, value, mem, temp, output);
    }

    template <typename T, typename S>
    void atomicOr8(const S& value, const T& mem) {
        atomicEffectOp(1, AtomicFetchOrOp, value, mem);
    }
    template <typename T, typename S>
    void atomicOr16(const S& value, const T& mem) {
        atomicEffectOp(2, AtomicFetchOrOp, value, mem);
    }
    template <typename T, typename S>
    void atomicOr32(const S& value, const T& mem) {
        atomicEffectOp(4, AtomicFetchOrOp, value, mem);
    }

    template <typename T, typename S>
    void atomicFetchXor8SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, true, AtomicFetchXorOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchXor8ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(1, false, AtomicFetchXorOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchXor16SignExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, true, AtomicFetchXorOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchXor16ZeroExtend(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(2, false, AtomicFetchXorOp, value, mem, temp, output);
    }
    template <typename T, typename S>
    void atomicFetchXor32(const S& value, const T& mem, Register temp, Register output) {
        atomicFetchOp(4, false, AtomicFetchXorOp, value, mem, temp, output);
    }

    template <typename T, typename S>
    void atomicXor8(const S& value, const T& mem) {
        atomicEffectOp(1, AtomicFetchXorOp, value, mem);
    }
    template <typename T, typename S>
    void atomicXor16(const S& value, const T& mem) {
        atomicEffectOp(2, AtomicFetchXorOp, value, mem);
    }
    template <typename T, typename S>
    void atomicXor32(const S& value, const T& mem) {
        atomicEffectOp(4, AtomicFetchXorOp, value, mem);
    }

    template<typename T>
    void compareExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem, Register oldval, Register newval,
                                        Register temp, AnyRegister output);

    template<typename T>
    void atomicExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem, Register value,
                                       Register temp, AnyRegister output);

    // Emit a BLR or NOP instruction. ToggleCall can be used to patch
    // this instruction.
    CodeOffset toggledCall(JitCode* target, bool enabled) {
        // The returned offset must be to the first instruction generated,
        // for the debugger to match offset with Baseline's pcMappingEntries_.
        BufferOffset offset = nextOffset();

        syncStackPtr();

        BufferOffset loadOffset;
        {
            vixl::UseScratchRegisterScope temps(this);

            // The register used for the load is hardcoded, so that ToggleCall
            // can patch in the branch instruction easily. This could be changed,
            // but then ToggleCall must read the target register from the load.
            MOZ_ASSERT(temps.IsAvailable(ScratchReg2_64));
            temps.Exclude(ScratchReg2_64);

            loadOffset = immPool64(ScratchReg2_64, uint64_t(target->raw()));

            if (enabled)
                blr(ScratchReg2_64);
            else
                nop();
        }

        addPendingJump(loadOffset, ImmPtr(target->raw()), Relocation::JITCODE);
        CodeOffset ret(offset.getOffset());
        return ret;
    }

    static size_t ToggledCallSize(uint8_t* code) {
        static const uint32_t syncStackInstruction = 0x9100039f; // mov sp, r28

        // start it off as an 8 byte sequence
        int ret = 8;
        Instruction* cur = (Instruction*)code;
        uint32_t* curw = (uint32_t*)code;

        if (*curw == syncStackInstruction) {
            ret += 4;
            cur += 4;
        }

        if (cur->IsUncondB())
            ret += cur->ImmPCRawOffset() << vixl::kInstructionSizeLog2;

        return ret;
    }

    void checkARMRegAlignment(const ARMRegister& reg) {
#ifdef DEBUG
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch64 = temps.AcquireX();
        MOZ_ASSERT(scratch64.asUnsized() != reg.asUnsized());
        Label aligned;
        Mov(scratch64, reg);
        Tst(scratch64, Operand(StackAlignment - 1));
        B(Zero, &aligned);
        breakpoint();
        bind(&aligned);
        Mov(scratch64, vixl::xzr); // Clear the scratch register for sanity.
#endif
    }

    void checkStackAlignment() {
#ifdef DEBUG
        checkARMRegAlignment(GetStackPointer64());

        // If another register is being used to track pushes, check sp explicitly.
        if (!GetStackPointer64().Is(vixl::sp))
            checkARMRegAlignment(vixl::sp);
#endif
    }

    void abiret() {
        syncStackPtr(); // SP is always used to transmit the stack between calls.
        vixl::MacroAssembler::Ret(vixl::lr);
    }

    bool convertUInt64ToDoubleNeedsTemp() {
        return false;
    }

    void convertUInt64ToDouble(Register64 src, FloatRegister dest, Register temp) {
        MOZ_ASSERT(temp == Register::Invalid());
        Ucvtf(ARMFPRegister(dest, 64), ARMRegister(src.reg, 64));
    }

    void clampCheck(Register r, Label* handleNotAnInt) {
        MOZ_CRASH("clampCheck");
    }

    void stackCheck(ImmWord limitAddr, Label* label) {
        MOZ_CRASH("stackCheck");
    }

    void incrementInt32Value(const Address& addr) {
        vixl::UseScratchRegisterScope temps(this);
        const ARMRegister scratch32 = temps.AcquireW();
        MOZ_ASSERT(scratch32.asUnsized() != addr.base);

        load32(addr, scratch32.asUnsized());
        Add(scratch32, scratch32, Operand(1));
        store32(scratch32.asUnsized(), addr);
    }

    void BoundsCheck(Register ptrReg, Label* onFail, vixl::CPURegister zeroMe = vixl::NoReg) {
        // use tst rather than Tst to *ensure* that a single instrution is generated.
        Cmp(ARMRegister(ptrReg, 32), ARMRegister(HeapLenReg, 32));
        if (!zeroMe.IsNone()) {
            if (zeroMe.IsRegister()) {
                Csel(ARMRegister(zeroMe),
                     ARMRegister(zeroMe),
                     Operand(zeroMe.Is32Bits() ? vixl::wzr : vixl::xzr),
                     Assembler::Below);
            } else if (zeroMe.Is32Bits()) {
                vixl::UseScratchRegisterScope temps(this);
                const ARMFPRegister scratchFloat = temps.AcquireS();
                Fmov(scratchFloat, JS::GenericNaN());
                Fcsel(ARMFPRegister(zeroMe), ARMFPRegister(zeroMe), scratchFloat, Assembler::Below);
            } else {
                vixl::UseScratchRegisterScope temps(this);
                const ARMFPRegister scratchDouble = temps.AcquireD();
                Fmov(scratchDouble, JS::GenericNaN());
                Fcsel(ARMFPRegister(zeroMe), ARMFPRegister(zeroMe), scratchDouble, Assembler::Below);
            }
        }
        B(onFail, Assembler::AboveOrEqual);
    }
    void breakpoint();

    // Emits a simulator directive to save the current sp on an internal stack.
    void simulatorMarkSP() {
#ifdef JS_SIMULATOR_ARM64
        svc(vixl::kMarkStackPointer);
#endif
    }

    // Emits a simulator directive to pop from its internal stack
    // and assert that the value is equal to the current sp.
    void simulatorCheckSP() {
#ifdef JS_SIMULATOR_ARM64
        svc(vixl::kCheckStackPointer);
#endif
    }

    void loadWasmGlobalPtr(uint32_t globalDataOffset, Register dest) {
        loadPtr(Address(GlobalReg, globalDataOffset - WasmGlobalRegBias), dest);
    }
    void loadWasmPinnedRegsFromTls() {
        loadPtr(Address(WasmTlsReg, offsetof(wasm::TlsData, memoryBase)), HeapReg);
        loadPtr(Address(WasmTlsReg, offsetof(wasm::TlsData, globalData)), GlobalReg);
        adds32(Imm32(WasmGlobalRegBias), GlobalReg);
    }

    // Overwrites the payload bits of a dest register containing a Value.
    void movePayload(Register src, Register dest) {
        // Bfxil cannot be used with the zero register as a source.
        if (src == rzr)
            And(ARMRegister(dest, 64), ARMRegister(dest, 64), Operand(~int64_t(JSVAL_PAYLOAD_MASK)));
        else
            Bfxil(ARMRegister(dest, 64), ARMRegister(src, 64), 0, JSVAL_TAG_SHIFT);
    }

    // FIXME: Should be in Assembler?
    // FIXME: Should be const?
    uint32_t currentOffset() const {
        return nextOffset().getOffset();
    }

    struct AutoPrepareForPatching {
        explicit AutoPrepareForPatching(MacroAssemblerCompat&) {}
    };

  protected:
    bool buildOOLFakeExitFrame(void* fakeReturnAddr) {
        uint32_t descriptor = MakeFrameDescriptor(framePushed(), JitFrame_IonJS,
                                                  ExitFrameLayout::Size());
        Push(Imm32(descriptor));
        Push(ImmPtr(fakeReturnAddr));
        return true;
    }
};

typedef MacroAssemblerCompat MacroAssemblerSpecific;

} // namespace jit
} // namespace js

#endif // jit_arm64_MacroAssembler_arm64_h
