/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 *
 * Copyright 2014 Mozilla Foundation
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

#include "wasm/WasmSignalHandlers.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/PodOperations.h"
#include "mozilla/ScopeExit.h"

#include "jit/AtomicOperations.h"
#include "jit/Disassembler.h"
#include "vm/Runtime.h"
#include "wasm/WasmBuiltins.h"
#include "wasm/WasmInstance.h"

using namespace js;
using namespace js::jit;
using namespace js::wasm;

using JS::GenericNaN;
using mozilla::DebugOnly;
using mozilla::PodArrayZero;

#if defined(ANDROID)
# include <sys/system_properties.h>
# if defined(MOZ_LINKER)
extern "C" MFBT_API bool IsSignalHandlingBroken();
# endif
#endif

// Crashing inside the signal handler can cause the handler to be recursively
// invoked, eventually blowing the stack without actually showing a crash
// report dialog via Breakpad. To guard against this we watch for such
// recursion and fall through to the next handler immediately rather than
// trying to handle it.
class AutoSetHandlingSegFault
{
    JSContext* cx;

  public:
    explicit AutoSetHandlingSegFault(JSContext* cx)
      : cx(cx)
    {
        MOZ_ASSERT(!cx->handlingSegFault);
        cx->handlingSegFault = true;
    }

    ~AutoSetHandlingSegFault()
    {
        MOZ_ASSERT(cx->handlingSegFault);
        cx->handlingSegFault = false;
    }
};

#if defined(XP_WIN)
# define XMM_sig(p,i) ((p)->Xmm##i)
# define EIP_sig(p) ((p)->Eip)
# define EBP_sig(p) ((p)->Ebp)
# define ESP_sig(p) ((p)->Esp)
# define RIP_sig(p) ((p)->Rip)
# define RAX_sig(p) ((p)->Rax)
# define RCX_sig(p) ((p)->Rcx)
# define RDX_sig(p) ((p)->Rdx)
# define RBX_sig(p) ((p)->Rbx)
# define RSP_sig(p) ((p)->Rsp)
# define RBP_sig(p) ((p)->Rbp)
# define RSI_sig(p) ((p)->Rsi)
# define RDI_sig(p) ((p)->Rdi)
# define R8_sig(p) ((p)->R8)
# define R9_sig(p) ((p)->R9)
# define R10_sig(p) ((p)->R10)
# define R11_sig(p) ((p)->R11)
# define R12_sig(p) ((p)->R12)
# define R13_sig(p) ((p)->R13)
# define R14_sig(p) ((p)->R14)
# define R15_sig(p) ((p)->R15)
#elif defined(__OpenBSD__)
# define XMM_sig(p,i) ((p)->sc_fpstate->fx_xmm[i])
# define EIP_sig(p) ((p)->sc_eip)
# define EBP_sig(p) ((p)->sc_ebp)
# define ESP_sig(p) ((p)->sc_esp)
# define RIP_sig(p) ((p)->sc_rip)
# define RAX_sig(p) ((p)->sc_rax)
# define RCX_sig(p) ((p)->sc_rcx)
# define RDX_sig(p) ((p)->sc_rdx)
# define RBX_sig(p) ((p)->sc_rbx)
# define RSP_sig(p) ((p)->sc_rsp)
# define RBP_sig(p) ((p)->sc_rbp)
# define RSI_sig(p) ((p)->sc_rsi)
# define RDI_sig(p) ((p)->sc_rdi)
# define R8_sig(p) ((p)->sc_r8)
# define R9_sig(p) ((p)->sc_r9)
# define R10_sig(p) ((p)->sc_r10)
# define R11_sig(p) ((p)->sc_r11)
# define R12_sig(p) ((p)->sc_r12)
# if defined(__arm__)
#  define R13_sig(p) ((p)->sc_usr_sp)
#  define R14_sig(p) ((p)->sc_usr_lr)
#  define R15_sig(p) ((p)->sc_pc)
# else
#  define R13_sig(p) ((p)->sc_r13)
#  define R14_sig(p) ((p)->sc_r14)
#  define R15_sig(p) ((p)->sc_r15)
# endif
# if defined(__aarch64__)
#  define EPC_sig(p) ((p)->sc_elr)
#  define RFP_sig(p) ((p)->sc_x[29])
#  define RLR_sig(p) ((p)->sc_lr)
#  define R31_sig(p) ((p)->sc_sp)
# endif
# if defined(__mips__)
#  define EPC_sig(p) ((p)->sc_pc)
#  define RFP_sig(p) ((p)->sc_regs[30])
# endif
#elif defined(__linux__) || defined(__sun)
# if defined(__linux__)
#  define XMM_sig(p,i) ((p)->uc_mcontext.fpregs->_xmm[i])
#  define EIP_sig(p) ((p)->uc_mcontext.gregs[REG_EIP])
#  define EBP_sig(p) ((p)->uc_mcontext.gregs[REG_EBP])
#  define ESP_sig(p) ((p)->uc_mcontext.gregs[REG_ESP])
# else
#  define XMM_sig(p,i) ((p)->uc_mcontext.fpregs.fp_reg_set.fpchip_state.xmm[i])
#  define EIP_sig(p) ((p)->uc_mcontext.gregs[REG_PC])
#  define EBP_sig(p) ((p)->uc_mcontext.gregs[REG_EBP])
#  define ESP_sig(p) ((p)->uc_mcontext.gregs[REG_ESP])
# endif
# define RIP_sig(p) ((p)->uc_mcontext.gregs[REG_RIP])
# define RAX_sig(p) ((p)->uc_mcontext.gregs[REG_RAX])
# define RCX_sig(p) ((p)->uc_mcontext.gregs[REG_RCX])
# define RDX_sig(p) ((p)->uc_mcontext.gregs[REG_RDX])
# define RBX_sig(p) ((p)->uc_mcontext.gregs[REG_RBX])
# define RSP_sig(p) ((p)->uc_mcontext.gregs[REG_RSP])
# define RBP_sig(p) ((p)->uc_mcontext.gregs[REG_RBP])
# define RSI_sig(p) ((p)->uc_mcontext.gregs[REG_RSI])
# define RDI_sig(p) ((p)->uc_mcontext.gregs[REG_RDI])
# define R8_sig(p) ((p)->uc_mcontext.gregs[REG_R8])
# define R9_sig(p) ((p)->uc_mcontext.gregs[REG_R9])
# define R10_sig(p) ((p)->uc_mcontext.gregs[REG_R10])
# define R12_sig(p) ((p)->uc_mcontext.gregs[REG_R12])
# if defined(__linux__) && defined(__arm__)
#  define R11_sig(p) ((p)->uc_mcontext.arm_fp)
#  define R13_sig(p) ((p)->uc_mcontext.arm_sp)
#  define R14_sig(p) ((p)->uc_mcontext.arm_lr)
#  define R15_sig(p) ((p)->uc_mcontext.arm_pc)
# else
#  define R11_sig(p) ((p)->uc_mcontext.gregs[REG_R11])
#  define R13_sig(p) ((p)->uc_mcontext.gregs[REG_R13])
#  define R14_sig(p) ((p)->uc_mcontext.gregs[REG_R14])
#  define R15_sig(p) ((p)->uc_mcontext.gregs[REG_R15])
# endif
# if defined(__linux__) && defined(__aarch64__)
#  define EPC_sig(p) ((p)->uc_mcontext.pc)
#  define RFP_sig(p) ((p)->uc_mcontext.regs[29])
#  define RLR_sig(p) ((p)->uc_mcontext.regs[30])
#  define R31_sig(p) ((p)->uc_mcontext.regs[31])
# endif
# if defined(__linux__) && defined(__mips__)
#  define EPC_sig(p) ((p)->uc_mcontext.pc)
#  define RFP_sig(p) ((p)->uc_mcontext.gregs[30])
# endif
#elif defined(__NetBSD__)
# define XMM_sig(p,i) (((struct fxsave64*)(p)->uc_mcontext.__fpregs)->fx_xmm[i])
# define EIP_sig(p) ((p)->uc_mcontext.__gregs[_REG_EIP])
# define EBP_sig(p) ((p)->uc_mcontext.__gregs[_REG_EBP])
# define ESP_sig(p) ((p)->uc_mcontext.__gregs[_REG_ESP])
# define RIP_sig(p) ((p)->uc_mcontext.__gregs[_REG_RIP])
# define RAX_sig(p) ((p)->uc_mcontext.__gregs[_REG_RAX])
# define RCX_sig(p) ((p)->uc_mcontext.__gregs[_REG_RCX])
# define RDX_sig(p) ((p)->uc_mcontext.__gregs[_REG_RDX])
# define RBX_sig(p) ((p)->uc_mcontext.__gregs[_REG_RBX])
# define RSP_sig(p) ((p)->uc_mcontext.__gregs[_REG_RSP])
# define RBP_sig(p) ((p)->uc_mcontext.__gregs[_REG_RBP])
# define RSI_sig(p) ((p)->uc_mcontext.__gregs[_REG_RSI])
# define RDI_sig(p) ((p)->uc_mcontext.__gregs[_REG_RDI])
# define R8_sig(p) ((p)->uc_mcontext.__gregs[_REG_R8])
# define R9_sig(p) ((p)->uc_mcontext.__gregs[_REG_R9])
# define R10_sig(p) ((p)->uc_mcontext.__gregs[_REG_R10])
# define R11_sig(p) ((p)->uc_mcontext.__gregs[_REG_R11])
# define R12_sig(p) ((p)->uc_mcontext.__gregs[_REG_R12])
# define R13_sig(p) ((p)->uc_mcontext.__gregs[_REG_R13])
# define R14_sig(p) ((p)->uc_mcontext.__gregs[_REG_R14])
# define R15_sig(p) ((p)->uc_mcontext.__gregs[_REG_R15])
# if defined(__aarch64__)
#  define EPC_sig(p) ((p)->uc_mcontext.__gregs[_REG_PC])
#  define RFP_sig(p) ((p)->uc_mcontext.__gregs[_REG_X29])
#  define RLR_sig(p) ((p)->uc_mcontext.__gregs[_REG_X30])
#  define R31_sig(p) ((p)->uc_mcontext.__gregs[_REG_SP])
# endif
# if defined(__mips__)
#  define EPC_sig(p) ((p)->uc_mcontext.__gregs[_REG_EPC])
#  define RFP_sig(p) ((p)->uc_mcontext.__gregs[_REG_S8])
# endif
#elif defined(__DragonFly__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
# if defined(__DragonFly__)
#  define XMM_sig(p,i) (((union savefpu*)(p)->uc_mcontext.mc_fpregs)->sv_xmm.sv_xmm[i])
# else
#  define XMM_sig(p,i) (((struct savefpu*)(p)->uc_mcontext.mc_fpstate)->sv_xmm[i])
# endif
# define EIP_sig(p) ((p)->uc_mcontext.mc_eip)
# define EBP_sig(p) ((p)->uc_mcontext.mc_ebp)
# define ESP_sig(p) ((p)->uc_mcontext.mc_esp)
# define RIP_sig(p) ((p)->uc_mcontext.mc_rip)
# define RAX_sig(p) ((p)->uc_mcontext.mc_rax)
# define RCX_sig(p) ((p)->uc_mcontext.mc_rcx)
# define RDX_sig(p) ((p)->uc_mcontext.mc_rdx)
# define RBX_sig(p) ((p)->uc_mcontext.mc_rbx)
# define RSP_sig(p) ((p)->uc_mcontext.mc_rsp)
# define RBP_sig(p) ((p)->uc_mcontext.mc_rbp)
# define RSI_sig(p) ((p)->uc_mcontext.mc_rsi)
# define RDI_sig(p) ((p)->uc_mcontext.mc_rdi)
# define R8_sig(p) ((p)->uc_mcontext.mc_r8)
# define R9_sig(p) ((p)->uc_mcontext.mc_r9)
# define R10_sig(p) ((p)->uc_mcontext.mc_r10)
# define R12_sig(p) ((p)->uc_mcontext.mc_r12)
# if defined(__FreeBSD__) && defined(__arm__)
#  define R11_sig(p) ((p)->uc_mcontext.__gregs[_REG_R11])
#  define R13_sig(p) ((p)->uc_mcontext.__gregs[_REG_R13])
#  define R14_sig(p) ((p)->uc_mcontext.__gregs[_REG_R14])
#  define R15_sig(p) ((p)->uc_mcontext.__gregs[_REG_R15])
# else
#  define R11_sig(p) ((p)->uc_mcontext.mc_r11)
#  define R13_sig(p) ((p)->uc_mcontext.mc_r13)
#  define R14_sig(p) ((p)->uc_mcontext.mc_r14)
#  define R15_sig(p) ((p)->uc_mcontext.mc_r15)
# endif
# if defined(__FreeBSD__) && defined(__aarch64__)
#  define EPC_sig(p) ((p)->uc_mcontext.mc_gpregs.gp_elr)
#  define RFP_sig(p) ((p)->uc_mcontext.mc_gpregs.gp_x[29])
#  define RLR_sig(p) ((p)->uc_mcontext.mc_gpregs.gp_lr)
#  define R31_sig(p) ((p)->uc_mcontext.mc_gpregs.gp_sp)
# endif
# if defined(__FreeBSD__) && defined(__mips__)
#  define EPC_sig(p) ((p)->uc_mcontext.mc_pc)
#  define RFP_sig(p) ((p)->uc_mcontext.mc_regs[30])
# endif
#elif defined(XP_DARWIN)
# define EIP_sig(p) ((p)->uc_mcontext->__ss.__eip)
# define EBP_sig(p) ((p)->uc_mcontext->__ss.__ebp)
# define ESP_sig(p) ((p)->uc_mcontext->__ss.__esp)
# define RIP_sig(p) ((p)->uc_mcontext->__ss.__rip)
# define RBP_sig(p) ((p)->uc_mcontext->__ss.__rbp)
# define RSP_sig(p) ((p)->uc_mcontext->__ss.__rsp)
# define R15_sig(p) ((p)->uc_mcontext->__ss.__pc)
#else
# error "Don't know how to read/write to the thread state via the mcontext_t."
#endif

