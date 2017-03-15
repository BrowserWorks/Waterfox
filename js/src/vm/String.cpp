/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "vm/String-inl.h"

#include "mozilla/MathAlgorithms.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PodOperations.h"
#include "mozilla/RangedPtr.h"
#include "mozilla/SizePrintfMacros.h"
#include "mozilla/TypeTraits.h"
#include "mozilla/Unused.h"

#include "gc/Marking.h"
#include "js/UbiNode.h"
#include "vm/SPSProfiler.h"

#include "jscntxtinlines.h"
#include "jscompartmentinlines.h"

using namespace js;

using mozilla::IsSame;
using mozilla::PodCopy;
using mozilla::RangedPtr;
using mozilla::RoundUpPow2;

using JS::AutoCheckCannotGC;

size_t
JSString::sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf)
{
    // JSRope: do nothing, we'll count all children chars when we hit the leaf strings.
    if (isRope())
        return 0;

    MOZ_ASSERT(isLinear());

    // JSDependentString: do nothing, we'll count the chars when we hit the base string.
    if (isDependent())
        return 0;

    // JSExternalString: don't count, the chars could be stored anywhere.
    if (isExternal())
        return 0;

    MOZ_ASSERT(isFlat());

    // JSExtensibleString: count the full capacity, not just the used space.
    if (isExtensible()) {
        JSExtensibleString& extensible = asExtensible();
        return extensible.hasLatin1Chars()
               ? mallocSizeOf(extensible.rawLatin1Chars())
               : mallocSizeOf(extensible.rawTwoByteChars());
    }

    // JSInlineString, JSFatInlineString [JSInlineAtom, JSFatInlineAtom]: the chars are inline.
    if (isInline())
        return 0;

    // JSAtom, JSUndependedString: measure the space for the chars.  For
    // JSUndependedString, there is no need to count the base string, for the
    // same reason as JSDependentString above.
    JSFlatString& flat = asFlat();
    return flat.hasLatin1Chars()
           ? mallocSizeOf(flat.rawLatin1Chars())
           : mallocSizeOf(flat.rawTwoByteChars());
}

JS::ubi::Node::Size
JS::ubi::Concrete<JSString>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    JSString& str = get();
    size_t size;
    if (str.isAtom())
        size = str.isFatInline() ? sizeof(js::FatInlineAtom) : sizeof(js::NormalAtom);
    else
        size = str.isFatInline() ? sizeof(JSFatInlineString) : sizeof(JSString);

    // We can't use mallocSizeof on things in the nursery. At the moment,
    // strings are never in the nursery, but that may change.
    MOZ_ASSERT(!IsInsideNursery(&str));
    size += str.sizeOfExcludingThis(mallocSizeOf);

    return size;
}

const char16_t JS::ubi::Concrete<JSString>::concreteTypeName[] = u"JSString";

#ifdef DEBUG

template <typename CharT>
/*static */ void
JSString::dumpChars(const CharT* s, size_t n, FILE* fp)
{
    if (n == SIZE_MAX) {
        n = 0;
        while (s[n])
            n++;
    }

    fputc('"', fp);
    for (size_t i = 0; i < n; i++) {
        char16_t c = s[i];
        if (c == '\n')
            fprintf(fp, "\\n");
        else if (c == '\t')
            fprintf(fp, "\\t");
        else if (c >= 32 && c < 127)
            fputc(s[i], fp);
        else if (c <= 255)
            fprintf(fp, "\\x%02x", unsigned(c));
        else
            fprintf(fp, "\\u%04x", unsigned(c));
    }
    fputc('"', fp);
}

template void
JSString::dumpChars(const Latin1Char* s, size_t n, FILE* fp);

template void
JSString::dumpChars(const char16_t* s, size_t n, FILE* fp);

void
JSString::dumpCharsNoNewline(FILE* fp)
{
    if (JSLinearString* linear = ensureLinear(nullptr)) {
        AutoCheckCannotGC nogc;
        if (hasLatin1Chars())
            dumpChars(linear->latin1Chars(nogc), length(), fp);
        else
            dumpChars(linear->twoByteChars(nogc), length(), fp);
    } else {
        fprintf(fp, "(oom in JSString::dumpCharsNoNewline)");
    }
}

void
JSString::dump(FILE* fp)
{
    if (JSLinearString* linear = ensureLinear(nullptr)) {
        AutoCheckCannotGC nogc;
        if (hasLatin1Chars()) {
            const Latin1Char* chars = linear->latin1Chars(nogc);
            fprintf(fp, "JSString* (%p) = Latin1Char * (%p) = ", (void*) this,
                    (void*) chars);
            dumpChars(chars, length(), fp);
        } else {
            const char16_t* chars = linear->twoByteChars(nogc);
            fprintf(fp, "JSString* (%p) = char16_t * (%p) = ", (void*) this,
                    (void*) chars);
            dumpChars(chars, length(), fp);
        }
    } else {
        fprintf(fp, "(oom in JSString::dump)");
    }
    fputc('\n', fp);
}

void
JSString::dumpCharsNoNewline()
{
    dumpCharsNoNewline(stderr);
}

void
JSString::dump()
{
    dump(stderr);
}

void
JSString::dumpRepresentation(FILE* fp, int indent) const
{
    if      (isRope())          asRope()        .dumpRepresentation(fp, indent);
    else if (isDependent())     asDependent()   .dumpRepresentation(fp, indent);
    else if (isExternal())      asExternal()    .dumpRepresentation(fp, indent);
    else if (isExtensible())    asExtensible()  .dumpRepresentation(fp, indent);
    else if (isInline())        asInline()      .dumpRepresentation(fp, indent);
    else if (isFlat())          asFlat()        .dumpRepresentation(fp, indent);
    else
        MOZ_CRASH("Unexpected JSString representation");
}

void
JSString::dumpRepresentationHeader(FILE* fp, int indent, const char* subclass) const
{
    uint32_t flags = d.u1.flags;
    // Print the string's address as an actual C++ expression, to facilitate
    // copy-and-paste into a debugger.
    fprintf(fp, "((%s*) %p) length: %" PRIuSIZE "  flags: 0x%x", subclass, this, length(), flags);
    if (flags & FLAT_BIT)               fputs(" FLAT", fp);
    if (flags & HAS_BASE_BIT)           fputs(" HAS_BASE", fp);
    if (flags & INLINE_CHARS_BIT)       fputs(" INLINE_CHARS", fp);
    if (flags & ATOM_BIT)               fputs(" ATOM", fp);
    if (isPermanentAtom())              fputs(" PERMANENT", fp);
    if (flags & LATIN1_CHARS_BIT)       fputs(" LATIN1", fp);
    fputc('\n', fp);
}

