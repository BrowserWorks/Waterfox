/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_arm64_SharedICHelpers_arm64_h
#define jit_arm64_SharedICHelpers_arm64_h

#include "jit/BaselineFrame.h"
#include "jit/BaselineIC.h"
#include "jit/MacroAssembler.h"
#include "jit/SharedICRegisters.h"

namespace js {
namespace jit {

// Distance from sp to the top Value inside an IC stub (no return address on the stack on ARM).
static const size_t ICStackValueOffset = 0;

inline void
EmitRestoreTailCallReg(MacroAssembler& masm)
{
    // No-op on ARM because link register is always holding the return address.
}

inline void
EmitRepushTailCallReg(MacroAssembler& masm)
{
    // No-op on ARM because link register is always holding the return address.
}

inline void
EmitCallIC(CodeOffset* patchOffset, MacroAssembler& masm)
{
    // Move ICEntry offset into ICStubReg
    CodeOffset offset = masm.movWithPatch(ImmWord(-1), ICStubReg);
    *patchOffset = offset;

    // Load stub pointer into ICStubReg
    masm.loadPtr(Address(ICStubReg, ICEntry::offsetOfFirstStub()), ICStubReg);

    // Load stubcode pointer from BaselineStubEntry.
    // R2 won't be active when we call ICs, so we can use r0.
    MOZ_ASSERT(R2 == ValueOperand(r0));
    masm.loadPtr(Address(ICStubReg, ICStub::offsetOfStubCode()), r0);

    // Call the stubcode via a direct branch-and-link.
    masm.Blr(x0);
}

inline void
EmitEnterTypeMonitorIC(MacroAssembler& masm,
                       size_t monitorStubOffset = ICMonitoredStub::offsetOfFirstMonitorStub())
{
    // This is expected to be called from within an IC, when ICStubReg is
    // properly initialized to point to the stub.
    masm.loadPtr(Address(ICStubReg, (uint32_t) monitorStubOffset), ICStubReg);

    // Load stubcode pointer from BaselineStubEntry.
    // R2 won't be active when we call ICs, so we can use r0.
    MOZ_ASSERT(R2 == ValueOperand(r0));
    masm.loadPtr(Address(ICStubReg, ICStub::offsetOfStubCode()), r0);

    // Jump to the stubcode.
    masm.Br(x0);
}

inline void
EmitReturnFromIC(MacroAssembler& masm)
{
    masm.abiret(); // Defaults to lr.
}

inline void
EmitChangeICReturnAddress(MacroAssembler& masm, Register reg)
{
    masm.movePtr(reg, lr);
}

inline void
EmitBaselineTailCallVM(JitCode* target, MacroAssembler& masm, uint32_t argSize)
{
    // We assume that R0 has been pushed, and R2 is unused.
    MOZ_ASSERT(R2 == ValueOperand(r0));

    // Compute frame size into w0. Used below in makeFrameDescriptor().
    masm.Sub(x0, BaselineFrameReg64, masm.GetStackPointer64());
    masm.Add(w0, w0, Operand(BaselineFrame::FramePointerOffset));

    // Store frame size without VMFunction arguments for GC marking.
    {
        vixl::UseScratchRegisterScope temps(&masm.asVIXL());
        const ARMRegister scratch32 = temps.AcquireW();

        masm.Sub(scratch32, w0, Operand(argSize));
        masm.store32(scratch32.asUnsized(),
                     Address(BaselineFrameReg, BaselineFrame::reverseOffsetOfFrameSize()));
    }

    // Push frame descriptor (minus the return address) and perform the tail call.
    MOZ_ASSERT(ICTailCallReg == lr);
    masm.makeFrameDescriptor(r0, JitFrame_BaselineJS, ExitFrameLayout::Size());
    masm.push(r0);

    // The return address will be pushed by the VM wrapper, for compatibility
    // with direct calls. Refer to the top of generateVMWrapper().
    // ICTailCallReg (lr) already contains the return address (as we keep
    // it there through the stub calls).

    masm.branch(target);
}

inline void
EmitIonTailCallVM(JitCode* target, MacroAssembler& masm, uint32_t stackSize)
{
    MOZ_CRASH("Not implemented yet.");
}

inline void
EmitBaselineCreateStubFrameDescriptor(MacroAssembler& masm, Register reg, uint32_t headerSize)
{
    ARMRegister reg64(reg, 64);

    // Compute stub frame size.
    masm.Sub(reg64, masm.GetStackPointer64(), Operand(sizeof(void*) * 2));
    masm.Sub(reg64, BaselineFrameReg64, reg64);

    masm.makeFrameDescriptor(reg, JitFrame_BaselineStub, headerSize);
}

inline void
EmitBaselineCallVM(JitCode* target, MacroAssembler& masm)
{
    EmitBaselineCreateStubFrameDescriptor(masm, r0, ExitFrameLayout::Size());
    masm.push(r0);
    masm.call(target);
}

// Size of values pushed by EmitEnterStubFrame.
static const uint32_t STUB_FRAME_SIZE = 4 * sizeof(void*);
static const uint32_t STUB_FRAME_SAVED_STUB_OFFSET = sizeof(void*);

inline void
EmitBaselineEnterStubFrame(MacroAssembler& masm, Register scratch)
{
    MOZ_ASSERT(scratch != ICTailCallReg);

    // Compute frame size.
    masm.Add(ARMRegister(scratch, 64), BaselineFrameReg64, Operand(BaselineFrame::FramePointerOffset));
    masm.Sub(ARMRegister(scratch, 64), ARMRegister(scratch, 64), masm.GetStackPointer64());

    masm.store32(scratch, Address(BaselineFrameReg, BaselineFrame::reverseOffsetOfFrameSize()));

    // Note: when making changes here, don't forget to update STUB_FRAME_SIZE.

    // Push frame descriptor and return address.
    // Save old frame pointer, stack pointer, and stub reg.
    masm.makeFrameDescriptor(scratch, JitFrame_BaselineJS, BaselineStubFrameLayout::Size());
    masm.Push(scratch, ICTailCallReg, ICStubReg, BaselineFrameReg);

    // Update the frame register.
    masm.Mov(BaselineFrameReg64, masm.GetStackPointer64());

    // Stack should remain 16-byte aligned.
    masm.checkStackAlignment();
}

inline void
EmitBaselineLeaveStubFrame(MacroAssembler& masm, bool calledIntoIon = false)
{
    vixl::UseScratchRegisterScope temps(&masm.asVIXL());
    const ARMRegister scratch64 = temps.AcquireX();

    // Ion frames do not save and restore the frame pointer. If we called
    // into Ion, we have to restore the stack pointer from the frame descriptor.
    // If we performed a VM call, the descriptor has been popped already so
    // in that case we use the frame pointer.
    if (calledIntoIon) {
        masm.pop(scratch64.asUnsized());
        masm.Lsr(scratch64, scratch64, FRAMESIZE_SHIFT);
        masm.Add(masm.GetStackPointer64(), masm.GetStackPointer64(), scratch64);
    } else {
        masm.Mov(masm.GetStackPointer64(), BaselineFrameReg64);
    }

    // Pop values, discarding the frame descriptor.
    masm.pop(BaselineFrameReg, ICStubReg, ICTailCallReg, scratch64.asUnsized());

    // Stack should remain 16-byte aligned.
    masm.checkStackAlignment();
}

inline void
EmitStowICValues(MacroAssembler& masm, int values)
{
    switch (values) {
      case 1:
        // Stow R0.
        masm.Push(R0);
        break;
      case 2:
        // Stow R0 and R1.
        masm.Push(R0.valueReg());
        masm.Push(R1.valueReg());
        break;
      default:
        MOZ_MAKE_COMPILER_ASSUME_IS_UNREACHABLE("Expected 1 or 2 values");
    }
}

inline void
EmitUnstowICValues(MacroAssembler& masm, int values, bool discard = false)
{
    MOZ_ASSERT(values >= 0 && values <= 2);
    switch (values) {
      case 1:
        // Unstow R0.
        if (discard)
            masm.Drop(Operand(sizeof(Value)));
        else
            masm.popValue(R0);
        break;
      case 2:
        // Unstow R0 and R1.
        if (discard)
            masm.Drop(Operand(sizeof(Value) * 2));
        else
            masm.pop(R1.valueReg(), R0.valueReg());
        break;
      default:
        MOZ_MAKE_COMPILER_ASSUME_IS_UNREACHABLE("Expected 1 or 2 values");
    }
    masm.adjustFrame(-values * sizeof(Value));
}

template <typename AddrType>
inline void
EmitPreBarrier(MacroAssembler& masm, const AddrType& addr, MIRType type)
{
    // On AArch64, lr is clobbered by guardedCallPreBarrier. Save it first.
    masm.push(lr);
    masm.guardedCallPreBarrier(addr, type);
    masm.pop(lr);
}

inline void
EmitStubGuardFailure(MacroAssembler& masm)
{
    // Load next stub into ICStubReg.
    masm.loadPtr(Address(ICStubReg, ICStub::offsetOfNext()), ICStubReg);

    // Return address is already loaded, just jump to the next stubcode.
    masm.jump(Address(ICStubReg, ICStub::offsetOfStubCode()));
}

} // namespace jit
} // namespace js

#endif // jit_arm64_SharedICHelpers_arm64_h
