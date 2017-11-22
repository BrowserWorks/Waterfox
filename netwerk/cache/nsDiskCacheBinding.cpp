/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/MemoryReporting.h"
#include "nsCache.h"
#include <limits.h>

#include "nscore.h"
#include "nsDiskCacheBinding.h"
#include "nsCacheService.h"

using namespace mozilla;

/******************************************************************************
 *  static hash table callback functions
 *
 *****************************************************************************/
struct HashTableEntry : PLDHashEntryHdr {
    nsDiskCacheBinding *  mBinding;
};


static PLDHashNumber
HashKey(const void *key)
{
    return (PLDHashNumber) NS_PTR_TO_INT32(key);
}


static bool
MatchEntry(const PLDHashEntryHdr *       header,
           const void *                  key)
{
    HashTableEntry * hashEntry = (HashTableEntry *) header;
    return (hashEntry->mBinding->mRecord.HashNumber() == (PLDHashNumber) NS_PTR_TO_INT32(key));
}

static void
MoveEntry(PLDHashTable *           /* table */,
          const PLDHashEntryHdr *     src,
          PLDHashEntryHdr       *     dst)
{
    ((HashTableEntry *)dst)->mBinding = ((HashTableEntry *)src)->mBinding;
}


static void
ClearEntry(PLDHashTable *      /* table */,
           PLDHashEntryHdr *      header)
{
    ((HashTableEntry *)header)->mBinding = nullptr;
}


/******************************************************************************
 *  Utility Functions
 *****************************************************************************/
nsDiskCacheBinding *
GetCacheEntryBinding(nsCacheEntry * entry)
{
    return (nsDiskCacheBinding *) entry->Data();
}


/******************************************************************************
 *  nsDiskCacheBinding
 *****************************************************************************/

NS_IMPL_ISUPPORTS0(nsDiskCacheBinding)

nsDiskCacheBinding::nsDiskCacheBinding(nsCacheEntry* entry, nsDiskCacheRecord * record)
    :   mCacheEntry(entry)
    ,   mStreamIO(nullptr)
    ,   mDeactivateEvent(nullptr)
{
    NS_ASSERTION(record->ValidRecord(), "bad record");
    PR_INIT_CLIST(this);
    mRecord     = *record;
    mDoomed     = entry->IsDoomed();
    mGeneration = record->Generation();    // 0 == uninitialized, or data & meta using block files
}

nsDiskCacheBinding::~nsDiskCacheBinding()
{
    // Grab the cache lock since the binding is stored in nsCacheEntry::mData
    // and it is released using nsCacheService::ReleaseObject_Locked() which
    // releases the object outside the cache lock.
    nsCacheServiceAutoLock lock;

    NS_ASSERTION(PR_CLIST_IS_EMPTY(this), "binding deleted while still on list");
    if (!PR_CLIST_IS_EMPTY(this))
        PR_REMOVE_LINK(this);       // XXX why are we still on a list?

    // sever streamIO/binding link
    if (mStreamIO) {
        if (NS_FAILED(mStreamIO->ClearBinding()))
            nsCacheService::DoomEntry(mCacheEntry);
        NS_RELEASE(mStreamIO);
    }
}

nsresult
nsDiskCacheBinding::EnsureStreamIO()
{
    if (!mStreamIO) {
        mStreamIO = new nsDiskCacheStreamIO(this);
        if (!mStreamIO)  return NS_ERROR_OUT_OF_MEMORY;
        NS_ADDREF(mStreamIO);
    }
    return NS_OK;
}


/******************************************************************************
 *  nsDiskCacheBindery
 *
 *  Keeps track of bound disk cache entries to detect for collisions.
 *
 *****************************************************************************/

const PLDHashTableOps nsDiskCacheBindery::ops =
{
    HashKey,
    MatchEntry,
    MoveEntry,
    ClearEntry
};


nsDiskCacheBindery::nsDiskCacheBindery()
    : table(&ops, sizeof(HashTableEntry), kInitialTableLength)
    , initialized(false)
{
}


nsDiskCacheBindery::~nsDiskCacheBindery()
{
    Reset();
}


void
nsDiskCacheBindery::Init()
{
    table.ClearAndPrepareForLength(kInitialTableLength);
    initialized = true;
}

void
nsDiskCacheBindery::Reset()
{
    if (initialized) {
        table.ClearAndPrepareForLength(kInitialTableLength);
        initialized = false;
    }
}


nsDiskCacheBinding *
nsDiskCacheBindery::CreateBinding(nsCacheEntry *       entry,
                                  nsDiskCacheRecord *  record)
{
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");
    nsCOMPtr<nsISupports> data = entry->Data();
    if (data) {
        NS_ERROR("cache entry already has bind data");
        return nullptr;
    }

    nsDiskCacheBinding * binding = new nsDiskCacheBinding(entry, record);
    if (!binding)  return nullptr;

    // give ownership of the binding to the entry
    entry->SetData(binding);

    // add binding to collision detection system
    nsresult rv = AddBinding(binding);
    if (NS_FAILED(rv)) {
        entry->SetData(nullptr);
        return nullptr;
    }

    return binding;
}


/**
 *  FindActiveEntry :  to find active colliding entry so we can doom it
 */
