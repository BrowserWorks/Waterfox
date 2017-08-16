#include "TypedObjectConstants.h"

///////////////////////////////////////////////////////////////////////////
// Getters and setters for various slots.

// Type object slots

#define DESCR_KIND(obj) \
    UnsafeGetInt32FromReservedSlot(obj, JS_DESCR_SLOT_KIND)
#define DESCR_STRING_REPR(obj) \
    UnsafeGetStringFromReservedSlot(obj, JS_DESCR_SLOT_STRING_REPR)
#define DESCR_ALIGNMENT(obj) \
    UnsafeGetInt32FromReservedSlot(obj, JS_DESCR_SLOT_ALIGNMENT)
#define DESCR_SIZE(obj) \
    UnsafeGetInt32FromReservedSlot(obj, JS_DESCR_SLOT_SIZE)
#define DESCR_OPAQUE(obj) \
    UnsafeGetBooleanFromReservedSlot(obj, JS_DESCR_SLOT_OPAQUE)
#define DESCR_TYPE(obj)   \
    UnsafeGetInt32FromReservedSlot(obj, JS_DESCR_SLOT_TYPE)
#define DESCR_ARRAY_ELEMENT_TYPE(obj) \
    UnsafeGetObjectFromReservedSlot(obj, JS_DESCR_SLOT_ARRAY_ELEM_TYPE)
#define DESCR_ARRAY_LENGTH(obj) \
    TO_INT32(UnsafeGetInt32FromReservedSlot(obj, JS_DESCR_SLOT_ARRAY_LENGTH))
#define DESCR_STRUCT_FIELD_NAMES(obj) \
    UnsafeGetObjectFromReservedSlot(obj, JS_DESCR_SLOT_STRUCT_FIELD_NAMES)
#define DESCR_STRUCT_FIELD_TYPES(obj) \
    UnsafeGetObjectFromReservedSlot(obj, JS_DESCR_SLOT_STRUCT_FIELD_TYPES)
#define DESCR_STRUCT_FIELD_OFFSETS(obj) \
    UnsafeGetObjectFromReservedSlot(obj, JS_DESCR_SLOT_STRUCT_FIELD_OFFSETS)

///////////////////////////////////////////////////////////////////////////
// Getting values
//
// The methods in this section read from the memory pointed at
// by `this` and produce JS values. This process is called *reification*
// in the spec.

// Reifies the value referenced by the pointer, meaning that it
// returns a new object pointing at the value. If the value is
// a scalar, it will return a JS number, but otherwise the reified
// result will be a typedObj of the same class as the ptr's typedObj.
function TypedObjectGet(descr, typedObj, offset) {
  assert(IsObject(descr) && ObjectIsTypeDescr(descr),
         "get() called with bad type descr");

  if (!TypedObjectIsAttached(typedObj))
    ThrowTypeError(JSMSG_TYPEDOBJECT_HANDLE_UNATTACHED);

  switch (DESCR_KIND(descr)) {
  case JS_TYPEREPR_SCALAR_KIND:
    return TypedObjectGetScalar(descr, typedObj, offset);

  case JS_TYPEREPR_REFERENCE_KIND:
    return TypedObjectGetReference(descr, typedObj, offset);

  case JS_TYPEREPR_SIMD_KIND:
    return TypedObjectGetSimd(descr, typedObj, offset);

  case JS_TYPEREPR_ARRAY_KIND:
  case JS_TYPEREPR_STRUCT_KIND:
    return TypedObjectGetDerived(descr, typedObj, offset);
  }

  assert(false, "Unhandled kind: " + DESCR_KIND(descr));
  return undefined;
}

function TypedObjectGetDerived(descr, typedObj, offset) {
  assert(!TypeDescrIsSimpleType(descr),
         "getDerived() used with simple type");
  return NewDerivedTypedObject(descr, typedObj, offset);
}

function TypedObjectGetDerivedIf(descr, typedObj, offset, cond) {
  return (cond ? TypedObjectGetDerived(descr, typedObj, offset) : undefined);
}

function TypedObjectGetOpaque(descr, typedObj, offset) {
  assert(!TypeDescrIsSimpleType(descr),
         "getDerived() used with simple type");
  var opaqueTypedObj = NewOpaqueTypedObject(descr);
  AttachTypedObject(opaqueTypedObj, typedObj, offset);
  return opaqueTypedObj;
}

function TypedObjectGetOpaqueIf(descr, typedObj, offset, cond) {
  return (cond ? TypedObjectGetOpaque(descr, typedObj, offset) : undefined);
}

function TypedObjectGetScalar(descr, typedObj, offset) {
  var type = DESCR_TYPE(descr);
  switch (type) {
  case JS_SCALARTYPEREPR_INT8:
    return Load_int8(typedObj, offset);

  case JS_SCALARTYPEREPR_UINT8:
  case JS_SCALARTYPEREPR_UINT8_CLAMPED:
    return Load_uint8(typedObj, offset);

  case JS_SCALARTYPEREPR_INT16:
    return Load_int16(typedObj, offset);

  case JS_SCALARTYPEREPR_UINT16:
    return Load_uint16(typedObj, offset);

  case JS_SCALARTYPEREPR_INT32:
    return Load_int32(typedObj, offset);

  case JS_SCALARTYPEREPR_UINT32:
    return Load_uint32(typedObj, offset);

  case JS_SCALARTYPEREPR_FLOAT32:
    return Load_float32(typedObj, offset);

  case JS_SCALARTYPEREPR_FLOAT64:
    return Load_float64(typedObj, offset);
  }

  assert(false, "Unhandled scalar type: " + type);
  return undefined;
}

function TypedObjectGetReference(descr, typedObj, offset) {
  var type = DESCR_TYPE(descr);
  switch (type) {
  case JS_REFERENCETYPEREPR_ANY:
    return Load_Any(typedObj, offset);

  case JS_REFERENCETYPEREPR_OBJECT:
    return Load_Object(typedObj, offset);

  case JS_REFERENCETYPEREPR_STRING:
    return Load_string(typedObj, offset);
  }

  assert(false, "Unhandled scalar type: " + type);
  return undefined;
}