#if defined(XP_WIN)
# include "jswin.h"
#else
# include <signal.h>
# include <sys/mman.h>
#endif

#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
# include <sys/ucontext.h> // for ucontext_t, mcontext_t
#endif

#if defined(__x86_64__)
# if defined(__DragonFly__)
#  include <machine/npx.h> // for union savefpu
# elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || \
       defined(__NetBSD__) || defined(__OpenBSD__)
#  include <machine/fpu.h> // for struct savefpu/fxsave64
# endif
#endif

#if defined(ANDROID)
// Not all versions of the Android NDK define ucontext_t or mcontext_t.
// Detect this and provide custom but compatible definitions. Note that these
// follow the GLibc naming convention to access register values from
// mcontext_t.
//
// See: https://chromiumcodereview.appspot.com/10829122/
// See: http://code.google.com/p/android/issues/detail?id=34784
# if !defined(__BIONIC_HAVE_UCONTEXT_T)
#  if defined(__arm__)

// GLibc on ARM defines mcontext_t has a typedef for 'struct sigcontext'.
// Old versions of the C library <signal.h> didn't define the type.
#   if !defined(__BIONIC_HAVE_STRUCT_SIGCONTEXT)
#    include <asm/sigcontext.h>
#   endif

typedef struct sigcontext mcontext_t;

typedef struct ucontext {
    uint32_t uc_flags;
    struct ucontext* uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    // Other fields are not used so don't define them here.
} ucontext_t;

#  elif defined(__mips__)

typedef struct {
    uint32_t regmask;
    uint32_t status;
    uint64_t pc;
    uint64_t gregs[32];
    uint64_t fpregs[32];
    uint32_t acx;
    uint32_t fpc_csr;
    uint32_t fpc_eir;
    uint32_t used_math;
    uint32_t dsp;
    uint64_t mdhi;
    uint64_t mdlo;
    uint32_t hi1;
    uint32_t lo1;
    uint32_t hi2;
    uint32_t lo2;
    uint32_t hi3;
    uint32_t lo3;
} mcontext_t;

typedef struct ucontext {
    uint32_t uc_flags;
    struct ucontext* uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    // Other fields are not used so don't define them here.
} ucontext_t;

#  elif defined(__i386__)
// x86 version for Android.
typedef struct {
    uint32_t gregs[19];
    void* fpregs;
    uint32_t oldmask;
    uint32_t cr2;
} mcontext_t;

typedef uint32_t kernel_sigset_t[2];  // x86 kernel uses 64-bit signal masks
typedef struct ucontext {
    uint32_t uc_flags;
    struct ucontext* uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    // Other fields are not used by V8, don't define them here.
} ucontext_t;
enum { REG_EIP = 14 };
#  endif  // defined(__i386__)
# endif  // !defined(__BIONIC_HAVE_UCONTEXT_T)
#endif // defined(ANDROID)

#if !defined(XP_WIN)
# define CONTEXT ucontext_t
#endif

// Define a context type for use in the emulator code. This is usually just
// the same as CONTEXT, but on Mac we use a different structure since we call
// into the emulator code from a Mach exception handler rather than a
// sigaction-style signal handler.
#if defined(XP_DARWIN)
# if defined(__x86_64__)
struct macos_x64_context {
    x86_thread_state64_t thread;
    x86_float_state64_t float_;
};
#  define EMULATOR_CONTEXT macos_x64_context
# elif defined(__i386__)
struct macos_x86_context {
    x86_thread_state_t thread;
    x86_float_state_t float_;
};
#  define EMULATOR_CONTEXT macos_x86_context
# elif defined(__arm__)
struct macos_arm_context {
    arm_thread_state_t thread;
    arm_neon_state_t float_;
};
#  define EMULATOR_CONTEXT macos_arm_context
# else
#  error Unsupported architecture
# endif
#else
# define EMULATOR_CONTEXT CONTEXT
#endif

