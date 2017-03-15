/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ThreadStackHelper.h"
#include "MainThreadUtils.h"
#include "nsJSPrincipals.h"
#include "nsScriptSecurityManager.h"
#include "jsfriendapi.h"
#ifdef MOZ_THREADSTACKHELPER_NATIVE
#include "shared-libraries.h"
#endif

#include "mozilla/Assertions.h"
#include "mozilla/Attributes.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/Move.h"
#include "mozilla/Scoped.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/MemoryChecking.h"
#include "mozilla/Sprintf.h"

#ifdef __GNUC__
# pragma GCC diagnostic push
# pragma GCC diagnostic ignored "-Wshadow"
#endif

#if defined(MOZ_VALGRIND)
# include <valgrind/valgrind.h>
#endif

#include <string.h>
#include <vector>
#include <cstdlib>

#ifdef XP_LINUX
#include <ucontext.h>
#include <unistd.h>
#include <sys/syscall.h>
#endif

#ifdef __GNUC__
# pragma GCC diagnostic pop // -Wshadow
#endif

#if defined(XP_LINUX) || defined(XP_MACOSX)
#include <pthread.h>
#endif

#ifdef ANDROID
#ifndef SYS_gettid
#define SYS_gettid __NR_gettid
#endif
#if defined(__arm__) && !defined(__NR_rt_tgsigqueueinfo)
// Some NDKs don't define this constant even though the kernel supports it.
#define __NR_rt_tgsigqueueinfo (__NR_SYSCALL_BASE+363)
#endif
#ifndef SYS_rt_tgsigqueueinfo
#define SYS_rt_tgsigqueueinfo __NR_rt_tgsigqueueinfo
#endif
#endif

#ifdef MOZ_THREADSTACKHELPER_NATIVE
#if defined(MOZ_THREADSTACKHELPER_X86) || \
    defined(MOZ_THREADSTACKHELPER_X64) || \
    defined(MOZ_THREADSTACKHELPER_ARM)
// On these architectures, the stack grows downwards (toward lower addresses).
#define MOZ_THREADSTACKHELPER_STACK_GROWS_DOWN
#else
#error "Unsupported architecture"
#endif
#endif // MOZ_THREADSTACKHELPER_NATIVE

