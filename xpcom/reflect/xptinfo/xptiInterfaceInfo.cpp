/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Implementation of xptiInterfaceEntry and xptiInterfaceInfo. */

#include "xptiprivate.h"
#include "mozilla/dom/ScriptSettings.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/XPTInterfaceInfoManager.h"
#include "mozilla/PodOperations.h"
#include "jsapi.h"

using namespace mozilla;

/* static */ xptiInterfaceEntry*
xptiInterfaceEntry::Create(const char* name, const nsID& iid,
                           XPTInterfaceDescriptor* aDescriptor,
                           xptiTypelibGuts* aTypelib)
{
    int namelen = strlen(name);
    void* place =
        XPT_CALLOC8(gXPTIStructArena, sizeof(xptiInterfaceEntry) + namelen);
    if (!place) {
        return nullptr;
    }
    return new (place) xptiInterfaceEntry(name, namelen, iid, aDescriptor,
                                          aTypelib);
}

xptiInterfaceEntry::xptiInterfaceEntry(const char* name,
                                       size_t nameLength,
                                       const nsID& iid,
                                       XPTInterfaceDescriptor* aDescriptor,
                                       xptiTypelibGuts* aTypelib)
    : mIID(iid)
    , mDescriptor(aDescriptor)
    , mTypelib(aTypelib)
    , mParent(nullptr)
    , mInfo(nullptr)
    , mMethodBaseIndex(0)
    , mConstantBaseIndex(0)
    , mFlags(0)
{
    memcpy(mName, name, nameLength);
    SetResolvedState(PARTIALLY_RESOLVED);
}

bool
xptiInterfaceEntry::Resolve()
{
    MutexAutoLock lock(XPTInterfaceInfoManager::GetResolveLock());
    return ResolveLocked();
}

bool
xptiInterfaceEntry::ResolveLocked()
{
    int resolvedState = GetResolveState();

    if(resolvedState == FULLY_RESOLVED)
        return true;
    if(resolvedState == RESOLVE_FAILED)
        return false;

    NS_ASSERTION(GetResolveState() == PARTIALLY_RESOLVED, "bad state!");

    // Finish out resolution by finding parent and Resolving it so
    // we can set the info we get from it.

    uint16_t parent_index = mDescriptor->parent_interface;

    if(parent_index)
    {
        xptiInterfaceEntry* parent =
            mTypelib->GetEntryAt(parent_index - 1);

        if(!parent || !parent->EnsureResolvedLocked())
        {
            SetResolvedState(RESOLVE_FAILED);
            return false;
        }

        mParent = parent;
        if (parent->GetHasNotXPCOMFlag()) {
            SetHasNotXPCOMFlag();
        } else {
            for (uint16_t idx = 0; idx < mDescriptor->num_methods; ++idx) {
                nsXPTMethodInfo* method = reinterpret_cast<nsXPTMethodInfo*>(
                    mDescriptor->method_descriptors + idx);
                if (method->IsNotXPCOM()) {
                    SetHasNotXPCOMFlag();
                    break;
                }
            }
        }


        mMethodBaseIndex =
            parent->mMethodBaseIndex +
            parent->mDescriptor->num_methods;

        mConstantBaseIndex =
            parent->mConstantBaseIndex +
            parent->mDescriptor->num_constants;

    }
    LOG_RESOLVE(("+ complete resolve of %s\n", mName));

    SetResolvedState(FULLY_RESOLVED);
    return true;
}

/**************************************************/
// These non-virtual methods handle the delegated nsIInterfaceInfo methods.

nsresult
xptiInterfaceEntry::GetName(char **name)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *name = (char*) nsMemory::Clone(mName, strlen(mName)+1);
    return *name ? NS_OK : NS_ERROR_OUT_OF_MEMORY;
}

nsresult
xptiInterfaceEntry::GetIID(nsIID **iid)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *iid = (nsIID*) nsMemory::Clone(&mIID, sizeof(nsIID));
    return *iid ? NS_OK : NS_ERROR_OUT_OF_MEMORY;
}