#if defined(_M_X64) || defined(__x86_64__)
# define PC_sig(p) RIP_sig(p)
# define FP_sig(p) RBP_sig(p)
# define SP_sig(p) RSP_sig(p)
#elif defined(_M_IX86) || defined(__i386__)
# define PC_sig(p) EIP_sig(p)
# define FP_sig(p) EBP_sig(p)
# define SP_sig(p) ESP_sig(p)
#elif defined(__arm__)
# define FP_sig(p) R11_sig(p)
# define SP_sig(p) R13_sig(p)
# define LR_sig(p) R14_sig(p)
# define PC_sig(p) R15_sig(p)
#elif defined(__aarch64__)
# define PC_sig(p) EPC_sig(p)
# define FP_sig(p) RFP_sig(p)
# define SP_sig(p) R31_sig(p)
# define LR_sig(p) RLR_sig(p)
#elif defined(__mips__)
# define PC_sig(p) EPC_sig(p)
# define FP_sig(p) RFP_sig(p)
#endif

static uint8_t**
ContextToPC(CONTEXT* context)
{
#ifdef JS_CODEGEN_NONE
    MOZ_CRASH();
#else
    return reinterpret_cast<uint8_t**>(&PC_sig(context));
#endif
}

static uint8_t*
ContextToFP(CONTEXT* context)
{
#ifdef JS_CODEGEN_NONE
    MOZ_CRASH();
#else
    return reinterpret_cast<uint8_t*>(FP_sig(context));
#endif
}

#ifndef JS_CODEGEN_NONE
static uint8_t*
ContextToSP(CONTEXT* context)
{
    return reinterpret_cast<uint8_t*>(SP_sig(context));
}
#endif

#if defined(__arm__) || defined(__aarch64__)
static uint8_t*
ContextToLR(CONTEXT* context)
{
    return reinterpret_cast<uint8_t*>(LR_sig(context));
}
#endif

#if defined(XP_DARWIN)

static uint8_t**
ContextToPC(EMULATOR_CONTEXT* context)
{
# if defined(__x86_64__)
    static_assert(sizeof(context->thread.__rip) == sizeof(void*),
                  "stored IP should be compile-time pointer-sized");
    return reinterpret_cast<uint8_t**>(&context->thread.__rip);
# elif defined(__i386__)
    static_assert(sizeof(context->thread.uts.ts32.__eip) == sizeof(void*),
                  "stored IP should be compile-time pointer-sized");
    return reinterpret_cast<uint8_t**>(&context->thread.uts.ts32.__eip);
# elif defined(__arm__)
    static_assert(sizeof(context->thread.__pc) == sizeof(void*),
                  "stored IP should be compile-time pointer-sized");
    return reinterpret_cast<uint8_t**>(&context->thread.__pc);
# else
#  error Unsupported architecture
# endif
}

static uint8_t*
ContextToFP(EMULATOR_CONTEXT* context)
{
# if defined(__x86_64__)
    return (uint8_t*)context->thread.__rbp;
# elif defined(__i386__)
    return (uint8_t*)context->thread.uts.ts32.__ebp;
# elif defined(__arm__)
    return (uint8_t*)context->thread.__fp;
# else
#  error Unsupported architecture
# endif
}

static uint8_t*
ContextToSP(EMULATOR_CONTEXT* context)
{
# if defined(__x86_64__)
    return (uint8_t*)context->thread.__rsp;
# elif defined(__i386__)
    return (uint8_t*)context->thread.uts.ts32.__esp;
# elif defined(__arm__)
    return (uint8_t*)context->thread.__sp;
# else
#  error Unsupported architecture
# endif
}

static JS::ProfilingFrameIterator::RegisterState
ToRegisterState(EMULATOR_CONTEXT* context)
{
    JS::ProfilingFrameIterator::RegisterState state;
    state.fp = ContextToFP(context);
    state.pc = *ContextToPC(context);
    state.sp = ContextToSP(context);
    // no ARM on Darwin => don't fill state.lr.
    return state;
}
#endif // XP_DARWIN

static JS::ProfilingFrameIterator::RegisterState
ToRegisterState(CONTEXT* context)
{
#ifdef JS_CODEGEN_NONE
    MOZ_CRASH();
#else
    JS::ProfilingFrameIterator::RegisterState state;
    state.fp = ContextToFP(context);
    state.pc = *ContextToPC(context);
    state.sp = ContextToSP(context);
# if defined(__arm__) || defined(__aarch64__)
    state.lr = ContextToLR(context);
# endif
    return state;
#endif
}

#if defined(WASM_HUGE_MEMORY)
MOZ_COLD static void
SetFPRegToNaN(size_t size, void* fp_reg)
{
    MOZ_RELEASE_ASSERT(size <= Simd128DataSize);
    memset(fp_reg, 0, Simd128DataSize);
    switch (size) {
      case 4: *static_cast<float*>(fp_reg) = GenericNaN(); break;
      case 8: *static_cast<double*>(fp_reg) = GenericNaN(); break;
      default:
        // All SIMD accesses throw on OOB.
        MOZ_CRASH("unexpected size in SetFPRegToNaN");
    }
}

MOZ_COLD static void
SetGPRegToZero(void* gp_reg)
{
    memset(gp_reg, 0, sizeof(intptr_t));
}

MOZ_COLD static void
SetFPRegToLoadedValue(SharedMem<void*> addr, size_t size, void* fp_reg)
{
    MOZ_RELEASE_ASSERT(size <= Simd128DataSize);
    memset(fp_reg, 0, Simd128DataSize);
    AtomicOperations::memcpySafeWhenRacy(fp_reg, addr, size);
}

MOZ_COLD static void
SetGPRegToLoadedValue(SharedMem<void*> addr, size_t size, void* gp_reg)
{
    MOZ_RELEASE_ASSERT(size <= sizeof(void*));
    memset(gp_reg, 0, sizeof(void*));
    AtomicOperations::memcpySafeWhenRacy(gp_reg, addr, size);
}

MOZ_COLD static void
SetGPRegToLoadedValueSext32(SharedMem<void*> addr, size_t size, void* gp_reg)
{
    MOZ_RELEASE_ASSERT(size <= sizeof(int32_t));
    int8_t msb = AtomicOperations::loadSafeWhenRacy(addr.cast<uint8_t*>() + (size - 1));
    memset(gp_reg, 0, sizeof(void*));
    memset(gp_reg, msb >> 7, sizeof(int32_t));
    AtomicOperations::memcpySafeWhenRacy(gp_reg, addr, size);
}

MOZ_COLD static void
StoreValueFromFPReg(SharedMem<void*> addr, size_t size, const void* fp_reg)
{
    MOZ_RELEASE_ASSERT(size <= Simd128DataSize);
    AtomicOperations::memcpySafeWhenRacy(addr, const_cast<void*>(fp_reg), size);
}

MOZ_COLD static void
StoreValueFromGPReg(SharedMem<void*> addr, size_t size, const void* gp_reg)
{
    MOZ_RELEASE_ASSERT(size <= sizeof(void*));
    AtomicOperations::memcpySafeWhenRacy(addr, const_cast<void*>(gp_reg), size);
}

MOZ_COLD static void
StoreValueFromGPImm(SharedMem<void*> addr, size_t size, int32_t imm)
{
    MOZ_RELEASE_ASSERT(size <= sizeof(imm));
    AtomicOperations::memcpySafeWhenRacy(addr, static_cast<void*>(&imm), size);
}

# if !defined(XP_DARWIN)
MOZ_COLD static void*
AddressOfFPRegisterSlot(CONTEXT* context, FloatRegisters::Encoding encoding)
{
    switch (encoding) {
      case X86Encoding::xmm0:  return &XMM_sig(context, 0);
      case X86Encoding::xmm1:  return &XMM_sig(context, 1);
      case X86Encoding::xmm2:  return &XMM_sig(context, 2);
      case X86Encoding::xmm3:  return &XMM_sig(context, 3);
      case X86Encoding::xmm4:  return &XMM_sig(context, 4);
      case X86Encoding::xmm5:  return &XMM_sig(context, 5);
      case X86Encoding::xmm6:  return &XMM_sig(context, 6);
      case X86Encoding::xmm7:  return &XMM_sig(context, 7);
      case X86Encoding::xmm8:  return &XMM_sig(context, 8);
      case X86Encoding::xmm9:  return &XMM_sig(context, 9);
      case X86Encoding::xmm10: return &XMM_sig(context, 10);
      case X86Encoding::xmm11: return &XMM_sig(context, 11);
      case X86Encoding::xmm12: return &XMM_sig(context, 12);
      case X86Encoding::xmm13: return &XMM_sig(context, 13);
      case X86Encoding::xmm14: return &XMM_sig(context, 14);
      case X86Encoding::xmm15: return &XMM_sig(context, 15);
      default: break;
    }
    MOZ_CRASH();
}

