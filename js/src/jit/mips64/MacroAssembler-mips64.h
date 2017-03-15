/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_mips64_MacroAssembler_mips64_h
#define jit_mips64_MacroAssembler_mips64_h

#include "jsopcode.h"

#include "jit/IonCaches.h"
#include "jit/JitFrames.h"
#include "jit/mips-shared/MacroAssembler-mips-shared.h"
#include "jit/MoveResolver.h"

namespace js {
namespace jit {

enum LiFlags
{
    Li64 = 0,
    Li48 = 1,
};

struct ImmShiftedTag : public ImmWord
{
    explicit ImmShiftedTag(JSValueShiftedTag shtag)
      : ImmWord((uintptr_t)shtag)
    { }

    explicit ImmShiftedTag(JSValueType type)
      : ImmWord(uintptr_t(JSValueShiftedTag(JSVAL_TYPE_TO_SHIFTED_TAG(type))))
    { }
};

struct ImmTag : public Imm32
{
    ImmTag(JSValueTag mask)
      : Imm32(int32_t(mask))
    { }
};

static const ValueOperand JSReturnOperand = ValueOperand(JSReturnReg);

static const int defaultShift = 3;
static_assert(1 << defaultShift == sizeof(JS::Value), "The defaultShift is wrong");

class MacroAssemblerMIPS64 : public MacroAssemblerMIPSShared
{
  public:
    using MacroAssemblerMIPSShared::ma_b;
    using MacroAssemblerMIPSShared::ma_li;
    using MacroAssemblerMIPSShared::ma_ss;
    using MacroAssemblerMIPSShared::ma_sd;
    using MacroAssemblerMIPSShared::ma_load;
    using MacroAssemblerMIPSShared::ma_store;
    using MacroAssemblerMIPSShared::ma_cmp_set;
    using MacroAssemblerMIPSShared::ma_subTestOverflow;

    void ma_li(Register dest, CodeOffset* label);
    void ma_li(Register dest, ImmWord imm);
    void ma_liPatchable(Register dest, ImmPtr imm);
    void ma_liPatchable(Register dest, ImmWord imm, LiFlags flags = Li48);

    // Negate
    void ma_dnegu(Register rd, Register rs);

    // Shift operations
    void ma_dsll(Register rd, Register rt, Imm32 shift);
    void ma_dsrl(Register rd, Register rt, Imm32 shift);
    void ma_dsra(Register rd, Register rt, Imm32 shift);
    void ma_dror(Register rd, Register rt, Imm32 shift);
    void ma_drol(Register rd, Register rt, Imm32 shift);

    void ma_dsll(Register rd, Register rt, Register shift);
    void ma_dsrl(Register rd, Register rt, Register shift);
    void ma_dsra(Register rd, Register rt, Register shift);
    void ma_dror(Register rd, Register rt, Register shift);
    void ma_drol(Register rd, Register rt, Register shift);

    void ma_dins(Register rt, Register rs, Imm32 pos, Imm32 size);
    void ma_dext(Register rt, Register rs, Imm32 pos, Imm32 size);

    void ma_dctz(Register rd, Register rs);

    // load
    void ma_load(Register dest, Address address, LoadStoreSize size = SizeWord,
                 LoadStoreExtension extension = SignExtend);

    // store
    void ma_store(Register data, Address address, LoadStoreSize size = SizeWord,
                  LoadStoreExtension extension = SignExtend);

    // arithmetic based ops
    // add
    void ma_daddu(Register rd, Register rs, Imm32 imm);
    void ma_daddu(Register rd, Register rs);
    void ma_daddu(Register rd, Imm32 imm);
    template <typename L>
    void ma_addTestOverflow(Register rd, Register rs, Register rt, L overflow);
    template <typename L>
    void ma_addTestOverflow(Register rd, Register rs, Imm32 imm, L overflow);

    // subtract
    void ma_dsubu(Register rd, Register rs, Imm32 imm);
    void ma_dsubu(Register rd, Register rs);
    void ma_dsubu(Register rd, Imm32 imm);
    void ma_subTestOverflow(Register rd, Register rs, Register rt, Label* overflow);

