/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef vm_Shape_h
#define vm_Shape_h

#include "mozilla/Attributes.h"
#include "mozilla/GuardObjects.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/Maybe.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/TemplateLib.h"

#include <algorithm>

#include "jsapi.h"
#include "jsfriendapi.h"
#include "jstypes.h"
#include "NamespaceImports.h"

#include "gc/Barrier.h"
#include "gc/FreeOp.h"
#include "gc/MaybeRooted.h"
#include "gc/Rooting.h"
#include "js/HashTable.h"
#include "js/MemoryMetrics.h"
#include "js/RootingAPI.h"
#include "js/UbiNode.h"
#include "vm/JSAtom.h"
#include "vm/ObjectGroup.h"
#include "vm/Printer.h"
#include "vm/StringType.h"
#include "vm/SymbolType.h"

/*
 * [SMDOC] Shapes
 *
 * In isolation, a Shape represents a property that exists in one or more
 * objects; it has an id, flags, etc. (But it doesn't represent the property's
 * value.)  However, Shapes are always stored in linked linear sequence of
 * Shapes, called "shape lineages". Each shape lineage represents the layout of
 * an entire object.
 *
 * Every JSObject has a pointer, |shape_|, accessible via lastProperty(), to
 * the last Shape in a shape lineage, which identifies the property most
 * recently added to the object.  This pointer permits fast object layout
 * tests. The shape lineage order also dictates the enumeration order for the
 * object; ECMA requires no particular order but this implementation has
 * promised and delivered property definition order.
 *
 * Shape lineages occur in two kinds of data structure.
 *
 * 1. N-ary property trees. Each path from a non-root node to the root node in
 *    a property tree is a shape lineage. Property trees permit full (or
 *    partial) sharing of Shapes between objects that have fully (or partly)
 *    identical layouts. The root is an EmptyShape whose identity is determined
 *    by the object's class, compartment and prototype. These Shapes are shared
 *    and immutable.
 *
 * 2. Dictionary mode lists. Shapes in such lists are said to be "in
 *    dictionary mode", as are objects that point to such Shapes. These Shapes
 *    are unshared, private to a single object, and immutable except for their
 *    links in the dictionary list.
 *
 * All shape lineages are bi-directionally linked, via the |parent| and
 * |children|/|listp| members.
 *
 * Shape lineages start out life in the property tree. They can be converted
 * (by copying) to dictionary mode lists in the following circumstances.
 *
 * 1. The shape lineage's size reaches MAX_HEIGHT. This reasonable limit avoids
 *    potential worst cases involving shape lineage mutations.
 *
 * 2. A property represented by a non-last Shape in a shape lineage is removed
 *    from an object. (In the last Shape case, obj->shape_ can be easily
 *    adjusted to point to obj->shape_->parent.)  We originally tried lazy
 *    forking of the property tree, but this blows up for delete/add
 *    repetitions.
 *
 * 3. A property represented by a non-last Shape in a shape lineage has its
 *    attributes modified.
 *
 * To find the Shape for a particular property of an object initially requires
 * a linear search. But if the number of searches starting at any particular
 * Shape in the property tree exceeds LINEAR_SEARCHES_MAX and the Shape's
 * lineage has (excluding the EmptyShape) at least MIN_ENTRIES, we create an
 * auxiliary hash table -- the ShapeTable -- that allows faster lookup.
 * Furthermore, a ShapeTable is always created for dictionary mode lists,
 * and it is attached to the last Shape in the lineage. Shape tables for
 * property tree Shapes never change, but shape tables for dictionary mode
 * Shapes can grow and shrink.
 *
 * To save memory, shape tables can be discarded on GC and recreated when
 * needed. AutoKeepShapeCaches can be used to avoid discarding shape tables
 * for a particular zone. Methods operating on ShapeTables take either an
 * AutoCheckCannotGC or AutoKeepShapeCaches argument, to help ensure tables
 * are not purged while we're using them.
 *
 * There used to be a long, math-heavy comment here explaining why property
 * trees are more space-efficient than alternatives.  This was removed in bug
 * 631138; see that bug for the full details.
 *
 * For getters/setters, an AccessorShape is allocated. This is a slightly fatter
 * type with extra fields for the getter/setter data.
 *
 * Because many Shapes have similar data, there is actually a secondary type
 * called a BaseShape that holds some of a Shape's data.  Many shapes can share
 * a single BaseShape.
 */

MOZ_ALWAYS_INLINE size_t JSSLOT_FREE(const JSClass* clasp) {
  // Proxy classes have reserved slots, but proxies manage their own slot
  // layout.
  MOZ_ASSERT(!clasp->isProxy());
  return JSCLASS_RESERVED_SLOTS(clasp);
}

namespace js {

class Shape;
struct StackShape;

struct ShapeHasher : public DefaultHasher<Shape*> {
  using Key = Shape*;
  using Lookup = StackShape;

  static MOZ_ALWAYS_INLINE HashNumber hash(const Lookup& l);
  static MOZ_ALWAYS_INLINE bool match(Key k, const Lookup& l);
};

using ShapeSet = HashSet<Shape*, ShapeHasher, SystemAllocPolicy>;

// A tagged pointer to null, a single child, or a many-children data structure.
class ShapeChildren {
  // Tag bits must not overlap with DictionaryShapeLink.
  enum { SINGLE_SHAPE = 0, SHAPE_SET = 1, MASK = 3 };

  uintptr_t bits = 0;

 public:
  bool isNone() const { return !bits; }
  void setNone() { bits = 0; }

  bool isSingleShape() const {
    return (bits & MASK) == SINGLE_SHAPE && !isNone();
  }
  Shape* toSingleShape() const {
    MOZ_ASSERT(isSingleShape());
    return reinterpret_cast<Shape*>(bits & ~uintptr_t(MASK));
  }
  void setSingleShape(Shape* shape) {
    MOZ_ASSERT(shape);
    MOZ_ASSERT((uintptr_t(shape) & MASK) == 0);
    bits = uintptr_t(shape) | SINGLE_SHAPE;
  }

  bool isShapeSet() const { return (bits & MASK) == SHAPE_SET; }
  ShapeSet* toShapeSet() const {
    MOZ_ASSERT(isShapeSet());
    return reinterpret_cast<ShapeSet*>(bits & ~uintptr_t(MASK));
  }
  void setShapeSet(ShapeSet* hash) {
    MOZ_ASSERT(hash);
    MOZ_ASSERT((uintptr_t(hash) & MASK) == 0);
    bits = uintptr_t(hash) | SHAPE_SET;
  }

#ifdef DEBUG
  void checkHasChild(Shape* child) const;
#endif
} JS_HAZ_GC_POINTER;

// For dictionary mode shapes, a tagged pointer to the next shape or associated
// object if this is the last shape.
class DictionaryShapeLink {
  // Tag bits must not overlap with ShapeChildren.
  enum { SHAPE = 2, OBJECT = 3, MASK = 3 };

  uintptr_t bits = 0;

 public:
  // XXX Using = default on the default ctor causes rooting hazards for some
  // reason.
  DictionaryShapeLink() {}
  explicit DictionaryShapeLink(JSObject* obj) { setObject(obj); }
  explicit DictionaryShapeLink(Shape* shape) { setShape(shape); }

  bool isNone() const { return !bits; }
  void setNone() { bits = 0; }

  bool isShape() const { return (bits & MASK) == SHAPE; }
  Shape* toShape() const {
    MOZ_ASSERT(isShape());
    return reinterpret_cast<Shape*>(bits & ~uintptr_t(MASK));
  }
  void setShape(Shape* shape) {
    MOZ_ASSERT(shape);
    MOZ_ASSERT((uintptr_t(shape) & MASK) == 0);
    bits = uintptr_t(shape) | SHAPE;
  }

  bool isObject() const { return (bits & MASK) == OBJECT; }
  JSObject* toObject() const {
    MOZ_ASSERT(isObject());
    return reinterpret_cast<JSObject*>(bits & ~uintptr_t(MASK));
  }
  void setObject(JSObject* obj) {
    MOZ_ASSERT(obj);
    MOZ_ASSERT((uintptr_t(obj) & MASK) == 0);
    bits = uintptr_t(obj) | OBJECT;
  }

  bool operator==(const DictionaryShapeLink& other) const {
    return bits == other.bits;
  }
  bool operator!=(const DictionaryShapeLink& other) const {
    return !((*this) == other);
  }