nsresult
xptiInterfaceEntry::IsScriptable(bool* result)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *result = GetScriptableFlag();
    return NS_OK;
}

nsresult
xptiInterfaceEntry::IsFunction(bool* result)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    *result = XPT_ID_IS_FUNCTION(mDescriptor->flags);
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetMethodCount(uint16_t* count)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    *count = mMethodBaseIndex +
             mDescriptor->num_methods;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetConstantCount(uint16_t* count)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(!count)
        return NS_ERROR_UNEXPECTED;

    *count = mConstantBaseIndex +
             mDescriptor->num_constants;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetMethodInfo(uint16_t index, const nsXPTMethodInfo** info)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(index < mMethodBaseIndex)
        return mParent->GetMethodInfo(index, info);

    if(index >= mMethodBaseIndex +
                mDescriptor->num_methods)
    {
        NS_ERROR("bad param");
        *info = nullptr;
        return NS_ERROR_INVALID_ARG;
    }

    // else...
    *info = reinterpret_cast<nsXPTMethodInfo*>
       (&mDescriptor->method_descriptors[index - mMethodBaseIndex]);
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetMethodInfoForName(const char* methodName, uint16_t *index,
                                         const nsXPTMethodInfo** result)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    // This is a slow algorithm, but this is not expected to be called much.
    for(uint16_t i = 0; i < mDescriptor->num_methods; ++i)
    {
        const nsXPTMethodInfo* info;
        info = reinterpret_cast<nsXPTMethodInfo*>
                               (&mDescriptor->
                                        method_descriptors[i]);
        if (PL_strcmp(methodName, info->GetName()) == 0) {
            *index = i + mMethodBaseIndex;
            *result = info;
            return NS_OK;
        }
    }

    if(mParent)
        return mParent->GetMethodInfoForName(methodName, index, result);
    else
    {
        *index = 0;
        *result = 0;
        return NS_ERROR_INVALID_ARG;
    }
}

nsresult
xptiInterfaceEntry::GetConstant(uint16_t index, JS::MutableHandleValue constant,
                                char** name)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(index < mConstantBaseIndex)
        return mParent->GetConstant(index, constant, name);

    if(index >= mConstantBaseIndex +
                mDescriptor->num_constants)
    {
        NS_PRECONDITION(0, "bad param");
        return NS_ERROR_INVALID_ARG;
    }

    const auto& c = mDescriptor->const_descriptors[index - mConstantBaseIndex];
    AutoJSContext cx;
    JS::Rooted<JS::Value> v(cx);
    v.setUndefined();

    switch (c.type.prefix.flags) {
      case nsXPTType::T_I8:
      {
        v.setInt32(c.value.i8);
        break;
      }
      case nsXPTType::T_U8:
      {
        v.setInt32(c.value.ui8);
        break;
      }
      case nsXPTType::T_I16:
      {
        v.setInt32(c.value.i16);
        break;
      }
      case nsXPTType::T_U16:
      {
        v.setInt32(c.value.ui16);
        break;
      }
      case nsXPTType::T_I32:
      {
        v = JS_NumberValue(c.value.i32);
        break;
      }
      case nsXPTType::T_U32:
      {
        v = JS_NumberValue(c.value.ui32);
        break;
      }
      default:
      {
#ifdef DEBUG
        NS_ERROR("Non-numeric constant found in interface.");
#endif
      }
    }

    constant.set(v);
    *name = ToNewCString(nsDependentCString(c.name));

    return NS_OK;
}

// this is a private helper