    // multiplies.  For now, there are only few that we care about.
    void ma_dmult(Register rs, Imm32 imm);

    // stack
    void ma_pop(Register r);
    void ma_push(Register r);

    void branchWithCode(InstImm code, Label* label, JumpKind jumpKind);
    // branches when done from within mips-specific code
    void ma_b(Register lhs, ImmWord imm, Label* l, Condition c, JumpKind jumpKind = LongJump);
    void ma_b(Register lhs, Address addr, Label* l, Condition c, JumpKind jumpKind = LongJump);
    void ma_b(Address addr, Imm32 imm, Label* l, Condition c, JumpKind jumpKind = LongJump);
    void ma_b(Address addr, ImmGCPtr imm, Label* l, Condition c, JumpKind jumpKind = LongJump);
    void ma_b(Address addr, Register rhs, Label* l, Condition c, JumpKind jumpKind = LongJump) {
        MOZ_ASSERT(rhs != ScratchRegister);
        ma_load(ScratchRegister, addr, SizeDouble);
        ma_b(ScratchRegister, rhs, l, c, jumpKind);
    }

    void ma_bal(Label* l, DelaySlotFill delaySlotFill = FillDelaySlot);

    // fp instructions
    void ma_lid(FloatRegister dest, double value);

    void ma_mv(FloatRegister src, ValueOperand dest);
    void ma_mv(ValueOperand src, FloatRegister dest);

    void ma_ls(FloatRegister fd, Address address);
    void ma_ld(FloatRegister fd, Address address);
    void ma_sd(FloatRegister fd, Address address);
    void ma_ss(FloatRegister fd, Address address);

    void ma_pop(FloatRegister fs);
    void ma_push(FloatRegister fs);

    void ma_cmp_set(Register dst, Register lhs, ImmWord imm, Condition c);
    void ma_cmp_set(Register dst, Register lhs, ImmPtr imm, Condition c);

    // These functions abstract the access to high part of the double precision
    // float register. They are intended to work on both 32 bit and 64 bit
    // floating point coprocessor.
    void moveToDoubleHi(Register src, FloatRegister dest) {
        as_mthc1(src, dest);
    }
    void moveFromDoubleHi(FloatRegister src, Register dest) {
        as_mfhc1(dest, src);
    }

    void moveToDouble(Register src, FloatRegister dest) {
        as_dmtc1(src, dest);
    }
    void moveFromDouble(FloatRegister src, Register dest) {
        as_dmfc1(dest, src);
    }
};

class MacroAssembler;

class MacroAssemblerMIPS64Compat : public MacroAssemblerMIPS64
{
  public:
    using MacroAssemblerMIPS64::call;

    MacroAssemblerMIPS64Compat()
    { }

    void convertBoolToInt32(Register source, Register dest);
    void convertInt32ToDouble(Register src, FloatRegister dest);
    void convertInt32ToDouble(const Address& src, FloatRegister dest);
    void convertInt32ToDouble(const BaseIndex& src, FloatRegister dest);
    void convertUInt32ToDouble(Register src, FloatRegister dest);
    void convertUInt32ToFloat32(Register src, FloatRegister dest);
    void convertDoubleToFloat32(FloatRegister src, FloatRegister dest);
    void convertDoubleToInt32(FloatRegister src, Register dest, Label* fail,
                              bool negativeZeroCheck = true);
    void convertFloat32ToInt32(FloatRegister src, Register dest, Label* fail,
                               bool negativeZeroCheck = true);

    void convertFloat32ToDouble(FloatRegister src, FloatRegister dest);
    void convertInt32ToFloat32(Register src, FloatRegister dest);
    void convertInt32ToFloat32(const Address& src, FloatRegister dest);

    void movq(Register rs, Register rd);

    void computeScaledAddress(const BaseIndex& address, Register dest);

    void computeEffectiveAddress(const Address& address, Register dest) {
        ma_daddu(dest, address.base, Imm32(address.offset));
    }