  GCPtrShape* prevPtr();
} JS_HAZ_GC_POINTER;

class PropertyTree {
  friend class ::JSFunction;

#ifdef DEBUG
  JS::Zone* zone_;
#endif

  bool insertChild(JSContext* cx, Shape* parent, Shape* child);

  PropertyTree();

 public:
  /*
   * Use a lower limit for objects that are accessed using SETELEM (o[x] = y).
   * These objects are likely used as hashmaps and dictionary mode is more
   * efficient in this case.
   */
  enum { MAX_HEIGHT = 512, MAX_HEIGHT_WITH_ELEMENTS_ACCESS = 128 };

  explicit PropertyTree(JS::Zone* zone)
#ifdef DEBUG
      : zone_(zone)
#endif
  {
  }

  MOZ_ALWAYS_INLINE Shape* inlinedGetChild(JSContext* cx, Shape* parent,
                                           JS::Handle<StackShape> childSpec);
  Shape* getChild(JSContext* cx, Shape* parent, JS::Handle<StackShape> child);
};

class TenuringTracer;

using GetterOp = JSGetterOp;
using SetterOp = JSSetterOp;

/* Limit on the number of slotful properties in an object. */
static const uint32_t SHAPE_INVALID_SLOT = Bit(24) - 1;
static const uint32_t SHAPE_MAXIMUM_SLOT = Bit(24) - 2;

enum class MaybeAdding { Adding = true, NotAdding = false };

class AutoKeepShapeCaches;

/*
 * ShapeIC uses a small array that is linearly searched.
 */
class ShapeIC {
 public:
  friend class NativeObject;
  friend class BaseShape;
  friend class Shape;

  ShapeIC() : size_(0), nextFreeIndex_(0), entries_(nullptr) {}

  ~ShapeIC() = default;

  bool isFull() const {
    MOZ_ASSERT(nextFreeIndex_ <= size_);
    return size_ == nextFreeIndex_;
  }

  size_t sizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf) const {
    return mallocSizeOf(this) + mallocSizeOf(entries_.get());
  }

  uint32_t entryCount() { return nextFreeIndex_; }

  bool init(JSContext* cx);
  void trace(JSTracer* trc);

#ifdef JSGC_HASH_TABLE_CHECKS
  void checkAfterMovingGC();
#endif

  MOZ_ALWAYS_INLINE bool search(jsid id, Shape** foundShape);

  MOZ_ALWAYS_INLINE bool appendEntry(jsid id, Shape* shape) {
    MOZ_ASSERT(nextFreeIndex_ <= size_);
    if (nextFreeIndex_ == size_) {
      return false;
    }

    entries_[nextFreeIndex_].id_ = id;
    entries_[nextFreeIndex_].shape_ = shape;
    nextFreeIndex_++;
    return true;
  }

 private:
  static const uint32_t MAX_SIZE = 7;

  class Entry {
   public:
    jsid id_;
    Shape* shape_;

    Entry() = delete;
    Entry(const Entry&) = delete;
    Entry& operator=(const Entry&) = delete;
  };

  uint8_t size_;
  uint8_t nextFreeIndex_;

  /* table of ptrs to {jsid,Shape*} pairs */
  UniquePtr<Entry[], JS::FreePolicy> entries_;
};

/*
 * ShapeTable uses multiplicative hashing, but specialized to
 * minimize footprint.
 */
class ShapeTable {
 public:
  friend class NativeObject;
  friend class BaseShape;
  friend class Shape;
  friend class ShapeCachePtr;

  class Entry {
    // js::Shape pointer tag bit indicating a collision.
    static const uintptr_t SHAPE_COLLISION = 1;
    static Shape* const SHAPE_REMOVED;  // = SHAPE_COLLISION

    Shape* shape_;

    Entry() = delete;
    Entry(const Entry&) = delete;
    Entry& operator=(const Entry&) = delete;

   public:
    bool isFree() const { return shape_ == nullptr; }
    bool isRemoved() const { return shape_ == SHAPE_REMOVED; }
    bool isLive() const { return !isFree() && !isRemoved(); }
    bool hadCollision() const { return uintptr_t(shape_) & SHAPE_COLLISION; }

    void setFree() { shape_ = nullptr; }
    void setRemoved() { shape_ = SHAPE_REMOVED; }

    Shape* shape() const {
      return reinterpret_cast<Shape*>(uintptr_t(shape_) & ~SHAPE_COLLISION);
    }

    void setShape(Shape* shape) {
      MOZ_ASSERT(isFree());
      MOZ_ASSERT(shape);
      MOZ_ASSERT(shape != SHAPE_REMOVED);
      shape_ = shape;
      MOZ_ASSERT(!hadCollision());
    }

    void flagCollision() {
      shape_ = reinterpret_cast<Shape*>(uintptr_t(shape_) | SHAPE_COLLISION);
    }
    void setPreservingCollision(Shape* shape) {
      shape_ = reinterpret_cast<Shape*>(uintptr_t(shape) |
                                        uintptr_t(hadCollision()));
    }
  };

 private:
  static const uint32_t HASH_BITS = mozilla::tl::BitSize<HashNumber>::value;

  // This value is low because it's common for a ShapeTable to be created
  // with an entryCount of zero.
  static const uint32_t MIN_SIZE_LOG2 = 2;
  static const uint32_t MIN_SIZE = Bit(MIN_SIZE_LOG2);

  uint32_t hashShift_; /* multiplicative hash shift */

  uint32_t entryCount_;   /* number of entries in table */
  uint32_t removedCount_; /* removed entry sentinels in table */

  uint32_t freeList_; /* SHAPE_INVALID_SLOT or head of slot
                         freelist in owning dictionary-mode
                         object */

  UniquePtr<Entry[], JS::FreePolicy>
      entries_; /* table of ptrs to shared tree nodes */

  template <MaybeAdding Adding>
  MOZ_ALWAYS_INLINE Entry& searchUnchecked(jsid id);

 public:
  explicit ShapeTable(uint32_t nentries)
      : hashShift_(HASH_BITS - MIN_SIZE_LOG2),
        entryCount_(nentries),
        removedCount_(0),
        freeList_(SHAPE_INVALID_SLOT),
        entries_(nullptr) {
    /* NB: entries is set by init, which must be called. */
  }

  ~ShapeTable() = default;

  uint32_t entryCount() const { return entryCount_; }

  uint32_t freeList() const { return freeList_; }
  void setFreeList(uint32_t slot) { freeList_ = slot; }

  /*
   * This counts the ShapeTable object itself (which must be
   * heap-allocated) and its |entries| array.
   */
  size_t sizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf) const {
    return mallocSizeOf(this) + mallocSizeOf(entries_.get());
  }

  // init() is fallible and reports OOM to the context.
  bool init(JSContext* cx, Shape* lastProp);

  // change() is fallible but does not report OOM.
  bool change(JSContext* cx, int log2Delta);

  template <MaybeAdding Adding>
  MOZ_ALWAYS_INLINE Entry& search(jsid id, const AutoKeepShapeCaches&);

  template <MaybeAdding Adding>
  MOZ_ALWAYS_INLINE Entry& search(jsid id, const JS::AutoCheckCannotGC&);

  void trace(JSTracer* trc);
#ifdef JSGC_HASH_TABLE_CHECKS
  void checkAfterMovingGC();
#endif

 private:
  Entry& getEntry(uint32_t i) const {
    MOZ_ASSERT(i < capacity());
    return entries_[i];
  }
  void decEntryCount() {
    MOZ_ASSERT(entryCount_ > 0);
    entryCount_--;
  }
  void incEntryCount() {
    entryCount_++;
    MOZ_ASSERT(entryCount_ + removedCount_ <= capacity());
  }
  void incRemovedCount() {
    removedCount_++;
    MOZ_ASSERT(entryCount_ + removedCount_ <= capacity());
  }

  // By definition, hashShift = HASH_BITS - log2(capacity).
  uint32_t capacity() const { return Bit(HASH_BITS - hashShift_); }

  // Whether we need to grow.  We want to do this if the load factor
  // is >= 0.75
  bool needsToGrow() const {
    uint32_t size = capacity();
    return entryCount_ + removedCount_ >= size - (size >> 2);
  }

  // Try to grow the table.  On failure, reports out of memory on cx
  // and returns false.  This will make any extant pointers into the
  // table invalid.  Don't call this unless needsToGrow() is true.
  bool grow(JSContext* cx);
};

