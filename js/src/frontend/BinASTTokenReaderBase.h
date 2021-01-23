/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef frontend_BinASTTokenReaderBase_h
#define frontend_BinASTTokenReaderBase_h

#include "mozilla/Variant.h"

#include <string.h>

#include "frontend/BinASTToken.h"
#include "frontend/ErrorReporter.h"
#include "frontend/TokenStream.h"

#include "js/Result.h"
#include "js/TypeDecls.h"

namespace js {
namespace frontend {

// A constant used by tokenizers to represent a null float.
extern const uint64_t NULL_FLOAT_REPRESENTATION;

class MOZ_STACK_CLASS BinASTTokenReaderBase {
 public:
  template <typename T>
  using ErrorResult = mozilla::GenericErrorResult<T>;

  // Part of variant `Context`
  // Reading the root of the tree, before we enter any tagged tuple.
  struct RootContext {};

  // Part of variant `Context`
  // Reading an element from a list.
  struct ListContext {
    const BinASTInterfaceAndField position_;
    const BinASTList content_;
    ListContext(const BinASTInterfaceAndField position,
                const BinASTList content)
        : position_(position), content_(content) {}
  };

  // Part of variant `Context`
  // Reading a field from an interface.
  struct FieldContext {
    const BinASTInterfaceAndField position_;
    explicit FieldContext(const BinASTInterfaceAndField position)
        : position_(position) {}
  };

  // The context in which we read a token.
  using FieldOrRootContext = mozilla::Variant<FieldContext, RootContext>;
  using FieldOrListContext = mozilla::Variant<FieldContext, ListContext>;

#ifdef DEBUG
  // Utility matcher, used to print a `Context` during debugging.
  struct ContextPrinter {
    static void print(const char* text, const FieldOrRootContext& context) {
      fprintf(stderr, "%s ", text);
      context.match(ContextPrinter());
      fprintf(stderr, "\n");
    }
    static void print(const char* text, const FieldOrListContext& context) {
      fprintf(stderr, "%s ", text);
      context.match(ContextPrinter());
      fprintf(stderr, "\n");
    }

    void operator()(const RootContext&) { fprintf(stderr, "<Root context>"); }
    void operator()(const ListContext& context) {
      fprintf(stderr, "<List context>: %s => %s",
              describeBinASTInterfaceAndField(context.position_),
              describeBinASTList(context.content_));
    }
    void operator()(const FieldContext& context) {
      fprintf(stderr, "<Field context>: %s",
              describeBinASTInterfaceAndField(context.position_));
    }
  };
#endif  // DEBUG

  // The information needed to skip a subtree.
  class SkippableSubTree {
   public:
    SkippableSubTree(const size_t startOffset, const size_t length)
        : startOffset_(startOffset), length_(length) {}

    // The position in the source buffer at which the subtree starts.
    //
    // `SkippableSubTree` does *not* attempt to keep anything alive.
    size_t startOffset() const { return startOffset_; }

    // The length of the subtree.
    size_t length() const { return length_; }

   private:
    const size_t startOffset_;
    const size_t length_;
  };

  /**
   * Return the position of the latest token.
   */
  TokenPos pos();
  TokenPos pos(size_t startOffset);
  size_t offset() const { return current_ - start_; }

  // Set the tokenizer's cursor in the file. Use with caution.
  void seek(size_t offset);

  /**
   * Poison this tokenizer.
   */
  void poison();

  /**
   * Raise an error.
   *
   * Once `raiseError` has been called, the tokenizer is poisoned.
   */
  MOZ_MUST_USE ErrorResult<JS::Error&> raiseError(const char* description);
  MOZ_MUST_USE ErrorResult<JS::Error&> raiseOOM();
  MOZ_MUST_USE ErrorResult<JS::Error&> raiseInvalidNumberOfFields(
      const BinASTKind kind, const uint32_t expected, const uint32_t got);
  MOZ_MUST_USE ErrorResult<JS::Error&> raiseInvalidField(
      const char* kind, const BinASTField field);

 protected:
  BinASTTokenReaderBase(JSContext* cx, ErrorReporter* er, const uint8_t* start,
                        const size_t length)
      : cx_(cx),
        errorReporter_(er),
        poisoned_(false),
        start_(start),
        current_(start),
        stop_(start + length),
        latestKnownGoodPos_(0) {
    MOZ_ASSERT(errorReporter_);
  }

  /**
   * Read a single byte.
   */
  MOZ_MUST_USE JS::Result<uint8_t> readByte();

  /**
   * Read several bytes.
   *
   * If there is not enough data, or if the tokenizer has previously been
   * poisoned, return an error.
   */
  MOZ_MUST_USE JS::Result<Ok> readBuf(uint8_t* bytes, uint32_t len);

  /**
   * Read a sequence of chars, ensuring that they match an expected
   * sequence of chars.
   *
   * @param value The sequence of chars to expect, NUL-terminated.
   */
  template <size_t N>
  MOZ_MUST_USE JS::Result<Ok> readConst(const char (&value)[N]) {
    updateLatestKnownGood();
    if (MOZ_UNLIKELY(!matchConst(value, false))) {
      return raiseError("Could not find expected literal");
    }
    return Ok();
  }

  /**
   * Read a sequence of chars, consuming the bytes only if they match an
   * expected sequence of chars.
   *
   * @param value The sequence of chars to expect, NUL-terminated.
   * @param expectNul If true, expect NUL in the stream, otherwise don't.
   * @return true if `value` represents the next few chars in the
   * internal buffer, false otherwise. If `true`, the chars are consumed,
   * otherwise there is no side-effect.
   */
  template <size_t N>
  MOZ_MUST_USE bool matchConst(const char (&value)[N], bool expectNul) {
    MOZ_ASSERT(N > 0);
    MOZ_ASSERT(value[N - 1] == 0);
    MOZ_ASSERT(!hasRaisedError());

    if (MOZ_UNLIKELY(current_ + N - 1 > stop_)) {
      return false;
    }

#ifndef FUZZING
    // Perform lookup, without side-effects.
    if (memcmp(current_, value, N + (expectNul ? 0 : -1) /*implicit NUL*/) !=
        0) {
      return false;
    }
#endif

    // Looks like we have a match. Now perform side-effects
    current_ += N + (expectNul ? 0 : -1);
    updateLatestKnownGood();
    return true;
  }

  void updateLatestKnownGood();

  bool hasRaisedError() const;

  JSContext* cx_;

  ErrorReporter* errorReporter_;

  // `true` if we have encountered an error. Errors are non recoverable.
  // Attempting to read from a poisoned tokenizer will cause assertion errors.
  bool poisoned_;

  // The first byte of the buffer. Not owned.
  const uint8_t* start_;

  // The current position.
  const uint8_t* current_;

  // The last+1 byte of the buffer.
  const uint8_t* stop_;

  // Latest known good position. Used for error reporting.
  size_t latestKnownGoodPos_;

 private:
  BinASTTokenReaderBase(const BinASTTokenReaderBase&) = delete;
  BinASTTokenReaderBase(BinASTTokenReaderBase&&) = delete;
  BinASTTokenReaderBase& operator=(BinASTTokenReaderBase&) = delete;
};

}  // namespace frontend
}  // namespace js

#endif  // frontend_BinASTTokenReaderBase_h