void
JSLinearString::dumpRepresentationChars(FILE* fp, int indent) const
{
    if (hasLatin1Chars()) {
        fprintf(fp, "%*schars: ((Latin1Char*) %p) ", indent, "", rawLatin1Chars());
        dumpChars(rawLatin1Chars(), length());
    } else {
        fprintf(fp, "%*schars: ((char16_t*) %p) ", indent, "", rawTwoByteChars());
        dumpChars(rawTwoByteChars(), length());
    }
    fputc('\n', fp);
}

bool
JSString::equals(const char* s)
{
    JSLinearString* linear = ensureLinear(nullptr);
    if (!linear) {
        fprintf(stderr, "OOM in JSString::equals!\n");
        return false;
    }

    return StringEqualsAscii(linear, s);
}
#endif /* DEBUG */

template <typename CharT>
static MOZ_ALWAYS_INLINE bool
AllocChars(JSString* str, size_t length, CharT** chars, size_t* capacity)
{
    /*
     * String length doesn't include the null char, so include it here before
     * doubling. Adding the null char after doubling would interact poorly with
     * round-up malloc schemes.
     */
    size_t numChars = length + 1;

    /*
     * Grow by 12.5% if the buffer is very large. Otherwise, round up to the
     * next power of 2. This is similar to what we do with arrays; see
     * JSObject::ensureDenseArrayElements.
     */
    static const size_t DOUBLING_MAX = 1024 * 1024;
    numChars = numChars > DOUBLING_MAX ? numChars + (numChars / 8) : RoundUpPow2(numChars);

    /* Like length, capacity does not include the null char, so take it out. */
    *capacity = numChars - 1;

    JS_STATIC_ASSERT(JSString::MAX_LENGTH * sizeof(CharT) < UINT32_MAX);
    *chars = str->zone()->pod_malloc<CharT>(numChars);
    return *chars != nullptr;
}

bool
JSRope::copyLatin1CharsZ(ExclusiveContext* cx, ScopedJSFreePtr<Latin1Char>& out) const
{
    return copyCharsInternal<Latin1Char>(cx, out, true);
}

bool
JSRope::copyTwoByteCharsZ(ExclusiveContext* cx, ScopedJSFreePtr<char16_t>& out) const
{
    return copyCharsInternal<char16_t>(cx, out, true);
}

bool
JSRope::copyLatin1Chars(ExclusiveContext* cx, ScopedJSFreePtr<Latin1Char>& out) const
{
    return copyCharsInternal<Latin1Char>(cx, out, false);
}

bool
JSRope::copyTwoByteChars(ExclusiveContext* cx, ScopedJSFreePtr<char16_t>& out) const
{
    return copyCharsInternal<char16_t>(cx, out, false);
}

template <typename CharT>
bool
JSRope::copyCharsInternal(ExclusiveContext* cx, ScopedJSFreePtr<CharT>& out,
                          bool nullTerminate) const
{
    /*
     * Perform non-destructive post-order traversal of the rope, splatting
     * each node's characters into a contiguous buffer.
     */

    size_t n = length();
    if (cx)
        out.reset(cx->pod_malloc<CharT>(n + 1));
    else
        out.reset(js_pod_malloc<CharT>(n + 1));

    if (!out)
        return false;

    Vector<const JSString*, 8, SystemAllocPolicy> nodeStack;
    const JSString* str = this;
    CharT* pos = out;
    while (true) {
        if (str->isRope()) {
            if (!nodeStack.append(str->asRope().rightChild()))
                return false;
            str = str->asRope().leftChild();
        } else {
            CopyChars(pos, str->asLinear());
            pos += str->length();
            if (nodeStack.empty())
                break;
            str = nodeStack.popCopy();
        }
    }

    MOZ_ASSERT(pos == out + n);

    if (nullTerminate)
        out[n] = 0;

    return true;
}

#ifdef DEBUG
void
JSRope::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent, "JSRope");
    indent += 2;

    fprintf(fp, "%*sleft:  ", indent, "");
    leftChild()->dumpRepresentation(fp, indent);

    fprintf(fp, "%*sright: ", indent, "");
    rightChild()->dumpRepresentation(fp, indent);
}
#endif

namespace js {

template <>
void
CopyChars(char16_t* dest, const JSLinearString& str)
{
    AutoCheckCannotGC nogc;
    if (str.hasTwoByteChars())
        PodCopy(dest, str.twoByteChars(nogc), str.length());
    else
        CopyAndInflateChars(dest, str.latin1Chars(nogc), str.length());
}

template <>
void
CopyChars(Latin1Char* dest, const JSLinearString& str)
{
    AutoCheckCannotGC nogc;
    if (str.hasLatin1Chars()) {
        PodCopy(dest, str.latin1Chars(nogc), str.length());
    } else {
        /*
         * When we flatten a TwoByte rope, we turn child ropes (including Latin1
         * ropes) into TwoByte dependent strings. If one of these strings is
         * also part of another Latin1 rope tree, we can have a Latin1 rope with
         * a TwoByte descendent and we end up here when we flatten it. Although
         * the chars are stored as TwoByte, we know they must be in the Latin1
         * range, so we can safely deflate here.
         */
        size_t len = str.length();
        const char16_t* chars = str.twoByteChars(nogc);
        for (size_t i = 0; i < len; i++) {
            MOZ_ASSERT(chars[i] <= JSString::MAX_LATIN1_CHAR);
            dest[i] = chars[i];
        }
    }
}

} /* namespace js */