MOZ_COLD static void*
AddressOfGPRegisterSlot(EMULATOR_CONTEXT* context, Registers::Code code)
{
    switch (code) {
      case X86Encoding::rax: return &RAX_sig(context);
      case X86Encoding::rcx: return &RCX_sig(context);
      case X86Encoding::rdx: return &RDX_sig(context);
      case X86Encoding::rbx: return &RBX_sig(context);
      case X86Encoding::rsp: return &RSP_sig(context);
      case X86Encoding::rbp: return &RBP_sig(context);
      case X86Encoding::rsi: return &RSI_sig(context);
      case X86Encoding::rdi: return &RDI_sig(context);
      case X86Encoding::r8:  return &R8_sig(context);
      case X86Encoding::r9:  return &R9_sig(context);
      case X86Encoding::r10: return &R10_sig(context);
      case X86Encoding::r11: return &R11_sig(context);
      case X86Encoding::r12: return &R12_sig(context);
      case X86Encoding::r13: return &R13_sig(context);
      case X86Encoding::r14: return &R14_sig(context);
      case X86Encoding::r15: return &R15_sig(context);
      default: break;
    }
    MOZ_CRASH();
}
# else
MOZ_COLD static void*
AddressOfFPRegisterSlot(EMULATOR_CONTEXT* context, FloatRegisters::Encoding encoding)
{
    switch (encoding) {
      case X86Encoding::xmm0:  return &context->float_.__fpu_xmm0;
      case X86Encoding::xmm1:  return &context->float_.__fpu_xmm1;
      case X86Encoding::xmm2:  return &context->float_.__fpu_xmm2;
      case X86Encoding::xmm3:  return &context->float_.__fpu_xmm3;
      case X86Encoding::xmm4:  return &context->float_.__fpu_xmm4;
      case X86Encoding::xmm5:  return &context->float_.__fpu_xmm5;
      case X86Encoding::xmm6:  return &context->float_.__fpu_xmm6;
      case X86Encoding::xmm7:  return &context->float_.__fpu_xmm7;
      case X86Encoding::xmm8:  return &context->float_.__fpu_xmm8;
      case X86Encoding::xmm9:  return &context->float_.__fpu_xmm9;
      case X86Encoding::xmm10: return &context->float_.__fpu_xmm10;
      case X86Encoding::xmm11: return &context->float_.__fpu_xmm11;
      case X86Encoding::xmm12: return &context->float_.__fpu_xmm12;
      case X86Encoding::xmm13: return &context->float_.__fpu_xmm13;
      case X86Encoding::xmm14: return &context->float_.__fpu_xmm14;
      case X86Encoding::xmm15: return &context->float_.__fpu_xmm15;
      default: break;
    }
    MOZ_CRASH();
}

MOZ_COLD static void*
AddressOfGPRegisterSlot(EMULATOR_CONTEXT* context, Registers::Code code)
{
    switch (code) {
      case X86Encoding::rax: return &context->thread.__rax;
      case X86Encoding::rcx: return &context->thread.__rcx;
      case X86Encoding::rdx: return &context->thread.__rdx;
      case X86Encoding::rbx: return &context->thread.__rbx;
      case X86Encoding::rsp: return &context->thread.__rsp;
      case X86Encoding::rbp: return &context->thread.__rbp;
      case X86Encoding::rsi: return &context->thread.__rsi;
      case X86Encoding::rdi: return &context->thread.__rdi;
      case X86Encoding::r8:  return &context->thread.__r8;
      case X86Encoding::r9:  return &context->thread.__r9;
      case X86Encoding::r10: return &context->thread.__r10;
      case X86Encoding::r11: return &context->thread.__r11;
      case X86Encoding::r12: return &context->thread.__r12;
      case X86Encoding::r13: return &context->thread.__r13;
      case X86Encoding::r14: return &context->thread.__r14;
      case X86Encoding::r15: return &context->thread.__r15;
      default: break;
    }
    MOZ_CRASH();
}
# endif  // !XP_DARWIN

MOZ_COLD static void
SetRegisterToCoercedUndefined(EMULATOR_CONTEXT* context, size_t size,
                              const Disassembler::OtherOperand& value)
{
    if (value.kind() == Disassembler::OtherOperand::FPR)
        SetFPRegToNaN(size, AddressOfFPRegisterSlot(context, value.fpr()));
    else
        SetGPRegToZero(AddressOfGPRegisterSlot(context, value.gpr()));
}

MOZ_COLD static void
SetRegisterToLoadedValue(EMULATOR_CONTEXT* context, SharedMem<void*> addr, size_t size,
                         const Disassembler::OtherOperand& value)
{
    if (value.kind() == Disassembler::OtherOperand::FPR)
        SetFPRegToLoadedValue(addr, size, AddressOfFPRegisterSlot(context, value.fpr()));
    else
        SetGPRegToLoadedValue(addr, size, AddressOfGPRegisterSlot(context, value.gpr()));
}

MOZ_COLD static void
SetRegisterToLoadedValueSext32(EMULATOR_CONTEXT* context, SharedMem<void*> addr, size_t size,
                               const Disassembler::OtherOperand& value)
{
    SetGPRegToLoadedValueSext32(addr, size, AddressOfGPRegisterSlot(context, value.gpr()));
}

MOZ_COLD static void
StoreValueFromRegister(EMULATOR_CONTEXT* context, SharedMem<void*> addr, size_t size,
                       const Disassembler::OtherOperand& value)
{
    if (value.kind() == Disassembler::OtherOperand::FPR)
        StoreValueFromFPReg(addr, size, AddressOfFPRegisterSlot(context, value.fpr()));
    else if (value.kind() == Disassembler::OtherOperand::GPR)
        StoreValueFromGPReg(addr, size, AddressOfGPRegisterSlot(context, value.gpr()));
    else
        StoreValueFromGPImm(addr, size, value.imm());
}

MOZ_COLD static uint8_t*
ComputeAccessAddress(EMULATOR_CONTEXT* context, const Disassembler::ComplexAddress& address)
{
    MOZ_RELEASE_ASSERT(!address.isPCRelative(), "PC-relative addresses not supported yet");

    uintptr_t result = address.disp();

    if (address.hasBase()) {
        uintptr_t base;
        StoreValueFromGPReg(SharedMem<void*>::unshared(&base), sizeof(uintptr_t),
                            AddressOfGPRegisterSlot(context, address.base()));
        result += base;
    }

    if (address.hasIndex()) {
        uintptr_t index;
        StoreValueFromGPReg(SharedMem<void*>::unshared(&index), sizeof(uintptr_t),
                            AddressOfGPRegisterSlot(context, address.index()));
        MOZ_ASSERT(address.scale() < 32, "address shift overflow");
        result += index * (uintptr_t(1) << address.scale());
    }

    return reinterpret_cast<uint8_t*>(result);
}

