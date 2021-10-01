/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "vm/RegExpObject.h"

#include "mozilla/MemoryReporting.h"
#include "mozilla/PodOperations.h"

#include "jshashutil.h"
#include "jsstr.h"
#ifdef DEBUG
#include "jsutil.h"
#endif

#include "builtin/RegExp.h"
#include "builtin/SelfHostingDefines.h"
#include "frontend/TokenStream.h"
#include "new-regexp/regexp-stack.h"
#include "new-regexp/RegExpAPI.h"
#include "vm/MatchPairs.h"
#include "vm/RegExpStatics.h"
#include "vm/StringBuffer.h"
#include "vm/TraceLogging.h"
#ifdef DEBUG
#include "vm/Unicode.h"
#endif
#include "vm/Xdr.h"

#include "jsobjinlines.h"

#include "vm/NativeObject-inl.h"
#include "vm/Shape-inl.h"

#include "js/RegExp.h"
#include "js/RegExpFlags.h"

using namespace js;

using mozilla::ArrayLength;
using mozilla::DebugOnly;
using mozilla::Maybe;
using mozilla::PodCopy;
using JS::RegExpFlag;
using JS::RegExpFlags;
using js::frontend::TokenStream;

using JS::AutoCheckCannotGC;

static_assert(RegExpFlag::Global == REGEXP_GLOBAL_FLAG,
              "self-hosted JS and /g flag bits must agree");
static_assert(RegExpFlag::IgnoreCase == REGEXP_IGNORECASE_FLAG,
              "self-hosted JS and /i flag bits must agree");
static_assert(RegExpFlag::Multiline == REGEXP_MULTILINE_FLAG,
              "self-hosted JS and /m flag bits must agree");
static_assert(RegExpFlag::DotAll == REGEXP_DOTALL_FLAG,
              "self-hosted JS and /s flag bits must agree");
static_assert(RegExpFlag::Unicode == REGEXP_UNICODE_FLAG,
              "self-hosted JS and /u flag bits must agree");
static_assert(RegExpFlag::Sticky == REGEXP_STICKY_FLAG,
              "self-hosted JS and /y flag bits must agree");

RegExpObject*
js::RegExpAlloc(JSContext* cx, NewObjectKind newKind, HandleObject proto /* = nullptr */)
{
    Rooted<RegExpObject*> regexp(cx, NewObjectWithClassProto<RegExpObject>(cx, proto, newKind));
    if (!regexp)
        return nullptr;

    regexp->initPrivate(nullptr);

    if (!EmptyShape::ensureInitialCustomShape<RegExpObject>(cx, regexp))
        return nullptr;

    MOZ_ASSERT(regexp->lookupPure(cx->names().lastIndex)->slot() ==
               RegExpObject::lastIndexSlot());

    return regexp;
}

/* MatchPairs */

bool
MatchPairs::initArrayFrom(MatchPairs& copyFrom)
{
    MOZ_ASSERT(copyFrom.pairCount() > 0);

    if (!allocOrExpandArray(copyFrom.pairCount()))
        return false;

    PodCopy(pairs_, copyFrom.pairs_, pairCount_);

    return true;
}

bool
ScopedMatchPairs::allocOrExpandArray(size_t pairCount)
{
    /* Array expansion is forbidden, but array reuse is acceptable. */
    if (pairCount_) {
        MOZ_ASSERT(pairs_);
        MOZ_ASSERT(pairCount_ == pairCount);
        return true;
    }

    MOZ_ASSERT(!pairs_);
    pairs_ = (MatchPair*)lifoScope_.alloc().alloc(sizeof(MatchPair) * pairCount);
    if (!pairs_)
        return false;

    pairCount_ = pairCount;
    return true;
}

bool
VectorMatchPairs::allocOrExpandArray(size_t pairCount)
{
    if (!vec_.resizeUninitialized(sizeof(MatchPair) * pairCount))
        return false;

    pairs_ = &vec_[0];
    pairCount_ = pairCount;
    return true;
}

/* RegExpObject */

/* static */ RegExpShared*
RegExpObject::getShared(JSContext* cx, Handle<RegExpObject*> regexp)
{
    if (regexp->hasShared())
        return regexp->sharedRef();

    return createShared(cx, regexp);
}

/* static */ bool
RegExpObject::isOriginalFlagGetter(JSNative native, RegExpFlags* mask)
{
  if (native == regexp_global) {
      *mask = RegExpFlag::Global;
      return true;
  }
  if (native == regexp_ignoreCase) {
      *mask = RegExpFlag::IgnoreCase;
      return true;
  }
  if (native == regexp_multiline) {
      *mask = RegExpFlag::Multiline;
      return true;
  }
  if (native == regexp_sticky) {
      *mask = RegExpFlag::Sticky;
      return true;
  }
  if (native == regexp_unicode) {
      *mask = RegExpFlag::Unicode;
      return true;
  }
  if (native == regexp_dotAll) {
      *mask = RegExpFlag::DotAll;
      return true;
  }

  return false;
}

/* static */ void
RegExpObject::trace(JSTracer* trc, JSObject* obj)
{
    obj->as<RegExpObject>().trace(trc);
}

