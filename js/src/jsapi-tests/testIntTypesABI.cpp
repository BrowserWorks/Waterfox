/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * This test exercises the full, deliberately-exposed JSAPI interface to ensure
 * that no internal integer typedefs leak out.  Include every intentionally
 * public header file (and those headers included by them, for completeness),
 * even the ones tests.h itself included, to verify this.
 */

#include "jscpucfg.h"
#include "jspubtd.h"
#include "jstypes.h"

#include "js/CallArgs.h"
#include "js/CallNonGenericMethod.h"
#include "js/CharacterEncoding.h"
#include "js/Class.h"
#include "js/Date.h"
#include "js/Debug.h"
#include "js/GCAPI.h"
#include "js/HashTable.h"
#include "js/HeapAPI.h"
#include "js/Id.h"
/* LegacyIntTypes.h is deliberately exempted from this requirement */
#include "js/MemoryMetrics.h"
#include "js/ProfilingStack.h"
#include "js/RefCounted.h"
#include "js/RequiredDefines.h"
#include "js/RootingAPI.h"
#include "js/SliceBudget.h"
#include "js/Stream.h"
#include "js/StructuredClone.h"
#include "js/TracingAPI.h"
#include "js/TrackedOptimizationInfo.h"
#include "js/TypeDecls.h"
#include "js/UbiNode.h"
#include "js/Utility.h"
#include "js/Value.h"
#include "js/Vector.h"
#include "js/WeakMapPtr.h"
#include "jsapi-tests/tests.h"

/*
 * Verify that our public (and intended to be public, versus being that way
 * because we haven't made them private yet) headers don't define
 * {u,}int{8,16,32,64} or JS{Ui,I}nt{8,16,32,64} types.  If any do, they will
 * assuredly conflict with a corresponding typedef below mapping to a *struct*.
 *
 * Note that tests.h includes a few internal headers; in order that this
 * jsapi-test be writable, those internal headers must not import the legacy
 * typedefs.
 */

struct ConflictingType {
    uint64_t u64;
};

typedef ConflictingType uint8;
typedef ConflictingType uint16;
typedef ConflictingType uint32;
typedef ConflictingType uint64;

typedef ConflictingType int8;
typedef ConflictingType int16;
typedef ConflictingType int32;
typedef ConflictingType int64;

typedef ConflictingType JSUint8;
typedef ConflictingType JSUint16;
typedef ConflictingType JSUint32;
typedef ConflictingType JSUint64;

typedef ConflictingType JSInt8;
typedef ConflictingType JSInt16;
typedef ConflictingType JSInt32;
typedef ConflictingType JSInt64;

typedef ConflictingType jsword;
typedef ConflictingType jsuword;
typedef ConflictingType JSWord;
typedef ConflictingType JSUword;

BEGIN_TEST(testIntTypesABI)
{
    /* This passes if the typedefs didn't conflict at compile time. */
    return true;
}
END_TEST(testIntTypesABI)