function TypedObjectGetSimd(descr, typedObj, offset) {
  var type = DESCR_TYPE(descr);
  var simdTypeDescr = GetSimdTypeDescr(type);
  switch (type) {
  case JS_SIMDTYPEREPR_FLOAT32X4:
    var x = Load_float32(typedObj, offset + 0);
    var y = Load_float32(typedObj, offset + 4);
    var z = Load_float32(typedObj, offset + 8);
    var w = Load_float32(typedObj, offset + 12);
    return simdTypeDescr(x, y, z, w);

  case JS_SIMDTYPEREPR_FLOAT64X2:
    var x = Load_float64(typedObj, offset + 0);
    var y = Load_float64(typedObj, offset + 8);
    return simdTypeDescr(x, y);

  case JS_SIMDTYPEREPR_INT8X16:
    var s0 = Load_int8(typedObj, offset + 0);
    var s1 = Load_int8(typedObj, offset + 1);
    var s2 = Load_int8(typedObj, offset + 2);
    var s3 = Load_int8(typedObj, offset + 3);
    var s4 = Load_int8(typedObj, offset + 4);
    var s5 = Load_int8(typedObj, offset + 5);
    var s6 = Load_int8(typedObj, offset + 6);
    var s7 = Load_int8(typedObj, offset + 7);
    var s8 = Load_int8(typedObj, offset + 8);
    var s9 = Load_int8(typedObj, offset + 9);
    var s10 = Load_int8(typedObj, offset + 10);
    var s11 = Load_int8(typedObj, offset + 11);
    var s12 = Load_int8(typedObj, offset + 12);
    var s13 = Load_int8(typedObj, offset + 13);
    var s14 = Load_int8(typedObj, offset + 14);
    var s15 = Load_int8(typedObj, offset + 15);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);

  case JS_SIMDTYPEREPR_INT16X8:
    var s0 = Load_int16(typedObj, offset + 0);
    var s1 = Load_int16(typedObj, offset + 2);
    var s2 = Load_int16(typedObj, offset + 4);
    var s3 = Load_int16(typedObj, offset + 6);
    var s4 = Load_int16(typedObj, offset + 8);
    var s5 = Load_int16(typedObj, offset + 10);
    var s6 = Load_int16(typedObj, offset + 12);
    var s7 = Load_int16(typedObj, offset + 14);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7);

  case JS_SIMDTYPEREPR_INT32X4:
    var x = Load_int32(typedObj, offset + 0);
    var y = Load_int32(typedObj, offset + 4);
    var z = Load_int32(typedObj, offset + 8);
    var w = Load_int32(typedObj, offset + 12);
    return simdTypeDescr(x, y, z, w);

  case JS_SIMDTYPEREPR_UINT8X16:
    var s0 = Load_uint8(typedObj, offset + 0);
    var s1 = Load_uint8(typedObj, offset + 1);
    var s2 = Load_uint8(typedObj, offset + 2);
    var s3 = Load_uint8(typedObj, offset + 3);
    var s4 = Load_uint8(typedObj, offset + 4);
    var s5 = Load_uint8(typedObj, offset + 5);
    var s6 = Load_uint8(typedObj, offset + 6);
    var s7 = Load_uint8(typedObj, offset + 7);
    var s8 = Load_uint8(typedObj, offset + 8);
    var s9 = Load_uint8(typedObj, offset + 9);
    var s10 = Load_uint8(typedObj, offset + 10);
    var s11 = Load_uint8(typedObj, offset + 11);
    var s12 = Load_uint8(typedObj, offset + 12);
    var s13 = Load_uint8(typedObj, offset + 13);
    var s14 = Load_uint8(typedObj, offset + 14);
    var s15 = Load_uint8(typedObj, offset + 15);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);

  case JS_SIMDTYPEREPR_UINT16X8:
    var s0 = Load_uint16(typedObj, offset + 0);
    var s1 = Load_uint16(typedObj, offset + 2);
    var s2 = Load_uint16(typedObj, offset + 4);
    var s3 = Load_uint16(typedObj, offset + 6);
    var s4 = Load_uint16(typedObj, offset + 8);
    var s5 = Load_uint16(typedObj, offset + 10);
    var s6 = Load_uint16(typedObj, offset + 12);
    var s7 = Load_uint16(typedObj, offset + 14);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7);

  case JS_SIMDTYPEREPR_UINT32X4:
    var x = Load_uint32(typedObj, offset + 0);
    var y = Load_uint32(typedObj, offset + 4);
    var z = Load_uint32(typedObj, offset + 8);
    var w = Load_uint32(typedObj, offset + 12);
    return simdTypeDescr(x, y, z, w);

  case JS_SIMDTYPEREPR_BOOL8X16:
    var s0 = Load_int8(typedObj, offset + 0);
    var s1 = Load_int8(typedObj, offset + 1);
    var s2 = Load_int8(typedObj, offset + 2);
    var s3 = Load_int8(typedObj, offset + 3);
    var s4 = Load_int8(typedObj, offset + 4);
    var s5 = Load_int8(typedObj, offset + 5);
    var s6 = Load_int8(typedObj, offset + 6);
    var s7 = Load_int8(typedObj, offset + 7);
    var s8 = Load_int8(typedObj, offset + 8);
    var s9 = Load_int8(typedObj, offset + 9);
    var s10 = Load_int8(typedObj, offset + 10);
    var s11 = Load_int8(typedObj, offset + 11);
    var s12 = Load_int8(typedObj, offset + 12);
    var s13 = Load_int8(typedObj, offset + 13);
    var s14 = Load_int8(typedObj, offset + 14);
    var s15 = Load_int8(typedObj, offset + 15);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);

  case JS_SIMDTYPEREPR_BOOL16X8:
    var s0 = Load_int16(typedObj, offset + 0);
    var s1 = Load_int16(typedObj, offset + 2);
    var s2 = Load_int16(typedObj, offset + 4);
    var s3 = Load_int16(typedObj, offset + 6);
    var s4 = Load_int16(typedObj, offset + 8);
    var s5 = Load_int16(typedObj, offset + 10);
    var s6 = Load_int16(typedObj, offset + 12);
    var s7 = Load_int16(typedObj, offset + 14);
    return simdTypeDescr(s0, s1, s2, s3, s4, s5, s6, s7);

  case JS_SIMDTYPEREPR_BOOL32X4:
    var x = Load_int32(typedObj, offset + 0);
    var y = Load_int32(typedObj, offset + 4);
    var z = Load_int32(typedObj, offset + 8);
    var w = Load_int32(typedObj, offset + 12);
    return simdTypeDescr(x, y, z, w);

  case JS_SIMDTYPEREPR_BOOL64X2:
    var x = Load_int32(typedObj, offset + 0);
    var y = Load_int32(typedObj, offset + 8);
    return simdTypeDescr(x, y);

  }

  assert(false, "Unhandled SIMD type: " + type);
  return undefined;
}

///////////////////////////////////////////////////////////////////////////
// Setting values
//
// The methods in this section modify the data pointed at by `this`.