/*
 *  Wrapper class to either ShapeTable or ShapeIC optimization.
 *
 *  Shapes are initially cached in a linear cache from the ShapeIC class that is
 *  lazily initialized after LINEAR_SEARCHES_MAX searches have been reached, and
 *  the Shape has at least MIN_ENTRIES parents in the lineage.
 *
 *  We use the population of the cache as an indicator of whether the ShapeIC is
 *  working or not.  Once it is full, it is destroyed and a ShapeTable is
 * created instead.
 *
 *  For dictionaries, the linear cache is skipped entirely and hashify is used
 *  to generate the ShapeTable immediately.
 */
class ShapeCachePtr {
  // To reduce impact on memory usage, p is the only data member for this class.
  uintptr_t p;

  enum class CacheType {
    IC = 0x1,
    Table = 0x2,
  };

  static const uint32_t MASK_BITS = 0x3;
  static const uintptr_t CACHETYPE_MASK = 0x3;

  void* getPointer() const {
    uintptr_t ptrVal = p & ~CACHETYPE_MASK;
    return reinterpret_cast<void*>(ptrVal);
  }

  CacheType getType() const {
    return static_cast<CacheType>(p & CACHETYPE_MASK);
  }

 public:
  static const uint32_t MIN_ENTRIES = 3;

  ShapeCachePtr() : p(0) {}

  template <MaybeAdding Adding>
  MOZ_ALWAYS_INLINE bool search(jsid id, Shape* start, Shape** foundShape);

  bool isIC() const { return (getType() == CacheType::IC); }
  bool isTable() const { return (getType() == CacheType::Table); }
  bool isInitialized() const { return isTable() || isIC(); }

  ShapeTable* getTablePointer() const {
    MOZ_ASSERT(isTable());
    return reinterpret_cast<ShapeTable*>(getPointer());
  }

  ShapeIC* getICPointer() const {
    MOZ_ASSERT(isIC());
    return reinterpret_cast<ShapeIC*>(getPointer());
  }

  // Use ShapeTable implementation.
  // The caller must have purged any existing IC implementation.
  void initializeTable(ShapeTable* table) {
    MOZ_ASSERT(!isTable() && !isIC());

    uintptr_t tableptr = uintptr_t(table);

    // Double check that pointer is 4 byte aligned.
    MOZ_ASSERT((tableptr & CACHETYPE_MASK) == 0);

    tableptr |= static_cast<uintptr_t>(CacheType::Table);
    p = tableptr;
  }

  // Use ShapeIC implementation.
  // This cannot clobber an existing Table implementation.
  void initializeIC(ShapeIC* ic) {
    MOZ_ASSERT(!isTable() && !isIC());

    uintptr_t icptr = uintptr_t(ic);

    // Double check that pointer is 4 byte aligned.
    MOZ_ASSERT((icptr & CACHETYPE_MASK) == 0);

    icptr |= static_cast<uintptr_t>(CacheType::IC);
    p = icptr;
  }

  void destroy(JSFreeOp* fop, BaseShape* base);

  void maybePurgeCache(JSFreeOp* fop, BaseShape* base);

  void trace(JSTracer* trc);

  size_t sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const {
    size_t size = 0;
    if (isIC()) {
      size = getICPointer()->sizeOfIncludingThis(mallocSizeOf);
    } else if (isTable()) {
      size = getTablePointer()->sizeOfIncludingThis(mallocSizeOf);
    }
    return size;
  }

  uint32_t entryCount() {
    uint32_t count = 0;
    if (isIC()) {
      count = getICPointer()->entryCount();
    } else if (isTable()) {
      count = getTablePointer()->entryCount();
    }
    return count;
  }

#ifdef JSGC_HASH_TABLE_CHECKS
  void checkAfterMovingGC();
#endif
};

// Ensures no shape tables are purged in the current zone.
class MOZ_RAII AutoKeepShapeCaches {
  JSContext* cx_;
  bool prev_;

 public:
  void operator=(const AutoKeepShapeCaches&) = delete;
  AutoKeepShapeCaches(const AutoKeepShapeCaches&) = delete;
  explicit inline AutoKeepShapeCaches(JSContext* cx);
  inline ~AutoKeepShapeCaches();
};

/*
 * Shapes encode information about both a property lineage *and* a particular
 * property. This information is split across the Shape and the BaseShape
 * at shape->base(). Both Shape and BaseShape can be either owned or unowned
 * by, respectively, the Object or Shape referring to them.
 *
 * Owned Shapes are used in dictionary objects, and form a doubly linked list
 * whose entries are all owned by that dictionary. Unowned Shapes are all in
 * the property tree.
 *
 * Owned BaseShapes are used for shapes which have shape tables, including the
 * last properties in all dictionaries. Unowned BaseShapes compactly store
 * information common to many shapes. In a given zone there is a single
 * BaseShape for each combination of BaseShape information. This information is
 * cloned in owned BaseShapes so that information can be quickly looked up for a
 * given object or shape without regard to whether the base shape is owned or
 * not.
 *
 * All combinations of owned/unowned Shapes/BaseShapes are possible:
 *
 * Owned Shape, Owned BaseShape:
 *
 *     Last property in a dictionary object. The BaseShape is transferred from
 *     property to property as the object's last property changes.
 *
 * Owned Shape, Unowned BaseShape:
 *
 *     Property in a dictionary object other than the last one.
 *
 * Unowned Shape, Owned BaseShape:
 *
 *     Property in the property tree which has a shape table.
 *
 * Unowned Shape, Unowned BaseShape:
 *
 *     Property in the property tree which does not have a shape table.
 *
 * BaseShapes additionally encode some information about the referring object
 * itself. This includes the object's class and various flags that may be set
 * for the object. Except for the class, this information is mutable and may
 * change when the object has an established property lineage. On such changes
 * the entire property lineage is not updated, but rather only the last property
 * (and its base shape). This works because only the object's last property is
 * used to query information about the object. Care must be taken to call
 * JSObject::canRemoveLastProperty when unwinding an object to an earlier
 * property, however.
 */

class AccessorShape;
class Shape;
class UnownedBaseShape;
struct StackBaseShape;

class BaseShape : public gc::TenuredCell {
 public:
  friend class Shape;
  friend struct StackBaseShape;
  friend struct StackShape;

  enum Flag {
    /* Owned by the referring shape. */
    OWNED_SHAPE = 0x1,

    /* (0x2 and 0x4 are unused) */

    /*
     * Flags set which describe the referring object. Once set these cannot
     * be unset (except during object densification of sparse indexes), and
     * are transferred from shape to shape as the object's last property
     * changes.
     *
     * If you add a new flag here, please add appropriate code to
     * JSObject::dump to dump it as part of object representation.
     */

    DELEGATE = 0x8,
    NOT_EXTENSIBLE = 0x10,
    INDEXED = 0x20,
    HAS_INTERESTING_SYMBOL = 0x40,
    HAD_ELEMENTS_ACCESS = 0x80,
    FROZEN_ELEMENTS = 0x100,  // See ObjectElements::FROZEN comment.
    ITERATED_SINGLETON = 0x200,
    NEW_GROUP_UNKNOWN = 0x400,
    UNCACHEABLE_PROTO = 0x800,
    IMMUTABLE_PROTOTYPE = 0x1000,

    // See JSObject::isQualifiedVarObj().
    QUALIFIED_VAROBJ = 0x2000,

    // 0x4000 is unused.
    // 0x8000 is unused.

    OBJECT_FLAG_MASK = 0xfff8
  };

 private:
  using HeaderWithJSClass = gc::CellHeaderWithNonGCPointer<const JSClass>;
  HeaderWithJSClass headerAndClasp_; /* Class of referring object. */
  uint32_t flags;                    /* Vector of above flags. */
  uint32_t slotSpan_;                /* Object slot span for BaseShapes at
                                      * dictionary last properties. */

  /* For owned BaseShapes, the canonical unowned BaseShape. */
  GCPtrUnownedBaseShape unowned_;

  /* For owned BaseShapes, the shape's shape table. */
  ShapeCachePtr cache_;

  BaseShape(const BaseShape& base) = delete;
  BaseShape& operator=(const BaseShape& other) = delete;