MOZ_COLD static void
HandleMemoryAccess(EMULATOR_CONTEXT* context, uint8_t* pc, uint8_t* faultingAddress,
                   const Instance& instance, WasmActivation* activation, uint8_t** ppc)
{
    MOZ_RELEASE_ASSERT(instance.code().containsFunctionPC(pc));

    const CodeSegment* segment;
    const MemoryAccess* memoryAccess = instance.code().lookupMemoryAccess(pc, &segment);
    if (!memoryAccess) {
        // If there is no associated MemoryAccess for the faulting PC, this must be
        // experimental SIMD.js or Atomics. When these are converted to
        // non-experimental wasm features, this case, as well as outOfBoundsCode,
        // can be removed.
        activation->startInterrupt(ToRegisterState(context));
        if (!instance.code().containsCodePC(pc, &segment))
            MOZ_CRASH("Cannot map PC to trap handler");
        *ppc = segment->outOfBoundsCode();
        return;
    }

    MOZ_RELEASE_ASSERT(memoryAccess->insnOffset() == (pc - segment->base()));

    // On WASM_HUGE_MEMORY platforms, asm.js code may fault. asm.js does not
    // trap on fault and so has no trap out-of-line path. Instead, stores are
    // silently ignored (by advancing the pc past the store and resuming) and
    // loads silently succeed with a JS-semantics-determined value.

    if (memoryAccess->hasTrapOutOfLineCode()) {
        *ppc = memoryAccess->trapOutOfLineCode(segment->base());
        return;
    }

    MOZ_RELEASE_ASSERT(instance.isAsmJS());

    // Disassemble the instruction which caused the trap so that we can extract
    // information about it and decide what to do.
    Disassembler::HeapAccess access;
    uint8_t* end = Disassembler::DisassembleHeapAccess(pc, &access);
    const Disassembler::ComplexAddress& address = access.address();
    MOZ_RELEASE_ASSERT(end > pc);
    MOZ_RELEASE_ASSERT(segment->containsFunctionPC(end));

    // Check x64 asm.js heap access invariants.
    MOZ_RELEASE_ASSERT(address.disp() >= 0);
    MOZ_RELEASE_ASSERT(address.base() == HeapReg.code());
    MOZ_RELEASE_ASSERT(!address.hasIndex() || address.index() != HeapReg.code());
    MOZ_RELEASE_ASSERT(address.scale() == 0);
    if (address.hasBase()) {
        uintptr_t base;
        StoreValueFromGPReg(SharedMem<void*>::unshared(&base), sizeof(uintptr_t),
                            AddressOfGPRegisterSlot(context, address.base()));
        MOZ_RELEASE_ASSERT(reinterpret_cast<uint8_t*>(base) == instance.memoryBase());
    }
    if (address.hasIndex()) {
        uintptr_t index;
        StoreValueFromGPReg(SharedMem<void*>::unshared(&index), sizeof(uintptr_t),
                            AddressOfGPRegisterSlot(context, address.index()));
        MOZ_RELEASE_ASSERT(uint32_t(index) == index);
    }

    // Determine the actual effective address of the faulting access. We can't
    // rely on the faultingAddress given to us by the OS, because we need the
    // address of the start of the access, and the OS may sometimes give us an
    // address somewhere in the middle of the heap access.
    uint8_t* accessAddress = ComputeAccessAddress(context, address);
    MOZ_RELEASE_ASSERT(size_t(faultingAddress - accessAddress) < access.size(),
                       "Given faulting address does not appear to be within computed "
                       "faulting address range");
    MOZ_RELEASE_ASSERT(accessAddress >= instance.memoryBase(),
                       "Access begins outside the asm.js heap");
    MOZ_RELEASE_ASSERT(accessAddress + access.size() <= instance.memoryBase() +
                       instance.memoryMappedSize(),
                       "Access extends beyond the asm.js heap guard region");
    MOZ_RELEASE_ASSERT(accessAddress + access.size() > instance.memoryBase() +
                       instance.memoryLength(),
                       "Computed access address is not actually out of bounds");

    // The basic sandbox model is that all heap accesses are a heap base
    // register plus an index, and the index is always computed with 32-bit
    // operations, so we know it can only be 4 GiB off of the heap base.
    //
    // However, we wish to support the optimization of folding immediates
    // and scaled indices into addresses, and any address arithmetic we fold
    // gets done at full pointer width, so it doesn't get properly wrapped.
    // We support this by extending HugeMappedSize to the greatest size that
    // could be reached by such an unwrapped address, and then when we arrive
    // here in the signal handler for such an access, we compute the fully
    // wrapped address, and perform the load or store on it.
    //
    // Taking a signal is really slow, but in theory programs really shouldn't
    // be hitting this anyway.
    intptr_t unwrappedOffset = accessAddress - instance.memoryBase().unwrap(/* for value */);
    uint32_t wrappedOffset = uint32_t(unwrappedOffset);
    size_t size = access.size();
    MOZ_RELEASE_ASSERT(wrappedOffset + size > wrappedOffset);
    bool inBounds = wrappedOffset + size < instance.memoryLength();

    if (inBounds) {
        // We now know that this is an access that is actually in bounds when
        // properly wrapped. Complete the load or store with the wrapped
        // address.
        SharedMem<uint8_t*> wrappedAddress = instance.memoryBase() + wrappedOffset;
        MOZ_RELEASE_ASSERT(wrappedAddress >= instance.memoryBase());
        MOZ_RELEASE_ASSERT(wrappedAddress + size > wrappedAddress);
        MOZ_RELEASE_ASSERT(wrappedAddress + size <= instance.memoryBase() + instance.memoryLength());
        switch (access.kind()) {
          case Disassembler::HeapAccess::Load:
            SetRegisterToLoadedValue(context, wrappedAddress.cast<void*>(), size, access.otherOperand());
            break;
          case Disassembler::HeapAccess::LoadSext32:
            SetRegisterToLoadedValueSext32(context, wrappedAddress.cast<void*>(), size, access.otherOperand());
            break;
          case Disassembler::HeapAccess::Store:
            StoreValueFromRegister(context, wrappedAddress.cast<void*>(), size, access.otherOperand());
            break;
          case Disassembler::HeapAccess::LoadSext64:
            MOZ_CRASH("no int64 accesses in asm.js");
          case Disassembler::HeapAccess::Unknown:
            MOZ_CRASH("Failed to disassemble instruction");
        }
    } else {
        // We now know that this is an out-of-bounds access made by an asm.js
        // load/store that we should handle.
        switch (access.kind()) {
          case Disassembler::HeapAccess::Load:
          case Disassembler::HeapAccess::LoadSext32:
            // Assign the JS-defined result value to the destination register
            // (ToInt32(undefined) or ToNumber(undefined), determined by the
            // type of the destination register). Very conveniently, we can
            // infer the type from the register class, since all SIMD accesses
            // throw on out of bounds (see above), so the only types using FP
            // registers are float32 and double.
            SetRegisterToCoercedUndefined(context, access.size(), access.otherOperand());
            break;
          case Disassembler::HeapAccess::Store:
            // Do nothing.
            break;
          case Disassembler::HeapAccess::LoadSext64:
            MOZ_CRASH("no int64 accesses in asm.js");
          case Disassembler::HeapAccess::Unknown:
            MOZ_CRASH("Failed to disassemble instruction");
        }
    }

    *ppc = end;
}

#else // WASM_HUGE_MEMORY

MOZ_COLD static void
HandleMemoryAccess(EMULATOR_CONTEXT* context, uint8_t* pc, uint8_t* faultingAddress,
                   const Instance& instance, WasmActivation* activation, uint8_t** ppc)
{
    MOZ_RELEASE_ASSERT(instance.code().containsFunctionPC(pc));

    const CodeSegment* segment;
    const MemoryAccess* memoryAccess = instance.code().lookupMemoryAccess(pc, &segment);
    if (!memoryAccess) {
        // See explanation in the WASM_HUGE_MEMORY HandleMemoryAccess.
        activation->startInterrupt(ToRegisterState(context));
        if (!instance.code().containsCodePC(pc, &segment))
            MOZ_CRASH("Cannot map PC to trap handler");
        *ppc = segment->outOfBoundsCode();
        return;
    }

    MOZ_RELEASE_ASSERT(memoryAccess->hasTrapOutOfLineCode());
    *ppc = memoryAccess->trapOutOfLineCode(segment->base());
}

#endif // WASM_HUGE_MEMORY

MOZ_COLD static bool
IsHeapAccessAddress(const Instance &instance, uint8_t* faultingAddress)
{
    size_t accessLimit = instance.memoryMappedSize();

    return instance.metadata().usesMemory() &&
           faultingAddress >= instance.memoryBase() &&
           faultingAddress < instance.memoryBase() + accessLimit;
}

#if defined(XP_WIN)

static bool
HandleFault(PEXCEPTION_POINTERS exception)
{
    EXCEPTION_RECORD* record = exception->ExceptionRecord;
    CONTEXT* context = exception->ContextRecord;

    if (record->ExceptionCode != EXCEPTION_ACCESS_VIOLATION)
        return false;

    uint8_t** ppc = ContextToPC(context);
    uint8_t* pc = *ppc;

    if (record->NumberParameters < 2)
        return false;

    // Don't allow recursive handling of signals, see AutoSetHandlingSegFault.
    JSContext* cx = TlsContext.get();
    if (!cx || cx->handlingSegFault)
        return false;
    AutoSetHandlingSegFault handling(cx);

    WasmActivation* activation = ActivationIfInnermost(cx);
    if (!activation)
        return false;

    const CodeSegment* codeSegment;
    const Code* code = activation->compartment()->wasm.lookupCode(pc, &codeSegment);
    if (!code)
        return false;

    if (!codeSegment->containsFunctionPC(pc)) {
        // On Windows, it is possible for InterruptRunningJitCode to execute
        // between a faulting heap access and the handling of the fault due
        // to InterruptRunningJitCode's use of SuspendThread. When this happens,
        // after ResumeThread, the exception handler is called with pc equal to
        // CodeSegment.interrupt, which is logically wrong. The Right Thing would
        // be for the OS to make fault-handling atomic (so that CONTEXT.pc was
        // always the logically-faulting pc). Fortunately, we can detect this
        // case and silence the exception ourselves (the exception will
        // retrigger after the interrupt jumps back to resumePC).

        for (auto t : code->tiers()) {
            if (pc == code->segment(t).interruptCode() &&
                activation->interrupted() &&
                code->segment(t).containsFunctionPC(activation->resumePC()))
            {
                return true;
            }
        }
        return false;
    }

    const Instance* instance = LookupFaultingInstance(activation, pc, ContextToFP(context));
    if (!instance)
        return false;

    uint8_t* faultingAddress = reinterpret_cast<uint8_t*>(record->ExceptionInformation[1]);

    // This check isn't necessary, but, since we can, check anyway to make
    // sure we aren't covering up a real bug.
    if (!IsHeapAccessAddress(*instance, faultingAddress))
        return false;

    // Similar to the non-atomic situation above, on Windows, an OOB fault at a
    // PC can trigger *after* an async interrupt observed that PC and attempted
    // to redirect to the async stub. In this unique case, interrupted() is
    // already true when the OOB handler is called. Since the point of the async
    // interrupt is to get out of an iloop and the OOB trap will do just that,
    // we can simply clear the interrupt. (The update to CONTEXT.pc made by
    // HandleMemoryAccess will clobber the interrupt's previous update.)
    if (activation->interrupted()) {
        MOZ_ASSERT(activation->resumePC() == pc);
        activation->finishInterrupt();
    }

    HandleMemoryAccess(context, pc, faultingAddress, *instance, activation, ppc);
    return true;
}

