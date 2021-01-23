/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef frontend_BinASTTokenReaderMultipart_h
#define frontend_BinASTTokenReaderMultipart_h

#include "mozilla/Maybe.h"

#include "frontend/BinASTRuntimeSupport.h"
#include "frontend/BinASTToken.h"
#include "frontend/BinASTTokenReaderBase.h"

#include "js/Result.h"

namespace js {
namespace frontend {

/**
 * A token reader implementing the "multipart" serialization format for BinAST.
 *
 * This serialization format, which is also supported by the reference
 * implementation of the BinAST compression suite, is designed to be
 * space- and time-efficient.
 *
 * As other token readers for the BinAST:
 *
 * - the reader does not support error recovery;
 * - the reader does not support lookahead or pushback.
 */
class MOZ_STACK_CLASS BinASTTokenReaderMultipart
    : public BinASTTokenReaderBase {
 public:
  class AutoList;
  class AutoTaggedTuple;

  using CharSlice = BinaryASTSupport::CharSlice;
  using RootContext = BinASTTokenReaderBase::RootContext;
  using ListContext = BinASTTokenReaderBase::ListContext;
  using FieldContext = BinASTTokenReaderBase::FieldContext;
  using FieldOrRootContext = BinASTTokenReaderBase::FieldOrRootContext;
  using FieldOrListContext = BinASTTokenReaderBase::FieldOrListContext;
  using Chars = CharSlice;

 public:
  /**
   * Construct a token reader.
   *
   * Does NOT copy the buffer.
   */
  BinASTTokenReaderMultipart(JSContext* cx, ErrorReporter* er,
                             const uint8_t* start, const size_t length);

  /**
   * Construct a token reader.
   *
   * Does NOT copy the buffer.
   */
  BinASTTokenReaderMultipart(JSContext* cx, ErrorReporter* er,
                             const Vector<uint8_t>& chars);

  ~BinASTTokenReaderMultipart();

  /**
   * Read the header of the file.
   */
  MOZ_MUST_USE JS::Result<Ok> readHeader();

  /**
   * Read the footer of the tree, that multipart format doesn't have.
   */
  MOZ_MUST_USE JS::Result<Ok> readTreeFooter() { return Ok(); }

  // --- Primitive values.
  //
  // Note that the underlying format allows for a `null` value for primitive
  // values.
  //
  // Reading will return an error either in case of I/O error or in case of
  // a format problem. Reading if an exception in pending is an error and
  // will cause assertion failures. Do NOT attempt to read once an exception
  // has been cleared: the token reader does NOT support recovery, by design.

  /**
   * Read a single `true | false` value.
   */
  MOZ_MUST_USE JS::Result<bool> readBool(const FieldContext&);

  /**
   * Read a single `number` value.
   */
  MOZ_MUST_USE JS::Result<double> readDouble(const FieldContext&);

  /**
   * Read a single `string | null` value.
   *
   * Fails if that string is not valid UTF-8.
   */
  MOZ_MUST_USE JS::Result<JSAtom*> readMaybeAtom(const FieldContext&);
  MOZ_MUST_USE JS::Result<JSAtom*> readAtom(const FieldContext&);

  /**
   * Read a single IdentifierName value.
   */
  MOZ_MUST_USE JS::Result<JSAtom*> readMaybeIdentifierName(const FieldContext&);
  MOZ_MUST_USE JS::Result<JSAtom*> readIdentifierName(const FieldContext&);

  /**
   * Read a single PropertyKey value.
   */
  MOZ_MUST_USE JS::Result<JSAtom*> readPropertyKey(const FieldContext&);

  /**
   * Read a single `string | null` value.
   *
   * MAY check if that string is not valid UTF-8.
   */
  MOZ_MUST_USE JS::Result<Ok> readChars(Chars&, const FieldContext&);

  /**
   * Read a single `BinASTVariant | null` value.
   */
 private:
  MOZ_MUST_USE JS::Result<BinASTVariant> readVariant();

 public:
  MOZ_MUST_USE JS::Result<BinASTVariant> readVariant(
      const ListContext& context) {
    return readVariant();
  }
  MOZ_MUST_USE JS::Result<BinASTVariant> readVariant(
      const FieldContext& context) {
    return readVariant();
  }

  /**
   * Read over a single `[Skippable]` subtree value.
   *
   * This does *not* attempt to parse the subtree itself. Rather, the
   * returned `SkippableSubTree` contains the necessary information
   * to parse/tokenize the subtree at a later stage
   */
  MOZ_MUST_USE JS::Result<SkippableSubTree> readSkippableSubTree(
      const FieldContext&);

  /**
   * Register lazy script for later modification.
   * Not used in multipart format.
   */
  MOZ_MUST_USE JS::Result<Ok> registerLazyScript(FunctionBox* lazy) {
    return Ok();
  }

  // --- Composite values.
  //
  // The underlying format does NOT allows for a `null` composite value.
  //
  // Reading will return an error either in case of I/O error or in case of
  // a format problem. Reading from a poisoned tokenizer is an error and
  // will cause assertion failures.

  /**
   * Start reading a list.
   *
   * @param length (OUT) The number of elements in the list.
   * @param guard (OUT) A guard, ensuring that we read the list correctly.
   *
   * The `guard` is dedicated to ensuring that reading the list has consumed
   * exactly all the bytes from that list. The `guard` MUST therefore be
   * destroyed at the point where the caller has reached the end of the list.
   * If the caller has consumed too few/too many bytes, this will be reported
   * in the call go `guard.done()`.
   */
  MOZ_MUST_USE JS::Result<Ok> enterList(uint32_t& length, const ListContext&);

  /**
   * Start reading a tagged tuple.
   *
   * @param tag (OUT) The tag of the tuple.
   * @param fields Ignored, provided for API compatibility.
   * @param guard (OUT) A guard, ensuring that we read the tagged tuple
   * correctly.
   *
   * The `guard` is dedicated to ensuring that reading the list has consumed
   * exactly all the bytes from that tuple. The `guard` MUST therefore be
   * destroyed at the point where the caller has reached the end of the tuple.
   * If the caller has consumed too few/too many bytes, this will be reported
   * in the call go `guard.done()`.
   *
   * @return out If the header of the tuple is invalid.
   */
  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag);

  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag,
                                               const FieldOrRootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag,
                                               const FieldOrListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag,
                                               const RootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag,
                                               const ListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterTaggedTuple(BinASTKind& tag,
                                               const FieldContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterInterface(BinASTKind& tag,
                                             const FieldOrRootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterInterface(BinASTKind& tag,
                                             const FieldOrListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterInterface(BinASTKind& tag,
                                             const RootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterInterface(BinASTKind& tag,
                                             const ListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterInterface(BinASTKind& tag,
                                             const FieldContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterSum(BinASTKind& tag,
                                       const FieldOrRootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterSum(BinASTKind& tag,
                                       const FieldOrListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterSum(BinASTKind& tag, const RootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterSum(BinASTKind& tag, const ListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterSum(BinASTKind& tag, const FieldContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterOptionalInterface(
      BinASTKind& tag, const FieldOrRootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterOptionalInterface(
      BinASTKind& tag, const FieldOrListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterOptionalInterface(BinASTKind& tag,
                                                     const RootContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterOptionalInterface(BinASTKind& tag,
                                                     const ListContext&) {
    return enterTaggedTuple(tag);
  }
  MOZ_MUST_USE JS::Result<Ok> enterOptionalInterface(BinASTKind& tag,
                                                     const FieldContext&) {
    return enterTaggedTuple(tag);
  }

  /**
   * Read a single unsigned long.
   */
  MOZ_MUST_USE JS::Result<uint32_t> readUnsignedLong(const FieldContext&) {
    return readInternalUint32();
  }

 private:
  /**
   * Read a single uint32_t.
   */
  MOZ_MUST_USE JS::Result<uint32_t> readInternalUint32();

 private:
  // A mapping string index => BinASTVariant as extracted from the [STRINGS]
  // section of the file. Populated lazily.
  js::HashMap<uint32_t, BinASTVariant, DefaultHasher<uint32_t>,
              SystemAllocPolicy>
      variantsTable_;

  enum class MetadataOwnership { Owned, Unowned };
  MetadataOwnership metadataOwned_ = MetadataOwnership::Owned;
  BinASTSourceMetadataMultipart* metadata_;

  const uint8_t* posBeforeTree_;

  BinASTTokenReaderMultipart(const BinASTTokenReaderMultipart&) = delete;
  BinASTTokenReaderMultipart(BinASTTokenReaderMultipart&&) = delete;
  BinASTTokenReaderMultipart& operator=(BinASTTokenReaderMultipart&) = delete;

 public:
  void traceMetadata(JSTracer* trc);
  BinASTSourceMetadata* takeMetadata();
  MOZ_MUST_USE JS::Result<Ok> initFromScriptSource(ScriptSource* scriptSource);

 public:
  // The following classes are used whenever we encounter a tuple/tagged
  // tuple/list to make sure that:
  //
  // - if the construct "knows" its byte length, we have exactly consumed all
  //   the bytes (otherwise, this means that the file is corrupted, perhaps on
  //   purpose, so we need to reject the stream);
  // - if the construct has a footer, once we are done reading it, we have
  //   reached the footer (this is to aid with debugging).
  //
  // In either case, the caller MUST call method `done()` of the guard once
  // it is done reading the tuple/tagged tuple/list, to report any pending
  // error.

  // Base class used by other Auto* classes.
  class MOZ_STACK_CLASS AutoBase {
   protected:
    explicit AutoBase(BinASTTokenReaderMultipart& reader);
    ~AutoBase();

    friend BinASTTokenReaderMultipart;

   public:
    void init();

   protected:
    // Set to `true` if `init()` has been called. Reset to `false` once
    // all conditions have been checked.
    bool initialized_;
    BinASTTokenReaderMultipart& reader_;
  };

  // Guard class used to ensure that `enterList` is used properly.
  class MOZ_STACK_CLASS AutoList : public AutoBase {
   public:
    explicit AutoList(BinASTTokenReaderMultipart& reader);

    // Check that we have properly read to the end of the list.
    MOZ_MUST_USE JS::Result<Ok> done();

   protected:
    friend BinASTTokenReaderMultipart;
  };

  // Guard class used to ensure that `enterTaggedTuple` is used properly.
  class MOZ_STACK_CLASS AutoTaggedTuple : public AutoBase {
   public:
    explicit AutoTaggedTuple(BinASTTokenReaderMultipart& reader);

    // Check that we have properly read to the end of the tuple.
    MOZ_MUST_USE JS::Result<Ok> done();
  };

  // Compare a `Chars` and a string literal (ONLY a string literal).
  template <size_t N>
  static bool equals(const Chars& left, const char (&right)[N]) {
    MOZ_ASSERT(N > 0);
    MOZ_ASSERT(right[N - 1] == 0);
    if (left.byteLen_ + 1 /* implicit NUL */ != N) {
      return false;
    }

    if (!std::equal(left.start_, left.start_ + left.byteLen_, right)) {
      return false;
    }

    return true;
  }
};

}  // namespace frontend
}  // namespace js

#endif  // frontend_BinASTTokenReaderMultipart_h
