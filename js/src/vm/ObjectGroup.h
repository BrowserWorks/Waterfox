/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef vm_ObjectGroup_h
#define vm_ObjectGroup_h

#include "jsfriendapi.h"

#include "ds/IdValuePair.h"
#include "gc/Barrier.h"
#include "gc/GCProbes.h"
#include "js/CharacterEncoding.h"
#include "js/GCHashTable.h"
#include "js/TypeDecls.h"
#include "vm/TaggedProto.h"
#include "vm/TypeSet.h"

namespace js {

class TypeDescr;

class PreliminaryObjectArrayWithTemplate;
class TypeNewScript;
class AutoClearTypeInferenceStateOnOOM;
class AutoSweepObjectGroup;
class CompilerConstraintList;
class ObjectGroupRealm;
class PlainObject;

namespace gc {
void MergeRealms(JS::Realm* source, JS::Realm* target);
}  // namespace gc

/*
 * The NewObjectKind allows an allocation site to specify the type properties
 * and lifetime requirements that must be fixed at allocation time.
 */
enum NewObjectKind {
  /* This is the default. Most objects are generic. */
  GenericObject,

  /*
   * Singleton objects are treated specially by the type system. This flag
   * ensures that the new object is automatically set up correctly as a
   * singleton and is allocated in the tenured heap.
   */
  SingletonObject,

  /*
   * Objects which will not benefit from being allocated in the nursery
   * (e.g. because they are known to have a long lifetime) may be allocated
   * with this kind to place them immediately into the tenured generation.
   */
  TenuredObject
};

/*
 * [SMDOC] Type-Inference lazy ObjectGroup
 *
 * Object groups which represent at most one JS object are constructed lazily.
 * These include groups for native functions, standard classes, scripted
 * functions defined at the top level of global/eval scripts, objects which
 * dynamically become the prototype of some other object, and in some other
 * cases. Typical web workloads often create many windows (and many copies of
 * standard natives) and many scripts, with comparatively few non-singleton
 * groups.
 *
 * We can recover the type information for the object from examining it,
 * so don't normally track the possible types of its properties as it is
 * updated. Property type sets for the object are only constructed when an
 * analyzed script attaches constraints to it: the script is querying that
 * property off the object or another which delegates to it, and the analysis
 * information is sensitive to changes in the property's type. Future changes
 * to the property (whether those uncovered by analysis or those occurring
 * in the VM) will treat these properties like those of any other object group.
 */

/* Type information about an object accessed by a script. */
class ObjectGroup : public gc::TenuredCell {
 public:
  class Property;

 private:
  /* Class shared by objects in this group stored in header. */
  using HeaderWithJSClass = gc::CellHeaderWithNonGCPointer<const JSClass>;
  HeaderWithJSClass headerAndClasp_;

  /* Prototype shared by objects in this group. */
  GCPtr<TaggedProto> proto_;  // set by constructor

  /* Realm shared by objects in this group. */
  JS::Realm* realm_;  // set by constructor

  /* Flags for this group. */
  ObjectGroupFlags flags_;  // set by constructor

  // If non-null, holds additional information about this object, whose
  // format is indicated by the object's addendum kind.
  void* addendum_ = nullptr;

  /*
   * [SMDOC] Type-Inference object properties
   *
   * Properties of this object.
   *
   * The type sets in the properties of a group describe the possible values
   * that can be read out of that property in actual JS objects. In native
   * objects, property types account for plain data properties (those with a
   * slot and no getter or setter hook) and dense elements. In typed objects,
   * property types account for object and value properties and elements in the
   * object.
   *
   * For accesses on these properties, the correspondence is as follows:
   *
   * 1. If the group has unknownProperties(), the possible properties and
   *    value types for associated JSObjects are unknown.
   *
   * 2. Otherwise, for any |obj| in |group|, and any |id| which is a property
   *    in |obj|, before obj->getProperty(id) the property in |group| for
   *    |id| must reflect the result of the getProperty.
   *
   * There are several exceptions to this:
   *
   * 1. For properties of global JS objects which are undefined at the point
   *    where the property was (lazily) generated, the property type set will
   *    remain empty, and the 'undefined' type will only be added after a
   *    subsequent assignment or deletion. After these properties have been
   *    assigned a defined value, the only way they can become undefined
   *    again is after such an assign or deletion.
   *
   * 2. Array lengths are special cased by the compiler and VM and are not
   *    reflected in property types.
   *
   * 3. In typed objects, the initial values of properties (null pointers and
   *    undefined values) are not reflected in the property types. These values
   *    are always possible when reading the property.
   *
   * We establish these by using write barriers on calls to setProperty and
   * defineProperty which are on native properties, and on any jitcode which
   * might update the property with a new type.
   */
  Property** propertySet = nullptr;