// Writes `fromValue` into the `typedObj` at offset `offset`, adapting
// it to `descr` as needed. This is the most general entry point
// and works for any type.
function TypedObjectSet(descr, typedObj, offset, name, fromValue) {
  if (!TypedObjectIsAttached(typedObj))
    ThrowTypeError(JSMSG_TYPEDOBJECT_HANDLE_UNATTACHED);

  switch (DESCR_KIND(descr)) {
  case JS_TYPEREPR_SCALAR_KIND:
    TypedObjectSetScalar(descr, typedObj, offset, fromValue);
    return;

  case JS_TYPEREPR_REFERENCE_KIND:
    TypedObjectSetReference(descr, typedObj, offset, name, fromValue);
    return;

  case JS_TYPEREPR_SIMD_KIND:
    TypedObjectSetSimd(descr, typedObj, offset, fromValue);
    return;

  case JS_TYPEREPR_ARRAY_KIND:
    var length = DESCR_ARRAY_LENGTH(descr);
    if (TypedObjectSetArray(descr, length, typedObj, offset, fromValue))
      return;
    break;

  case JS_TYPEREPR_STRUCT_KIND:
    if (!IsObject(fromValue))
      break;

    // Adapt each field.
    var fieldNames = DESCR_STRUCT_FIELD_NAMES(descr);
    var fieldDescrs = DESCR_STRUCT_FIELD_TYPES(descr);
    var fieldOffsets = DESCR_STRUCT_FIELD_OFFSETS(descr);
    for (var i = 0; i < fieldNames.length; i++) {
      var fieldName = fieldNames[i];
      var fieldDescr = fieldDescrs[i];
      var fieldOffset = fieldOffsets[i];
      var fieldValue = fromValue[fieldName];
      TypedObjectSet(fieldDescr, typedObj, offset + fieldOffset, fieldName, fieldValue);
    }
    return;
  }

  ThrowTypeError(JSMSG_CANT_CONVERT_TO,
                 typeof(fromValue),
                 DESCR_STRING_REPR(descr));
}

function TypedObjectSetArray(descr, length, typedObj, offset, fromValue) {
  if (!IsObject(fromValue))
    return false;

  // Check that "array-like" fromValue has an appropriate length.
  if (fromValue.length !== length)
    return false;

  // Adapt each element.
  if (length > 0) {
    var elemDescr = DESCR_ARRAY_ELEMENT_TYPE(descr);
    var elemSize = DESCR_SIZE(elemDescr);
    var elemOffset = offset;
    for (var i = 0; i < length; i++) {
      TypedObjectSet(elemDescr, typedObj, elemOffset, null, fromValue[i]);
      elemOffset += elemSize;
    }
  }
  return true;
}

// Sets `fromValue` to `this` assuming that `this` is a scalar type.
function TypedObjectSetScalar(descr, typedObj, offset, fromValue) {
  assert(DESCR_KIND(descr) === JS_TYPEREPR_SCALAR_KIND,
         "Expected scalar type descriptor");
  var type = DESCR_TYPE(descr);
  switch (type) {
  case JS_SCALARTYPEREPR_INT8:
    return Store_int8(typedObj, offset,
                      TO_INT32(fromValue) & 0xFF);

  case JS_SCALARTYPEREPR_UINT8:
    return Store_uint8(typedObj, offset,
                       TO_UINT32(fromValue) & 0xFF);

  case JS_SCALARTYPEREPR_UINT8_CLAMPED:
    var v = ClampToUint8(+fromValue);
    return Store_int8(typedObj, offset, v);

  case JS_SCALARTYPEREPR_INT16:
    return Store_int16(typedObj, offset,
                       TO_INT32(fromValue) & 0xFFFF);

  case JS_SCALARTYPEREPR_UINT16:
    return Store_uint16(typedObj, offset,
                        TO_UINT32(fromValue) & 0xFFFF);

  case JS_SCALARTYPEREPR_INT32:
    return Store_int32(typedObj, offset,
                       TO_INT32(fromValue));

  case JS_SCALARTYPEREPR_UINT32:
    return Store_uint32(typedObj, offset,
                        TO_UINT32(fromValue));

  case JS_SCALARTYPEREPR_FLOAT32:
    return Store_float32(typedObj, offset, +fromValue);

  case JS_SCALARTYPEREPR_FLOAT64:
    return Store_float64(typedObj, offset, +fromValue);
  }

  assert(false, "Unhandled scalar type: " + type);
  return undefined;
}

function TypedObjectSetReference(descr, typedObj, offset, name, fromValue) {
  var type = DESCR_TYPE(descr);
  switch (type) {
  case JS_REFERENCETYPEREPR_ANY:
    return Store_Any(typedObj, offset, name, fromValue);

  case JS_REFERENCETYPEREPR_OBJECT:
    var value = (fromValue === null ? fromValue : ToObject(fromValue));
    return Store_Object(typedObj, offset, name, value);

  case JS_REFERENCETYPEREPR_STRING:
    return Store_string(typedObj, offset, name, ToString(fromValue));
  }

  assert(false, "Unhandled scalar type: " + type);
  return undefined;
}

