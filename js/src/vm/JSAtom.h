/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef vm_JSAtom_h
#define vm_JSAtom_h

#include "mozilla/Maybe.h"

#include "gc/MaybeRooted.h"
#include "gc/Rooting.h"
#include "js/TypeDecls.h"
#include "js/Utility.h"
#include "vm/CommonPropertyNames.h"

namespace js {

/*
 * Return a printable, lossless char[] representation of a string-type atom.
 * The returned string is guaranteed to contain only ASCII characters.
 */
extern UniqueChars AtomToPrintableString(JSContext* cx, JSAtom* atom);

class PropertyName;

} /* namespace js */

/* Well-known predefined C strings. */
#define DECLARE_PROTO_STR(name, clasp) extern const char js_##name##_str[];
JS_FOR_EACH_PROTOTYPE(DECLARE_PROTO_STR)
#undef DECLARE_PROTO_STR

#define DECLARE_CONST_CHAR_STR(idpart, id, text) \
  extern const char js_##idpart##_str[];
FOR_EACH_COMMON_PROPERTYNAME(DECLARE_CONST_CHAR_STR)
#undef DECLARE_CONST_CHAR_STR

namespace js {

class AutoAccessAtomsZone;

/*
 * Atom tracing and garbage collection hooks.
 */
void TraceAtoms(JSTracer* trc, const AutoAccessAtomsZone& access);

void TraceWellKnownSymbols(JSTracer* trc);

/* N.B. must correspond to boolean tagging behavior. */
enum PinningBehavior { DoNotPinAtom = false, PinAtom = true };

extern JSAtom* Atomize(
    JSContext* cx, const char* bytes, size_t length,
    js::PinningBehavior pin = js::DoNotPinAtom,
    const mozilla::Maybe<uint32_t>& indexValue = mozilla::Nothing());

template <typename CharT>
extern JSAtom* AtomizeChars(JSContext* cx, const CharT* chars, size_t length,
                            js::PinningBehavior pin = js::DoNotPinAtom);

/**
 * Create an atom whose contents are those of the |utf8ByteLength| code units
 * starting at |utf8Chars|, interpreted as UTF-8.
 *
 * Throws if the code units do not contain valid UTF-8.
 */
extern JSAtom* AtomizeUTF8Chars(JSContext* cx, const char* utf8Chars,
                                size_t utf8ByteLength);

/**
 * Create an atom whose contents are those of the |wtf8ByteLength| code units
 * starting at |wtf8Chars|, interpreted as WTF-8.
 *
 * Throws if the code units do not contain valid WTF-8.
 */
extern JSAtom* AtomizeWTF8Chars(JSContext* cx, const char* wtf8Chars,
                                size_t wtf8ByteLength);

extern JSAtom* AtomizeString(JSContext* cx, JSString* str,
                             js::PinningBehavior pin = js::DoNotPinAtom);

template <AllowGC allowGC>
extern JSAtom* ToAtom(JSContext* cx,
                      typename MaybeRooted<JS::Value, allowGC>::HandleType v);

// These functions are declared in vm/Xdr.h
//
// template<XDRMode mode>
// XDRResult
// XDRAtom(XDRState<mode>* xdr, js::MutableHandleAtom atomp);

// template<XDRMode mode>
// XDRResult
// XDRAtomOrNull(XDRState<mode>* xdr, js::MutableHandleAtom atomp);

extern JS::Handle<PropertyName*> ClassName(JSProtoKey key, JSContext* cx);

#ifdef DEBUG

bool AtomIsMarked(JS::Zone* zone, JSAtom* atom);
bool AtomIsMarked(JS::Zone* zone, jsid id);
bool AtomIsMarked(JS::Zone* zone, const JS::Value& value);

#endif  // DEBUG

} /* namespace js */

#endif /* vm_JSAtom_h */