 public:
  void finalize(JSFreeOp* fop);

  explicit inline BaseShape(const StackBaseShape& base);

  /* Not defined: BaseShapes must not be stack allocated. */
  ~BaseShape();

  const JSClass* clasp() const { return headerAndClasp_.ptr(); }

  bool isOwned() const { return !!(flags & OWNED_SHAPE); }

  static void copyFromUnowned(BaseShape& dest, UnownedBaseShape& src);
  inline void adoptUnowned(UnownedBaseShape* other);

  void setOwned(UnownedBaseShape* unowned) {
    flags |= OWNED_SHAPE;
    unowned_ = unowned;
  }

  uint32_t getObjectFlags() const { return flags & OBJECT_FLAG_MASK; }

  bool hasTable() const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return cache_.isTable();
  }

  bool hasIC() const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return cache_.isIC();
  }

  void setTable(ShapeTable* table) {
    MOZ_ASSERT(isOwned());
    cache_.initializeTable(table);
  }

  void setIC(ShapeIC* ic) {
    MOZ_ASSERT(isOwned());
    cache_.initializeIC(ic);
  }

  ShapeCachePtr getCache(const AutoKeepShapeCaches&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return cache_;
  }

  ShapeCachePtr getCache(const JS::AutoCheckCannotGC&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return cache_;
  }

  ShapeTable* maybeTable(const AutoKeepShapeCaches&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return (cache_.isTable()) ? cache_.getTablePointer() : nullptr;
  }

  ShapeTable* maybeTable(const JS::AutoCheckCannotGC&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return (cache_.isTable()) ? cache_.getTablePointer() : nullptr;
  }

  ShapeIC* maybeIC(const AutoKeepShapeCaches&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return (cache_.isIC()) ? cache_.getICPointer() : nullptr;
  }

  ShapeIC* maybeIC(const JS::AutoCheckCannotGC&) const {
    MOZ_ASSERT_IF(cache_.isInitialized(), isOwned());
    return (cache_.isIC()) ? cache_.getICPointer() : nullptr;
  }

  void maybePurgeCache(JSFreeOp* fop) { cache_.maybePurgeCache(fop, this); }

  uint32_t slotSpan() const {
    MOZ_ASSERT(isOwned());
    return slotSpan_;
  }
  void setSlotSpan(uint32_t slotSpan) {
    MOZ_ASSERT(isOwned());
    slotSpan_ = slotSpan;
  }

  /*
   * Lookup base shapes from the zone's baseShapes table, adding if not
   * already found.
   */
  static UnownedBaseShape* getUnowned(JSContext* cx, StackBaseShape& base);

  /* Get the canonical base shape. */
  inline UnownedBaseShape* unowned();

  /* Get the canonical base shape for an owned one. */
  inline UnownedBaseShape* baseUnowned();

  /* Get the canonical base shape for an unowned one (i.e. identity). */
  inline UnownedBaseShape* toUnowned();

  /* Check that an owned base shape is consistent with its unowned base. */
  void assertConsistency();

  /* For JIT usage */
  static inline size_t offsetOfFlags() { return offsetof(BaseShape, flags); }

  static const JS::TraceKind TraceKind = JS::TraceKind::BaseShape;
  const gc::CellHeader& cellHeader() const { return headerAndClasp_; }

  void traceChildren(JSTracer* trc);
  void traceChildrenSkipShapeCache(JSTracer* trc);

#ifdef DEBUG
  bool canSkipMarkingShapeCache(Shape* lastShape);
#endif

 private:
  static void staticAsserts() {
    static_assert(offsetof(BaseShape, headerAndClasp_) ==
                  offsetof(js::shadow::BaseShape, clasp_));
    static_assert(sizeof(BaseShape) % gc::CellAlignBytes == 0,
                  "Things inheriting from gc::Cell must have a size that's "
                  "a multiple of gc::CellAlignBytes");
  }

  void traceShapeCache(JSTracer* trc);
};

class UnownedBaseShape : public BaseShape {};

UnownedBaseShape* BaseShape::unowned() {
  return isOwned() ? baseUnowned() : toUnowned();
}

UnownedBaseShape* BaseShape::toUnowned() {
  MOZ_ASSERT(!isOwned() && !unowned_);
  return static_cast<UnownedBaseShape*>(this);
}

UnownedBaseShape* BaseShape::baseUnowned() {
  MOZ_ASSERT(isOwned() && unowned_);
  return unowned_;
}

/* Entries for the per-zone baseShapes set of unowned base shapes. */
struct StackBaseShape : public DefaultHasher<WeakHeapPtr<UnownedBaseShape*>> {
  uint32_t flags;
  const JSClass* clasp;

  explicit StackBaseShape(BaseShape* base)
      : flags(base->flags & BaseShape::OBJECT_FLAG_MASK),
        clasp(base->clasp()) {}

  inline StackBaseShape(const JSClass* clasp, uint32_t objectFlags);
  explicit inline StackBaseShape(Shape* shape);

  struct Lookup {
    uint32_t flags;
    const JSClass* clasp;

    MOZ_IMPLICIT Lookup(const StackBaseShape& base)
        : flags(base.flags), clasp(base.clasp) {}

    MOZ_IMPLICIT Lookup(UnownedBaseShape* base)
        : flags(base->getObjectFlags()), clasp(base->clasp()) {
      MOZ_ASSERT(!base->isOwned());
    }

    explicit Lookup(const WeakHeapPtr<UnownedBaseShape*>& base)
        : flags(base.unbarrieredGet()->getObjectFlags()),
          clasp(base.unbarrieredGet()->clasp()) {
      MOZ_ASSERT(!base.unbarrieredGet()->isOwned());
    }
  };

  static HashNumber hash(const Lookup& lookup) {
    return mozilla::HashGeneric(lookup.flags, lookup.clasp);
  }
  static inline bool match(const WeakHeapPtr<UnownedBaseShape*>& key,
                           const Lookup& lookup) {
    return key.unbarrieredGet()->flags == lookup.flags &&
           key.unbarrieredGet()->clasp() == lookup.clasp;
  }
};

static MOZ_ALWAYS_INLINE js::HashNumber HashId(jsid id) {
  // HashGeneric alone would work, but bits of atom and symbol addresses
  // could then be recovered from the hash code. See bug 1330769.
  if (MOZ_LIKELY(JSID_IS_ATOM(id))) {
    return JSID_TO_ATOM(id)->hash();
  }
  if (JSID_IS_SYMBOL(id)) {
    return JSID_TO_SYMBOL(id)->hash();
  }
  return mozilla::HashGeneric(JSID_BITS(id));
}

}  // namespace js

namespace mozilla {

template <>
struct DefaultHasher<jsid> {
  using Lookup = jsid;
  static HashNumber hash(jsid id) { return js::HashId(id); }
  static bool match(jsid id1, jsid id2) { return id1 == id2; }
};

}  // namespace mozilla

namespace js {

using BaseShapeSet =
    JS::WeakCache<JS::GCHashSet<WeakHeapPtr<UnownedBaseShape*>, StackBaseShape,
                                SystemAllocPolicy>>;

class Shape : public gc::TenuredCell {
  friend class ::JSObject;
  friend class ::JSFunction;
  friend class GCMarker;
  friend class NativeObject;
  friend class PropertyTree;
  friend class TenuringTracer;
  friend struct StackBaseShape;
  friend struct StackShape;
  friend class JS::ubi::Concrete<Shape>;
  friend class js::gc::RelocationOverlay;

 protected:
  using HeaderWithBaseShape = gc::CellHeaderWithTenuredGCPointer<BaseShape>;
  HeaderWithBaseShape headerAndBase_;
  const GCPtrId propid_;

  // Flags that are not modified after the Shape is created. Off-thread Ion
  // compilation can access the immutableFlags word, so we don't want any
  // mutable state here to avoid (TSan) races.
  enum ImmutableFlags : uint32_t {
    // Mask to get the index in object slots for isDataProperty() shapes.
    // For other shapes in the property tree with a parent, stores the
    // parent's slot index (which may be invalid), and invalid for all
    // other shapes.
    SLOT_MASK = BitMask(24),

