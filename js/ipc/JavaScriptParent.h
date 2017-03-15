/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=4 sw=4 et tw=80:
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_jsipc_JavaScriptParent__
#define mozilla_jsipc_JavaScriptParent__

#include "JavaScriptBase.h"
#include "mozilla/jsipc/PJavaScriptParent.h"

namespace mozilla {
namespace jsipc {

class JavaScriptParent : public JavaScriptBase<PJavaScriptParent>
{
  public:
    JavaScriptParent() : savedNextCPOWNumber_(1) {}
    virtual ~JavaScriptParent();

    bool init();
    void trace(JSTracer* trc);

    void drop(JSObject* obj);

    bool allowMessage(JSContext* cx) override;
    void afterProcessTask();

  protected:
    virtual bool isParent() override { return true; }
    virtual JSObject* scopeForTargetObjects() override;

  private:
    uint64_t savedNextCPOWNumber_;
};

} // namespace jsipc
} // namespace mozilla

#endif // mozilla_jsipc_JavaScriptWrapper_h__