  // END OF PROPERTIES

 private:
  static inline uint32_t offsetOfClasp() {
    return offsetof(ObjectGroup, headerAndClasp_) +
           HeaderWithJSClass::offsetOfPtr();
  }

  static inline uint32_t offsetOfProto() {
    return offsetof(ObjectGroup, proto_);
  }

  static inline uint32_t offsetOfRealm() {
    return offsetof(ObjectGroup, realm_);
  }

  static inline uint32_t offsetOfFlags() {
    return offsetof(ObjectGroup, flags_);
  }

  static inline uint32_t offsetOfAddendum() {
    return offsetof(ObjectGroup, addendum_);
  }

  friend class gc::GCRuntime;

  // See JSObject::offsetOfGroup() comment.
  friend class js::jit::MacroAssembler;

 public:
  const JSClass* clasp() const { return headerAndClasp_.ptr(); }

  bool hasDynamicPrototype() const { return proto_.isDynamic(); }

  const GCPtr<TaggedProto>& proto() const { return proto_; }

  GCPtr<TaggedProto>& proto() { return proto_; }

  void setProto(TaggedProto proto);
  void setProtoUnchecked(TaggedProto proto);

  bool hasUncacheableProto() const {
    // We allow singletons to mutate their prototype after the group has
    // been created. If true, the JIT must re-check prototype even if group
    // has been seen before.
    MOZ_ASSERT(!hasDynamicPrototype());
    return singleton();
  }

  bool singleton() const {
    return flagsDontCheckGeneration() & OBJECT_FLAG_SINGLETON;
  }

  bool lazy() const {
    bool res = flagsDontCheckGeneration() & OBJECT_FLAG_LAZY_SINGLETON;
    MOZ_ASSERT_IF(res, singleton());
    return res;
  }

  JS::Compartment* compartment() const {
    return JS::GetCompartmentForRealm(realm_);
  }
  JS::Compartment* maybeCompartment() const { return compartment(); }
  JS::Realm* realm() const { return realm_; }

 public:
  // Kinds of addendums which can be attached to ObjectGroups.
  enum AddendumKind {
    Addendum_None,

    // When used by interpreted function, the addendum stores the
    // canonical JSFunction object.
    Addendum_InterpretedFunction,

    // When used by the 'new' group when constructing an interpreted
    // function, the addendum stores a TypeNewScript.
    Addendum_NewScript,

    // For some plain objects, the addendum stores a
    // PreliminaryObjectArrayWithTemplate.
    Addendum_PreliminaryObjects,

    // When used by typed objects, the addendum stores a TypeDescr.
    Addendum_TypeDescr
  };

 private:
  void setAddendum(AddendumKind kind, void* addendum, bool isSweeping = false);

  AddendumKind addendumKind() const {
    return (AddendumKind)((flags_ & OBJECT_FLAG_ADDENDUM_MASK) >>
                          OBJECT_FLAG_ADDENDUM_SHIFT);
  }

  TypeNewScript* newScriptDontCheckGeneration() const {
    if (addendumKind() == Addendum_NewScript) {
      return reinterpret_cast<TypeNewScript*>(addendum_);
    }
    return nullptr;
  }

  void detachNewScript(bool isSweeping, ObjectGroup* replacement);

  ObjectGroupFlags flagsDontCheckGeneration() const { return flags_; }

 public:
  inline ObjectGroupFlags flags(const AutoSweepObjectGroup&);
  inline void addFlags(const AutoSweepObjectGroup&, ObjectGroupFlags flags);
  inline void clearFlags(const AutoSweepObjectGroup&, ObjectGroupFlags flags);
  inline TypeNewScript* newScript(const AutoSweepObjectGroup& sweep);