    // Number of fixed slots in objects with this shape.
    // FIXED_SLOTS_MAX is the biggest count of fixed slots a Shape can store.
    FIXED_SLOTS_MAX = 0x1f,
    FIXED_SLOTS_SHIFT = 24,
    FIXED_SLOTS_MASK = uint32_t(FIXED_SLOTS_MAX << FIXED_SLOTS_SHIFT),

    // Property stored in per-object dictionary, not shared property tree.
    IN_DICTIONARY = 1 << 29,

    // This shape is an AccessorShape, a fat Shape that can store
    // getter/setter information.
    ACCESSOR_SHAPE = 1 << 30,
  };

  // Flags stored in mutableFlags.
  enum MutableFlags : uint8_t {
    // numLinearSearches starts at zero and is incremented initially on
    // search() calls. Once numLinearSearches reaches LINEAR_SEARCHES_MAX,
    // the inline cache is created on the next search() call.  Once the
    // cache is full, it self transforms into a hash table. The hash table
    // can also be created directly when hashifying for dictionary mode.
    LINEAR_SEARCHES_MAX = 0x5,
    LINEAR_SEARCHES_MASK = 0x7,

    // Slotful property was stored to more than once. This is used as a
    // hint for type inference.
    OVERWRITTEN = 0x08,

    // Flags used to speed up isBigEnoughForAShapeTable().
    HAS_CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE = 0x10,
    CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE = 0x20,
  };

  uint32_t immutableFlags; /* immutable flags, see above */
  uint8_t attrs;           /* attributes, see jsapi.h JSPROP_* */
  uint8_t mutableFlags;    /* mutable flags, see below for defines */

  GCPtrShape parent; /* parent node, reverse for..in order */
  friend class DictionaryShapeLink;

  union {
    // Valid when !inDictionary().
    ShapeChildren children;

    // Valid when inDictionary().
    DictionaryShapeLink dictNext;
  };

  void setNextDictionaryShape(Shape* shape);
  void setDictionaryObject(JSObject* obj);
  void setDictionaryNextPtr(DictionaryShapeLink next);
  void clearDictionaryNextPtr();
  void dictNextPreWriteBarrier();

  template <MaybeAdding Adding = MaybeAdding::NotAdding>
  static MOZ_ALWAYS_INLINE Shape* search(JSContext* cx, Shape* start, jsid id);

  template <MaybeAdding Adding = MaybeAdding::NotAdding>
  static inline MOZ_MUST_USE bool search(JSContext* cx, Shape* start, jsid id,
                                         const AutoKeepShapeCaches&,
                                         Shape** pshape, ShapeTable** ptable,
                                         ShapeTable::Entry** pentry);

  static inline Shape* searchNoHashify(Shape* start, jsid id);

  void removeFromDictionary(NativeObject* obj);
  void insertIntoDictionaryBefore(DictionaryShapeLink next);

  inline void initDictionaryShape(const StackShape& child, uint32_t nfixed,
                                  DictionaryShapeLink next);

  // Replace the base shape of the last shape in a non-dictionary lineage with
  // base.
  static Shape* replaceLastProperty(JSContext* cx, StackBaseShape& base,
                                    TaggedProto proto, HandleShape shape);

  /*
   * This function is thread safe if every shape in the lineage of |shape|
   * is thread local, which is the case when we clone the entire shape
   * lineage in preparation for converting an object to dictionary mode.
   */
  static bool hashify(JSContext* cx, Shape* shape);
  static bool cachify(JSContext* cx, Shape* shape);
  void handoffTableTo(Shape* newShape);

  void setParent(Shape* p) {
    MOZ_ASSERT_IF(p && !p->hasMissingSlot() && !inDictionary(),
                  p->maybeSlot() <= maybeSlot());
    MOZ_ASSERT_IF(p && !inDictionary(),
                  isDataProperty() == (p->maybeSlot() != maybeSlot()));
    parent = p;
  }

  bool ensureOwnBaseShape(JSContext* cx) {
    if (base()->isOwned()) {
      return true;
    }
    return makeOwnBaseShape(cx);
  }

  bool makeOwnBaseShape(JSContext* cx);

  MOZ_ALWAYS_INLINE MOZ_MUST_USE bool maybeCreateCacheForLookup(JSContext* cx);

  MOZ_ALWAYS_INLINE void updateDictionaryTable(ShapeTable* table,
                                               ShapeTable::Entry* entry,
                                               const AutoKeepShapeCaches& keep);

 public:
  bool hasTable() const { return base()->hasTable(); }
  bool hasIC() const { return base()->hasIC(); }

  ShapeIC* maybeIC(const AutoKeepShapeCaches& keep) const {
    return base()->maybeIC(keep);
  }
  ShapeIC* maybeIC(const JS::AutoCheckCannotGC& check) const {
    return base()->maybeIC(check);
  }
  ShapeTable* maybeTable(const AutoKeepShapeCaches& keep) const {
    return base()->maybeTable(keep);
  }
  ShapeTable* maybeTable(const JS::AutoCheckCannotGC& check) const {
    return base()->maybeTable(check);
  }
  ShapeCachePtr getCache(const AutoKeepShapeCaches& keep) const {
    return base()->getCache(keep);
  }
  ShapeCachePtr getCache(const JS::AutoCheckCannotGC& check) const {
    return base()->getCache(check);
  }

  bool appendShapeToIC(jsid id, Shape* shape,
                       const JS::AutoCheckCannotGC& check) {
    MOZ_ASSERT(hasIC());
    ShapeCachePtr cache = getCache(check);
    return cache.getICPointer()->appendEntry(id, shape);
  }

  template <typename T>
  MOZ_MUST_USE ShapeTable* ensureTableForDictionary(JSContext* cx,
                                                    const T& nogc) {
    MOZ_ASSERT(inDictionary());
    if (ShapeTable* table = maybeTable(nogc)) {
      return table;
    }
    if (!hashify(cx, this)) {
      return nullptr;
    }
    ShapeTable* table = maybeTable(nogc);
    MOZ_ASSERT(table);
    return table;
  }

  void addSizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf,
                              JS::ShapeInfo* info) const {
    JS::AutoCheckCannotGC nogc;
    if (inDictionary()) {
      info->shapesMallocHeapDictTables +=
          getCache(nogc).sizeOfExcludingThis(mallocSizeOf);
    } else {
      info->shapesMallocHeapTreeTables +=
          getCache(nogc).sizeOfExcludingThis(mallocSizeOf);
    }

    if (!inDictionary() && children.isShapeSet()) {
      info->shapesMallocHeapTreeChildren +=
          children.toShapeSet()->shallowSizeOfIncludingThis(mallocSizeOf);
    }
  }

  bool isAccessorShape() const {
    MOZ_ASSERT_IF(immutableFlags & ACCESSOR_SHAPE,
                  getAllocKind() == gc::AllocKind::ACCESSOR_SHAPE);
    return immutableFlags & ACCESSOR_SHAPE;
  }
  AccessorShape& asAccessorShape() const {
    MOZ_ASSERT(isAccessorShape());
    return *(AccessorShape*)this;
  }

  const GCPtrShape& previous() const { return parent; }

  template <AllowGC allowGC>
  class Range {
   protected:
    friend class Shape;

    typename MaybeRooted<Shape*, allowGC>::RootType cursor;

   public:
    Range(JSContext* cx, Shape* shape) : cursor(cx, shape) {
      static_assert(allowGC == CanGC);
    }

    explicit Range(Shape* shape) : cursor((JSContext*)nullptr, shape) {
      static_assert(allowGC == NoGC);
    }

    bool empty() const { return !cursor || cursor->isEmptyShape(); }

    Shape& front() const {
      MOZ_ASSERT(!empty());
      return *cursor;
    }

    void popFront() {
      MOZ_ASSERT(!empty());
      cursor = cursor->parent;
    }
  };

  const JSClass* getObjectClass() const { return base()->clasp(); }

  static Shape* setObjectFlags(JSContext* cx, BaseShape::Flag flag,
                               TaggedProto proto, Shape* last);

  uint32_t getObjectFlags() const { return base()->getObjectFlags(); }
  bool hasAllObjectFlags(BaseShape::Flag flags) const {
    MOZ_ASSERT(flags);
    MOZ_ASSERT(!(flags & ~BaseShape::OBJECT_FLAG_MASK));
    return (base()->flags & flags) == flags;
  }

 protected:
  /* Get a shape identical to this one, without parent/children information. */
  inline Shape(const StackShape& other, uint32_t nfixed);