template<JSRope::UsingBarrier b, typename CharT>
JSFlatString*
JSRope::flattenInternal(ExclusiveContext* maybecx)
{
    /*
     * Consider the DAG of JSRopes rooted at this JSRope, with non-JSRopes as
     * its leaves. Mutate the root JSRope into a JSExtensibleString containing
     * the full flattened text that the root represents, and mutate all other
     * JSRopes in the interior of the DAG into JSDependentStrings that refer to
     * this new JSExtensibleString.
     *
     * If the leftmost leaf of our DAG is a JSExtensibleString, consider
     * stealing its buffer for use in our new root, and transforming it into a
     * JSDependentString too. Do not mutate any of the other leaves.
     *
     * Perform a depth-first dag traversal, splatting each node's characters
     * into a contiguous buffer. Visit each rope node three times:
     *   1. record position in the buffer and recurse into left child;
     *   2. recurse into the right child;
     *   3. transform the node into a dependent string.
     * To avoid maintaining a stack, tree nodes are mutated to indicate how many
     * times they have been visited. Since ropes can be dags, a node may be
     * encountered multiple times during traversal. However, step 3 above leaves
     * a valid dependent string, so everything works out.
     *
     * While ropes avoid all sorts of quadratic cases with string concatenation,
     * they can't help when ropes are immediately flattened. One idiomatic case
     * that we'd like to keep linear (and has traditionally been linear in SM
     * and other JS engines) is:
     *
     *   while (...) {
     *     s += ...
     *     s.flatten
     *   }
     *
     * Two behaviors accomplish this:
     *
     * - When the leftmost non-rope in the DAG we're flattening is a
     *   JSExtensibleString with sufficient capacity to hold the entire
     *   flattened string, we just flatten the DAG into its buffer. Then, when
     *   we transform the root of the DAG from a JSRope into a
     *   JSExtensibleString, we steal that buffer, and change the victim from a
     *   JSExtensibleString to a JSDependentString. In this case, the left-hand
     *   side of the string never needs to be copied.
     *
     * - Otherwise, we round up the total flattened size and create a fresh
     *   JSExtensibleString with that much capacity. If this in turn becomes the
     *   leftmost leaf of a subsequent flatten, we will hopefully be able to
     *   fill it, as in the case above.
     *
     * Note that, even though the code for creating JSDependentStrings avoids
     * creating dependents of dependents, we can create that situation here: the
     * JSExtensibleStrings we transform into JSDependentStrings might have
     * JSDependentStrings pointing to them already. Stealing the buffer doesn't
     * change its address, only its owning JSExtensibleString, so all chars()
     * pointers in the JSDependentStrings are still valid.
     */
    const size_t wholeLength = length();
    size_t wholeCapacity;
    CharT* wholeChars;
    JSString* str = this;
    CharT* pos;

    /*
     * JSString::flattenData is a tagged pointer to the parent node.
     * The tag indicates what to do when we return to the parent.
     */
    static const uintptr_t Tag_Mask = 0x3;
    static const uintptr_t Tag_FinishNode = 0x0;
    static const uintptr_t Tag_VisitRightChild = 0x1;

    AutoCheckCannotGC nogc;

    /* Find the left most string, containing the first string. */
    JSRope* leftMostRope = this;
    while (leftMostRope->leftChild()->isRope())
        leftMostRope = &leftMostRope->leftChild()->asRope();

    if (leftMostRope->leftChild()->isExtensible()) {
        JSExtensibleString& left = leftMostRope->leftChild()->asExtensible();
        size_t capacity = left.capacity();
        if (capacity >= wholeLength && left.hasTwoByteChars() == IsSame<CharT, char16_t>::value) {
            /*
             * Simulate a left-most traversal from the root to leftMost->leftChild()
             * via first_visit_node
             */
            MOZ_ASSERT(str->isRope());
            while (str != leftMostRope) {
                if (b == WithIncrementalBarrier) {
                    JSString::writeBarrierPre(str->d.s.u2.left);
                    JSString::writeBarrierPre(str->d.s.u3.right);
                }
                JSString* child = str->d.s.u2.left;
                MOZ_ASSERT(child->isRope());
                str->setNonInlineChars(left.nonInlineChars<CharT>(nogc));
                child->d.u1.flattenData = uintptr_t(str) | Tag_VisitRightChild;
                str = child;
            }
            if (b == WithIncrementalBarrier) {
                JSString::writeBarrierPre(str->d.s.u2.left);
                JSString::writeBarrierPre(str->d.s.u3.right);
            }
            str->setNonInlineChars(left.nonInlineChars<CharT>(nogc));
            wholeCapacity = capacity;
            wholeChars = const_cast<CharT*>(left.nonInlineChars<CharT>(nogc));
            pos = wholeChars + left.d.u1.length;
            JS_STATIC_ASSERT(!(EXTENSIBLE_FLAGS & DEPENDENT_FLAGS));
            left.d.u1.flags ^= (EXTENSIBLE_FLAGS | DEPENDENT_FLAGS);
            left.d.s.u3.base = (JSLinearString*)this;  /* will be true on exit */
            StringWriteBarrierPostRemove(maybecx, &left.d.s.u2.left);
            StringWriteBarrierPost(maybecx, (JSString**)&left.d.s.u3.base);
            goto visit_right_child;
        }
    }

    if (!AllocChars(this, wholeLength, &wholeChars, &wholeCapacity)) {
        if (maybecx)
            ReportOutOfMemory(maybecx);
        return nullptr;
    }

    pos = wholeChars;
    first_visit_node: {
        if (b == WithIncrementalBarrier) {
            JSString::writeBarrierPre(str->d.s.u2.left);
            JSString::writeBarrierPre(str->d.s.u3.right);
        }

        JSString& left = *str->d.s.u2.left;
        str->setNonInlineChars(pos);
        StringWriteBarrierPostRemove(maybecx, &str->d.s.u2.left);
        if (left.isRope()) {
            /* Return to this node when 'left' done, then goto visit_right_child. */
            left.d.u1.flattenData = uintptr_t(str) | Tag_VisitRightChild;
            str = &left;
            goto first_visit_node;
        }
        CopyChars(pos, left.asLinear());
        pos += left.length();
    }
    visit_right_child: {
        JSString& right = *str->d.s.u3.right;
        if (right.isRope()) {
            /* Return to this node when 'right' done, then goto finish_node. */
            right.d.u1.flattenData = uintptr_t(str) | Tag_FinishNode;
            str = &right;
            goto first_visit_node;
        }
        CopyChars(pos, right.asLinear());
        pos += right.length();
    }
    finish_node: {
        if (str == this) {
            MOZ_ASSERT(pos == wholeChars + wholeLength);
            *pos = '\0';
            str->d.u1.length = wholeLength;
            if (IsSame<CharT, char16_t>::value)
                str->d.u1.flags = EXTENSIBLE_FLAGS;
            else
                str->d.u1.flags = EXTENSIBLE_FLAGS | LATIN1_CHARS_BIT;
            str->setNonInlineChars(wholeChars);
            str->d.s.u3.capacity = wholeCapacity;
            StringWriteBarrierPostRemove(maybecx, &str->d.s.u2.left);
            StringWriteBarrierPostRemove(maybecx, &str->d.s.u3.right);
            return &this->asFlat();
        }
        uintptr_t flattenData = str->d.u1.flattenData;
        if (IsSame<CharT, char16_t>::value)
            str->d.u1.flags = DEPENDENT_FLAGS;
        else
            str->d.u1.flags = DEPENDENT_FLAGS | LATIN1_CHARS_BIT;
        str->d.u1.length = pos - str->asLinear().nonInlineChars<CharT>(nogc);
        str->d.s.u3.base = (JSLinearString*)this;       /* will be true on exit */
        StringWriteBarrierPost(maybecx, (JSString**)&str->d.s.u3.base);
        str = (JSString*)(flattenData & ~Tag_Mask);
        if ((flattenData & Tag_Mask) == Tag_VisitRightChild)
            goto visit_right_child;
        MOZ_ASSERT((flattenData & Tag_Mask) == Tag_FinishNode);
        goto finish_node;
    }
}