static inline bool
IsMarkingTrace(JSTracer* trc)
{
    // Determine whether tracing is happening during normal marking.  We need to
    // test all the following conditions, since:
    //
    //   1. During TraceRuntime, CurrentThreadIsHeapBusy() is true, but the
    //      tracer might not be a marking tracer.
    //   2. When a write barrier executes, IsMarkingTracer is true, but
    //      CurrentThreadIsHeapBusy() will be false.

    return JS::CurrentThreadIsHeapCollecting() && trc->isMarkingTracer();
}

void
RegExpObject::trace(JSTracer* trc)
{
    TraceNullableEdge(trc, &sharedRef(), "RegExpObject shared");
}

static JSObject*
CreateRegExpPrototype(JSContext* cx, JSProtoKey key)
{
    return GlobalObject::createBlankPrototype(cx, cx->global(), &RegExpObject::protoClass_);
}

static const ClassOps RegExpObjectClassOps = {
    nullptr, /* addProperty */
    nullptr, /* delProperty */
    nullptr, /* getProperty */
    nullptr, /* setProperty */
    nullptr, /* enumerate */
    nullptr, /* newEnumerate */
    nullptr, /* resolve */
    nullptr, /* mayResolve */
    nullptr, /* finalize */
    nullptr, /* call */
    nullptr, /* hasInstance */
    nullptr, /* construct */
    RegExpObject::trace,
};

static const ClassSpec RegExpObjectClassSpec = {
    GenericCreateConstructor<js::regexp_construct, 2, gc::AllocKind::FUNCTION>,
    CreateRegExpPrototype,
    nullptr,
    js::regexp_static_props,
    js::regexp_methods,
    js::regexp_properties
};

const Class RegExpObject::class_ = {
    js_RegExp_str,
    JSCLASS_HAS_PRIVATE |
    JSCLASS_HAS_RESERVED_SLOTS(RegExpObject::RESERVED_SLOTS) |
    JSCLASS_HAS_CACHED_PROTO(JSProto_RegExp),
    &RegExpObjectClassOps,
    &RegExpObjectClassSpec
};

const Class RegExpObject::protoClass_ = {
    js_Object_str,
    JSCLASS_HAS_CACHED_PROTO(JSProto_RegExp),
    JS_NULL_CLASS_OPS,
    &RegExpObjectClassSpec
};

RegExpObject*
RegExpObject::create(JSContext* cx,
                     const char16_t* chars,
                     size_t length,
                     RegExpFlags flags,
                     const ReadOnlyCompileOptions* options,
                     TokenStream* tokenStream,
                     LifoAlloc& alloc,
                     NewObjectKind newKind)
{
    RootedAtom source(cx, AtomizeChars(cx, chars, length));
    if (!source)
        return nullptr;

    return create(cx, source, flags, options, tokenStream, alloc, newKind);
}

RegExpObject*
RegExpObject::create(JSContext* cx,
                     HandleAtom source,
                     RegExpFlags flags,
                     const ReadOnlyCompileOptions* options,
                     TokenStream* tokenStream,
                     LifoAlloc& alloc,
                     NewObjectKind newKind)
{
    Maybe<CompileOptions> dummyOptions;
    if (!tokenStream && !options) {
        dummyOptions.emplace(cx, JSVERSION_DEFAULT);
        options = dummyOptions.ptr();
    }
    Maybe<TokenStream> dummyTokenStream;
    if (!tokenStream) {
        dummyTokenStream.emplace(cx, *options,
                                   (const char16_t*) nullptr, 0,
                                   (frontend::StrictModeGetter*) nullptr);
        tokenStream = dummyTokenStream.ptr();
    }

    if (!irregexp::CheckPatternSyntax(cx, *tokenStream, source, flags)) {
        return nullptr;
    }
    Rooted<RegExpObject*> regexp(cx, RegExpAlloc(cx, newKind));
    if (!regexp)
        return nullptr;

    regexp->initAndZeroLastIndex(source, flags, cx);

    return regexp;
}

/* static */ RegExpShared*
RegExpObject::createShared(JSContext* cx, Handle<RegExpObject*> regexp)
{
    MOZ_ASSERT(!regexp->hasShared());
    RootedAtom source(cx, regexp->getSource());
    RegExpShared* shared = cx->zone()->regExps.get(cx, source, regexp->getFlags());
    if (!shared)
        return nullptr;

    regexp->setShared(*shared);
    return shared;
}

Shape*
RegExpObject::assignInitialShape(JSContext* cx, Handle<RegExpObject*> self)
{
    MOZ_ASSERT(self->empty());

    JS_STATIC_ASSERT(LAST_INDEX_SLOT == 0);

    /* The lastIndex property alone is writable but non-configurable. */
    return NativeObject::addDataProperty(cx, self, cx->names().lastIndex, LAST_INDEX_SLOT,
                                         JSPROP_PERMANENT);
}

void
RegExpObject::initIgnoringLastIndex(JSAtom* source, RegExpFlags flags)
{
    // If this is a re-initialization with an existing RegExpShared, 'flags'
    // may not match getShared()->flags, so forget the RegExpShared.
    sharedRef() = nullptr;

    setSource(source);
    setFlags(flags);
}

void
RegExpObject::initAndZeroLastIndex(JSAtom* source, RegExpFlags flags, JSContext* cx)
{
    initIgnoringLastIndex(source, flags);
    zeroLastIndex(cx);
}

static MOZ_ALWAYS_INLINE bool
IsLineTerminator(const JS::Latin1Char c)
{
    return c == '\n' || c == '\r';
}

