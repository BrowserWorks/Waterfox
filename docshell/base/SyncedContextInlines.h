/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_SyncedContextInlines_h
#define mozilla_dom_SyncedContextInlines_h

#include "mozilla/dom/SyncedContext.h"
#include "mozilla/dom/BrowsingContextGroup.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/ContentChild.h"
#include "nsReadableUtils.h"
#include "mozilla/HalIPCUtils.h"

namespace mozilla {
namespace dom {
namespace syncedcontext {

template <typename T>
struct IsMozillaMaybe : std::false_type {};
template <typename T>
struct IsMozillaMaybe<Maybe<T>> : std::true_type {};

// A super-sketchy logging only function for generating a human-readable version
// of the value of a synced context field.
template <typename T>
void FormatFieldValue(nsACString& aStr, const T& aValue) {
  if constexpr (std::is_same_v<bool, T>) {
    if (aValue) {
      aStr.AppendLiteral("true");
    } else {
      aStr.AppendLiteral("false");
    }
  } else if constexpr (std::is_same_v<nsID, T>) {
    aStr.Append(nsIDToCString(aValue).get());
  } else if constexpr (std::is_integral_v<T>) {
    aStr.AppendInt(aValue);
  } else if constexpr (std::is_enum_v<T>) {
    aStr.AppendInt(static_cast<std::underlying_type_t<T>>(aValue));
  } else if constexpr (std::is_floating_point_v<T>) {
    aStr.AppendFloat(aValue);
  } else if constexpr (std::is_base_of_v<nsAString, T>) {
    AppendUTF16toUTF8(aValue, aStr);
  } else if constexpr (std::is_base_of_v<nsACString, T>) {
    aStr.Append(aValue);
  } else if constexpr (IsMozillaMaybe<T>::value) {
    if (aValue) {
      aStr.AppendLiteral("Some(");
      FormatFieldValue(aStr, aValue.ref());
      aStr.AppendLiteral(")");
    } else {
      aStr.AppendLiteral("Nothing");
    }
  } else {
    aStr.AppendLiteral("???");
  }
}

// Sketchy logging-only logic to generate a human-readable output of the actions
// a synced context transaction is going to perform.
template <typename Context>
nsAutoCString FormatTransaction(
    typename Transaction<Context>::IndexSet aModified,
    const typename Context::FieldValues& aOldValues,
    const typename Context::FieldValues& aNewValues) {
  nsAutoCString result;
  Context::FieldValues::EachIndex([&](auto idx) {
    if (aModified.contains(idx)) {
      result.Append(Context::FieldIndexToName(idx));
      result.AppendLiteral("(");
      FormatFieldValue(result, aOldValues.Get(idx));
      result.AppendLiteral("->");
      FormatFieldValue(result, aNewValues.Get(idx));
      result.AppendLiteral(") ");
    }
  });
  return result;
}

template <typename Context>
nsCString FormatValidationError(
    typename Transaction<Context>::IndexSet aFailedFields, const char* prefix) {
  MOZ_ASSERT(!aFailedFields.isEmpty());
  return nsDependentCString{prefix} +
         StringJoin(", "_ns, aFailedFields,
                    [](nsACString& dest, const auto& idx) {
                      dest.Append(Context::FieldIndexToName(idx));
                    });
}

template <typename Context>
nsresult Transaction<Context>::Commit(Context* aOwner) {
  if (NS_WARN_IF(aOwner->IsDiscarded())) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  IndexSet failedFields = Validate(aOwner, nullptr);
  if (!failedFields.isEmpty()) {
    nsCString error = FormatValidationError<Context>(
        failedFields, "CanSet failed for field(s): ");
    MOZ_CRASH_UNSAFE_PRINTF("%s", error.get());
  }

  if (mModified.isEmpty()) {
    return NS_OK;
  }

  if (XRE_IsContentProcess()) {
    ContentChild* cc = ContentChild::GetSingleton();

    // Increment the field epoch for fields affected by this transaction.
    uint64_t epoch = cc->NextBrowsingContextFieldEpoch();
    EachIndex([&](auto idx) {
      if (mModified.contains(idx)) {
        FieldEpoch(idx, aOwner) = epoch;
      }
    });

    // Tell our derived class to send the correct "Commit" IPC message.
    aOwner->SendCommitTransaction(cc, *this, epoch);
  } else {
    MOZ_DIAGNOSTIC_ASSERT(XRE_IsParentProcess());

    // Tell our derived class to send the correct "Commit" IPC messages.
    BrowsingContextGroup* group = aOwner->Group();
    group->EachParent([&](ContentParent* aParent) {
      aOwner->SendCommitTransaction(aParent, *this,
                                    aParent->GetBrowsingContextFieldEpoch());
    });
  }

  Apply(aOwner, /* aFromIPC */ false);
  return NS_OK;
}

template <typename Context>
mozilla::ipc::IPCResult Transaction<Context>::CommitFromIPC(
    const MaybeDiscarded<Context>& aOwner, ContentParent* aSource) {
  MOZ_DIAGNOSTIC_ASSERT(XRE_IsParentProcess());
  if (aOwner.IsNullOrDiscarded()) {
    MOZ_LOG(Context::GetSyncLog(), LogLevel::Debug,
            ("IPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }
  Context* owner = aOwner.get();

  // Validate that the set from content is allowed before continuing.
  IndexSet failedFields = Validate(owner, aSource);
  if (!failedFields.isEmpty()) {
    nsCString error = FormatValidationError<Context>(
        failedFields,
        "Invalid Transaction from Child - CanSet failed for field(s): ");
    // data-review+ at https://bugzilla.mozilla.org/show_bug.cgi?id=1618992#c7
    return IPC_FAIL_UNSAFE_PRINTF(aSource, "%s", error.get());
  }

  // Validate may have dropped some fields from the transaction, check it's not
  // empty before continuing.
  if (mModified.isEmpty()) {
    return IPC_OK();
  }

  BrowsingContextGroup* group = owner->Group();
  group->EachOtherParent(aSource, [&](ContentParent* aParent) {
    owner->SendCommitTransaction(aParent, *this,
                                 aParent->GetBrowsingContextFieldEpoch());
  });

  Apply(owner, /* aFromIPC */ true);
  return IPC_OK();
}

template <typename Context>
void Transaction<Context>::SendCorrection(Context* aOwner,
                                          ContentParent* aTarget) {
  if (mModified.isEmpty()) {
    return;
  }
  MOZ_LOG(
      Context::GetSyncLog(), LogLevel::Debug,
      ("Transaction::SendCorrection(#%" PRIx64 ", childid %d): %s",
       aOwner->Id(), aTarget->OtherChildID(),
       StringJoin(", "_ns, mModified, [](nsACString& dest, const auto& idx) {
         dest.Append(Context::FieldIndexToName(idx));
       }).get()));
  aOwner->SendCommitTransaction(aTarget, *this,
                                aTarget->GetBrowsingContextFieldEpoch());
}

template <typename Context>
void Transaction<Context>::ReconcileInitialFields(
    Context* aOwner, typename Context::FieldValues&& aRequested,
    ContentParent* aSource, Transaction<Context>& aCorrection) {
  MOZ_DIAGNOSTIC_ASSERT(XRE_IsParentProcess());
  MOZ_DIAGNOSTIC_ASSERT(aSource);

  Transaction<Context> accepted;
  EachIndex([&](auto idx) {
    if (!(aRequested.Get(idx) == aOwner->mFields.mValues.Get(idx))) {
      accepted.mValues.Get(idx) = std::move(aRequested.Get(idx));
      accepted.mModified += idx;
    }
  });

  MOZ_LOG(Context::GetSyncLog(), LogLevel::Debug,
          ("Transaction::ReconcileInitialFields(#%" PRIx64 ", childid %d): %s",
           aOwner->Id(), aSource->OtherChildID(),
           FormatTransaction<Context>(accepted.mModified,
                                      aOwner->mFields.mValues, accepted.mValues)
               .get()));

  // Not `Validate`: it sends reverts to `aSource` immediately, and `aOwner`
  // cannot be serialized before it is attached.
  EachIndex([&](auto idx) {
    if (!accepted.mModified.contains(idx)) {
      return;
    }
    if (accepted.ValidateOne(idx, aOwner, aSource) == CanSetResult::Allow) {
      return;
    }
    aCorrection.mValues.Get(idx) = aOwner->mFields.mValues.Get(idx);
    aCorrection.mModified += idx;
    accepted.mModified -= idx;
  });

  if (!aCorrection.mModified.isEmpty()) {
    MOZ_LOG(Context::GetSyncLog(), LogLevel::Warning,
            ("Transaction::ReconcileInitialFields(#%" PRIx64
             ", childid %d): refused %s",
             aOwner->Id(), aSource->OtherChildID(),
             StringJoin(", "_ns, aCorrection.mModified,
                        [](nsACString& dest, const auto& idx) {
                          dest.Append(Context::FieldIndexToName(idx));
                        })
                 .get()));
  }

  // Not `Apply`: `DidSet` must not run on a context which is still being
  // constructed, and did not run for the values it was constructed with either.
  if (!accepted.mModified.isEmpty()) {
    accepted.CommitWithoutSyncing(aOwner);
  }
}

template <typename Context>
mozilla::ipc::IPCResult Transaction<Context>::CommitFromIPC(
    const MaybeDiscarded<Context>& aOwner, uint64_t aEpoch,
    ContentChild* aSource) {
  MOZ_DIAGNOSTIC_ASSERT(XRE_IsContentProcess());
  if (aOwner.IsNullOrDiscarded()) {
    MOZ_LOG(Context::GetSyncLog(), LogLevel::Debug,
            ("ChildIPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }
  Context* owner = aOwner.get();

  // Clear any fields which have been obsoleted by the epoch.
  EachIndex([&](auto idx) {
    if (mModified.contains(idx) && FieldEpoch(idx, owner) > aEpoch) {
      MOZ_LOG(
          Context::GetSyncLog(), LogLevel::Debug,
          ("Transaction::Obsoleted(#%" PRIx64 ", %" PRIu64 ">%" PRIu64 "): %s",
           owner->Id(), FieldEpoch(idx, owner), aEpoch,
           Context::FieldIndexToName(idx)));
      mModified -= idx;
    }
  });

  if (mModified.isEmpty()) {
    return IPC_OK();
  }

  Apply(owner, /* aFromIPC */ true);
  return IPC_OK();
}

template <typename Context>
void Transaction<Context>::Apply(Context* aOwner, bool aFromIPC) {
  MOZ_ASSERT(!mModified.isEmpty());

  MOZ_LOG(
      Context::GetSyncLog(), LogLevel::Debug,
      ("Transaction::Apply(#%" PRIx64 ", %s): %s", aOwner->Id(),
       aFromIPC ? "ipc" : "local",
       FormatTransaction<Context>(mModified, aOwner->mFields.mValues, mValues)
           .get()));

  EachIndex([&](auto idx) {
    if (mModified.contains(idx)) {
      auto& txnField = mValues.Get(idx);
      auto& ownerField = aOwner->mFields.mValues.Get(idx);
      std::swap(ownerField, txnField);
      aOwner->DidSet(idx);
      aOwner->DidSet(idx, std::move(txnField));
    }
  });
  mModified.clear();
}

template <typename Context>
void Transaction<Context>::CommitWithoutSyncing(Context* aOwner) {
  MOZ_LOG(
      Context::GetSyncLog(), LogLevel::Debug,
      ("Transaction::CommitWithoutSyncing(#%" PRIx64 "): %s", aOwner->Id(),
       FormatTransaction<Context>(mModified, aOwner->mFields.mValues, mValues)
           .get()));

  EachIndex([&](auto idx) {
    if (mModified.contains(idx)) {
      aOwner->mFields.mValues.Get(idx) = std::move(mValues.Get(idx));
    }
  });
  mModified.clear();
}

inline CanSetResult AsCanSetResult(CanSetResult aValue) { return aValue; }
inline CanSetResult AsCanSetResult(bool aValue) {
  return aValue ? CanSetResult::Allow : CanSetResult::Deny;
}

template <typename Context>
typename Transaction<Context>::IndexSet Transaction<Context>::Validate(
    Context* aOwner, ContentParent* aSource) {
  IndexSet failedFields;
  Transaction<Context> revertTxn;

  EachIndex([&](auto idx) {
    if (!mModified.contains(idx)) {
      return;
    }

    switch (ValidateOne(idx, aOwner, aSource)) {
      case CanSetResult::Allow:
        break;
      case CanSetResult::Deny:
        failedFields += idx;
        break;
      case CanSetResult::Revert:
        revertTxn.mValues.Get(idx) = aOwner->mFields.mValues.Get(idx);
        revertTxn.mModified += idx;
        break;
    }
  });

  // If any changes need to be reverted, log them, remove them from this
  // transaction, and optionally send a message to the source process.
  if (!revertTxn.mModified.isEmpty()) {
    // NOTE: Logging with modified IndexSet from revert transaction, and values
    // from this transaction, so we log the failed values we're going to revert.
    MOZ_LOG(Context::GetSyncLog(), LogLevel::Debug,
            ("Transaction::PartialRevert(#%" PRIx64 ", childid %d, pid %" PRIPID
             "): %s",
             aOwner->Id(), aSource ? aSource->OtherChildID() : -1,
             aSource ? aSource->OtherPid() : base::kInvalidProcessId,
             FormatTransaction<Context>(revertTxn.mModified, mValues,
                                        revertTxn.mValues)
                 .get()));

    mModified -= revertTxn.mModified;

    if (aSource) {
      aOwner->SendCommitTransaction(aSource, revertTxn,
                                    aSource->GetBrowsingContextFieldEpoch());
    }
  }
  return failedFields;
}

template <typename Context>
template <size_t I>
CanSetResult Transaction<Context>::ValidateOne(Index<I>, Context* aOwner,
                                               ContentParent* aSource) {
  constexpr FieldInfo info = Context::FieldIndexToInfo(Index<I>{});
  if constexpr (info.mTopOnly) {
    if (!aOwner->IsTop()) {
      return CanSetResult::Deny;
    }
  }

  if constexpr (info.mCanSet == CanSet::ParentOnly) {
    return AsCanSetResult(aOwner->CheckOnlyParentProcessCanSet(aSource));
  } else if constexpr (info.mCanSet == CanSet::EmbedderOnly) {
    // NOTE: This member is only on BrowsingContext.
    return AsCanSetResult(aOwner->CheckOnlyEmbedderCanSet(aSource));
  } else if constexpr (info.mCanSet == CanSet::EmbedderOrParentOnly) {
    // NOTE: This member is only on BrowsingContext.
    return AsCanSetResult(aOwner->CheckOnlyParentProcessCanSet(aSource) ||
                          aOwner->CheckOnlyEmbedderCanSet(aSource));
  } else if constexpr (info.mCanSet == CanSet::OwnerOnly) {
    // NOTE: This member is only on WindowContext.
    return AsCanSetResult(aOwner->CheckOnlyOwningProcessCanSet(aSource));
  } else if constexpr (info.mCanSet == CanSet::OwnerOrParentOnly) {
    // NOTE: This member is only on WindowContext.
    return AsCanSetResult(aOwner->CheckOnlyParentProcessCanSet(aSource) ||
                          aOwner->CheckOnlyOwningProcessCanSet(aSource));
  } else if constexpr (info.mCanSet == CanSet::Unrestricted) {
    return CanSetResult::Allow;
  } else {
    static_assert(info.mCanSet == CanSet::Custom,
                  "Field has unknown mCanSetValue for ValidateOne");
    return AsCanSetResult(
        aOwner->CanSet(Index<I>{}, mValues.Get(Index<I>{}), aSource));
  }
}

template <typename Context>
void Transaction<Context>::Write(IPC::MessageWriter* aWriter) const {
  // Record which field indices will be included, and then write those fields
  // out.
  typename IndexSet::serializedType modified = mModified.serialize();
  IPC::WriteParam(aWriter, modified);
  EachIndex([&](auto idx) {
    if (mModified.contains(idx)) {
      IPC::WriteParam(aWriter, mValues.Get(idx));
    }
  });
}

template <typename Context>
bool Transaction<Context>::Read(IPC::MessageReader* aReader) {
  // Read in which field indices were sent by the remote, followed by the fields
  // identified by those indices.
  typename IndexSet::serializedType modified =
      typename IndexSet::serializedType{};
  if (!IPC::ReadParam(aReader, &modified)) {
    return false;
  }
  mModified.deserialize(modified);

  bool ok = true;
  EachIndex([&](auto idx) {
    if (ok && mModified.contains(idx)) {
      ok = IPC::ReadParam(aReader, &mValues.Get(idx));
    }
  });
  return ok;
}

template <typename Base, size_t Count>
void FieldValues<Base, Count>::Write(IPC::MessageWriter* aWriter) const {
  // XXX The this-> qualification is necessary to work around a bug in older gcc
  // versions causing an ICE.
  EachIndex([&](auto idx) { IPC::WriteParam(aWriter, this->Get(idx)); });
}

template <typename Base, size_t Count>
bool FieldValues<Base, Count>::Read(IPC::MessageReader* aReader) {
  bool ok = true;
  EachIndex([&](auto idx) {
    if (ok) {
      // XXX The this-> qualification is necessary to work around a bug in older
      // gcc versions causing an ICE.
      ok = IPC::ReadParam(aReader, &this->Get(idx));
    }
  });
  return ok;
}

}  // namespace syncedcontext
}  // namespace dom
}  // namespace mozilla

#endif  // !defined(mozilla_dom_SyncedContextInlines_h)