    inline void computeEffectiveAddress(const BaseIndex& address, Register dest);

    void j(Label* dest) {
        ma_b(dest);
    }

    void mov(Register src, Register dest) {
        as_ori(dest, src, 0);
    }
    void mov(ImmWord imm, Register dest) {
        ma_li(dest, imm);
    }
    void mov(ImmPtr imm, Register dest) {
        mov(ImmWord(uintptr_t(imm.value)), dest);
    }
    void mov(Register src, Address dest) {
        MOZ_CRASH("NYI-IC");
    }
    void mov(Address src, Register dest) {
        MOZ_CRASH("NYI-IC");
    }

    void writeDataRelocation(const Value& val) {
        if (val.isMarkable()) {
            gc::Cell* cell = val.toMarkablePointer();
            if (cell && gc::IsInsideNursery(cell))
                embedsNurseryPointers_ = true;
            dataRelocations_.writeUnsigned(currentOffset());
        }
    }

    void branch(JitCode* c) {
        BufferOffset bo = m_buffer.nextOffset();
        addPendingJump(bo, ImmPtr(c->raw()), Relocation::JITCODE);
        ma_liPatchable(ScratchRegister, ImmPtr(c->raw()));
        as_jr(ScratchRegister);
        as_nop();
    }
    void branch(const Register reg) {
        as_jr(reg);
        as_nop();
    }
    void nop() {
        as_nop();
    }
    void ret() {
        ma_pop(ra);
        as_jr(ra);
        as_nop();
    }
    inline void retn(Imm32 n);
    void push(Imm32 imm) {
        ma_li(ScratchRegister, imm);
        ma_push(ScratchRegister);
    }
    void push(ImmWord imm) {
        ma_li(ScratchRegister, imm);
        ma_push(ScratchRegister);
    }
    void push(ImmGCPtr imm) {
        ma_li(ScratchRegister, imm);
        ma_push(ScratchRegister);
    }
    void push(const Address& address) {
        loadPtr(address, ScratchRegister);
        ma_push(ScratchRegister);
    }
    void push(Register reg) {
        ma_push(reg);
    }
    void push(FloatRegister reg) {
        ma_push(reg);
    }
    void pop(Register reg) {
        ma_pop(reg);
    }
    void pop(FloatRegister reg) {
        ma_pop(reg);
    }

    // Emit a branch that can be toggled to a non-operation. On MIPS64 we use
    // "andi" instruction to toggle the branch.
    // See ToggleToJmp(), ToggleToCmp().
    CodeOffset toggledJump(Label* label);

    // Emit a "jalr" or "nop" instruction. ToggleCall can be used to patch
    // this instruction.
    CodeOffset toggledCall(JitCode* target, bool enabled);

    static size_t ToggledCallSize(uint8_t* code) {
        // Six instructions used in: MacroAssemblerMIPS64Compat::toggledCall
        return 6 * sizeof(uint32_t);
    }

    CodeOffset pushWithPatch(ImmWord imm) {
        CodeOffset offset = movWithPatch(imm, ScratchRegister);
        ma_push(ScratchRegister);
        return offset;
    }

    CodeOffset movWithPatch(ImmWord imm, Register dest) {
        CodeOffset offset = CodeOffset(currentOffset());
        ma_liPatchable(dest, imm, Li64);
        return offset;
    }
    CodeOffset movWithPatch(ImmPtr imm, Register dest) {
        CodeOffset offset = CodeOffset(currentOffset());
        ma_liPatchable(dest, imm);
        return offset;
    }

    void jump(Label* label) {
        ma_b(label);
    }
    void jump(Register reg) {
        as_jr(reg);
        as_nop();
    }
    void jump(const Address& address) {
        loadPtr(address, ScratchRegister);
        as_jr(ScratchRegister);
        as_nop();
    }

    void jump(JitCode* code) {
        branch(code);
    }

    void jump(wasm::TrapDesc target) {
        ma_b(target);
    }

    void splitTag(Register src, Register dest) {
        ma_dsrl(dest, src, Imm32(JSVAL_TAG_SHIFT));
    }