static MOZ_ALWAYS_INLINE bool
IsLineTerminator(const char16_t c)
{
    return c == '\n' || c == '\r' || c == 0x2028 || c == 0x2029;
}

static MOZ_ALWAYS_INLINE bool
AppendEscapedLineTerminator(StringBuffer& sb, const JS::Latin1Char c)
{
    switch (c) {
      case '\n':
        if (!sb.append('n'))
            return false;
        break;
      case '\r':
        if (!sb.append('r'))
            return false;
        break;
      default:
        MOZ_CRASH("Bad LineTerminator");
    }
    return true;
}

static MOZ_ALWAYS_INLINE bool
AppendEscapedLineTerminator(StringBuffer& sb, const char16_t c)
{
    switch (c) {
      case '\n':
        if (!sb.append('n'))
            return false;
        break;
      case '\r':
        if (!sb.append('r'))
            return false;
        break;
      case 0x2028:
        if (!sb.append("u2028"))
            return false;
        break;
      case 0x2029:
        if (!sb.append("u2029"))
            return false;
        break;
      default:
        MOZ_CRASH("Bad LineTerminator");
    }
    return true;
}

template <typename CharT>
static MOZ_ALWAYS_INLINE bool
SetupBuffer(StringBuffer& sb, const CharT* oldChars, size_t oldLen, const CharT* it)
{
    if (mozilla::IsSame<CharT, char16_t>::value && !sb.ensureTwoByteChars())
        return false;

    if (!sb.reserve(oldLen + 1))
        return false;

    sb.infallibleAppend(oldChars, size_t(it - oldChars));
    return true;
}

// Note: leaves the string buffer empty if no escaping need be performed.
template <typename CharT>
static bool
EscapeRegExpPattern(StringBuffer& sb, const CharT* oldChars, size_t oldLen)
{
    bool inBrackets = false;
    bool previousCharacterWasBackslash = false;

    for (const CharT* it = oldChars; it < oldChars + oldLen; ++it) {
        CharT ch = *it;
        if (!previousCharacterWasBackslash) {
            if (inBrackets) {
                if (ch == ']')
                    inBrackets = false;
            } else if (ch == '/') {
                // There's a forward slash that needs escaping.
                if (sb.empty()) {
                    // This is the first char we've seen that needs escaping,
                    // copy everything up to this point.
                    if (!SetupBuffer(sb, oldChars, oldLen, it))
                        return false;
                }
                if (!sb.append('\\'))
                    return false;
            } else if (ch == '[') {
                inBrackets = true;
            }
        }

        if (IsLineTerminator(ch)) {
            // There's LineTerminator that needs escaping.
            if (sb.empty()) {
                // This is the first char we've seen that needs escaping,
                // copy everything up to this point.
                if (!SetupBuffer(sb, oldChars, oldLen, it))
                    return false;
            }
            if (!previousCharacterWasBackslash) {
                if (!sb.append('\\'))
                    return false;
            }
            if (!AppendEscapedLineTerminator(sb, ch))
                return false;
        } else if (!sb.empty()) {
            if (!sb.append(ch))
                return false;
        }

        if (previousCharacterWasBackslash)
            previousCharacterWasBackslash = false;
        else if (ch == '\\')
            previousCharacterWasBackslash = true;
    }

    return true;
}

// ES6 draft rev32 21.2.3.2.4.
JSAtom*
js::EscapeRegExpPattern(JSContext* cx, HandleAtom src)
{
    // Step 2.
    if (src->length() == 0)
        return cx->names().emptyRegExp;

    // We may never need to use |sb|. Start using it lazily.
    StringBuffer sb(cx);

    if (src->hasLatin1Chars()) {
        JS::AutoCheckCannotGC nogc;
        if (!::EscapeRegExpPattern(sb, src->latin1Chars(nogc), src->length()))
            return nullptr;
    } else {
        JS::AutoCheckCannotGC nogc;
        if (!::EscapeRegExpPattern(sb, src->twoByteChars(nogc), src->length()))
            return nullptr;
    }

    // Step 3.
    return sb.empty() ? src : sb.finishAtom();
}

// ES6 draft rev32 21.2.5.14. Optimized for RegExpObject.
JSFlatString*
RegExpObject::toString(JSContext* cx) const
{
    // Steps 3-4.
    RootedAtom src(cx, getSource());
    if (!src)
        return nullptr;
    RootedAtom escapedSrc(cx, EscapeRegExpPattern(cx, src));

    // Step 7.
    StringBuffer sb(cx);
    size_t len = escapedSrc->length();
    if (!sb.reserve(len + 2))
        return nullptr;
    sb.infallibleAppend('/');
    if (!sb.append(escapedSrc))
        return nullptr;
    sb.infallibleAppend('/');

    // Steps 5-7.
    if (global() && !sb.append('g'))
        return nullptr;
    if (ignoreCase() && !sb.append('i'))
        return nullptr;
    if (multiline() && !sb.append('m'))
        return nullptr;
    if (unicode() && !sb.append('u'))
        return nullptr;
    if (sticky() && !sb.append('y'))
        return nullptr;
    if (dotAll() && !sb.append('s'))
        return nullptr;

    return sb.finishString();
}

