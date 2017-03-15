/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sw=4 et tw=80:
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_jsipc_JavaScriptBase_h__
#define mozilla_jsipc_JavaScriptBase_h__

#include "WrapperAnswer.h"
#include "WrapperOwner.h"
#include "mozilla/dom/DOMTypes.h"
#include "mozilla/jsipc/PJavaScript.h"

namespace mozilla {
namespace jsipc {

template<class Base>
class JavaScriptBase : public WrapperOwner, public WrapperAnswer, public Base
{
    typedef WrapperAnswer Answer;

  public:
    virtual ~JavaScriptBase() {}

    virtual void ActorDestroy(WrapperOwner::ActorDestroyReason why) {
        WrapperOwner::ActorDestroy(why);
    }

    /*** IPC handlers ***/

    bool RecvPreventExtensions(const uint64_t& objId, ReturnStatus* rs) {
        return Answer::RecvPreventExtensions(ObjectId::deserialize(objId), rs);
    }
    bool RecvGetPropertyDescriptor(const uint64_t& objId, const JSIDVariant& id,
                                     ReturnStatus* rs,
                                     PPropertyDescriptor* out) {
        return Answer::RecvGetPropertyDescriptor(ObjectId::deserialize(objId), id, rs, out);
    }
    bool RecvGetOwnPropertyDescriptor(const uint64_t& objId,
                                        const JSIDVariant& id,
                                        ReturnStatus* rs,
                                        PPropertyDescriptor* out) {
        return Answer::RecvGetOwnPropertyDescriptor(ObjectId::deserialize(objId), id, rs, out);
    }
    bool RecvDefineProperty(const uint64_t& objId, const JSIDVariant& id,
                            const PPropertyDescriptor& flags, ReturnStatus* rs) {
        return Answer::RecvDefineProperty(ObjectId::deserialize(objId), id, flags, rs);
    }
    bool RecvDelete(const uint64_t& objId, const JSIDVariant& id,
                      ReturnStatus* rs) {
        return Answer::RecvDelete(ObjectId::deserialize(objId), id, rs);
    }

    bool RecvHas(const uint64_t& objId, const JSIDVariant& id,
                   ReturnStatus* rs, bool* bp) {
        return Answer::RecvHas(ObjectId::deserialize(objId), id, rs, bp);
    }
    bool RecvHasOwn(const uint64_t& objId, const JSIDVariant& id,
                      ReturnStatus* rs, bool* bp) {
        return Answer::RecvHasOwn(ObjectId::deserialize(objId), id, rs, bp);
    }
    bool RecvGet(const uint64_t& objId, const JSVariant& receiverVar, const JSIDVariant& id,
                 ReturnStatus* rs, JSVariant* result) {
        return Answer::RecvGet(ObjectId::deserialize(objId), receiverVar, id, rs, result);
    }
    bool RecvSet(const uint64_t& objId, const JSIDVariant& id, const JSVariant& value,
                 const JSVariant& receiverVar, ReturnStatus* rs) {
        return Answer::RecvSet(ObjectId::deserialize(objId), id, value, receiverVar, rs);
    }