  void setNewScript(TypeNewScript* newScript) {
    MOZ_ASSERT(newScript);
    setAddendum(Addendum_NewScript, newScript);
  }
  void detachNewScript() { setAddendum(Addendum_None, nullptr); }

  inline PreliminaryObjectArrayWithTemplate* maybePreliminaryObjects(
      const AutoSweepObjectGroup& sweep);

  PreliminaryObjectArrayWithTemplate*
  maybePreliminaryObjectsDontCheckGeneration() {
    if (addendumKind() == Addendum_PreliminaryObjects) {
      return reinterpret_cast<PreliminaryObjectArrayWithTemplate*>(addendum_);
    }
    return nullptr;
  }

  void setPreliminaryObjects(
      PreliminaryObjectArrayWithTemplate* preliminaryObjects) {
    setAddendum(Addendum_PreliminaryObjects, preliminaryObjects);
  }

  void detachPreliminaryObjects() {
    MOZ_ASSERT(maybePreliminaryObjectsDontCheckGeneration());
    setAddendum(Addendum_None, nullptr);
  }

  inline bool hasUnanalyzedPreliminaryObjects();

  TypeDescr* maybeTypeDescr() {
    // Note: there is no need to sweep when accessing the type descriptor
    // of an object, as it is strongly held and immutable.
    if (addendumKind() == Addendum_TypeDescr) {
      return &typeDescr();
    }
    return nullptr;
  }

  TypeDescr& typeDescr() {
    MOZ_ASSERT(addendumKind() == Addendum_TypeDescr);
    return *reinterpret_cast<TypeDescr*>(addendum_);
  }

  void setTypeDescr(TypeDescr* descr) {
    setAddendum(Addendum_TypeDescr, descr);
  }

  JSFunction* maybeInterpretedFunction() {
    // Note: as with type descriptors, there is no need to sweep when
    // accessing the interpreted function associated with an object.
    if (addendumKind() == Addendum_InterpretedFunction) {
      return reinterpret_cast<JSFunction*>(addendum_);
    }
    return nullptr;
  }

  void setInterpretedFunction(JSFunction* fun) {
    MOZ_ASSERT(!gc::IsInsideNursery(reinterpret_cast<gc::Cell*>(fun)));
    setAddendum(Addendum_InterpretedFunction, fun);
  }

  class Property {
   public:
    // Identifier for this property, JSID_VOID for the aggregate integer
    // index property, or JSID_EMPTY for properties holding constraints
    // listening to changes in the group's state.
    const GCPtrId id;

    // Possible own types for this property.
    HeapTypeSet types;

    explicit Property(jsid id) : id(id) {}

    Property(const Property& o) : id(o.id.get()), types(o.types) {}

    static uint32_t keyBits(jsid id) { return uint32_t(JSID_BITS(id)); }
    static jsid getKey(Property* p) { return p->id; }
  };

 public:
  inline ObjectGroup(const JSClass* clasp, TaggedProto proto, JS::Realm* realm,
                     ObjectGroupFlags initialFlags);

  inline bool hasAnyFlags(const AutoSweepObjectGroup& sweep,
                          ObjectGroupFlags flags);
  inline bool hasAllFlags(const AutoSweepObjectGroup& sweep,
                          ObjectGroupFlags flags);

  bool hasAnyFlagsDontCheckGeneration(ObjectGroupFlags flags) {
    MOZ_ASSERT((flags & OBJECT_FLAG_DYNAMIC_MASK) == flags);
    return !!(this->flagsDontCheckGeneration() & flags);
  }
  bool hasAllFlagsDontCheckGeneration(ObjectGroupFlags flags) {
    MOZ_ASSERT((flags & OBJECT_FLAG_DYNAMIC_MASK) == flags);
    return (this->flagsDontCheckGeneration() & flags) == flags;
  }

  inline bool unknownProperties(const AutoSweepObjectGroup& sweep);

  bool unknownPropertiesDontCheckGeneration() {
    MOZ_ASSERT_IF(flagsDontCheckGeneration() & OBJECT_FLAG_UNKNOWN_PROPERTIES,
                  hasAllFlagsDontCheckGeneration(OBJECT_FLAG_DYNAMIC_MASK));
    return !!(flagsDontCheckGeneration() & OBJECT_FLAG_UNKNOWN_PROPERTIES);
  }