template <typename CharT>
static MOZ_ALWAYS_INLINE bool
IsRegExpMetaChar(CharT ch)
{
    switch (ch) {
      /* ES 2016 draft Mar 25, 2016 21.2.1 SyntaxCharacter. */
      case '^': case '$': case '\\': case '.': case '*': case '+':
      case '?': case '(': case ')': case '[': case ']': case '{':
      case '}': case '|':
        return true;
      default:
        return false;
    }
}

template <typename CharT>
bool
js::HasRegExpMetaChars(const CharT* chars, size_t length)
{
    for (size_t i = 0; i < length; ++i) {
        if (IsRegExpMetaChar<CharT>(chars[i]))
            return true;
    }
    return false;
}

template bool
js::HasRegExpMetaChars<Latin1Char>(const Latin1Char* chars, size_t length);

template bool
js::HasRegExpMetaChars<char16_t>(const char16_t* chars, size_t length);

bool
js::StringHasRegExpMetaChars(JSLinearString* str)
{
    AutoCheckCannotGC nogc;
    if (str->hasLatin1Chars())
        return HasRegExpMetaChars(str->latin1Chars(nogc), str->length());

    return HasRegExpMetaChars(str->twoByteChars(nogc), str->length());
}

/* RegExpShared */

RegExpShared::RegExpShared(JSAtom* source, RegExpFlags flags)
  : source(source)
  , flags(flags)
  , pairCount_(0)
{}

void
RegExpShared::traceChildren(JSTracer* trc)
{
    // Discard code to avoid holding onto ExecutablePools.
    if (IsMarkingTrace(trc) && trc->runtime()->gc.isShrinkingGC())
        discardJitCode();

    TraceNullableEdge(trc, &source, "RegExpShared source");
    if (kind() == RegExpShared::Kind::Atom) {
        TraceNullableEdge(trc, &patternAtom_, "RegExpShared pattern atom");
    } else {
        for (auto& comp : compilationArray) {
            TraceNullableEdge(trc, &comp.jitCode, "RegExpShared code");
        }
        TraceNullableEdge(trc, &groupsTemplate_, "RegExpShared groups template");
    }
}

void
RegExpShared::discardJitCode()
{
    for (auto& comp : compilationArray)
        comp.jitCode = nullptr;

    // We can also purge the tables used by JIT code.
    tables.clearAndFree();
}


void
RegExpShared::finalize(FreeOp* fop)
{
    for (auto& comp : compilationArray) {
        if (comp.byteCode) {
            js_free(comp.byteCode);
        }
    }
    if (namedCaptureIndices_) {
        js_free(namedCaptureIndices_);
    }
    tables.~JitCodeTables();
}

/* static */ bool
RegExpShared::compile(JSContext* cx, MutableHandleRegExpShared re, HandleLinearString input,
                      RegExpShared::CodeKind codeKind)
{
    TraceLoggerThread* logger = TraceLoggerForCurrentThread(cx);
    AutoTraceLog logCompile(logger, TraceLogger_IrregexpCompile);

    RootedAtom pattern(cx, re->source);
    return compile(cx, re, pattern, input, codeKind);
}

bool
RegExpShared::compile(JSContext* cx,
                      MutableHandleRegExpShared re,
                      HandleAtom pattern,
                      HandleLinearString input,
                      RegExpShared::CodeKind code)
{
    MOZ_CRASH("TODO");
}
/* static */
bool
RegExpShared::compileIfNecessary(JSContext* cx,
                                 MutableHandleRegExpShared re,
                                 HandleLinearString input,
                                 RegExpShared::CodeKind codeKind)
{
  if (codeKind == RegExpShared::CodeKind::Any) {
    // We start by interpreting regexps, then compile them once they are
    // sufficiently hot. For very long input strings, we tier up eagerly.
    codeKind = RegExpShared::CodeKind::Bytecode;
    if (IsNativeRegExpEnabled(cx) &&
        (re->markedForTierUp(cx) || input->length() > 1000)) {
      codeKind = RegExpShared::CodeKind::Jitcode;
    }
  }

  bool needsCompile = false;
  if (re->kind() == RegExpShared::Kind::Unparsed) {
    needsCompile = true;
  }

  if (re->kind() == RegExpShared::Kind::RegExp) {
    if (!re->isCompiled(input->hasLatin1Chars(), codeKind)) {
      needsCompile = true;
    }
  }

  if (needsCompile) {
    return irregexp::CompilePattern(cx, re, input, codeKind);
  }
  return true;
}