    void splitTag(const ValueOperand& operand, Register dest) {
        splitTag(operand.valueReg(), dest);
    }

    // Returns the register containing the type tag.
    Register splitTagForTest(const ValueOperand& value) {
        splitTag(value, SecondScratchReg);
        return SecondScratchReg;
    }

    // unboxing code
    void unboxNonDouble(const ValueOperand& operand, Register dest);
    void unboxNonDouble(const Address& src, Register dest);
    void unboxNonDouble(const BaseIndex& src, Register dest);
    void unboxInt32(const ValueOperand& operand, Register dest);
    void unboxInt32(Register src, Register dest);
    void unboxInt32(const Address& src, Register dest);
    void unboxInt32(const BaseIndex& src, Register dest);
    void unboxBoolean(const ValueOperand& operand, Register dest);
    void unboxBoolean(Register src, Register dest);
    void unboxBoolean(const Address& src, Register dest);
    void unboxBoolean(const BaseIndex& src, Register dest);
    void unboxDouble(const ValueOperand& operand, FloatRegister dest);
    void unboxDouble(Register src, Register dest);
    void unboxDouble(const Address& src, FloatRegister dest);
    void unboxString(const ValueOperand& operand, Register dest);
    void unboxString(Register src, Register dest);
    void unboxString(const Address& src, Register dest);
    void unboxSymbol(const ValueOperand& src, Register dest);
    void unboxSymbol(Register src, Register dest);
    void unboxSymbol(const Address& src, Register dest);
    void unboxObject(const ValueOperand& src, Register dest);
    void unboxObject(Register src, Register dest);
    void unboxObject(const Address& src, Register dest);
    void unboxObject(const BaseIndex& src, Register dest) { unboxNonDouble(src, dest); }
    void unboxValue(const ValueOperand& src, AnyRegister dest);
    void unboxPrivate(const ValueOperand& src, Register dest);

    void notBoolean(const ValueOperand& val) {
        as_xori(val.valueReg(), val.valueReg(), 1);
    }

    // boxing code
    void boxDouble(FloatRegister src, const ValueOperand& dest);
    void boxNonDouble(JSValueType type, Register src, const ValueOperand& dest);

    // Extended unboxing API. If the payload is already in a register, returns
    // that register. Otherwise, provides a move to the given scratch register,
    // and returns that.
    Register extractObject(const Address& address, Register scratch);
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
    Register extractTag(const Address& address, Register scratch);
    Register extractTag(const BaseIndex& address, Register scratch);
    Register extractTag(const ValueOperand& value, Register scratch) {
        MOZ_ASSERT(scratch != ScratchRegister);
        splitTag(value, scratch);
        return scratch;
    }

    void boolValueToDouble(const ValueOperand& operand, FloatRegister dest);
    void int32ValueToDouble(const ValueOperand& operand, FloatRegister dest);
    void loadInt32OrDouble(const Address& src, FloatRegister dest);
    void loadInt32OrDouble(const BaseIndex& addr, FloatRegister dest);
    void loadConstantDouble(double dp, FloatRegister dest);
    void loadConstantDouble(wasm::RawF64 d, FloatRegister dest);

    void boolValueToFloat32(const ValueOperand& operand, FloatRegister dest);
    void int32ValueToFloat32(const ValueOperand& operand, FloatRegister dest);
    void loadConstantFloat32(float f, FloatRegister dest);
    void loadConstantFloat32(wasm::RawF32 f, FloatRegister dest);

    void testNullSet(Condition cond, const ValueOperand& value, Register dest);

    void testObjectSet(Condition cond, const ValueOperand& value, Register dest);

    void testUndefinedSet(Condition cond, const ValueOperand& value, Register dest);

    // higher level tag testing code
    Address ToPayload(Address value) {
        return value;
    }

    void moveValue(const Value& val, Register dest);

    CodeOffsetJump backedgeJump(RepatchLabel* label, Label* documentation = nullptr);
    CodeOffsetJump jumpWithPatch(RepatchLabel* label, Label* documentation = nullptr);