template<JSRope::UsingBarrier b>
JSFlatString*
JSRope::flattenInternal(ExclusiveContext* maybecx)
{
    if (hasTwoByteChars())
        return flattenInternal<b, char16_t>(maybecx);
    return flattenInternal<b, Latin1Char>(maybecx);
}

JSFlatString*
JSRope::flatten(ExclusiveContext* maybecx)
{
    mozilla::Maybe<AutoSPSEntry> sps;
    if (maybecx && maybecx->isJSContext())
        sps.emplace(maybecx->asJSContext()->runtime(), "JSRope::flatten");

    if (zone()->needsIncrementalBarrier())
        return flattenInternal<WithIncrementalBarrier>(maybecx);
    return flattenInternal<NoBarrier>(maybecx);
}

template <AllowGC allowGC>
static JSLinearString*
EnsureLinear(ExclusiveContext* cx, typename MaybeRooted<JSString*, allowGC>::HandleType string)
{
    JSLinearString* linear = string->ensureLinear(cx);
    // Don't report an exception if GC is not allowed, just return nullptr.
    if (!linear && !allowGC)
        cx->recoverFromOutOfMemory();
    return linear;
}

template <AllowGC allowGC>
JSString*
js::ConcatStrings(ExclusiveContext* cx,
                  typename MaybeRooted<JSString*, allowGC>::HandleType left,
                  typename MaybeRooted<JSString*, allowGC>::HandleType right)
{
    MOZ_ASSERT_IF(!left->isAtom(), cx->isInsideCurrentZone(left));
    MOZ_ASSERT_IF(!right->isAtom(), cx->isInsideCurrentZone(right));

    size_t leftLen = left->length();
    if (leftLen == 0)
        return right;

    size_t rightLen = right->length();
    if (rightLen == 0)
        return left;

    size_t wholeLength = leftLen + rightLen;
    if (MOZ_UNLIKELY(wholeLength > JSString::MAX_LENGTH)) {
        // Don't report an exception if GC is not allowed, just return nullptr.
        if (allowGC)
            js::ReportAllocationOverflow(cx);
        return nullptr;
    }

    bool isLatin1 = left->hasLatin1Chars() && right->hasLatin1Chars();
    bool canUseInline = isLatin1
                        ? JSInlineString::lengthFits<Latin1Char>(wholeLength)
                        : JSInlineString::lengthFits<char16_t>(wholeLength);
    if (canUseInline && cx->isJSContext()) {
        Latin1Char* latin1Buf = nullptr;  // initialize to silence GCC warning
        char16_t* twoByteBuf = nullptr;  // initialize to silence GCC warning
        JSInlineString* str = isLatin1
            ? AllocateInlineString<allowGC>(cx, wholeLength, &latin1Buf)
            : AllocateInlineString<allowGC>(cx, wholeLength, &twoByteBuf);
        if (!str)
            return nullptr;

        AutoCheckCannotGC nogc;
        JSLinearString* leftLinear = EnsureLinear<allowGC>(cx, left);
        if (!leftLinear)
            return nullptr;
        JSLinearString* rightLinear = EnsureLinear<allowGC>(cx, right);
        if (!rightLinear)
            return nullptr;

        if (isLatin1) {
            PodCopy(latin1Buf, leftLinear->latin1Chars(nogc), leftLen);
            PodCopy(latin1Buf + leftLen, rightLinear->latin1Chars(nogc), rightLen);
            latin1Buf[wholeLength] = 0;
        } else {
            if (leftLinear->hasTwoByteChars())
                PodCopy(twoByteBuf, leftLinear->twoByteChars(nogc), leftLen);
            else
                CopyAndInflateChars(twoByteBuf, leftLinear->latin1Chars(nogc), leftLen);
            if (rightLinear->hasTwoByteChars())
                PodCopy(twoByteBuf + leftLen, rightLinear->twoByteChars(nogc), rightLen);
            else
                CopyAndInflateChars(twoByteBuf + leftLen, rightLinear->latin1Chars(nogc), rightLen);
            twoByteBuf[wholeLength] = 0;
        }

        return str;
    }

    return JSRope::new_<allowGC>(cx, left, right, wholeLength);
}

template JSString*
js::ConcatStrings<CanGC>(ExclusiveContext* cx, HandleString left, HandleString right);

template JSString*
js::ConcatStrings<NoGC>(ExclusiveContext* cx, JSString* const& left, JSString* const& right);

template <typename CharT>
JSFlatString*
JSDependentString::undependInternal(JSContext* cx)
{
    size_t n = length();
    CharT* s = cx->pod_malloc<CharT>(n + 1);
    if (!s)
        return nullptr;

    AutoCheckCannotGC nogc;
    PodCopy(s, nonInlineChars<CharT>(nogc), n);
    s[n] = '\0';
    setNonInlineChars<CharT>(s);

    /*
     * Transform *this into an undepended string so 'base' will remain rooted
     * for the benefit of any other dependent string that depends on *this.
     */
    if (IsSame<CharT, Latin1Char>::value)
        d.u1.flags = UNDEPENDED_FLAGS | LATIN1_CHARS_BIT;
    else
        d.u1.flags = UNDEPENDED_FLAGS;

    return &this->asFlat();
}