/* static */
RegExpRunStatus
RegExpShared::execute(JSContext* cx,
                      MutableHandleRegExpShared re,
                      HandleLinearString input,
                      size_t start,
                      MatchPairs* matches)
{
    MOZ_ASSERT(matches);

    // TODO: Add tracelogger support

    /* Compile the code at point-of-use. */
    if (!compileIfNecessary(cx, re, input, RegExpShared::CodeKind::Any)) {
        return RegExpRunStatus_Error;
    }

    /*
     * Ensure sufficient memory for output vector.
     * No need to initialize it. The RegExp engine fills them in on a match.
     */
    if (!matches->allocOrExpandArray(re->pairCount())) {
        ReportOutOfMemory(cx);
        return RegExpRunStatus_Error;
    }

    if (re->kind() == RegExpShared::Kind::Atom) {
        return RegExpShared::executeAtom(cx, re, input, start, matches);
    }

    // Reset the Irregexp backtrack stack if it grows during execution.
    irregexp::RegExpStackScope stackScope(cx->isolate);

    /*
     * Ensure sufficient memory for output vector.
     * No need to initialize it. The RegExp engine fills them in on a match.
     */
    if (!matches->allocOrExpandArray(re->pairCount())) {
        ReportOutOfMemory(cx);
        return RegExpRunStatus_Error;
    }

    uint32_t interruptRetries = 0;
    const uint32_t maxInterruptRetries = 4;
    do {
        RegExpRunStatus result = irregexp::Execute(cx, re, input, start, matches);

        if (result == RegExpRunStatus_Error) {
            /* Execute can return RegExpRunStatus_Error:
             *
             *  1. If the native stack overflowed
             *  2. If the backtrack stack overflowed
             *  3. If an interrupt was requested during execution.
             *
             * In the first two cases, we want to throw an error. In the
             * third case, we want to handle the interrupt and try again.
             * We cap the number of times we will retry.
             */
            if (cx->hasPendingInterrupt()) {
                if (!CheckForInterrupt(cx)) {
                    return RegExpRunStatus_Error;
                }
                if (interruptRetries++ < maxInterruptRetries) {
                    continue;
                }
            }
            // If we have run out of retries, this regexp takes too long to execute.
            ReportOverRecursed(cx);
            return RegExpRunStatus_Error;
        }

        MOZ_ASSERT(result == RegExpRunStatus_Success ||
                   result == RegExpRunStatus_Success_NotFound);

        return result;
    } while (true);

    MOZ_CRASH("Unreachable");
}

void RegExpShared::useAtomMatch(HandleAtom pattern) {
  MOZ_ASSERT(kind() == RegExpShared::Kind::Unparsed);
  kind_ = RegExpShared::Kind::Atom;
  patternAtom_ = pattern;
  pairCount_ = 1;
}

void RegExpShared::useRegExpMatch(size_t pairCount) {
  MOZ_ASSERT(kind() == RegExpShared::Kind::Unparsed);
  kind_ = RegExpShared::Kind::RegExp;
  pairCount_ = pairCount;
  ticks_ = jit::JitOptions.regexpWarmUpThreshold;
}

/* static */
bool
RegExpShared::initializeNamedCaptures(JSContext* cx,
                                      HandleRegExpShared re,
                                      HandleNativeObject namedCaptures)
{
    MOZ_ASSERT(!re->groupsTemplate_);
    MOZ_ASSERT(!re->namedCaptureIndices_);

    // The irregexp parser returns named capture information in the form
    // of an ArrayObject, where even elements store the capture name and
    // odd elements store the corresponding capture index. We create a
    // template object with a property for each capture name, and store
    // the capture indices as a heap-allocated array.
    uint32_t numNamedCaptures = namedCaptures->getDenseInitializedLength() / 2;

    // Create a plain template object.
    RootedPlainObject templateObject(cx, NewObjectWithGivenProto<PlainObject>(cx, nullptr, TenuredObject));
    if (!templateObject) {
        return false;
    }

    // Create a new group for the template.
    Rooted<TaggedProto> proto(cx, templateObject->taggedProto());
    ObjectGroup* group =
      ObjectGroupCompartment::makeGroup(cx, templateObject->getClass(), proto);
    if (!group) {
        return false;
    }
    templateObject->setGroup(group);

    // Initialize the properties of the template.
    RootedValue dummyString(cx, StringValue(cx->runtime()->emptyString));
    for (uint32_t i = 0; i < numNamedCaptures; i++) {
        RootedString name(cx, namedCaptures->getDenseElement(i * 2).toString());
        RootedId id(cx, NameToId(name->asAtom().asPropertyName()));
        if (!NativeDefineProperty(
              cx, templateObject, id, dummyString, nullptr, nullptr, JSPROP_ENUMERATE)) {
            return false;
        }
        AddTypePropertyId(cx, templateObject, id, UndefinedValue());
    }

    // Allocate the capture index array.
    uint32_t arraySize = numNamedCaptures * sizeof(uint32_t);
    uint32_t* captureIndices = static_cast<uint32_t*>(js_malloc(arraySize));
    if (!captureIndices) {
        ReportOutOfMemory(cx);
        return false;
    }

    // Populate the capture index array
    for (uint32_t i = 0; i < numNamedCaptures; i++) {
        captureIndices[i] = namedCaptures->getDenseElement(i * 2 + 1).toInt32();
    }

    re->numNamedCaptures_ = numNamedCaptures;
    re->groupsTemplate_ = templateObject;
    re->namedCaptureIndices_ = captureIndices;
    // js::AddCellMemory(re, arraySize, MemoryUse::RegExpSharedNamedCaptureData);
    return true;
}

void RegExpShared::tierUpTick() {
  MOZ_ASSERT(kind() == RegExpShared::Kind::RegExp);
  if (ticks_ > 0) {
    ticks_--;
  }
}

bool RegExpShared::markedForTierUp(JSContext* cx) const {
  if (!IsNativeRegExpEnabled(cx)) {
    return false;
  }
  if (kind() != RegExpShared::Kind::RegExp) {
    return false;
  }
  return ticks_ == 0;
}