  /* Used by EmptyShape (see jsscopeinlines.h). */
  inline Shape(UnownedBaseShape* base, uint32_t nfixed);

  /* Copy constructor disabled, to avoid misuse of the above form. */
  Shape(const Shape& other) = delete;

  /* Allocate a new shape based on the given StackShape. */
  static inline Shape* new_(JSContext* cx, Handle<StackShape> other,
                            uint32_t nfixed);

  /*
   * Whether this shape has a valid slot value. This may be true even if
   * !isDataProperty() (see SlotInfo comment above), and may be false even if
   * isDataProperty() if the shape is being constructed and has not had a slot
   * assigned yet. After construction, isDataProperty() implies
   * !hasMissingSlot().
   */
  bool hasMissingSlot() const { return maybeSlot() == SHAPE_INVALID_SLOT; }

 public:
  bool inDictionary() const { return immutableFlags & IN_DICTIONARY; }

  inline GetterOp getter() const;
  bool hasDefaultGetter() const { return !getter(); }
  GetterOp getterOp() const {
    MOZ_ASSERT(!hasGetterValue());
    return getter();
  }
  inline JSObject* getterObject() const;
  bool hasGetterObject() const { return hasGetterValue() && getterObject(); }

  // Per ES5, decode null getterObj as the undefined value, which encodes as
  // null.
  Value getterValue() const {
    MOZ_ASSERT(hasGetterValue());
    if (JSObject* getterObj = getterObject()) {
      return ObjectValue(*getterObj);
    }
    return UndefinedValue();
  }

  Value getterOrUndefined() const {
    return hasGetterValue() ? getterValue() : UndefinedValue();
  }

  inline SetterOp setter() const;
  bool hasDefaultSetter() const { return !setter(); }
  SetterOp setterOp() const {
    MOZ_ASSERT(!hasSetterValue());
    return setter();
  }
  inline JSObject* setterObject() const;
  bool hasSetterObject() const { return hasSetterValue() && setterObject(); }

  // Per ES5, decode null setterObj as the undefined value, which encodes as
  // null.
  Value setterValue() const {
    MOZ_ASSERT(hasSetterValue());
    if (JSObject* setterObj = setterObject()) {
      return ObjectValue(*setterObj);
    }
    return UndefinedValue();
  }

  Value setterOrUndefined() const {
    return hasSetterValue() ? setterValue() : UndefinedValue();
  }

  void setOverwritten() { mutableFlags |= OVERWRITTEN; }
  bool hadOverwrite() const { return mutableFlags & OVERWRITTEN; }

  bool matches(const Shape* other) const {
    return propid_.get() == other->propid_.get() &&
           matchesParamsAfterId(other->base(), other->maybeSlot(), other->attrs,
                                other->getter(), other->setter());
  }

  inline bool matches(const StackShape& other) const;

  bool matchesParamsAfterId(BaseShape* base, uint32_t aslot, unsigned aattrs,
                            GetterOp rawGetter, SetterOp rawSetter) const {
    return base->unowned() == this->base()->unowned() && maybeSlot() == aslot &&
           attrs == aattrs && getter() == rawGetter && setter() == rawSetter;
  }

  BaseShape* base() const { return headerAndBase_.ptr(); }

  static bool isDataProperty(unsigned attrs, GetterOp getter, SetterOp setter) {
    return !(attrs & (JSPROP_GETTER | JSPROP_SETTER)) && !getter && !setter;
  }

  bool isDataProperty() const {
    MOZ_ASSERT(!isEmptyShape());
    return isDataProperty(attrs, getter(), setter());
  }
  uint32_t slot() const {
    MOZ_ASSERT(isDataProperty() && !hasMissingSlot());
    return maybeSlot();
  }
  uint32_t maybeSlot() const { return immutableFlags & SLOT_MASK; }

  bool isEmptyShape() const {
    MOZ_ASSERT_IF(JSID_IS_EMPTY(propid_), hasMissingSlot());
    return JSID_IS_EMPTY(propid_);
  }

  uint32_t slotSpan(const JSClass* clasp) const {
    MOZ_ASSERT(!inDictionary());
    // Proxy classes have reserved slots, but proxies manage their own slot
    // layout. This means all non-native object shapes have nfixed == 0 and
    // slotSpan == 0.
    uint32_t free = clasp->isProxy() ? 0 : JSSLOT_FREE(clasp);
    return hasMissingSlot() ? free : std::max(free, maybeSlot() + 1);
  }

  uint32_t slotSpan() const { return slotSpan(getObjectClass()); }

  void setSlot(uint32_t slot) {
    MOZ_ASSERT(slot <= SHAPE_INVALID_SLOT);
    immutableFlags = (immutableFlags & ~Shape::SLOT_MASK) | slot;
  }

  uint32_t numFixedSlots() const {
    return (immutableFlags & FIXED_SLOTS_MASK) >> FIXED_SLOTS_SHIFT;
  }

  void setNumFixedSlots(uint32_t nfixed) {
    MOZ_ASSERT(nfixed < FIXED_SLOTS_MAX);
    immutableFlags = immutableFlags & ~FIXED_SLOTS_MASK;
    immutableFlags = immutableFlags | (nfixed << FIXED_SLOTS_SHIFT);
  }

  uint32_t numLinearSearches() const {
    return mutableFlags & LINEAR_SEARCHES_MASK;
  }

  void incrementNumLinearSearches() {
    uint32_t count = numLinearSearches();
    MOZ_ASSERT(count < LINEAR_SEARCHES_MAX);
    mutableFlags = (mutableFlags & ~LINEAR_SEARCHES_MASK) | (count + 1);
  }

  const GCPtrId& propid() const {
    MOZ_ASSERT(!isEmptyShape());
    MOZ_ASSERT(!JSID_IS_VOID(propid_));
    return propid_;
  }
  const GCPtrId& propidRef() {
    MOZ_ASSERT(!JSID_IS_VOID(propid_));
    return propid_;
  }
  jsid propidRaw() const {
    // Return the actual jsid, not an internal reference.
    return propid();
  }

  uint8_t attributes() const { return attrs; }
  bool configurable() const { return (attrs & JSPROP_PERMANENT) == 0; }
  bool enumerable() const { return (attrs & JSPROP_ENUMERATE) != 0; }
  bool writable() const { return (attrs & JSPROP_READONLY) == 0; }
  bool hasGetterValue() const { return attrs & JSPROP_GETTER; }
  bool hasSetterValue() const { return attrs & JSPROP_SETTER; }

  bool isDataDescriptor() const {
    return (attrs & (JSPROP_SETTER | JSPROP_GETTER)) == 0;
  }
  bool isAccessorDescriptor() const {
    return (attrs & (JSPROP_SETTER | JSPROP_GETTER)) != 0;
  }

  uint32_t entryCount() {
    JS::AutoCheckCannotGC nogc;
    if (ShapeTable* table = maybeTable(nogc)) {
      return table->entryCount();
    }
    uint32_t count = 0;
    for (Shape::Range<NoGC> r(this); !r.empty(); r.popFront()) {
      ++count;
    }
    return count;
  }

 private:
  void setBase(BaseShape* base) {
    MOZ_ASSERT(base);
    headerAndBase_.setPtr(base);
  }

  bool isBigEnoughForAShapeTableSlow() {
    uint32_t count = 0;
    for (Shape::Range<NoGC> r(this); !r.empty(); r.popFront()) {
      ++count;
      if (count >= ShapeCachePtr::MIN_ENTRIES) {
        return true;
      }
    }
    return false;
  }
  void clearCachedBigEnoughForShapeTable() {
    mutableFlags &= ~(HAS_CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE |
                      CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE);
  }

 public:
  bool isBigEnoughForAShapeTable() {
    MOZ_ASSERT(!hasTable());

    // isBigEnoughForAShapeTableSlow is pretty inefficient so we only call
    // it once and cache the result.

    if (mutableFlags & HAS_CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE) {
      bool res = mutableFlags & CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE;
      MOZ_ASSERT(res == isBigEnoughForAShapeTableSlow());
      return res;
    }

    MOZ_ASSERT(!(mutableFlags & CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE));

    bool res = isBigEnoughForAShapeTableSlow();
    if (res) {
      mutableFlags |= CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE;
    }
    mutableFlags |= HAS_CACHED_BIG_ENOUGH_FOR_SHAPE_TABLE;
    return res;
  }

#ifdef DEBUG
  void dump(js::GenericPrinter& out) const;
  void dump() const;
  void dumpSubtree(int level, js::GenericPrinter& out) const;
#endif

