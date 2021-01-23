/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef vm_SharedStencil_h
#define vm_SharedStencil_h

#include "mozilla/Span.h"  // mozilla::Span

#include <stddef.h>  // size_t
#include <stdint.h>  // uint32_t

#include "frontend/SourceNotes.h"  // js::SrcNote
#include "js/TypeDecls.h"          // JSContext,jsbytecode
#include "js/UniquePtr.h"          // js::UniquePtr
#include "util/TrailingArray.h"    // js::TrailingArray
#include "vm/StencilEnums.h"  // js::{TryNoteKind,ImmutableScriptFlagsEnum,MutableScriptFlagsEnum}

//
// Data structures shared between Stencil and the VM.
//

namespace js {

/*
 * Exception handling record.
 */
struct TryNote {
  uint32_t kind_;      /* one of TryNoteKind */
  uint32_t stackDepth; /* stack depth upon exception handler entry */
  uint32_t start;      /* start of the try statement or loop relative
                          to script->code() */
  uint32_t length;     /* length of the try statement or loop */

  TryNote(uint32_t kind, uint32_t stackDepth, uint32_t start, uint32_t length)
      : kind_(kind), stackDepth(stackDepth), start(start), length(length) {}

  TryNote() = default;

  TryNoteKind kind() const { return TryNoteKind(kind_); }

  bool isLoop() const {
    switch (kind()) {
      case TryNoteKind::Loop:
      case TryNoteKind::ForIn:
      case TryNoteKind::ForOf:
        return true;
      case TryNoteKind::Catch:
      case TryNoteKind::Finally:
      case TryNoteKind::ForOfIterClose:
      case TryNoteKind::Destructuring:
        return false;
    }
    MOZ_CRASH("Unexpected try note kind");
  }
};

// A block scope has a range in bytecode: it is entered at some offset, and left
// at some later offset.  Scopes can be nested.  Given an offset, the
// ScopeNote containing that offset whose with the highest start value
// indicates the block scope.  The block scope list is sorted by increasing
// start value.
//
// It is possible to leave a scope nonlocally, for example via a "break"
// statement, so there may be short bytecode ranges in a block scope in which we
// are popping the block chain in preparation for a goto.  These exits are also
// nested with respect to outer scopes.  The scopes in these exits are indicated
// by the "index" field, just like any other block.  If a nonlocal exit pops the
// last block scope, the index will be NoScopeIndex.
//
struct ScopeNote {
  // Sentinel index for no Scope.
  static const uint32_t NoScopeIndex = UINT32_MAX;

  // Sentinel index for no ScopeNote.
  static const uint32_t NoScopeNoteIndex = UINT32_MAX;

  // Index of the js::Scope in the script's gcthings array, or NoScopeIndex if
  // there is no block scope in this range.
  uint32_t index = 0;

  // Bytecode offset at which this scope starts relative to script->code().
  uint32_t start = 0;

  // Length of bytecode span this scope covers.
  uint32_t length = 0;

  // Index of parent block scope in notes, or NoScopeNote.
  uint32_t parent = 0;
};

// These are wrapper types around the flag enums to provide a more appropriate
// abstraction of the bitfields.
template <typename EnumType>
class ScriptFlagBase {
 protected:
  // Stored as a uint32_t to make access more predictable from
  // JIT code.
  uint32_t flags_ = 0;

 public:
  ScriptFlagBase() = default;
  explicit ScriptFlagBase(uint32_t rawFlags) : flags_(rawFlags) {}

  MOZ_MUST_USE bool hasFlag(EnumType flag) const {
    return flags_ & static_cast<uint32_t>(flag);
  }
  void setFlag(EnumType flag) { flags_ |= static_cast<uint32_t>(flag); }
  void clearFlag(EnumType flag) { flags_ &= ~static_cast<uint32_t>(flag); }
  void setFlag(EnumType flag, bool b) {
    if (b) {
      setFlag(flag);
    } else {
      clearFlag(flag);
    }
  }

  operator uint32_t() const { return flags_; }

  ScriptFlagBase& operator|=(const uint32_t rhs) {
    flags_ |= rhs;
    return *this;
  }
};

class ImmutableScriptFlags : public ScriptFlagBase<ImmutableScriptFlagsEnum> {
 public:
  using ScriptFlagBase<ImmutableScriptFlagsEnum>::ScriptFlagBase;

  void operator=(uint32_t flag) { flags_ = flag; }
};

class MutableScriptFlags : public ScriptFlagBase<MutableScriptFlagsEnum> {
 public:
  MutableScriptFlags() = default;