/* static */
RegExpRunStatus
RegExpShared::executeAtom(JSContext* cx,
                          MutableHandleRegExpShared re,
                          HandleLinearString input,
                          size_t start,
                          MatchPairs* matches)
{
    MOZ_ASSERT(re->pairCount() == 1);

    size_t length = input->length();
    size_t searchLength = re->patternAtom()->length();

    if (re->sticky()) {
        // First part checks size_t overflow.
        if (searchLength + start < searchLength || searchLength + start > length) {
            return RegExpRunStatus_Success_NotFound;
        }
        if (!HasSubstringAt(input, re->patternAtom(), start)) {
            return RegExpRunStatus_Success_NotFound;
        }

        (*matches)[0].start = start;
        (*matches)[0].limit = start + searchLength;
        matches->checkAgainst(length);

        return RegExpRunStatus_Success;
    }

    int res = StringFindPattern(input, re->patternAtom(), start);
    if (res == -1) {
        return RegExpRunStatus_Success_NotFound;
    }

    (*matches)[0].start = res;
    (*matches)[0].limit = res + searchLength;
    matches->checkAgainst(length);

    return RegExpRunStatus_Success;
}

size_t
RegExpShared::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf)
{
    size_t n = 0;

    for (size_t i = 0; i < ArrayLength(compilationArray); i++) {
        const RegExpCompilation& compilation = compilationArray[i];
        if (compilation.byteCode)
            n += mallocSizeOf(compilation.byteCode);
    }

    n += tables.sizeOfExcludingThis(mallocSizeOf);
    for (size_t i = 0; i < tables.length(); i++)
        n += mallocSizeOf(tables[i].get());

    return n;
}

/* RegExpCompartment */

RegExpCompartment::RegExpCompartment(Zone* zone)
  : matchResultTemplateObject_(nullptr),
    optimizableRegExpPrototypeShape_(nullptr),
    optimizableRegExpInstanceShape_(nullptr)
{}

ArrayObject*
RegExpCompartment::createMatchResultTemplateObject(JSContext* cx)
{
    MOZ_ASSERT(!matchResultTemplateObject_);

    /* Create template array object */
    RootedArrayObject templateObject(cx, NewDenseUnallocatedArray(cx, RegExpObject::MaxPairCount,
                                                                  nullptr, TenuredObject));
    if (!templateObject) {
        return nullptr;
    }

    // Create a new group for the template.
    Rooted<TaggedProto> proto(cx, templateObject->taggedProto());
    ObjectGroup* group = ObjectGroupCompartment::makeGroup(cx, templateObject->getClass(), proto);
    if (!group) {
        return nullptr;
    }
    templateObject->setGroup(group);

    /* Set dummy index property */
    RootedValue index(cx, Int32Value(0));
    if (!NativeDefineProperty(cx, templateObject, cx->names().index, index, nullptr, nullptr,
                              JSPROP_ENUMERATE))
    {
        return nullptr;
    }

    /* Set dummy input property */
    RootedValue inputVal(cx, StringValue(cx->runtime()->emptyString));
    if (!NativeDefineProperty(
          cx, templateObject, cx->names().input, inputVal, nullptr, nullptr, JSPROP_ENUMERATE)) {
        return nullptr;
    }

    /* Set dummy groups property */
    RootedValue groupsVal(cx, UndefinedValue());
    if (!NativeDefineProperty(
          cx, templateObject, cx->names().groups, groupsVal, nullptr, nullptr, JSPROP_ENUMERATE)) {
        return nullptr;
    }
    AddTypePropertyId(cx, templateObject, NameToId(cx->names().groups), TypeSet::AnyObjectType());

    // Make sure that the properties are in the right slots.
#ifdef DEBUG
  Shape* groupsShape = templateObject->lastProperty();
  MOZ_ASSERT(groupsShape->slot() == 0 &&
             groupsShape->propidRef() == NameToId(cx->names().groups));
  Shape* inputShape = groupsShape->previous().get();
  MOZ_ASSERT(inputShape->slot() == 1 &&
             inputShape->propidRef() == NameToId(cx->names().input));
  Shape* indexShape = inputShape->previous().get();
  MOZ_ASSERT(indexShape->slot() == 2 &&
             indexShape->propidRef() == NameToId(cx->names().index));
#endif

    // Make sure type information reflects the indexed properties which might
    // be added.
    AddTypePropertyId(cx, templateObject, JSID_VOID, TypeSet::StringType());
    AddTypePropertyId(cx, templateObject, JSID_VOID, TypeSet::UndefinedType());

    matchResultTemplateObject_.set(templateObject);

    return matchResultTemplateObject_;
}

bool
RegExpZone::init()
{
    if (!set_.init(0))
        return false;

    return true;
}

void
RegExpCompartment::sweep(JSRuntime* rt)
{
    if (matchResultTemplateObject_ &&
        IsAboutToBeFinalized(&matchResultTemplateObject_))
    {
        matchResultTemplateObject_.set(nullptr);
    }

    if (optimizableRegExpPrototypeShape_ &&
        IsAboutToBeFinalized(&optimizableRegExpPrototypeShape_))
    {
        optimizableRegExpPrototypeShape_.set(nullptr);
    }

    if (optimizableRegExpInstanceShape_ &&
        IsAboutToBeFinalized(&optimizableRegExpInstanceShape_))
    {
        optimizableRegExpInstanceShape_.set(nullptr);
    }
}