nsresult
xptiInterfaceEntry::GetInterfaceIndexForParam(uint16_t methodIndex,
                                              const nsXPTParamInfo* param,
                                              uint16_t* interfaceIndex)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(methodIndex < mMethodBaseIndex)
        return mParent->GetInterfaceIndexForParam(methodIndex, param,
                                                  interfaceIndex);

    if(methodIndex >= mMethodBaseIndex +
                      mDescriptor->num_methods)
    {
        NS_ERROR("bad param");
        return NS_ERROR_INVALID_ARG;
    }

    const XPTTypeDescriptor *td = &param->type;

    while (XPT_TDP_TAG(td->prefix) == TD_ARRAY) {
        td = &mDescriptor->additional_types[td->u.array.additional_type];
    }

    if(XPT_TDP_TAG(td->prefix) != TD_INTERFACE_TYPE) {
        NS_ERROR("not an interface");
        return NS_ERROR_INVALID_ARG;
    }

    *interfaceIndex = (td->u.iface.iface_hi8 << 8) | td->u.iface.iface_lo8;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetEntryForParam(uint16_t methodIndex,
                                     const nsXPTParamInfo * param,
                                     xptiInterfaceEntry** entry)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(methodIndex < mMethodBaseIndex)
        return mParent->GetEntryForParam(methodIndex, param, entry);

    uint16_t interfaceIndex = 0;
    nsresult rv = GetInterfaceIndexForParam(methodIndex, param,
                                            &interfaceIndex);
    if (NS_FAILED(rv)) {
        return rv;
    }

    xptiInterfaceEntry* theEntry = mTypelib->GetEntryAt(interfaceIndex - 1);

    // This can happen if a declared interface is not available at runtime.
    if(!theEntry)
    {
        *entry = nullptr;
        return NS_ERROR_FAILURE;
    }

    *entry = theEntry;
    return NS_OK;
}

already_AddRefed<ShimInterfaceInfo>
xptiInterfaceEntry::GetShimForParam(uint16_t methodIndex,
                                    const nsXPTParamInfo* param)
{
    if(methodIndex < mMethodBaseIndex) {
        return mParent->GetShimForParam(methodIndex, param);
    }

    uint16_t interfaceIndex = 0;
    nsresult rv = GetInterfaceIndexForParam(methodIndex, param,
                                            &interfaceIndex);
    if (NS_FAILED(rv)) {
        return nullptr;
    }

    const char* shimName = mTypelib->GetEntryNameAt(interfaceIndex - 1);
    RefPtr<ShimInterfaceInfo> shim =
        ShimInterfaceInfo::MaybeConstruct(shimName, nullptr);
    return shim.forget();
}