static LONG WINAPI
WasmFaultHandler(LPEXCEPTION_POINTERS exception)
{
    if (HandleFault(exception))
        return EXCEPTION_CONTINUE_EXECUTION;

    // No need to worry about calling other handlers, the OS does this for us.
    return EXCEPTION_CONTINUE_SEARCH;
}

#elif defined(XP_DARWIN)
# include <mach/exc.h>

// This definition was generated by mig (the Mach Interface Generator) for the
// routine 'exception_raise' (exc.defs).
#pragma pack(4)
typedef struct {
    mach_msg_header_t Head;
    /* start of the kernel processed data */
    mach_msg_body_t msgh_body;
    mach_msg_port_descriptor_t thread;
    mach_msg_port_descriptor_t task;
    /* end of the kernel processed data */
    NDR_record_t NDR;
    exception_type_t exception;
    mach_msg_type_number_t codeCnt;
    int64_t code[2];
} Request__mach_exception_raise_t;
#pragma pack()

// The full Mach message also includes a trailer.
struct ExceptionRequest
{
    Request__mach_exception_raise_t body;
    mach_msg_trailer_t trailer;
};

static bool
HandleMachException(JSContext* cx, const ExceptionRequest& request)
{
    // Don't allow recursive handling of signals, see AutoSetHandlingSegFault.
    if (cx->handlingSegFault)
        return false;
    AutoSetHandlingSegFault handling(cx);

    // Get the port of the JSContext's thread from the message.
    mach_port_t cxThread = request.body.thread.name;

    // Read out the JSRuntime thread's register state.
    EMULATOR_CONTEXT context;
# if defined(__x86_64__)
    unsigned int thread_state_count = x86_THREAD_STATE64_COUNT;
    unsigned int float_state_count = x86_FLOAT_STATE64_COUNT;
    int thread_state = x86_THREAD_STATE64;
    int float_state = x86_FLOAT_STATE64;
# elif defined(__i386__)
    unsigned int thread_state_count = x86_THREAD_STATE_COUNT;
    unsigned int float_state_count = x86_FLOAT_STATE_COUNT;
    int thread_state = x86_THREAD_STATE;
    int float_state = x86_FLOAT_STATE;
# elif defined(__arm__)
    unsigned int thread_state_count = ARM_THREAD_STATE_COUNT;
    unsigned int float_state_count = ARM_NEON_STATE_COUNT;
    int thread_state = ARM_THREAD_STATE;
    int float_state = ARM_NEON_STATE;
# else
#  error Unsupported architecture
# endif
    kern_return_t kret;
    kret = thread_get_state(cxThread, thread_state,
                            (thread_state_t)&context.thread, &thread_state_count);
    if (kret != KERN_SUCCESS)
        return false;
    kret = thread_get_state(cxThread, float_state,
                            (thread_state_t)&context.float_, &float_state_count);
    if (kret != KERN_SUCCESS)
        return false;

    uint8_t** ppc = ContextToPC(&context);
    uint8_t* pc = *ppc;

    if (request.body.exception != EXC_BAD_ACCESS || request.body.codeCnt != 2)
        return false;

    // The faulting thread is suspended so we can access cx fields that can
    // normally only be accessed by the cx's active thread.
    AutoNoteSingleThreadedRegion anstr;

    WasmActivation* activation = ActivationIfInnermost(cx);
    if (!activation)
        return false;

    const Instance* instance = LookupFaultingInstance(activation, pc, ContextToFP(&context));
    if (!instance || !instance->code().containsFunctionPC(pc))
        return false;

    uint8_t* faultingAddress = reinterpret_cast<uint8_t*>(request.body.code[1]);

    // This check isn't necessary, but, since we can, check anyway to make
    // sure we aren't covering up a real bug.
    if (!IsHeapAccessAddress(*instance, faultingAddress))
        return false;

    HandleMemoryAccess(&context, pc, faultingAddress, *instance, activation, ppc);

    // Update the thread state with the new pc and register values.
    kret = thread_set_state(cxThread, float_state, (thread_state_t)&context.float_, float_state_count);
    if (kret != KERN_SUCCESS)
        return false;
    kret = thread_set_state(cxThread, thread_state, (thread_state_t)&context.thread, thread_state_count);
    if (kret != KERN_SUCCESS)
        return false;

    return true;
}

// Taken from mach_exc in /usr/include/mach/mach_exc.defs.
static const mach_msg_id_t sExceptionId = 2405;

// The choice of id here is arbitrary, the only constraint is that sQuitId != sExceptionId.
static const mach_msg_id_t sQuitId = 42;

