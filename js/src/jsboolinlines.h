/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jsboolinlines_h
#define jsboolinlines_h

#include "jsbool.h"

#include "vm/BooleanObject.h"
#include "vm/WrapperObject.h"

namespace js {

inline bool
EmulatesUndefined(JSObject* obj)
{
    // This may be called off the main thread. It's OK not to expose the object
    // here as it doesn't escape.
    JSObject* actual = MOZ_LIKELY(!obj->is<WrapperObject>()) ? obj : UncheckedUnwrapWithoutExpose(obj);
    return actual->getClass()->emulatesUndefined();
}

} /* namespace js */

#endif /* jsboolinlines_h */