JSFlatString*
JSDependentString::undepend(JSContext* cx)
{
    MOZ_ASSERT(JSString::isDependent());
    return hasLatin1Chars()
           ? undependInternal<Latin1Char>(cx)
           : undependInternal<char16_t>(cx);
}

#ifdef DEBUG
void
JSDependentString::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent, "JSDependentString");
    indent += 2;

    fprintf(fp, "%*soffset: %" PRIuSIZE "\n", indent, "", baseOffset());
    fprintf(fp, "%*sbase: ", indent, "");
    base()->dumpRepresentation(fp, indent);
}
#endif

template <typename CharT>
/* static */ bool
JSFlatString::isIndexSlow(const CharT* s, size_t length, uint32_t* indexp)
{
    CharT ch = *s;

    if (!JS7_ISDEC(ch))
        return false;

    if (length > UINT32_CHAR_BUFFER_LENGTH)
        return false;

    /*
     * Make sure to account for the '\0' at the end of characters, dereferenced
     * in the loop below.
     */
    RangedPtr<const CharT> cp(s, length + 1);
    const RangedPtr<const CharT> end(s + length, s, length + 1);

    uint32_t index = JS7_UNDEC(*cp++);
    uint32_t oldIndex = 0;
    uint32_t c = 0;

    if (index != 0) {
        while (JS7_ISDEC(*cp)) {
            oldIndex = index;
            c = JS7_UNDEC(*cp);
            index = 10 * index + c;
            cp++;
        }
    }

    /* It's not an element if there are characters after the number. */
    if (cp != end)
        return false;

    /*
     * Look out for "4294967296" and larger-number strings that fit in
     * UINT32_CHAR_BUFFER_LENGTH: only unsigned 32-bit integers shall pass.
     */
    if (oldIndex < UINT32_MAX / 10 || (oldIndex == UINT32_MAX / 10 && c <= (UINT32_MAX % 10))) {
        *indexp = index;
        return true;
    }

    return false;
}

template bool
JSFlatString::isIndexSlow(const Latin1Char* s, size_t length, uint32_t* indexp);

template bool
JSFlatString::isIndexSlow(const char16_t* s, size_t length, uint32_t* indexp);

/*
 * Set up some tools to make it easier to generate large tables. After constant
 * folding, for each n, Rn(0) is the comma-separated list R(0), R(1), ..., R(2^n-1).
 * Similary, Rn(k) (for any k and n) generates the list R(k), R(k+1), ..., R(k+2^n-1).
 * To use this, define R appropriately, then use Rn(0) (for some value of n), then
 * undefine R.
 */
#define R2(n) R(n),  R((n) + (1 << 0)),  R((n) + (2 << 0)),  R((n) + (3 << 0))
#define R4(n) R2(n), R2((n) + (1 << 2)), R2((n) + (2 << 2)), R2((n) + (3 << 2))
#define R6(n) R4(n), R4((n) + (1 << 4)), R4((n) + (2 << 4)), R4((n) + (3 << 4))
#define R7(n) R6(n), R6((n) + (1 << 6))

/*
 * This is used when we generate our table of short strings, so the compiler is
 * happier if we use |c| as few times as possible.
 */
#define FROM_SMALL_CHAR(c) Latin1Char((c) + ((c) < 10 ? '0' :      \
                                             (c) < 36 ? 'a' - 10 : \
                                             'A' - 36))

/*
 * Declare length-2 strings. We only store strings where both characters are
 * alphanumeric. The lower 10 short chars are the numerals, the next 26 are
 * the lowercase letters, and the next 26 are the uppercase letters.
 */
#define TO_SMALL_CHAR(c) ((c) >= '0' && (c) <= '9' ? (c) - '0' :              \
                          (c) >= 'a' && (c) <= 'z' ? (c) - 'a' + 10 :         \
                          (c) >= 'A' && (c) <= 'Z' ? (c) - 'A' + 36 :         \
                          StaticStrings::INVALID_SMALL_CHAR)

#define R TO_SMALL_CHAR
const StaticStrings::SmallChar StaticStrings::toSmallChar[] = { R7(0) };
#undef R

#undef R2
#undef R4
#undef R6
#undef R7

bool
StaticStrings::init(JSContext* cx)
{
    AutoLockForExclusiveAccess lock(cx);
    AutoCompartment ac(cx, cx->runtime()->atomsCompartment(lock), &lock);

    static_assert(UNIT_STATIC_LIMIT - 1 <= JSString::MAX_LATIN1_CHAR,
                  "Unit strings must fit in Latin1Char.");

    using Latin1Range = mozilla::Range<const Latin1Char>;

    for (uint32_t i = 0; i < UNIT_STATIC_LIMIT; i++) {
        Latin1Char buffer[] = { Latin1Char(i), '\0' };
        JSFlatString* s = NewInlineString<NoGC>(cx, Latin1Range(buffer, 1));
        if (!s)
            return false;
        HashNumber hash = mozilla::HashString(buffer, 1);
        unitStaticTable[i] = s->morphAtomizedStringIntoPermanentAtom(hash);
    }

    for (uint32_t i = 0; i < NUM_SMALL_CHARS * NUM_SMALL_CHARS; i++) {
        Latin1Char buffer[] = { FROM_SMALL_CHAR(i >> 6), FROM_SMALL_CHAR(i & 0x3F), '\0' };
        JSFlatString* s = NewInlineString<NoGC>(cx, Latin1Range(buffer, 2));
        if (!s)
            return false;
        HashNumber hash = mozilla::HashString(buffer, 2);
        length2StaticTable[i] = s->morphAtomizedStringIntoPermanentAtom(hash);
    }

    for (uint32_t i = 0; i < INT_STATIC_LIMIT; i++) {
        if (i < 10) {
            intStaticTable[i] = unitStaticTable[i + '0'];
        } else if (i < 100) {
            size_t index = ((size_t)TO_SMALL_CHAR((i / 10) + '0') << 6) +
                TO_SMALL_CHAR((i % 10) + '0');
            intStaticTable[i] = length2StaticTable[index];
        } else {
            Latin1Char buffer[] = { Latin1Char('0' + (i / 100)),
                                    Latin1Char('0' + ((i / 10) % 10)),
                                    Latin1Char('0' + (i % 10)),
                                    '\0' };
            JSFlatString* s = NewInlineString<NoGC>(cx, Latin1Range(buffer, 3));
            if (!s)
                return false;
            HashNumber hash = mozilla::HashString(buffer, 3);
            intStaticTable[i] = s->morphAtomizedStringIntoPermanentAtom(hash);
        }
    }

    return true;
}