// Sets `fromValue` to `this` assuming that `this` is a scalar type.
function TypedObjectSetSimd(descr, typedObj, offset, fromValue) {
  if (!IsObject(fromValue) || !ObjectIsTypedObject(fromValue))
    ThrowTypeError(JSMSG_CANT_CONVERT_TO,
                   typeof(fromValue),
                   DESCR_STRING_REPR(descr));

  if (!DescrsEquiv(descr, TypedObjectTypeDescr(fromValue)))
    ThrowTypeError(JSMSG_CANT_CONVERT_TO,
                   typeof(fromValue),
                   DESCR_STRING_REPR(descr));

  var type = DESCR_TYPE(descr);
  switch (type) {
    case JS_SIMDTYPEREPR_FLOAT32X4:
      Store_float32(typedObj, offset + 0, Load_float32(fromValue, 0));
      Store_float32(typedObj, offset + 4, Load_float32(fromValue, 4));
      Store_float32(typedObj, offset + 8, Load_float32(fromValue, 8));
      Store_float32(typedObj, offset + 12, Load_float32(fromValue, 12));
      break;
    case JS_SIMDTYPEREPR_FLOAT64X2:
      Store_float64(typedObj, offset + 0, Load_float64(fromValue, 0));
      Store_float64(typedObj, offset + 8, Load_float64(fromValue, 8));
      break;
    case JS_SIMDTYPEREPR_INT8X16:
    case JS_SIMDTYPEREPR_BOOL8X16:
      Store_int8(typedObj, offset + 0, Load_int8(fromValue, 0));
      Store_int8(typedObj, offset + 1, Load_int8(fromValue, 1));
      Store_int8(typedObj, offset + 2, Load_int8(fromValue, 2));
      Store_int8(typedObj, offset + 3, Load_int8(fromValue, 3));
      Store_int8(typedObj, offset + 4, Load_int8(fromValue, 4));
      Store_int8(typedObj, offset + 5, Load_int8(fromValue, 5));
      Store_int8(typedObj, offset + 6, Load_int8(fromValue, 6));
      Store_int8(typedObj, offset + 7, Load_int8(fromValue, 7));
      Store_int8(typedObj, offset + 8, Load_int8(fromValue, 8));
      Store_int8(typedObj, offset + 9, Load_int8(fromValue, 9));
      Store_int8(typedObj, offset + 10, Load_int8(fromValue, 10));
      Store_int8(typedObj, offset + 11, Load_int8(fromValue, 11));
      Store_int8(typedObj, offset + 12, Load_int8(fromValue, 12));
      Store_int8(typedObj, offset + 13, Load_int8(fromValue, 13));
      Store_int8(typedObj, offset + 14, Load_int8(fromValue, 14));
      Store_int8(typedObj, offset + 15, Load_int8(fromValue, 15));
      break;
    case JS_SIMDTYPEREPR_INT16X8:
    case JS_SIMDTYPEREPR_BOOL16X8:
      Store_int16(typedObj, offset + 0, Load_int16(fromValue, 0));
      Store_int16(typedObj, offset + 2, Load_int16(fromValue, 2));
      Store_int16(typedObj, offset + 4, Load_int16(fromValue, 4));
      Store_int16(typedObj, offset + 6, Load_int16(fromValue, 6));
      Store_int16(typedObj, offset + 8, Load_int16(fromValue, 8));
      Store_int16(typedObj, offset + 10, Load_int16(fromValue, 10));
      Store_int16(typedObj, offset + 12, Load_int16(fromValue, 12));
      Store_int16(typedObj, offset + 14, Load_int16(fromValue, 14));
      break;
    case JS_SIMDTYPEREPR_INT32X4:
    case JS_SIMDTYPEREPR_BOOL32X4:
    case JS_SIMDTYPEREPR_BOOL64X2:
      Store_int32(typedObj, offset + 0, Load_int32(fromValue, 0));
      Store_int32(typedObj, offset + 4, Load_int32(fromValue, 4));
      Store_int32(typedObj, offset + 8, Load_int32(fromValue, 8));
      Store_int32(typedObj, offset + 12, Load_int32(fromValue, 12));
      break;
    case JS_SIMDTYPEREPR_UINT8X16:
      Store_uint8(typedObj, offset + 0, Load_uint8(fromValue, 0));
      Store_uint8(typedObj, offset + 1, Load_uint8(fromValue, 1));
      Store_uint8(typedObj, offset + 2, Load_uint8(fromValue, 2));
      Store_uint8(typedObj, offset + 3, Load_uint8(fromValue, 3));
      Store_uint8(typedObj, offset + 4, Load_uint8(fromValue, 4));
      Store_uint8(typedObj, offset + 5, Load_uint8(fromValue, 5));
      Store_uint8(typedObj, offset + 6, Load_uint8(fromValue, 6));
      Store_uint8(typedObj, offset + 7, Load_uint8(fromValue, 7));
      Store_uint8(typedObj, offset + 8, Load_uint8(fromValue, 8));
      Store_uint8(typedObj, offset + 9, Load_uint8(fromValue, 9));
      Store_uint8(typedObj, offset + 10, Load_uint8(fromValue, 10));
      Store_uint8(typedObj, offset + 11, Load_uint8(fromValue, 11));
      Store_uint8(typedObj, offset + 12, Load_uint8(fromValue, 12));
      Store_uint8(typedObj, offset + 13, Load_uint8(fromValue, 13));
      Store_uint8(typedObj, offset + 14, Load_uint8(fromValue, 14));
      Store_uint8(typedObj, offset + 15, Load_uint8(fromValue, 15));
      break;
    case JS_SIMDTYPEREPR_UINT16X8:
      Store_uint16(typedObj, offset + 0, Load_uint16(fromValue, 0));
      Store_uint16(typedObj, offset + 2, Load_uint16(fromValue, 2));
      Store_uint16(typedObj, offset + 4, Load_uint16(fromValue, 4));
      Store_uint16(typedObj, offset + 6, Load_uint16(fromValue, 6));
      Store_uint16(typedObj, offset + 8, Load_uint16(fromValue, 8));
      Store_uint16(typedObj, offset + 10, Load_uint16(fromValue, 10));
      Store_uint16(typedObj, offset + 12, Load_uint16(fromValue, 12));
      Store_uint16(typedObj, offset + 14, Load_uint16(fromValue, 14));
      break;
    case JS_SIMDTYPEREPR_UINT32X4:
      Store_uint32(typedObj, offset + 0, Load_uint32(fromValue, 0));
      Store_uint32(typedObj, offset + 4, Load_uint32(fromValue, 4));
      Store_uint32(typedObj, offset + 8, Load_uint32(fromValue, 8));
      Store_uint32(typedObj, offset + 12, Load_uint32(fromValue, 12));
      break;
    default:
      assert(false, "Unhandled Simd type: " + type);
  }
}

///////////////////////////////////////////////////////////////////////////
// C++ Wrappers
//
// These helpers are invoked by C++ code or used as method bodies.

// Wrapper for use from C++ code.
function ConvertAndCopyTo(destDescr,
                          destTypedObj,
                          destOffset,
                          fieldName,
                          fromValue)
{
  assert(IsObject(destDescr) && ObjectIsTypeDescr(destDescr),
         "ConvertAndCopyTo: not type obj");
  assert(IsObject(destTypedObj) && ObjectIsTypedObject(destTypedObj),
         "ConvertAndCopyTo: not type typedObj");

  if (!TypedObjectIsAttached(destTypedObj))
    ThrowTypeError(JSMSG_TYPEDOBJECT_HANDLE_UNATTACHED);

  TypedObjectSet(destDescr, destTypedObj, destOffset, fieldName, fromValue);
}

// Wrapper for use from C++ code.
function Reify(sourceDescr,
               sourceTypedObj,
               sourceOffset) {
  assert(IsObject(sourceDescr) && ObjectIsTypeDescr(sourceDescr),
         "Reify: not type obj");
  assert(IsObject(sourceTypedObj) && ObjectIsTypedObject(sourceTypedObj),
         "Reify: not type typedObj");

  if (!TypedObjectIsAttached(sourceTypedObj))
    ThrowTypeError(JSMSG_TYPEDOBJECT_HANDLE_UNATTACHED);

  return TypedObjectGet(sourceDescr, sourceTypedObj, sourceOffset);
}