RegExpShared*
RegExpZone::get(JSContext* cx, HandleAtom source, RegExpFlags flags)
{
    DependentAddPtr<Set> p(cx, set_, Key(source, flags));
    if (p)
        return *p;

    auto shared = Allocate<RegExpShared>(cx);
    if (!shared)
        return nullptr;

    new (shared) RegExpShared(source, flags);

    if (!p.add(cx, set_, Key(source, flags), shared)) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    return shared;
}

RegExpShared*
RegExpZone::get(JSContext* cx, HandleAtom atom, JSString* opt)
{
    RegExpFlags flags = RegExpFlag::NoFlags;
    if (opt && !ParseRegExpFlags(cx, opt, &flags))
        return nullptr;

    return get(cx, atom, flags);
}

size_t
RegExpZone::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf)
{
    return set_.sizeOfExcludingThis(mallocSizeOf);
}

RegExpZone::RegExpZone(Zone* zone)
  : set_(zone, zone->runtimeFromMainThread())
{}

/* Functions */

JSObject*
js::CloneRegExpObject(JSContext* cx, Handle<RegExpObject*> regex)
{
    // Unlike RegExpAlloc, all clones must use |regex|'s group.
    RootedObjectGroup group(cx, regex->group());
    Rooted<RegExpObject*> clone(cx, NewObjectWithGroup<RegExpObject>(cx, group, GenericObject));
    if (!clone)
        return nullptr;
    clone->initPrivate(nullptr);

    if (!EmptyShape::ensureInitialCustomShape<RegExpObject>(cx, clone))
        return nullptr;

    RegExpShared* shared = RegExpObject::getShared(cx, regex);
    if (!shared)
        return nullptr;

    clone->initAndZeroLastIndex(shared->getSource(), shared->getFlags(), cx);
    clone->setShared(*shared);

    return clone;
}

template<typename CharT>
static bool
ParseRegExpFlags(const CharT* chars, size_t length, RegExpFlags* flagsOut, char16_t* invalidFlag)
{
    *flagsOut = RegExpFlag::NoFlags;

    for (size_t i = 0; i < length; i++) {
        uint8_t flag;
        switch (chars[i]) {
            case 'g':
                flag = RegExpFlag::Global;
                break;
            case 'i':
                flag = RegExpFlag::IgnoreCase;
                break;
            case 'm':
                flag = RegExpFlag::Multiline;
                break;
            case 's':
                flag = RegExpFlag::DotAll;
                break;
            case 'u':
                flag = RegExpFlag::Unicode;
                break;
            case 'y':
                flag = RegExpFlag::Sticky;
                break;
            default:
                *invalidFlag = chars[i];
                return false;
        }
        if (*flagsOut & flag) {
            *invalidFlag = chars[i];
            return false;
        }
        *flagsOut |= flag;
    }

    return true;
}

bool
js::ParseRegExpFlags(JSContext* cx, JSString* flagStr, RegExpFlags* flagsOut)
{
    JSLinearString* linear = flagStr->ensureLinear(cx);
    if (!linear)
        return false;

    size_t len = linear->length();

    bool ok;
    char16_t invalidFlag;
    if (linear->hasLatin1Chars()) {
        AutoCheckCannotGC nogc;
        ok = ::ParseRegExpFlags(linear->latin1Chars(nogc), len, flagsOut, &invalidFlag);
    } else {
        AutoCheckCannotGC nogc;
        ok = ::ParseRegExpFlags(linear->twoByteChars(nogc), len, flagsOut, &invalidFlag);
    }

    if (!ok) {
        TwoByteChars range(&invalidFlag, 1);
        UniqueChars utf8(JS::CharsToNewUTF8CharsZ(cx, range).c_str());
        if (!utf8)
            return false;
        JS_ReportErrorFlagsAndNumberUTF8(cx, JSREPORT_ERROR, GetErrorMessage, nullptr,
                                         JSMSG_BAD_REGEXP_FLAG, utf8.get());
        return false;
    }

    return true;
}

template<XDRMode mode>
bool
js::XDRScriptRegExpObject(XDRState<mode>* xdr, MutableHandle<RegExpObject*> objp)
{
    /* NB: Keep this in sync with CloneScriptRegExpObject. */

    RootedAtom source(xdr->cx());
    uint8_t flags = 0;

    if (mode == XDR_ENCODE) {
        MOZ_ASSERT(objp);
        RegExpObject& reobj = *objp;
        source = reobj.getSource();
        flags = reobj.getFlags().value();
    }
    if (!XDRAtom(xdr, &source) || !xdr->codeUint8(&flags))
        return false;
    if (mode == XDR_DECODE) {
        const ReadOnlyCompileOptions* options = nullptr;
        if (xdr->hasOptions())
            options = &xdr->options();
        RegExpObject* reobj = RegExpObject::create(xdr->cx(), source, RegExpFlags(flags),
                                                   options, nullptr, xdr->lifoAlloc(),
                                                   TenuredObject);
        if (!reobj)
            return false;

        objp.set(reobj);
    }
    return true;
}

template bool
js::XDRScriptRegExpObject(XDRState<XDR_ENCODE>* xdr, MutableHandle<RegExpObject*> objp);

template bool
js::XDRScriptRegExpObject(XDRState<XDR_DECODE>* xdr, MutableHandle<RegExpObject*> objp);

JSObject*
js::CloneScriptRegExpObject(JSContext* cx, RegExpObject& reobj)
{
    /* NB: Keep this in sync with XDRScriptRegExpObject. */

    RootedAtom source(cx, reobj.getSource());
    cx->markAtom(source);

    return RegExpObject::create(cx, source, reobj.getFlags(),
                                nullptr, nullptr, cx->tempLifoAlloc(),
                                TenuredObject);
}