void
StaticStrings::trace(JSTracer* trc)
{
    /* These strings never change, so barriers are not needed. */

    for (uint32_t i = 0; i < UNIT_STATIC_LIMIT; i++)
        TraceProcessGlobalRoot(trc, unitStaticTable[i], "unit-static-string");

    for (uint32_t i = 0; i < NUM_SMALL_CHARS * NUM_SMALL_CHARS; i++)
        TraceProcessGlobalRoot(trc, length2StaticTable[i], "length2-static-string");

    /* This may mark some strings more than once, but so be it. */
    for (uint32_t i = 0; i < INT_STATIC_LIMIT; i++)
        TraceProcessGlobalRoot(trc, intStaticTable[i], "int-static-string");
}

template <typename CharT>
/* static */ bool
StaticStrings::isStatic(const CharT* chars, size_t length)
{
    switch (length) {
      case 1: {
        char16_t c = chars[0];
        return c < UNIT_STATIC_LIMIT;
      }
      case 2:
        return fitsInSmallChar(chars[0]) && fitsInSmallChar(chars[1]);
      case 3:
        if ('1' <= chars[0] && chars[0] <= '9' &&
            '0' <= chars[1] && chars[1] <= '9' &&
            '0' <= chars[2] && chars[2] <= '9') {
            int i = (chars[0] - '0') * 100 +
                      (chars[1] - '0') * 10 +
                      (chars[2] - '0');

            return unsigned(i) < INT_STATIC_LIMIT;
        }
        return false;
      default:
        return false;
    }
}

/* static */ bool
StaticStrings::isStatic(JSAtom* atom)
{
    AutoCheckCannotGC nogc;
    return atom->hasLatin1Chars()
           ? isStatic(atom->latin1Chars(nogc), atom->length())
           : isStatic(atom->twoByteChars(nogc), atom->length());
}

bool
AutoStableStringChars::init(JSContext* cx, JSString* s)
{
    RootedLinearString linearString(cx, s->ensureLinear(cx));
    if (!linearString)
        return false;

    MOZ_ASSERT(state_ == Uninitialized);

    // If the chars are inline then we need to copy them since they may be moved
    // by a compacting GC.
    if (baseIsInline(linearString)) {
        return linearString->hasTwoByteChars() ? copyTwoByteChars(cx, linearString)
                                               : copyLatin1Chars(cx, linearString);
    }

    if (linearString->hasLatin1Chars()) {
        state_ = Latin1;
        latin1Chars_ = linearString->rawLatin1Chars();
    } else {
        state_ = TwoByte;
        twoByteChars_ = linearString->rawTwoByteChars();
    }

    s_ = linearString;
    return true;
}

bool
AutoStableStringChars::initTwoByte(JSContext* cx, JSString* s)
{
    RootedLinearString linearString(cx, s->ensureLinear(cx));
    if (!linearString)
        return false;

    MOZ_ASSERT(state_ == Uninitialized);

    if (linearString->hasLatin1Chars())
        return copyAndInflateLatin1Chars(cx, linearString);

    // If the chars are inline then we need to copy them since they may be moved
    // by a compacting GC.
    if (baseIsInline(linearString))
        return copyTwoByteChars(cx, linearString);

    state_ = TwoByte;
    twoByteChars_ = linearString->rawTwoByteChars();
    s_ = linearString;
    return true;
}

bool AutoStableStringChars::baseIsInline(HandleLinearString linearString)
{
    JSString* base = linearString;
    while (base->isDependent())
        base = base->asDependent().base();
    return base->isInline();
}

template <typename T>
T*
AutoStableStringChars::allocOwnChars(JSContext* cx, size_t count)
{
    static_assert(
        InlineCapacity >= sizeof(JS::Latin1Char) * (JSFatInlineString::MAX_LENGTH_LATIN1 + 1) &&
        InlineCapacity >= sizeof(char16_t) * (JSFatInlineString::MAX_LENGTH_TWO_BYTE + 1),
        "InlineCapacity too small to hold fat inline strings");

    static_assert((JSString::MAX_LENGTH & mozilla::tl::MulOverflowMask<sizeof(T)>::value) == 0,
                  "Size calculation can overflow");
    MOZ_ASSERT(count <= (JSString::MAX_LENGTH + 1));
    size_t size = sizeof(T) * count;

    ownChars_.emplace(cx);
    if (!ownChars_->resize(size)) {
        ownChars_.reset();
        return nullptr;
    }

    return reinterpret_cast<T*>(ownChars_->begin());
}

bool
AutoStableStringChars::copyAndInflateLatin1Chars(JSContext* cx, HandleLinearString linearString)
{
    char16_t* chars = allocOwnChars<char16_t>(cx, linearString->length() + 1);
    if (!chars)
        return false;

    CopyAndInflateChars(chars, linearString->rawLatin1Chars(),
                        linearString->length());
    chars[linearString->length()] = 0;

    state_ = TwoByte;
    twoByteChars_ = chars;
    s_ = linearString;
    return true;
}

bool
AutoStableStringChars::copyLatin1Chars(JSContext* cx, HandleLinearString linearString)
{
    size_t length = linearString->length();
    JS::Latin1Char* chars = allocOwnChars<JS::Latin1Char>(cx, length + 1);
    if (!chars)
        return false;

    PodCopy(chars, linearString->rawLatin1Chars(), length);
    chars[length] = 0;

    state_ = Latin1;
    latin1Chars_ = chars;
    s_ = linearString;
    return true;
}