  inline bool shouldPreTenure(const AutoSweepObjectGroup& sweep);
  inline bool shouldPreTenureDontCheckGeneration();

  gc::InitialHeap initialHeap(CompilerConstraintList* constraints);

  inline bool canPreTenure(const AutoSweepObjectGroup& sweep);
  inline bool fromAllocationSite(const AutoSweepObjectGroup& sweep);
  inline void setShouldPreTenure(const AutoSweepObjectGroup& sweep,
                                 JSContext* cx);

  /*
   * Get or create a property of this object. Only call this for properties
   * which a script accesses explicitly.
   */
  inline HeapTypeSet* getProperty(const AutoSweepObjectGroup& sweep,
                                  JSContext* cx, JSObject* obj, jsid id);

  /* Get a property only if it already exists. */
  MOZ_ALWAYS_INLINE HeapTypeSet* maybeGetProperty(
      const AutoSweepObjectGroup& sweep, jsid id);
  MOZ_ALWAYS_INLINE HeapTypeSet* maybeGetPropertyDontCheckGeneration(jsid id);

  /*
   * Iterate through the group's properties. getPropertyCount overapproximates
   * in the hash case (see SET_ARRAY_SIZE in TypeInference-inl.h), and
   * getProperty may return nullptr.
   */
  inline unsigned getPropertyCount(const AutoSweepObjectGroup& sweep);
  inline Property* getProperty(const AutoSweepObjectGroup& sweep, unsigned i);

  /* Helpers */

  void updateNewPropertyTypes(const AutoSweepObjectGroup& sweep, JSContext* cx,
                              JSObject* obj, jsid id, HeapTypeSet* types);
  void addDefiniteProperties(JSContext* cx, Shape* shape);
  void markPropertyNonData(JSContext* cx, JSObject* obj, jsid id);
  void markPropertyNonWritable(JSContext* cx, JSObject* obj, jsid id);
  void markStateChange(const AutoSweepObjectGroup& sweep, JSContext* cx);
  void setFlags(const AutoSweepObjectGroup& sweep, JSContext* cx,
                ObjectGroupFlags flags);
  void markUnknown(const AutoSweepObjectGroup& sweep, JSContext* cx);
  void maybeClearNewScriptOnOOM();
  void clearNewScript(JSContext* cx, ObjectGroup* replacement = nullptr);

  void print(const AutoSweepObjectGroup& sweep);

  inline void clearProperties(const AutoSweepObjectGroup& sweep);
  void traceChildren(JSTracer* trc);

  inline bool needsSweep();
  void sweep(const AutoSweepObjectGroup& sweep);

 private:
  uint32_t generation() {
    return (flags_ & OBJECT_FLAG_GENERATION_MASK) >>
           OBJECT_FLAG_GENERATION_SHIFT;
  }

 public:
  void setGeneration(uint32_t generation) {
    MOZ_ASSERT(generation <=
               (OBJECT_FLAG_GENERATION_MASK >> OBJECT_FLAG_GENERATION_SHIFT));
    flags_ &= ~OBJECT_FLAG_GENERATION_MASK;
    flags_ |= generation << OBJECT_FLAG_GENERATION_SHIFT;
  }

  size_t sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const;

  void finalize(JSFreeOp* fop);

  static const JS::TraceKind TraceKind = JS::TraceKind::ObjectGroup;
  const gc::CellHeader& cellHeader() const { return headerAndClasp_; }

 public:
  const ObjectGroupFlags* addressOfFlags() const { return &flags_; }

  inline uint32_t basePropertyCount(const AutoSweepObjectGroup& sweep);
  inline uint32_t basePropertyCountDontCheckGeneration();

 private:
  inline void setBasePropertyCount(const AutoSweepObjectGroup& sweep,
                                   uint32_t count);

  static void staticAsserts() {
    static_assert(offsetof(ObjectGroup, proto_) ==
                  offsetof(js::shadow::ObjectGroup, proto));
  }

 public:
  // Whether to make a deep cloned singleton when cloning fun.
  static bool useSingletonForClone(JSFunction* fun);

  // Whether to make a singleton when calling 'new' at script/pc.
  static bool useSingletonForNewObject(JSContext* cx, JSScript* script,
                                       jsbytecode* pc);