    template <typename T>
    void loadUnboxedValue(const T& address, MIRType type, AnyRegister dest) {
        if (dest.isFloat())
            loadInt32OrDouble(address, dest.fpu());
        else if (type == MIRType::Int32)
            unboxInt32(address, dest.gpr());
        else if (type == MIRType::Boolean)
            unboxBoolean(address, dest.gpr());
        else
            unboxNonDouble(address, dest.gpr());
    }

    template <typename T>
    void storeUnboxedPayload(ValueOperand value, T address, size_t nbytes) {
        switch (nbytes) {
          case 8:
            unboxNonDouble(value, ScratchRegister);
            storePtr(ScratchRegister, address);
            return;
          case 4:
            store32(value.valueReg(), address);
            return;
          case 1:
            store8(value.valueReg(), address);
            return;
          default: MOZ_CRASH("Bad payload width");
        }
    }

    void moveValue(const Value& val, const ValueOperand& dest);

    void moveValue(const ValueOperand& src, const ValueOperand& dest) {
        if (src.valueReg() != dest.valueReg())
          ma_move(dest.valueReg(), src.valueReg());
    }
    void boxValue(JSValueType type, Register src, Register dest) {
        MOZ_ASSERT(src != dest);

        JSValueTag tag = (JSValueTag)JSVAL_TYPE_TO_TAG(type);
        ma_li(dest, Imm32(tag));
        ma_dsll(dest, dest, Imm32(JSVAL_TAG_SHIFT));
        ma_dins(dest, src, Imm32(0), Imm32(JSVAL_TAG_SHIFT));
    }

    void storeValue(ValueOperand val, Operand dst);
    void storeValue(ValueOperand val, const BaseIndex& dest);
    void storeValue(JSValueType type, Register reg, BaseIndex dest);
    void storeValue(ValueOperand val, const Address& dest);
    void storeValue(JSValueType type, Register reg, Address dest);
    void storeValue(const Value& val, Address dest);
    void storeValue(const Value& val, BaseIndex dest);
    void storeValue(const Address& src, const Address& dest, Register temp) {
        loadPtr(src, temp);
        storePtr(temp, dest);
    }

    void loadValue(Address src, ValueOperand val);
    void loadValue(Operand dest, ValueOperand val) {
        loadValue(dest.toAddress(), val);
    }
    void loadValue(const BaseIndex& addr, ValueOperand val);
    void tagValue(JSValueType type, Register payload, ValueOperand dest);

    void pushValue(ValueOperand val);
    void popValue(ValueOperand val);
    void pushValue(const Value& val) {
        if (val.isMarkable()) {
            writeDataRelocation(val);
            movWithPatch(ImmWord(val.asRawBits()), ScratchRegister);
            push(ScratchRegister);
        } else {
            push(ImmWord(val.asRawBits()));
        }
    }
    void pushValue(JSValueType type, Register reg) {
        boxValue(type, reg, ScratchRegister);
        push(ScratchRegister);
    }
    void pushValue(const Address& addr);

    void handleFailureWithHandlerTail(void* handler);

    /////////////////////////////////////////////////////////////////
    // Common interface.
    /////////////////////////////////////////////////////////////////
  public:
    // The following functions are exposed for use in platform-shared code.