    bool RecvIsExtensible(const uint64_t& objId, ReturnStatus* rs,
                            bool* result) {
        return Answer::RecvIsExtensible(ObjectId::deserialize(objId), rs, result);
    }
    bool RecvCallOrConstruct(const uint64_t& objId, InfallibleTArray<JSParam>&& argv,
                             const bool& construct, ReturnStatus* rs, JSVariant* result,
                             nsTArray<JSParam>* outparams) {
        return Answer::RecvCallOrConstruct(ObjectId::deserialize(objId), Move(argv), construct, rs, result, outparams);
    }
    bool RecvHasInstance(const uint64_t& objId, const JSVariant& v, ReturnStatus* rs, bool* bp) {
        return Answer::RecvHasInstance(ObjectId::deserialize(objId), v, rs, bp);
    }
    bool RecvGetBuiltinClass(const uint64_t& objId, ReturnStatus* rs, uint32_t* classValue) {
        return Answer::RecvGetBuiltinClass(ObjectId::deserialize(objId), rs, classValue);
    }
    bool RecvIsArray(const uint64_t& objId, ReturnStatus* rs, uint32_t* answer) {
        return Answer::RecvIsArray(ObjectId::deserialize(objId), rs, answer);
    }
    bool RecvClassName(const uint64_t& objId, nsCString* result) {
        return Answer::RecvClassName(ObjectId::deserialize(objId), result);
    }
    bool RecvGetPrototype(const uint64_t& objId, ReturnStatus* rs, ObjectOrNullVariant* result) {
        return Answer::RecvGetPrototype(ObjectId::deserialize(objId), rs, result);
    }
    bool RecvGetPrototypeIfOrdinary(const uint64_t& objId, ReturnStatus* rs, bool* isOrdinary,
                                    ObjectOrNullVariant* result)
    {
        return Answer::RecvGetPrototypeIfOrdinary(ObjectId::deserialize(objId), rs, isOrdinary, result);
    }
    bool RecvRegExpToShared(const uint64_t& objId, ReturnStatus* rs, nsString* source, uint32_t* flags) {
        return Answer::RecvRegExpToShared(ObjectId::deserialize(objId), rs, source, flags);
    }

    bool RecvGetPropertyKeys(const uint64_t& objId, const uint32_t& flags,
                             ReturnStatus* rs, nsTArray<JSIDVariant>* ids) {
        return Answer::RecvGetPropertyKeys(ObjectId::deserialize(objId), flags, rs, ids);
    }
    bool RecvInstanceOf(const uint64_t& objId, const JSIID& iid,
                          ReturnStatus* rs, bool* instanceof) {
        return Answer::RecvInstanceOf(ObjectId::deserialize(objId), iid, rs, instanceof);
    }
    bool RecvDOMInstanceOf(const uint64_t& objId, const int& prototypeID, const int& depth,
                             ReturnStatus* rs, bool* instanceof) {
        return Answer::RecvDOMInstanceOf(ObjectId::deserialize(objId), prototypeID, depth, rs, instanceof);
    }

    bool RecvDropObject(const uint64_t& objId) {
        return Answer::RecvDropObject(ObjectId::deserialize(objId));
    }

    /*** Dummy call handlers ***/

    bool SendDropObject(const ObjectId& objId) {
        return Base::SendDropObject(objId.serialize());
    }
    bool SendPreventExtensions(const ObjectId& objId, ReturnStatus* rs) {
        return Base::SendPreventExtensions(objId.serialize(), rs);
    }
    bool SendGetPropertyDescriptor(const ObjectId& objId, const JSIDVariant& id,
                                     ReturnStatus* rs,
                                     PPropertyDescriptor* out) {
        return Base::SendGetPropertyDescriptor(objId.serialize(), id, rs, out);
    }
    bool SendGetOwnPropertyDescriptor(const ObjectId& objId,
                                      const JSIDVariant& id,
                                      ReturnStatus* rs,
                                      PPropertyDescriptor* out) {
        return Base::SendGetOwnPropertyDescriptor(objId.serialize(), id, rs, out);
    }
    bool SendDefineProperty(const ObjectId& objId, const JSIDVariant& id,
                            const PPropertyDescriptor& flags,
                            ReturnStatus* rs) {
        return Base::SendDefineProperty(objId.serialize(), id, flags, rs);
    }
    bool SendDelete(const ObjectId& objId, const JSIDVariant& id, ReturnStatus* rs) {
        return Base::SendDelete(objId.serialize(), id, rs);
    }

