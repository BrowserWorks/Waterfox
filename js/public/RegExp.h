/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */

/* Public JS API for Regular Expressions. */

#ifndef js_RegExp_h
#define js_RegExp_h

#include <stddef.h> // size_t

#include "jstypes.h" // JS_PUBLIC_API

#include "js/RootingAPI.h" // JS::{,Mutable}Handle
#include "js/Value.h"      // JS::Value

struct JSContext;
class JSString;

namespace JS {

/*
 * A namespace for all regular expression flags as they appear in the APIs below as flags values.
 */

struct RegExpFlags
{
public:
  /**
   * Interpret regular expression source text case-insensitively by folding
   * uppercase letters to lowercase, i.e. /i.
   */
  static unsigned const IgnoreCase = 0x01;

  /**
   * Act globally and find *all* matches (rather than stopping after just the
   * first one), i.e. /g.
   */
  static unsigned const Global = 0x02;

  /** Treat ^ and $ as begin and end of line, i.e. /m. */
  static unsigned const Multiline = 0x04;

  /** Only match starting from <regular expression>.lastIndex, i.e. /y. */
  static unsigned const Sticky = 0x08;

  /** Use Unicode semantics, i.e. /u. */
  static unsigned const Unicode = 0x10;

  /** Match '.' to any character including newlines, i.e. /s. */
  static unsigned const DotAll = 0x20;
};

/*
 * Create a new RegExp for the given Latin-1-encoded source and flags.
 */
extern JS_PUBLIC_API(JSObject*) NewRegExpObject(JSContext* cx,
                                                const char* bytes,
                                                size_t length,
                                                unsigned flags);

/*
 * Create a new RegExp for the given UC source and flags.
 */
extern JS_PUBLIC_API(JSObject*) NewUCRegExpObject(JSContext* cx,
                                                  const char16_t* chars,
                                                  size_t length,
                                                  unsigned flags);

extern JS_PUBLIC_API(bool)
  SetRegExpInput(JSContext* cx, Handle<JSObject*> obj, Handle<JSString*> input);

extern JS_PUBLIC_API(bool)
  ClearRegExpStatics(JSContext* cx, Handle<JSObject*> obj);

/* RegExp interface for callers with a global object. */

extern JS_PUBLIC_API(bool) ExecuteRegExp(JSContext* cx,
                                         Handle<JSObject*> obj,
                                         Handle<JSObject*> reobj,
                                         char16_t* chars,
                                         size_t length,
                                         size_t* indexp,
                                         bool test,
                                         MutableHandle<Value> rval);

/* RegExp interface for callers without a global object. */

extern JS_PUBLIC_API(bool) ExecuteRegExpNoStatics(JSContext* cx,
                                                  Handle<JSObject*> reobj,
                                                  char16_t* chars,
                                                  size_t length,
                                                  size_t* indexp,
                                                  bool test,
                                                  MutableHandle<Value> rval);

/*
 * Returns true on success, setting |*isRegExp| to true if |obj| is a RegExp
 * object or a wrapper around one, or to false if not. Returns false on failure.
 *
 * This method returns true with |*isRegExp == false| when passed an ES6 proxy
 * whose target is a RegExp, or when passed a revoked proxy.
 */
extern JS_PUBLIC_API(bool)
  ObjectIsRegExp(JSContext* cx, Handle<JSObject*> obj, bool* isRegExp);

/*
 * Given a RegExp object (or a wrapper around one), return all JS::RegExpFlags::* for it.
 */
extern JS_PUBLIC_API(unsigned)
  GetRegExpFlags(JSContext* cx, Handle<JSObject*> obj);

/*
 * Return the source text for a RegExp object (or a wrapper around one), or null on failure.
 */
extern JS_PUBLIC_API(JSString*)
  GetRegExpSource(JSContext* cx, Handle<JSObject*> obj);

} // namespace JS

#endif // js_RegExp_h
