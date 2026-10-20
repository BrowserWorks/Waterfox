/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#ifndef mozilla_freestanding_DllBlocklist_h
#define mozilla_freestanding_DllBlocklist_h

#include "mozilla/Attributes.h"
#include "mozilla/NativeNt.h"
#include "nsWindowsDllInterceptor.h"
#include "mozilla/WinHeaderOnlyUtils.h"

namespace mozilla {
namespace freestanding {

NTSTATUS NTAPI patched_LdrLoadDll(PWCHAR aDllPath, PULONG aFlags,
                                  PUNICODE_STRING aDllName, PHANDLE aOutHandle);

MOZ_NO_STACK_PROTECTOR NTSTATUS NTAPI patched_NtMapViewOfSection(
    HANDLE aSection, HANDLE aProcess, PVOID* aBaseAddress, ULONG_PTR aZeroBits,
    SIZE_T aCommitSize, PLARGE_INTEGER aSectionOffset, PSIZE_T aViewSize,
    SECTION_INHERIT aInheritDisposition, ULONG aAllocationType,
    ULONG aProtectionFlags);

MOZ_NO_STACK_PROTECTOR NTSTATUS NTAPI patched_NtCreateSection(
    PHANDLE aSectionHandle, ACCESS_MASK aDesiredAccess,
    POBJECT_ATTRIBUTES aObjectAttributes, PLARGE_INTEGER aMaximumSize,
    ULONG aSectionPageProtection, ULONG aAllocationAttributes,
    HANDLE aFileHandle);

using LdrLoadDllPtr = decltype(&::LdrLoadDll);

extern CrossProcessDllInterceptor::FuncHookType<LdrLoadDllPtr> stub_LdrLoadDll;

using NtMapViewOfSectionPtr = decltype(&::NtMapViewOfSection);

extern CrossProcessDllInterceptor::FuncHookType<NtMapViewOfSectionPtr>
    stub_NtMapViewOfSection;

using NtCreateSectionPtr = decltype(&::NtCreateSection);

extern CrossProcessDllInterceptor::FuncHookType<NtCreateSectionPtr>
    stub_NtCreateSection;

}  // namespace freestanding
}  // namespace mozilla

#endif  // mozilla_freestanding_DllBlocklist_h
