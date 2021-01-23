/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef dom_plugins_ipc_ipdltuple_h
#define dom_plugins_ipc_ipdltuple_h

#include "mozilla/plugins/FunctionBrokerIPCUtils.h"
#include "mozilla/Variant.h"

namespace mozilla {
namespace plugins {

// The stuff in this "internal" namespace used to be inside the IpdlTuple
// class, but that prevented the MOZ_DECLARE_RELOCATE_USING_MOVE_CONSTRUCTOR
// that is needed on the IpdlTupleElement struct. Without this, nsTArray can end
// up using a move constructor on this struct, which is not memmovable on
// Windows.
namespace internal {

struct InvalidType {};

// Like Variant but with a default constructor.
template <typename... Types>
struct MaybeVariant {
 public:
  MaybeVariant() : mValue(InvalidType()) {}
  MaybeVariant(MaybeVariant&& o) : mValue(std::move(o.mValue)) {}

  template <typename Param>
  void Set(const Param& aParam) {
    mValue = mozilla::AsVariant(aParam);
  }

  typedef mozilla::Variant<InvalidType, Types...> MaybeVariantType;
  MaybeVariantType& GetVariant() { return mValue; }
  const MaybeVariantType& GetVariant() const { return mValue; }

 private:
  MaybeVariantType mValue;
};

#if defined(XP_WIN)
typedef MaybeVariant<int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t,
                     int64_t, uint64_t, nsCString, nsString, bool,
                     OpenFileNameIPC, OpenFileNameRetIPC, NativeWindowHandle,
                     IPCSchannelCred, IPCInternetBuffers, StringArray,
                     IPCPrintDlg>
    IpdlTupleElement;
#else
typedef MaybeVariant<int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t,
                     int64_t, uint64_t, nsCString, nsString, bool>
    IpdlTupleElement;
#endif  // defined(XP_WIN)

}  // namespace internal
}  // namespace plugins
}  // namespace mozilla

MOZ_DECLARE_RELOCATE_USING_MOVE_CONSTRUCTOR(
    mozilla::plugins::internal::IpdlTupleElement)

namespace mozilla {
namespace plugins {

/**
 * IpdlTuple is used by automatic function brokering to pass parameter
 * lists for brokered functions.  It supports a limited set of types
 * (see IpdlTuple::IpdlTupleElement).
 */
class IpdlTuple {
 public:
  uint32_t NumElements() const { return mTupleElements.Length(); }

  template <typename EltType>
  EltType* Element(uint32_t index) {
    if ((index >= mTupleElements.Length()) ||
        !mTupleElements[index].GetVariant().is<EltType>()) {
      return nullptr;
    }
    return &mTupleElements[index].GetVariant().as<EltType>();
  }

  template <typename EltType>
  const EltType* Element(uint32_t index) const {
    return const_cast<IpdlTuple*>(this)->Element<EltType>(index);
  }

  template <typename EltType>
  void AddElement(const EltType& aElt) {
    IpdlTupleElement* newEntry = mTupleElements.AppendElement();
    newEntry->Set(aElt);
  }

 private:
  typedef mozilla::plugins::internal::InvalidType InvalidType;
  typedef mozilla::plugins::internal::IpdlTupleElement IpdlTupleElement;

  friend struct IPC::ParamTraits<IpdlTuple>;
  friend struct IPC::ParamTraits<IpdlTuple::IpdlTupleElement>;
  friend struct IPC::ParamTraits<IpdlTuple::InvalidType>;

  nsTArray<IpdlTupleElement> mTupleElements;
};

namespace internal {
template <>
template <>
inline void IpdlTupleElement::Set<nsDependentCSubstring>(
    const nsDependentCSubstring& aParam) {
  mValue = MaybeVariantType(mozilla::VariantType<nsCString>(), aParam);
}
}  // namespace internal

}  // namespace plugins
}  // namespace mozilla

namespace IPC {

using namespace mozilla::plugins;

template <>
struct ParamTraits<IpdlTuple> {
  typedef IpdlTuple paramType;

  static void Write(Message* aMsg, const paramType& aParam) {
    WriteParam(aMsg, aParam.mTupleElements);
  }

  static bool Read(const Message* aMsg, PickleIterator* aIter,
                   paramType* aParam) {
    return ReadParam(aMsg, aIter, &aParam->mTupleElements);
  }

  static void Log(const paramType& aParam, std::wstring* aLog) {
    LogParam(aParam.mTupleElements, aLog);
  }
};

template <>
struct ParamTraits<IpdlTuple::IpdlTupleElement> {
  typedef IpdlTuple::IpdlTupleElement paramType;

  static void Write(Message* aMsg, const paramType& aParam) {
    MOZ_RELEASE_ASSERT(!aParam.GetVariant().is<IpdlTuple::InvalidType>());
    WriteParam(aMsg, aParam.GetVariant());
  }

  static bool Read(const Message* aMsg, PickleIterator* aIter,
                   paramType* aParam) {
    bool ret = ReadParam(aMsg, aIter, &aParam->GetVariant());
    MOZ_RELEASE_ASSERT(!aParam->GetVariant().is<IpdlTuple::InvalidType>());
    return ret;
  }

  static void Log(const paramType& aParam, std::wstring* aLog) {
    aParam.GetVariant().match(
        [aLog](const auto& aParam) { LogParam(aParam, aLog); });
  }
};

template <>
struct ParamTraits<IpdlTuple::InvalidType> {
  typedef IpdlTuple::InvalidType paramType;

  static void Write(Message* aMsg, const paramType& aParam) {
    MOZ_ASSERT_UNREACHABLE("Attempt to serialize an invalid tuple element");
  }

  static bool Read(const Message* aMsg, PickleIterator* aIter,
                   paramType* aParam) {
    MOZ_ASSERT_UNREACHABLE("Attempt to deserialize an invalid tuple element");
    return false;
  }

  static void Log(const paramType& aParam, std::wstring* aLog) {
    aLog->append(L"<Invalid Tuple Entry>");
  }
};

}  // namespace IPC

#endif /* dom_plugins_ipc_ipdltuple_h */