  void sweep(JSFreeOp* fop);
  void finalize(JSFreeOp* fop);
  void removeChild(JSFreeOp* fop, Shape* child);

  static const JS::TraceKind TraceKind = JS::TraceKind::Shape;
  const gc::CellHeader& cellHeader() const { return headerAndBase_; }

  void traceChildren(JSTracer* trc);

  MOZ_ALWAYS_INLINE Shape* search(JSContext* cx, jsid id);
  MOZ_ALWAYS_INLINE Shape* searchLinear(jsid id);

  void fixupAfterMovingGC();
  void fixupGetterSetterForBarrier(JSTracer* trc);
  void updateBaseShapeAfterMovingGC();

  // For JIT usage.
  static constexpr size_t offsetOfBaseShape() {
    return offsetof(Shape, headerAndBase_) + HeaderWithBaseShape::offsetOfPtr();
  }

#ifdef DEBUG
  static inline size_t offsetOfImmutableFlags() {
    return offsetof(Shape, immutableFlags);
  }
  static inline uint32_t fixedSlotsMask() { return FIXED_SLOTS_MASK; }
#endif

 private:
  void fixupDictionaryShapeAfterMovingGC();
  void fixupShapeTreeAfterMovingGC();

  static void staticAsserts() {
    static_assert(offsetOfBaseShape() == offsetof(js::shadow::Shape, base));
    static_assert(offsetof(Shape, immutableFlags) ==
                  offsetof(js::shadow::Shape, immutableFlags));
    static_assert(FIXED_SLOTS_SHIFT == js::shadow::Shape::FIXED_SLOTS_SHIFT);
    static_assert(FIXED_SLOTS_MASK == js::shadow::Shape::FIXED_SLOTS_MASK);
  }
};

/* Fat Shape used for accessor properties. */
class AccessorShape : public Shape {
  friend class Shape;
  friend class NativeObject;

  union {
    GetterOp rawGetter;  /* getter hook for shape */
    JSObject* getterObj; /* user-defined callable "get" object or
                            null if shape->hasGetterValue() */
  };
  union {
    SetterOp rawSetter;  /* setter hook for shape */
    JSObject* setterObj; /* user-defined callable "set" object or
                            null if shape->hasSetterValue() */
  };

 public:
  /* Get a shape identical to this one, without parent/children information. */
  inline AccessorShape(const StackShape& other, uint32_t nfixed);
};

inline StackBaseShape::StackBaseShape(Shape* shape)
    : flags(shape->getObjectFlags()), clasp(shape->getObjectClass()) {}

class MOZ_RAII AutoRooterGetterSetter {
  class Inner {
   public:
    inline Inner(uint8_t attrs, GetterOp* pgetter_, SetterOp* psetter_);

    void trace(JSTracer* trc);

   private:
    uint8_t attrs;
    GetterOp* pgetter;
    SetterOp* psetter;
  };

 public:
  inline AutoRooterGetterSetter(JSContext* cx, uint8_t attrs, GetterOp* pgetter,
                                SetterOp* psetter
                                    MOZ_GUARD_OBJECT_NOTIFIER_PARAM);

 private:
  mozilla::Maybe<Rooted<Inner>> inner;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

struct EmptyShape : public js::Shape {
  EmptyShape(UnownedBaseShape* base, uint32_t nfixed)
      : js::Shape(base, nfixed) {}

  static Shape* new_(JSContext* cx, Handle<UnownedBaseShape*> base,
                     uint32_t nfixed);

  /*
   * Lookup an initial shape matching the given parameters, creating an empty
   * shape if none was found.
   */
  static Shape* getInitialShape(JSContext* cx, const JSClass* clasp,
                                TaggedProto proto, size_t nfixed,
                                uint32_t objectFlags = 0);
  static Shape* getInitialShape(JSContext* cx, const JSClass* clasp,
                                TaggedProto proto, gc::AllocKind kind,
                                uint32_t objectFlags = 0);

  /*
   * Reinsert an alternate initial shape, to be returned by future
   * getInitialShape calls, until the new shape becomes unreachable in a GC
   * and the table entry is purged.
   */
  static void insertInitialShape(JSContext* cx, HandleShape shape,
                                 HandleObject proto);

  /*
   * Some object subclasses are allocated with a built-in set of properties.
   * The first time such an object is created, these built-in properties must
   * be set manually, to compute an initial shape.  Afterward, that initial
   * shape can be reused for newly-created objects that use the subclass's
   * standard prototype.  This method should be used in a post-allocation
   * init method, to ensure that objects of such subclasses compute and cache
   * the initial shape, if it hasn't already been computed.
   */
  template <class ObjectSubclass>
  static inline bool ensureInitialCustomShape(JSContext* cx,
                                              Handle<ObjectSubclass*> obj);
};

/*
 * Entries for the per-zone initialShapes set indexing initial shapes for
 * objects in the zone and the associated types.
 */
struct InitialShapeEntry {
  /*
   * Initial shape to give to the object. This is an empty shape, except for
   * certain classes (e.g. String, RegExp) which may add certain baked-in
   * properties.
   */
  WeakHeapPtr<Shape*> shape;

  /*
   * Matching prototype for the entry. The shape of an object determines its
   * prototype, but the prototype cannot be determined from the shape itself.
   */
  WeakHeapPtr<TaggedProto> proto;

  /* State used to determine a match on an initial shape. */
  struct Lookup {
    const JSClass* clasp;
    TaggedProto proto;
    uint32_t nfixed;
    uint32_t baseFlags;

    Lookup(const JSClass* clasp, const TaggedProto& proto, uint32_t nfixed,
           uint32_t baseFlags)
        : clasp(clasp), proto(proto), nfixed(nfixed), baseFlags(baseFlags) {}
  };

  inline InitialShapeEntry();
  inline InitialShapeEntry(Shape* shape, const TaggedProto& proto);

  static HashNumber hash(const Lookup& lookup) {
    HashNumber hash = MovableCellHasher<TaggedProto>::hash(lookup.proto);
    return mozilla::AddToHash(
        hash, mozilla::HashGeneric(lookup.clasp, lookup.nfixed));
  }
  static inline bool match(const InitialShapeEntry& key, const Lookup& lookup) {
    const Shape* shape = key.shape.unbarrieredGet();
    return lookup.clasp == shape->getObjectClass() &&
           lookup.nfixed == shape->numFixedSlots() &&
           lookup.baseFlags == shape->getObjectFlags() &&
           key.proto.unbarrieredGet() == lookup.proto;
  }
  static void rekey(InitialShapeEntry& k, const InitialShapeEntry& newKey) {
    k = newKey;
  }

  bool needsSweep() {
    Shape* ushape = shape.unbarrieredGet();
    TaggedProto uproto = proto.unbarrieredGet();
    JSObject* protoObj = uproto.raw();
    return (
        gc::IsAboutToBeFinalizedUnbarriered(&ushape) ||
        (uproto.isObject() && gc::IsAboutToBeFinalizedUnbarriered(&protoObj)));
  }

  bool operator==(const InitialShapeEntry& other) const {
    return shape == other.shape && proto == other.proto;
  }
};

using InitialShapeSet = JS::WeakCache<
    JS::GCHashSet<InitialShapeEntry, InitialShapeEntry, SystemAllocPolicy>>;

struct StackShape {
  /* For performance, StackShape only roots when absolutely necessary. */
  UnownedBaseShape* base;
  jsid propid;
  GetterOp rawGetter;
  SetterOp rawSetter;
  uint32_t immutableFlags;
  uint8_t attrs;
  uint8_t mutableFlags;

  explicit StackShape(UnownedBaseShape* base, jsid propid, uint32_t slot,
                      unsigned attrs)
      : base(base),
        propid(propid),
        rawGetter(nullptr),
        rawSetter(nullptr),
        immutableFlags(slot),
        attrs(uint8_t(attrs)),
        mutableFlags(0) {
    MOZ_ASSERT(base);
    MOZ_ASSERT(!JSID_IS_VOID(propid));
    MOZ_ASSERT(slot <= SHAPE_INVALID_SLOT);
  }