  MutableScriptFlags& operator&=(const uint32_t rhs) {
    flags_ &= rhs;
    return *this;
  }
};

// [SMDOC] JSScript data layout (immutable)
//
// ImmutableScriptData stores variable-length script data that may be shared
// between scripts with the same bytecode, even across different GC Zones.
// Abstractly this structure consists of multiple (optional) arrays that are
// exposed as mozilla::Span<T>. These arrays exist in a single heap allocation.
//
// Under the hood, ImmutableScriptData is a fixed-size header class followed
// the various array bodies interleaved with metadata to compactly encode the
// bounds. These arrays have varying requirements for alignment, performance,
// and jit-friendliness which leads to the complex indexing system below.
//
// Note: The '----' separators are for readability only.
//
// ----
//   <ImmutableScriptData itself>
// ----
//   (REQUIRED) Flags structure
//   (REQUIRED) Array of jsbytecode constituting code()
//   (REQUIRED) Array of SrcNote constituting notes()
// ----
//   (OPTIONAL) Array of uint32_t optional-offsets
//  optArrayOffset:
// ----
//  L0:
//   (OPTIONAL) Array of uint32_t constituting resumeOffsets()
//  L1:
//   (OPTIONAL) Array of ScopeNote constituting scopeNotes()
//  L2:
//   (OPTIONAL) Array of TryNote constituting tryNotes()
//  L3:
// ----
//
// NOTE: The notes() array must have been null-padded such that
//       flags/code/notes together have uint32_t alignment.
//
// The labels shown are recorded as byte-offsets relative to 'this'. This is to
// reduce memory as well as make ImmutableScriptData easier to share across
// processes.
//
// The L0/L1/L2/L3 labels indicate the start and end of the optional arrays.
// Some of these labels may refer to the same location if the array between
// them is empty. Each unique label position has an offset stored in the
// optional-offsets table. Note that we also avoid entries for labels that
// match 'optArrayOffset'. This saves memory when arrays are empty.
//
// The flags() data indicates (for each optional array) which entry from the
// optional-offsets table marks the *end* of array. The array starts where the
// previous array ends (with the first array beginning at 'optArrayOffset').
// The optional-offset table is addressed at negative indices from
// 'optArrayOffset'.
//
// In general, the length of each array is computed from subtracting the start
// offset of the array from the start offset of the subsequent array. The
// notable exception is that bytecode length is stored explicitly.
class alignas(uint32_t) ImmutableScriptData final : public TrailingArray {
 private:
  Offset optArrayOffset_ = 0;

  // Length of bytecode
  uint32_t codeLength_ = 0;

 public:
  // Offset of main entry point from code, after predef'ing prologue.
  uint32_t mainOffset = 0;

  // Fixed frame slots.
  uint32_t nfixed = 0;

  // Slots plus maximum stack depth.
  uint32_t nslots = 0;

  // Index into the gcthings array of the body scope.
  uint32_t bodyScopeIndex = 0;

  // Number of IC entries to allocate in JitScript for Baseline ICs.
  uint32_t numICEntries = 0;

  // ES6 function length.
  uint16_t funLength = 0;

  // Number of type sets used in this script for dynamic type monitoring.
  uint16_t numBytecodeTypeSets = 0;

  // NOTE: The raw bytes of this structure are used for hashing so use explicit
  // padding values as needed for predicatable results across compilers.

 private:
  struct Flags {
    uint8_t resumeOffsetsEndIndex : 2;
    uint8_t scopeNotesEndIndex : 2;
    uint8_t tryNotesEndIndex : 2;
    uint8_t _unused : 2;
  };
  static_assert(sizeof(Flags) == sizeof(uint8_t),
                "Structure packing is broken");

  // Offsets (in bytes) from 'this' to each component array. The delta between
  // each offset and the next offset is the size of each array and is defined
  // even if an array is empty.
  Offset flagOffset() const { return offsetOfCode() - sizeof(Flags); }
  Offset codeOffset() const { return offsetOfCode(); }
  Offset noteOffset() const { return offsetOfCode() + codeLength_; }
  Offset optionalOffsetsOffset() const {
    // Determine the location to beginning of optional-offsets array by looking
    // at index for try-notes.
    //
    //   optionalOffsetsOffset():
    //     (OPTIONAL) tryNotesEndOffset
    //     (OPTIONAL) scopeNotesEndOffset
    //     (OPTIONAL) resumeOffsetsEndOffset
    //   optArrayOffset_:
    //     ....
    unsigned numOffsets = flags().tryNotesEndIndex;
    MOZ_ASSERT(numOffsets >= flags().scopeNotesEndIndex);
    MOZ_ASSERT(numOffsets >= flags().resumeOffsetsEndIndex);

    return optArrayOffset_ - (numOffsets * sizeof(Offset));
  }
  Offset resumeOffsetsOffset() const { return optArrayOffset_; }
  Offset scopeNotesOffset() const {
    return getOptionalOffset(flags().resumeOffsetsEndIndex);
  }
  Offset tryNotesOffset() const {
    return getOptionalOffset(flags().scopeNotesEndIndex);
  }
  Offset endOffset() const {
    return getOptionalOffset(flags().tryNotesEndIndex);
  }

  void initOptionalArrays(Offset* cursor, uint32_t numResumeOffsets,
                          uint32_t numScopeNotes, uint32_t numTryNotes);

  // Initialize to GC-safe state
  ImmutableScriptData(uint32_t codeLength, uint32_t noteLength,
                      uint32_t numResumeOffsets, uint32_t numScopeNotes,
                      uint32_t numTryNotes);