bool
AutoStableStringChars::copyTwoByteChars(JSContext* cx, HandleLinearString linearString)
{
    size_t length = linearString->length();
    char16_t* chars = allocOwnChars<char16_t>(cx, length + 1);
    if (!chars)
        return false;

    PodCopy(chars, linearString->rawTwoByteChars(), length);
    chars[length] = 0;

    state_ = TwoByte;
    twoByteChars_ = chars;
    s_ = linearString;
    return true;
}

JSFlatString*
JSString::ensureFlat(JSContext* cx)
{
    if (isFlat())
        return &asFlat();
    if (isDependent())
        return asDependent().undepend(cx);
    if (isRope())
        return asRope().flatten(cx);
    return asExternal().ensureFlat(cx);
}

JSFlatString*
JSExternalString::ensureFlat(JSContext* cx)
{
    MOZ_ASSERT(hasTwoByteChars());

    size_t n = length();
    char16_t* s = cx->pod_malloc<char16_t>(n + 1);
    if (!s)
        return nullptr;

    // Copy the chars before finalizing the string.
    {
        AutoCheckCannotGC nogc;
        PodCopy(s, nonInlineChars<char16_t>(nogc), n);
        s[n] = '\0';
    }

    // Release the external chars.
    finalize(cx->runtime()->defaultFreeOp());

    // Transform the string into a non-external, flat string.
    setNonInlineChars<char16_t>(s);
    d.u1.flags = FLAT_BIT;

    return &this->asFlat();
}

#ifdef DEBUG
void
JSAtom::dump(FILE* fp)
{
    fprintf(fp, "JSAtom* (%p) = ", (void*) this);
    this->JSString::dump(fp);
}

void
JSAtom::dump()
{
    dump(stderr);
}

void
JSExternalString::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent, "JSExternalString");
    indent += 2;

    fprintf(fp, "%*sfinalizer: ((JSStringFinalizer*) %p)\n", indent, "", externalFinalizer());
    fprintf(fp, "%*sbase: ", indent, "");
    base()->dumpRepresentation(fp, indent);
}
#endif /* DEBUG */

JSLinearString*
js::NewDependentString(JSContext* cx, JSString* baseArg, size_t start, size_t length)
{
    if (length == 0)
        return cx->emptyString();

    JSLinearString* base = baseArg->ensureLinear(cx);
    if (!base)
        return nullptr;

    if (start == 0 && length == base->length())
        return base;

    if (base->hasTwoByteChars()) {
        AutoCheckCannotGC nogc;
        const char16_t* chars = base->twoByteChars(nogc) + start;
        if (JSLinearString* staticStr = cx->staticStrings().lookup(chars, length))
            return staticStr;
    } else {
        AutoCheckCannotGC nogc;
        const Latin1Char* chars = base->latin1Chars(nogc) + start;
        if (JSLinearString* staticStr = cx->staticStrings().lookup(chars, length))
            return staticStr;
    }

    return JSDependentString::new_(cx, base, start, length);
}

static bool
CanStoreCharsAsLatin1(const char16_t* s, size_t length)
{
    for (const char16_t* end = s + length; s < end; ++s) {
        if (*s > JSString::MAX_LATIN1_CHAR)
            return false;
    }

    return true;
}

static bool
CanStoreCharsAsLatin1(const Latin1Char* s, size_t length)
{
    MOZ_CRASH("Shouldn't be called for Latin1 chars");
}

template <AllowGC allowGC>
static MOZ_ALWAYS_INLINE JSInlineString*
NewInlineStringDeflated(ExclusiveContext* cx, mozilla::Range<const char16_t> chars)
{
    size_t len = chars.length();
    Latin1Char* storage;
    JSInlineString* str = AllocateInlineString<allowGC>(cx, len, &storage);
    if (!str)
        return nullptr;

    for (size_t i = 0; i < len; i++) {
        MOZ_ASSERT(chars[i] <= JSString::MAX_LATIN1_CHAR);
        storage[i] = Latin1Char(chars[i]);
    }
    storage[len] = '\0';
    return str;
}

template <typename CharT>
static MOZ_ALWAYS_INLINE JSFlatString*
TryEmptyOrStaticString(ExclusiveContext* cx, const CharT* chars, size_t n)
{
    // Measurements on popular websites indicate empty strings are pretty common
    // and most strings with length 1 or 2 are in the StaticStrings table. For
    // length 3 strings that's only about 1%, so we check n <= 2.
    if (n <= 2) {
        if (n == 0)
            return cx->emptyString();

        if (JSFlatString* str = cx->staticStrings().lookup(chars, n))
            return str;
    }

    return nullptr;
}

template <AllowGC allowGC>
static JSFlatString*
NewStringDeflated(ExclusiveContext* cx, const char16_t* s, size_t n)
{
    if (JSFlatString* str = TryEmptyOrStaticString(cx, s, n))
        return str;

    if (JSInlineString::lengthFits<Latin1Char>(n))
        return NewInlineStringDeflated<allowGC>(cx, mozilla::Range<const char16_t>(s, n));

    ScopedJSFreePtr<Latin1Char> news(cx->pod_malloc<Latin1Char>(n + 1));
    if (!news)
        return nullptr;

    for (size_t i = 0; i < n; i++) {
        MOZ_ASSERT(s[i] <= JSString::MAX_LATIN1_CHAR);
        news.get()[i] = Latin1Char(s[i]);
    }
    news[n] = '\0';

    JSFlatString* str = JSFlatString::new_<allowGC>(cx, news.get(), n);
    if (!str)
        return nullptr;

    news.forget();
    return str;
}

template <AllowGC allowGC>
static JSFlatString*
NewStringDeflated(ExclusiveContext* cx, const Latin1Char* s, size_t n)
{
    MOZ_CRASH("Shouldn't be called for Latin1 chars");
}

template <AllowGC allowGC, typename CharT>
JSFlatString*
js::NewStringDontDeflate(ExclusiveContext* cx, CharT* chars, size_t length)
{
    if (JSFlatString* str = TryEmptyOrStaticString(cx, chars, length)) {
        // Free |chars| because we're taking possession of it, but it's no
        // longer needed because we use the static string instead.
        js_free(chars);
        return str;
    }

    if (JSInlineString::lengthFits<CharT>(length)) {
        JSInlineString* str =
            NewInlineString<allowGC>(cx, mozilla::Range<const CharT>(chars, length));
        if (!str)
            return nullptr;

        js_free(chars);
        return str;
    }

    return JSFlatString::new_<allowGC>(cx, chars, length);
}