    bool SendHas(const ObjectId& objId, const JSIDVariant& id,
                   ReturnStatus* rs, bool* bp) {
        return Base::SendHas(objId.serialize(), id, rs, bp);
    }
    bool SendHasOwn(const ObjectId& objId, const JSIDVariant& id,
                    ReturnStatus* rs, bool* bp) {
        return Base::SendHasOwn(objId.serialize(), id, rs, bp);
    }
    bool SendGet(const ObjectId& objId, const JSVariant& receiverVar, const JSIDVariant& id,
                 ReturnStatus* rs, JSVariant* result) {
        return Base::SendGet(objId.serialize(), receiverVar, id, rs, result);
    }
    bool SendSet(const ObjectId& objId, const JSIDVariant& id, const JSVariant& value,
                 const JSVariant& receiverVar, ReturnStatus* rs) {
        return Base::SendSet(objId.serialize(), id, value, receiverVar, rs);
    }

    bool SendIsExtensible(const ObjectId& objId, ReturnStatus* rs,
                          bool* result) {
        return Base::SendIsExtensible(objId.serialize(), rs, result);
    }
    bool SendCallOrConstruct(const ObjectId& objId, const nsTArray<JSParam>& argv,
                             const bool& construct, ReturnStatus* rs, JSVariant* result,
                             nsTArray<JSParam>* outparams) {
        return Base::SendCallOrConstruct(objId.serialize(), argv, construct, rs, result, outparams);
    }
    bool SendHasInstance(const ObjectId& objId, const JSVariant& v, ReturnStatus* rs, bool* bp) {
        return Base::SendHasInstance(objId.serialize(), v, rs, bp);
    }
    bool SendGetBuiltinClass(const ObjectId& objId, ReturnStatus* rs, uint32_t* classValue) {
        return Base::SendGetBuiltinClass(objId.serialize(), rs, classValue);
    }
    bool SendIsArray(const ObjectId& objId, ReturnStatus* rs, uint32_t* answer)
    {
        return Base::SendIsArray(objId.serialize(), rs, answer);
    }
    bool SendClassName(const ObjectId& objId, nsCString* result) {
        return Base::SendClassName(objId.serialize(), result);
    }
    bool SendGetPrototype(const ObjectId& objId, ReturnStatus* rs, ObjectOrNullVariant* result) {
        return Base::SendGetPrototype(objId.serialize(), rs, result);
    }
    bool SendGetPrototypeIfOrdinary(const ObjectId& objId, ReturnStatus* rs, bool* isOrdinary,
                                    ObjectOrNullVariant* result)
    {
        return Base::SendGetPrototypeIfOrdinary(objId.serialize(), rs, isOrdinary, result);
    }

    bool SendRegExpToShared(const ObjectId& objId, ReturnStatus* rs,
                            nsString* source, uint32_t* flags) {
        return Base::SendRegExpToShared(objId.serialize(), rs, source, flags);
    }

    bool SendGetPropertyKeys(const ObjectId& objId, const uint32_t& flags,
                             ReturnStatus* rs, nsTArray<JSIDVariant>* ids) {
        return Base::SendGetPropertyKeys(objId.serialize(), flags, rs, ids);
    }
    bool SendInstanceOf(const ObjectId& objId, const JSIID& iid,
                        ReturnStatus* rs, bool* instanceof) {
        return Base::SendInstanceOf(objId.serialize(), iid, rs, instanceof);
    }
    bool SendDOMInstanceOf(const ObjectId& objId, const int& prototypeID, const int& depth,
                           ReturnStatus* rs, bool* instanceof) {
        return Base::SendDOMInstanceOf(objId.serialize(), prototypeID, depth, rs, instanceof);
    }

    /* The following code is needed to suppress a bogus MSVC warning (C4250). */

    virtual bool toObjectVariant(JSContext* cx, JSObject* obj, ObjectVariant* objVarp) {
        return WrapperOwner::toObjectVariant(cx, obj, objVarp);
    }
    virtual JSObject* fromObjectVariant(JSContext* cx, const ObjectVariant& objVar) {
        return WrapperOwner::fromObjectVariant(cx, objVar);
    }
};

} // namespace jsipc
} // namespace mozilla

#endif