nsresult
xptiInterfaceEntry::GetInfoForParam(uint16_t methodIndex,
                                    const nsXPTParamInfo *param,
                                    nsIInterfaceInfo** info)
{
    xptiInterfaceEntry* entry;
    nsresult rv = GetEntryForParam(methodIndex, param, &entry);
    if (NS_FAILED(rv)) {
        RefPtr<ShimInterfaceInfo> shim = GetShimForParam(methodIndex, param);
        if (!shim) {
            return rv;
        }

        shim.forget(info);
        return NS_OK;
    }

    *info = entry->InterfaceInfo().take();

    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetIIDForParam(uint16_t methodIndex,
                                   const nsXPTParamInfo* param, nsIID** iid)
{
    xptiInterfaceEntry* entry;
    nsresult rv = GetEntryForParam(methodIndex, param, &entry);
    if (NS_FAILED(rv)) {
        RefPtr<ShimInterfaceInfo> shim = GetShimForParam(methodIndex, param);
        if (!shim) {
            return rv;
        }

        return shim->GetInterfaceIID(iid);
    }
    return entry->GetIID(iid);
}

nsresult
xptiInterfaceEntry::GetIIDForParamNoAlloc(uint16_t methodIndex,
                                          const nsXPTParamInfo * param,
                                          nsIID *iid)
{
    xptiInterfaceEntry* entry;
    nsresult rv = GetEntryForParam(methodIndex, param, &entry);
    if (NS_FAILED(rv)) {
        RefPtr<ShimInterfaceInfo> shim = GetShimForParam(methodIndex, param);
        if (!shim) {
            return rv;
        }

        const nsIID* shimIID;
        DebugOnly<nsresult> rv2 = shim->GetIIDShared(&shimIID);
        MOZ_ASSERT(NS_SUCCEEDED(rv2));
        *iid = *shimIID;
        return NS_OK;
    }
    *iid = entry->mIID;
    return NS_OK;
}

// this is a private helper
nsresult
xptiInterfaceEntry::GetTypeInArray(const nsXPTParamInfo* param,
                                  uint16_t dimension,
                                  const XPTTypeDescriptor** type)
{
    NS_ASSERTION(IsFullyResolved(), "bad state");

    const XPTTypeDescriptor *td = &param->type;
    const XPTTypeDescriptor *additional_types =
                mDescriptor->additional_types;

    for (uint16_t i = 0; i < dimension; i++) {
        if(XPT_TDP_TAG(td->prefix) != TD_ARRAY) {
            NS_ERROR("bad dimension");
            return NS_ERROR_INVALID_ARG;
        }
        td = &additional_types[td->u.array.additional_type];
    }

    *type = td;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetTypeForParam(uint16_t methodIndex,
                                    const nsXPTParamInfo* param,
                                    uint16_t dimension,
                                    nsXPTType* type)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(methodIndex < mMethodBaseIndex)
        return mParent->
            GetTypeForParam(methodIndex, param, dimension, type);

    if(methodIndex >= mMethodBaseIndex +
                      mDescriptor->num_methods)
    {
        NS_ERROR("bad index");
        return NS_ERROR_INVALID_ARG;
    }

    const XPTTypeDescriptor *td;

    if(dimension) {
        nsresult rv = GetTypeInArray(param, dimension, &td);
        if(NS_FAILED(rv))
            return rv;
    }
    else
        td = &param->type;

    *type = nsXPTType(td->prefix);
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetSizeIsArgNumberForParam(uint16_t methodIndex,
                                               const nsXPTParamInfo* param,
                                               uint16_t dimension,
                                               uint8_t* argnum)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(methodIndex < mMethodBaseIndex)
        return mParent->
            GetSizeIsArgNumberForParam(methodIndex, param, dimension, argnum);

    if(methodIndex >= mMethodBaseIndex +
                      mDescriptor->num_methods)
    {
        NS_ERROR("bad index");
        return NS_ERROR_INVALID_ARG;
    }

    const XPTTypeDescriptor *td;

    if(dimension) {
        nsresult rv = GetTypeInArray(param, dimension, &td);
        if(NS_FAILED(rv))
            return rv;
    }
    else
        td = &param->type;

    // verify that this is a type that has size_is
    switch (XPT_TDP_TAG(td->prefix)) {
      case TD_ARRAY:
        *argnum = td->u.array.argnum;
        break;
      case TD_PSTRING_SIZE_IS:
      case TD_PWSTRING_SIZE_IS:
        *argnum = td->u.pstring_is.argnum;
        break;
      default:
        NS_ERROR("not a size_is");
        return NS_ERROR_INVALID_ARG;
    }

    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetInterfaceIsArgNumberForParam(uint16_t methodIndex,
                                                    const nsXPTParamInfo* param,
                                                    uint8_t* argnum)
{
    if(!EnsureResolved())
        return NS_ERROR_UNEXPECTED;

    if(methodIndex < mMethodBaseIndex)
        return mParent->
            GetInterfaceIsArgNumberForParam(methodIndex, param, argnum);

    if(methodIndex >= mMethodBaseIndex +
                      mDescriptor->num_methods)
    {
        NS_ERROR("bad index");
        return NS_ERROR_INVALID_ARG;
    }

    const XPTTypeDescriptor *td = &param->type;

    while (XPT_TDP_TAG(td->prefix) == TD_ARRAY) {
        td = &mDescriptor->additional_types[td->u.array.additional_type];
    }

    if(XPT_TDP_TAG(td->prefix) != TD_INTERFACE_IS_TYPE) {
        NS_ERROR("not an iid_is");
        return NS_ERROR_INVALID_ARG;
    }

    *argnum = td->u.interface_is.argnum;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::IsIID(const nsIID * iid, bool *_retval)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *_retval = mIID.Equals(*iid);
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetNameShared(const char **name)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *name = mName;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::GetIIDShared(const nsIID * *iid)
{
    // It is not necessary to Resolve because this info is read from manifest.
    *iid = &mIID;
    return NS_OK;
}

nsresult
xptiInterfaceEntry::HasAncestor(const nsIID * iid, bool *_retval)
{
    *_retval = false;

    for(xptiInterfaceEntry* current = this;
        current;
        current = current->mParent)
    {
        if(current->mIID.Equals(*iid))
        {
            *_retval = true;
            break;
        }
        if(!current->EnsureResolved())
            return NS_ERROR_UNEXPECTED;
    }

    return NS_OK;
}

/***************************************************/

already_AddRefed<xptiInterfaceInfo>
xptiInterfaceEntry::InterfaceInfo()
{
#ifdef DEBUG
    XPTInterfaceInfoManager::GetSingleton()->mWorkingSet.mTableReentrantMonitor.
        AssertCurrentThreadIn();
#endif

    if(!mInfo)
    {
        mInfo = new xptiInterfaceInfo(this);
    }

    RefPtr<xptiInterfaceInfo> info = mInfo;
    return info.forget();
}

void
xptiInterfaceEntry::LockedInvalidateInterfaceInfo()
{
    if(mInfo)
    {
        mInfo->Invalidate();
        mInfo = nullptr;
    }
}

bool
xptiInterfaceInfo::BuildParent()
{
    mozilla::ReentrantMonitorAutoEnter monitor(XPTInterfaceInfoManager::GetSingleton()->
                                    mWorkingSet.mTableReentrantMonitor);
    NS_ASSERTION(mEntry &&
                 mEntry->IsFullyResolved() &&
                 !mParent &&
                 mEntry->Parent(),
                "bad BuildParent call");
    mParent = mEntry->Parent()->InterfaceInfo();
    return true;
}

/***************************************************************************/

NS_IMPL_QUERY_INTERFACE(xptiInterfaceInfo, nsIInterfaceInfo)

xptiInterfaceInfo::xptiInterfaceInfo(xptiInterfaceEntry* entry)
    : mEntry(entry)
{
}

xptiInterfaceInfo::~xptiInterfaceInfo()
{
    NS_ASSERTION(!mEntry, "bad state in dtor");
}

void
xptiInterfaceInfo::Invalidate()
{
  mParent = nullptr;
  mEntry = nullptr;
}

MozExternalRefCountType
xptiInterfaceInfo::AddRef(void)
{
    nsrefcnt cnt = ++mRefCnt;
    NS_LOG_ADDREF(this, cnt, "xptiInterfaceInfo", sizeof(*this));
    return cnt;
}

MozExternalRefCountType
xptiInterfaceInfo::Release(void)
{
    xptiInterfaceEntry* entry = mEntry;
    nsrefcnt cnt = --mRefCnt;
    NS_LOG_RELEASE(this, cnt, "xptiInterfaceInfo");
    if(!cnt)
    {
        mozilla::ReentrantMonitorAutoEnter monitor(XPTInterfaceInfoManager::
                                          GetSingleton()->mWorkingSet.
                                          mTableReentrantMonitor);

        // If InterfaceInfo added and *released* a reference before we
        // acquired the monitor then 'this' might already be dead. In that
        // case we would not want to try to access any instance data. We
        // would want to bail immediately. If 'this' is already dead then the
        // entry will no longer have a pointer to 'this'. So, we can protect
        // ourselves from danger without more aggressive locking.
        if(entry && !entry->InterfaceInfoEquals(this))
            return 0;

        // If InterfaceInfo added a reference before we acquired the monitor
        // then we want to bail out of here without destorying the object.
        if(mRefCnt)
            return 1;

        if(mEntry)
        {
            mEntry->LockedInterfaceInfoDeathNotification();
            mEntry = nullptr;
        }

        delete this;
        return 0;
    }
    return cnt;
}

/***************************************************************************/