template JSFlatString*
js::NewStringDontDeflate<CanGC>(ExclusiveContext* cx, char16_t* chars, size_t length);

template JSFlatString*
js::NewStringDontDeflate<NoGC>(ExclusiveContext* cx, char16_t* chars, size_t length);

template JSFlatString*
js::NewStringDontDeflate<CanGC>(ExclusiveContext* cx, Latin1Char* chars, size_t length);

template JSFlatString*
js::NewStringDontDeflate<NoGC>(ExclusiveContext* cx, Latin1Char* chars, size_t length);

template <AllowGC allowGC, typename CharT>
JSFlatString*
js::NewString(ExclusiveContext* cx, CharT* chars, size_t length)
{
    if (IsSame<CharT, char16_t>::value && CanStoreCharsAsLatin1(chars, length)) {
        JSFlatString* s = NewStringDeflated<allowGC>(cx, chars, length);
        if (!s)
            return nullptr;

        // Free |chars| because we're taking possession of it but not using it.
        js_free(chars);
        return s;
    }

    return NewStringDontDeflate<allowGC>(cx, chars, length);
}

template JSFlatString*
js::NewString<CanGC>(ExclusiveContext* cx, char16_t* chars, size_t length);

template JSFlatString*
js::NewString<NoGC>(ExclusiveContext* cx, char16_t* chars, size_t length);

template JSFlatString*
js::NewString<CanGC>(ExclusiveContext* cx, Latin1Char* chars, size_t length);

template JSFlatString*
js::NewString<NoGC>(ExclusiveContext* cx, Latin1Char* chars, size_t length);

namespace js {

template <AllowGC allowGC, typename CharT>
JSFlatString*
NewStringCopyNDontDeflate(ExclusiveContext* cx, const CharT* s, size_t n)
{
    if (JSFlatString* str = TryEmptyOrStaticString(cx, s, n))
        return str;

    if (JSInlineString::lengthFits<CharT>(n))
        return NewInlineString<allowGC>(cx, mozilla::Range<const CharT>(s, n));

    ScopedJSFreePtr<CharT> news(cx->pod_malloc<CharT>(n + 1));
    if (!news) {
        if (!allowGC)
            cx->recoverFromOutOfMemory();
        return nullptr;
    }

    PodCopy(news.get(), s, n);
    news[n] = 0;

    JSFlatString* str = JSFlatString::new_<allowGC>(cx, news.get(), n);
    if (!str)
        return nullptr;

    news.forget();
    return str;
}

template JSFlatString*
NewStringCopyNDontDeflate<CanGC>(ExclusiveContext* cx, const char16_t* s, size_t n);

template JSFlatString*
NewStringCopyNDontDeflate<NoGC>(ExclusiveContext* cx, const char16_t* s, size_t n);

template JSFlatString*
NewStringCopyNDontDeflate<CanGC>(ExclusiveContext* cx, const Latin1Char* s, size_t n);

template JSFlatString*
NewStringCopyNDontDeflate<NoGC>(ExclusiveContext* cx, const Latin1Char* s, size_t n);

JSFlatString*
NewLatin1StringZ(ExclusiveContext* cx, UniqueChars chars)
{
    JSFlatString* str = NewString<CanGC>(cx, (Latin1Char*)chars.get(), strlen(chars.get()));
    if (!str)
        return nullptr;

    mozilla::Unused << chars.release();
    return str;
}

template <AllowGC allowGC, typename CharT>
JSFlatString*
NewStringCopyN(ExclusiveContext* cx, const CharT* s, size_t n)
{
    if (IsSame<CharT, char16_t>::value && CanStoreCharsAsLatin1(s, n))
        return NewStringDeflated<allowGC>(cx, s, n);

    return NewStringCopyNDontDeflate<allowGC>(cx, s, n);
}

template JSFlatString*
NewStringCopyN<CanGC>(ExclusiveContext* cx, const char16_t* s, size_t n);

template JSFlatString*
NewStringCopyN<NoGC>(ExclusiveContext* cx, const char16_t* s, size_t n);

template JSFlatString*
NewStringCopyN<CanGC>(ExclusiveContext* cx, const Latin1Char* s, size_t n);

template JSFlatString*
NewStringCopyN<NoGC>(ExclusiveContext* cx, const Latin1Char* s, size_t n);

template <js::AllowGC allowGC>
JSFlatString*
NewStringCopyUTF8N(JSContext* cx, const JS::UTF8Chars utf8)
{
    JS::SmallestEncoding encoding = JS::FindSmallestEncoding(utf8);
    if (encoding == JS::SmallestEncoding::ASCII)
        return NewStringCopyN<allowGC>(cx, utf8.begin().get(), utf8.length());

    size_t length;
    if (encoding == JS::SmallestEncoding::Latin1) {
        Latin1Char* latin1 = UTF8CharsToNewLatin1CharsZ(cx, utf8, &length).get();
        if (!latin1)
            return nullptr;

        JSFlatString* result = NewString<allowGC>(cx, latin1, length);
        if (!result)
            js_free((void*)latin1);
        return result;
    }

    MOZ_ASSERT(encoding == JS::SmallestEncoding::UTF16);

    char16_t* utf16 = UTF8CharsToNewTwoByteCharsZ(cx, utf8, &length).get();
    if (!utf16)
        return nullptr;

    JSFlatString* result = NewString<allowGC>(cx, utf16, length);
    if (!result)
        js_free((void*)utf16);
    return result;
}

template JSFlatString*
NewStringCopyUTF8N<CanGC>(JSContext* cx, const JS::UTF8Chars utf8);

} /* namespace js */

#ifdef DEBUG
void
JSExtensibleString::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent, "JSExtensibleString");
    indent += 2;

    fprintf(fp, "%*scapacity: %" PRIuSIZE "\n", indent, "", capacity());
    dumpRepresentationChars(fp, indent);
}

void
JSInlineString::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent,
                             isFatInline() ? "JSFatInlineString" : "JSThinInlineString");
    indent += 2;

    dumpRepresentationChars(fp, indent);
}

void
JSFlatString::dumpRepresentation(FILE* fp, int indent) const
{
    dumpRepresentationHeader(fp, indent, "JSFlatString");
    indent += 2;

    dumpRepresentationChars(fp, indent);
}
#endif