JS_FRIEND_API(RegExpShared*)
js::RegExpToSharedNonInline(JSContext* cx, HandleObject obj)
{
    return RegExpToShared(cx, obj);
}

JS::ubi::Node::Size
JS::ubi::Concrete<RegExpShared>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    return js::gc::Arena::thingSize(gc::AllocKind::REGEXP_SHARED) +
        get().sizeOfExcludingThis(mallocSizeOf);
}

/*
 * Public API functions for Regular Expressions.
 */
JS_PUBLIC_API(JSObject*)
JS::NewRegExpObject(JSContext* cx, const char* bytes, size_t length, RegExpFlags flags)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);
    ScopedJSFreePtr<char16_t> chars(InflateString(cx, bytes, length));
    if (!chars) {
        return nullptr;
    }

    return RegExpObject::create(
      cx, chars, length, flags, nullptr, nullptr, cx->tempLifoAlloc(), GenericObject);
}

JS_PUBLIC_API(JSObject*)
JS::NewUCRegExpObject(JSContext* cx, const char16_t* chars, size_t length, RegExpFlags flags)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);
    return RegExpObject::create(
      cx, chars, length, flags, nullptr, nullptr, cx->tempLifoAlloc(), GenericObject);
}

JS_PUBLIC_API(bool) JS::SetRegExpInput(JSContext* cx, HandleObject obj, HandleString input)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);
    assertSameCompartment(cx, input);

    Handle<GlobalObject*> global = obj.as<GlobalObject>();
    RegExpStatics* res = GlobalObject::getRegExpStatics(cx, global);
    if (!res) {
        return false;
    }

    res->reset(cx, input);
    return true;
}

JS_PUBLIC_API(bool) JS::ClearRegExpStatics(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);
    MOZ_ASSERT(obj);

    Handle<GlobalObject*> global = obj.as<GlobalObject>();
    RegExpStatics* res = GlobalObject::getRegExpStatics(cx, global);
    if (!res) {
        return false;
    }

    res->clear();
    return true;
}

JS_PUBLIC_API(bool)
JS::ExecuteRegExp(JSContext* cx,
                  HandleObject obj,
                  HandleObject reobj,
                  char16_t* chars,
                  size_t length,
                  size_t* indexp,
                  bool test,
                  MutableHandleValue rval)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);

    Handle<GlobalObject*> global = obj.as<GlobalObject>();
    RegExpStatics* res = GlobalObject::getRegExpStatics(cx, global);
    if (!res) {
        return false;
    }

    RootedLinearString input(cx, NewStringCopyN<CanGC>(cx, chars, length));
    if (!input) {
        return false;
    }

    return ExecuteRegExpLegacy(cx, res, reobj.as<RegExpObject>(), input, indexp, test, rval);
}

JS_PUBLIC_API(bool)
JS::ExecuteRegExpNoStatics(JSContext* cx,
                           HandleObject obj,
                           char16_t* chars,
                           size_t length,
                           size_t* indexp,
                           bool test,
                           MutableHandleValue rval)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);

    RootedLinearString input(cx, NewStringCopyN<CanGC>(cx, chars, length));
    if (!input) {
        return false;
    }

    return ExecuteRegExpLegacy(cx, nullptr, obj.as<RegExpObject>(), input, indexp, test, rval);
}

JS_PUBLIC_API(bool) JS::ObjectIsRegExp(JSContext* cx, HandleObject obj, bool* isRegExp)
{
    assertSameCompartment(cx, obj);

    ESClass cls;
    if (!GetBuiltinClass(cx, obj, &cls)) {
        return false;
    }

    *isRegExp = cls == ESClass::RegExp;
    return true;
}

JS_PUBLIC_API(RegExpFlags) JS::GetRegExpFlags(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);

    RegExpShared* shared = RegExpToShared(cx, obj);
    if (!shared) {
        return RegExpFlag::NoFlags;
    }
    return shared->getFlags();
}

JS_PUBLIC_API(JSString*) JS::GetRegExpSource(JSContext* cx, HandleObject obj)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);

    RegExpShared* shared = RegExpToShared(cx, obj);
    if (!shared) {
        return nullptr;
    }
    return shared->getSource();
}

JS_PUBLIC_API(bool)
JS::CheckRegExpSyntax(JSContext* cx,
                      const char16_t* chars,
                      size_t length,
                      RegExpFlags flags,
                      MutableHandleValue error)
{
    AssertHeapIsIdle();
    CHECK_REQUEST(cx);

    CompileOptions options(cx, JSVERSION_DEFAULT);
    frontend::TokenStream dummyTokenStream(cx, options, nullptr, 0, nullptr);

    mozilla::Range<const char16_t> source(chars, length);
    bool success = irregexp::CheckPatternSyntax(cx, dummyTokenStream, source, flags);
    error.set(UndefinedValue());
    if (!success) {
        // We can fail because of OOM or over-recursion even if the syntax is valid.
        if (cx->isThrowingOutOfMemory() || cx->isThrowingOverRecursed()) {
            return false;
        }
        if (!cx->getPendingException(error)) {
            return false;
        }
        cx->clearPendingException();
    }
    return true;
}