  void setOptionalOffset(int index, Offset offset) {
    MOZ_ASSERT(index > 0);
    MOZ_ASSERT(offset != optArrayOffset_, "Do not store implicit offset");
    offsetToPointer<Offset>(optArrayOffset_)[-index] = offset;
  }
  Offset getOptionalOffset(int index) const {
    // The index 0 represents (implicitly) the offset 'optArrayOffset_'.
    if (index == 0) {
      return optArrayOffset_;
    }

    ImmutableScriptData* this_ = const_cast<ImmutableScriptData*>(this);
    return this_->offsetToPointer<Offset>(optArrayOffset_)[-index];
  }

 public:
  static js::UniquePtr<ImmutableScriptData> new_(
      JSContext* cx, uint32_t mainOffset, uint32_t nfixed, uint32_t nslots,
      uint32_t bodyScopeIndex, uint32_t numICEntries,
      uint32_t numBytecodeTypeSets, bool isFunction, uint16_t funLength,
      mozilla::Span<const jsbytecode> code, mozilla::Span<const SrcNote> notes,
      mozilla::Span<const uint32_t> resumeOffsets,
      mozilla::Span<const ScopeNote> scopeNotes,
      mozilla::Span<const TryNote> tryNotes);

  static js::UniquePtr<ImmutableScriptData> new_(
      JSContext* cx, uint32_t codeLength, uint32_t noteLength,
      uint32_t numResumeOffsets, uint32_t numScopeNotes, uint32_t numTryNotes);

  // The code() and note() arrays together maintain an target alignment by
  // padding the source notes with null. This allows arrays with stricter
  // alignment requirements to follow them.
  static constexpr size_t CodeNoteAlign = sizeof(uint32_t);

  // Compute number of null notes to pad out source notes with.
  static uint32_t ComputeNotePadding(uint32_t codeLength, uint32_t noteLength) {
    uint32_t flagLength = sizeof(Flags);
    uint32_t nullLength =
        CodeNoteAlign - (flagLength + codeLength + noteLength) % CodeNoteAlign;

    // The source notes must have at least one null-terminator.
    MOZ_ASSERT(nullLength >= 1);

    return nullLength;
  }

  // Span over all raw bytes in this struct and its trailing arrays.
  mozilla::Span<const uint8_t> immutableData() const {
    size_t allocSize = endOffset();
    return mozilla::MakeSpan(reinterpret_cast<const uint8_t*>(this), allocSize);
  }

 private:
  Flags& flagsRef() { return *offsetToPointer<Flags>(flagOffset()); }
  const Flags& flags() const {
    return const_cast<ImmutableScriptData*>(this)->flagsRef();
  }

 public:
  uint32_t codeLength() const { return codeLength_; }
  jsbytecode* code() { return offsetToPointer<jsbytecode>(codeOffset()); }
  mozilla::Span<jsbytecode> codeSpan() { return {code(), codeLength()}; }

  uint32_t noteLength() const {
    return numElements<SrcNote>(noteOffset(), optionalOffsetsOffset());
  }
  SrcNote* notes() { return offsetToPointer<SrcNote>(noteOffset()); }
  mozilla::Span<SrcNote> notesSpan() { return {notes(), noteLength()}; }

  mozilla::Span<uint32_t> resumeOffsets() {
    return mozilla::MakeSpan(offsetToPointer<uint32_t>(resumeOffsetsOffset()),
                             offsetToPointer<uint32_t>(scopeNotesOffset()));
  }
  mozilla::Span<ScopeNote> scopeNotes() {
    return mozilla::MakeSpan(offsetToPointer<ScopeNote>(scopeNotesOffset()),
                             offsetToPointer<ScopeNote>(tryNotesOffset()));
  }
  mozilla::Span<TryNote> tryNotes() {
    return mozilla::MakeSpan(offsetToPointer<TryNote>(tryNotesOffset()),
                             offsetToPointer<TryNote>(endOffset()));
  }

  // Expose offsets to the JITs.
  static constexpr size_t offsetOfCode() {
    return sizeof(ImmutableScriptData) + sizeof(Flags);
  }
  static constexpr size_t offsetOfResumeOffsetsOffset() {
    // Resume-offsets are the first optional array if they exist. Locate the
    // array with the 'optArrayOffset_' field.
    static_assert(sizeof(Offset) == sizeof(uint32_t),
                  "JIT expect Offset to be uint32_t");
    return offsetof(ImmutableScriptData, optArrayOffset_);
  }
  static constexpr size_t offsetOfNfixed() {
    return offsetof(ImmutableScriptData, nfixed);
  }
  static constexpr size_t offsetOfNslots() {
    return offsetof(ImmutableScriptData, nslots);
  }
  static constexpr size_t offsetOfFunLength() {
    return offsetof(ImmutableScriptData, funLength);
  }

  // ImmutableScriptData has trailing data so isn't copyable or movable.
  ImmutableScriptData(const ImmutableScriptData&) = delete;
  ImmutableScriptData& operator=(const ImmutableScriptData&) = delete;
};

}  // namespace js

#endif /* vm_SharedStencil_h */