    template<typename T>
    void compareExchange8SignExtend(const T& mem, Register oldval, Register newval, Register valueTemp,
                                    Register offsetTemp, Register maskTemp, Register output)
    {
        compareExchange(1, true, mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void compareExchange8ZeroExtend(const T& mem, Register oldval, Register newval, Register valueTemp,
                                    Register offsetTemp, Register maskTemp, Register output)
    {
        compareExchange(1, false, mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void compareExchange16SignExtend(const T& mem, Register oldval, Register newval, Register valueTemp,
                                     Register offsetTemp, Register maskTemp, Register output)
    {
        compareExchange(2, true, mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void compareExchange16ZeroExtend(const T& mem, Register oldval, Register newval, Register valueTemp,
                                     Register offsetTemp, Register maskTemp, Register output)
    {
        compareExchange(2, false, mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void compareExchange32(const T& mem, Register oldval, Register newval, Register valueTemp,
                           Register offsetTemp, Register maskTemp, Register output)
    {
        compareExchange(4, false, mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output);
    }

    template<typename T>
    void atomicExchange8SignExtend(const T& mem, Register value, Register valueTemp,
                          Register offsetTemp, Register maskTemp, Register output)
    {
        atomicExchange(1, true, mem, value, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void atomicExchange8ZeroExtend(const T& mem, Register value, Register valueTemp,
                          Register offsetTemp, Register maskTemp, Register output)
    {
        atomicExchange(1, false, mem, value, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void atomicExchange16SignExtend(const T& mem, Register value, Register valueTemp,
                          Register offsetTemp, Register maskTemp, Register output)
    {
        atomicExchange(2, true, mem, value, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void atomicExchange16ZeroExtend(const T& mem, Register value, Register valueTemp,
                          Register offsetTemp, Register maskTemp, Register output)
    {
        atomicExchange(2, false, mem, value, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T>
    void atomicExchange32(const T& mem, Register value, Register valueTemp,
                          Register offsetTemp, Register maskTemp, Register output)
    {
        atomicExchange(4, false, mem, value, valueTemp, offsetTemp, maskTemp, output);
    }

    template<typename T, typename S>
    void atomicFetchAdd8SignExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, true, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAdd8ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, false, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAdd16SignExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, true, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAdd16ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, false, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAdd32(const S& value, const T& mem, Register flagTemp,
                          Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(4, false, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template <typename T, typename S>
    void atomicAdd8(const T& value, const S& mem, Register flagTemp,
                    Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(1, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicAdd16(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(2, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicAdd32(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(4, AtomicFetchAddOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }

    template<typename T, typename S>
    void atomicFetchSub8SignExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, true, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchSub8ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, false, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchSub16SignExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, true, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchSub16ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, false, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchSub32(const S& value, const T& mem, Register flagTemp,
                          Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(4, false, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template <typename T, typename S>
    void atomicSub8(const T& value, const S& mem, Register flagTemp,
                    Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(1, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicSub16(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(2, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicSub32(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(4, AtomicFetchSubOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }

    template<typename T, typename S>
    void atomicFetchAnd8SignExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, true, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAnd8ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, false, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAnd16SignExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, true, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAnd16ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, false, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchAnd32(const S& value, const T& mem, Register flagTemp,
                          Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(4, false, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template <typename T, typename S>
    void atomicAnd8(const T& value, const S& mem, Register flagTemp,
                    Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(1, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicAnd16(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(2, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicAnd32(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(4, AtomicFetchAndOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }

    template<typename T, typename S>
    void atomicFetchOr8SignExtend(const S& value, const T& mem, Register flagTemp,
                                  Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, true, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchOr8ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                  Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, false, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchOr16SignExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, true, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchOr16ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, false, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchOr32(const S& value, const T& mem, Register flagTemp,
                         Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(4, false, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template <typename T, typename S>
    void atomicOr8(const T& value, const S& mem, Register flagTemp,
                   Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(1, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicOr16(const T& value, const S& mem, Register flagTemp,
                    Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(2, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicOr32(const T& value, const S& mem, Register flagTemp,
                    Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(4, AtomicFetchOrOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }

    template<typename T, typename S>
    void atomicFetchXor8SignExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, true, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchXor8ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                   Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(1, false, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchXor16SignExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, true, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchXor16ZeroExtend(const S& value, const T& mem, Register flagTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(2, false, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template<typename T, typename S>
    void atomicFetchXor32(const S& value, const T& mem, Register flagTemp,
                          Register valueTemp, Register offsetTemp, Register maskTemp, Register output)
    {
        atomicFetchOp(4, false, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output);
    }
    template <typename T, typename S>
    void atomicXor8(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(1, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicXor16(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(2, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }
    template <typename T, typename S>
    void atomicXor32(const T& value, const S& mem, Register flagTemp,
                     Register valueTemp, Register offsetTemp, Register maskTemp)
    {
        atomicEffectOp(4, AtomicFetchXorOp, value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
    }

    template<typename T>
    void compareExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem, Register oldval, Register newval,
                                        Register temp, Register valueTemp, Register offsetTemp, Register maskTemp,
                                        AnyRegister output);

    template<typename T>
    void atomicExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem, Register value,
                                       Register temp, Register valueTemp, Register offsetTemp, Register maskTemp,
                                       AnyRegister output);

    inline void incrementInt32Value(const Address& addr);

    void move32(Imm32 imm, Register dest);
    void move32(Register src, Register dest);

    void movePtr(Register src, Register dest);
    void movePtr(ImmWord imm, Register dest);
    void movePtr(ImmPtr imm, Register dest);
    void movePtr(wasm::SymbolicAddress imm, Register dest);
    void movePtr(ImmGCPtr imm, Register dest);

    void load8SignExtend(const Address& address, Register dest);
    void load8SignExtend(const BaseIndex& src, Register dest);

    void load8ZeroExtend(const Address& address, Register dest);
    void load8ZeroExtend(const BaseIndex& src, Register dest);

    void load16SignExtend(const Address& address, Register dest);
    void load16SignExtend(const BaseIndex& src, Register dest);

    void load16ZeroExtend(const Address& address, Register dest);
    void load16ZeroExtend(const BaseIndex& src, Register dest);

    void load32(const Address& address, Register dest);
    void load32(const BaseIndex& address, Register dest);
    void load32(AbsoluteAddress address, Register dest);
    void load32(wasm::SymbolicAddress address, Register dest);
    void load64(const Address& address, Register64 dest) {
        loadPtr(address, dest.reg);
    }

    void loadPtr(const Address& address, Register dest);
    void loadPtr(const BaseIndex& src, Register dest);
    void loadPtr(AbsoluteAddress address, Register dest);
    void loadPtr(wasm::SymbolicAddress address, Register dest);

    void loadPrivate(const Address& address, Register dest);

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
    void storeAlignedSimd128Int(FloatRegister src, Address addr) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Int(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Int(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Int(FloatRegister src, Address addr) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Int(FloatRegister src, BaseIndex addr) { MOZ_CRASH("NYI"); }

    void loadFloat32x3(const Address& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadFloat32x3(const BaseIndex& src, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadAlignedSimd128Float(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeAlignedSimd128Float(FloatRegister src, Address addr) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Float(const Address& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void loadUnalignedSimd128Float(const BaseIndex& addr, FloatRegister dest) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Float(FloatRegister src, Address addr) { MOZ_CRASH("NYI"); }
    void storeUnalignedSimd128Float(FloatRegister src, BaseIndex addr) { MOZ_CRASH("NYI"); }

    void loadDouble(const Address& addr, FloatRegister dest);
    void loadDouble(const BaseIndex& src, FloatRegister dest);
    void loadUnalignedDouble(const BaseIndex& src, Register temp, FloatRegister dest);

    // Load a float value into a register, then expand it to a double.
    void loadFloatAsDouble(const Address& addr, FloatRegister dest);
    void loadFloatAsDouble(const BaseIndex& src, FloatRegister dest);

    void loadFloat32(const Address& addr, FloatRegister dest);
    void loadFloat32(const BaseIndex& src, FloatRegister dest);
    void loadUnalignedFloat32(const BaseIndex& src, Register temp, FloatRegister dest);

    void store8(Register src, const Address& address);
    void store8(Imm32 imm, const Address& address);
    void store8(Register src, const BaseIndex& address);
    void store8(Imm32 imm, const BaseIndex& address);

    void store16(Register src, const Address& address);
    void store16(Imm32 imm, const Address& address);
    void store16(Register src, const BaseIndex& address);
    void store16(Imm32 imm, const BaseIndex& address);

    void store32(Register src, AbsoluteAddress address);
    void store32(Register src, const Address& address);
    void store32(Register src, const BaseIndex& address);
    void store32(Imm32 src, const Address& address);
    void store32(Imm32 src, const BaseIndex& address);

    // NOTE: This will use second scratch on MIPS64. Only ARM needs the
    // implementation without second scratch.
    void store32_NoSecondScratch(Imm32 src, const Address& address) {
        store32(src, address);
    }

    void store64(Imm64 imm, Address address) {
        storePtr(ImmWord(imm.value), address);
    }

    void store64(Register64 src, Address address) {
        storePtr(src.reg, address);
    }

    template <typename T> void storePtr(ImmWord imm, T address);
    template <typename T> void storePtr(ImmPtr imm, T address);
    template <typename T> void storePtr(ImmGCPtr imm, T address);
    void storePtr(Register src, const Address& address);
    void storePtr(Register src, const BaseIndex& address);
    void storePtr(Register src, AbsoluteAddress dest);

    void storeUnalignedFloat32(FloatRegister src, Register temp, const BaseIndex& dest);
    void storeUnalignedDouble(FloatRegister src, Register temp, const BaseIndex& dest);

    void moveDouble(FloatRegister src, FloatRegister dest) {
        as_movd(dest, src);
    }

    void zeroDouble(FloatRegister reg) {
        moveToDouble(zero, reg);
    }

    void convertInt64ToDouble(Register src, FloatRegister dest);
    void convertInt64ToFloat32(Register src, FloatRegister dest);

    void convertUInt64ToDouble(Register src, FloatRegister dest);
    void convertUInt64ToFloat32(Register src, FloatRegister dest);

    static bool convertUInt64ToDoubleNeedsTemp();
    void convertUInt64ToDouble(Register64 src, FloatRegister dest, Register temp);

    void breakpoint();

    void checkStackAlignment();

    static void calculateAlignedStackPointer(void** stackPointer);

    // If source is a double, load it into dest. If source is int32,
    // convert it to double. Else, branch to failure.
    void ensureDouble(const ValueOperand& source, FloatRegister dest, Label* failure);

    void cmpPtrSet(Assembler::Condition cond, Address lhs, ImmPtr rhs, Register dest);
    void cmpPtrSet(Assembler::Condition cond, Register lhs, Address rhs, Register dest);

    void cmp32Set(Assembler::Condition cond, Register lhs, Address rhs, Register dest);

    void cmp64Set(Assembler::Condition cond, Register lhs, Imm32 rhs, Register dest)
    {
        ma_cmp_set(dest, lhs, rhs, cond);
    }

  protected:
    bool buildOOLFakeExitFrame(void* fakeReturnAddr);

  public:
    CodeOffset labelForPatch() {
        return CodeOffset(nextOffset().getOffset());
    }

    void lea(Operand addr, Register dest) {
        ma_daddu(dest, addr.baseReg(), Imm32(addr.disp()));
    }

    void abiret() {
        as_jr(ra);
        as_nop();
    }

    BufferOffset ma_BoundsCheck(Register bounded) {
        BufferOffset bo = m_buffer.nextOffset();
        ma_liPatchable(bounded, ImmWord(0));
        return bo;
    }

    void moveFloat32(FloatRegister src, FloatRegister dest) {
        as_movs(dest, src);
    }

    void loadWasmGlobalPtr(uint32_t globalDataOffset, Register dest) {
        loadPtr(Address(GlobalReg, globalDataOffset - WasmGlobalRegBias), dest);
    }
    void loadWasmPinnedRegsFromTls() {
        loadPtr(Address(WasmTlsReg, offsetof(wasm::TlsData, memoryBase)), HeapReg);
        loadPtr(Address(WasmTlsReg, offsetof(wasm::TlsData, globalData)), GlobalReg);
        ma_daddu(GlobalReg, Imm32(WasmGlobalRegBias));
    }

    // Instrumentation for entering and leaving the profiler.
    void profilerEnterFrame(Register framePtr, Register scratch);
    void profilerExitFrame();
};

typedef MacroAssemblerMIPS64Compat MacroAssemblerSpecific;

} // namespace jit
} // namespace js

#endif /* jit_mips64_MacroAssembler_mips64_h */