static void
MachExceptionHandlerThread(JSContext* cx)
{
    mach_port_t port = cx->wasmMachExceptionHandler.port();
    kern_return_t kret;

    while(true) {
        ExceptionRequest request;
        kret = mach_msg(&request.body.Head, MACH_RCV_MSG, 0, sizeof(request),
                        port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);

        // If we fail even receiving the message, we can't even send a reply!
        // Rather than hanging the faulting thread (hanging the browser), crash.
        if (kret != KERN_SUCCESS) {
            fprintf(stderr, "MachExceptionHandlerThread: mach_msg failed with %d\n", (int)kret);
            MOZ_CRASH();
        }

        // There are only two messages we should be receiving: an exception
        // message that occurs when the runtime's thread faults and the quit
        // message sent when the runtime is shutting down.
        if (request.body.Head.msgh_id == sQuitId)
            break;
        if (request.body.Head.msgh_id != sExceptionId) {
            fprintf(stderr, "Unexpected msg header id %d\n", (int)request.body.Head.msgh_bits);
            MOZ_CRASH();
        }

        // Some thread just commited an EXC_BAD_ACCESS and has been suspended by
        // the kernel. The kernel is waiting for us to reply with instructions.
        // Our default is the "not handled" reply (by setting the RetCode field
        // of the reply to KERN_FAILURE) which tells the kernel to continue
        // searching at the process and system level. If this is an asm.js
        // expected exception, we handle it and return KERN_SUCCESS.
        bool handled = HandleMachException(cx, request);
        kern_return_t replyCode = handled ? KERN_SUCCESS : KERN_FAILURE;

        // This magic incantation to send a reply back to the kernel was derived
        // from the exc_server generated by 'mig -v /usr/include/mach/mach_exc.defs'.
        __Reply__exception_raise_t reply;
        reply.Head.msgh_bits = MACH_MSGH_BITS(MACH_MSGH_BITS_REMOTE(request.body.Head.msgh_bits), 0);
        reply.Head.msgh_size = sizeof(reply);
        reply.Head.msgh_remote_port = request.body.Head.msgh_remote_port;
        reply.Head.msgh_local_port = MACH_PORT_NULL;
        reply.Head.msgh_id = request.body.Head.msgh_id + 100;
        reply.NDR = NDR_record;
        reply.RetCode = replyCode;
        mach_msg(&reply.Head, MACH_SEND_MSG, sizeof(reply), 0, MACH_PORT_NULL,
                 MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
    }
}

MachExceptionHandler::MachExceptionHandler()
  : installed_(false),
    thread_(),
    port_(MACH_PORT_NULL)
{}

void
MachExceptionHandler::uninstall()
{
    if (installed_) {
        thread_port_t thread = mach_thread_self();
        kern_return_t kret = thread_set_exception_ports(thread,
                                                        EXC_MASK_BAD_ACCESS,
                                                        MACH_PORT_NULL,
                                                        EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES,
                                                        THREAD_STATE_NONE);
        mach_port_deallocate(mach_task_self(), thread);
        if (kret != KERN_SUCCESS)
            MOZ_CRASH();
        installed_ = false;
    }
    if (thread_.joinable()) {
        // Break the handler thread out of the mach_msg loop.
        mach_msg_header_t msg;
        msg.msgh_bits = MACH_MSGH_BITS(MACH_MSG_TYPE_COPY_SEND, 0);
        msg.msgh_size = sizeof(msg);
        msg.msgh_remote_port = port_;
        msg.msgh_local_port = MACH_PORT_NULL;
        msg.msgh_reserved = 0;
        msg.msgh_id = sQuitId;
        kern_return_t kret = mach_msg(&msg, MACH_SEND_MSG, sizeof(msg), 0, MACH_PORT_NULL,
                                      MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
        if (kret != KERN_SUCCESS) {
            fprintf(stderr, "MachExceptionHandler: failed to send quit message: %d\n", (int)kret);
            MOZ_CRASH();
        }

        // Wait for the handler thread to complete before deallocating the port.
        thread_.join();
    }
    if (port_ != MACH_PORT_NULL) {
        DebugOnly<kern_return_t> kret = mach_port_destroy(mach_task_self(), port_);
        MOZ_ASSERT(kret == KERN_SUCCESS);
        port_ = MACH_PORT_NULL;
    }
}

bool
MachExceptionHandler::install(JSContext* cx)
{
    MOZ_ASSERT(!installed());
    kern_return_t kret;
    mach_port_t thread;

    auto onFailure = mozilla::MakeScopeExit([&] {
        uninstall();
    });

    // Get a port which can send and receive data.
    kret = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &port_);
    if (kret != KERN_SUCCESS)
        return false;
    kret = mach_port_insert_right(mach_task_self(), port_, port_, MACH_MSG_TYPE_MAKE_SEND);
    if (kret != KERN_SUCCESS)
        return false;

    // Create a thread to block on reading port_.
    if (!thread_.init(MachExceptionHandlerThread, cx))
        return false;

    // Direct exceptions on this thread to port_ (and thus our handler thread).
    // Note: we are totally clobbering any existing *thread* exception ports and
    // not even attempting to forward. Breakpad and gdb both use the *process*
    // exception ports which are only called if the thread doesn't handle the
    // exception, so we should be fine.
    thread = mach_thread_self();
    kret = thread_set_exception_ports(thread,
                                      EXC_MASK_BAD_ACCESS,
                                      port_,
                                      EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES,
                                      THREAD_STATE_NONE);
    mach_port_deallocate(mach_task_self(), thread);
    if (kret != KERN_SUCCESS)
        return false;

    installed_ = true;
    onFailure.release();
    return true;
}

#else  // If not Windows or Mac, assume Unix

enum class Signal {
    SegFault,
    BusError
};

// Be very cautious and default to not handling; we don't want to accidentally
// silence real crashes from real bugs.
template<Signal signal>
static bool
HandleFault(int signum, siginfo_t* info, void* ctx)
{
    // The signals we're expecting come from access violations, accessing
    // mprotected memory. If the signal originates anywhere else, don't try
    // to handle it.
    if (signal == Signal::SegFault)
        MOZ_RELEASE_ASSERT(signum == SIGSEGV);
    else
        MOZ_RELEASE_ASSERT(signum == SIGBUS);

    CONTEXT* context = (CONTEXT*)ctx;
    uint8_t** ppc = ContextToPC(context);
    uint8_t* pc = *ppc;

    // Don't allow recursive handling of signals, see AutoSetHandlingSegFault.
    JSContext* cx = TlsContext.get();
    if (!cx || cx->handlingSegFault)
        return false;
    AutoSetHandlingSegFault handling(cx);

    WasmActivation* activation = ActivationIfInnermost(cx);
    if (!activation)
        return false;

    const CodeSegment* segment;
    const Instance* instance = LookupFaultingInstance(activation, pc, ContextToFP(context));
    if (!instance || !instance->code().containsFunctionPC(pc, &segment))
        return false;

    uint8_t* faultingAddress = reinterpret_cast<uint8_t*>(info->si_addr);

    // Although it's not strictly necessary, to make sure we're not covering up
    // any real bugs, check that the faulting address is indeed in the
    // instance's memory.
    if (!faultingAddress) {
        // On some Linux systems, the kernel apparently sometimes "gives up" and
        // passes a null faultingAddress with si_code set to SI_KERNEL.
        // This is observed on some automation machines for some out-of-bounds
        // atomic accesses on x86/64.
#ifdef SI_KERNEL
        if (info->si_code != SI_KERNEL)
            return false;
#else
        return false;
#endif
    } else {
        if (!IsHeapAccessAddress(*instance, faultingAddress))
            return false;
    }

#ifdef JS_CODEGEN_ARM
    if (signal == Signal::BusError) {
        // TODO: We may see a bus error for something that is an unaligned access that
        // partly overlaps the end of the heap.  In this case, it is an out-of-bounds
        // error and we should signal that properly, but to do so we must inspect
        // the operand of the failed access.
        activation->startInterrupt(ToRegisterState(context));
        *ppc = segment->unalignedAccessCode();
        return true;
    }
#endif

    HandleMemoryAccess(context, pc, faultingAddress, *instance, activation, ppc);
    return true;
}

static struct sigaction sPrevSEGVHandler;
static struct sigaction sPrevSIGBUSHandler;

template<Signal signal>
static void
WasmFaultHandler(int signum, siginfo_t* info, void* context)
{
    if (HandleFault<signal>(signum, info, context))
        return;

    struct sigaction* previousSignal = signum == SIGSEGV
                                       ? &sPrevSEGVHandler
                                       : &sPrevSIGBUSHandler;

    // This signal is not for any asm.js code we expect, so we need to forward
    // the signal to the next handler. If there is no next handler (SIG_IGN or
    // SIG_DFL), then it's time to crash. To do this, we set the signal back to
    // its original disposition and return. This will cause the faulting op to
    // be re-executed which will crash in the normal way. The advantage of
    // doing this to calling _exit() is that we remove ourselves from the crash
    // stack which improves crash reports. If there is a next handler, call it.
    // It will either crash synchronously, fix up the instruction so that
    // execution can continue and return, or trigger a crash by returning the
    // signal to it's original disposition and returning.
    //
    // Note: the order of these tests matter.
    if (previousSignal->sa_flags & SA_SIGINFO)
        previousSignal->sa_sigaction(signum, info, context);
    else if (previousSignal->sa_handler == SIG_DFL || previousSignal->sa_handler == SIG_IGN)
        sigaction(signum, previousSignal, nullptr);
    else
        previousSignal->sa_handler(signum);
}
# endif // XP_WIN || XP_DARWIN || assume unix

static void
RedirectIonBackedgesToInterruptCheck(JSContext* cx)
{
    if (!cx->runtime()->hasJitRuntime())
        return;
    jit::JitRuntime* jitRuntime = cx->runtime()->jitRuntime();
    Zone* zone = cx->zoneRaw();
    if (zone && !zone->isAtomsZone()) {
        // If the backedge list is being mutated, the pc must be in C++ code and
        // thus not in a JIT iloop. We assume that the interrupt flag will be
        // checked at least once before entering JIT code (if not, no big deal;
        // the browser will just request another interrupt in a second).
        if (!jitRuntime->preventBackedgePatching()) {
            jit::JitZoneGroup* jzg = zone->group()->jitZoneGroup;
            jzg->patchIonBackedges(cx, jit::JitZoneGroup::BackedgeInterruptCheck);
        }
    }
}

bool
wasm::InInterruptibleCode(JSContext* cx, uint8_t* pc, const CodeSegment** cs)
{
    // Only interrupt in function code so that the frame iterators have the
    // invariant that resumePC always has a function CodeRange and we can't
    // get into any weird interrupt-during-interrupt-stub cases.
    if (!cx->compartment())
        return false;

    const Code* code = cx->compartment()->wasm.lookupCode(pc, cs);
    return code && (*cs)->containsFunctionPC(pc);
}

// The return value indicates whether the PC was changed, not whether there was
// a failure.
static bool
RedirectJitCodeToInterruptCheck(JSContext* cx, CONTEXT* context)
{
    // Jitcode may only be modified on the runtime's active thread.
    if (cx != cx->runtime()->activeContext())
        return false;

    // The faulting thread is suspended so we can access cx fields that can
    // normally only be accessed by the cx's active thread.
    AutoNoteSingleThreadedRegion anstr;

    RedirectIonBackedgesToInterruptCheck(cx);

#ifdef JS_SIMULATOR
    uint8_t* pc = cx->simulator()->get_pc_as<uint8_t*>();
#else
    uint8_t* pc = *ContextToPC(context);
#endif

    const CodeSegment* codeSegment = nullptr;
    if (!InInterruptibleCode(cx, pc, &codeSegment))
        return false;

    // Only probe cx->activation() via ActivationIfInnermost after we know the
    // pc is in wasm code. This way we don't depend on signal-safe update of
    // cx->activation().
    WasmActivation* activation = ActivationIfInnermost(cx);
    MOZ_ASSERT(activation);

#ifdef JS_SIMULATOR
    // The checks performed by the !JS_SIMULATOR path happen in
    // Simulator::handleWasmInterrupt.
    cx->simulator()->trigger_wasm_interrupt();
#else
    // fp may be null when first entering wasm code from an entry stub.
    uint8_t* fp = ContextToFP(context);
    if (!fp)
        return false;

    // The out-of-bounds/unaligned trap paths which call startInterrupt() go
    // through function code, so test if already interrupted. These paths are
    // temporary though, so this case can be removed later.
    if (activation->interrupted())
        return false;

    activation->startInterrupt(ToRegisterState(context));
    *ContextToPC(context) = codeSegment->interruptCode();
#endif

    return true;
}

#if !defined(XP_WIN)
// For the interrupt signal, pick a signal number that:
//  - is not otherwise used by mozilla or standard libraries
//  - defaults to nostop and noprint on gdb/lldb so that noone is bothered
// SIGVTALRM a relative of SIGALRM, so intended for user code, but, unlike
// SIGALRM, not used anywhere else in Mozilla.
static const int sInterruptSignal = SIGVTALRM;

static void
JitInterruptHandler(int signum, siginfo_t* info, void* context)
{
    if (JSContext* cx = TlsContext.get()) {

#if defined(JS_SIMULATOR_ARM) || defined(JS_SIMULATOR_MIPS32) || defined(JS_SIMULATOR_MIPS64)
        SimulatorProcess::ICacheCheckingDisableCount++;
#endif

        RedirectJitCodeToInterruptCheck(cx, (CONTEXT*)context);

#if defined(JS_SIMULATOR_ARM) || defined(JS_SIMULATOR_MIPS32) || defined(JS_SIMULATOR_MIPS64)
        SimulatorProcess::cacheInvalidatedBySignalHandler_ = true;
        SimulatorProcess::ICacheCheckingDisableCount--;
#endif

        cx->finishHandlingJitInterrupt();
    }
}
#endif

static bool sTriedInstallSignalHandlers = false;
static bool sHaveSignalHandlers = false;

static bool
ProcessHasSignalHandlers()
{
    // We assume that there are no races creating the first JSRuntime of the process.
    if (sTriedInstallSignalHandlers)
        return sHaveSignalHandlers;
    sTriedInstallSignalHandlers = true;

#if defined(ANDROID)
# if !defined(__aarch64__)
    // Before Android 4.4 (SDK version 19), there is a bug
    //   https://android-review.googlesource.com/#/c/52333
    // in Bionic's pthread_join which causes pthread_join to return early when
    // pthread_kill is used (on any thread). Nobody expects the pthread_cond_wait
    // EINTRquisition.
    char version_string[PROP_VALUE_MAX];
    PodArrayZero(version_string);
    if (__system_property_get("ro.build.version.sdk", version_string) > 0) {
        if (atol(version_string) < 19)
            return false;
    }
# endif
# if defined(MOZ_LINKER)
    // Signal handling is broken on some android systems.
    if (IsSignalHandlingBroken())
        return false;
# endif
#endif

    // The interrupt handler allows the active thread to be paused from another
    // thread (see InterruptRunningJitCode).
#if defined(XP_WIN)
    // Windows uses SuspendThread to stop the active thread from another thread.
#else
    struct sigaction interruptHandler;
    interruptHandler.sa_flags = SA_SIGINFO;
    interruptHandler.sa_sigaction = &JitInterruptHandler;
    sigemptyset(&interruptHandler.sa_mask);
    struct sigaction prev;
    if (sigaction(sInterruptSignal, &interruptHandler, &prev))
        MOZ_CRASH("unable to install interrupt handler");

    // There shouldn't be any other handlers installed for sInterruptSignal. If
    // there are, we could always forward, but we need to understand what we're
    // doing to avoid problematic interference.
    if ((prev.sa_flags & SA_SIGINFO && prev.sa_sigaction) ||
        (prev.sa_handler != SIG_DFL && prev.sa_handler != SIG_IGN))
    {
        MOZ_CRASH("contention for interrupt signal");
    }
#endif // defined(XP_WIN)

    // Install a SIGSEGV handler to handle safely-out-of-bounds asm.js heap
    // access and/or unaligned accesses.
# if defined(XP_WIN)
#  if defined(MOZ_ASAN)
    // Under ASan we need to let the ASan runtime's ShadowExceptionHandler stay
    // in the first handler position. This requires some coordination with
    // MemoryProtectionExceptionHandler::isDisabled().
    const bool firstHandler = false;
#  else
    // Otherwise, WasmFaultHandler needs to go first, so that we can recover
    // from wasm faults and continue execution without triggering handlers
    // such as MemoryProtectionExceptionHandler that assume we are crashing.
    const bool firstHandler = true;
#  endif
    if (!AddVectoredExceptionHandler(firstHandler, WasmFaultHandler))
        return false;
# elif defined(XP_DARWIN)
    // OSX handles seg faults via the Mach exception handler above, so don't
    // install WasmFaultHandler.
# else
    // SA_NODEFER allows us to reenter the signal handler if we crash while
    // handling the signal, and fall through to the Breakpad handler by testing
    // handlingSegFault.

    // Allow handling OOB with signals on all architectures
    struct sigaction faultHandler;
    faultHandler.sa_flags = SA_SIGINFO | SA_NODEFER;
    faultHandler.sa_sigaction = WasmFaultHandler<Signal::SegFault>;
    sigemptyset(&faultHandler.sa_mask);
    if (sigaction(SIGSEGV, &faultHandler, &sPrevSEGVHandler))
        MOZ_CRASH("unable to install segv handler");

#  if defined(JS_CODEGEN_ARM)
    // On Arm Handle Unaligned Accesses
    struct sigaction busHandler;
    busHandler.sa_flags = SA_SIGINFO | SA_NODEFER;
    busHandler.sa_sigaction = WasmFaultHandler<Signal::BusError>;
    sigemptyset(&busHandler.sa_mask);
    if (sigaction(SIGBUS, &busHandler, &sPrevSIGBUSHandler))
        MOZ_CRASH("unable to install sigbus handler");
#  endif
# endif

    sHaveSignalHandlers = true;
    return true;
}

bool
wasm::EnsureSignalHandlers(JSContext* cx)
{
    // Nothing to do if the platform doesn't support it.
    if (!ProcessHasSignalHandlers())
        return true;

#if defined(XP_DARWIN)
    // On OSX, each JSContext which runs wasm gets its own handler thread.
    if (!cx->wasmMachExceptionHandler.installed() && !cx->wasmMachExceptionHandler.install(cx))
        return false;
#endif

    return true;
}

bool
wasm::HaveSignalHandlers()
{
    MOZ_ASSERT(sTriedInstallSignalHandlers);
    return sHaveSignalHandlers;
}

// JSRuntime::requestInterrupt sets interrupt_ (which is checked frequently by
// C++ code at every Baseline JIT loop backedge) and jitStackLimit_ (which is
// checked at every Baseline and Ion JIT function prologue). The remaining
// sources of potential iloops (Ion loop backedges and all wasm code) are
// handled by this function:
//  1. Ion loop backedges are patched to instead point to a stub that handles
//     the interrupt;
//  2. if the active thread's pc is inside wasm code, the pc is updated to point
//     to a stub that handles the interrupt.
void
js::InterruptRunningJitCode(JSContext* cx)
{
    // If signal handlers weren't installed, then Ion and wasm emit normal
    // interrupt checks and don't need asynchronous interruption.
    if (!HaveSignalHandlers())
        return;

    // Do nothing if we're already handling an interrupt here, to avoid races
    // below and in JitRuntime::patchIonBackedges.
    if (!cx->startHandlingJitInterrupt())
        return;

    // If we are on context's thread, then: pc is not in wasm code (so nothing
    // to do for wasm) and we can patch Ion backedges without any special
    // synchronization.
    if (cx == TlsContext.get()) {
        RedirectIonBackedgesToInterruptCheck(cx);
        cx->finishHandlingJitInterrupt();
        return;
    }

    // We are not on the runtime's active thread, so to do 1 and 2 above, we need
    // to halt the runtime's active thread first.
#if defined(XP_WIN)
    // On Windows, we can simply suspend the active thread and work directly on
    // its context from this thread. SuspendThread can sporadically fail if the
    // thread is in the middle of a syscall. Rather than retrying in a loop,
    // just wait for the next request for interrupt.
    HANDLE thread = (HANDLE)cx->threadNative();
    if (SuspendThread(thread) != (DWORD)-1) {
        CONTEXT context;
        context.ContextFlags = CONTEXT_FULL;
        if (GetThreadContext(thread, &context)) {
            if (RedirectJitCodeToInterruptCheck(cx, &context))
                SetThreadContext(thread, &context);
        }
        ResumeThread(thread);
    }
    cx->finishHandlingJitInterrupt();
#else
    // On Unix, we instead deliver an async signal to the active thread which
    // halts the thread and callers our JitInterruptHandler (which has already
    // been installed by EnsureSignalHandlersInstalled).
    pthread_t thread = (pthread_t)cx->threadNative();
    pthread_kill(thread, sInterruptSignal);
#endif
}