  // Whether to make a singleton object at an allocation site.
  static bool useSingletonForAllocationSite(JSScript* script, jsbytecode* pc,
                                            JSProtoKey key);

 public:
  // Static accessors for ObjectGroupRealm NewTable.

  static ObjectGroup* defaultNewGroup(JSContext* cx, const JSClass* clasp,
                                      TaggedProto proto,
                                      JSObject* associated = nullptr);

  // For use in creating a singleton group without needing to replace an
  // existing group.
  static ObjectGroup* lazySingletonGroup(JSContext* cx, ObjectGroupRealm& realm,
                                         JS::Realm* objectRealm,
                                         const JSClass* clasp,
                                         TaggedProto proto);

  // For use in replacing an already-existing group with a singleton group.
  static inline ObjectGroup* lazySingletonGroup(JSContext* cx,
                                                ObjectGroup* oldGroup,
                                                const JSClass* clasp,
                                                TaggedProto proto);

  static void setDefaultNewGroupUnknown(JSContext* cx, ObjectGroupRealm& realm,
                                        const JSClass* clasp,
                                        JS::HandleObject obj);

  // Static accessors for ObjectGroupRealm ArrayObjectTable and
  // PlainObjectTable.

  enum class NewArrayKind {
    Normal,       // Specialize array group based on its element type.
    CopyOnWrite,  // Make an array with copy-on-write elements.
    UnknownIndex  // Make an array with an unknown element type.
  };

  // Create an ArrayObject with the specified elements and a group specialized
  // for the elements.
  static ArrayObject* newArrayObject(
      JSContext* cx, const Value* vp, size_t length, NewObjectKind newKind,
      NewArrayKind arrayKind = NewArrayKind::Normal);

  // Create a PlainObject with the specified properties and a group specialized
  // for those properties.
  static JSObject* newPlainObject(JSContext* cx, IdValuePair* properties,
                                  size_t nproperties, NewObjectKind newKind);

  // Static accessors for ObjectGroupRealm AllocationSiteTable.

  // Get a non-singleton group to use for objects created at the specified
  // allocation site.
  static ObjectGroup* allocationSiteGroup(JSContext* cx, JSScript* script,
                                          jsbytecode* pc, JSProtoKey key,
                                          HandleObject proto = nullptr);

  // Get a non-singleton group to use for objects created in a JSNative call.
  static ObjectGroup* callingAllocationSiteGroup(JSContext* cx, JSProtoKey key,
                                                 HandleObject proto = nullptr);

  // Set the group or singleton-ness of an object created for an allocation
  // site.
  static bool setAllocationSiteObjectGroup(JSContext* cx, HandleScript script,
                                           jsbytecode* pc, HandleObject obj,
                                           bool singleton);

  static ArrayObject* getOrFixupCopyOnWriteObject(JSContext* cx,
                                                  HandleScript script,
                                                  jsbytecode* pc);
  static ArrayObject* getCopyOnWriteObject(JSScript* script, jsbytecode* pc);

  // Returns false if not found.
  static bool findAllocationSite(JSContext* cx, const ObjectGroup* group,
                                 JSScript** script, uint32_t* offset);

 private:
  static ObjectGroup* defaultNewGroup(JSContext* cx, JSProtoKey key);
};

// Structure used to manage the groups in a realm.
class ObjectGroupRealm {
 private:
  class NewTable;

  struct ArrayObjectKey;
  using ArrayObjectTable =
      js::GCRekeyableHashMap<ArrayObjectKey, WeakHeapPtrObjectGroup,
                             ArrayObjectKey, SystemAllocPolicy>;

  struct PlainObjectKey;
  struct PlainObjectEntry;
  struct PlainObjectTableSweepPolicy {
    static bool traceWeak(JSTracer* trc, PlainObjectKey* key,
                          PlainObjectEntry* entry);
  };
  using PlainObjectTable =
      JS::GCHashMap<PlainObjectKey, PlainObjectEntry, PlainObjectKey,
                    SystemAllocPolicy, PlainObjectTableSweepPolicy>;

  class AllocationSiteTable;

 private:
  // Set of default 'new' or lazy groups in the realm.
  NewTable* defaultNewTable = nullptr;
  NewTable* lazyTable = nullptr;