nsDiskCacheBinding *
nsDiskCacheBindery::FindActiveBinding(uint32_t  hashNumber)
{
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");
    // find hash entry for key
    auto hashEntry = static_cast<HashTableEntry*>
        (table.Search((void*)(uintptr_t)hashNumber));
    if (!hashEntry) return nullptr;

    // walk list looking for active entry
    NS_ASSERTION(hashEntry->mBinding, "hash entry left with no binding");
    nsDiskCacheBinding * binding = hashEntry->mBinding;
    while (binding->mCacheEntry->IsDoomed()) {
        binding = (nsDiskCacheBinding *)PR_NEXT_LINK(binding);
        if (binding == hashEntry->mBinding)  return nullptr;
    }
    return binding;
}


/**
 *  AddBinding
 *
 *  Called from FindEntry() if we read an entry off of disk
 *      - it may already have a generation number
 *      - a generation number conflict is an error
 *
 *  Called from BindEntry()
 *      - a generation number needs to be assigned
 */
nsresult
nsDiskCacheBindery::AddBinding(nsDiskCacheBinding * binding)
{
    NS_ENSURE_ARG_POINTER(binding);
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");

    // find hash entry for key
    auto hashEntry = static_cast<HashTableEntry*>
        (table.Add((void*)(uintptr_t)binding->mRecord.HashNumber(), fallible));
    if (!hashEntry)
        return NS_ERROR_OUT_OF_MEMORY;

    if (hashEntry->mBinding == nullptr) {
        hashEntry->mBinding = binding;
        if (binding->mGeneration == 0)
            binding->mGeneration = 1;   // if generation uninitialized, set it to 1

        return NS_OK;
    }


    // insert binding in generation order
    nsDiskCacheBinding * p  = hashEntry->mBinding;
    bool     calcGeneration = (binding->mGeneration == 0);  // do we need to calculate generation?
    if (calcGeneration)  binding->mGeneration = 1;          // initialize to 1 if uninitialized
    while (1) {

        if (binding->mGeneration < p->mGeneration) {
            // here we are
            PR_INSERT_BEFORE(binding, p);
            if (hashEntry->mBinding == p)
                hashEntry->mBinding = binding;
            break;
        }

        if (binding->mGeneration == p->mGeneration) {
            if (calcGeneration)  ++binding->mGeneration;    // try the next generation
            else {
                NS_ERROR("### disk cache: generations collide!");
                return NS_ERROR_UNEXPECTED;
            }
        }

        p = (nsDiskCacheBinding *)PR_NEXT_LINK(p);
        if (p == hashEntry->mBinding) {
            // end of line: insert here or die
            p = (nsDiskCacheBinding *)PR_PREV_LINK(p);  // back up and check generation
            if (p->mGeneration == 255) {
                NS_WARNING("### disk cache: generation capacity at full");
                return NS_ERROR_UNEXPECTED;
            }
            PR_INSERT_BEFORE(binding, hashEntry->mBinding);
            break;
        }
    }
    return NS_OK;
}


/**
 *  RemoveBinding :  remove binding from collision detection on deactivation
 */
void
nsDiskCacheBindery::RemoveBinding(nsDiskCacheBinding * binding)
{
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");
    if (!initialized)   return;

    void* key = (void *)(uintptr_t)binding->mRecord.HashNumber();
    auto hashEntry =
        static_cast<HashTableEntry*>(table.Search((void*)(uintptr_t) key));
    if (!hashEntry) {
        NS_WARNING("### disk cache: binding not in hashtable!");
        return;
    }

    if (binding == hashEntry->mBinding) {
        if (PR_CLIST_IS_EMPTY(binding)) {
            // remove this hash entry
            table.Remove((void*)(uintptr_t) binding->mRecord.HashNumber());
            return;

        } else {
            // promote next binding to head, and unlink this binding
            hashEntry->mBinding = (nsDiskCacheBinding *)PR_NEXT_LINK(binding);
        }
    }
    PR_REMOVE_AND_INIT_LINK(binding);
}

/**
 * ActiveBindings: return true if any bindings have open descriptors.
 */
bool
nsDiskCacheBindery::ActiveBindings()
{
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");
    if (!initialized) return false;

    for (auto iter = table.Iter(); !iter.Done(); iter.Next()) {
        auto entry = static_cast<HashTableEntry*>(iter.Get());
        nsDiskCacheBinding* binding = entry->mBinding;
        nsDiskCacheBinding* head = binding;
        do {
            if (binding->IsActive()) {
                return true;
            }
            binding = (nsDiskCacheBinding *)PR_NEXT_LINK(binding);
        } while (binding != head);
    }

    return false;
}

/**
 * SizeOfExcludingThis: return the amount of heap memory (bytes) being used by
 * the bindery.
 */
size_t
nsDiskCacheBindery::SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf)
{
    NS_ASSERTION(initialized, "nsDiskCacheBindery not initialized");
    if (!initialized) return 0;

    size_t size = 0;

    for (auto iter = table.Iter(); !iter.Done(); iter.Next()) {
        auto entry = static_cast<HashTableEntry*>(iter.Get());
        nsDiskCacheBinding* binding = entry->mBinding;

        nsDiskCacheBinding* head = binding;
        do {
            size += aMallocSizeOf(binding);
            if (binding->mStreamIO) {
                size += binding->mStreamIO->SizeOfIncludingThis(aMallocSizeOf);
            }

            // No good way to get at mDeactivateEvent internals for proper
            // size, so we use this as an estimate.
            if (binding->mDeactivateEvent) {
                size += aMallocSizeOf(binding->mDeactivateEvent);
            }
            binding = (nsDiskCacheBinding *)PR_NEXT_LINK(binding);
        } while (binding != head);
    }

    return size;
}