namespace mozilla {

void
ThreadStackHelper::Startup()
{
#if defined(XP_LINUX)
  MOZ_ASSERT(NS_IsMainThread());
  if (!sInitialized) {
    // TODO: centralize signal number allocation
    sFillStackSignum = SIGRTMIN + 4;
    if (sFillStackSignum > SIGRTMAX) {
      // Leave uninitialized
      MOZ_ASSERT(false);
      return;
    }
    struct sigaction sigact = {};
    sigact.sa_sigaction = FillStackHandler;
    sigemptyset(&sigact.sa_mask);
    sigact.sa_flags = SA_SIGINFO | SA_RESTART;
    MOZ_ALWAYS_TRUE(!::sigaction(sFillStackSignum, &sigact, nullptr));
  }
  sInitialized++;
#endif
}

void
ThreadStackHelper::Shutdown()
{
#if defined(XP_LINUX)
  MOZ_ASSERT(NS_IsMainThread());
  if (sInitialized == 1) {
    struct sigaction sigact = {};
    sigact.sa_handler = SIG_DFL;
    MOZ_ALWAYS_TRUE(!::sigaction(sFillStackSignum, &sigact, nullptr));
  }
  sInitialized--;
#endif
}

ThreadStackHelper::ThreadStackHelper()
  : mStackToFill(nullptr)
#ifdef MOZ_THREADSTACKHELPER_PSEUDO
  , mPseudoStack(mozilla_get_pseudo_stack())
#ifdef MOZ_THREADSTACKHELPER_NATIVE
  , mContextToFill(nullptr)
#endif
  , mMaxStackSize(Stack::sMaxInlineStorage)
  , mMaxBufferSize(512)
#endif
{
#if defined(XP_LINUX)
  MOZ_ALWAYS_TRUE(!::sem_init(&mSem, 0, 0));
  mThreadID = ::syscall(SYS_gettid);
#elif defined(XP_WIN)
  mInitialized = !!::DuplicateHandle(
    ::GetCurrentProcess(), ::GetCurrentThread(),
    ::GetCurrentProcess(), &mThreadID,
    THREAD_SUSPEND_RESUME
#ifdef MOZ_THREADSTACKHELPER_NATIVE
    | THREAD_GET_CONTEXT | THREAD_QUERY_INFORMATION
#endif
    , FALSE, 0);
  MOZ_ASSERT(mInitialized);
#elif defined(XP_MACOSX)
  mThreadID = mach_thread_self();
#endif

#ifdef MOZ_THREADSTACKHELPER_NATIVE
  GetThreadStackBase();
#endif
}

ThreadStackHelper::~ThreadStackHelper()
{
#if defined(XP_LINUX)
  MOZ_ALWAYS_TRUE(!::sem_destroy(&mSem));
#elif defined(XP_WIN)
  if (mInitialized) {
    MOZ_ALWAYS_TRUE(!!::CloseHandle(mThreadID));
  }
#endif
}

#ifdef MOZ_THREADSTACKHELPER_NATIVE
void ThreadStackHelper::GetThreadStackBase()
{
  mThreadStackBase = 0;

#if defined(XP_LINUX)
  void* stackAddr;
  size_t stackSize;
  ::pthread_t pthr = ::pthread_self();
  ::pthread_attr_t pthr_attr;
  NS_ENSURE_TRUE_VOID(!::pthread_getattr_np(pthr, &pthr_attr));
  if (!::pthread_attr_getstack(&pthr_attr, &stackAddr, &stackSize)) {
#ifdef MOZ_THREADSTACKHELPER_STACK_GROWS_DOWN
    mThreadStackBase = intptr_t(stackAddr) + stackSize;
#else
    mThreadStackBase = intptr_t(stackAddr);
#endif
  }
  MOZ_ALWAYS_TRUE(!::pthread_attr_destroy(&pthr_attr));

#elif defined(XP_WIN)
  ::MEMORY_BASIC_INFORMATION meminfo = {};
  NS_ENSURE_TRUE_VOID(::VirtualQuery(&meminfo, &meminfo, sizeof(meminfo)));
#ifdef MOZ_THREADSTACKHELPER_STACK_GROWS_DOWN
  mThreadStackBase = intptr_t(meminfo.BaseAddress) + meminfo.RegionSize;
#else
  mThreadStackBase = intptr_t(meminfo.AllocationBase);
#endif

#elif defined(XP_MACOSX)
  ::pthread_t pthr = ::pthread_self();
  mThreadStackBase = intptr_t(::pthread_get_stackaddr_np(pthr));

#else
  #error "Unsupported platform"
#endif // platform
}
#endif // MOZ_THREADSTACKHELPER_NATIVE

namespace {
template<typename T>
class ScopedSetPtr
{
private:
  T*& mPtr;
public:
  ScopedSetPtr(T*& p, T* val) : mPtr(p) { mPtr = val; }
  ~ScopedSetPtr() { mPtr = nullptr; }
};
} // namespace

void
ThreadStackHelper::GetStack(Stack& aStack)
{
  // Always run PrepareStackBuffer first to clear aStack
  if (!PrepareStackBuffer(aStack)) {
    // Skip and return empty aStack
    return;
  }

  ScopedSetPtr<Stack> stackPtr(mStackToFill, &aStack);

#if defined(XP_LINUX)
  if (!sInitialized) {
    MOZ_ASSERT(false);
    return;
  }
  siginfo_t uinfo = {};
  uinfo.si_signo = sFillStackSignum;
  uinfo.si_code = SI_QUEUE;
  uinfo.si_pid = getpid();
  uinfo.si_uid = getuid();
  uinfo.si_value.sival_ptr = this;
  if (::syscall(SYS_rt_tgsigqueueinfo, uinfo.si_pid,
                mThreadID, sFillStackSignum, &uinfo)) {
    // rt_tgsigqueueinfo was added in Linux 2.6.31.
    // Could have failed because the syscall did not exist.
    return;
  }
  MOZ_ALWAYS_TRUE(!::sem_wait(&mSem));

#elif defined(XP_WIN)
  if (!mInitialized) {
    MOZ_ASSERT(false);
    return;
  }
  if (::SuspendThread(mThreadID) == DWORD(-1)) {
    MOZ_ASSERT(false);
    return;
  }

  // SuspendThread is asynchronous, so the thread may still be running. Use
  // GetThreadContext to ensure it's really suspended.
  // See https://blogs.msdn.microsoft.com/oldnewthing/20150205-00/?p=44743.
  CONTEXT context;
  context.ContextFlags = CONTEXT_CONTROL;
  if (::GetThreadContext(mThreadID, &context)) {
    FillStackBuffer();
    FillThreadContext();
  }

  MOZ_ALWAYS_TRUE(::ResumeThread(mThreadID) != DWORD(-1));

#elif defined(XP_MACOSX)
# if defined(MOZ_VALGRIND) && defined(RUNNING_ON_VALGRIND)
  if (RUNNING_ON_VALGRIND) {
    /* thread_suspend and thread_resume sometimes hang runs on Valgrind,
       for unknown reasons.  So, just avoid them.  See bug 1100911. */
    return;
  }
# endif

  if (::thread_suspend(mThreadID) != KERN_SUCCESS) {
    MOZ_ASSERT(false);
    return;
  }

  FillStackBuffer();
  FillThreadContext();

  MOZ_ALWAYS_TRUE(::thread_resume(mThreadID) == KERN_SUCCESS);

#endif
}

#ifdef MOZ_THREADSTACKHELPER_NATIVE
class ThreadStackHelper::ThreadContext final
{
public:
  // TODO: provide per-platform definition of Context.
  typedef struct {} Context;