  // This cache is purged on GC.
  class DefaultNewGroupCache {
    ObjectGroup* group_;
    JSObject* associated_;

   public:
    DefaultNewGroupCache() : associated_(nullptr) { purge(); }

    void purge() { group_ = nullptr; }
    void put(ObjectGroup* group, JSObject* associated) {
      group_ = group;
      associated_ = associated;
    }

    MOZ_ALWAYS_INLINE ObjectGroup* lookup(const JSClass* clasp,
                                          TaggedProto proto,
                                          JSObject* associated);
  } defaultNewGroupCache = {};

  // Tables for managing groups common to the contents of large script
  // singleton objects and JSON objects. These are vanilla ArrayObjects and
  // PlainObjects, so we distinguish the groups of different ones by looking
  // at the types of their properties.
  //
  // All singleton/JSON arrays which have the same prototype, are homogenous
  // and of the same element type will share a group. All singleton/JSON
  // objects which have the same shape and property types will also share a
  // group. We don't try to collate arrays or objects with type mismatches.
  ArrayObjectTable* arrayObjectTable = nullptr;
  PlainObjectTable* plainObjectTable = nullptr;

  // Table for referencing types of objects keyed to an allocation site.
  AllocationSiteTable* allocationSiteTable = nullptr;

  // A single per-realm ObjectGroup for all calls to StringSplitString.
  // StringSplitString is always called from self-hosted code, and conceptually
  // the return object for a string.split(string) operation should have a
  // unified type.  Having a global group for this also allows us to remove
  // the hash-table lookup that would be required if we allocated this group
  // on the basis of call-site pc.
  WeakHeapPtrObjectGroup stringSplitStringGroup = {};

  // END OF PROPERTIES

 private:
  friend class ObjectGroup;

  struct AllocationSiteKey;
  friend struct MovableCellHasher<AllocationSiteKey>;

 public:
  struct NewEntry;

  ObjectGroupRealm() = default;
  ~ObjectGroupRealm();

  ObjectGroupRealm(ObjectGroupRealm&) = delete;
  void operator=(ObjectGroupRealm&) = delete;

  static ObjectGroupRealm& get(const ObjectGroup* group);
  static ObjectGroupRealm& getForNewObject(JSContext* cx);

  void removeDefaultNewGroup(const JSClass* clasp, TaggedProto proto,
                             JSObject* associated);
  void replaceDefaultNewGroup(const JSClass* clasp, TaggedProto proto,
                              JSObject* associated, ObjectGroup* group);

  static ObjectGroup* makeGroup(JSContext* cx, JS::Realm* realm,
                                const JSClass* clasp, Handle<TaggedProto> proto,
                                ObjectGroupFlags initialFlags = 0);

  static ObjectGroup* getStringSplitStringGroup(JSContext* cx);

  void addSizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf,
                              size_t* allocationSiteTables,
                              size_t* arrayGroupTables,
                              size_t* plainObjectGroupTables,
                              size_t* realmTables);

  void clearTables();

  void traceWeak(JSTracer* trc);

  void purge() { defaultNewGroupCache.purge(); }

#ifdef JSGC_HASH_TABLE_CHECKS
  void checkTablesAfterMovingGC() {
    checkNewTableAfterMovingGC(defaultNewTable);
    checkNewTableAfterMovingGC(lazyTable);
  }
#endif

  void fixupTablesAfterMovingGC() {
    fixupNewTableAfterMovingGC(defaultNewTable);
    fixupNewTableAfterMovingGC(lazyTable);
  }

 private:
#ifdef JSGC_HASH_TABLE_CHECKS
  void checkNewTableAfterMovingGC(NewTable* table);
#endif

  void fixupNewTableAfterMovingGC(NewTable* table);
};

PlainObject* NewPlainObjectWithProperties(JSContext* cx,
                                          IdValuePair* properties,
                                          size_t nproperties,
                                          NewObjectKind newKind);

bool CombineArrayElementTypes(JSContext* cx, JSObject* newObj,
                              const Value* compare, size_t ncompare);

bool CombinePlainObjectPropertyTypes(JSContext* cx, JSObject* newObj,
                                     const Value* compare, size_t ncompare);

}  // namespace js

#endif /* vm_ObjectGroup_h */