// Warning: user exposed!
function TypeDescrEquivalent(otherDescr) {
  if (!IsObject(this) || !ObjectIsTypeDescr(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  if (!IsObject(otherDescr) || !ObjectIsTypeDescr(otherDescr))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  return DescrsEquiv(this, otherDescr);
}

// TypedObjectArray.redimension(newArrayType)
//
// Method that "repackages" the data from this array into a new typed
// object whose type is `newArrayType`. Once you strip away all the
// outer array dimensions, the type of `this` array and `newArrayType`
// must share the same innermost element type. Moreover, those
// stripped away dimensions must amount to the same total number of
// elements.
//
// For example, given two equivalent types `T` and `U`, it is legal to
// interconvert between arrays types like:
//     T[32]
//     U[2][16]
//     U[2][2][8]
// Because they all share the same total number (32) of equivalent elements.
// But it would be illegal to convert `T[32]` to `U[31]` or `U[2][17]`, since
// the number of elements differs. And it's just plain incompatible to convert
// if the base element types are not equivalent.
//
// Warning: user exposed!
function TypedObjectArrayRedimension(newArrayType) {
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  if (!IsObject(newArrayType) || !ObjectIsTypeDescr(newArrayType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  // Peel away the outermost array layers from the type of `this` to find
  // the core element type. In the process, count the number of elements.
  var oldArrayType = TypedObjectTypeDescr(this);
  var oldElementType = oldArrayType;
  var oldElementCount = 1;

  if (DESCR_KIND(oldArrayType) != JS_TYPEREPR_ARRAY_KIND)
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  while (DESCR_KIND(oldElementType) === JS_TYPEREPR_ARRAY_KIND) {
    oldElementCount *= oldElementType.length;
    oldElementType = oldElementType.elementType;
  }

  // Peel away the outermost array layers from `newArrayType`. In the
  // process, count the number of elements.
  var newElementType = newArrayType;
  var newElementCount = 1;
  while (DESCR_KIND(newElementType) == JS_TYPEREPR_ARRAY_KIND) {
    newElementCount *= newElementType.length;
    newElementType = newElementType.elementType;
  }

  // Check that the total number of elements does not change.
  if (oldElementCount !== newElementCount) {
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  }

  // Check that the element types are equivalent.
  if (!DescrsEquiv(oldElementType, newElementType)) {
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  }

  // Together, this should imply that the sizes are unchanged.
  assert(DESCR_SIZE(oldArrayType) == DESCR_SIZE(newArrayType),
         "Byte sizes should be equal");

  // Rewrap the data from `this` in a new type.
  return NewDerivedTypedObject(newArrayType, this, 0);
}

///////////////////////////////////////////////////////////////////////////
// SIMD

function SimdProtoString(type) {
  switch (type) {
  case JS_SIMDTYPEREPR_INT8X16:
    return "Int8x16";
  case JS_SIMDTYPEREPR_INT16X8:
    return "Int16x8";
  case JS_SIMDTYPEREPR_INT32X4:
    return "Int32x4";
  case JS_SIMDTYPEREPR_UINT8X16:
    return "Uint8x16";
  case JS_SIMDTYPEREPR_UINT16X8:
    return "Uint16x8";
  case JS_SIMDTYPEREPR_UINT32X4:
    return "Uint32x4";
  case JS_SIMDTYPEREPR_FLOAT32X4:
    return "Float32x4";
  case JS_SIMDTYPEREPR_FLOAT64X2:
    return "Float64x2";
  case JS_SIMDTYPEREPR_BOOL8X16:
    return "Bool8x16";
  case JS_SIMDTYPEREPR_BOOL16X8:
    return "Bool16x8";
  case JS_SIMDTYPEREPR_BOOL32X4:
    return "Bool32x4";
  case JS_SIMDTYPEREPR_BOOL64X2:
    return "Bool64x2";
  }

  assert(false, "Unhandled type constant");
  return undefined;
}

function SimdTypeToLength(type) {
  switch (type) {
  case JS_SIMDTYPEREPR_INT8X16:
  case JS_SIMDTYPEREPR_BOOL8X16:
    return 16;
  case JS_SIMDTYPEREPR_INT16X8:
  case JS_SIMDTYPEREPR_BOOL16X8:
    return 8;
  case JS_SIMDTYPEREPR_INT32X4:
  case JS_SIMDTYPEREPR_FLOAT32X4:
  case JS_SIMDTYPEREPR_BOOL32X4:
    return 4;
  case JS_SIMDTYPEREPR_FLOAT64X2:
  case JS_SIMDTYPEREPR_BOOL64X2:
    return 2;
  }

  assert(false, "Unhandled type constant");
  return undefined;
}

// This implements SIMD.*.prototype.valueOf().
// Once we have proper value semantics for SIMD types, this function should just
// perform a type check and return this.
// For now, throw a TypeError unconditionally since valueOf() was probably
// called from ToNumber() which is supposed to throw when attempting to convert
// a SIMD value to a number.
function SimdValueOf() {
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD", "valueOf", typeof this);

  var descr = TypedObjectTypeDescr(this);

  if (DESCR_KIND(descr) != JS_TYPEREPR_SIMD_KIND)
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD", "valueOf", typeof this);

  ThrowTypeError(JSMSG_SIMD_TO_NUMBER);
}

function SimdToSource() {
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD.*", "toSource", typeof this);

  var descr = TypedObjectTypeDescr(this);

  if (DESCR_KIND(descr) != JS_TYPEREPR_SIMD_KIND)
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD.*", "toSource", typeof this);

  return SimdFormatString(descr, this);
}

function SimdToString() {
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD.*", "toString", typeof this);

  var descr = TypedObjectTypeDescr(this);

  if (DESCR_KIND(descr) != JS_TYPEREPR_SIMD_KIND)
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "SIMD.*", "toString", typeof this);

  return SimdFormatString(descr, this);
}

function SimdFormatString(descr, typedObj) {
  var typerepr = DESCR_TYPE(descr);
  var protoString = SimdProtoString(typerepr);
  switch (typerepr) {
      case JS_SIMDTYPEREPR_INT8X16: {
          var s1 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 7);
          var s9 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 8);
          var s10 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 9);
          var s11 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 10);
          var s12 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 11);
          var s13 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 12);
          var s14 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 13);
          var s15 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 14);
          var s16 = callFunction(std_SIMD_Int8x16_extractLane, null, typedObj, 15);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8}, ${s9}, ${s10}, ${s11}, ${s12}, ${s13}, ${s14}, ${s15}, ${s16})`;
      }
      case JS_SIMDTYPEREPR_INT16X8: {
          var s1 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Int16x8_extractLane, null, typedObj, 7);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8})`;
      }
      case JS_SIMDTYPEREPR_INT32X4: {
          var x = callFunction(std_SIMD_Int32x4_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Int32x4_extractLane, null, typedObj, 1);
          var z = callFunction(std_SIMD_Int32x4_extractLane, null, typedObj, 2);
          var w = callFunction(std_SIMD_Int32x4_extractLane, null, typedObj, 3);
          return `SIMD.${protoString}(${x}, ${y}, ${z}, ${w})`;
      }
      case JS_SIMDTYPEREPR_UINT8X16: {
          var s1 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 7);
          var s9 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 8);
          var s10 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 9);
          var s11 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 10);
          var s12 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 11);
          var s13 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 12);
          var s14 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 13);
          var s15 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 14);
          var s16 = callFunction(std_SIMD_Uint8x16_extractLane, null, typedObj, 15);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8}, ${s9}, ${s10}, ${s11}, ${s12}, ${s13}, ${s14}, ${s15}, ${s16})`;
      }
      case JS_SIMDTYPEREPR_UINT16X8: {
          var s1 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Uint16x8_extractLane, null, typedObj, 7);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8})`;
      }
      case JS_SIMDTYPEREPR_UINT32X4: {
          var x = callFunction(std_SIMD_Uint32x4_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Uint32x4_extractLane, null, typedObj, 1);
          var z = callFunction(std_SIMD_Uint32x4_extractLane, null, typedObj, 2);
          var w = callFunction(std_SIMD_Uint32x4_extractLane, null, typedObj, 3);
          return `SIMD.${protoString}(${x}, ${y}, ${z}, ${w})`;
      }
      case JS_SIMDTYPEREPR_FLOAT32X4: {
          var x = callFunction(std_SIMD_Float32x4_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Float32x4_extractLane, null, typedObj, 1);
          var z = callFunction(std_SIMD_Float32x4_extractLane, null, typedObj, 2);
          var w = callFunction(std_SIMD_Float32x4_extractLane, null, typedObj, 3);
          return `SIMD.${protoString}(${x}, ${y}, ${z}, ${w})`;
      }
      case JS_SIMDTYPEREPR_FLOAT64X2: {
          var x = callFunction(std_SIMD_Float64x2_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Float64x2_extractLane, null, typedObj, 1);
          return `SIMD.${protoString}(${x}, ${y})`;
      }
      case JS_SIMDTYPEREPR_BOOL8X16: {
          var s1 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 7);
          var s9 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 8);
          var s10 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 9);
          var s11 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 10);
          var s12 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 11);
          var s13 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 12);
          var s14 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 13);
          var s15 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 14);
          var s16 = callFunction(std_SIMD_Bool8x16_extractLane, null, typedObj, 15);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8}, ${s9}, ${s10}, ${s11}, ${s12}, ${s13}, ${s14}, ${s15}, ${s16})`;
      }
      case JS_SIMDTYPEREPR_BOOL16X8: {
          var s1 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 0);
          var s2 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 1);
          var s3 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 2);
          var s4 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 3);
          var s5 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 4);
          var s6 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 5);
          var s7 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 6);
          var s8 = callFunction(std_SIMD_Bool16x8_extractLane, null, typedObj, 7);
          return `SIMD.${protoString}(${s1}, ${s2}, ${s3}, ${s4}, ${s5}, ${s6}, ${s7}, ${s8})`;
      }
      case JS_SIMDTYPEREPR_BOOL32X4: {
          var x = callFunction(std_SIMD_Bool32x4_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Bool32x4_extractLane, null, typedObj, 1);
          var z = callFunction(std_SIMD_Bool32x4_extractLane, null, typedObj, 2);
          var w = callFunction(std_SIMD_Bool32x4_extractLane, null, typedObj, 3);
          return `SIMD.${protoString}(${x}, ${y}, ${z}, ${w})`;
      }
      case JS_SIMDTYPEREPR_BOOL64X2: {
          var x = callFunction(std_SIMD_Bool64x2_extractLane, null, typedObj, 0);
          var y = callFunction(std_SIMD_Bool64x2_extractLane, null, typedObj, 1);
          return `SIMD.${protoString}(${x}, ${y})`;
      }
  }
  assert(false, "unexpected SIMD kind");
  return "?";
}

///////////////////////////////////////////////////////////////////////////
// Miscellaneous

function DescrsEquiv(descr1, descr2) {
  assert(IsObject(descr1) && ObjectIsTypeDescr(descr1), "descr1 not descr");
  assert(IsObject(descr2) && ObjectIsTypeDescr(descr2), "descr2 not descr");

  // Potential optimization: these two strings are guaranteed to be
  // atoms, and hence this string comparison can just be a pointer
  // comparison.  However, I don't think ion knows that. If this ever
  // becomes a bottleneck, we can add a intrinsic at some point that
  // is treated specially by Ion.  (Bug 976688)

  return DESCR_STRING_REPR(descr1) === DESCR_STRING_REPR(descr2);
}

// toSource() for type descriptors.
//
// Warning: user exposed!
function DescrToSource() {
  if (!IsObject(this) || !ObjectIsTypeDescr(this))
    ThrowTypeError(JSMSG_INCOMPATIBLE_PROTO, "Type", "toSource", "value");

  return DESCR_STRING_REPR(this);
}

// Warning: user exposed!
function ArrayShorthand(...dims) {
  if (!IsObject(this) || !ObjectIsTypeDescr(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  var AT = GetTypedObjectModule().ArrayType;

  if (dims.length == 0)
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  var accum = this;
  for (var i = dims.length - 1; i >= 0; i--)
    accum = new AT(accum, dims[i]);
  return accum;
}

// This is the `storage()` function defined in the spec.  When
// provided with a *transparent* typed object, it returns an object
// containing buffer, byteOffset, byteLength. When given an opaque
// typed object, it returns null. Otherwise it throws.
//
// Warning: user exposed!
function StorageOfTypedObject(obj) {
  if (IsObject(obj)) {
    if (ObjectIsOpaqueTypedObject(obj))
      return null;

    if (ObjectIsTransparentTypedObject(obj)) {
      if (!TypedObjectIsAttached(obj))
          ThrowTypeError(JSMSG_TYPEDOBJECT_HANDLE_UNATTACHED);

      var descr = TypedObjectTypeDescr(obj);
      var byteLength = DESCR_SIZE(descr);

      return { buffer: TypedObjectBuffer(obj),
               byteLength,
               byteOffset: TypedObjectByteOffset(obj) };
    }
  }

  ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
}

// This is the `objectType()` function defined in the spec.
// It returns the type of its argument.
//
// Warning: user exposed!
function TypeOfTypedObject(obj) {
  if (IsObject(obj) && ObjectIsTypedObject(obj))
    return TypedObjectTypeDescr(obj);

  // Note: Do not create bindings for `Any`, `String`, etc in
  // Utilities.js, but rather access them through
  // `GetTypedObjectModule()`. The reason is that bindings
  // you create in Utilities.js are part of the self-hosted global,
  // vs the user-accessible global, and hence should not escape to
  // user script.
  var T = GetTypedObjectModule();
  switch (typeof obj) {
    case "object": return T.Object;
    case "function": return T.Object;
    case "string": return T.String;
    case "number": return T.float64;
    case "undefined": return T.Any;
    default: return T.Any;
  }
}

///////////////////////////////////////////////////////////////////////////
// TypedObject surface API methods (sequential implementations).

// Warning: user exposed!
function TypedObjectArrayTypeBuild(a, b, c) {
  // Arguments : [depth], func

  if (!IsObject(this) || !ObjectIsTypeDescr(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  var kind = DESCR_KIND(this);
  switch (kind) {
  case JS_TYPEREPR_ARRAY_KIND:
    if (typeof a === "function") // XXX here and elsewhere: these type dispatches are fragile at best.
      return BuildTypedSeqImpl(this, this.length, 1, a);
    else if (typeof a === "number" && typeof b === "function")
      return BuildTypedSeqImpl(this, this.length, a, b);
    else if (typeof a === "number")
      ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
    else
      ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  default:
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  }
}

// Warning: user exposed!
function TypedObjectArrayTypeFrom(a, b, c) {
  // Arguments: arrayLike, [depth], func

  if (!IsObject(this) || !ObjectIsTypeDescr(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  var untypedInput = !IsObject(a) || !ObjectIsTypedObject(a) ||
                     !TypeDescrIsArrayType(TypedObjectTypeDescr(a));

  // for untyped input array, the expectation (in terms of error
  // reporting for invalid parameters) is no-depth, despite
  // supporting an explicit depth of 1; while for typed input array,
  // the expectation is explicit depth.

  if (untypedInput) {
    if (b === 1 && IsCallable(c))
      return MapUntypedSeqImpl(a, this, c);
    if (IsCallable(b))
      return MapUntypedSeqImpl(a, this, b);
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  }

  if (typeof b === "number" && IsCallable(c))
    return MapTypedSeqImpl(a, b, this, c);
  if (IsCallable(b))
    return MapTypedSeqImpl(a, 1, this, b);
  ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
}

// Warning: user exposed!
function TypedObjectArrayMap(a, b) {
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  var thisType = TypedObjectTypeDescr(this);
  if (!TypeDescrIsArrayType(thisType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  // Arguments: [depth], func
  if (typeof a === "number" && typeof b === "function")
    return MapTypedSeqImpl(this, a, thisType, b);
  else if (typeof a === "function")
    return MapTypedSeqImpl(this, 1, thisType, a);
  ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
}

// Warning: user exposed!
function TypedObjectArrayReduce(a, b) {
  // Arguments: func, [initial]
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  var thisType = TypedObjectTypeDescr(this);
  if (!TypeDescrIsArrayType(thisType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  if (a !== undefined && typeof a !== "function")
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  var outputType = thisType.elementType;
  return ReduceTypedSeqImpl(this, outputType, a, b);
}

// Warning: user exposed!
function TypedObjectArrayFilter(func) {
  // Arguments: predicate
  if (!IsObject(this) || !ObjectIsTypedObject(this))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  var thisType = TypedObjectTypeDescr(this);
  if (!TypeDescrIsArrayType(thisType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  if (typeof func !== "function")
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  return FilterTypedSeqImpl(this, func);
}

// should eventually become macros
function NUM_BYTES(bits) {
  return (bits + 7) >> 3;
}
function SET_BIT(data, index) {
  var word = index >> 3;
  var mask = 1 << (index & 0x7);
  data[word] |= mask;
}
function GET_BIT(data, index) {
  var word = index >> 3;
  var mask = 1 << (index & 0x7);
  return (data[word] & mask) != 0;
}

// Bug 956914: make performance-tuned variants tailored to 1, 2, and 3 dimensions.
function BuildTypedSeqImpl(arrayType, len, depth, func) {
  assert(IsObject(arrayType) && ObjectIsTypeDescr(arrayType), "Build called on non-type-object");

  if (depth <= 0 || TO_INT32(depth) !== depth) {
    // RangeError("bad depth")
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  }

  // For example, if we have as input
  //    ArrayType(ArrayType(T, 4), 5)
  // and a depth of 2, we get
  //    grainType = T
  //    iterationSpace = [5, 4]
  var {iterationSpace, grainType, totalLength} =
    ComputeIterationSpace(arrayType, depth, len);

  // Create a zeroed instance with no data
  var result = new arrayType();

  var indices = new List();
  indices.length = depth;
  for (var i = 0; i < depth; i++) {
    indices[i] = 0;
  }

  var grainTypeIsComplex = !TypeDescrIsSimpleType(grainType);
  var size = DESCR_SIZE(grainType);
  var outOffset = 0;
  for (i = 0; i < totalLength; i++) {
    // Position out-pointer to point at &result[...indices], if appropriate.
    var userOutPointer = TypedObjectGetOpaqueIf(grainType, result, outOffset,
                                                grainTypeIsComplex);

    // Invoke func(...indices, userOutPointer) and store the result
    callFunction(std_Array_push, indices, userOutPointer);
    var r = callFunction(std_Function_apply, func, undefined, indices);
    callFunction(std_Array_pop, indices);
    if (r !== undefined)
      TypedObjectSet(grainType, result, outOffset, null, r); // result[...indices] = r;

    // Increment indices.
    IncrementIterationSpace(indices, iterationSpace);
    outOffset += size;
  }

  return result;
}

function ComputeIterationSpace(arrayType, depth, len) {
  assert(IsObject(arrayType) && ObjectIsTypeDescr(arrayType), "ComputeIterationSpace called on non-type-object");
  assert(TypeDescrIsArrayType(arrayType), "ComputeIterationSpace called on non-array-type");
  assert(depth > 0, "ComputeIterationSpace called on non-positive depth");
  var iterationSpace = new List();
  iterationSpace.length = depth;
  iterationSpace[0] = len;
  var totalLength = len;
  var grainType = arrayType.elementType;

  for (var i = 1; i < depth; i++) {
    if (TypeDescrIsArrayType(grainType)) {
      var grainLen = grainType.length;
      iterationSpace[i] = grainLen;
      totalLength *= grainLen;
      grainType = grainType.elementType;
    } else {
      // RangeError("Depth "+depth+" too high");
      ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
    }
  }
  return { iterationSpace, grainType, totalLength };
}

function IncrementIterationSpace(indices, iterationSpace) {
  // Increment something like
  //     [5, 5, 7, 8]
  // in an iteration space of
  //     [9, 9, 9, 9]
  // to
  //     [5, 5, 8, 0]

  assert(indices.length === iterationSpace.length,
         "indices dimension must equal iterationSpace dimension.");
  var n = indices.length - 1;
  while (true) {
    indices[n] += 1;
    if (indices[n] < iterationSpace[n])
      return;

    assert(indices[n] === iterationSpace[n],
         "Components of indices must match those of iterationSpace.");
    indices[n] = 0;
    if (n == 0)
      return;

    n -= 1;
  }
}

// Implements |from| method for untyped |inArray|.  (Depth is implicitly 1 for untyped input.)
function MapUntypedSeqImpl(inArray, outputType, maybeFunc) {
  assert(IsObject(outputType), "1. Map/From called on non-object outputType");
  assert(ObjectIsTypeDescr(outputType), "1. Map/From called on non-type-object outputType");
  inArray = ToObject(inArray);
  assert(TypeDescrIsArrayType(outputType), "Map/From called on non array-type outputType");

  if (!IsCallable(maybeFunc))
    ThrowTypeError(JSMSG_NOT_FUNCTION, DecompileArg(0, maybeFunc));
  var func = maybeFunc;

  // Skip check for compatible iteration spaces; any normal JS array
  // is trivially compatible with any iteration space of depth 1.

  var outLength = outputType.length;
  var outGrainType = outputType.elementType;

  // Create a zeroed instance with no data
  var result = new outputType();

  var outUnitSize = DESCR_SIZE(outGrainType);
  var outGrainTypeIsComplex = !TypeDescrIsSimpleType(outGrainType);
  var outOffset = 0;

  // Core of map computation starts here (comparable to
  // DoMapTypedSeqDepth1 and DoMapTypedSeqDepthN below).

  for (var i = 0; i < outLength; i++) {
    // In this loop, since depth is 1, "indices" denotes singleton array [i].

    if (i in inArray) { // Check for holes (only needed for untyped case).
      // Extract element value.
      var element = inArray[i];

      // Create out pointer to point at &array[...indices] for result array.
      var out = TypedObjectGetOpaqueIf(outGrainType, result, outOffset,
                                       outGrainTypeIsComplex);

      // Invoke: var r = func(element, ...indices, collection, out);
      var r = func(element, i, inArray, out);

      if (r !== undefined)
        TypedObjectSet(outGrainType, result, outOffset, null, r); // result[i] = r
    }

    // Update offset and (implicitly) increment indices.
    outOffset += outUnitSize;
  }

  return result;
}

// Implements |map| and |from| methods for typed |inArray|.
function MapTypedSeqImpl(inArray, depth, outputType, func) {
  assert(IsObject(outputType) && ObjectIsTypeDescr(outputType), "2. Map/From called on non-type-object outputType");
  assert(IsObject(inArray) && ObjectIsTypedObject(inArray), "Map/From called on non-object or untyped input array.");
  assert(TypeDescrIsArrayType(outputType), "Map/From called on non array-type outputType");

  if (depth <= 0 || TO_INT32(depth) !== depth)
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  // Compute iteration space for input and output and check for compatibility.
  var inputType = TypeOfTypedObject(inArray);
  var {iterationSpace: inIterationSpace, grainType: inGrainType} =
    ComputeIterationSpace(inputType, depth, inArray.length);
  if (!IsObject(inGrainType) || !ObjectIsTypeDescr(inGrainType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);
  var {iterationSpace, grainType: outGrainType, totalLength} =
    ComputeIterationSpace(outputType, depth, outputType.length);
  for (var i = 0; i < depth; i++)
    if (inIterationSpace[i] !== iterationSpace[i])
      // TypeError("Incompatible iteration space in input and output type");
      ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  // Create a zeroed instance with no data
  var result = new outputType();

  var inGrainTypeIsComplex = !TypeDescrIsSimpleType(inGrainType);
  var outGrainTypeIsComplex = !TypeDescrIsSimpleType(outGrainType);

  var inOffset = 0;
  var outOffset = 0;

  var isDepth1Simple = depth == 1 && !(inGrainTypeIsComplex || outGrainTypeIsComplex);

  var inUnitSize = isDepth1Simple ? 0 : DESCR_SIZE(inGrainType);
  var outUnitSize = isDepth1Simple ? 0 : DESCR_SIZE(outGrainType);

  // Bug 956914: add additional variants for depth = 2, 3, etc.

  function DoMapTypedSeqDepth1() {
    for (var i = 0; i < totalLength; i++) {
      // In this loop, since depth is 1, "indices" denotes singleton array [i].

      // Prepare input element/handle and out pointer
      var element = TypedObjectGet(inGrainType, inArray, inOffset);
      var out = TypedObjectGetOpaqueIf(outGrainType, result, outOffset,
                                       outGrainTypeIsComplex);

      // Invoke: var r = func(element, ...indices, collection, out);
      var r = func(element, i, inArray, out);
      if (r !== undefined)
        TypedObjectSet(outGrainType, result, outOffset, null, r); // result[i] = r

      // Update offsets and (implicitly) increment indices.
      inOffset += inUnitSize;
      outOffset += outUnitSize;
    }

    return result;
  }

  function DoMapTypedSeqDepth1Simple(inArray, totalLength, func, result) {
    for (var i = 0; i < totalLength; i++) {
      var r = func(inArray[i], i, inArray, undefined);
      if (r !== undefined)
        result[i] = r;
    }

    return result;
  }

  function DoMapTypedSeqDepthN() {
    // Simulate Uint32Array(depth) with a dumber (and more accessible)
    // datastructure.
    var indices = new List();
    for (var i = 0; i < depth; i++)
        callFunction(std_Array_push, indices, 0);

    for (var i = 0; i < totalLength; i++) {
      // Prepare input element and out pointer
      var element = TypedObjectGet(inGrainType, inArray, inOffset);
      var out = TypedObjectGetOpaqueIf(outGrainType, result, outOffset,
                                       outGrainTypeIsComplex);

      // Invoke: var r = func(element, ...indices, collection, out);
      var args = [element];
      callFunction(std_Function_apply, std_Array_push, args, indices);
      callFunction(std_Array_push, args, inArray, out);
      var r = callFunction(std_Function_apply, func, void 0, args);
      if (r !== undefined)
        TypedObjectSet(outGrainType, result, outOffset, null, r); // result[...indices] = r

      // Update offsets and explicitly increment indices.
      inOffset += inUnitSize;
      outOffset += outUnitSize;
      IncrementIterationSpace(indices, iterationSpace);
    }

    return result;
  }

  if (isDepth1Simple)
    return DoMapTypedSeqDepth1Simple(inArray, totalLength, func, result);

  if (depth == 1)
    return DoMapTypedSeqDepth1();

  return DoMapTypedSeqDepthN();
}

function ReduceTypedSeqImpl(array, outputType, func, initial) {
  assert(IsObject(array) && ObjectIsTypedObject(array), "Reduce called on non-object or untyped input array.");
  assert(IsObject(outputType) && ObjectIsTypeDescr(outputType), "Reduce called on non-type-object outputType");

  var start, value;

  if (initial === undefined && array.length < 1)
    // RangeError("reduce requires array of length > 0")
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  // FIXME bug 950106 Should reduce method supply an outptr handle?
  // For now, reduce never supplies an outptr, regardless of outputType.

  if (TypeDescrIsSimpleType(outputType)) {
    if (initial === undefined) {
      start = 1;
      value = array[0];
    } else {
      start = 0;
      value = outputType(initial);
    }

    for (var i = start; i < array.length; i++)
      value = outputType(func(value, array[i]));

  } else {
    if (initial === undefined) {
      start = 1;
      value = new outputType(array[0]);
    } else {
      start = 0;
      value = initial;
    }

    for (var i = start; i < array.length; i++)
      value = func(value, array[i]);
  }

  return value;
}

function FilterTypedSeqImpl(array, func) {
  assert(IsObject(array) && ObjectIsTypedObject(array), "Filter called on non-object or untyped input array.");
  assert(typeof func === "function", "Filter called with non-function predicate");

  var arrayType = TypeOfTypedObject(array);
  if (!TypeDescrIsArrayType(arrayType))
    ThrowTypeError(JSMSG_TYPEDOBJECT_BAD_ARGS);

  var elementType = arrayType.elementType;
  var flags = new Uint8Array(NUM_BYTES(array.length));
  var count = 0;
  var size = DESCR_SIZE(elementType);
  var inOffset = 0;
  for (var i = 0; i < array.length; i++) {
    var v = TypedObjectGet(elementType, array, inOffset);
    if (func(v, i, array)) {
      SET_BIT(flags, i);
      count++;
    }
    inOffset += size;
  }

  var AT = GetTypedObjectModule().ArrayType;

  var resultType = new AT(elementType, count);
  var result = new resultType();
  for (var i = 0, j = 0; i < array.length; i++) {
    if (GET_BIT(flags, i))
      result[j++] = array[i];
  }
  return result;
}