  // Limit copied stack to 4kB
  static const size_t kMaxStackSize = 0x1000;
  // Limit unwound stack to 32 frames
  static const unsigned int kMaxStackFrames = 32;
  // Whether this structure contains valid data
  bool mValid;
  // Processor context
  Context mContext;
  // Stack area
  UniquePtr<uint8_t[]> mStack;
  // Start of stack area
  uintptr_t mStackBase;
  // Size of stack area
  size_t mStackSize;
  // End of stack area
  const void* mStackEnd;

  ThreadContext()
    : mValid(false)
    , mStackBase(0)
    , mStackSize(0)
    , mStackEnd(nullptr) {}
};
#endif // MOZ_THREADSTACKHELPER_NATIVE

void
ThreadStackHelper::GetNativeStack(Stack& aStack)
{
#ifdef MOZ_THREADSTACKHELPER_NATIVE
  ThreadContext context;
  context.mStack = MakeUnique<uint8_t[]>(ThreadContext::kMaxStackSize);

  ScopedSetPtr<ThreadContext> contextPtr(mContextToFill, &context);

  // Get pseudostack first and fill the thread context.
  GetStack(aStack);
  NS_ENSURE_TRUE_VOID(context.mValid);

  // TODO: walk the saved stack frames.
#endif // MOZ_THREADSTACKHELPER_NATIVE
}

#ifdef XP_LINUX

int ThreadStackHelper::sInitialized;
int ThreadStackHelper::sFillStackSignum;

void
ThreadStackHelper::FillStackHandler(int aSignal, siginfo_t* aInfo,
                                    void* aContext)
{
  ThreadStackHelper* const helper =
    reinterpret_cast<ThreadStackHelper*>(aInfo->si_value.sival_ptr);
  helper->FillStackBuffer();
  helper->FillThreadContext(aContext);
  ::sem_post(&helper->mSem);
}

#endif // XP_LINUX

bool
ThreadStackHelper::PrepareStackBuffer(Stack& aStack)
{
  // Return false to skip getting the stack and return an empty stack
  aStack.clear();
#ifdef MOZ_THREADSTACKHELPER_PSEUDO
  /* Normally, provided the profiler is enabled, it would be an error if we
     don't have a pseudostack here (the thread probably forgot to call
     profiler_register_thread). However, on B2G, profiling secondary threads
     may be disabled despite profiler being enabled. This is by-design and
     is not an error. */
#ifdef MOZ_WIDGET_GONK
  if (!mPseudoStack) {
    return false;
  }
#endif
  MOZ_ASSERT(mPseudoStack);
  if (!aStack.reserve(mMaxStackSize) ||
      !aStack.reserve(aStack.capacity()) || // reserve up to the capacity
      !aStack.EnsureBufferCapacity(mMaxBufferSize)) {
    return false;
  }
  return true;
#else
  return false;
#endif
}

#ifdef MOZ_THREADSTACKHELPER_PSEUDO

namespace {

bool
IsChromeJSScript(JSScript* aScript)
{
  // May be called from another thread or inside a signal handler.
  // We assume querying the script is safe but we must not manipulate it.

  nsIScriptSecurityManager* const secman =
    nsScriptSecurityManager::GetScriptSecurityManager();
  NS_ENSURE_TRUE(secman, false);

  JSPrincipals* const principals = JS_GetScriptPrincipals(aScript);
  return secman->IsSystemPrincipal(nsJSPrincipals::get(principals));
}

// Get the full path after the URI scheme, if the URI matches the scheme.
// For example, GetFullPathForScheme("a://b/c/d/e", "a://") returns "b/c/d/e".
template <size_t LEN>
const char*
GetFullPathForScheme(const char* filename, const char (&scheme)[LEN]) {
  // Account for the null terminator included in LEN.
  if (!strncmp(filename, scheme, LEN - 1)) {
    return filename + LEN - 1;
  }
  return nullptr;
}

// Get the full path after a URI component, if the URI contains the component.
// For example, GetPathAfterComponent("a://b/c/d/e", "/c/") returns "d/e".
template <size_t LEN>
const char*
GetPathAfterComponent(const char* filename, const char (&component)[LEN]) {
  const char* found = nullptr;
  const char* next = strstr(filename, component);
  while (next) {
    // Move 'found' to end of the component, after the separator '/'.
    // 'LEN - 1' accounts for the null terminator included in LEN,
    found = next + LEN - 1;
    // Resume searching before the separator '/'.
    next = strstr(found - 1, component);
  }
  return found;
}

} // namespace

const char*
ThreadStackHelper::AppendJSEntry(const volatile StackEntry* aEntry,
                                 intptr_t& aAvailableBufferSize,
                                 const char* aPrevLabel)
{
  // May be called from another thread or inside a signal handler.
  // We assume querying the script is safe but we must not manupulate it.
  // Also we must not allocate any memory from heap.
  MOZ_ASSERT(aEntry->isJs());

  const char* label;
  JSScript* script = aEntry->script();
  if (!script) {
    label = "(profiling suppressed)";
  } else if (IsChromeJSScript(aEntry->script())) {
    const char* filename = JS_GetScriptFilename(aEntry->script());
    const unsigned lineno = JS_PCToLineNumber(aEntry->script(), aEntry->pc());
    MOZ_ASSERT(filename);

    char buffer[128]; // Enough to fit longest js file name from the tree

    // Some script names are in the form "foo -> bar -> baz".
    // Here we find the origin of these redirected scripts.
    const char* basename = GetPathAfterComponent(filename, " -> ");
    if (basename) {
      filename = basename;
    }

    basename = GetFullPathForScheme(filename, "chrome://");
    if (!basename) {
      basename = GetFullPathForScheme(filename, "resource://");
    }
    if (!basename) {
      // If the (add-on) script is located under the {profile}/extensions
      // directory, extract the path after the /extensions/ part.
      basename = GetPathAfterComponent(filename, "/extensions/");
    }
    if (!basename) {
      // Only keep the file base name for paths outside the above formats.
      basename = strrchr(filename, '/');
      basename = basename ? basename + 1 : filename;
      // Look for Windows path separator as well.
      filename = strrchr(basename, '\\');
      if (filename) {
        basename = filename + 1;
      }
    }

    size_t len = SprintfLiteral(buffer, "%s:%u", basename, lineno);
    if (len < sizeof(buffer)) {
      if (mStackToFill->IsSameAsEntry(aPrevLabel, buffer)) {
        return aPrevLabel;
      }

      // Keep track of the required buffer size
      aAvailableBufferSize -= (len + 1);
      if (aAvailableBufferSize >= 0) {
        // Buffer is big enough.
        return mStackToFill->InfallibleAppendViaBuffer(buffer, len);
      }
      // Buffer is not big enough; fall through to using static label below.
    }
    // snprintf failed or buffer is not big enough.
    label = "(chrome script)";
  } else {
    label = "(content script)";
  }

  if (mStackToFill->IsSameAsEntry(aPrevLabel, label)) {
    return aPrevLabel;
  }
  mStackToFill->infallibleAppend(label);
  return label;
}

#endif // MOZ_THREADSTACKHELPER_PSEUDO

void
ThreadStackHelper::FillStackBuffer()
{
  MOZ_ASSERT(mStackToFill->empty());

#ifdef MOZ_THREADSTACKHELPER_PSEUDO
  size_t reservedSize = mStackToFill->capacity();
  size_t reservedBufferSize = mStackToFill->AvailableBufferSize();
  intptr_t availableBufferSize = intptr_t(reservedBufferSize);

  // Go from front to back
  const volatile StackEntry* entry = mPseudoStack->mStack;
  const volatile StackEntry* end = entry + mPseudoStack->stackSize();
  // Deduplicate identical, consecutive frames
  const char* prevLabel = nullptr;
  for (; reservedSize-- && entry != end; entry++) {
    /* We only accept non-copy labels, including js::RunScript,
       because we only want static labels in the hang stack. */
    if (entry->isCopyLabel()) {
      continue;
    }
    if (entry->isJs()) {
      prevLabel = AppendJSEntry(entry, availableBufferSize, prevLabel);
      continue;
    }
#ifdef MOZ_THREADSTACKHELPER_NATIVE
    if (mContextToFill) {
      mContextToFill->mStackEnd = entry->stackAddress();
    }
#endif
    const char* const label = entry->label();
    if (mStackToFill->IsSameAsEntry(prevLabel, label)) {
      // Avoid duplicate labels to save space in the stack.
      continue;
    }
    mStackToFill->infallibleAppend(label);
    prevLabel = label;
  }

  // end != entry if we exited early due to not enough reserved frames.
  // Expand the number of reserved frames for next time.
  mMaxStackSize = mStackToFill->capacity() + (end - entry);

  // availableBufferSize < 0 if we needed a larger buffer than we reserved.
  // Calculate a new reserve size for next time.
  if (availableBufferSize < 0) {
    mMaxBufferSize = reservedBufferSize - availableBufferSize;
  }
#endif
}

MOZ_ASAN_BLACKLIST void
ThreadStackHelper::FillThreadContext(void* aContext)
{
#ifdef MOZ_THREADSTACKHELPER_NATIVE
  if (!mContextToFill) {
    return;
  }

#if 0 // TODO: remove dependency on Breakpad structs.
#if defined(XP_LINUX)
  const ucontext_t& context = *reinterpret_cast<ucontext_t*>(aContext);
#if defined(MOZ_THREADSTACKHELPER_X86)
  mContextToFill->mContext.context_flags = MD_CONTEXT_X86_FULL;
  mContextToFill->mContext.edi = context.uc_mcontext.gregs[REG_EDI];
  mContextToFill->mContext.esi = context.uc_mcontext.gregs[REG_ESI];
  mContextToFill->mContext.ebx = context.uc_mcontext.gregs[REG_EBX];
  mContextToFill->mContext.edx = context.uc_mcontext.gregs[REG_EDX];
  mContextToFill->mContext.ecx = context.uc_mcontext.gregs[REG_ECX];
  mContextToFill->mContext.eax = context.uc_mcontext.gregs[REG_EAX];
  mContextToFill->mContext.ebp = context.uc_mcontext.gregs[REG_EBP];
  mContextToFill->mContext.eip = context.uc_mcontext.gregs[REG_EIP];
  mContextToFill->mContext.eflags = context.uc_mcontext.gregs[REG_EFL];
  mContextToFill->mContext.esp = context.uc_mcontext.gregs[REG_ESP];
#elif defined(MOZ_THREADSTACKHELPER_X64)
  mContextToFill->mContext.context_flags = MD_CONTEXT_AMD64_FULL;
  mContextToFill->mContext.eflags = uint32_t(context.uc_mcontext.gregs[REG_EFL]);
  mContextToFill->mContext.rax = context.uc_mcontext.gregs[REG_RAX];
  mContextToFill->mContext.rcx = context.uc_mcontext.gregs[REG_RCX];
  mContextToFill->mContext.rdx = context.uc_mcontext.gregs[REG_RDX];
  mContextToFill->mContext.rbx = context.uc_mcontext.gregs[REG_RBX];
  mContextToFill->mContext.rsp = context.uc_mcontext.gregs[REG_RSP];
  mContextToFill->mContext.rbp = context.uc_mcontext.gregs[REG_RBP];
  mContextToFill->mContext.rsi = context.uc_mcontext.gregs[REG_RSI];
  mContextToFill->mContext.rdi = context.uc_mcontext.gregs[REG_RDI];
  memcpy(&mContextToFill->mContext.r8,
         &context.uc_mcontext.gregs[REG_R8], 8 * sizeof(int64_t));
  mContextToFill->mContext.rip = context.uc_mcontext.gregs[REG_RIP];
#elif defined(MOZ_THREADSTACKHELPER_ARM)
  mContextToFill->mContext.context_flags = MD_CONTEXT_ARM_FULL;
  memcpy(&mContextToFill->mContext.iregs[0],
         &context.uc_mcontext.arm_r0, 17 * sizeof(int32_t));
#else
  #error "Unsupported architecture"
#endif // architecture

#elif defined(XP_WIN)
  // Breakpad context struct is based off of the Windows CONTEXT struct,
  // so we assume they are the same; do some sanity checks to make sure.
  static_assert(sizeof(ThreadContext::Context) == sizeof(::CONTEXT),
                "Context struct mismatch");
  static_assert(offsetof(ThreadContext::Context, context_flags) ==
                offsetof(::CONTEXT, ContextFlags),
                "Context struct mismatch");
  mContextToFill->mContext.context_flags = CONTEXT_FULL;
  NS_ENSURE_TRUE_VOID(::GetThreadContext(mThreadID,
      reinterpret_cast<::CONTEXT*>(&mContextToFill->mContext)));

#elif defined(XP_MACOSX)
#if defined(MOZ_THREADSTACKHELPER_X86)
  const thread_state_flavor_t flavor = x86_THREAD_STATE32;
  x86_thread_state32_t state = {};
  mach_msg_type_number_t count = x86_THREAD_STATE32_COUNT;
#elif defined(MOZ_THREADSTACKHELPER_X64)
  const thread_state_flavor_t flavor = x86_THREAD_STATE64;
  x86_thread_state64_t state = {};
  mach_msg_type_number_t count = x86_THREAD_STATE64_COUNT;
#elif defined(MOZ_THREADSTACKHELPER_ARM)
  const thread_state_flavor_t flavor = ARM_THREAD_STATE;
  arm_thread_state_t state = {};
  mach_msg_type_number_t count = ARM_THREAD_STATE_COUNT;
#endif
  NS_ENSURE_TRUE_VOID(KERN_SUCCESS == ::thread_get_state(
    mThreadID, flavor, reinterpret_cast<thread_state_t>(&state), &count));
#if __DARWIN_UNIX03
#define GET_REGISTER(s, r) ((s).__##r)
#else
#define GET_REGISTER(s, r) ((s).r)
#endif
#if defined(MOZ_THREADSTACKHELPER_X86)
  mContextToFill->mContext.context_flags = MD_CONTEXT_X86_FULL;
  mContextToFill->mContext.edi = GET_REGISTER(state, edi);
  mContextToFill->mContext.esi = GET_REGISTER(state, esi);
  mContextToFill->mContext.ebx = GET_REGISTER(state, ebx);
  mContextToFill->mContext.edx = GET_REGISTER(state, edx);
  mContextToFill->mContext.ecx = GET_REGISTER(state, ecx);
  mContextToFill->mContext.eax = GET_REGISTER(state, eax);
  mContextToFill->mContext.ebp = GET_REGISTER(state, ebp);
  mContextToFill->mContext.eip = GET_REGISTER(state, eip);
  mContextToFill->mContext.eflags = GET_REGISTER(state, eflags);
  mContextToFill->mContext.esp = GET_REGISTER(state, esp);
#elif defined(MOZ_THREADSTACKHELPER_X64)
  mContextToFill->mContext.context_flags = MD_CONTEXT_AMD64_FULL;
  mContextToFill->mContext.eflags = uint32_t(GET_REGISTER(state, rflags));
  mContextToFill->mContext.rax = GET_REGISTER(state, rax);
  mContextToFill->mContext.rcx = GET_REGISTER(state, rcx);
  mContextToFill->mContext.rdx = GET_REGISTER(state, rdx);
  mContextToFill->mContext.rbx = GET_REGISTER(state, rbx);
  mContextToFill->mContext.rsp = GET_REGISTER(state, rsp);
  mContextToFill->mContext.rbp = GET_REGISTER(state, rbp);
  mContextToFill->mContext.rsi = GET_REGISTER(state, rsi);
  mContextToFill->mContext.rdi = GET_REGISTER(state, rdi);
  memcpy(&mContextToFill->mContext.r8,
         &GET_REGISTER(state, r8), 8 * sizeof(int64_t));
  mContextToFill->mContext.rip = GET_REGISTER(state, rip);
#elif defined(MOZ_THREADSTACKHELPER_ARM)
  mContextToFill->mContext.context_flags = MD_CONTEXT_ARM_FULL;
  memcpy(mContextToFill->mContext.iregs,
         GET_REGISTER(state, r), 17 * sizeof(int32_t));
#else
  #error "Unsupported architecture"
#endif // architecture
#undef GET_REGISTER

#else
  #error "Unsupported platform"
#endif // platform

  intptr_t sp = 0;
#if defined(MOZ_THREADSTACKHELPER_X86)
  sp = mContextToFill->mContext.esp;
#elif defined(MOZ_THREADSTACKHELPER_X64)
  sp = mContextToFill->mContext.rsp;
#elif defined(MOZ_THREADSTACKHELPER_ARM)
  sp = mContextToFill->mContext.iregs[13];
#else
  #error "Unsupported architecture"
#endif // architecture
  NS_ENSURE_TRUE_VOID(sp);
  NS_ENSURE_TRUE_VOID(mThreadStackBase);

  size_t stackSize = std::min(intptr_t(ThreadContext::kMaxStackSize),
                              std::abs(sp - mThreadStackBase));

  if (mContextToFill->mStackEnd) {
    // Limit the start of stack to a certain location if specified.
    stackSize = std::min(intptr_t(stackSize),
      std::abs(sp - intptr_t(mContextToFill->mStackEnd)));
  }

#ifndef MOZ_THREADSTACKHELPER_STACK_GROWS_DOWN
  // If if the stack grows upwards, and we need to recalculate our
  // stack copy's base address. Subtract sizeof(void*) so that the
  // location pointed to by sp is included.
  sp -= stackSize - sizeof(void*);
#endif

#ifndef MOZ_ASAN
  memcpy(mContextToFill->mStack.get(), reinterpret_cast<void*>(sp), stackSize);
  // Valgrind doesn't care about the access outside the stack frame, but
  // the presence of uninitialised values on the stack does cause it to
  // later report a lot of false errors when Breakpad comes to unwind it.
  // So mark the extracted data as defined.
  MOZ_MAKE_MEM_DEFINED(mContextToFill->mStack.get(), stackSize);
#else
  // ASan will flag memcpy for access outside of stack frames,
  // so roll our own memcpy here.
  intptr_t* dst = reinterpret_cast<intptr_t*>(&mContextToFill->mStack[0]);
  const intptr_t* src = reinterpret_cast<intptr_t*>(sp);
  for (intptr_t len = stackSize; len > 0; len -= sizeof(*src)) {
    *(dst++) = *(src++);
  }
#endif

  mContextToFill->mStackBase = uintptr_t(sp);
  mContextToFill->mStackSize = stackSize;
  mContextToFill->mValid = true;
#endif
#endif // MOZ_THREADSTACKHELPER_NATIVE
}

} // namespace mozilla