  explicit StackShape(Shape* shape)
      : base(shape->base()->unowned()),
        propid(shape->propidRef()),
        rawGetter(shape->getter()),
        rawSetter(shape->setter()),
        immutableFlags(shape->immutableFlags),
        attrs(shape->attrs),
        mutableFlags(shape->mutableFlags) {}

  void updateGetterSetter(GetterOp rawGetter, SetterOp rawSetter) {
    if (rawGetter || rawSetter || (attrs & (JSPROP_GETTER | JSPROP_SETTER))) {
      immutableFlags |= Shape::ACCESSOR_SHAPE;
    } else {
      immutableFlags &= ~Shape::ACCESSOR_SHAPE;
    }

    this->rawGetter = rawGetter;
    this->rawSetter = rawSetter;
  }

  bool isDataProperty() const {
    MOZ_ASSERT(!JSID_IS_EMPTY(propid));
    return Shape::isDataProperty(attrs, rawGetter, rawSetter);
  }
  bool hasMissingSlot() const { return maybeSlot() == SHAPE_INVALID_SLOT; }

  uint32_t slot() const {
    MOZ_ASSERT(isDataProperty() && !hasMissingSlot());
    return maybeSlot();
  }
  uint32_t maybeSlot() const { return immutableFlags & Shape::SLOT_MASK; }

  void setSlot(uint32_t slot) {
    MOZ_ASSERT(slot <= SHAPE_INVALID_SLOT);
    immutableFlags = (immutableFlags & ~Shape::SLOT_MASK) | slot;
  }

  bool isAccessorShape() const {
    return immutableFlags & Shape::ACCESSOR_SHAPE;
  }

  HashNumber hash() const {
    HashNumber hash = HashId(propid);
    return mozilla::AddToHash(
        hash,
        mozilla::HashGeneric(base, attrs, maybeSlot(), rawGetter, rawSetter));
  }

  // StructGCPolicy implementation.
  void trace(JSTracer* trc);
};

template <typename Wrapper>
class WrappedPtrOperations<StackShape, Wrapper> {
  const StackShape& ss() const {
    return static_cast<const Wrapper*>(this)->get();
  }

 public:
  bool isDataProperty() const { return ss().isDataProperty(); }
  bool hasMissingSlot() const { return ss().hasMissingSlot(); }
  uint32_t slot() const { return ss().slot(); }
  uint32_t maybeSlot() const { return ss().maybeSlot(); }
  uint32_t slotSpan() const { return ss().slotSpan(); }
  bool isAccessorShape() const { return ss().isAccessorShape(); }
  uint8_t attrs() const { return ss().attrs; }
};

template <typename Wrapper>
class MutableWrappedPtrOperations<StackShape, Wrapper>
    : public WrappedPtrOperations<StackShape, Wrapper> {
  StackShape& ss() { return static_cast<Wrapper*>(this)->get(); }

 public:
  void updateGetterSetter(GetterOp rawGetter, SetterOp rawSetter) {
    ss().updateGetterSetter(rawGetter, rawSetter);
  }
  void setSlot(uint32_t slot) { ss().setSlot(slot); }
  void setBase(UnownedBaseShape* base) { ss().base = base; }
  void setAttrs(uint8_t attrs) { ss().attrs = attrs; }
};

inline Shape::Shape(const StackShape& other, uint32_t nfixed)
    : headerAndBase_(other.base),
      propid_(other.propid),
      immutableFlags(other.immutableFlags),
      attrs(other.attrs),
      mutableFlags(other.mutableFlags),
      parent(nullptr) {
  setNumFixedSlots(nfixed);

#ifdef DEBUG
  gc::AllocKind allocKind = getAllocKind();
  MOZ_ASSERT_IF(other.isAccessorShape(),
                allocKind == gc::AllocKind::ACCESSOR_SHAPE);
  MOZ_ASSERT_IF(allocKind == gc::AllocKind::SHAPE, !other.isAccessorShape());
#endif

  MOZ_ASSERT_IF(!isEmptyShape(), AtomIsMarked(zone(), propid()));

  children.setNone();
}

// This class is used to update any shapes in a zone that have nursery objects
// as getters/setters.  It updates the pointers and the shapes' entries in the
// parents' ShapeSet tables.
class NurseryShapesRef : public gc::BufferableRef {
  Zone* zone_;

 public:
  explicit NurseryShapesRef(Zone* zone) : zone_(zone) {}
  void trace(JSTracer* trc) override;
};

inline Shape::Shape(UnownedBaseShape* base, uint32_t nfixed)
    : headerAndBase_(base),
      propid_(JSID_EMPTY),
      immutableFlags(SHAPE_INVALID_SLOT | (nfixed << FIXED_SLOTS_SHIFT)),
      attrs(0),
      mutableFlags(0),
      parent(nullptr) {
  MOZ_ASSERT(base);
  children.setNone();
}

inline GetterOp Shape::getter() const {
  return isAccessorShape() ? asAccessorShape().rawGetter : nullptr;
}

inline SetterOp Shape::setter() const {
  return isAccessorShape() ? asAccessorShape().rawSetter : nullptr;
}

inline JSObject* Shape::getterObject() const {
  MOZ_ASSERT(hasGetterValue());
  return asAccessorShape().getterObj;
}

inline JSObject* Shape::setterObject() const {
  MOZ_ASSERT(hasSetterValue());
  return asAccessorShape().setterObj;
}

inline Shape* Shape::searchLinear(jsid id) {
  for (Shape* shape = this; shape;) {
    if (shape->propidRef() == id) {
      return shape;
    }
    shape = shape->parent;
  }

  return nullptr;
}

inline bool Shape::matches(const StackShape& other) const {
  return propid_.get() == other.propid &&
         matchesParamsAfterId(other.base, other.maybeSlot(), other.attrs,
                              other.rawGetter, other.rawSetter);
}

template <MaybeAdding Adding>
MOZ_ALWAYS_INLINE bool ShapeCachePtr::search(jsid id, Shape* start,
                                             Shape** foundShape) {
  bool found = false;
  if (isIC()) {
    ShapeIC* ic = getICPointer();
    found = ic->search(id, foundShape);
  } else if (isTable()) {
    ShapeTable* table = getTablePointer();
    ShapeTable::Entry& entry = table->searchUnchecked<Adding>(id);
    *foundShape = entry.shape();
    found = true;
  }
  return found;
}

MOZ_ALWAYS_INLINE bool ShapeIC::search(jsid id, Shape** foundShape) {
  // This loop needs to be as fast as possible, so use a direct pointer
  // to the array instead of going through the UniquePtr methods.
  Entry* entriesArray = entries_.get();
  for (uint8_t i = 0; i < nextFreeIndex_; i++) {
    Entry& entry = entriesArray[i];
    if (entry.id_ == id) {
      *foundShape = entry.shape_;
      return true;
    }
  }

  return false;
}

Shape* ReshapeForAllocKind(JSContext* cx, Shape* shape, TaggedProto proto,
                           gc::AllocKind allocKind);

}  // namespace js

// JS::ubi::Nodes can point to Shapes and BaseShapes; they're js::gc::Cell
// instances that occupy a compartment.
namespace JS {
namespace ubi {

template <>
class Concrete<js::Shape> : TracerConcrete<js::Shape> {
 protected:
  explicit Concrete(js::Shape* ptr) : TracerConcrete<js::Shape>(ptr) {}

 public:
  static void construct(void* storage, js::Shape* ptr) {
    new (storage) Concrete(ptr);
  }

  Size size(mozilla::MallocSizeOf mallocSizeOf) const override;

  const char16_t* typeName() const override { return concreteTypeName; }
  static const char16_t concreteTypeName[];
};

template <>
class Concrete<js::BaseShape> : TracerConcrete<js::BaseShape> {
 protected:
  explicit Concrete(js::BaseShape* ptr) : TracerConcrete<js::BaseShape>(ptr) {}

 public:
  static void construct(void* storage, js::BaseShape* ptr) {
    new (storage) Concrete(ptr);
  }

  Size size(mozilla::MallocSizeOf mallocSizeOf) const override;

  const char16_t* typeName() const override { return concreteTypeName; }
  static const char16_t concreteTypeName[];
};

}  // namespace ubi
}  // namespace JS

#endif /* vm_Shape_h */
